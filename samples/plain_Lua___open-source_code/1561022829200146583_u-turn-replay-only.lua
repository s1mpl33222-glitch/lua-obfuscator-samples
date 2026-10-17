local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function findPath(fullName)
	local current = game
	for part in string.gmatch(fullName, "[^%.]+") do
		if part == "game" then
			continue
		elseif part == "ReplicatedStorage" then
			current = ReplicatedStorage
		else
			current = current and current:FindFirstChild(part)
		end
	end
	return current
end

local function parentPathAndName(fullName)
	local lastDot = nil
	for index = 1, #fullName do
		if fullName:sub(index, index) == "." then
			lastDot = index
		end
	end
	if not lastDot then return nil, fullName end
	return fullName:sub(1, lastDot - 1), fullName:sub(lastDot + 1)
end

local function instancePosition(instance)
	local ok, position = pcall(function()
		if instance:IsA("PVInstance") then
			return instance:GetPivot().Position
		elseif instance:IsA("BasePart") then
			return instance.Position
		end
	end)
	if ok then return position end
	return nil
end

local function findInstance(fullName, className, position)
	local parentPath, childName = parentPathAndName(fullName)
	local parent = parentPath and findPath(parentPath)

	if parent and position then
		local best, bestDistance = nil, math.huge
		for _, child in ipairs(parent:GetChildren()) do
			if child.Name == childName and (not className or child.ClassName == className) then
				local childPosition = instancePosition(child)
				if childPosition then
					local distance = (childPosition - position).Magnitude
					if distance < bestDistance then
						best = child
						bestDistance = distance
					end
				end
			end
		end
		if best then return best end
	end

	local exact = findPath(fullName)
	if exact and (not className or exact.ClassName == className) then return exact end
	return exact
end

local lastPlacedTroop = nil
local placedTroops = {}

local function isTroopPlace(call)
	return call.method == "InvokeServer" and call.args[1] == "Troops" and call.args[2] == "Place"
end

local function isTroopUpgrade(call)
	return call.method == "InvokeServer" and call.args[1] == "Troops" and call.args[2] == "Upgrade"
end

local function isTroopSell(call)
	return call.method == "InvokeServer" and call.args[1] == "Troops" and call.args[2] == "Sell"
end

local function isTroopAction(call)
	return call.method == "InvokeServer" and call.args[1] == "Troops"
end

local function rememberTroop(troop)
	if typeof(troop) ~= "Instance" then return end
	lastPlacedTroop = troop
	table.insert(placedTroops, troop)
end

local function nearestPlacedTroop(position)
	if not position then return nil end
	local best, bestDistance = nil, math.huge
	for _, troop in ipairs(placedTroops) do
		if troop and troop.Parent then
			local troopPosition = instancePosition(troop)
			if troopPosition then
				local distance = (troopPosition - position).Magnitude
				if distance < bestDistance then
					best = troop
					bestDistance = distance
				end
			end
		end
	end
	return best
end

local function towerRoot(instance, towersFolder)
	local current = instance
	while current and current.Parent ~= towersFolder do
		current = current.Parent
	end
	return current
end

local function nearestLiveTower(position, maxDistance)
	if not position then return nil end
	local towers = workspace:FindFirstChild("Towers")
	if not towers then return nil end
	local best, bestDistance = nil, math.huge
	local seen = {}
	local function check(candidate)
		if not candidate or seen[candidate] then return end
		seen[candidate] = true
		local candidatePosition = instancePosition(candidate)
		if candidatePosition then
			local distance = (candidatePosition - position).Magnitude
			if distance < bestDistance then
				best = candidate
				bestDistance = distance
			end
		end
	end
	for _, child in ipairs(towers:GetChildren()) do check(child) end
	for _, descendant in ipairs(towers:GetDescendants()) do check(towerRoot(descendant, towers)) end
	if best and bestDistance <= (maxDistance or 14) then return best, bestDistance end
	return nil, bestDistance
end

local function waitForTowerNear(position, timeout, maxDistance)
	if not position then return nil end
	local stopAt = os.clock() + (timeout or 5)
	local best, distance
	while os.clock() < stopAt do
		best, distance = nearestLiveTower(position, maxDistance or 14)
		if best then return best, distance end
		task.wait(0.15)
	end
	return nearestLiveTower(position, maxDistance or 18)
end

local function fixTroopArg(call)
	if isTroopAction(call) and not isTroopPlace(call) and typeof(call.args[4]) == "table" then
		local current = call.args[4].Troop
		if typeof(current) == "Instance" and current.Parent then return end
		local chosen = waitForTowerNear(call.troopPosition, 8, 20) or nearestPlacedTroop(call.troopPosition)
		if not chosen and not call.troopPosition then chosen = lastPlacedTroop end
		if chosen then call.args[4].Troop = chosen; rememberTroop(chosen) end
	end
end

local calls = {

	-- Wave --
	{
		t = 1.8484,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "--",
		waveNumber = 0,
		waveTimerText = "--",
		waveTimerSeconds = nil,
		cashText = "5",
		cashNumber = 5,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 2,
		args = {
			[1] = "Voting", -- string Voting
			[2] = "Skip", -- string Skip
		},
	},
	{
		t = 11.4977,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "--",
		waveNumber = 0,
		waveTimerText = "00:11",
		waveTimerSeconds = 11,
		cashText = "$600",
		cashNumber = 600,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 12.8655,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "--",
		waveNumber = 0,
		waveTimerText = "00:10",
		waveTimerSeconds = 10,
		cashText = "$0",
		cashNumber = 0,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(12.2193984985, 1.0000064373, -9.4487714767)}, -- table table: 0x3a1a846ddb32b771
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 13.1316,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "--",
		waveNumber = 0,
		waveTimerText = "00:10",
		waveTimerSeconds = 10,
		cashText = "$0",
		cashNumber = 0,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 2 / 35
	{
		t = 41.7845,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "2 / 35",
		waveNumber = 2,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$390",
		cashNumber = 390,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 44.4332,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "2 / 35",
		waveNumber = 2,
		waveTimerText = "00:53",
		waveTimerSeconds = 53,
		cashText = "$271",
		cashNumber = 271,
		position = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2193984985, 1.0000125170, -9.4487714767))}, -- table table: 0xfbd321fb806a20e1
		},
	},
	{
		t = 49.7600,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "2 / 35",
		waveNumber = 2,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$144",
		cashNumber = 144,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 3 / 35
	{
		t = 56.0005,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "3 / 35",
		waveNumber = 3,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$595",
		cashNumber = 595,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 60.7673,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "3 / 35",
		waveNumber = 3,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$595",
		cashNumber = 595,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 66.0289,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "3 / 35",
		waveNumber = 3,
		waveTimerText = "00:50",
		waveTimerSeconds = 50,
		cashText = "$641",
		cashNumber = 641,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 75.5953,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "3 / 35",
		waveNumber = 3,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$1,133",
		cashNumber = 1133,
		position = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2193984985, 1.0000125170, -9.4487714767))}, -- table table: 0xab92b8e1b33b2ee1
		},
	},

	-- Wave 4 / 35
	{
		t = 83.6122,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "4 / 35",
		waveNumber = 4,
		waveTimerText = "00:54",
		waveTimerSeconds = 54,
		cashText = "$434",
		cashNumber = 434,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 91.1836,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "4 / 35",
		waveNumber = 4,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$969",
		cashNumber = 969,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 93.5642,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "4 / 35",
		waveNumber = 4,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$554",
		cashNumber = 554,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(12.2325601578, 1.0000064373, -6.1779851913)}, -- table table: 0x923e19a70009f161
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 93.8269,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "4 / 35",
		waveNumber = 4,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$553",
		cashNumber = 553,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 5 / 35
	{
		t = 96.0291,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "5 / 35",
		waveNumber = 5,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$553",
		cashNumber = 553,
		position = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2325601578, 1.0000125170, -6.1779851913))}, -- table table: 0x089327c3859f5fa1
		},
	},
	{
		t = 99.2799,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "5 / 35",
		waveNumber = 5,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$253",
		cashNumber = 253,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 112.5681,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "5 / 35",
		waveNumber = 5,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$1,197",
		cashNumber = 1197,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 113.1566,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "5 / 35",
		waveNumber = 5,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$1,197",
		cashNumber = 1197,
		position = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2325601578, 1.0000125170, -6.1779851913))}, -- table table: 0x9cc840d3f22de691
		},
	},

	-- Wave 6 / 35
	{
		t = 125.7601,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:49",
		waveTimerSeconds = 49,
		cashText = "$497",
		cashNumber = 497,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 135.2517,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$747",
		cashNumber = 747,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 136.4177,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$1,352",
		cashNumber = 1352,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 137.9144,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$995",
		cashNumber = 995,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(14.4999713898, 1.0000064373, -3.4679813385)}, -- table table: 0x329f38db6bf5b441
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 138.1824,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$994",
		cashNumber = 994,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 138.8472,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "6 / 35",
		waveNumber = 6,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$981",
		cashNumber = 981,
		position = Vector3.new(14.4999713898, 1.0000125170, -3.4679813385),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.4999713898, 1.0000125170, -3.4679813385),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.4999713898, 1.0000125170, -3.4679813385))}, -- table table: 0x61394bc31f557201
		},
	},

	-- Wave 7 / 35
	{
		t = 157.2792,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "7 / 35",
		waveNumber = 7,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$1,042",
		cashNumber = 1042,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 158.2873,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "7 / 35",
		waveNumber = 7,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$1,721",
		cashNumber = 1721,
		position = Vector3.new(14.4999713898, 1.0000125170, -3.4679813385),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.4999713898, 1.0000125170, -3.4679813385),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.4999713898, 1.0000125170, -3.4679813385))}, -- table table: 0x879fbe302b492c71
		},
	},
	{
		t = 159.6858,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "7 / 35",
		waveNumber = 7,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$1,142",
		cashNumber = 1142,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 160.3921,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "7 / 35",
		waveNumber = 7,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$553",
		cashNumber = 553,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(11.1026725769, 1.0000064373, -2.8480975628)}, -- table table: 0xac54fd6d9a6dabf1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 160.6618,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "7 / 35",
		waveNumber = 7,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$542",
		cashNumber = 542,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 8 / 35
	{
		t = 161.3584,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "8 / 35",
		waveNumber = 8,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$542",
		cashNumber = 542,
		position = Vector3.new(11.1026725769, 1.0000125170, -2.8480975628),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.1026725769, 1.0000125170, -2.8480975628),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.1026725769, 1.0000125170, -2.8480975628))}, -- table table: 0x5c7944808084d571
		},
	},
	{
		t = 177.8233,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "8 / 35",
		waveNumber = 8,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$1,445",
		cashNumber = 1445,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 178.9503,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "8 / 35",
		waveNumber = 8,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$1,746",
		cashNumber = 1746,
		position = Vector3.new(11.1026725769, 1.0000123978, -2.8480975628),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.1026725769, 1.0000123978, -2.8480975628),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.1026725769, 1.0000123978, -2.8480975628))}, -- table table: 0xe27f22fa5eebd071
		},
	},

	-- Wave 9 / 35
	{
		t = 181.7682,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$896",
		cashNumber = 896,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 182.7837,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$338",
		cashNumber = 338,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(14.2328500748, 1.0000064373, 0.1751356125)}, -- table table: 0x1e4c51084f49a591
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 183.0592,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$296",
		cashNumber = 296,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 185.8495,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$386",
		cashNumber = 386,
		position = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.2328500748, 1.0000125170, 0.1751356125))}, -- table table: 0x85b87b348f461811
		},
	},
	{
		t = 201.0000,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$626",
		cashNumber = 626,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 203.5437,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$26",
		cashNumber = 26,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(10.5553083420, 1.0000064373, 0.3380870819)}, -- table table: 0x392cf1a8b539e9c1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 203.8151,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$26",
		cashNumber = 26,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 205.4338,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$929",
		cashNumber = 929,
		position = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5553083420, 1.0000125170, 0.3380870819))}, -- table table: 0x20a2a1fca8572511
		},
	},
	{
		t = 206.9492,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "9 / 35",
		waveNumber = 9,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$883",
		cashNumber = 883,
		position = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5553083420, 1.0000125170, 0.3380870819))}, -- table table: 0xa58f1a026b54f201
		},
	},

	-- Wave 10 / 35
	{
		t = 209.4009,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "10 / 35",
		waveNumber = 10,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$33",
		cashNumber = 33,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 11 / 35
	{
		t = 225.7466,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$1,917",
		cashNumber = 1917,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 228.3160,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$1,317",
		cashNumber = 1317,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(12.5864706039, 1.0000064373, 3.1800518036)}, -- table table: 0xd8276ae7f7a9f0c1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 228.5832,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$1,317",
		cashNumber = 1317,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 229.3598,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$1,367",
		cashNumber = 1367,
		position = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.5864706039, 1.0000125170, 3.1800518036))}, -- table table: 0x627e6272b22f4e11
		},
	},
	{
		t = 230.6854,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$1,117",
		cashNumber = 1117,
		position = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.5864706039, 1.0000125170, 3.1800518036))}, -- table table: 0x3a5864a3f2481c51
		},
	},
	{
		t = 236.4353,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:49",
		waveTimerSeconds = 49,
		cashText = "$708",
		cashNumber = 708,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 238.7334,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "11 / 35",
		waveNumber = 11,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$738",
		cashNumber = 738,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 12 / 35
	{
		t = 257.5901,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "12 / 35",
		waveNumber = 12,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$2,849",
		cashNumber = 2849,
		position = Vector3.new(12.5864706039, 1.0000126362, 3.1800518036),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.5864706039, 1.0000126362, 3.1800518036),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.5864706039, 1.0000126362, 3.1800518036))}, -- table table: 0x740ba5c3f81e57d1
		},
	},
	{
		t = 266.0304,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "12 / 35",
		waveNumber = 12,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$599",
		cashNumber = 599,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 13 / 35
	{
		t = 281.2041,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "13 / 35",
		waveNumber = 13,
		waveTimerText = "00:50",
		waveTimerSeconds = 50,
		cashText = "$2,845",
		cashNumber = 2845,
		position = Vector3.new(11.1026725769, 1.0000123978, -2.8480975628),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.1026725769, 1.0000123978, -2.8480975628),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.1026725769, 1.0000123978, -2.8480975628))}, -- table table: 0xf975164009356671
		},
	},
	{
		t = 294.8098,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "13 / 35",
		waveNumber = 13,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$2,097",
		cashNumber = 2097,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 14 / 35
	{
		t = 305.3551,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "14 / 35",
		waveNumber = 14,
		waveTimerText = "00:50",
		waveTimerSeconds = 50,
		cashText = "$3,072",
		cashNumber = 3072,
		position = Vector3.new(12.2193984985, 1.0000123978, -9.4487714767),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2193984985, 1.0000123978, -9.4487714767),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2193984985, 1.0000123978, -9.4487714767))}, -- table table: 0xcf21a993746cb121
		},
	},
	{
		t = 315.1748,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "14 / 35",
		waveNumber = 14,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$2,770",
		cashNumber = 2770,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 15 / 35
	{
		t = 317.4519,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$2,770",
		cashNumber = 2770,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 318.4862,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$2,770",
		cashNumber = 2770,
		position = Vector3.new(14.4999713898, 1.0000123978, -3.4679813385),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.4999713898, 1.0000123978, -3.4679813385),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.4999713898, 1.0000123978, -3.4679813385))}, -- table table: 0x46d993b58bc31581
		},
	},
	{
		t = 320.3252,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$98",
		cashNumber = 98,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 332.3209,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "00:45",
		waveTimerSeconds = 45,
		cashText = "$995",
		cashNumber = 995,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 333.6025,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "00:44",
		waveTimerSeconds = 44,
		cashText = "$1,245",
		cashNumber = 1245,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 339.2625,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "15 / 35",
		waveNumber = 15,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$3,284",
		cashNumber = 3284,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 16 / 35
	{
		t = 340.4201,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "02:00",
		waveTimerSeconds = 120,
		cashText = "$2,719",
		cashNumber = 2719,
		position = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2325601578, 1.0000125170, -6.1779851913))}, -- table table: 0x975f2b083bebade1
		},
	},
	{
		t = 373.0318,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "01:28",
		waveTimerSeconds = 88,
		cashText = "$3,394",
		cashNumber = 3394,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 373.8621,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "01:27",
		waveTimerSeconds = 87,
		cashText = "$3,394",
		cashNumber = 3394,
		position = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5553083420, 1.0000125170, 0.3380870819),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5553083420, 1.0000125170, 0.3380870819))}, -- table table: 0x4af0d90455f13431
		},
	},
	{
		t = 375.4278,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "01:25",
		waveTimerSeconds = 85,
		cashText = "$644",
		cashNumber = 644,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 388.0354,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$5,638",
		cashNumber = 5638,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 388.8197,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "16 / 35",
		waveNumber = 16,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$5,638",
		cashNumber = 5638,
		position = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.2328500748, 1.0000125170, 0.1751356125))}, -- table table: 0x0cf6b7f67ac7b121
		},
	},

	-- Wave 17 / 35
	{
		t = 390.4675,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "17 / 35",
		waveNumber = 17,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$4,264",
		cashNumber = 4264,
		position = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.2328500748, 1.0000125170, 0.1751356125),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.2328500748, 1.0000125170, 0.1751356125))}, -- table table: 0x505c230d3b0c2cd1
		},
	},
	{
		t = 393.2546,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "17 / 35",
		waveNumber = 17,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$2,038",
		cashNumber = 2038,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 397.2472,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "17 / 35",
		waveNumber = 17,
		waveTimerText = "00:53",
		waveTimerSeconds = 53,
		cashText = "$3,113",
		cashNumber = 3113,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 412.6603,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "17 / 35",
		waveNumber = 17,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$8,765",
		cashNumber = 8765,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 413.6317,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "17 / 35",
		waveNumber = 17,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$8,765",
		cashNumber = 8765,
		position = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.5864706039, 1.0000125170, 3.1800518036),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.5864706039, 1.0000125170, 3.1800518036))}, -- table table: 0x6c0731aa4b652df1
		},
	},

	-- Wave 18 / 35
	{
		t = 447.0651,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "18 / 35",
		waveNumber = 18,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$7,938",
		cashNumber = 7938,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 448.2976,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "18 / 35",
		waveNumber = 18,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$8,899",
		cashNumber = 8899,
		position = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2325601578, 1.0000125170, -6.1779851913),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2325601578, 1.0000125170, -6.1779851913))}, -- table table: 0x28ddcdadadc83cc1
		},
	},

	-- Wave 19 / 35
	{
		t = 474.1743,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "19 / 35",
		waveNumber = 19,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$9,630",
		cashNumber = 9630,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 474.7881,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "19 / 35",
		waveNumber = 19,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$9,630",
		cashNumber = 9630,
		position = Vector3.new(14.4999713898, 1.0000123978, -3.4679813385),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.4999713898, 1.0000123978, -3.4679813385),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.4999713898, 1.0000123978, -3.4679813385))}, -- table table: 0xd7101185217c7cb1
		},
	},

	-- Wave 20 / 35
	{
		t = 477.2784,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "20 / 35",
		waveNumber = 20,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$1,630",
		cashNumber = 1630,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 485.9921,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "20 / 35",
		waveNumber = 20,
		waveTimerText = "00:51",
		waveTimerSeconds = 51,
		cashText = "$2,875",
		cashNumber = 2875,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 507.0375,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "20 / 35",
		waveNumber = 20,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$9,586",
		cashNumber = 9586,
		position = Vector3.new(11.1026725769, 1.0000125170, -2.8480975628),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.1026725769, 1.0000125170, -2.8480975628),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.1026725769, 1.0000125170, -2.8480975628))}, -- table table: 0xaa81ff5550146321
		},
	},

	-- Wave 21 / 35
	{
		t = 511.1076,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "21 / 35",
		waveNumber = 21,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$1,586",
		cashNumber = 1586,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 535.7152,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "21 / 35",
		waveNumber = 21,
		waveTimerText = "00:33",
		waveTimerSeconds = 33,
		cashText = "$9,568",
		cashNumber = 9568,
		position = Vector3.new(10.5553083420, 1.0000123978, 0.3380870819),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5553083420, 1.0000123978, 0.3380870819),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5553083420, 1.0000123978, 0.3380870819))}, -- table table: 0x49d6fe4bb5c692f1
		},
	},
	{
		t = 540.1505,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "21 / 35",
		waveNumber = 21,
		waveTimerText = "00:29",
		waveTimerSeconds = 29,
		cashText = "$3,568",
		cashNumber = 3568,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},

	-- Wave 22 / 35
	{
		t = 551.1864,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$8,015",
		cashNumber = 8015,
		position = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(12.2193984985, 1.0000125170, -9.4487714767),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(12.2193984985, 1.0000125170, -9.4487714767))}, -- table table: 0x93c1490eab3c72b1
		},
	},
	{
		t = 568.9362,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:39",
		waveTimerSeconds = 39,
		cashText = "$6,490",
		cashNumber = 6490,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 574.6599,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$10,051",
		cashNumber = 10051,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},
	{
		t = 575.2981,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$10,828",
		cashNumber = 10828,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)}, -- table table: 0xd56e495076b1b7a1
			[4] = "Military Base", -- string Military Base
		},
	},
	{
		t = 575.5626,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$10,825",
		cashNumber = 10825,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 575.8787,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$10,825",
		cashNumber = 10825,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307))}, -- table table: 0x3dc2effd3e67f4d1
		},
	},
	{
		t = 576.1107,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$10,625",
		cashNumber = 10625,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307))}, -- table table: 0xa3c90d598ee9e0d1
		},
	},
	{
		t = 576.2208,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$10,250",
		cashNumber = 10250,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307))}, -- table table: 0x86998c8880c6a761
		},
	},
	{
		t = 576.9268,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "22 / 35",
		waveNumber = 22,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$8,225",
		cashNumber = 8225,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307))}, -- table table: 0x500ecdbb21fba321
		},
	},

	-- Wave 23 / 35
	{
		t = 578.2202,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "23 / 35",
		waveNumber = 23,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$725",
		cashNumber = 725,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 596.0156,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "23 / 35",
		waveNumber = 23,
		waveTimerText = "00:42",
		waveTimerSeconds = 42,
		cashText = "$5,165",
		cashNumber = 5165,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 603.0268,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "23 / 35",
		waveNumber = 23,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$8,798",
		cashNumber = 8798,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 603.3336,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "23 / 35",
		waveNumber = 23,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$8,798",
		cashNumber = 8798,
		position = Vector3.new(14.2328500748, 1.0000123978, 0.1751356125),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.2328500748, 1.0000123978, 0.1751356125),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.2328500748, 1.0000123978, 0.1751356125))}, -- table table: 0x8dd33e0168e02e61
		},
	},
	{
		t = 606.2035,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "23 / 35",
		waveNumber = 23,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$5,097",
		cashNumber = 5097,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},

	-- Wave 24 / 35
	{
		t = 608.1936,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$4,702",
		cashNumber = 4702,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-29.9127731323, 1.0118863583, -16.7649593353)}, -- table table: 0x8f17de1b2a7fc9d1
			[4] = "Military Base", -- string Military Base
		},
	},
	{
		t = 608.4579,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$4,697",
		cashNumber = 4697,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 609.0310,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$4,697",
		cashNumber = 4697,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500))}, -- table table: 0x8347ddba905860c1
		},
	},
	{
		t = 609.6038,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$4,497",
		cashNumber = 4497,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500))}, -- table table: 0xd3bbb965b0fe1b41
		},
	},
	{
		t = 610.4309,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$4,097",
		cashNumber = 4097,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 610.6281,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$5,907",
		cashNumber = 5907,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 611.9151,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$6,134",
		cashNumber = 6134,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500))}, -- table table: 0xc98df5aaea8492e1
		},
	},
	{
		t = 619.5170,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$7,634",
		cashNumber = 7634,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500))}, -- table table: 0x9ed64cf8e71500b1
		},
	},
	{
		t = 633.0621,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$9,872",
		cashNumber = 9872,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},
	{
		t = 634.2868,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "24 / 35",
		waveNumber = 24,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$9,489",
		cashNumber = 9489,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-28.7406806946, 1.0500061512, -11.5174083710)}, -- table table: 0x8f189deae8643ff1
			[4] = "Military Base", -- string Military Base
		},
	},

	-- Wave 25 / 35
	{
		t = 634.5904,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$9,472",
		cashNumber = 9472,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 635.1179,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$9,472",
		cashNumber = 9472,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636))}, -- table table: 0x5cbe2e47ad088ae1
		},
	},
	{
		t = 635.5186,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:09",
		waveTimerSeconds = 69,
		cashText = "$9,272",
		cashNumber = 9272,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636))}, -- table table: 0x40ccf7bff45e8f21
		},
	},
	{
		t = 635.8962,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:09",
		waveTimerSeconds = 69,
		cashText = "$8,957",
		cashNumber = 8957,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636))}, -- table table: 0xf97f3c08213d3111
		},
	},
	{
		t = 641.1589,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:04",
		waveTimerSeconds = 64,
		cashText = "$5,093",
		cashNumber = 5093,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636))}, -- table table: 0x0555b3efbf968c61
		},
	},
	{
		t = 642.7955,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$437",
		cashNumber = 437,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},
	{
		t = 643.0909,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$437",
		cashNumber = 437,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 644.2270,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:01",
		waveTimerSeconds = 61,
		cashText = "$466",
		cashNumber = 466,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666)}, -- table table: 0x19fb08efe3bc8051
			[4] = "Military Base", -- string Military Base
		},
	},
	{
		t = 644.5071,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$212",
		cashNumber = 212,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 645.1462,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$302",
		cashNumber = 302,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 645.4869,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$386",
		cashNumber = 386,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666))}, -- table table: 0x454a5c2917754e11
		},
	},
	{
		t = 647.6502,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$517",
		cashNumber = 517,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666))}, -- table table: 0x2d609ae2d95af871
		},
	},
	{
		t = 653.5340,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:51",
		waveTimerSeconds = 51,
		cashText = "$3,417",
		cashNumber = 3417,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666))}, -- table table: 0x14b114272ec3dc31
		},
	},
	{
		t = 669.2116,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:36",
		waveTimerSeconds = 36,
		cashText = "$5,149",
		cashNumber = 5149,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 674.9075,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:30",
		waveTimerSeconds = 30,
		cashText = "$8,149",
		cashNumber = 8149,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666))}, -- table table: 0x5b52145cc7a0e7f1
		},
	},
	{
		t = 678.0815,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:27",
		waveTimerSeconds = 27,
		cashText = "$649",
		cashNumber = 649,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 679.2511,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:26",
		waveTimerSeconds = 26,
		cashText = "$649",
		cashNumber = 649,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 680.1768,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$649",
		cashNumber = 649,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 691.0499,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:14",
		waveTimerSeconds = 14,
		cashText = "$3,649",
		cashNumber = 3649,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},
	{
		t = 692.0883,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:13",
		waveTimerSeconds = 13,
		cashText = "$3,266",
		cashNumber = 3266,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)}, -- table table: 0x5759e128a2e43bd1
			[4] = "Military Base", -- string Military Base
		},
	},
	{
		t = 692.3606,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:12",
		waveTimerSeconds = 12,
		cashText = "$3,249",
		cashNumber = 3249,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 692.6608,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$3,249",
		cashNumber = 3249,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394))}, -- table table: 0x18c608765d977b51
		},
	},
	{
		t = 692.8277,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$3,051",
		cashNumber = 3051,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394))}, -- table table: 0xb405f64c23903bb1
		},
	},
	{
		t = 693.0004,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$2,652",
		cashNumber = 2652,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394))}, -- table table: 0x431c0c986dcd0901
		},
	},
	{
		t = 695.4844,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "25 / 35",
		waveNumber = 25,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$5,326",
		cashNumber = 5326,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},

	-- Wave 26 / 35
	{
		t = 704.2139,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "01:09",
		waveTimerSeconds = 69,
		cashText = "$7,976",
		cashNumber = 7976,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 704.4583,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "01:08",
		waveTimerSeconds = 68,
		cashText = "$7,976",
		cashNumber = 7976,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394))}, -- table table: 0x6a8daded85f114c1
		},
	},
	{
		t = 706.6589,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "01:06",
		waveTimerSeconds = 66,
		cashText = "$3,126",
		cashNumber = 3126,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 713.1015,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$7,376",
		cashNumber = 7376,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 714.2702,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$8,257",
		cashNumber = 8257,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 715.1933,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$10,276",
		cashNumber = 10276,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 719.5616,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:53",
		waveTimerSeconds = 53,
		cashText = "$13,176",
		cashNumber = 13176,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 2, -- number 2
		},
	},
	{
		t = 720.2594,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:53",
		waveTimerSeconds = 53,
		cashText = "$13,176",
		cashNumber = 13176,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-30.9188537598, 1.0000064373, -27.3244857788)}, -- table table: 0x509ffb840e66cb41
			[4] = "Military Base", -- string Military Base
		},
	},
	{
		t = 726.5241,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:46",
		waveTimerSeconds = 46,
		cashText = "$16,551",
		cashNumber = 16551,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 727.1123,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:46",
		waveTimerSeconds = 46,
		cashText = "$16,551",
		cashNumber = 16551,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 739.2293,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:34",
		waveTimerSeconds = 34,
		cashText = "$20,426",
		cashNumber = 20426,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 746.1001,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:27",
		waveTimerSeconds = 27,
		cashText = "$18,423",
		cashNumber = 18423,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307))}, -- table table: 0x6730d5db67febe51
		},
	},
	{
		t = 748.1113,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$1,426",
		cashNumber = 1426,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 748.2097,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$1,426",
		cashNumber = 1426,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 3, -- number 3
		},
	},
	{
		t = 749.3756,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$977",
		cashNumber = 977,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(11.3606834412, 1.0000064373, -17.6842994690)}, -- table table: 0xf906384ef57dc831
			[4] = "Freezer", -- string Freezer
		},
	},
	{
		t = 749.4312,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$976",
		cashNumber = 976,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 749.6433,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$976",
		cashNumber = 976,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Freezer", -- string Freezer
			[4] = "Default", -- string Default
		},
	},
	{
		t = 750.3386,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$4,452",
		cashNumber = 4452,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 750.4029,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$4,453",
		cashNumber = 4453,
		position = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.3606834412, 1.0000125170, -17.6842994690))}, -- table table: 0x41b1c58cea3f3a61
		},
	},
	{
		t = 750.5530,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$4,158",
		cashNumber = 4158,
		position = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.3606834412, 1.0000125170, -17.6842994690))}, -- table table: 0x4fdf9f3ece15eb01
		},
	},
	{
		t = 750.7360,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "26 / 35",
		waveNumber = 26,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$3,705",
		cashNumber = 3705,
		position = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.3606834412, 1.0000125170, -17.6842994690))}, -- table table: 0x6c430b68be819ca1
		},
	},

	-- Wave 27 / 35
	{
		t = 758.5203,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "27 / 35",
		waveNumber = 27,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$3,365",
		cashNumber = 3365,
		position = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(11.3606834412, 1.0000125170, -17.6842994690),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(11.3606834412, 1.0000125170, -17.6842994690))}, -- table table: 0xb741aca056ce4041
		},
	},
	{
		t = 762.0105,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "27 / 35",
		waveNumber = 27,
		waveTimerText = "00:52",
		waveTimerSeconds = 52,
		cashText = "$3,693",
		cashNumber = 3693,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 774.2597,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "27 / 35",
		waveNumber = 27,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$22,354",
		cashNumber = 22354,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 776.2453,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "27 / 35",
		waveNumber = 27,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$23,799",
		cashNumber = 23799,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},

	-- Wave 28 / 35
	{
		t = 783.1417,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$25,199",
		cashNumber = 25199,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 784.2772,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$26,599",
		cashNumber = 26599,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 784.4724,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$26,599",
		cashNumber = 26599,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636))}, -- table table: 0xc91b7e71fc9c77b1
		},
	},
	{
		t = 785.2030,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$1,599",
		cashNumber = 1599,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 797.0497,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:46",
		waveTimerSeconds = 46,
		cashText = "$10,919",
		cashNumber = 10919,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 806.8718,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:36",
		waveTimerSeconds = 36,
		cashText = "$20,499",
		cashNumber = 20499,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 807.9014,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$19,899",
		cashNumber = 19899,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 808.1200,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$19,899",
		cashNumber = 19899,
		position = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212))}, -- table table: 0x58a7c85ffb447061
		},
	},
	{
		t = 808.2735,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$19,603",
		cashNumber = 19603,
		position = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212))}, -- table table: 0x39a6ab5f3b5bc711
		},
	},
	{
		t = 808.3911,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:34",
		waveTimerSeconds = 34,
		cashText = "$18,800",
		cashNumber = 18800,
		position = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212))}, -- table table: 0xdb30aab8ab7a4e71
		},
	},
	{
		t = 808.6413,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:34",
		waveTimerSeconds = 34,
		cashText = "$16,000",
		cashNumber = 16000,
		position = Vector3.new(-12.8057765961, 1.0000126362, -4.3037586212),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8057765961, 1.0000126362, -4.3037586212),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8057765961, 1.0000126362, -4.3037586212))}, -- table table: 0x482713d16db92321
		},
	},
	{
		t = 809.2575,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:34",
		waveTimerSeconds = 34,
		cashText = "$10,899",
		cashNumber = 10899,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 809.3356,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:33",
		waveTimerSeconds = 33,
		cashText = "$10,899",
		cashNumber = 10899,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 810.0726,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:33",
		waveTimerSeconds = 33,
		cashText = "$10,299",
		cashNumber = 10299,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 810.1941,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:33",
		waveTimerSeconds = 33,
		cashText = "$10,299",
		cashNumber = 10299,
		position = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004))}, -- table table: 0xec2d8c4f9e364231
		},
	},
	{
		t = 810.3510,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:32",
		waveTimerSeconds = 32,
		cashText = "$9,654",
		cashNumber = 9654,
		position = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004))}, -- table table: 0xa2c86db003e10b61
		},
	},
	{
		t = 810.5539,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:32",
		waveTimerSeconds = 32,
		cashText = "$9,150",
		cashNumber = 9150,
		position = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1238403320, 1.0000125170, 2.0721035004))}, -- table table: 0x647795c150489581
		},
	},
	{
		t = 816.7047,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$13,644",
		cashNumber = 13644,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 817.1673,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$13,644",
		cashNumber = 13644,
		position = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		troopPath = "Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212),
		n = 3,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Sell", -- string Sell
			[3] = {Troop = findInstance("Default", "Model", Vector3.new(-12.8057765961, 1.0000125170, -4.3037586212))}, -- table table: 0x71473384f3fef8d1
		},
	},
	{
		t = 817.6411,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$17,810",
		cashNumber = 17810,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 818.1537,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$17,810",
		cashNumber = 17810,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 818.1980,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$17,810",
		cashNumber = 17810,
		position = Vector3.new(-13.1238403320, 1.0000123978, 2.0721035004),
		troopPath = "Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1238403320, 1.0000123978, 2.0721035004),
		n = 3,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Sell", -- string Sell
			[3] = {Troop = findInstance("Default", "Model", Vector3.new(-13.1238403320, 1.0000123978, 2.0721035004))}, -- table table: 0x4825fa655af50f21
		},
	},
	{
		t = 819.2737,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "28 / 35",
		waveNumber = 28,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$19,310",
		cashNumber = 19310,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},

	-- Wave 29 / 35
	{
		t = 820.2205,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$19,310",
		cashNumber = 19310,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 830.0317,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:50",
		waveTimerSeconds = 50,
		cashText = "$24,810",
		cashNumber = 24810,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 831.0436,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:49",
		waveTimerSeconds = 49,
		cashText = "$26,310",
		cashNumber = 26310,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500))}, -- table table: 0xb7a77c427c74c4a1
		},
	},
	{
		t = 832.0620,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$2,810",
		cashNumber = 2810,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 844.2885,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$11,910",
		cashNumber = 11910,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 853.1567,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:27",
		waveTimerSeconds = 27,
		cashText = "$19,885",
		cashNumber = 19885,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 854.2923,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$19,885",
		cashNumber = 19885,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 855.2238,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$20,260",
		cashNumber = 20260,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 859.8371,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:20",
		waveTimerSeconds = 20,
		cashText = "$25,385",
		cashNumber = 25385,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 860.5363,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:19",
		waveTimerSeconds = 19,
		cashText = "$25,385",
		cashNumber = 25385,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394))}, -- table table: 0xfe306ebe058a1eb1
		},
	},
	{
		t = 867.0549,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:13",
		waveTimerSeconds = 13,
		cashText = "$4,760",
		cashNumber = 4760,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 872.0726,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "29 / 35",
		waveNumber = 29,
		waveTimerText = "00:08",
		waveTimerSeconds = 8,
		cashText = "$10,760",
		cashNumber = 10760,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},

	-- Wave 30 / 35
	{
		t = 879.3084,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:58",
		waveTimerSeconds = 178,
		cashText = "$16,201",
		cashNumber = 16201,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 888.1722,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:50",
		waveTimerSeconds = 170,
		cashText = "$23,701",
		cashNumber = 23701,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 889.3058,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:48",
		waveTimerSeconds = 168,
		cashText = "$24,451",
		cashNumber = 24451,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Tank", -- string Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 890.2292,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:48",
		waveTimerSeconds = 168,
		cashText = "$24,451",
		cashNumber = 24451,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 894.8324,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:43",
		waveTimerSeconds = 163,
		cashText = "$27,451",
		cashNumber = 27451,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666))}, -- table table: 0xc52a1bcaffe2e381
		},
	},
	{
		t = 900.0026,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:38",
		waveTimerSeconds = 158,
		cashText = "$8,251",
		cashNumber = 8251,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 900.7828,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:37",
		waveTimerSeconds = 157,
		cashText = "$6,649",
		cashNumber = 6649,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(2.2695789337, 1.0000064373, -8.0314064026)}, -- table table: 0x7b1ef093d6d959c1
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 901.0607,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:37",
		waveTimerSeconds = 157,
		cashText = "$6,626",
		cashNumber = 6626,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 901.7184,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:36",
		waveTimerSeconds = 156,
		cashText = "$11,026",
		cashNumber = 11026,
		position = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2695789337, 1.0000125170, -8.0314064026))}, -- table table: 0xd11bc8675edd1751
		},
	},
	{
		t = 902.1164,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:36",
		waveTimerSeconds = 156,
		cashText = "$10,301",
		cashNumber = 10301,
		position = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2695789337, 1.0000125170, -8.0314064026))}, -- table table: 0x2e994c7a98f863e1
		},
	},
	{
		t = 902.1955,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:36",
		waveTimerSeconds = 156,
		cashText = "$8,019",
		cashNumber = 8019,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 905.2693,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:33",
		waveTimerSeconds = 153,
		cashText = "$10,451",
		cashNumber = 10451,
		position = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2695789337, 1.0000125170, -8.0314064026))}, -- table table: 0x9c490aaeb04f4061
		},
	},
	{
		t = 909.4748,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:28",
		waveTimerSeconds = 148,
		cashText = "$5,051",
		cashNumber = 5051,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 910.1857,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:28",
		waveTimerSeconds = 148,
		cashText = "$3,484",
		cashNumber = 3484,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(2.3619651794, 1.0000064373, -4.6389122009)}, -- table table: 0x900895919c4e4071
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 910.4737,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:27",
		waveTimerSeconds = 147,
		cashText = "$3,426",
		cashNumber = 3426,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 911.7519,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:26",
		waveTimerSeconds = 146,
		cashText = "$5,426",
		cashNumber = 5426,
		position = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.3619651794, 1.0000125170, -4.6389122009))}, -- table table: 0xea7440e83d00f901
		},
	},
	{
		t = 911.9737,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:26",
		waveTimerSeconds = 146,
		cashText = "$3,754",
		cashNumber = 3754,
		position = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.3619651794, 1.0000125170, -4.6389122009))}, -- table table: 0x8a6084daae16ebb1
		},
	},
	{
		t = 913.0210,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:25",
		waveTimerSeconds = 145,
		cashText = "$2,851",
		cashNumber = 2851,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 913.7808,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:24",
		waveTimerSeconds = 144,
		cashText = "$2,732",
		cashNumber = 2732,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(2.4058761597, 1.0000064373, -1.4597620964)}, -- table table: 0x019da251510b6ca1
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 914.0601,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:24",
		waveTimerSeconds = 144,
		cashText = "$2,226",
		cashNumber = 2226,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 914.3098,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:23",
		waveTimerSeconds = 143,
		cashText = "$2,226",
		cashNumber = 2226,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 914.5741,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:23",
		waveTimerSeconds = 143,
		cashText = "$2,226",
		cashNumber = 2226,
		position = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.4058761597, 1.0000125170, -1.4597620964))}, -- table table: 0x6b7d78c8a0db7991
		},
	},
	{
		t = 915.4896,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:22",
		waveTimerSeconds = 142,
		cashText = "$3,501",
		cashNumber = 3501,
		position = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.4058761597, 1.0000125170, -1.4597620964))}, -- table table: 0x989a08f884ada481
		},
	},
	{
		t = 916.0886,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:22",
		waveTimerSeconds = 142,
		cashText = "$651",
		cashNumber = 651,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 917.3810,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:20",
		waveTimerSeconds = 140,
		cashText = "$1,481",
		cashNumber = 1481,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(2.2793903351, 1.0000064373, 1.6213359833)}, -- table table: 0xd1a21eb952e1e3e1
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 917.6680,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:20",
		waveTimerSeconds = 140,
		cashText = "$1,026",
		cashNumber = 1026,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 918.3702,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:19",
		waveTimerSeconds = 139,
		cashText = "$1,026",
		cashNumber = 1026,
		position = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2793903351, 1.0000125170, 1.6213359833))}, -- table table: 0xa7f7c38e4946adb1
		},
	},
	{
		t = 923.2016,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:15",
		waveTimerSeconds = 135,
		cashText = "$301",
		cashNumber = 301,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 924.3331,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:13",
		waveTimerSeconds = 133,
		cashText = "$301",
		cashNumber = 301,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 925.2680,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:13",
		waveTimerSeconds = 133,
		cashText = "$301",
		cashNumber = 301,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 928.7602,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:09",
		waveTimerSeconds = 129,
		cashText = "$4,048",
		cashNumber = 4048,
		position = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2793903351, 1.0000125170, 1.6213359833))}, -- table table: 0x70c0631c8ef6aca1
		},
	},
	{
		t = 930.1306,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:08",
		waveTimerSeconds = 128,
		cashText = "$3,449",
		cashNumber = 3449,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 930.8511,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:07",
		waveTimerSeconds = 127,
		cashText = "$2,754",
		cashNumber = 2754,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.3501224518, 1.0000064373, -7.5127544403)}, -- table table: 0xdd7ae304ed246341
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 931.1584,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:07",
		waveTimerSeconds = 127,
		cashText = "$2,576",
		cashNumber = 2576,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 931.8000,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:06",
		waveTimerSeconds = 126,
		cashText = "$2,576",
		cashNumber = 2576,
		position = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403))}, -- table table: 0x1bbf3acf9f130d51
		},
	},
	{
		t = 935.6193,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:02",
		waveTimerSeconds = 122,
		cashText = "$3,351",
		cashNumber = 3351,
		position = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403))}, -- table table: 0x066f35501747e3c1
		},
	},
	{
		t = 937.0893,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:01",
		waveTimerSeconds = 121,
		cashText = "$4,295",
		cashNumber = 4295,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 937.4026,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:00",
		waveTimerSeconds = 120,
		cashText = "$5,750",
		cashNumber = 5750,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 938.3977,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "02:00",
		waveTimerSeconds = 120,
		cashText = "$5,635",
		cashNumber = 5635,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.0879154205, 1.0000064373, -4.0790061951)}, -- table table: 0xef79b5a5a1a38c81
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 938.6977,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:59",
		waveTimerSeconds = 119,
		cashText = "$5,626",
		cashNumber = 5626,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 939.4974,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:58",
		waveTimerSeconds = 118,
		cashText = "$6,376",
		cashNumber = 6376,
		position = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951))}, -- table table: 0x7c7d5e33a9fcf8d1
		},
	},
	{
		t = 940.4963,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:57",
		waveTimerSeconds = 117,
		cashText = "$4,524",
		cashNumber = 4524,
		position = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951))}, -- table table: 0xe544168104802a91
		},
	},
	{
		t = 942.7515,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:55",
		waveTimerSeconds = 115,
		cashText = "$4,301",
		cashNumber = 4301,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 943.5673,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:54",
		waveTimerSeconds = 114,
		cashText = "$3,433",
		cashNumber = 3433,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.5610218048, 1.0000064373, -0.1180443764)}, -- table table: 0xe31d747d585fa3e1
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 943.8515,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:54",
		waveTimerSeconds = 114,
		cashText = "$3,426",
		cashNumber = 3426,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 944.4414,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:53",
		waveTimerSeconds = 113,
		cashText = "$3,426",
		cashNumber = 3426,
		position = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764))}, -- table table: 0xa3f8d38572127d81
		},
	},
	{
		t = 945.9993,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:52",
		waveTimerSeconds = 112,
		cashText = "$3,451",
		cashNumber = 3451,
		position = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764))}, -- table table: 0x78b82b3727f5fb51
		},
	},
	{
		t = 949.3164,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:48",
		waveTimerSeconds = 108,
		cashText = "$3,848",
		cashNumber = 3848,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 952.2634,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:46",
		waveTimerSeconds = 106,
		cashText = "$3,848",
		cashNumber = 3848,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 953.2097,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:45",
		waveTimerSeconds = 105,
		cashText = "$2,543",
		cashNumber = 2543,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(1.8275852203, 1.0000064373, -11.1142406464)}, -- table table: 0x2e84936010860e31
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 953.5138,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:44",
		waveTimerSeconds = 104,
		cashText = "$2,223",
		cashNumber = 2223,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 954.1531,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:44",
		waveTimerSeconds = 104,
		cashText = "$2,223",
		cashNumber = 2223,
		position = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.8275852203, 1.0000125170, -11.1142406464))}, -- table table: 0x0f91d87ba3034b81
		},
	},
	{
		t = 958.2157,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "01:40",
		waveTimerSeconds = 100,
		cashText = "$1,498",
		cashNumber = 1498,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 959.3560,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$2,268",
		cashNumber = 2268,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 960.2672,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$5,522",
		cashNumber = 5522,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 960.6173,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$7,131",
		cashNumber = 7131,
		position = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.8275852203, 1.0000125170, -11.1142406464))}, -- table table: 0x915a04505a74f1c1
		},
	},
	{
		t = 962.4857,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "30 / 35",
		waveNumber = 30,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$4,281",
		cashNumber = 4281,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},

	-- Wave 31 / 35
	{
		t = 964.2435,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "02:00",
		waveTimerSeconds = 120,
		cashText = "$3,114",
		cashNumber = 3114,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.2656192780, 1.0000064373, -10.9164056778)}, -- table table: 0x52ec368558de4be1
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 964.5411,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:59",
		waveTimerSeconds = 119,
		cashText = "$2,656",
		cashNumber = 2656,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 965.1654,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:59",
		waveTimerSeconds = 119,
		cashText = "$2,656",
		cashNumber = 2656,
		position = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778))}, -- table table: 0x4a1236b24e2ac4a1
		},
	},
	{
		t = 967.8374,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:56",
		waveTimerSeconds = 116,
		cashText = "$3,331",
		cashNumber = 3331,
		position = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778))}, -- table table: 0xf59c4d68964aa031
		},
	},
	{
		t = 968.8200,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:55",
		waveTimerSeconds = 115,
		cashText = "$481",
		cashNumber = 481,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 969.6197,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:54",
		waveTimerSeconds = 114,
		cashText = "$879",
		cashNumber = 879,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(1.9299125671, 1.0000064373, -14.7460145950)}, -- table table: 0x53daa0ba2b1b4901
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 969.9055,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:54",
		waveTimerSeconds = 114,
		cashText = "$856",
		cashNumber = 856,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 970.6392,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:53",
		waveTimerSeconds = 113,
		cashText = "$2,356",
		cashNumber = 2356,
		position = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.9299125671, 1.0000125170, -14.7460145950))}, -- table table: 0xc69713706a51c4c1
		},
	},
	{
		t = 972.0858,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:52",
		waveTimerSeconds = 112,
		cashText = "$1,631",
		cashNumber = 1631,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 973.0579,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:51",
		waveTimerSeconds = 111,
		cashText = "$4,031",
		cashNumber = 4031,
		position = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.9299125671, 1.0000125170, -14.7460145950))}, -- table table: 0xf52020022abbf761
		},
	},
	{
		t = 975.3726,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:48",
		waveTimerSeconds = 108,
		cashText = "$6,681",
		cashNumber = 6681,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 5, -- number 5
		},
	},
	{
		t = 976.0789,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:48",
		waveTimerSeconds = 108,
		cashText = "$6,681",
		cashNumber = 6681,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.2577037811, 1.0000064373, -15.0568704605)}, -- table table: 0x06f9ddd1a8d76671
			[4] = "Hunter", -- string Hunter
		},
	},
	{
		t = 977.6254,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:46",
		waveTimerSeconds = 106,
		cashText = "$6,681",
		cashNumber = 6681,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 982.1814,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:42",
		waveTimerSeconds = 102,
		cashText = "$17,702",
		cashNumber = 17702,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 983.7831,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:40",
		waveTimerSeconds = 100,
		cashText = "$18,631",
		cashNumber = 18631,
		position = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764))}, -- table table: 0xa89da56fb2bbf001
		},
	},
	{
		t = 984.3288,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:39",
		waveTimerSeconds = 99,
		cashText = "$9,681",
		cashNumber = 9681,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 985.7761,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:38",
		waveTimerSeconds = 98,
		cashText = "$18,881",
		cashNumber = 18881,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 986.5808,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:37",
		waveTimerSeconds = 97,
		cashText = "$19,781",
		cashNumber = 19781,
		position = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2793903351, 1.0000125170, 1.6213359833))}, -- table table: 0x2a5a2e40f61c1541
		},
	},
	{
		t = 987.6280,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:36",
		waveTimerSeconds = 96,
		cashText = "$10,381",
		cashNumber = 10381,
		position = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.4058761597, 1.0000125170, -1.4597620964))}, -- table table: 0x0e2abdd5c08d4b41
		},
	},
	{
		t = 989.1067,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:35",
		waveTimerSeconds = 95,
		cashText = "$1,356",
		cashNumber = 1356,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 993.2407,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:31",
		waveTimerSeconds = 91,
		cashText = "$1,731",
		cashNumber = 1731,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 994.3546,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:29",
		waveTimerSeconds = 89,
		cashText = "$10,481",
		cashNumber = 10481,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 995.1035,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:29",
		waveTimerSeconds = 89,
		cashText = "$10,481",
		cashNumber = 10481,
		position = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.3619651794, 1.0000125170, -4.6389122009))}, -- table table: 0xf1d63f84988696a1
		},
	},
	{
		t = 995.2938,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:28",
		waveTimerSeconds = 88,
		cashText = "$1,125",
		cashNumber = 1125,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1004.0753,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:20",
		waveTimerSeconds = 80,
		cashText = "$10,956",
		cashNumber = 10956,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1006.1178,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:18",
		waveTimerSeconds = 78,
		cashText = "$12,831",
		cashNumber = 12831,
		position = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.8275852203, 1.0000125170, -11.1142406464))}, -- table table: 0x80a9c14eb13d0e91
		},
	},
	{
		t = 1007.1366,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:17",
		waveTimerSeconds = 77,
		cashText = "$4,681",
		cashNumber = 4681,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1012.7701,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:11",
		waveTimerSeconds = 71,
		cashText = "$14,796",
		cashNumber = 14796,
		position = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403))}, -- table table: 0xb2fcf0070d72a0c1
		},
	},
	{
		t = 1016.9862,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:07",
		waveTimerSeconds = 67,
		cashText = "$14,396",
		cashNumber = 14396,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1017.9947,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:06",
		waveTimerSeconds = 66,
		cashText = "$17,396",
		cashNumber = 17396,
		position = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951))}, -- table table: 0x7b143382253eccb1
		},
	},
	{
		t = 1019.0712,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:05",
		waveTimerSeconds = 65,
		cashText = "$7,996",
		cashNumber = 7996,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1019.3525,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "01:04",
		waveTimerSeconds = 64,
		cashText = "$7,996",
		cashNumber = 7996,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1023.5525,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$12,158",
		cashNumber = 12158,
		position = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778))}, -- table table: 0xfa50cd1e6caee341
		},
	},
	{
		t = 1024.6911,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$4,422",
		cashNumber = 4422,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1026.2974,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "31 / 35",
		waveNumber = 31,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$4,422",
		cashNumber = 4422,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},

	-- Wave 32 / 35
	{
		t = 1028.2340,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:59",
		waveTimerSeconds = 179,
		cashText = "$4,422",
		cashNumber = 4422,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1029.4447,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:57",
		waveTimerSeconds = 177,
		cashText = "$4,422",
		cashNumber = 4422,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1030.4365,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:56",
		waveTimerSeconds = 176,
		cashText = "$4,422",
		cashNumber = 4422,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1035.3887,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:51",
		waveTimerSeconds = 171,
		cashText = "$13,172",
		cashNumber = 13172,
		position = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.9299125671, 1.0000125170, -14.7460145950))}, -- table table: 0x1769158ed26d7b21
		},
	},
	{
		t = 1042.1321,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:45",
		waveTimerSeconds = 165,
		cashText = "$20,612",
		cashNumber = 20612,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1043.4731,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:43",
		waveTimerSeconds = 163,
		cashText = "$22,147",
		cashNumber = 22147,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1043.9095,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:43",
		waveTimerSeconds = 163,
		cashText = "$23,044",
		cashNumber = 23044,
		position = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2793903351, 1.0000125170, 1.6213359833),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2793903351, 1.0000125170, 1.6213359833))}, -- table table: 0x91fe6bc53257f931
		},
	},
	{
		t = 1053.6835,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:33",
		waveTimerSeconds = 153,
		cashText = "$11,022",
		cashNumber = 11022,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1054.3540,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:32",
		waveTimerSeconds = 152,
		cashText = "$11,022",
		cashNumber = 11022,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1062.5162,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:24",
		waveTimerSeconds = 144,
		cashText = "$20,022",
		cashNumber = 20022,
		position = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.4058761597, 1.0000125170, -1.4597620964),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.4058761597, 1.0000125170, -1.4597620964))}, -- table table: 0x48c1a8fbe3d51091
		},
	},
	{
		t = 1063.2995,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:23",
		waveTimerSeconds = 143,
		cashText = "$22",
		cashNumber = 22,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1064.3418,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:22",
		waveTimerSeconds = 142,
		cashText = "$22",
		cashNumber = 22,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1065.3101,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:21",
		waveTimerSeconds = 141,
		cashText = "$5,022",
		cashNumber = 5022,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1077.1519,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:10",
		waveTimerSeconds = 130,
		cashText = "$18,022",
		cashNumber = 18022,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1084.1553,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:03",
		waveTimerSeconds = 123,
		cashText = "$29,022",
		cashNumber = 29022,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1084.7896,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "32 / 35",
		waveNumber = 32,
		waveTimerText = "02:02",
		waveTimerSeconds = 122,
		cashText = "$29,022",
		cashNumber = 29022,
		position = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.2695789337, 1.0000125170, -8.0314064026),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.2695789337, 1.0000125170, -8.0314064026))}, -- table table: 0xb441c2d7e24eebf1
		},
	},

	-- Wave 33 / 35
	{
		t = 1089.3963,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:45",
		waveTimerSeconds = 105,
		cashText = "$15,042",
		cashNumber = 15042,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1091.9805,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:43",
		waveTimerSeconds = 103,
		cashText = "$15,042",
		cashNumber = 15042,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1096.8959,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:38",
		waveTimerSeconds = 98,
		cashText = "$20,642",
		cashNumber = 20642,
		position = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(2.3619651794, 1.0000125170, -4.6389122009),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(2.3619651794, 1.0000125170, -4.6389122009))}, -- table table: 0xe4903c6f93acf7a1
		},
	},
	{
		t = 1098.2835,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:36",
		waveTimerSeconds = 96,
		cashText = "$2,504",
		cashNumber = 2504,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1098.5971,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:36",
		waveTimerSeconds = 96,
		cashText = "$2,504",
		cashNumber = 2504,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1099.4182,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:35",
		waveTimerSeconds = 95,
		cashText = "$4,279",
		cashNumber = 4279,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1100.3090,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:34",
		waveTimerSeconds = 94,
		cashText = "$4,279",
		cashNumber = 4279,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1112.1740,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:23",
		waveTimerSeconds = 83,
		cashText = "$8,518",
		cashNumber = 8518,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1121.4278,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:13",
		waveTimerSeconds = 73,
		cashText = "$20,454",
		cashNumber = 20454,
		position = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.0879154205, 1.0000125170, -4.0790061951))}, -- table table: 0x3a621f21148bd3d1
		},
	},
	{
		t = 1122.7960,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:12",
		waveTimerSeconds = 72,
		cashText = "$1,854",
		cashNumber = 1854,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1124.3638,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$7,854",
		cashNumber = 7854,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1133.3000,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:01",
		waveTimerSeconds = 61,
		cashText = "$21,604",
		cashNumber = 21604,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1134.0646,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:01",
		waveTimerSeconds = 61,
		cashText = "$21,604",
		cashNumber = 21604,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1134.4864,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$10,414",
		cashNumber = 10414,
		position = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.3501224518, 1.0000125170, -7.5127544403))}, -- table table: 0x928d03d57f82a0e1
		},
	},
	{
		t = 1134.4869,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$10,414",
		cashNumber = 10414,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1135.3234,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$1,604",
		cashNumber = 1604,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1137.5277,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$1,604",
		cashNumber = 1604,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4222679138, 1.1000005007, 2.4807815552, 0.3109431565, 0.0000000000, 0.9504284263, 0.0000000000, 0.9999999404, -0.0000000000, -0.9504285455, 0.0000000000, 0.3109431267), pointToEnd = 97.3392466455698}}, -- table table: 0x1664139d9bec9a81
		},
	},
	{
		t = 1137.7397,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$1,105",
		cashNumber = 1105,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4276785851, 1.1000005007, 3.4291815758, 0.3416824043, 0.0000000000, 0.9398155212, 0.0000000000, 1.0000001192, -0.0000000000, -0.9398155212, 0.0000000000, 0.3416824043), pointToEnd = 95.69773210585117}}, -- table table: 0x90a611240559a7f1
		},
	},
	{
		t = 1137.9034,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$4,031",
		cashNumber = 4031,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4276785851, 1.1000005007, 3.4291820526, 0.3416824341, 0.0000000000, 0.9398155212, 0.0000000000, 1.0000001192, -0.0000000000, -0.9398155212, 0.0000000000, 0.3416824341), pointToEnd = 95.69773210585117}}, -- table table: 0x781440ce372ad291
		},
	},
	{
		t = 1138.1244,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$3,605",
		cashNumber = 3605,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4311137199, 1.1000005007, 4.0313086510, 0.3606452644, 0.0000000000, 0.9327030778, 0.0000000000, 1.0000000000, -0.0000000000, -0.9327030778, 0.0000000000, 0.3606452644), pointToEnd = 95.69773210585117}}, -- table table: 0x0659a6001629d321
		},
	},
	{
		t = 1138.3306,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$3,604",
		cashNumber = 3604,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), pointToEnd = 92.95470263063908}}, -- table table: 0xe543af865abb60c1
		},
	},
	{
		t = 1138.5552,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$3,105",
		cashNumber = 3105,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4440994263, 1.1000006199, 6.3077163696, 0.4282876551, 0.0000000000, 0.9036425352, 0.0000000000, 1.0000001192, -0.0000000000, -0.9036425352, 0.0000000000, 0.4282876551), pointToEnd = 92.95470263063908}}, -- table table: 0x03327c47b7d0f0c1
		},
	},
	{
		t = 1138.7638,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$2,605",
		cashNumber = 2605,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4440994263, 1.1000006199, 6.3077163696, 0.4282876551, 0.0000000000, 0.9036425352, 0.0000000000, 1.0000001192, -0.0000000000, -0.9036425352, 0.0000000000, 0.4282876551), pointToEnd = 92.95470263063908}}, -- table table: 0x2a4d85c5ae704be1
		},
	},
	{
		t = 1138.9594,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$2,604",
		cashNumber = 2604,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4451498985, 1.1000006199, 6.4918904305, 0.4334746897, 0.0000000000, 0.9011657238, 0.0000000000, 1.0000000000, -0.0000000000, -0.9011658430, 0.0000000000, 0.4334746301), pointToEnd = 92.95470263063908}}, -- table table: 0x39af8ef1195c2a91
		},
	},
	{
		t = 1139.1739,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$2,105",
		cashNumber = 2105,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4451498985, 1.1000006199, 6.4918904305, 0.4334746897, 0.0000000000, 0.9011657238, 0.0000000000, 1.0000000000, -0.0000000000, -0.9011658430, 0.0000000000, 0.4334746301), pointToEnd = 92.95470263063908}}, -- table table: 0x84565e94fef64231
		},
	},
	{
		t = 1146.1397,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:49",
		waveTimerSeconds = 49,
		cashText = "$27,104",
		cashNumber = 27104,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1146.6816,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$27,104",
		cashNumber = 27104,
		position = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.8275852203, 1.0000125170, -11.1142406464),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.8275852203, 1.0000125170, -11.1142406464))}, -- table table: 0x55bf5018dac70d51
		},
	},
	{
		t = 1147.1621,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$7,104",
		cashNumber = 7104,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1150.4379,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:44",
		waveTimerSeconds = 44,
		cashText = "$15,104",
		cashNumber = 15104,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1151.9672,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:43",
		waveTimerSeconds = 43,
		cashText = "$21,104",
		cashNumber = 21104,
		position = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.2656192780, 1.0000125170, -10.9164056778))}, -- table table: 0x277188a1b4f95021
		},
	},
	{
		t = 1155.7626,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:39",
		waveTimerSeconds = 39,
		cashText = "$11,094",
		cashNumber = 11094,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1159.1431,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:36",
		waveTimerSeconds = 36,
		cashText = "$21,094",
		cashNumber = 21094,
		position = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(1.9299125671, 1.0000125170, -14.7460145950),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(1.9299125671, 1.0000125170, -14.7460145950))}, -- table table: 0x81f88f707fc6c0b1
		},
	},
	{
		t = 1159.3928,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$1,105",
		cashNumber = 1105,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1168.3142,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$14,979",
		cashNumber = 14979,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1169.3945,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$18,215",
		cashNumber = 18215,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1170.3234,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$18,307",
		cashNumber = 18307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1170.5294,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "33 / 35",
		waveNumber = 33,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$18,307",
		cashNumber = 18307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},

	-- Wave 34 / 35
	{
		t = 1179.4339,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:12",
		waveTimerSeconds = 72,
		cashText = "$27,057",
		cashNumber = 27057,
		position = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-1.5610218048, 1.0000125170, -0.1180443764))}, -- table table: 0x0a6f23e2b7d1ee81
		},
	},
	{
		t = 1180.5084,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:11",
		waveTimerSeconds = 71,
		cashText = "$7,507",
		cashNumber = 7507,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1181.1421,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:11",
		waveTimerSeconds = 71,
		cashText = "$6,909",
		cashNumber = 6909,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-9.6156196594, 1.0000064373, -5.3303546906)}, -- table table: 0xd31e554a39f760d1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1181.4504,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$6,907",
		cashNumber = 6907,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1181.7959,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$6,907",
		cashNumber = 6907,
		position = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906))}, -- table table: 0x682101a81d8068a1
		},
	},
	{
		t = 1181.9967,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$6,608",
		cashNumber = 6608,
		position = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906))}, -- table table: 0xa6f521226207bce1
		},
	},
	{
		t = 1182.1936,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$5,760",
		cashNumber = 5760,
		position = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906))}, -- table table: 0xee8e454267f25071
		},
	},
	{
		t = 1182.1941,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:10",
		waveTimerSeconds = 70,
		cashText = "$5,760",
		cashNumber = 5760,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1183.1002,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:09",
		waveTimerSeconds = 69,
		cashText = "$13,107",
		cashNumber = 13107,
		position = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.6156196594, 1.0000125170, -5.3303546906))}, -- table table: 0x701b7ea044bef7a1
		},
	},
	{
		t = 1183.4924,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:08",
		waveTimerSeconds = 68,
		cashText = "$5,557",
		cashNumber = 5557,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1184.1423,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:08",
		waveTimerSeconds = 68,
		cashText = "$5,411",
		cashNumber = 5411,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-12.8391799927, 1.0000064373, -5.4555997849)}, -- table table: 0x4fca083389705951
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1184.4650,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:07",
		waveTimerSeconds = 67,
		cashText = "$5,407",
		cashNumber = 5407,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1184.7814,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:07",
		waveTimerSeconds = 67,
		cashText = "$5,407",
		cashNumber = 5407,
		position = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849))}, -- table table: 0x69b9776f1af1ee81
		},
	},
	{
		t = 1184.9691,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:07",
		waveTimerSeconds = 67,
		cashText = "$4,739",
		cashNumber = 4739,
		position = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849))}, -- table table: 0xc24f62eb5359d1a1
		},
	},
	{
		t = 1185.1020,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:07",
		waveTimerSeconds = 67,
		cashText = "$4,264",
		cashNumber = 4264,
		position = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849))}, -- table table: 0x1b3ad7bccff86671
		},
	},
	{
		t = 1187.7106,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:04",
		waveTimerSeconds = 64,
		cashText = "$10,257",
		cashNumber = 10257,
		position = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-12.8391799927, 1.0000125170, -5.4555997849))}, -- table table: 0x09872d5a663cfbb1
		},
	},
	{
		t = 1188.3595,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:03",
		waveTimerSeconds = 63,
		cashText = "$3,657",
		cashNumber = 3657,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1189.3025,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$3,060",
		cashNumber = 3060,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(10.9910888672, 1.0000064373, 6.2987241745)}, -- table table: 0xb281cd950b48e851
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1189.6257,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$3,057",
		cashNumber = 3057,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1189.9244,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$3,057",
		cashNumber = 3057,
		position = Vector3.new(10.9910888672, 1.0000125170, 6.2987241745),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.9910888672, 1.0000125170, 6.2987241745),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.9910888672, 1.0000125170, 6.2987241745))}, -- table table: 0xcedaa388be0f1b81
		},
	},
	{
		t = 1190.1261,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:02",
		waveTimerSeconds = 62,
		cashText = "$2,495",
		cashNumber = 2495,
		position = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.9910888672, 1.0000123978, 6.2987241745))}, -- table table: 0xc230ed36fce04fa1
		},
	},
	{
		t = 1191.2367,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:01",
		waveTimerSeconds = 61,
		cashText = "$10,323",
		cashNumber = 10323,
		position = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.9910888672, 1.0000123978, 6.2987241745))}, -- table table: 0x89faaeafe3806fd1
		},
	},
	{
		t = 1191.7716,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$8,942",
		cashNumber = 8942,
		position = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.9910888672, 1.0000123978, 6.2987241745),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.9910888672, 1.0000123978, 6.2987241745))}, -- table table: 0xa7b5b1ec63ccbd61
		},
	},
	{
		t = 1192.1926,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "01:00",
		waveTimerSeconds = 60,
		cashText = "$4,107",
		cashNumber = 4107,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1193.0343,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$4,924",
		cashNumber = 4924,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(10.5779609680, 1.0000064373, 9.8459300995)}, -- table table: 0x1fec5d75d7eebbd1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1193.3372,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:59",
		waveTimerSeconds = 59,
		cashText = "$4,907",
		cashNumber = 4907,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1193.9088,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$4,907",
		cashNumber = 4907,
		position = Vector3.new(10.5779609680, 1.0000123978, 9.8459300995),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5779609680, 1.0000123978, 9.8459300995),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5779609680, 1.0000123978, 9.8459300995))}, -- table table: 0xa1d21a86e66148e1
		},
	},
	{
		t = 1194.0459,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$4,615",
		cashNumber = 4615,
		position = Vector3.new(10.5779609680, 1.0000123978, 9.8459300995),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5779609680, 1.0000123978, 9.8459300995),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5779609680, 1.0000123978, 9.8459300995))}, -- table table: 0x1d3b2d4d7bb5ac11
		},
	},
	{
		t = 1194.2550,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:58",
		waveTimerSeconds = 58,
		cashText = "$5,146",
		cashNumber = 5146,
		position = Vector3.new(10.5779609680, 1.0000125170, 9.8459300995),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5779609680, 1.0000125170, 9.8459300995),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5779609680, 1.0000125170, 9.8459300995))}, -- table table: 0xc3900066509ea101
		},
	},
	{
		t = 1194.4254,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$2,432",
		cashNumber = 2432,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1194.6407,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:57",
		waveTimerSeconds = 57,
		cashText = "$5,982",
		cashNumber = 5982,
		position = Vector3.new(10.5779609680, 1.0000125170, 9.8459300995),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.5779609680, 1.0000125170, 9.8459300995),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.5779609680, 1.0000125170, 9.8459300995))}, -- table table: 0xdcc6c690cd3543f1
		},
	},
	{
		t = 1195.6007,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$1,907",
		cashNumber = 1907,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1196.5122,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:56",
		waveTimerSeconds = 56,
		cashText = "$1,307",
		cashNumber = 1307,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-10.2589025497, 1.0000064373, -0.4389753342)}, -- table table: 0xe2719a032d905021
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1196.8331,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$8,728",
		cashNumber = 8728,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1197.0958,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$9,415",
		cashNumber = 9415,
		position = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342))}, -- table table: 0x7a2d9eaaf80f6381
		},
	},
	{
		t = 1197.2788,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:55",
		waveTimerSeconds = 55,
		cashText = "$9,907",
		cashNumber = 9907,
		position = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342))}, -- table table: 0x209353a5cc763bb1
		},
	},
	{
		t = 1197.4605,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:54",
		waveTimerSeconds = 54,
		cashText = "$9,061",
		cashNumber = 9061,
		position = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342))}, -- table table: 0xf2d0de13e750f821
		},
	},
	{
		t = 1201.1717,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:51",
		waveTimerSeconds = 51,
		cashText = "$15,207",
		cashNumber = 15207,
		position = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-10.2589025497, 1.0000125170, -0.4389753342))}, -- table table: 0xe15d09d4c08d4cb1
		},
	},
	{
		t = 1203.3281,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$14,707",
		cashNumber = 14707,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1203.3886,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:48",
		waveTimerSeconds = 48,
		cashText = "$14,707",
		cashNumber = 14707,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 3, -- number 3
		},
	},
	{
		t = 1204.5409,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,745",
		cashNumber = 21745,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-0.7596836090, 1.0000064373, 10.5257148743)}, -- table table: 0x22321b3c99430961
			[4] = "Freezer", -- string Freezer
		},
	},
	{
		t = 1204.6126,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,756",
		cashNumber = 21756,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1204.8337,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,757",
		cashNumber = 21757,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Freezer", -- string Freezer
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1204.9347,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,757",
		cashNumber = 21757,
		position = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743))}, -- table table: 0xe9248654895f9c31
		},
	},
	{
		t = 1205.0705,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,467",
		cashNumber = 21467,
		position = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743))}, -- table table: 0xe3a9656e98889f11
		},
	},
	{
		t = 1205.2392,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:47",
		waveTimerSeconds = 47,
		cashText = "$21,011",
		cashNumber = 21011,
		position = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-0.7596836090, 1.0000125170, 10.5257148743))}, -- table table: 0xc06f0e10f9d8c0b1
		},
	},
	{
		t = 1205.4341,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:46",
		waveTimerSeconds = 46,
		cashText = "$19,315",
		cashNumber = 19315,
		position = Vector3.new(-0.7596836090, 1.0000123978, 10.5257148743),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-0.7596836090, 1.0000123978, 10.5257148743),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-0.7596836090, 1.0000123978, 10.5257148743))}, -- table table: 0x6909a921e596b311
		},
	},
	{
		t = 1205.4347,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:46",
		waveTimerSeconds = 46,
		cashText = "$19,315",
		cashNumber = 19315,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1208.2566,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:44",
		waveTimerSeconds = 44,
		cashText = "$29,806",
		cashNumber = 29806,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1209.0117,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:43",
		waveTimerSeconds = 43,
		cashText = "$29,212",
		cashNumber = 29212,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-9.9845685959, 1.0000064373, 2.9424037933)}, -- table table: 0x0830629a3b819141
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1209.2966,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:43",
		waveTimerSeconds = 43,
		cashText = "$29,207",
		cashNumber = 29207,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1209.6374,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:42",
		waveTimerSeconds = 42,
		cashText = "$29,207",
		cashNumber = 29207,
		position = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933))}, -- table table: 0x268de6719f54d8a1
		},
	},
	{
		t = 1209.8342,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:42",
		waveTimerSeconds = 42,
		cashText = "$28,908",
		cashNumber = 28908,
		position = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933))}, -- table table: 0x9e6c4076633e23c1
		},
	},
	{
		t = 1209.9653,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:42",
		waveTimerSeconds = 42,
		cashText = "$28,085",
		cashNumber = 28085,
		position = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933))}, -- table table: 0x656eb6172c10a5d1
		},
	},
	{
		t = 1210.1596,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:42",
		waveTimerSeconds = 42,
		cashText = "$25,317",
		cashNumber = 25317,
		position = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.9845685959, 1.0000125170, 2.9424037933))}, -- table table: 0x7cd8ad79270b2de1
		},
	},
	{
		t = 1210.9326,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:41",
		waveTimerSeconds = 41,
		cashText = "$24,807",
		cashNumber = 24807,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1211.4187,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$24,457",
		cashNumber = 24457,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-9.7834424973, 1.0000064373, 5.9366941452)}, -- table table: 0x2a826a032e956ca1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1211.7195,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$24,207",
		cashNumber = 24207,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1211.9347,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$24,207",
		cashNumber = 24207,
		position = Vector3.new(-9.7834424973, 1.0000125170, 5.9366941452),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.7834424973, 1.0000125170, 5.9366941452),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.7834424973, 1.0000125170, 5.9366941452))}, -- table table: 0xcc9762af0002c9e1
		},
	},
	{
		t = 1212.0879,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$23,912",
		cashNumber = 23912,
		position = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452))}, -- table table: 0x761cc1d7e77b6b11
		},
	},
	{
		t = 1212.2331,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:40",
		waveTimerSeconds = 40,
		cashText = "$23,072",
		cashNumber = 23072,
		position = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452))}, -- table table: 0x407dfae0eb4b5811
		},
	},
	{
		t = 1212.4312,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:39",
		waveTimerSeconds = 39,
		cashText = "$20,316",
		cashNumber = 20316,
		position = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.7834424973, 1.0000123978, 5.9366941452))}, -- table table: 0xead2cde880c1d811
		},
	},
	{
		t = 1213.1717,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:39",
		waveTimerSeconds = 39,
		cashText = "$12,307",
		cashNumber = 12307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1214.4010,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:38",
		waveTimerSeconds = 38,
		cashText = "$11,914",
		cashNumber = 11914,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-9.8009395599, 1.0000064373, 9.5996313095)}, -- table table: 0x3c727abc8b005ca1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1214.6900,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:37",
		waveTimerSeconds = 37,
		cashText = "$11,707",
		cashNumber = 11707,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1215.0881,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:37",
		waveTimerSeconds = 37,
		cashText = "$11,707",
		cashNumber = 11707,
		position = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095))}, -- table table: 0x7be55851d79226c1
		},
	},
	{
		t = 1215.2216,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:37",
		waveTimerSeconds = 37,
		cashText = "$11,416",
		cashNumber = 11416,
		position = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095))}, -- table table: 0x167dd390e9f68ea1
		},
	},
	{
		t = 1215.4413,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:36",
		waveTimerSeconds = 36,
		cashText = "$9,908",
		cashNumber = 9908,
		position = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095))}, -- table table: 0xe12155d589accb81
		},
	},
	{
		t = 1217.1840,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:35",
		waveTimerSeconds = 35,
		cashText = "$7,807",
		cashNumber = 7807,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1220.9523,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:31",
		waveTimerSeconds = 31,
		cashText = "$9,307",
		cashNumber = 9307,
		position = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.8009395599, 1.0000125170, 9.5996313095))}, -- table table: 0x5532c1b076f098a1
		},
	},
	{
		t = 1221.4805,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:30",
		waveTimerSeconds = 30,
		cashText = "$3,508",
		cashNumber = 3508,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1222.6606,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:29",
		waveTimerSeconds = 29,
		cashText = "$5,208",
		cashNumber = 5208,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-13.3197450638, 1.0000064373, -1.6679697037)}, -- table table: 0x39aafba0285b1dd1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1222.9889,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:29",
		waveTimerSeconds = 29,
		cashText = "$5,207",
		cashNumber = 5207,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1223.4652,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:28",
		waveTimerSeconds = 28,
		cashText = "$5,957",
		cashNumber = 5957,
		position = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037))}, -- table table: 0xa3ee5b52aa1f2d01
		},
	},
	{
		t = 1223.6451,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:28",
		waveTimerSeconds = 28,
		cashText = "$5,659",
		cashNumber = 5659,
		position = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037))}, -- table table: 0x63b3c3084ed5f121
		},
	},
	{
		t = 1223.7994,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:28",
		waveTimerSeconds = 28,
		cashText = "$6,464",
		cashNumber = 6464,
		position = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037))}, -- table table: 0x13f5fb96db4eb931
		},
	},
	{
		t = 1226.5001,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$8,576",
		cashNumber = 8576,
		position = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.3197450638, 1.0000125170, -1.6679697037))}, -- table table: 0xd882b1a8bb4bec71
		},
	},
	{
		t = 1226.9828,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:25",
		waveTimerSeconds = 25,
		cashText = "$1,557",
		cashNumber = 1557,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1228.2484,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:24",
		waveTimerSeconds = 24,
		cashText = "$3,964",
		cashNumber = 3964,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-13.1304044724, 1.0000064373, 1.7605981827)}, -- table table: 0xf361036f24ab8781
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1228.5730,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:23",
		waveTimerSeconds = 23,
		cashText = "$4,667",
		cashNumber = 4667,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1229.4647,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:22",
		waveTimerSeconds = 22,
		cashText = "$6,877",
		cashNumber = 6877,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1229.5107,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:22",
		waveTimerSeconds = 22,
		cashText = "$6,941",
		cashNumber = 6941,
		position = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827))}, -- table table: 0x30af3b898fe3a481
		},
	},
	{
		t = 1229.7164,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:22",
		waveTimerSeconds = 22,
		cashText = "$6,300",
		cashNumber = 6300,
		position = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827))}, -- table table: 0x0eb289191f1deab1
		},
	},
	{
		t = 1230.3685,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:21",
		waveTimerSeconds = 21,
		cashText = "$7,307",
		cashNumber = 7307,
		position = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827))}, -- table table: 0xda4e09206ab4ef71
		},
	},
	{
		t = 1232.3715,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:19",
		waveTimerSeconds = 19,
		cashText = "$6,301",
		cashNumber = 6301,
		position = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1304044724, 1.0000125170, 1.7605981827))}, -- table table: 0xc8d7b30e34389851
		},
	},
	{
		t = 1232.7415,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:19",
		waveTimerSeconds = 19,
		cashText = "$1,807",
		cashNumber = 1807,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1233.9310,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:18",
		waveTimerSeconds = 18,
		cashText = "$1,227",
		cashNumber = 1227,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-13.1500110626, 1.0000064373, 4.9634590149)}, -- table table: 0x32264e8c10917761
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1234.2271,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:18",
		waveTimerSeconds = 18,
		cashText = "$1,207",
		cashNumber = 1207,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1234.8439,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:17",
		waveTimerSeconds = 17,
		cashText = "$1,207",
		cashNumber = 1207,
		position = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149))}, -- table table: 0xc4a81b845b66b821
		},
	},
	{
		t = 1234.9248,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:17",
		waveTimerSeconds = 17,
		cashText = "$958",
		cashNumber = 958,
		position = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149))}, -- table table: 0x34e5803216fb1ec1
		},
	},
	{
		t = 1236.4956,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:15",
		waveTimerSeconds = 15,
		cashText = "$2,613",
		cashNumber = 2613,
		position = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149))}, -- table table: 0x698071c068dd6ab1
		},
	},
	{
		t = 1238.3455,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:13",
		waveTimerSeconds = 13,
		cashText = "$3,307",
		cashNumber = 3307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1239.4282,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:12",
		waveTimerSeconds = 12,
		cashText = "$3,307",
		cashNumber = 3307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1240.3358,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:11",
		waveTimerSeconds = 11,
		cashText = "$6,307",
		cashNumber = 6307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1241.9367,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:10",
		waveTimerSeconds = 10,
		cashText = "$12,307",
		cashNumber = 12307,
		position = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.1500110626, 1.0000125170, 4.9634590149))}, -- table table: 0xece44bfa75d48f21
		},
	},
	{
		t = 1242.4070,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:09",
		waveTimerSeconds = 9,
		cashText = "$7,307",
		cashNumber = 7307,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1244.3147,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:08",
		waveTimerSeconds = 8,
		cashText = "$9,712",
		cashNumber = 9712,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-13.0851325989, 1.0000064373, 8.3943510056)}, -- table table: 0xd38e4dcd302bbff1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1244.6168,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:07",
		waveTimerSeconds = 7,
		cashText = "$9,707",
		cashNumber = 9707,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1244.8814,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:07",
		waveTimerSeconds = 7,
		cashText = "$9,707",
		cashNumber = 9707,
		position = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056))}, -- table table: 0x8d3a7c1455e17a61
		},
	},
	{
		t = 1245.0946,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:07",
		waveTimerSeconds = 7,
		cashText = "$9,408",
		cashNumber = 9408,
		position = Vector3.new(-13.0851325989, 1.0000123978, 8.3943510056),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0851325989, 1.0000123978, 8.3943510056),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0851325989, 1.0000123978, 8.3943510056))}, -- table table: 0xdec98b1dd1c43db1
		},
	},
	{
		t = 1245.2169,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:07",
		waveTimerSeconds = 7,
		cashText = "$8,596",
		cashNumber = 8596,
		position = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056))}, -- table table: 0x17a04cbbce874a61
		},
	},
	{
		t = 1245.5964,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:06",
		waveTimerSeconds = 6,
		cashText = "$8,777",
		cashNumber = 8777,
		position = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0851325989, 1.0000125170, 8.3943510056))}, -- table table: 0x7d6d0c84bfbc9321
		},
	},
	{
		t = 1252.1993,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:05",
		waveTimerSeconds = 5,
		cashText = "$29,807",
		cashNumber = 29807,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1253.0965,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:04",
		waveTimerSeconds = 4,
		cashText = "$34,383",
		cashNumber = 34383,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1253.9905,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$33,800",
		cashNumber = 33800,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-13.0012655258, 1.0000064373, 11.6822853088)}, -- table table: 0xaf32bebdb9426861
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1254.3073,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:03",
		waveTimerSeconds = 3,
		cashText = "$33,783",
		cashNumber = 33783,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1254.4332,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$33,783",
		cashNumber = 33783,
		position = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088))}, -- table table: 0xc6f74c4f3b8cdca1
		},
	},
	{
		t = 1254.5890,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$33,487",
		cashNumber = 33487,
		position = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088))}, -- table table: 0x18eec355c63d4061
		},
	},
	{
		t = 1254.8528,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$32,634",
		cashNumber = 32634,
		position = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088))}, -- table table: 0x008b952cc237f271
		},
	},
	{
		t = 1254.9742,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:02",
		waveTimerSeconds = 2,
		cashText = "$29,919",
		cashNumber = 29919,
		position = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-13.0012655258, 1.0000125170, 11.6822853088))}, -- table table: 0x8d5521af30d526c1
		},
	},
	{
		t = 1255.4919,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$21,883",
		cashNumber = 21883,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1256.0738,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "34 / 35",
		waveNumber = 34,
		waveTimerText = "00:01",
		waveTimerSeconds = 1,
		cashText = "$21,361",
		cashNumber = 21361,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-9.3235845566, 1.0000064373, 12.7586860657)}, -- table table: 0xd923bd8e40280521
			[4] = "Militant", -- string Militant
		},
	},

	-- Wave 35 / 35
	{
		t = 1256.3958,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$21,283",
		cashNumber = 21283,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1256.6047,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$21,283",
		cashNumber = 21283,
		position = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657))}, -- table table: 0x40ceeb86a504a3c1
		},
	},
	{
		t = 1256.6965,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$21,019",
		cashNumber = 21019,
		position = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657))}, -- table table: 0xca84ee0b08c991a1
		},
	},
	{
		t = 1256.8958,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$20,135",
		cashNumber = 20135,
		position = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657))}, -- table table: 0x41fc339d7f2f37a1
		},
	},
	{
		t = 1257.0600,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$17,412",
		cashNumber = 17412,
		position = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(-9.3235845566, 1.0000125170, 12.7586860657))}, -- table table: 0x3139138c6584c071
		},
	},
	{
		t = 1257.6484,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$9,383",
		cashNumber = 9383,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1259.2142,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$8,783",
		cashNumber = 8783,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(10.0921726227, 1.0000064373, 13.4594688416)}, -- table table: 0xd33b58e094543ce1
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1259.5019,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$8,783",
		cashNumber = 8783,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1259.7360,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$8,783",
		cashNumber = 8783,
		position = Vector3.new(10.0921726227, 1.0000125170, 13.4594688416),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.0921726227, 1.0000125170, 13.4594688416),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.0921726227, 1.0000125170, 13.4594688416))}, -- table table: 0x8d2e4c9f866996a1
		},
	},
	{
		t = 1259.8994,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$8,486",
		cashNumber = 8486,
		position = Vector3.new(10.0921726227, 1.0000123978, 13.4594688416),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.0921726227, 1.0000123978, 13.4594688416),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.0921726227, 1.0000123978, 13.4594688416))}, -- table table: 0xf2d7a953f84786b1
		},
	},
	{
		t = 1260.0321,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$7,660",
		cashNumber = 7660,
		position = Vector3.new(10.0921726227, 1.0000123978, 13.4594688416),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.0921726227, 1.0000123978, 13.4594688416),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.0921726227, 1.0000123978, 13.4594688416))}, -- table table: 0x4083ff3b41f9b4f1
		},
	},
	{
		t = 1262.1295,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$4,883",
		cashNumber = 4883,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1263.2956,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$12,383",
		cashNumber = 12383,
		position = Vector3.new(10.0921726227, 1.0000125170, 13.4594688416),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(10.0921726227, 1.0000125170, 13.4594688416),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(10.0921726227, 1.0000125170, 13.4594688416))}, -- table table: 0xeb8746aa0c9ef2c1
		},
	},
	{
		t = 1263.6514,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$4,383",
		cashNumber = 4383,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1264.1899,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$3,789",
		cashNumber = 3789,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(14.5102357864, 1.0000064373, 10.5685119629)}, -- table table: 0x711aad73cf2e8831
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1264.4133,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$3,783",
		cashNumber = 3783,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1264.5390,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$3,783",
		cashNumber = 3783,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1264.7714,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$3,783",
		cashNumber = 3783,
		position = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.5102357864, 1.0000125170, 10.5685119629))}, -- table table: 0x3e91b680d71eab31
		},
	},
	{
		t = 1264.9003,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$3,493",
		cashNumber = 3493,
		position = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.5102357864, 1.0000125170, 10.5685119629))}, -- table table: 0xe31c5eb84a5a2281
		},
	},
	{
		t = 1266.1111,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$10,133",
		cashNumber = 10133,
		position = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.5102357864, 1.0000125170, 10.5685119629))}, -- table table: 0xe7fb06766f276651
		},
	},
	{
		t = 1268.8242,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$15,607",
		cashNumber = 15607,
		position = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		troopPath = "Workspace.Towers.Default",
		troopClass = "Model",
		troopPosition = Vector3.new(14.5102357864, 1.0000125170, 10.5685119629),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Upgrade", -- string Upgrade
			[3] = "Set", -- string Set
			[4] = {Troop = findInstance("Workspace.Towers.Default", "Model", Vector3.new(14.5102357864, 1.0000125170, 10.5685119629))}, -- table table: 0x9ec8a0520e40aca1
		},
	},
	{
		t = 1269.2954,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$7,633",
		cashNumber = 7633,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 3,
		args = {
			[1] = "Hotbar", -- string Hotbar
			[2] = "Click", -- string Click
			[3] = 1, -- number 1
		},
	},
	{
		t = 1270.3337,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$7,633",
		cashNumber = 7633,
		position = Vector3.new(0.0000000000, 0.0000000000, 0.0000000000),
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Place", -- string Place
			[3] = {Rotation = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, -0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), Position = Vector3.new(-1.3399515152, 1.0000064373, -14.2888059616)}, -- table table: 0x80a06857bcdcdb71
			[4] = "Militant", -- string Militant
		},
	},
	{
		t = 1273.3576,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$25,108",
		cashNumber = 25108,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1274.4337,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$25,108",
		cashNumber = 25108,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1275.3596,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$34,008",
		cashNumber = 34008,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1287.2243,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$41,008",
		cashNumber = 41008,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1299.5288,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$70,997",
		cashNumber = 70997,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1304.9428,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$81,008",
		cashNumber = 81008,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.3941702843, 1.1000003815, -2.4445528984, 0.0108768726, 0.0000000000, 0.9999408722, 0.0000000000, 1.0000000000, -0.0000000000, -0.9999408722, 0.0000000000, 0.0108768726), pointToEnd = 101.74244572222233}}, -- table table: 0xeb297e44cde65d21
		},
	},
	{
		t = 1305.1562,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$80,509",
		cashNumber = 80509,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.3964223862, 1.1000003815, -2.0497331619, 0.0409016795, 0.0000000000, 0.9991631508, 0.0000000000, 1.0000001192, -0.0000000000, -0.9991632700, 0.0000000000, 0.0409016758), pointToEnd = 101.74244572222233}}, -- table table: 0xfc12611624b096e1
		},
	},
	{
		t = 1305.5702,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$83,507",
		cashNumber = 83507,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), pointToEnd = 100.45470358431339}}, -- table table: 0x6af3182cd7449d51
		},
	},
	{
		t = 1306.0191,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$84,459",
		cashNumber = 84459,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), pointToEnd = 100.45470358431339}}, -- table table: 0xdaef20a9368476b1
		},
	},
	{
		t = 1306.2211,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$84,439",
		cashNumber = 84439,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4051556587, 1.1000003815, -0.5188447833, 0.0861650631, 0.0000000000, 0.9962809086, 0.0000000000, 1.0000001192, -0.0000000000, -0.9962809086, 0.0000000000, 0.0861650631), pointToEnd = 100.45470358431339}}, -- table table: 0x81c7eed5d1875b41
		},
	},
	{
		t = 1306.4663,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$84,622",
		cashNumber = 84622,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4077844620, 1.1000003815, -0.0580729544, 0.0922383964, 0.0000000000, 0.9957370162, 0.0000000000, 1.0000001192, -0.0000000000, -0.9957370162, 0.0000000000, 0.0922383964), pointToEnd = 98.97207523882389}}, -- table table: 0xf571e55a67434e11
		},
	},
	{
		t = 1306.7029,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$86,007",
		cashNumber = 86007,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(6.4102344513, 1.1000003815, 0.3714038730, 0.1069081202, 0.0000000000, 0.9942688942, 0.0000000000, 1.0000000000, -0.0000000000, -0.9942688942, 0.0000000000, 0.1069081202), pointToEnd = 98.97207523882389}}, -- table table: 0x36e4e64b43b1cc21
		},
	},
	{
		t = 1308.3636,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$95,712",
		cashNumber = 95712,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1309.4658,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$98,750",
		cashNumber = 98750,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1310.4000,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$102,035",
		cashNumber = 102035,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1322.2237,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$142,578",
		cashNumber = 142578,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1334.4360,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$193,257",
		cashNumber = 193257,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1343.3743,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$230,758",
		cashNumber = 230758,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1344.4364,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$235,579",
		cashNumber = 235579,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1345.3758,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$240,751",
		cashNumber = 240751,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1357.2700,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$270,758",
		cashNumber = 270758,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1369.4601,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$270,758",
		cashNumber = 270758,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1377.0399,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$270,758",
		cashNumber = 270758,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.6664743423, 1.1000015736, 12.1933994293, 0.6292558908, 0.0000000000, 0.7771981955, 0.0000000000, 1.0000000000, -0.0000000000, -0.7771983147, 0.0000000000, 0.6292558312), pointToEnd = 76.51016102731228}}, -- table table: 0x4e58fc110a3dcfb1
		},
	},
	{
		t = 1377.2333,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$270,260",
		cashNumber = 270260,
		position = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-24.0490398407, 1.0099967718, -18.1452789307)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.6232786179, 1.1000015736, 12.2437982559, 0.6286178827, 0.0000000000, 0.7777142525, 0.0000000000, 1.0000000000, -0.0000000000, -0.7777143717, 0.0000000000, 0.6286178231), pointToEnd = 76.51016102731228}}, -- table table: 0xee50f06c9d22c541
		},
	},
	{
		t = 1377.4101,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$270,258",
		cashNumber = 270258,
		position = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-28.7406597137, 1.0500061512, -11.5174064636)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.6339740753, 1.1000015736, 12.2313194275, 0.6293351650, 0.0000000000, 0.7771340013, 0.0000000000, 1.0000000000, -0.0000000000, -0.7771340013, 0.0000000000, 0.6293351650), pointToEnd = 76.51016102731228}}, -- table table: 0xd488c67e0de64cb1
		},
	},
	{
		t = 1377.8184,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$269,758",
		cashNumber = 269758,
		position = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-29.9127788544, 1.0118863583, -16.7649631500)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000, 1.0000000000), pointToEnd = 76.51016102731228}}, -- table table: 0x619dd178c73f1581
		},
	},
	{
		t = 1378.0466,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$269,259",
		cashNumber = 269259,
		position = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-31.5818862915, 1.0099961758, -21.5850982666)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.6748976707, 1.1000015736, 12.1835718155, 0.6301926970, 0.0000000000, 0.7764388323, 0.0000000000, 1.0000000000, -0.0000000000, -0.7764388323, 0.0000000000, 0.6301926970), pointToEnd = 76.51016102731228}}, -- table table: 0xc2eebef8a34cf761
		},
	},
	{
		t = 1378.2374,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,760",
		cashNumber = 268760,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.6478366852, 1.1000015736, 12.2151451111, 0.6281610131, 0.0000000000, 0.7780833840, 0.0000000000, 1.0000000000, -0.0000000000, -0.7780833840, 0.0000000000, 0.6281610131), pointToEnd = 76.51016102731228}}, -- table table: 0xda007225e8db9481
		},
	},
	{
		t = 1378.4339,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,260",
		cashNumber = 268260,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1378.4503,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,259",
		cashNumber = 268259,
		position = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		troopPath = "Workspace.Towers.Classic",
		troopClass = "Model",
		troopPosition = Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394),
		n = 4,
		args = {
			[1] = "Troops", -- string Troops
			[2] = "Abilities", -- string Abilities
			[3] = "Activate", -- string Activate
			[4] = {Troop = findInstance("Workspace.Towers.Classic", "Model", Vector3.new(-35.7213668823, 1.0000064373, -16.3223991394)), Name = "Airstrike", Data = {pathName = 1, directionCFrame = CFrame.new(-4.7589378357, 1.1000015736, 12.0825624466, 0.6297869086, 0.0000000000, 0.7767680287, 0.0000000000, 1.0000001192, -0.0000000000, -0.7767680287, 0.0000000000, 0.6297869086), pointToEnd = 76.07828809320927}}, -- table table: 0x55d4635ab8101c01
		},
	},
	{
		t = 1379.4832,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,258",
		cashNumber = 268258,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1380.3741,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,258",
		cashNumber = 268258,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1392.2651,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$268,258",
		cashNumber = 268258,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1404.4754,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$273,258",
		cashNumber = 273258,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1413.4342,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$310,749",
		cashNumber = 310749,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1414.5335,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$315,460",
		cashNumber = 315460,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1415.4154,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$318,257",
		cashNumber = 318257,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1427.3510,
		method = "InvokeServer",
		remotePath = "ReplicatedStorage.RemoteFunction",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$350,758",
		cashNumber = 350758,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 5,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectUnit", -- string SelectUnit
			[3] = "Railgun Tank", -- string Railgun Tank
			[4] = "Classic", -- string Classic
			[5] = true, -- boolean true
		},
	},
	{
		t = 1438.5944,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Farm", -- string Farm
			[4] = "Arcade", -- string Arcade
		},
	},
	{
		t = 1438.5949,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Hunter", -- string Hunter
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1438.5951,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Freezer", -- string Freezer
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1438.5953,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Military Base", -- string Military Base
			[4] = "Classic", -- string Classic
		},
	},
	{
		t = 1438.5955,
		method = "FireServer",
		remotePath = "ReplicatedStorage.RemoteEvent",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 4,
		args = {
			[1] = "Streaming", -- string Streaming
			[2] = "SelectTower", -- string SelectTower
			[3] = "Militant", -- string Militant
			[4] = "Default", -- string Default
		},
	},
	{
		t = 1448.3386,
		method = "FireServer",
		remotePath = "ReplicatedStorage.Network.Teleport.RE:backToLobby",
		waveText = "35 / 35",
		waveNumber = 35,
		waveTimerText = "ÃƒÂ¢Ã‹â€ Ã…Â¾",
		waveTimerSeconds = nil,
		cashText = "$357,359",
		cashNumber = 357359,
		position = nil,
		troopPath = nil,
		troopClass = nil,
		troopPosition = nil,
		n = 0,
		args = {
		},
	},
}

local function parseNumberText(text)
	text = tostring(text or ""):gsub(",", ""):gsub("%$", "")
	local number = text:match("[-]?%d+")
	return number and tonumber(number) or nil
end

local function getCashNumber()
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player and player:FindFirstChild("PlayerGui")
	local hotbar = playerGui and playerGui:FindFirstChild("ReactUniversalHotbar")
	local amount = hotbar
		and hotbar:FindFirstChild("Frame")
		and hotbar.Frame:FindFirstChild("values")
		and hotbar.Frame.values:FindFirstChild("cash")
		and hotbar.Frame.values.cash:FindFirstChild("amount")
	if not amount and hotbar then amount = hotbar:FindFirstChild("amount", true) end
	if amount and amount:IsA("TextLabel") then return parseNumberText(amount.Text) end
	return nil
end

local function waitForRecordedCash(call)
	if not isTroopUpgrade(call) then return end
	local needed = tonumber(call.cashNumber)
	if not needed or needed <= 0 then return end
	local stopAt = os.clock() + 45
	while os.clock() < stopAt do
		local cash = getCashNumber()
		if not cash or cash >= needed then return end
		task.wait(0.15)
	end
	warn("Cash wait timed out:", call.args[1], call.args[2], "needed", needed, "cash", getCashNumber())
end

local started = os.clock()
local currentReplayWave = nil
for _, call in ipairs(calls) do
	local waitTime = call.t - (os.clock() - started)
	if waitTime > 0 then task.wait(waitTime) end
	if call.waveText ~= currentReplayWave then
		currentReplayWave = call.waveText
		print("Replay Wave:", currentReplayWave)
	end
	local remote = findPath(call.remotePath)
	if remote then
		fixTroopArg(call)
		if call.method == "FireServer" then
			remote:FireServer(table.unpack(call.args, 1, call.n))
		elseif call.method == "InvokeServer" then
			waitForRecordedCash(call)
			local tries = isTroopAction(call) and 3 or 1
			local ok, result = false, nil
			for attempt = 1, tries do
				fixTroopArg(call)
				if isTroopAction(call) and not isTroopPlace(call) and typeof(call.args[4]) == "table" and not (typeof(call.args[4].Troop) == "Instance" and call.args[4].Troop.Parent) then
					result = "missing tower target"
					task.wait(0.45)
					continue
				end
				ok, result = pcall(function() return remote:InvokeServer(table.unpack(call.args, 1, call.n)) end)
				if ok then break end
				task.wait(0.35)
			end
			if ok and isTroopPlace(call) then
				if typeof(result) == "Instance" then
					rememberTroop(result)
				elseif typeof(result) == "table" and typeof(result.Troop) == "Instance" then
					rememberTroop(result.Troop)
				else
					local found = waitForTowerNear(call.position, 8, 20)
					if found then rememberTroop(found) end
				end
			elseif not ok then
				warn("Remote invoke failed:", call.args[1], call.args[2], result)
			end
		end
	else
		warn("Missing remote:", call.remotePath)
	end
end
