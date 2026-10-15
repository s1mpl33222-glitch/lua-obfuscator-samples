-- Validação de Segurança do Limão Hub
local hub = "limao-hub-premium"
local user = game.Players.LocalPlayer.Name
local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
local via = getgenv().LuaHub or ""
local url = "https://lua-launcher.lovable.app/api/public/validate?hub="..hub.."&user="..user.."&hwid="..hwid.."&via="..via
local ok, res = pcall(function() return game:HttpGet(url) end)
if not ok or not string.find(res, '"allowed":true') then
    return game.Players.LocalPlayer:Kick("Acesso não autorizado.")
end

--[[
limão hub premium desobfuscated by zx
@zxbest9 on discord
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
game:GetService("SoundService")
game:GetService("Debris")
local localPlayer = Players.LocalPlayer
local networking = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")

local tbl = {
	AskFieldEggSnapshot = networking:WaitForChild("RF/EggWorld/AskFieldEggSnapshot", 10),
	AskFieldEggCarry = networking:WaitForChild("RF/EggWorld/AskFieldEggCarry", 10),
	AskFieldEggDrop = networking:WaitForChild("RF/EggWorld/AskFieldEggDrop", 10),
	FieldEggCarry = networking:WaitForChild("RE/EggWorld/FieldEggCarry", 10),
}

local tbl2

tbl2 = {
	walk = function(arg, arg2)
		if not arg or not arg2 then
			return nil
		end
		local children = arg:GetChildren()

		while #children > 0 do
			local n = #children
			local v = children[n]
			children[n] = nil
			local children2 = v:GetChildren()

			for i = 1, #children2 do
				children[#children + 1] = children2[i]
			end

			if arg2(v) ~= true then
				continue
			end
			return v
		end

		return nil
	end,
	snapshot = function(arg)
		local tbl3 = {}

		tbl2.walk(arg, function(arg2)
			tbl3[#tbl3 + 1] = arg2
		end)

		return tbl3
	end,
}

tbl2.Integrity = {
	armed = false,
	restoring = false,
	connections = {},
	records = {},
	knownRootChildren = {},
	repairQueued = false,
	hardUntil = 0,
	hardRefreshAt = 0,
	tamperCount = 0,
	tamperWindow = 0,
	guardName = "LHVisualGuard_" .. tostring(math.random(100000, 999999)),
}

tbl2.integrityDisconnect = function()
	local integrity = tbl2.Integrity

	for i = 1, #integrity.connections do
		local v = integrity.connections[i]

		if v then
			pcall(function()
				v:Disconnect()
			end)
		end
	end

	table.clear(integrity.connections)

	pcall(function()
		RunService:UnbindFromRenderStep(integrity.guardName)
	end)
end

tbl2.integrityEscalate = function()
	local integrity = tbl2.Integrity
	local now = os.clock()

	if now - integrity.tamperWindow > 0.45 then
		integrity.tamperWindow = now
		integrity.tamperCount = 0
	end

	integrity.tamperCount = integrity.tamperCount + 1

	if integrity.tamperCount >= 3 then
		integrity.hardUntil = math.max(integrity.hardUntil, now + 2.5)
	end
end

tbl2.integrityRepairRecord = function(arg, arg2)
	local instance = arg and arg.instance
	if not instance then
		return
	end

	if arg.parent and instance.Parent ~= arg.parent then
		pcall(function()
			instance.Parent = arg.parent
		end)
	end

	if arg2 then
		local v = arg.properties[arg2]

		if v ~= nil then
			local ok, result = pcall(function()
				return instance[arg2]
			end)

			if ok and result ~= v then
				pcall(function()
					instance[arg2] = v
				end)
			end
		end

		return
	end

	for k, property in pairs(arg.properties) do
		local ok, result = pcall(function()
			return instance[k]
		end)

		if ok and result ~= property then
			pcall(function()
				instance[k] = property
			end)
		end
	end
end

tbl2.integrityQueueRepair = function()
	local integrity = tbl2.Integrity
	if not integrity.armed or integrity.restoring or integrity.repairQueued then
		return
	end
	integrity.repairQueued = true

	task.defer(function()
		integrity.repairQueued = false
		tbl2.integrityRepairAll()
	end)
end

tbl2.integrityRepairAll = function()
	local integrity = tbl2.Integrity
	if not integrity.armed or integrity.restoring then
		return
	end
	integrity.restoring = true

	for i = 1, #integrity.records do
		tbl2.integrityRepairRecord(integrity.records[i])
	end

	if integrity.refresh then
		pcall(integrity.refresh)
	end

	integrity.restoring = false
end

tbl2.integrityWatch = function(arg, arg2, parent)
	if not arg then
		return
	end
	local integrity = tbl2.Integrity
	local tbl3 = { instance = arg, properties = arg2, parent = parent }
	integrity.records[#integrity.records + 1] = tbl3

	if parent then
		integrity.connections[#integrity.connections + 1] = arg.AncestryChanged:Connect(function()
			if not integrity.armed or integrity.restoring or arg.Parent == parent then
				return
			end
			tbl2.integrityEscalate()
			integrity.restoring = true

			pcall(function()
				arg.Parent = parent
			end)

			integrity.restoring = false

			if arg.Parent ~= parent then
				tbl2.integrityQueueRepair()
			end
		end)
	end

	integrity.connections[#integrity.connections + 1] = arg.Changed:Connect(function(arg3)
		if not integrity.armed or integrity.restoring or arg2[arg3] == nil then
			return
		end

		local ok, result = pcall(function()
			return arg[arg3]
		end)

		if ok and result == arg2[arg3] then
			return
		end
		tbl2.integrityEscalate()
		integrity.restoring = true
		tbl2.integrityRepairRecord(tbl3, arg3)
		integrity.restoring = false
	end)
end

tbl2.integrityWatchComputed = function(arg, arg2, arg3)
	if not arg or not arg3 then
		return
	end
	local integrity = tbl2.Integrity
	local tbl3 = {}

	for i = 1, #arg2 do
		tbl3[arg2[i]] = true
	end

	integrity.connections[#integrity.connections + 1] = arg.Changed:Connect(function(arg4)
		if not integrity.armed or integrity.restoring or not tbl3[arg4] then
			return
		end
		tbl2.integrityEscalate()
		integrity.restoring = true
		pcall(arg3)
		integrity.restoring = false
	end)
end

tbl2.armHubIntegrity = function(arg)
	local integrity = tbl2.Integrity
	tbl2.integrityDisconnect()
	integrity.armed = false
	integrity.restoring = false
	integrity.repairQueued = false
	integrity.records = {}
	integrity.knownRootChildren = {}
	integrity.hardUntil = 0
	integrity.hardRefreshAt = 0
	integrity.tamperCount = 0
	integrity.tamperWindow = os.clock()
	local gui = arg.gui
	if not gui or not gui.Parent then
		return
	end
	local dynamicText = arg.dynamicText or {}
	local dynamicTextColor = arg.dynamicTextColor or {}
	local dynamicTextTransparency = arg.dynamicTextTransparency or {}
	local dynamicBackground = arg.dynamicBackground or {}
	local dynamicBackgroundTransparency = arg.dynamicBackgroundTransparency or {}
	local dynamicSize = arg.dynamicSize or {}
	local dynamicPosition = arg.dynamicPosition or {}
	local dynamicRotation = arg.dynamicRotation or {}
	local dynamicStrokeColor = arg.dynamicStrokeColor or {}
	local dynamicStrokeTransparency = arg.dynamicStrokeTransparency or {}

	local function fn(arg2)
		local tbl3 = { Name = arg2.Name }

		if arg2:IsA("ScreenGui") then
			tbl3.ResetOnSpawn = arg2.ResetOnSpawn
			tbl3.IgnoreGuiInset = arg2.IgnoreGuiInset
			tbl3.DisplayOrder = arg2.DisplayOrder
			tbl3.AutoLocalize = arg2.AutoLocalize
			tbl3.ZIndexBehavior = arg2.ZIndexBehavior
		end

		if arg2:IsA("GuiObject") then
			tbl3.BorderSizePixel = arg2.BorderSizePixel
			tbl3.ZIndex = arg2.ZIndex
			tbl3.AnchorPoint = arg2.AnchorPoint

			if not dynamicSize[arg2] then
				tbl3.Size = arg2.Size
			end

			if not dynamicPosition[arg2] then
				tbl3.Position = arg2.Position
			end

			if not dynamicRotation[arg2] then
				tbl3.Rotation = arg2.Rotation
			end

			if not dynamicBackground[arg2] then
				tbl3.BackgroundColor3 = arg2.BackgroundColor3
			end

			if not dynamicBackgroundTransparency[arg2] then
				tbl3.BackgroundTransparency = arg2.BackgroundTransparency
			end
		end

		if arg2:IsA("TextLabel") or arg2:IsA("TextButton") then
			if not dynamicText[arg2] then
				tbl3.Text = arg2.Text
			end

			if not dynamicTextColor[arg2] then
				tbl3.TextColor3 = arg2.TextColor3
			end

			if not dynamicTextTransparency[arg2] then
				tbl3.TextTransparency = arg2.TextTransparency
			end

			tbl3.TextStrokeColor3 = arg2.TextStrokeColor3
			tbl3.TextStrokeTransparency = arg2.TextStrokeTransparency
			tbl3.TextSize = arg2.TextSize
			tbl3.Font = arg2.Font
			tbl3.TextXAlignment = arg2.TextXAlignment
			tbl3.TextYAlignment = arg2.TextYAlignment
			tbl3.TextWrapped = arg2.TextWrapped
			tbl3.TextScaled = arg2.TextScaled
			tbl3.TextTruncate = arg2.TextTruncate

			if arg2:IsA("TextButton") then
				tbl3.AutoButtonColor = arg2.AutoButtonColor
			end
		end

		if arg2:IsA("ImageLabel") or arg2:IsA("ImageButton") then
			tbl3.Image = arg2.Image
			tbl3.ImageColor3 = arg2.ImageColor3
			tbl3.ImageTransparency = arg2.ImageTransparency
			tbl3.ScaleType = arg2.ScaleType

			if arg2:IsA("ImageButton") then
				tbl3.AutoButtonColor = arg2.AutoButtonColor
			end
		end

		if arg2:IsA("UIStroke") then
			if not dynamicStrokeColor[arg2] then
				tbl3.Color = arg2.Color
			end

			if not dynamicStrokeTransparency[arg2] then
				tbl3.Transparency = arg2.Transparency
			end

			tbl3.Thickness = arg2.Thickness
			tbl3.LineJoinMode = arg2.LineJoinMode
		end

		if arg2:IsA("UICorner") then
			tbl3.CornerRadius = arg2.CornerRadius
		end

		if arg2:IsA("UIScale") then
			tbl3.Scale = arg2.Scale
		end

		if arg2:IsA("UIGradient") then
			tbl3.Color = arg2.Color
			tbl3.Transparency = arg2.Transparency
			tbl3.Rotation = arg2.Rotation
		end

		return tbl3
	end

	local parent = gui.Parent
	tbl2.integrityWatch(gui, fn(gui), parent)
	local children = gui:GetChildren()

	for i = 1, #children do
		integrity.knownRootChildren[children[i]] = true
	end

	tbl2.walk(gui, function(arg2)
		local parent2 = arg2.Parent
		tbl2.integrityWatch(arg2, fn(arg2), parent2)
	end)

	integrity.connections[#integrity.connections + 1] = gui.ChildAdded:Connect(function(child)
		if not integrity.armed or integrity.restoring then
			return
		end

		if not integrity.knownRootChildren[child] then
			tbl2.integrityEscalate()

			pcall(function()
				child:Destroy()
			end)
		end
	end)

	integrity.connections[#integrity.connections + 1] = gui.ChildRemoved:Connect(function(child)
		if not integrity.armed or integrity.restoring or not integrity.knownRootChildren[child] then
			return
		end
		tbl2.integrityEscalate()
		tbl2.integrityQueueRepair()
	end)

	local computed = arg.computed or {}

	for i = 1, #computed do
		local v = arg.computed[i]
		tbl2.integrityWatchComputed(v.instance, v.properties, v.repair)
	end

	integrity.refresh = arg.refresh
	integrity.armed = true
	tbl2.integrityRepairAll()

	pcall(function()
		RunService:UnbindFromRenderStep(integrity.guardName)
	end)

	RunService:BindToRenderStep(integrity.guardName, Enum.RenderPriority.Last.Value + 1000, function()
		local now = os.clock()
		if not integrity.armed or integrity.restoring or now > integrity.hardUntil then
			return
		end
		integrity.restoring = true

		for i = 1, #integrity.records do
			tbl2.integrityRepairRecord(integrity.records[i])
		end

		if integrity.refresh and now >= integrity.hardRefreshAt then
			integrity.hardRefreshAt = now + 0.05
			pcall(integrity.refresh)
		end

		integrity.restoring = false
	end)
end

tbl2.findModule = function(arg)
	local v = nil

	tbl2.walk(ReplicatedStorage, function(arg2)
		if arg2:IsA("ModuleScript") and arg2.Name:lower() == arg:lower() then
			v = arg2
			return true
		end
	end)

	if v then
		local ok, result = pcall(require, v)
		if ok then
			return result
		end
	end

	return nil
end

local Assets = nil
local data = ReplicatedStorage:FindFirstChild("Data")
local assets = data and data:FindFirstChild("Assets") or ReplicatedStorage:FindFirstChild("Assets")

if assets and assets:IsA("ModuleScript") then
	local ok, result = pcall(require, assets)

	if ok then
		Assets = result
	end
end

Assets = Assets or tbl2.findModule("Assets")
require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("EggState"))
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("RagdollJoints"))
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("AreaEggSlotIdentity"))
local AreaEggCycle = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("AreaEggCycle"))
require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("AreaEggResetCycle"))
local Rarity = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("Rarity"))

tbl2.isDaytime = function()
	local ok, result = pcall(function()
		return AreaEggCycle.IsNightPhase(workspace:GetServerTimeNow())
	end)

	return ok and result ~= true
end

tbl2.isStartWallOpen = function()
	local objects = workspace:FindFirstChild("World")
	objects = objects and objects:FindFirstChild("Areas")
	if not objects then
		return true
	end
	local wallStartVisual = objects:FindFirstChild("WallStartVisual")
	if wallStartVisual and wallStartVisual:IsA("BasePart") and wallStartVisual.Size.Y > 0.25 then
		return false
	end
	local wallStartCollision = objects:FindFirstChild("WallStartCollision")
	if wallStartCollision and wallStartCollision:IsA("BasePart") and wallStartCollision.CanCollide then
		return false
	end
	return true
end

tbl2.canLeaveForSteal = function()
	return tbl2.isDaytime() and tbl2.isStartWallOpen()
end

tbl2.rarityConfigCache = {}
tbl2.rarityColorCache = {}

tbl2.getOfficialRarityConfig = function(arg)
	local str = string.lower(tostring(arg or "")):gsub("%s+", "")
	local v = tbl2.rarityConfigCache[str]
	if v ~= nil then
		return v ~= false and v or nil
	end
	local v2 = pairs
	local rarities = Rarity.Rarities or {}

	for k, rarity in v2(rarities) do
		local str2 = string.lower(tostring(k)):gsub("%s+", "")
		local str3 = string.lower(tostring(type(rarity) == "table" and rarity.DisplayName or "")):gsub("%s+", "")
		if str2 == str or str3 == str then
			tbl2.rarityConfigCache[str] = rarity
			return rarity
		end
	end

	tbl2.rarityConfigCache[str] = false
	return nil
end

tbl2.getOfficialRarityColor = function(arg)
	local str = string.lower(tostring(arg or "")):gsub("%s+", "")
	local v = tbl2.rarityColorCache[str]
	if v then
		return v
	end
	local color = tbl2.getOfficialRarityConfig(arg)
	color = color and color.Color
	local value

	if typeof(color) == "ColorSequence" then
		value = color.Keypoints[1].Value
	else
		value = color
	end

	if typeof(value) ~= "Color3" then
		value = Color3.fromRGB(57, 255, 20)
	end

	tbl2.rarityColorCache[str] = value
	return value
end

local Mutations = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Mutations"))
local AssetViewport = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("AssetViewport"))

local tbl3 = {
	REFRESH_INTERVAL = 0.5,
	SPAM_INTERVAL = 0.01,
	PROTECT_INTERVAL = 0.05,
	SPAWN_OFFSET = 3,
	BEAM_WIDTH = 0.12,
	GROUND_OFFSET = 3,
	DROPDOWN_ROWS = 4,
	ROW_H = 28,
	ROW_GAP = 3,
	TWEEN_SPEED = 500,
	WAYPOINT = Vector3.new(510.092, 70.767, -364.085),
	USE_GROUND_DETECTION = true,
	GROUND_CLEARANCE = 4,
	RAYCAST_UP = 100,
	RAYCAST_DOWN = 300,
	START_MARKER_DEPTH_PADDING = 0,
	START_MARKER_BACK_PADDING = 16,
	START_MARKER_TEXT_BACK_OFFSET = 9,
	START_MARKER_TEXT_AREA_EXTRA = 11,
	JUMP_ANIMATION_ID = "rbxassetid://125750702",
}

local tbl4 = {
	engineStatus = nil :: string?,
	enabled = false,
	mode = "TELEGUIADO",
	running = true,
	bestEgg = nil,
	selectedEgg = nil,
	selectedUid = nil,
	dropdownOpen = false,
	targetEgg = nil,
	eggs = {},
	rarityEggs = {},
	filteredEggs = {},
	rarityFilter = {},
	waitingForDay = false,
	loopEnabled = false,
	runLoop = false,
	guidedCycleActive = false,
	lastRefresh = 0,
	isMoving = false,
	isStealing = false,
	isProtecting = false,
	carrying = false,
	carryLocked = false,
	isDelivering = false,
	heldEggUid = nil,
	moveTarget = nil,
	onArrive = nil,
	lastSpamTime = 0,
	lastProtectTime = 0,
}

local tbl5 = {}
local tbl6 = { Key = "cosmic", Label = "Cosmic", Color = tbl2.getOfficialRarityColor("Cosmic") }
local tbl7 = { Key = "secret", Label = "Secret", Color = tbl2.getOfficialRarityColor("Secret") }
local tbl8 = { Key = "eternal", Label = "Eternal", Color = tbl2.getOfficialRarityColor("Eternal") }
local tbl9 = { Key = "divine", Label = "Divine", Color = tbl2.getOfficialRarityColor("Divine") }
tbl5[1] = tbl6
tbl5[2] = tbl7
tbl5[3] = tbl8
tbl5[4] = tbl9

tbl2.normalizeRarityKey = function(arg)
	return string.lower(tostring(arg or "")):gsub("%s+", "")
end

tbl2.isRarityFilterActive = function()
	for _, v in ipairs(tbl5) do
		if tbl4.rarityFilter[v.Key] then
			return true
		end
	end

	return false
end

tbl2.eggMatchesRarityFilter = function(arg)
	if not tbl2.isRarityFilterActive() then
		return true
	end
	return tbl4.rarityFilter[tbl2.normalizeRarityKey(arg.RarityName)] == true
end

local v = nil
local humanoid = nil
local humanoidRootPart = nil
workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("StartArea")
ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Trails")
local v2 = nil
local v3 = nil
local animate = nil
local health = nil
local v4 = nil
local v5 = nil
local animation = nil
local breakJointsOnDeath = nil
local v6 = nil
local connection = nil
local walkSpeed = nil

tbl2.restoreWalkSpeed = function()
	local character = localPlayer.Character
	local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid2 and walkSpeed then
		humanoid2.WalkSpeed = walkSpeed
		walkSpeed = nil
	end
end

tbl2.isPlayerInGroundArea = function(arg)
	local ground = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Areas") and workspace.World.Areas:FindFirstChild("Ground")
	if not ground then
		return false
	end

	if ground:IsA("Model") then
		local boundingBox, v7 = ground:GetBoundingBox()
		local v8 = boundingBox:PointToObjectSpace(arg.Position)
		local n = v7.X / 2
		local flag = math.abs(v8.X) <= n

		if flag then
			local n2 = v7.Y / 2 + 20
			flag = math.abs(v8.Y) <= n2
		end

		if flag then
			local n2 = v7.Z / 2
			flag = math.abs(v8.Z) <= n2
		end

		return flag
	end

	if ground:IsA("BasePart") then
		local v7 = ground.CFrame:PointToObjectSpace(arg.Position)
		local n = ground.Size.X / 2
		local flag = math.abs(v7.X) <= n

		if flag then
			local n2 = ground.Size.Y / 2 + 20
			flag = math.abs(v7.Y) <= n2
		end

		if flag then
			local n2 = ground.Size.Z / 2
			flag = math.abs(v7.Z) <= n2
		end

		return flag
	end

	return false
end

tbl2.unequipTreadmill = function()
	pcall(function()
		local network = ReplicatedStorage:FindFirstChild("Network")
		network = network and network:FindFirstChild("Treadmills: RequestUnequip")

		if network then
			network:InvokeServer()
		end
	end)
end

tbl2.getGroundAdjustedPosition = function(arg)
	if typeof(arg) ~= "Vector3" then
		return arg
	end
	local n = tonumber(tbl3.GROUND_CLEARANCE) or 4
	local character = localPlayer.Character or v
	local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
	character = character and character:FindFirstChildOfClass("Humanoid")
	local n2

	if humanoidRootPart2 and character then
		n2 = math.max(n, humanoidRootPart2.Size.Y * 0.5 + math.max(tonumber(character.HipHeight) or 0, 0) + 0.2)
	else
		n2 = n
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true
	local filterDescendantsInstances = {}

	if v and v.Parent then
		table.insert(filterDescendantsInstances, v)
	end

	local n3 = arg + Vector3.new(0, tbl3.RAYCAST_UP, 0)
	local vector = Vector3.new(0, -(tbl3.RAYCAST_UP + tbl3.RAYCAST_DOWN), 0)

	for i = 1, 8 do
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		local hit = workspace:Raycast(n3, vector, raycastParams)
		if not hit then
			return arg
		end
		local instance = hit.Instance
		if instance:IsA("Terrain") or instance:IsA("BasePart") and instance.CanCollide then
			return Vector3.new(arg.X, hit.Position.Y + n2, arg.Z)
		end
		table.insert(filterDescendantsInstances, instance)
	end

	return arg
end

tbl2.liftCharacterOutOfGround = function()
	local character = localPlayer.Character or v
	local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not humanoidRootPart2 or not humanoid2 then
		return
	end
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true
	local filterDescendantsInstances = { character }
	local v7 = nil

	for i = 1, 8 do
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		local hit = workspace:Raycast(humanoidRootPart2.Position + Vector3.new(0, 2, 0), Vector3.new(0, -12, 0), raycastParams)
		v7 = nil

		if hit then
			local instance = hit.Instance

			if instance:IsA("Terrain") or instance:IsA("BasePart") and instance.CanCollide then
				v7 = hit
				break
			else
				table.insert(filterDescendantsInstances, instance)
				v7 = nil
				continue
			end
		end

		break
	end

	if not v7 then
		return
	end

	if humanoidRootPart2.Position.Y + 1.5 < v7.Position.Y then
		return
	end
	local n = v7.Position.Y + humanoidRootPart2.Size.Y * 0.5 + math.max(tonumber(humanoid2.HipHeight) or 0, 0) + 0.2

	if humanoidRootPart2.Position.Y < n - 0.05 then
		humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
		humanoidRootPart2.CFrame = humanoidRootPart2.CFrame + Vector3.new(0, n - humanoidRootPart2.Position.Y, 0)
	end
end

tbl2.stopCurrentTween = function(arg)
	if connection then
		connection:Disconnect()
		connection = nil
	end

	if v6 then
		v6:Cancel()
		v6 = nil
	end

	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")

	if character then
		character.AssemblyLinearVelocity = Vector3.zero
	end

	tbl2.restoreWalkSpeed()

	if arg then
		task.spawn(function()
			task.wait(0.05)

			pcall(function()
				if ReplicatedStorage:FindFirstChild("Network") then
					local askFieldEggDrop = tbl.AskFieldEggDrop

					if askFieldEggDrop then
						askFieldEggDrop:InvokeServer({ Reason = "PlayerRequest" })
					end
				end
			end)
		end)
	end
end

tbl2.completeMove = function()
	tbl2.restoreWalkSpeed()

	if tbl4.isMoving then
		tbl4.isMoving = false
		tbl4.moveTarget = nil
		local onArrive = tbl4.onArrive
		tbl4.onArrive = nil

		if onArrive then
			task.defer(onArrive)
		end
	end
end

tbl2.tweenToTarget = function(arg, arg2)
	local character = localPlayer.Character
	local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
	character = character and character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart2 then
		if tbl2.isPlayerInGroundArea(humanoidRootPart2) then
			tbl2.unequipTreadmill()
		end

		local n = tonumber(tbl3.TWEEN_SPEED) or 500
		tbl2.stopCurrentTween(false)

		if character then
			if character.WalkSpeed > 0 then
				walkSpeed = character.WalkSpeed
			end

			character.WalkSpeed = 0
		end

		local function fn(arg3, arg4)
			local magnitude = (arg3 - humanoidRootPart2.Position).Magnitude

			if magnitude < 2 then
				if arg4 then
					arg4()
				end

				return
			end

			local tweenInfo = TweenInfo.new(magnitude / n, Enum.EasingStyle.Linear)
			local cframe = CFrame.new(arg3)

			if arg2 then
				local vector = Vector3.new(arg3.X - humanoidRootPart2.Position.X, 0, arg3.Z - humanoidRootPart2.Position.Z)

				if vector.Magnitude > 0.01 then
					cframe = CFrame.lookAt(arg3, arg3 + vector.Unit)
				end
			end

			local tween = TweenService:Create(humanoidRootPart2, tweenInfo, { CFrame = cframe })
			v6 = tween

			connection = tween.Completed:Connect(function(playbackState)
				if v6 == tween then
					v6 = nil

					if connection then
						connection:Disconnect()
						connection = nil
					end

					if playbackState == Enum.PlaybackState.Completed then
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						humanoidRootPart2.CFrame = cframe

						if arg4 then
							arg4()
						end
					end
				end
			end)

			tween:Play()
		end

		local waypoint = tbl3.WAYPOINT
		local flag = (arg - waypoint).Magnitude < 2
		local v7 = tbl2.getGroundAdjustedPosition(waypoint)
		local v8 = arg2 and arg or tbl2.getGroundAdjustedPosition(arg)

		if tbl3.USE_GROUND_DETECTION and not arg2 and tbl2.isPlayerInGroundArea(humanoidRootPart2) and not flag then
			fn(v7, function()
				fn(v8, tbl2.completeMove)
			end)
		else
			fn(v8, tbl2.completeMove)
		end
	end
end

tbl2.startMove = function(moveTarget, onArrive, arg)
	if not moveTarget or not humanoidRootPart then
		return
	end
	tbl4.isMoving = true
	tbl4.moveTarget = moveTarget
	tbl4.onArrive = onArrive
	tbl2.tweenToTarget(moveTarget, arg == true)
end

tbl2.finishMove = function()
	tbl2.stopCurrentTween(false)
	tbl4.isMoving = false
	tbl4.moveTarget = nil
	tbl4.onArrive = nil
end

tbl2.unequipAllTools = function()
	task.spawn(function()
		pcall(function()
			local character = localPlayer.Character or v
			if not character then
				return
			end
			local humanoid2 = character:FindFirstChildOfClass("Humanoid")

			if humanoid2 then
				humanoid2:UnequipTools()
			end
		end)
	end)
end

tbl2.applyAntiRagdoll = function(arg, arg2)
	if not arg or not arg2 then
		return
	end
	arg2:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	arg2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	arg2:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	local motorCache = tbl2.motorCache

	if motorCache then
		for i = 1, #motorCache do
			local v7 = motorCache[i]

			if v7 and v7.Parent and v7:IsDescendantOf(arg) then
				v7.Enabled = true
			end
		end
	else
		tbl2.walk(arg, function(arg3)
			if arg3:IsA("Motor6D") then
				arg3.Enabled = true
			end
		end)
	end
end

tbl2.createZombieHumanoidClone = function(arg, arg2)
	if not arg then
		return nil
	end
	local clone = arg:Clone()
	clone.Name = "Humanoid"
	clone.BreakJointsOnDeath = false
	clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	clone:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	clone:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	clone.Health = clone.MaxHealth
	clone.HipHeight = arg.HipHeight
	clone.PlatformStand = false
	clone.Sit = false
	clone.AutoRotate = arg2 == true
	return clone
end

tbl2.applyZombieDesync = function(parent)
	if not parent then
		return nil
	end

	if v2 and v2.Parent == parent then
		return v2
	end
	walkSpeed = nil
	local humanoid2 = parent:WaitForChild("Humanoid", 5)
	if not humanoid2 then
		return nil
	end
	local humanoidRootPart2 = parent:FindFirstChild("HumanoidRootPart")
	local cFrame = humanoidRootPart2 and humanoidRootPart2.CFrame or nil
	local hipHeight = humanoid2.HipHeight
	v3 = humanoid2
	breakJointsOnDeath = humanoid2.BreakJointsOnDeath
	v4 = parent
	health = parent:FindFirstChild("Health")
	animate = parent:FindFirstChild("Animate")
	local v7 = tbl2.createZombieHumanoidClone(humanoid2, true)
	if not v7 then
		return nil
	end

	if animate then
		animate.Parent = nil
	end

	local animator = v7:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = v7
	end

	if tbl3.JUMP_ANIMATION_ID and tbl3.JUMP_ANIMATION_ID ~= "" then
		pcall(function()
			animation = Instance.new("Animation")
			animation.AnimationId = tbl3.JUMP_ANIMATION_ID
			v5 = animator:LoadAnimation(animation)

			v7.Jumping:Connect(function(arg)
				if arg and v5 then
					v5:Play()
				end
			end)
		end)
	end

	humanoid2.Parent = nil
	v7.Parent = parent
	v7.HipHeight = hipHeight
	v2 = v7
	humanoid = v7

	if animate then
		if not pcall(function()
			local clone = animate:Clone()
			clone.Name = "Animate"
			clone.Parent = parent
			clone.Disabled = false
		end) then
			animate.Parent = parent
			animate.Disabled = false
		end
	end

	tbl2.applyAntiRagdoll(parent, v7)

	if humanoidRootPart2 and humanoidRootPart2.Parent then
		humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

		if cFrame then
			humanoidRootPart2.CFrame = cFrame
		end
	end

	local currentCamera = workspace.CurrentCamera

	if currentCamera then
		currentCamera.CameraType = Enum.CameraType.Custom
		currentCamera.CameraSubject = v7
	end

	return v7
end

tbl2.restoreOriginalHumanoid = function()
	local character = v4 or localPlayer.Character
	if not character then
		return
	end

	if not v3 then
		v2 = nil
		humanoid = character:FindFirstChildOfClass("Humanoid")
		local currentCamera = workspace.CurrentCamera

		if currentCamera and humanoid then
			currentCamera.CameraType = Enum.CameraType.Custom
			currentCamera.CameraSubject = humanoid
		end

		return
	end

	if v5 then
		pcall(function()
			v5:Stop(0)
		end)
	end

	if animation then
		pcall(function()
			animation:Destroy()
		end)
	end

	v5 = nil
	animation = nil
	local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
	local cFrame = humanoidRootPart2 and humanoidRootPart2.CFrame or nil
	local humanoid2 = character:FindFirstChildOfClass("Humanoid")

	if humanoid2 and humanoid2 ~= v3 then
		humanoid2:Destroy()
	end

	if v3 then
		v3.Parent = character
		v3.PlatformStand = false
		v3.AutoRotate = true
		v3.Sit = false

		pcall(function()
			v3:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)

		humanoid = v3
		v2 = nil
	end

	if humanoidRootPart2 and humanoidRootPart2.Parent then
		humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

		if cFrame then
			humanoidRootPart2.CFrame = cFrame
		end
	end

	local animate2 = character:FindFirstChild("Animate")

	if animate2 and animate2 ~= animate then
		animate2:Destroy()
	end

	if animate then
		animate.Parent = character
		animate.Disabled = false
	end

	if health then
		health.Parent = character
	end

	if v3 and breakJointsOnDeath ~= nil then
		v3.BreakJointsOnDeath = breakJointsOnDeath
	end

	local currentCamera = workspace.CurrentCamera

	if currentCamera and humanoid then
		currentCamera.CameraSubject = humanoid
	end

	v4 = nil
	v3 = nil
	animate = nil
	health = nil
	breakJointsOnDeath = nil
end

local n = 0

RunService.Heartbeat:Connect(function(deltaTime)
	n += deltaTime
	if n < 0.1 then
		return
	end
	n = 0

	if localPlayer.Character and v2 then
		local motorCache = tbl2.motorCache

		if motorCache then
			for i = 1, #motorCache do
				local v7 = motorCache[i]

				if v7 and v7.Parent and not v7.Enabled then
					v7.Enabled = true
				end
			end
		end

		local state = v2:GetState()

		if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
			v2:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end
end)

local guardAreas = workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("GuardAreas")
guardAreas:WaitForChild("Forest")

local tbl10 = {
	["Abyss Ocean"] = { X = 0, Y = 9.4, Z = 4 },
	["Cherry Blossom"] = { X = 0, Y = 7.5, Z = -1 },
	Cosmic = { X = 0, Y = 11, Z = 3.000015 },
	Desert = { X = -6.1e-05, Y = 2, Z = 2 },
	Forest = { X = 0, Y = 2, Z = 0.500061 },
	Jungle = { X = 0, Y = 5.000008, Z = -0.500031 },
	Lake = { X = 0, Y = 2, Z = 0 },
	Prehistoric = { X = 0, Y = 22, Z = -12 },
	Snow = { X = 0, Y = 1.5, Z = -0.5 },
	Volcano = { X = -6.1e-05, Y = 8, Z = -2 },
	["Titan Temple"] = { X = 0, Y = 15, Z = 3.5 },
}

local v7 = nil
local v8 = nil
local v9 = nil
local y = nil
local v10 = nil
local parent = nil
local weldConstraint = nil
local v11 = nil
local v12 = nil
local v13 = nil
local tbl11 = {}
local connection2 = nil

tbl2.getAreaCenter = function(arg)
	if not arg then
		return nil
	end

	if arg:IsA("Model") then
		return arg:GetPivot().Position
	end

	if arg:IsA("BasePart") then
		return arg.Position
	end
	local basePart = arg:FindFirstChildWhichIsA("BasePart", true)
	return basePart and basePart.Position or nil
end

tbl2.isPositionInsideArea = function(arg, arg2)
	if not arg2 then
		return false
	end
	local boundingBox, size

	if arg2:IsA("Model") then
		boundingBox, size = arg2:GetBoundingBox()
	else
		if not arg2:IsA("BasePart") then
			return false
		end
		boundingBox = arg2.CFrame
		size = arg2.Size
	end

	local v14 = boundingBox:PointToObjectSpace(arg)
	local n2 = size.X / 2
	local flag = math.abs(v14.X) <= n2

	if flag then
		local n3 = size.Z / 2
		flag = math.abs(v14.Z) <= n3
	end

	local flag2

	if flag then
		local n3 = size.Y / 2 + 100
		flag2 = math.abs(v14.Y) <= n3
	else
		flag2 = flag
	end

	return flag2
end

tbl2.getBossAreaFromEgg = function(arg)
	if not arg then
		return nil
	end
	local areaName = arg.AreaName or arg.Area or arg.World or arg.Biome
	if type(areaName) == "string" and guardAreas:FindFirstChild(areaName) then
		return areaName
	end
	local position = arg.Position
	if typeof(position) ~= "Vector3" then
		return nil
	end
	local v14 = nil
	local name = nil

	for _, child in ipairs(guardAreas:GetChildren()) do
		if tbl2.isPositionInsideArea(position, child) then
			return child.Name
		end
		local v15 = tbl2.getAreaCenter(child)

		if v15 then
			local magnitude = (Vector3.new(v15.X, 0, v15.Z) - Vector3.new(position.X, 0, position.Z)).Magnitude

			if not v14 or magnitude < v14 then
				name = child.Name
				v14 = magnitude
			end
		end
	end

	return name
end

tbl2.stopBossAnimations = function()
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if v11 then
		pcall(function()
			v11:Stop(0.15)
		end)
	end

	if v12 then
		pcall(function()
			v12:Stop(0.15)
		end)
	end

	if v13 then
		pcall(function()
			v13:Stop(0.15)
		end)
	end

	for _, v14 in ipairs(tbl11) do
		local sound = v14.Sound

		if sound and sound.Parent then
			pcall(function()
				sound:Stop()
				sound.Looped = v14.Looped
			end)
		end
	end

	tbl11 = {}
	v11 = nil
	v12 = nil
	v13 = nil
end

tbl2.cleanupBossMount = function()
	tbl2.stopBossAnimations()

	if weldConstraint then
		weldConstraint:Destroy()
		weldConstraint = nil
	end

	if v7 then
		v7:Destroy()
		v7 = nil
	end

	if v10 and parent then
		v10.Parent = parent
	end

	v10 = nil
	parent = nil
	v8 = nil
	v9 = nil
	y = nil
	local humanoid2 = v2 or v and v:FindFirstChildOfClass("Humanoid")

	if humanoid2 and humanoid2.Parent then
		humanoid2.PlatformStand = false
		humanoid2.AutoRotate = true
	end
end

tbl2.loadBossMovementSounds = function(arg)
	tbl11 = {}
	local tbl12 = {}
	local tbl13 = {}

	tbl2.walk(arg, function(arg2)
		if arg2:IsA("Sound") then
			tbl13[#tbl13 + 1] = arg2
			local v14 = string.lower(arg2.Name)

			if v14:find("walk") or v14:find("run") or v14:find("move") or v14:find("step") or arg2.Looped then
				tbl12[#tbl12 + 1] = arg2
			end
		end
	end)

	if #tbl12 == 0 then
		tbl12 = tbl13
	end

	for _, v14 in ipairs(tbl12) do
		table.insert(tbl11, { Sound = v14, Looped = v14.Looped })
		v14.Looped = true
	end
end

tbl2.setBossMovementSounds = function(arg)
	for _, v14 in ipairs(tbl11) do
		local sound = v14.Sound

		if sound and sound.Parent then
			if arg then
				if not sound.IsPlaying then
					pcall(function()
						sound:Play()
					end)
				end
			elseif sound.IsPlaying then
				pcall(function()
					sound:Stop()
				end)
			end
		end
	end
end

tbl2.loadBossAnimations = function(arg, arg2)
	tbl2.loadBossMovementSounds(arg)
	local animationController = arg:FindFirstChildWhichIsA("AnimationController", true)

	if not animationController then
		animationController = Instance.new("AnimationController")
		animationController.Name = "AnimationController"
		animationController.Parent = arg:FindFirstChild("Model") or arg
	end

	local animator = animationController:FindFirstChildWhichIsA("Animator") or Instance.new("Animator")
	animator.Parent = animationController
	local animationId = nil
	local animationId2 = nil

	pcall(function()
		local v14 = ReplicatedStorage.Data.Guards.Configs:FindFirstChild(arg2)

		if v14 then
			local module = require(v14)
			animationId = module.IdleAnimation and module.IdleAnimation.AnimationId
			animationId2 = module.WalkAnimation and module.WalkAnimation.AnimationId
		end
	end)

	local function fn(animationId3, priority)
		if not animationId3 then
			return nil
		end
		local animation2 = Instance.new("Animation")
		animation2.AnimationId = animationId3

		local ok, result = pcall(function()
			return animator:LoadAnimation(animation2)
		end)

		if not ok or not result then
			return nil
		end
		result.Looped = true
		result.Priority = priority
		return result
	end

	v11 = fn(animationId, Enum.AnimationPriority.Idle)
	v12 = fn(animationId2, Enum.AnimationPriority.Movement)

	if v11 then
		v11:Play(0.15)
	end

	local v14 = v2
	local humanoid2

	if v2 then
		humanoid2 = v14
	else
		humanoid2 = v and v:FindFirstChildOfClass("Humanoid")
	end

	if humanoid2 then
		local animator2 = humanoid2:FindFirstChildOfClass("Animator") or Instance.new("Animator")
		animator2.Parent = humanoid2
		local animation2 = Instance.new("Animation")
		animation2.AnimationId = "rbxassetid://2506281703"

		local ok, result = pcall(function()
			return animator2:LoadAnimation(animation2)
		end)

		if ok and result then
			v13 = result
			v13.Looped = true
			v13.Priority = Enum.AnimationPriority.Action4
			v13:Play(0.15)
			v13:AdjustWeight(1, 0.1)
		end
	end

	local n2 = 0

	connection2 = RunService.Heartbeat:Connect(function(deltaTime)
		n2 += deltaTime
		if n2 < 0.08 then
			return
		end
		n2 = 0
		if not v7 or not v7.Parent then
			tbl2.cleanupBossMount()
			return
		end
		local isMoving = tbl4.isMoving

		if isMoving and v12 then
			if v11 and v11.IsPlaying then
				v11:Stop(0.15)
			end

			if not v12.IsPlaying then
				v12:Play(0.15)
			end

			tbl2.setBossMovementSounds(true)
		elseif not isMoving and v11 then
			if v12 and v12.IsPlaying then
				v12:Stop(0.15)
			end

			if not v11.IsPlaying then
				v11:Play(0.15)
			end

			tbl2.setBossMovementSounds(false)
		elseif isMoving then
			tbl2.setBossMovementSounds(true)
		else
			tbl2.setBossMovementSounds(false)
		end

		if v13 and not v13.IsPlaying then
			v13:Play(0.1)
			v13:AdjustWeight(1, 0.1)
		end
	end)
end

tbl2.getGroundDirectionFrom = function(arg)
	local ground = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Areas") and workspace.World.Areas:FindFirstChild("Ground")
	if not ground then
		return nil
	end
	local position

	if ground:IsA("Model") then
		position = ground:GetPivot().Position
	elseif ground:IsA("BasePart") then
		position = ground.Position
	else
		position = ground:FindFirstChildWhichIsA("BasePart", true)
		position = position and position.Position
	end

	if not position then
		return nil
	end
	local vector = Vector3.new(position.X - arg.X, 0, position.Z - arg.Z)
	return vector.Magnitude > 0.01 and vector.Unit or nil
end

tbl2.spawnBossForEgg = function(arg)
	tbl2.cleanupBossMount()
	if not humanoidRootPart or not humanoidRootPart.Parent then
		return nil
	end
	local v14 = tbl2.getBossAreaFromEgg(arg)
	local v15 = v14 and guardAreas:FindFirstChild(v14)
	local guard = v15 and v15:FindFirstChild("Guard")
	if not guard then
		warn("Guard não encontrado para a área do ovo:", tostring(v14))
		return nil
	end
	local primaryPart = guard.PrimaryPart or guard:FindFirstChild("HumanoidRootPart", true) or guard:FindFirstChild("Root", true) or guard:FindFirstChildWhichIsA("BasePart", true)
	if not primaryPart then
		return nil
	end
	y = primaryPart.Position.Y
	local clone = guard:Clone()
	clone.Name = "__LimaoBoss_" .. tostring(v14)
	v10 = guard
	parent = guard.Parent
	guard.Parent = nil
	local primaryPart2 = clone.PrimaryPart or clone:FindFirstChild("HumanoidRootPart", true) or clone:FindFirstChild("Root", true) or clone:FindFirstChildWhichIsA("BasePart", true)

	if not primaryPart2 then
		clone:Destroy()

		if v10 and parent then
			v10.Parent = parent
		end

		v10 = nil
		parent = nil
		return nil
	end

	clone.PrimaryPart = primaryPart2

	tbl2.walk(clone, function(arg2)
		if arg2:IsA("BasePart") then
			arg2.CanCollide = false
			arg2.CanQuery = false
			arg2.CanTouch = false
			arg2.Massless = true
			arg2.Anchored = false
		end
	end)

	local lookVector = tbl2.getGroundDirectionFrom(humanoidRootPart.Position) or humanoidRootPart.CFrame.LookVector
	local unit = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
	local n2 = humanoidRootPart.Position + unit * 8
	local vector = Vector3.new(n2.X, y, n2.Z)
	clone:PivotTo(CFrame.lookAt(vector, vector + unit))
	local n3 = y - primaryPart2.Position.Y

	if math.abs(n3) > 0.001 then
		clone:PivotTo(clone:GetPivot() + Vector3.new(0, n3, 0))
	end

	clone.Parent = workspace
	primaryPart2.Anchored = true
	local tbl12 = tbl10[v14] or { X = 0, Y = 3, Z = 0 }
	v9 = tbl12
	humanoidRootPart.CFrame = primaryPart2.CFrame * CFrame.new(tbl12.X, tbl12.Y, tbl12.Z)
	primaryPart2.Anchored = false
	weldConstraint = Instance.new("WeldConstraint")
	weldConstraint.Name = "LimaoBossRiderWeld"
	weldConstraint.Part0 = humanoidRootPart
	weldConstraint.Part1 = primaryPart2
	weldConstraint.Parent = humanoidRootPart
	v7 = clone
	v8 = primaryPart2
	local humanoid2 = v2 or v and v:FindFirstChildOfClass("Humanoid")

	if humanoid2 then
		humanoid2.PlatformStand = false
		humanoid2.AutoRotate = false
	end

	tbl2.loadBossAnimations(clone, v14)
	return clone
end

tbl2.getBossDeliveryPosition = function(arg)
	if typeof(arg) ~= "Vector3" then
		return arg
	end
	local v14 = v9
	if not v14 then
		return arg
	end
	local vector = Vector3.new(arg.X, y or arg.Y, arg.Z)
	return (CFrame.lookAt(vector, vector + (tbl2.getGroundDirectionFrom(vector) or Vector3.new(0, 0, -1))) * CFrame.new(v14.X, v14.Y, v14.Z)).Position
end

local str = "LH_"

local function fn(arg)
	if not arg then
		return
	end
	local children = arg:GetChildren()

	for i = 1, #children do
		local v14 = children[i]

		if v14:IsA("ScreenGui") and (v14.Name == "LimaoHubPremium" or v14.Name == "LennonHub" or v14.Name:sub(1, #str) == str or v14.Name == "LimaoLoadingGui") then
			pcall(function()
				v14:Destroy()
			end)
		end
	end
end

pcall(function()
	fn(game:GetService("CoreGui"))
end)

pcall(function()
	fn(localPlayer.PlayerGui)
end)

local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
local flag = viewportSize.X < 680 or viewportSize.Y < 500
local n2 = 262
local n3 = 185
local scale = flag and 0.88 or 0.94
local n4 = flag and 40 or 42
local n5 = flag and 10 or 14
local udim2 = flag and UDim2.new(1, -math.floor(n2 * scale) - 8, 0, 8) or UDim2.new(0.5, 140, 0.5, -math.floor(n3 * scale / 2) - 22)
local n6 = tbl3.DROPDOWN_ROWS * tbl3.ROW_H + (tbl3.DROPDOWN_ROWS - 1) * tbl3.ROW_GAP + 8
local n7 = n6 + 20
local n8 = 2
local v14 = math.ceil(#tbl5 / n8)
local n9 = flag and 21 or 22
local n10 = 3
local n11 = v14 * n9 + (v14 - 1) * n10
local n12 = 120 + n7 + n11 + 10
local screenGui = Instance.new("ScreenGui")
screenGui.Name = str .. tostring(math.random(1000000, 9999999))
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.DisplayOrder = 100
screenGui.AutoLocalize = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- TELA DE CARREGAMENTO (LOADING SCREEN 100% PRETA - TELA CHEIA)
local loadingScreenGui = Instance.new("ScreenGui")
loadingScreenGui.Name = "LimaoLoadingGui"
loadingScreenGui.ResetOnSpawn = false
loadingScreenGui.IgnoreGuiInset = true
loadingScreenGui.DisplayOrder = 999999
loadingScreenGui.AutoLocalize = false
loadingScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local loadingGui = Instance.new("Frame")
loadingGui.Name = "LimaoLoadingScreen"
loadingGui.Size = UDim2.fromScale(1, 1)
loadingGui.Position = UDim2.fromScale(0, 0)
loadingGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingGui.BackgroundTransparency = 0
loadingGui.Visible = false
loadingGui.BorderSizePixel = 0
loadingGui.Parent = loadingScreenGui

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, 0, 0, 50)
loadingTitle.Position = UDim2.new(0, 0, 0.5, -35)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "Limão Hub"
loadingTitle.TextColor3 = Color3.fromRGB(57, 255, 120)
loadingTitle.TextSize = 28
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loadingGui

local loadingSub = Instance.new("TextLabel")
loadingSub.Size = UDim2.new(1, 0, 0, 20)
loadingSub.Position = UDim2.new(0, 0, 0.5, 20)
loadingSub.BackgroundTransparency = 1
loadingSub.Text = "Levando Ovo..."
loadingSub.TextColor3 = Color3.fromRGB(120, 255, 100)
loadingSub.TextSize = 13
loadingSub.Font = Enum.Font.Gotham
loadingSub.Parent = loadingGui

tbl2.showLoading = function(text)
	if text then
		loadingSub.Text = text
	end
	loadingGui.Visible = true
end

tbl2.hideLoading = function()
	loadingGui.Visible = false
end

local imageButton = Instance.new("ImageButton")
imageButton.Name = "LimaoIcon"
imageButton.Size = UDim2.fromOffset(n4, n4)
imageButton.Position = UDim2.new(0, n5, 0.5, -math.floor(n4 / 2))
imageButton.BackgroundColor3 = Color3.fromRGB(5, 14, 8)
imageButton.BackgroundTransparency = 0.05
imageButton.Image = "rbxassetid://102570474465205"
imageButton.ScaleType = Enum.ScaleType.Crop
imageButton.AutoButtonColor = false
imageButton.ZIndex = 20
imageButton.Parent = screenGui
Instance.new("UICorner", imageButton).CornerRadius = UDim.new(1, 0)
local uiStroke = Instance.new("UIStroke", imageButton)
uiStroke.Color = Color3.fromRGB(57, 255, 20)
uiStroke.Thickness = 2
uiStroke.Transparency = 0.05
local frame = Instance.new("Frame")
frame.Name = "LimaoPanel"
frame.Size = UDim2.fromOffset(262, 185)
frame.Position = udim2
frame.BackgroundColor3 = Color3.fromRGB(4, 12, 6)
frame.BackgroundTransparency = 0.08
frame.Visible = true
frame.ZIndex = 10
frame.Parent = screenGui
local uiScale = Instance.new("UIScale")
uiScale.Name = "CompactScale"
uiScale.Scale = scale
uiScale.Parent = frame
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local uiStroke2 = Instance.new("UIStroke", frame)
uiStroke2.Color = Color3.fromRGB(57, 255, 20)
uiStroke2.Thickness = 1.5
uiStroke2.Transparency = 0.1
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, -20, 0, 42)
frame2.Position = UDim2.fromOffset(10, 10)
frame2.BackgroundTransparency = 1
frame2.ZIndex = 11
frame2.Parent = frame
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.fromOffset(26, 26)
imageLabel.Position = UDim2.new(0, 0, 0.5, -13)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://102570474465205"
imageLabel.ScaleType = Enum.ScaleType.Crop
imageLabel.ZIndex = 12
imageLabel.Parent = frame2
Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(1, 0)
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -70, 0, 18)
textLabel.Position = UDim2.new(0, 34, 0, 4)
textLabel.BackgroundTransparency = 1
textLabel.Text = "LIMÃO HUB PREMIUM"
textLabel.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel.TextSize = 12
textLabel.Font = Enum.Font.GothamBold
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.ZIndex = 12
textLabel.Parent = frame2
local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, -70, 0, 13)
textLabel2.Position = UDim2.new(0, 34, 0, 22)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "Limão Hub Pro"
textLabel2.TextColor3 = Color3.fromRGB(120, 255, 100)
textLabel2.TextSize = 7
textLabel2.Font = Enum.Font.GothamMedium
textLabel2.TextXAlignment = Enum.TextXAlignment.Left
textLabel2.ZIndex = 12
textLabel2.Parent = frame2
local frame3 = Instance.new("Frame")
frame3.Name = "LimaoToast"
frame3.Size = UDim2.fromOffset(190, 28)
frame3.Position = UDim2.new(0.5, -95, 0, -35)
frame3.BackgroundColor3 = Color3.fromRGB(8, 20, 10)
frame3.BackgroundTransparency = 1
frame3.ZIndex = 50
frame3.Visible = false
frame3.ClipsDescendants = true
frame3.Parent = frame
Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 8)
local uiStroke3 = Instance.new("UIStroke", frame3)
uiStroke3.Color = Color3.fromRGB(57, 255, 20)
uiStroke3.Thickness = 1.2
uiStroke3.Transparency = 1
local textLabel3 = Instance.new("TextLabel")
textLabel3.Size = UDim2.new(1, 0, 1, 0)
textLabel3.BackgroundTransparency = 1
textLabel3.Text = "Discord link copied!"
textLabel3.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel3.TextTransparency = 1
textLabel3.TextSize = 10
textLabel3.Font = Enum.Font.GothamBold
textLabel3.ZIndex = 51
textLabel3.Parent = frame3

tbl2.showToast = function(text)
	textLabel3.Text = text or "Discord link copied!"
	frame3.Visible = true
	frame3.Position = UDim2.new(0.5, -95, 0, -35)
	frame3.BackgroundTransparency = 1
	textLabel3.TextTransparency = 1
	uiStroke3.Transparency = 1
	TweenService:Create(frame3, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, -95, 0, 7), BackgroundTransparency = 0.05 }):Play()
	TweenService:Create(textLabel3, TweenInfo.new(0.18), { TextTransparency = 0 }):Play()
	TweenService:Create(uiStroke3, TweenInfo.new(0.18), { Transparency = 0.15 }):Play()

	task.delay(1.8, function()
		if not frame3.Visible then
			return
		end
		local tween = TweenService:Create(frame3, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0.5, -95, 0, -35), BackgroundTransparency = 1 })
		TweenService:Create(textLabel3, TweenInfo.new(0.22), { TextTransparency = 1 }):Play()
		TweenService:Create(uiStroke3, TweenInfo.new(0.22), { Transparency = 1 }):Play()
		tween:Play()

		tween.Completed:Connect(function()
			if frame3.Position.Y.Offset <= -25 then
				frame3.Visible = false
			end
		end)
	end)
end

local imageButton2 = Instance.new("ImageButton")
imageButton2.Size = UDim2.fromOffset(24, 24)
imageButton2.Position = UDim2.new(1, -52, 0.5, -12)
imageButton2.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
imageButton2.BackgroundTransparency = 0.2
imageButton2.Image = "rbxassetid://121807029290075"
imageButton2.ScaleType = Enum.ScaleType.Fit
imageButton2.AutoButtonColor = false
imageButton2.ZIndex = 12
imageButton2.Parent = frame2
Instance.new("UICorner", imageButton2).CornerRadius = UDim.new(1, 0)
local uiStroke4 = Instance.new("UIStroke", imageButton2)
uiStroke4.Color = Color3.fromRGB(57, 255, 20)
uiStroke4.Thickness = 1.5
uiStroke4.Transparency = 0.2

imageButton2.MouseButton1Click:Connect(function()
	pcall(function()
		if setclipboard then
			setclipboard("https://discord.gg/CugrPTFhh")
		end
	end)

	tbl2.showToast("Discord link copied!")
	uiStroke4.Color = Color3.fromRGB(100, 255, 60)

	task.delay(0.4, function()
		if uiStroke4 and uiStroke4.Parent then
			uiStroke4.Color = Color3.fromRGB(57, 255, 20)
		end
	end)
end)

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.fromOffset(24, 24)
textButton.Position = UDim2.new(1, -24, 0.5, -12)
textButton.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
textButton.BackgroundTransparency = 0.2
textButton.Text = "×"
textButton.TextColor3 = Color3.fromRGB(57, 255, 20)
textButton.TextSize = 16
textButton.Font = Enum.Font.Gotham
textButton.AutoButtonColor = false
textButton.ZIndex = 12
textButton.Parent = frame2
Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
local frame4 = Instance.new("Frame")
frame4.Size = UDim2.new(1, -20, 0, 1)
frame4.Position = UDim2.fromOffset(10, 52)
frame4.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
frame4.BackgroundTransparency = 0.4
frame4.BorderSizePixel = 0
frame4.ZIndex = 11
frame4.Parent = frame
local frame5 = Instance.new("Frame")
frame5.Size = UDim2.new(1, -20, 0, 52)
frame5.Position = UDim2.fromOffset(10, 60)
frame5.BackgroundColor3 = Color3.fromRGB(15, 45, 20)
frame5.BackgroundTransparency = 0.15
frame5.ZIndex = 11
frame5.Parent = frame
Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 9)
local uiStroke5 = Instance.new("UIStroke", frame5)
uiStroke5.Color = Color3.fromRGB(57, 255, 20)
uiStroke5.Thickness = 1
uiStroke5.Transparency = 0.25
local textLabel4 = Instance.new("TextLabel")
textLabel4.Size = UDim2.new(1, -58, 0, 14)
textLabel4.Position = UDim2.fromOffset(52, 5)
textLabel4.BackgroundTransparency = 1
textLabel4.Text = "BEST EGG"
textLabel4.TextColor3 = Color3.fromRGB(120, 255, 100)
textLabel4.TextSize = 7
textLabel4.Font = Enum.Font.GothamBold
textLabel4.TextXAlignment = Enum.TextXAlignment.Left
textLabel4.ZIndex = 12
textLabel4.Parent = frame5
local textLabel5 = Instance.new("TextLabel")
textLabel5.Size = UDim2.new(0, 100, 0, 17)
textLabel5.Position = UDim2.fromOffset(52, 20)
textLabel5.BackgroundTransparency = 1
textLabel5.Text = "SEARCHING..."
textLabel5.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel5.TextSize = 10
textLabel5.Font = Enum.Font.GothamBold
textLabel5.TextXAlignment = Enum.TextXAlignment.Left
textLabel5.TextTruncate = Enum.TextTruncate.AtEnd
textLabel5.ZIndex = 12
textLabel5.Parent = frame5
local textLabel6 = Instance.new("TextLabel")
textLabel6.Size = UDim2.new(0, 100, 0, 12)
textLabel6.Position = UDim2.fromOffset(52, 35)
textLabel6.BackgroundTransparency = 1
textLabel6.Text = ""
textLabel6.TextColor3 = Color3.fromRGB(150, 255, 130)
textLabel6.TextSize = 8
textLabel6.Font = Enum.Font.GothamBold
textLabel6.TextXAlignment = Enum.TextXAlignment.Left
textLabel6.TextTruncate = Enum.TextTruncate.AtEnd
textLabel6.ZIndex = 12
textLabel6.Parent = frame5
local textLabel7 = Instance.new("TextLabel")
textLabel7.AnchorPoint = Vector2.new(1, 0)
textLabel7.Size = UDim2.fromOffset(60, 17)
textLabel7.Position = UDim2.new(1, -24, 0, 20)
textLabel7.BackgroundTransparency = 1
textLabel7.Text = "--"
textLabel7.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel7.TextSize = 10
textLabel7.Font = Enum.Font.GothamBold
textLabel7.TextXAlignment = Enum.TextXAlignment.Right
textLabel7.ZIndex = 12
textLabel7.Parent = frame5
local textButton2 = Instance.new("TextButton")
textButton2.Name = "DropdownToggle"
textButton2.Size = UDim2.fromOffset(18, 18)
textButton2.Position = UDim2.new(1, -20, 0, 3)
textButton2.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
textButton2.BackgroundTransparency = 0.3
textButton2.Text = ""
textButton2.AutoButtonColor = false
textButton2.ZIndex = 13
textButton2.Parent = frame5
Instance.new("UICorner", textButton2).CornerRadius = UDim.new(1, 0)
local frame6 = Instance.new("Frame")
frame6.Name = "Arrow"
frame6.AnchorPoint = Vector2.new(0.5, 0.5)
frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
frame6.Size = UDim2.fromOffset(10, 10)
frame6.BackgroundTransparency = 1
frame6.Rotation = 0
frame6.ZIndex = 14
frame6.Parent = textButton2
local frame7 = Instance.new("Frame")
frame7.AnchorPoint = Vector2.new(0.5, 0.5)
frame7.Position = UDim2.new(0.5, -3, 0.5, -1)
frame7.Size = UDim2.fromOffset(7, 2)
frame7.Rotation = 45
frame7.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
frame7.BorderSizePixel = 0
frame7.ZIndex = 14
frame7.Parent = frame6
Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
local frame8 = Instance.new("Frame")
frame8.AnchorPoint = Vector2.new(0.5, 0.5)
frame8.Position = UDim2.new(0.5, 3, 0.5, -1)
frame8.Size = UDim2.fromOffset(7, 2)
frame8.Rotation = -45
frame8.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
frame8.BorderSizePixel = 0
frame8.ZIndex = 14
frame8.Parent = frame6
Instance.new("UICorner", frame8).CornerRadius = UDim.new(1, 0)
local textButton3 = Instance.new("TextButton")
textButton3.Size = UDim2.new(1, -20, 0, 55)
textButton3.Position = UDim2.fromOffset(10, 120)
textButton3.BackgroundColor3 = Color3.fromRGB(15, 45, 20)
textButton3.BackgroundTransparency = 0.15
textButton3.Text = ""
textButton3.AutoButtonColor = false
textButton3.ZIndex = 11
textButton3.Parent = frame
Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 9)
local uiStroke6 = Instance.new("UIStroke", textButton3)
uiStroke6.Color = Color3.fromRGB(57, 255, 20)
uiStroke6.Thickness = 1
uiStroke6.Transparency = 0.25
local textLabel8 = Instance.new("TextLabel")
textLabel8.Size = UDim2.fromOffset(88, 20)
textLabel8.Position = UDim2.fromOffset(12, 8)
textLabel8.BackgroundTransparency = 1
textLabel8.Text = "TELEGUIADO"
textLabel8.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel8.TextSize = 11
textLabel8.Font = Enum.Font.GothamBold
textLabel8.TextXAlignment = Enum.TextXAlignment.Left
textLabel8.ZIndex = 12
textLabel8.Parent = textButton3
local textLabel9 = Instance.new("TextLabel")
textLabel9.Size = UDim2.fromOffset(88, 14)
textLabel9.Position = UDim2.fromOffset(12, 30)
textLabel9.BackgroundTransparency = 1
textLabel9.Text = "Always targets the highest value"
textLabel9.TextColor3 = Color3.fromRGB(120, 255, 100)
textLabel9.TextSize = 8
textLabel9.Font = Enum.Font.Gotham
textLabel9.TextXAlignment = Enum.TextXAlignment.Left
textLabel9.ZIndex = 12
textLabel9.Parent = textButton3
tbl2.loopButton = Instance.new("TextButton")
tbl2.loopButton.Name = "LoopCheckbox"
tbl2.loopButton.AnchorPoint = Vector2.new(0.5, 0.5)
tbl2.loopButton.Size = UDim2.fromOffset(52, 20)
tbl2.loopButton.Position = UDim2.new(0.56, 0, 0.5, 0)
tbl2.loopButton.BackgroundTransparency = 1
tbl2.loopButton.Text = ""
tbl2.loopButton.AutoButtonColor = false
tbl2.loopButton.ZIndex = 13
tbl2.loopButton.Parent = textButton3
tbl2.loopBox = Instance.new("Frame")
tbl2.loopBox.Size = UDim2.fromOffset(14, 14)
tbl2.loopBox.Position = UDim2.fromOffset(0, 3)
tbl2.loopBox.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
tbl2.loopBox.BorderSizePixel = 0
tbl2.loopBox.ZIndex = 14
tbl2.loopBox.Parent = tbl2.loopButton
Instance.new("UICorner", tbl2.loopBox).CornerRadius = UDim.new(0, 4)
tbl2.loopBoxStroke = Instance.new("UIStroke", tbl2.loopBox)
tbl2.loopBoxStroke.Color = Color3.fromRGB(57, 255, 20)
tbl2.loopBoxStroke.Thickness = 1
tbl2.loopBoxStroke.Transparency = 0.2
tbl2.loopCheck = Instance.new("TextLabel")
tbl2.loopCheck.Size = UDim2.fromScale(1, 1)
tbl2.loopCheck.BackgroundTransparency = 1
tbl2.loopCheck.Text = "✓"
tbl2.loopCheck.TextColor3 = Color3.fromRGB(4, 12, 6)
tbl2.loopCheck.TextSize = 11
tbl2.loopCheck.Font = Enum.Font.GothamBold
tbl2.loopCheck.Visible = false
tbl2.loopCheck.ZIndex = 15
tbl2.loopCheck.Parent = tbl2.loopBox
tbl2.loopLabel = Instance.new("TextLabel")
tbl2.loopLabel.Size = UDim2.new(1, -18, 1, 0)
tbl2.loopLabel.Position = UDim2.fromOffset(18, 0)
tbl2.loopLabel.BackgroundTransparency = 1
tbl2.loopLabel.Text = "LOOP"
tbl2.loopLabel.TextColor3 = Color3.fromRGB(57, 255, 20)
tbl2.loopLabel.TextSize = 11
tbl2.loopLabel.Font = Enum.Font.GothamBold
tbl2.loopLabel.TextXAlignment = Enum.TextXAlignment.Left
tbl2.loopLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
tbl2.loopLabel.TextStrokeTransparency = 0
tbl2.loopLabel.ZIndex = 14
tbl2.loopLabel.Parent = tbl2.loopButton
local frame9 = Instance.new("Frame")
frame9.Size = UDim2.fromOffset(38, 20)
frame9.Position = UDim2.new(1, -48, 0.5, -10)
frame9.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
frame9.ZIndex = 12
frame9.Parent = textButton3
Instance.new("UICorner", frame9).CornerRadius = UDim.new(1, 0)
local frame10 = Instance.new("Frame")
frame10.Size = UDim2.fromOffset(14, 14)
frame10.Position = UDim2.new(0, 3, 0.5, -7)
frame10.BackgroundColor3 = Color3.fromRGB(150, 255, 130)
frame10.ZIndex = 13
frame10.Parent = frame9
Instance.new("UICorner", frame10).CornerRadius = UDim.new(1, 0)
local frame11 = Instance.new("Frame")
frame11.Name = "DropdownList"
frame11.Size = UDim2.new(1, -20, 0, n7 + n11)
frame11.Position = UDim2.fromOffset(10, 120)
frame11.BackgroundTransparency = 1
frame11.Visible = false
frame11.ZIndex = 11
frame11.Parent = frame
local tbl12 = {}

tbl2.createDropdownRow = function(arg)
	local textButton4 = Instance.new("TextButton")
	textButton4.Name = "Row" .. arg
	textButton4.Size = UDim2.new(1, 0, 0, tbl3.ROW_H)
	textButton4.Position = UDim2.fromOffset(0, (arg - 1) * (tbl3.ROW_H + tbl3.ROW_GAP))
	textButton4.BackgroundColor3 = Color3.fromRGB(15, 45, 20)
	textButton4.BackgroundTransparency = 0.15
	textButton4.Text = ""
	textButton4.AutoButtonColor = false
	textButton4.ZIndex = 12
	textButton4.Visible = false
	textButton4.Parent = frame11
	Instance.new("UICorner", textButton4).CornerRadius = UDim.new(0, 7)
	local uiStroke7 = Instance.new("UIStroke", textButton4)
	uiStroke7.Color = Color3.fromRGB(57, 255, 20)
	uiStroke7.Thickness = 1
	uiStroke7.Transparency = 0.25
	local textLabel10 = Instance.new("TextLabel")
	textLabel10.Size = UDim2.fromOffset(16, tbl3.ROW_H)
	textLabel10.Position = UDim2.fromOffset(6, 0)
	textLabel10.BackgroundTransparency = 1
	textLabel10.Text = "#" .. arg
	textLabel10.TextColor3 = Color3.fromRGB(120, 255, 100)
	textLabel10.TextSize = 9
	textLabel10.Font = Enum.Font.GothamBold
	textLabel10.ZIndex = 13
	textLabel10.Parent = textButton4
	local frame12 = Instance.new("Frame")
	frame12.Name = "Preview"
	frame12.AnchorPoint = Vector2.new(0, 0.5)
	frame12.Position = UDim2.new(0, 26, 0.5, 0)
	frame12.Size = UDim2.fromOffset(24, 24)
	frame12.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame12.BackgroundTransparency = 0.5
	frame12.BorderSizePixel = 0
	frame12.ClipsDescendants = true
	frame12.ZIndex = 13
	frame12.Parent = textButton4
	Instance.new("UICorner", frame12).CornerRadius = UDim.new(0, 6)
	local textLabel11 = Instance.new("TextLabel")
	textLabel11.Size = UDim2.new(1, -130, 0, 14)
	textLabel11.Position = UDim2.fromOffset(58, 4)
	textLabel11.BackgroundTransparency = 1
	textLabel11.Text = ""
	textLabel11.TextColor3 = Color3.fromRGB(57, 255, 20)
	textLabel11.TextSize = 9
	textLabel11.Font = Enum.Font.GothamBold
	textLabel11.TextXAlignment = Enum.TextXAlignment.Left
	textLabel11.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel11.ZIndex = 13
	textLabel11.Parent = textButton4
	local textLabel12 = Instance.new("TextLabel")
	textLabel12.Size = UDim2.new(1, -130, 0, 11)
	textLabel12.Position = UDim2.fromOffset(58, 17)
	textLabel12.BackgroundTransparency = 1
	textLabel12.Text = ""
	textLabel12.TextColor3 = Color3.fromRGB(150, 255, 130)
	textLabel12.TextSize = 7
	textLabel12.Font = Enum.Font.GothamBold
	textLabel12.TextXAlignment = Enum.TextXAlignment.Left
	textLabel12.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel12.ZIndex = 13
	textLabel12.Parent = textButton4
	local textLabel13 = Instance.new("TextLabel")
	textLabel13.AnchorPoint = Vector2.new(1, 0)
	textLabel13.Size = UDim2.fromOffset(60, 20)
	textLabel13.Position = UDim2.new(1, -8, 0, 5)
	textLabel13.BackgroundTransparency = 1
	textLabel13.Text = ""
	textLabel13.TextColor3 = Color3.fromRGB(57, 255, 20)
	textLabel13.TextSize = 10
	textLabel13.Font = Enum.Font.GothamBold
	textLabel13.TextXAlignment = Enum.TextXAlignment.Right
	textLabel13.ZIndex = 13
	textLabel13.Parent = textButton4

	return {
		Row = textButton4,
		Preview = frame12,
		NameLabel = textLabel11,
		RarityLabel = textLabel12,
		ValueLabel = textLabel13,
		Egg = nil,
		LastUid = nil,
		LastCategory = nil,
	}
end

for i = 1, tbl3.DROPDOWN_ROWS do
	tbl12[i] = tbl2.createDropdownRow(i)
end

local textLabel10 = Instance.new("TextLabel")
textLabel10.Name = "RarityFilterTitle"
textLabel10.Size = UDim2.new(1, 0, 0, 18)
textLabel10.Position = UDim2.fromOffset(0, n6)
textLabel10.BackgroundTransparency = 1
textLabel10.Text = "RARITY FILTER • TP + TELEGUIADO"
textLabel10.TextColor3 = Color3.fromRGB(57, 255, 20)
textLabel10.TextSize = 8
textLabel10.Font = Enum.Font.GothamBold
textLabel10.TextXAlignment = Enum.TextXAlignment.Left
textLabel10.ZIndex = 12
textLabel10.Parent = frame11
local frame12 = Instance.new("Frame")
frame12.Name = "RarityFilterList"
frame12.Size = UDim2.new(1, 0, 0, n11)
frame12.Position = UDim2.fromOffset(0, n7)
frame12.BackgroundTransparency = 1
frame12.Visible = true
frame12.ZIndex = 11
frame12.Parent = frame11
local tbl13 = {}

tbl2.createRarityCheckbox = function(arg, arg2)
	local n13 = (arg - 1) % n8
	local n14 = math.floor((arg - 1) / n8)
	local textButton4 = Instance.new("TextButton")
	textButton4.Name = "RarityCheckbox" .. arg2.Key
	textButton4.Size = UDim2.new(0.5, -3, 0, n9)
	textButton4.Position = UDim2.new(n13 * 0.5, n13 == 0 and 0 or 3, 0, n14 * (n9 + n10))
	textButton4.BackgroundColor3 = Color3.fromRGB(15, 45, 20)
	textButton4.BackgroundTransparency = 0.15
	textButton4.BorderSizePixel = 0
	textButton4.AutoButtonColor = false
	textButton4.Text = ""
	textButton4.ZIndex = 12
	textButton4.Parent = frame12
	Instance.new("UICorner", textButton4).CornerRadius = UDim.new(0, 7)
	local uiStroke7 = Instance.new("UIStroke", textButton4)
	uiStroke7.Color = arg2.Color
	uiStroke7.Thickness = 1
	uiStroke7.Transparency = 0.25
	local textLabel11 = Instance.new("TextLabel")
	textLabel11.Name = "Check"
	textLabel11.Size = UDim2.fromOffset(16, 16)
	textLabel11.Position = UDim2.fromOffset(5, 4)
	textLabel11.BackgroundColor3 = arg2.Color
	textLabel11.BackgroundTransparency = 0.55
	textLabel11.BorderSizePixel = 0
	textLabel11.Text = ""
	textLabel11.TextColor3 = Color3.fromRGB(4, 12, 6)
	textLabel11.TextSize = 12
	textLabel11.Font = Enum.Font.GothamBlack
	textLabel11.ZIndex = 13
	textLabel11.Parent = textButton4
	Instance.new("UICorner", textLabel11).CornerRadius = UDim.new(0, 4)
	local textLabel12 = Instance.new("TextLabel")
	textLabel12.Name = "Label"
	textLabel12.Size = UDim2.new(1, -28, 1, 0)
	textLabel12.Position = UDim2.fromOffset(26, 0)
	textLabel12.BackgroundTransparency = 1
	textLabel12.Text = arg2.Label
	textLabel12.TextColor3 = arg2.Key == "secret" and Color3.fromRGB(255, 255, 255) or arg2.Color
	textLabel12.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel12.TextStrokeTransparency = arg2.Key == "secret" and 0 or 1
	textLabel12.TextSize = 8
	textLabel12.Font = Enum.Font.GothamBold
	textLabel12.TextXAlignment = Enum.TextXAlignment.Left
	textLabel12.ZIndex = 13
	textLabel12.Parent = textButton4
	return { Row = textButton4, Box = textLabel11, Stroke = uiStroke7, Label = textLabel12, Option = arg2 }
end

for i, v15 in ipairs(tbl5) do
	tbl13[v15.Key] = tbl2.createRarityCheckbox(i, v15)
end

tbl2.updateRarityChecks = function()
	for _, v15 in ipairs(tbl5) do
		local v16 = tbl13[v15.Key]
		local flag2 = tbl4.rarityFilter[v15.Key] == true
		local flag3 = v15.Key == "secret"
		v16.Label.TextColor3 = flag3 and Color3.fromRGB(255, 255, 255) or v15.Color
		v16.Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		v16.Label.TextStrokeTransparency = flag3 and 0 or 1
		v16.Box.Text = flag2 and "✓" or ""
		v16.Box.BackgroundColor3 = v15.Color
		v16.Box.BackgroundTransparency = flag2 and 0 or 0.55
		v16.Box.TextColor3 = flag2 and Color3.fromRGB(4, 12, 6) or v15.Color
		v16.Stroke.Color = v15.Color
		v16.Stroke.Transparency = flag2 and 0 or 0.25
		v16.Row.BackgroundColor3 = flag2 and Color3.fromRGB(25, 75, 30) or Color3.fromRGB(15, 45, 20)
	end
end

tbl2.attachViewport = function(arg, arg2)
	if not AssetViewport then
		return
	end

	local ok, result = pcall(function()
		return AssetViewport.Mount(arg)
	end)

	if not ok or not result then
		return
	end
	local v15 = result
	v15.Size = UDim2.fromScale(1, 1)
	v15.Position = UDim2.fromScale(0.5, 0.5)
	v15.AnchorPoint = Vector2.new(0.5, 0.5)
	v15.BackgroundTransparency = 1
	v15.ZIndex = 14

	if not pcall(function()
		return AssetViewport.ShowAsset(arg2, v15, true)
	end) then
		if v15 then
			v15:Destroy()
		end

		return
	end
end

local v15 = nil

tbl2.updatePetPreview = function(arg)
	if not frame.Visible then
		v15 = nil
		return
	end

	if v15 == arg and frame5:FindFirstChild("Preview") then
		return
	end
	v15 = arg
	local preview = frame5:FindFirstChild("Preview")

	if preview then
		preview:Destroy()
	end

	if not arg then
		return
	end
	local frame13 = Instance.new("Frame")
	frame13.Name = "Preview"
	frame13.AnchorPoint = Vector2.new(0, 0.5)
	frame13.Position = UDim2.new(0, 6, 0.5, 0)
	frame13.Size = UDim2.fromOffset(40, 40)
	frame13.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame13.BackgroundTransparency = 0.5
	frame13.BorderSizePixel = 0
	frame13.ClipsDescendants = true
	frame13.ZIndex = 13
	frame13.Parent = frame5
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 7)
	uiCorner.Parent = frame13
	tbl2.attachViewport(frame13, arg)
end

tbl2.formatNumber = function(arg)
	local n13 = tonumber(arg) or 0

	local function fn2(arg2)
		return (string.format("%.2f", arg2):gsub("(%..-)0+$", "%1"):gsub("%.$", ""))
	end

	local n14 = math.abs(n13)

	for _, v16 in ipairs({ { 1e12, "T" }, { 1e9, "B" }, { 1000000, "M" }, { 1000, "K" } }) do
		if n14 >= v16[1] then
			local v17 = v16[2]
			return fn2(n13 / v16[1]) .. v17
		end
	end

	return tostring(math.floor(n13 + 0.5))
end

local tbl14 = {
	common = Color3.fromRGB(185, 185, 185),
	uncommon = Color3.fromRGB(80, 220, 100),
	rare = Color3.fromRGB(70, 150, 255),
	epic = Color3.fromRGB(170, 75, 255),
	legendary = Color3.fromRGB(255, 190, 45),
	mythic = Color3.fromRGB(255, 75, 75),
	cosmic = Color3.fromRGB(215, 90, 255),
	eternal = Color3.fromRGB(255, 220, 80),
}

tbl2.getRarityColor = function(arg)
	if type(arg) == "table" then
		local color = arg.Color or arg.Color3 or arg.RarityColor
		if typeof(color) == "Color3" then
			return color
		end

		if typeof(color) == "ColorSequence" then
			return color.Keypoints[1].Value
		end

		if type(color) == "string" then
			local str2 = color:gsub("#", "")

			if #str2 == 6 then
				local num = tonumber(str2:sub(1, 2), 16)
				local num2 = tonumber(str2:sub(3, 4), 16)
				local num3 = tonumber(str2:sub(5, 6), 16)
				if num and num2 and num3 then
					return Color3.fromRGB(num, num2, num3)
				end
			end
		end
	end

	return tbl14[string.lower(tostring(type(arg) == "table" and (arg.DisplayName or arg.Name) or arg or ""))] or Color3.fromRGB(57, 255, 20)
end

tbl2.getScaleMultiplier = function(arg)
	local n13 = tonumber(arg) or 1
	if n13 <= 5 then
		return n13 ^ 1.85
	end
	return (n13 / 5) ^ 1.2 * 19.637875755794113
end

tbl2.getEggData = function(arg)
	local v16 = Assets.Directory[arg.AssetCategory]
	if not v16 then
		return nil
	end
	local n13 = tonumber(v16.EarningRate) or 0
	local n14 = tonumber(arg.AssetScale) or 1
	local flag2 = arg.Mutations and #arg.Mutations > 0
	local n15 = 1

	if flag2 then
		local v17 = Mutations
		local earningsFor

		if Mutations then
			earningsFor = Mutations.EarningsFor
		else
			earningsFor = v17
		end

		if type(earningsFor) == "function" then
			local ok, result = pcall(function()
				return earningsFor(arg.Mutations)
			end)

			if ok then
				n15 = tonumber(result) or 1
			end
		end
	end

	local n16 = n13 * tbl2.getScaleMultiplier(n14) * n15
	local color = Color3.fromRGB(57, 255, 20)
	local n17 = 0
	local str2 = ""

	if v16.Rarity then
		n17 = v16.Rarity.RarityNumber or 0
		str2 = v16.Rarity.DisplayName or v16.Rarity.Name or ""
		color = tbl2.getOfficialRarityColor(str2)
	end

	return {
		Uid = arg.Uid,
		Category = arg.AssetCategory,
		Name = v16.DisplayName or arg.AssetCategory,
		Generation = math.round(n16),
		Position = arg.BottomCFrame.Position,
		BottomCFrame = arg.BottomCFrame,
		Rarity = n17,
		RarityName = str2,
		RarityColor = color,
		BaseRate = n13,
		Scale = n14,
	}
end

tbl2.getGroundPosition = function()
	local objects = workspace:FindFirstChild("World")
	if not objects then
		return nil
	end
	local areas = objects:FindFirstChild("Areas")
	if not areas then
		return nil
	end
	local ground = areas:FindFirstChild("Ground")
	if not ground then
		return nil
	end

	if ground:IsA("BasePart") then
		return ground.Position + Vector3.new(0, ground.Size.Y * 0.5 + tbl3.GROUND_OFFSET, 0)
	end

	if ground:IsA("Model") then
		local pivot = ground:GetPivot()
		local boundingBox, v16 = ground:GetBoundingBox()
		return pivot.Position + Vector3.new(0, v16.Y * 0.5 + tbl3.GROUND_OFFSET, 0)
	end

	local basePart = ground:FindFirstChildWhichIsA("BasePart", true)
	if basePart then
		return basePart.Position + Vector3.new(0, basePart.Size.Y * 0.5 + tbl3.GROUND_OFFSET, 0)
	end
	return nil
end

tbl2.refreshDropdownRows = function()
	for i = 1, tbl3.DROPDOWN_ROWS do
		local v16 = tbl12[i]
		local v17 = tbl4.filteredEggs[i]
		v16.Egg = v17
		local lastUid = v17 and tostring(v17.Uid) or nil
		local category = v17 and v17.Category or nil

		if v16.LastUid ~= lastUid or v16.LastCategory ~= category then
			for _, child in ipairs(v16.Preview:GetChildren()) do
				child:Destroy()
			end

			v16.LastUid = lastUid
			v16.LastCategory = category

			if v17 then
				tbl2.attachViewport(v16.Preview, category)
			end
		end

		if v17 then
			v16.Row.Visible = true
			local text = tostring(v17.Name or "UNKNOWN")
			local text2 = tostring(v17.RarityName or "")
			local v18 = tbl2.formatNumber(v17.Generation or 0)

			if v16.NameLabel.Text ~= text then
				v16.NameLabel.Text = text
			end

			if v16.RarityLabel.Text ~= text2 then
				v16.RarityLabel.Text = text2
			end

			local rarityColor = v17.RarityColor or Color3.fromRGB(57, 255, 20)

			if v16.RarityLabel.TextColor3 ~= rarityColor then
				v16.RarityLabel.TextColor3 = rarityColor
			end

			if v16.ValueLabel.Text ~= v18 then
				v16.ValueLabel.Text = v18
			end
		else
			v16.Row.Visible = false

			if v16.NameLabel.Text ~= "" then
				v16.NameLabel.Text = ""
			end

			if v16.RarityLabel.Text ~= "" then
				v16.RarityLabel.Text = ""
			end

			if v16.ValueLabel.Text ~= "" then
				v16.ValueLabel.Text = ""
			end
		end
	end
end

tbl2.closeDropdown = function()
	if not tbl4.dropdownOpen then
		return
	end
	tbl4.dropdownOpen = false
	frame11.Visible = false
	textButton3.Visible = true
	TweenService:Create(frame6, TweenInfo.new(0.15), { Rotation = 0 }):Play()
	TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(262, 185) }):Play()
end

tbl2.openDropdown = function()
	if tbl4.dropdownOpen then
		return
	end
	tbl4.dropdownOpen = true
	tbl2.refreshDropdownRows()
	textButton3.Visible = false
	frame11.Visible = true
	TweenService:Create(frame6, TweenInfo.new(0.15), { Rotation = 180 }):Play()
	TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(262, n12) }):Play()
end

textButton2.MouseButton1Click:Connect(function()
	if tbl4.dropdownOpen then
		tbl2.closeDropdown()
	else
		tbl2.openDropdown()
	end
end)

for i = 1, tbl3.DROPDOWN_ROWS do
	local v16 = tbl12[i]

	v16.Row.MouseButton1Click:Connect(function()
		local egg = v16.Egg

		if egg then
			tbl4.selectedEgg = egg
			tbl4.selectedUid = egg.Uid
			tbl4.targetEgg = nil

			if tbl4.enabled and not tbl4.carrying and not tbl4.carryLocked and not tbl4.isProtecting and not tbl4.isDelivering then
				tbl2.finishMove()
				tbl4.isStealing = false
			end
		end

		tbl2.closeDropdown()
	end)

	v16.Row.MouseEnter:Connect(function()
		TweenService:Create(v16.Row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(25, 65, 30) }):Play()
	end)

	v16.Row.MouseLeave:Connect(function()
		TweenService:Create(v16.Row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(15, 45, 20) }):Play()
	end)
end

tbl2.refreshEggs = function(arg)
	local now = tick()
	if not arg and now - tbl4.lastRefresh < tbl3.REFRESH_INTERVAL then
		return tbl4.eggs
	end

	local ok, result = pcall(function()
		return tbl.AskFieldEggSnapshot:InvokeServer()
	end)

	if not ok then
		return tbl4.eggs
	end
	local eggs = tbl4.eggs
	table.clear(eggs)

	if result and result.Records then
		local seen = {}
		for _, record in ipairs(result.Records) do
			if (record.State == "Slot" or record.State == "Dropped") and not seen[record.Uid] then
				seen[record.Uid] = true
				local v16 = tbl2.getEggData(record)

				if v16 then
					eggs[#eggs + 1] = v16
				end
			end
		end
	end

	table.sort(eggs, function(arg2, arg3)
		return arg2.Generation > arg3.Generation
	end)

	local filteredEggs = tbl4.filteredEggs
	table.clear(filteredEggs)

	for _, egg in ipairs(eggs) do
		if tbl2.eggMatchesRarityFilter(egg) then
			filteredEggs[#filteredEggs + 1] = egg
		end
	end

	tbl4.bestEgg = tbl4.filteredEggs[1]
	tbl4.lastRefresh = now
	return tbl4.eggs
end

tbl2.getActiveTargetEgg = function()
	if tbl4.selectedEgg then
		for _, filteredEgg in ipairs(tbl4.filteredEggs) do
			if filteredEgg.Uid == tbl4.selectedEgg.Uid then
				tbl4.selectedEgg = filteredEgg
				tbl4.selectedUid = filteredEgg.Uid
				return filteredEgg
			end
		end

		tbl4.selectedEgg = nil
		tbl4.selectedUid = nil
	end

	return tbl4.bestEgg
end

for _, v16 in ipairs(tbl5) do
	local v17 = tbl13[v16.Key]

	v17.Row.MouseButton1Click:Connect(function()
		tbl4.rarityFilter[v16.Key] = not tbl4.rarityFilter[v16.Key]
		tbl4.selectedEgg = nil
		tbl4.selectedUid = nil
		tbl4.targetEgg = nil
		tbl4.lastRefresh = 0
		tbl2.updateRarityChecks()
		tbl2.refreshEggs(true)

		if tbl4.enabled and tbl4.mode == "TELEGUIADO" and not tbl4.carrying and not tbl4.carryLocked and not tbl4.isProtecting and not tbl4.isDelivering then
			tbl2.finishMove()
			tbl4.isStealing = false
		end
	end)

	v17.Row.MouseEnter:Connect(function()
		if not tbl4.rarityFilter[v16.Key] then
			TweenService:Create(v17.Row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(25, 65, 30) }):Play()
		end
	end)

	v17.Row.MouseLeave:Connect(function()
		if not tbl4.rarityFilter[v16.Key] then
			TweenService:Create(v17.Row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(15, 45, 20) }):Play()
		end
	end)
end

tbl2.updateRarityChecks()
local beam = nil
local attachment = nil
local attachment2 = nil

tbl2.clearBeam = function()
	if beam then
		beam:Destroy()
		beam = nil
	end

	if attachment then
		attachment:Destroy()
		attachment = nil
	end

	if attachment2 then
		if attachment2.Parent then
			attachment2.Parent:Destroy()
		end

		attachment2 = nil
	end
end

tbl2.createBeam = function(arg)
	if not humanoidRootPart or not humanoidRootPart.Parent or not arg then
		return
	end
	tbl2.clearBeam()
	attachment = Instance.new("Attachment")
	attachment.Name = "LimaoBeamOrigin"
	attachment.Parent = humanoidRootPart
	local part = Instance.new("Part")
	part.Name = "LimaoBeamTarget"
	part.Size = Vector3.new(0.1, 0.1, 0.1)
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CFrame = CFrame.new(arg)
	part.Parent = workspace
	attachment2 = Instance.new("Attachment")
	attachment2.Parent = part
	beam = Instance.new("Beam")
	beam.Name = "LimaoTargetBeam"
	beam.Attachment0 = attachment
	beam.Attachment1 = attachment2
	beam.Width0 = tbl3.BEAM_WIDTH
	beam.Width1 = tbl3.BEAM_WIDTH
	beam.FaceCamera = true
	beam.LightEmission = 1
	beam.LightInfluence = 0
	beam.Color = ColorSequence.new(Color3.fromRGB(57, 255, 20))
	beam.Parent = humanoidRootPart
end

tbl2.updateBestDisplay = function()
	tbl2.refreshEggs()
	local v16 = tbl2.getActiveTargetEgg()

	pcall(function()
		if not v16 then
			if textLabel5 and textLabel5.Parent and textLabel5.Text ~= "NO EGG FOUND" then
				textLabel5.Text = "NO EGG FOUND"
			end

			if textLabel6 and textLabel6.Parent and textLabel6.Text ~= "" then
				textLabel6.Text = ""
			end

			if textLabel7 and textLabel7.Parent and textLabel7.Text ~= "--" then
				textLabel7.Text = "--"
			end

			tbl2.updatePetPreview(nil)
		else
			local text = tostring(v16.Name or "UNKNOWN")
			local text2 = tostring(v16.RarityName or "")
			local v17 = tbl2.formatNumber(v16.Generation or 0)

			if textLabel5 and textLabel5.Parent and textLabel5.Text ~= text then
				textLabel5.Text = text
			end

			if textLabel6 and textLabel6.Parent then
				if textLabel6.Text ~= text2 then
					textLabel6.Text = text2
				end

				local rarityColor = v16.RarityColor or Color3.fromRGB(57, 255, 20)

				if textLabel6.TextColor3 ~= rarityColor then
					textLabel6.TextColor3 = rarityColor
				end
			end

			if textLabel7 and textLabel7.Parent and textLabel7.Text ~= v17 then
				textLabel7.Text = v17
			end

			tbl2.updatePetPreview(v16.Category)
		end
	end)

	if tbl4.dropdownOpen then
		tbl2.refreshDropdownRows()
	end

	return v16
end

tbl2.updateLoopUI = function()
	if not tbl2.loopBox or not tbl2.loopBox.Parent then
		return
	end

	if tbl4.loopEnabled then
		tbl2.loopBox.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
		tbl2.loopBoxStroke.Color = Color3.fromRGB(120, 255, 100)
		tbl2.loopCheck.Visible = true
		tbl2.loopLabel.TextColor3 = Color3.fromRGB(180, 255, 160)
	else
		tbl2.loopBox.BackgroundColor3 = Color3.fromRGB(12, 30, 15)
		tbl2.loopBoxStroke.Color = Color3.fromRGB(57, 255, 20)
		tbl2.loopCheck.Visible = false
		tbl2.loopLabel.TextColor3 = Color3.fromRGB(120, 255, 100)
	end
end

tbl2.updateToggle = function()
	if tbl4.enabled then
		TweenService:Create(frame9, TweenInfo.new(0.18, Enum.EasingStyle.Quart), { BackgroundColor3 = Color3.fromRGB(20, 220, 60) }):Play()
		TweenService:Create(frame10, TweenInfo.new(0.18, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
		uiStroke6.Color = Color3.fromRGB(57, 255, 20)

		if tbl4.waitingForDay then
			textLabel9.Text = tbl2.isDaytime() and "WAITING FOR GATE" or "WAITING FOR DAY"
		elseif tbl4.engineStatus then
			textLabel9.Text = tbl4.engineStatus
		elseif tbl4.runLoop then
			textLabel9.Text = "LOOP ACTIVE"
		else
			textLabel9.Text = "ONE SHOT IN PROGRESS"
		end
	else
		TweenService:Create(frame9, TweenInfo.new(0.18, Enum.EasingStyle.Quart), { BackgroundColor3 = Color3.fromRGB(12, 30, 15) }):Play()
		TweenService:Create(frame10, TweenInfo.new(0.18, Enum.EasingStyle.Quart), { Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(150, 255, 130) }):Play()
		uiStroke6.Color = Color3.fromRGB(57, 255, 20)
		textLabel9.Text = tbl4.loopEnabled and "LOOP READY" or "ONE SHOT"
	end
end

tbl2.startEggProtection = function(heldEggUid)
	if not heldEggUid then
		return
	end

	if tbl4.isProtecting and tbl4.heldEggUid == heldEggUid then
		return
	end
	tbl4.isProtecting = true
	tbl4.heldEggUid = heldEggUid
	tbl4.lastProtectTime = 0

	task.spawn(function()
		while tbl4.isProtecting and tbl4.heldEggUid == heldEggUid do
			tbl4.lastProtectTime = tick()

			local ok, result = pcall(function()
				return tbl.AskFieldEggCarry:InvokeServer({ Uid = heldEggUid })
			end)

			if ok and result == true then
				tbl4.carrying = true
			end

			task.wait(tbl3.PROTECT_INTERVAL)
		end
	end)
end

tbl2.resetCarryState = function()
	tbl4.carrying = false
	tbl4.carryLocked = false
	tbl4.isProtecting = false
	tbl4.heldEggUid = nil
	tbl4.targetEgg = nil
	tbl2.hideLoading()
	tbl2.clearBeam()
	tbl2.unequipAllTools()
end

tbl2.startDelivery = function()
end

tbl2.startSpammingCarry = function(heldEggUid)
	if not heldEggUid or tbl4.isStealing then
		return
	end

	if tbl4.carrying and tbl4.heldEggUid == heldEggUid then
		return
	end
	tbl4.isStealing = true
	tbl4.lastSpamTime = 0

	task.spawn(function()
		while true do
			if tbl4.isStealing and not tbl4.carrying then
				local now = tick()

				if not (tbl3.SPAM_INTERVAL <= now - tbl4.lastSpamTime) then
					RunService.Heartbeat:Wait()
					continue
				else
					tbl4.lastSpamTime = now

					local ok, result = pcall(function()
						return tbl.AskFieldEggCarry:InvokeServer({ Uid = heldEggUid })
					end)

					if ok and result == true then
						tbl4.isStealing = false
						tbl4.carrying = true
						tbl4.heldEggUid = heldEggUid

						tbl4.carryLocked = true
						tbl2.showLoading("Levando Ovo...")
						tbl2.spawnBossForEgg(tbl4.targetEgg or tbl2.getActiveTargetEgg())

						task.spawn(function()
							tbl2.startEggProtection(heldEggUid)
						end)

						task.spawn(function()
							local v16 = tbl2.getGroundPosition()
							local v17 = tbl2.getBossDeliveryPosition(v16)

							if v16 and v17 then
								tbl4.isDelivering = true
								tbl2.clearBeam()
								tbl2.createBeam(v16)

								tbl2.startMove(v17, function()
									tbl4.isDelivering = false
									tbl2.cleanupBossMount()
									tbl2.resetCarryState()
									tbl2.completeGuidedCycle()
								end, true)
							end
						end)

						break
					else
						RunService.Heartbeat:Wait()
						continue
					end
				end
			end

			break
		end

		tbl4.isStealing = false
	end)
end

tbl2.completeGuidedCycle = function()
	tbl2.hideLoading()
	if not tbl4.guidedCycleActive then
		return
	end
	tbl4.guidedCycleActive = false
	tbl4.lastRefresh = 0
	if tbl4.mode ~= "TELEGUIADO" then
		return
	end

	if tbl4.enabled and tbl4.runLoop then
		tbl2.updateToggle()
		return
	end
	tbl4.enabled = false
	tbl4.waitingForDay = false
	tbl4.runLoop = false
	tbl2.updateToggle()
end

tbl2.startDelivery = function()
	if tbl4.isDelivering then
		return
	end
	local v16 = tbl2.getGroundPosition()
	local v17 = tbl2.getBossDeliveryPosition(v16)
	if not v16 or not v17 then
		return
	end
	tbl4.isDelivering = true
	tbl2.showLoading("Levando Ovo...")
	tbl2.clearBeam()
	tbl2.createBeam(v16)

	if humanoidRootPart and humanoidRootPart.Parent then
		local vector = Vector3.new(v17.X - humanoidRootPart.Position.X, 0, v17.Z - humanoidRootPart.Position.Z)

		if vector.Magnitude > 0.01 then
			humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
		end
	end

	tbl2.startMove(v17, function()
		tbl4.isDelivering = false
		tbl2.cleanupBossMount()
		tbl2.resetCarryState()
		tbl2.completeGuidedCycle()
	end, true)
end

tbl2.moveToBestEggTP = function()
	if tbl4.carrying or tbl4.carryLocked or tbl4.isProtecting or tbl4.isDelivering or tbl4.isMoving or tbl4.isStealing then
		return false
	end
	tbl2.refreshEggs(true)
	local v16 = tbl2.getActiveTargetEgg()
	if not v16 or not humanoidRootPart or not humanoidRootPart.Parent then
		return false
	end

	if tbl4.mode == "TELEGUIADO" then
		tbl4.guidedCycleActive = true

		if tbl4.enabled then
			tbl2.updateToggle()
		end
	end

	tbl4.targetEgg = v16
	local position = v16.Position
	tbl2.createBeam(position)
	if (position - humanoidRootPart.Position).Magnitude <= tbl3.SPAWN_OFFSET then
		tbl2.startSpammingCarry(v16.Uid)
		return
	end

	tbl2.startMove(position - (position - humanoidRootPart.Position).Unit * tbl3.SPAWN_OFFSET, function()
		if tbl4.enabled and not tbl4.carrying and not tbl4.carryLocked and not tbl4.isProtecting and not tbl4.isDelivering and tbl4.targetEgg and tbl4.targetEgg.Uid == v16.Uid then
			tbl2.startSpammingCarry(v16.Uid)
		end
	end)

	return true
end

tbl2.cancelEverything = function()
	tbl2.hideLoading()
	tbl2.cleanupBossMount()
	tbl2.stopCurrentTween(true)
	tbl2.restoreOriginalHumanoid()
	tbl4.isMoving = false
	tbl4.moveTarget = nil
	tbl4.onArrive = nil
	tbl4.isStealing = false
	tbl4.isProtecting = false
	tbl4.isDelivering = false
	tbl4.targetEgg = nil
	tbl4.heldEggUid = nil
	tbl4.carrying = false
	tbl4.carryLocked = false
	tbl4.guidedCycleActive = false
	tbl2.clearBeam()
end

tbl2.setupCharacter = function(arg)
	if tbl2.motorAddedConn then
		tbl2.motorAddedConn:Disconnect()
		tbl2.motorAddedConn = nil
	end

	if tbl2.motorRemovingConn then
		tbl2.motorRemovingConn:Disconnect()
		tbl2.motorRemovingConn = nil
	end

	v = arg
	humanoidRootPart = arg:WaitForChild("HumanoidRootPart")
	humanoid = arg:FindFirstChildOfClass("Humanoid")
	tbl2.motorCache = {}

	tbl2.walk(arg, function(arg2)
		if arg2:IsA("Motor6D") then
			tbl2.motorCache[#tbl2.motorCache + 1] = arg2
		end
	end)

	tbl2.motorAddedConn = arg.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("Motor6D") then
			table.insert(tbl2.motorCache, descendant)
		end
	end)

	tbl2.motorRemovingConn = arg.DescendantRemoving:Connect(function(descendant)
		if not descendant:IsA("Motor6D") then
			return
		end

		for i = #tbl2.motorCache, 1, -1 do
			if tbl2.motorCache[i] == descendant then
				table.remove(tbl2.motorCache, i)
				break
			end
		end
	end)
end

tbl.FieldEggCarry.OnClientEvent:Connect(function(arg)
	if tbl2.newTGRuntime and tbl2.newTGRuntime.running then
		return
	end

	if not arg or not arg.Uid then
		return
	end
	local uid = arg.Uid

	if arg.CarrierUserId == localPlayer.UserId then
		if uid == tbl4.heldEggUid then
			tbl4.carrying = true
			tbl2.showLoading("Levando Ovo...")
			return
		end

		if tbl4.targetEgg and uid == tbl4.targetEgg.Uid then
			tbl4.carrying = true
			tbl4.heldEggUid = uid
			tbl4.carryLocked = true
			tbl4.isStealing = false
			tbl2.showLoading("Levando Ovo...")
			tbl2.spawnBossForEgg(tbl4.targetEgg or tbl2.getActiveTargetEgg())

			task.spawn(function()
				tbl2.startEggProtection(uid)
			end)

			task.spawn(function()
				tbl2.startDelivery()
			end)
		end

		return
	end

	if uid == tbl4.heldEggUid then
		tbl4.carrying = false
		tbl4.carryLocked = false

		if not tbl4.isProtecting then
			task.spawn(function()
				tbl2.startEggProtection(uid)
			end)
		end

		return
	end

	if tbl4.targetEgg and uid == tbl4.targetEgg.Uid then
		tbl4.carrying = false

		if not tbl4.isStealing then
			task.defer(function()
				task.wait(0.02)

				if tbl4.targetEgg and tbl4.targetEgg.Uid == uid and not tbl4.carrying then
					tbl2.startSpammingCarry(uid)
				end
			end)
		end
	end
end)

tbl2.newTGRuntime = tbl2.newTGRuntime or {
	running = false,
	cleanup = nil,
	cooldownUntil = 0,
	desyncOriginal = nil,
	desyncOriginalState = nil,
	desyncFake = nil,
	desyncCharacter = nil,
	desyncStateConn = nil,
	desyncDescConn = nil,
	restoreDesync = nil,
}

tbl2.stopNewTeleguiado = function()
	tbl2.hideLoading()
	local newTGRuntime = tbl2.newTGRuntime
	local cleanup = newTGRuntime.cleanup
	newTGRuntime.cleanup = nil

	if cleanup then
		pcall(cleanup)
	end

	local restoreDesync = newTGRuntime.restoreDesync

	if restoreDesync then
		pcall(restoreDesync)
	end

	if tbl2.instantTP then
		tbl2.instantTP.cancel()
	end
	tbl4.engineStatus = nil
	newTGRuntime.running = false
end

tbl2.AUTO_STEAL_WAYPOINTS = {
	{ name = "WP1", pos = Vector3.new(3340.17, 70.52, -331.08), speed = 4000 },
	{ name = "WP2", pos = Vector3.new(2894.71, 75.64, -327.45), speed = 4000 },
	{ name = "WP3", pos = Vector3.new(1923.22, 75.64, -330.11), speed = 4000 },
	{ name = "WP4", pos = Vector3.new(767.54, 70.51, -327.81), speed = 4000 },
	{ name = "WP5", pos = Vector3.new(596.65, 70.52, -316.80), speed = 1000 },
	{ name = "WP6", pos = Vector3.new(573.61, 70.52, -327.54), speed = 1000 },
	{ name = "WP7", pos = Vector3.new(540.18, 70.52, -356.74), speed = 1000 },
}
tbl2.AUTO_STEAL_RESET_WP_INDEX = 5
tbl2.AUTO_STEAL_SPEED_EGG = 150
tbl2.AUTO_STEAL_SPEED_TWEEN_FAST = 4000
tbl2.AUTO_STEAL_SPEED_TWEEN_SLOW = 1000
tbl2.AUTO_STEAL_SPEED_EGG_TWEEN = 100

tbl2.autoStealDestroyHumanoid = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local hum = character:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			hum:Destroy()
		end)
	end
	local anim = character:FindFirstChild("Animate")
	if anim then
		pcall(function()
			anim:Destroy()
		end)
	end
end

tbl2.autoStealForceReset = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum then
		hum = Instance.new("Humanoid")
		hum.Parent = character
	end
	pcall(function()
		hum.Health = 0
	end)
end

tbl2.autoStealTweenTo = function(position, speed, lookAt)
	local character = localPlayer.Character
	if not character then
		return false
	end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	local cframe = CFrame.new(position)
	if lookAt then
		local dir = Vector3.new(position.X - hrp.Position.X, 0, position.Z - hrp.Position.Z)
		if dir.Magnitude > 0.01 then
			cframe = CFrame.lookAt(position, position + dir.Unit)
		end
	end
	local distance = (position - hrp.Position).Magnitude
	local duration = math.max(distance / speed, 0.01)
	local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = cframe })
	tween:Play()
	tween.Completed:Wait()
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	return true
end

tbl2.autoStealNavigateToEgg = function(targetPosition)
	local character = localPlayer.Character
	if not character then
		return false
	end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end
	local direction = Vector3.new(targetPosition.X - hrp.Position.X, 0, targetPosition.Z - hrp.Position.Z)
	local destination = targetPosition
	if direction.Magnitude > 0.01 then
		destination = targetPosition - direction.Unit * 3
	end
	local distance = (destination - hrp.Position).Magnitude
	local duration = math.max(distance / tbl2.AUTO_STEAL_SPEED_EGG, 0.01)
	local cframe = CFrame.new(destination)
	if direction.Magnitude > 0.01 then
		cframe = CFrame.lookAt(destination, destination + direction.Unit)
	end
	local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = cframe })
	tween:Play()
	tween.Completed:Wait()
	return true
end

local function buildInstantTPEngine(onStatus)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer


------------------------------------------------------------------ settings (same values as the hub)
local CFG = {
	SpeedCap = 1.15, -- never above 115% of the walk speed
	HopRatio = 1.515, -- hop distance = walk speed * ratio (a distance, not a speed)
	HopMin = 40,
	HopGap = 0.06, -- seconds between two hops (learned: grows after a pull-back, shrinks after a clean hop)
	HopGapMin = 0.06,
	HopGapMax = 0.2,
	HopRetries = 6,
	HopLift = 42, -- height of the hops above the start
	LandOffset = 14, -- landing spot in front of the line
	LandSettle = 0.08,
	DropDelay = 0.05,
	GrabInterval = 0.06, -- re-envio do takeEgg (~16/s); a pega detecta no frame via state.Carrying
	GrabSettle = 0.7, -- pausa ao chegar no ovo antes de pedir (evita pedir/correr junto)
	RegrabFar = 40, -- egg further than this: teleport onto it, otherwise run to it
	Height = 70, -- the safe-zone run starts above the base and comes down (same as the hub)
	ClimbShare = 0.5,
	CarryRatio = 0.9,
	EasyRatio = 1.3,
	WP1 = Vector3.new(542.29, 70.43, -367.45), -- base, perto da linha
	WP2 = Vector3.new(1569.24, 70.43, -365.01),
	WP3 = Vector3.new(2380.77, 70.43, -363.54),
	WP_RADIUS = 100, -- so dispara a essa distancia da origem
	WP_DELAY = 1, -- espera entre waypoints (esfria o servidor)
	WP_DELAYFast = 0.5, -- primeira tres posicoes: pulo mais rapido
	WP_DELAYSlow = 0.7, -- normal quando o walkSpeed do player esta abaixo de 100
	Celebrate = true, -- danca fisica ao entregar (todo mundo ve); "" ou false desliga
	CelebrateTime = 2.5, -- segundos de danca antes de parar sozinho
}
local FPS = { 60, 30, 0.15 }

------------------------------------------------------------------ game handles
local function safeRequire(getter)
	local ok, result = pcall(function()
		return require(getter())
	end)
	return ok and result or nil
end

local networkingFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")
local EggState = safeRequire(function() return ReplicatedStorage.Client.EggState end)

local function remote(name)
	return networkingFolder:FindFirstChild(name)
end

local function root()
	local character = localPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

-- "Humanoid Swap" (the hub's default shield, always on in the hub): the character runs on a copy of its humanoid,
-- the original is kept out of the character while we steal. Same code path as the hub.
local shield = { Original = nil, Clone = nil, Links = {}, Connection = nil, Added = nil }

local function walkSpeed()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local speed = humanoid and humanoid.WalkSpeed or 16
	if shield.Original and shield.Original.Health > 0 then
		speed = math.min(speed, shield.Original.WalkSpeed)
	end
	local ok, result = pcall(function()
		local stat = localPlayer:FindFirstChild("leaderstats")
		stat = stat and stat:FindFirstChild("Speed")
		local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
		return stat and util.SpeedPowerToWalkSpeed(stat.Value) or nil
	end)
	if ok and type(result) == "number" and result > 0 then
		speed = math.min(speed, result)
	end
	return speed
end

local function shieldControls(humanoid)
	pcall(function()
		local scripts = localPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if type(controls) == "table" then
				controls.humanoid = humanoid
			end
		end
	end)
end

local function shieldAnimate(character)
	local animate = character and character:FindFirstChild("Animate")
	if animate and animate:IsA("LocalScript") then
		task.spawn(function()
			animate.Enabled = false
			task.wait()
			animate.Enabled = true
		end)
	end
end

local function shieldUnlink()
	for _, link in ipairs(shield.Links) do
		pcall(function()
			link:Disconnect()
		end)
	end
	table.clear(shield.Links)
end

local groundedStates = {
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.RunningNoPhysics] = true,
	[Enum.HumanoidStateType.Landed] = true,
}

local function grounded(humanoid)
	if not humanoid or humanoid.Health <= 0 or humanoid.FloorMaterial == Enum.Material.Air then
		return false
	end
	return groundedStates[humanoid:GetState()] == true
end

local function shieldSwap()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	if shield.Clone and shield.Clone.Parent == character then
		return
	end
	if not grounded(humanoid) then
		return
	end

	local clone = humanoid:Clone()
	humanoid.Parent = nil
	clone.Parent = character
	workspace.CurrentCamera.CameraSubject = clone
	shieldControls(clone)
	shieldAnimate(character)
	shield.Original = humanoid
	shield.Clone = clone

	table.insert(shield.Links, humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if clone.Parent ~= nil then
			clone.WalkSpeed = humanoid.WalkSpeed
		end
	end))

	local animator = humanoid:FindFirstChildOfClass("Animator")
	local animator2 = clone:FindFirstChildOfClass("Animator")
	if animator and animator2 then
		table.insert(shield.Links, animator.AnimationPlayed:Connect(function(played)
			local animation = played.Animation
			if not animation or clone.Parent == nil then
				return
			end
			local ok, track = pcall(function()
				return animator2:LoadAnimation(animation)
			end)
			if not ok or not track then
				return
			end
			pcall(function()
				track.Priority = played.Priority
				track.Looped = played.Looped
				track:Play(0.05, math.max(played.WeightTarget, 0.01), played.Speed)
			end)
			local stopped
			stopped = played.Stopped:Connect(function()
				stopped:Disconnect()
				pcall(function()
					track:Stop(0.1)
				end)
			end)
		end))
	end

	table.insert(shield.Links, clone.Died:Connect(function()
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		local current = localPlayer.Character
		if current and humanoid.Parent == nil then
			humanoid.Parent = current
			workspace.CurrentCamera.CameraSubject = humanoid
			shieldControls(humanoid)
		end
		pcall(function()
			clone:Destroy()
		end)
		humanoid.Health = 0
	end))
end

local function shieldUndo()
	shieldUnlink()
	local character = localPlayer.Character
	local original, clone = shield.Original, shield.Clone
	shield.Original, shield.Clone = nil, nil
	if original and clone and character and original.Parent == nil and clone.Parent == character then
		original.Parent = character
		workspace.CurrentCamera.CameraSubject = original
		shieldControls(original)
		pcall(function()
			clone:Destroy()
		end)
		shieldAnimate(character)
	end
end

local function shieldStart()
	shieldSwap()
	local n = 0
	shield.Connection = RunService.Heartbeat:Connect(function(dt)
		n += dt
		local character = localPlayer.Character
		local missing = not (shield.Clone and character and shield.Clone.Parent == character)
		if (missing and 0.25 or 3) <= n then
			n = 0
			shieldSwap()
		end
	end)
	shield.Added = localPlayer.CharacterAdded:Connect(function(character)
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			task.wait(1)
			if shield.Connection and localPlayer.Character == character then
				shieldSwap()
			end
		end)
	end)
end

local function shieldStop()
	if shield.Connection then
		shield.Connection:Disconnect()
		shield.Connection = nil
	end
	if shield.Added then
		shield.Added:Disconnect()
		shield.Added = nil
	end
	shieldUndo()
end

------------------------------------------------------------------ carry / delivery state
local state = { Carrying = false, Uid = nil, Delivered = 0, Busy = false, Cancel = false, Mult = 1, PulledAt = 0, HeldSeen = 0, GuessedDrop = false }

if type(EggState) == "table" and type(EggState.CarryChanged) == "table" and type(EggState.CarryChanged.Connect) == "function" then
	EggState.CarryChanged:Connect(function(arg)
		local carrying = type(arg) == "table" and arg.IsCarrying == true
		if carrying and arg.GuardDisabled == true then
			carrying = false
		end
		state.GuessedDrop = false
		if carrying then
			state.HeldSeen = os.clock()
		end
		if carrying and type(arg.Uid) == "string" then
			state.Uid = arg.Uid
			local mult = tonumber(arg.SpeedMultiplier)
			if mult and mult > 0 then
				state.Mult = mult
			end
		end
		state.Carrying = carrying
		if carrying then
			tbl2.showLoading("Levando Ovo...")
		else
			tbl2.hideLoading()
		end
	end)
end

pcall(function()
	remote("RE/EggWorld/FieldEggRedeemVerdict").OnClientEvent:Connect(function()
		state.Delivered = os.clock()
		tbl2.hideLoading()
	end)
end)

-- the server pulling us back ("Relocate") is noted so the hop is simply repeated
pcall(function()
	remote("RE/RigSync/Refresh").OnClientEvent:Connect(function(arg)
		if type(arg) == "table" and arg.Action == "Relocate" then
			state.PulledAt = os.clock()
		end
	end)
end)

local function takeEgg(uid)
	if type(uid) == "string" and type(EggState) == "table" and type(EggState.CarryFieldEgg) == "function" then
		pcall(EggState.CarryFieldEgg, uid)
	end
end

local function dropEgg()
	if type(EggState) == "table" and type(EggState.DropFieldEgg) == "function" then
		pcall(EggState.DropFieldEgg, "PlayerRequest")
	end
end

local celebrateAt = 0 -- anti-spam da danca (uma festa por entrega)
local function celebrate()
	if CFG.Celebrate == "" or CFG.Celebrate == false then
		return
	end
	if state.Cancel or os.clock() - celebrateAt < 8 then
		return
	end
	celebrateAt = os.clock()
	task.spawn(function()
		pcall(function()
			local character = localPlayer.Character
			local r = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not r or not humanoid or state.Cancel then
				return
			end
			-- danca fisica: giro + pulinho + inclinacao no lugar.
			-- E movimento real do personagem, entao todo mundo no server ve.
			local dur = math.max(CFG.CelebrateTime, 0.5)
			local base = r.CFrame
			local look = base.LookVector
			local t0 = os.clock()
			while os.clock() - t0 < dur and not state.Cancel do
				RunService.Heartbeat:Wait()
				local t = os.clock() - t0
				local pos = base.Position + Vector3.new(0, math.abs(math.sin(t * 9)) * 2.5, 0)
				r.CFrame = CFrame.new(pos) * CFrame.Angles(0, t * 10, math.sin(t * 9) * 0.25)
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end
			-- volta a olhar pra frente, parado
			pcall(function()
				local p = r.Position
				r.CFrame = CFrame.new(p, p + Vector3.new(look.X, 0, look.Z))
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end)
	end)
end

-- the prompt of the egg itself (nearest egg prompt to the egg's position), never one of another egg
local function promptNear(position, radius)
	local best, bestDistance = nil, radius
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
			local prompt = child:FindFirstChild("CarryAreaEgg")
			if prompt and prompt:IsA("ProximityPrompt") then
				local distance = (child.Position - position).Magnitude
				if distance < bestDistance then
					best, bestDistance = prompt, distance
				end
			end
		end
	end
	return best
end

-- the carried egg is welded to the character: used to catch a missed carry signal (same check as the hub)
local function heldByMe(uid)
	local character = localPlayer.Character
	if type(uid) ~= "string" or not character then
		return false
	end
	local egg = workspace:FindFirstChild(uid)
	if not egg then
		return false
	end
	for _, d in ipairs(egg:GetDescendants()) do
		if d:IsA("WeldConstraint") or d:IsA("JointInstance") then
			local ok, a, b = pcall(function()
				return d.Part0, d.Part1
			end)
			if ok and ((a and a:IsDescendantOf(character)) or (b and b:IsDescendantOf(character))) then
				return true
			end
		end
	end
	return false
end

task.spawn(function()
	while true do
		task.wait(0.5) -- HeldSeen tolera 0.8s, entao 0.5s e seguro
		if not state.Carrying then
			if state.GuessedDrop and heldByMe(state.Uid) then
				state.GuessedDrop, state.Carrying, state.HeldSeen = false, true, os.clock()
			end
		elseif heldByMe(state.Uid) then
			state.HeldSeen = os.clock()
		elseif os.clock() - state.HeldSeen > 0.8 then
			state.Carrying, state.GuessedDrop = false, true
		end
	end
end)

local function snapshot()
	local list = {}
	local ok, result = pcall(function()
		return remote("RF/EggWorld/AskFieldEggSnapshot"):InvokeServer()
	end)
	local records = ok and type(result) == "table" and result.Records or nil
	if type(records) ~= "table" then
		return list
	end
	for _, record in pairs(records) do
		if type(record) == "table" and type(record.Uid) == "string" and (record.State == "Slot" or record.State == "Dropped") and typeof(record.BottomCFrame) == "CFrame" then
			list[#list + 1] = record
		end
	end
	return list
end

local function eggPosition(uid)
	for _, record in ipairs(snapshot()) do
		if record.Uid == uid then
			return record.BottomCFrame.Position
		end
	end
	return nil
end

------------------------------------------------------------------ Instant TP logic
local status = onStatus

local function frozenCamera()
	local camera = workspace.CurrentCamera
	if not camera then
		return function() end
	end
	local oldType = camera.CameraType
	local frame = camera.CFrame
	pcall(function()
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = frame
	end)
	return function()
		pcall(function()
			camera.CameraType = oldType
		end)
	end
end

local fpsGen = 0
local function fpsOn()
	if typeof(setfpscap) ~= "function" then
		return
	end
	fpsGen += 1
	local mine = fpsGen
	task.spawn(function()
		local high = true
		local started = os.clock()
		while fpsGen == mine and os.clock() - started < 60 do
			pcall(setfpscap, high and FPS[1] or FPS[2])
			high = not high
			task.wait(FPS[3])
		end
	end)
end

local function fpsOff()
	fpsGen += 1
	if typeof(setfpscap) == "function" then
		pcall(setfpscap, 240)
	end
end

-- a still copy of the player stays where the egg was taken during the flight; removed on arrival
local stealClone = nil
local function dropClone()
	local copy = stealClone
	stealClone = nil
	if copy then
		pcall(function()
			copy:Destroy()
		end)
	end
end

local function postClone()
	dropClone()
	local character = localPlayer.Character
	if not character then
		return
	end
	local was = character.Archivable
	character.Archivable = true
	local copy = character:Clone()
	character.Archivable = was
	if copy then
		for _, d in ipairs(copy:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("Humanoid") then
				pcall(function()
					d:Destroy()
				end)
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
			end
		end
		copy.Name = "Clone"
		copy.Parent = workspace
		stealClone = copy
	end
end

local function lineInfo()
	local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	world = world and world:FindFirstChild("Areas")
	world = world and world:FindFirstChild("SeparationLine")
	local ok = world and world:IsA("BasePart")
	return ok and world.Position.X or 552.2, ok and world.Position.Y or 67.67
end

local function homePoint()
	for _, def in ipairs({
		{ { "GearGiver_Slap", "Podium" }, Vector3.new(-16.415, 21.072, -6.106) },
		{ { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
		{ { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
	}) do
		local node = workspace
		for _, name in ipairs(def[1]) do
			node = node and node:FindFirstChild(name) or nil
		end
		if node and node:IsA("BasePart") then
			return node.CFrame:PointToWorldSpace(def[2])
		end
	end
	return Vector3.new(528.7, 70.57, -364.11)
end

local function place(position)
	local r = root()
	if not r then
		return
	end
	pcall(function()
		r.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0)
		r.AssemblyLinearVelocity = Vector3.zero
		r.AssemblyAngularVelocity = Vector3.zero
	end)
end

-- portals / arenas / teleporters are walked around (same list as the hub)
local dangerCache, dangerAt = {}, 0
local function dangers()
	if os.clock() - dangerAt < 1 then
		return dangerCache
	end
	dangerAt = os.clock()
	local list = {}
	local function add(inst)
		local ok, cf, size = pcall(function()
			if inst:IsA("Model") then
				return inst:GetBoundingBox()
			elseif inst:IsA("BasePart") then
				return inst.CFrame, inst.Size
			end
		end)
		if ok and cf and size then
			local half = Vector3.new(math.abs(size.X), 0, math.abs(size.Z)) * 0.5
			local rot = (cf - cf.Position):VectorToWorldSpace(half)
			local rx = math.max(math.abs(rot.X), half.X, half.Z)
			local rz = math.max(math.abs(rot.Z), half.X, half.Z)
			list[#list + 1] = { MinX = cf.Position.X - rx, MaxX = cf.Position.X + rx, MinZ = cf.Position.Z - rz, MaxZ = cf.Position.Z + rz }
		end
	end
	local function bad(name)
		if name == "ScrambleLocalVisuals" or name == "DrScrambleEvent" then
			return false
		end
		name = string.lower(name)
		return string.find(name, "portal", 1, true) or string.find(name, "teleport", 1, true) or string.find(name, "mech", 1, true) or string.find(name, "arena", 1, true) or string.find(name, "scramble", 1, true)
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if (child:IsA("Model") or child:IsA("BasePart") or child:IsA("Folder")) and bad(child.Name) then
			if child:IsA("Folder") then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			else
				add(child)
			end
		end
	end
	local build = workspace:FindFirstChild("World")
	build = build and build:FindFirstChild("Build")
	if build then
		for _, child in ipairs(build:GetChildren()) do
			if bad(child.Name) then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			end
		end
	end
	dangerCache = list
	return list
end

-- if the straight line crosses a danger zone, aim at the corner of it instead
local function avoid(from, to)
	for _, d in ipairs(dangers()) do
		local x0, x1, z0, z1 = d.MinX - 12, d.MaxX + 12, d.MinZ - 12, d.MaxZ + 12
		local inside = from.X >= x0 and from.X <= x1 and from.Z >= z0 and from.Z <= z1
		if not inside then
			local t0, t1, hit = 0, 1, true
			for _, axis in ipairs({ { from.X, to.X - from.X, x0, x1 }, { from.Z, to.Z - from.Z, z0, z1 } }) do
				local pos, delta, lo, hi = axis[1], axis[2], axis[3], axis[4]
				if math.abs(delta) < 1e-6 then
					if pos < lo or pos > hi then
						hit = false
					end
				else
					local ta, tb = (lo - pos) / delta, (hi - pos) / delta
					if ta > tb then
						ta, tb = tb, ta
					end
					t0, t1 = math.max(t0, ta), math.min(t1, tb)
					if t0 > t1 then
						hit = false
					end
				end
			end
			if hit then
				local zLow, zHigh = z0 - 2, z1 + 2
				local z = math.abs(from.Z - zLow) <= math.abs(from.Z - zHigh) and zLow or zHigh
				if z < -440 or z > -290 then
					z = z == zLow and zHigh or zLow
				end
				local x = math.abs(from.X - x0) <= math.abs(from.X - x1) and x0 or x1
				if math.abs(from.Z - z) < 3 then
					x = math.abs(to.X - x0) <= math.abs(to.X - x1) and x0 or x1
				end
				return Vector3.new(x, to.Y, z)
			end
		end
	end
	return to
end

-- the hub's "Run" way to the egg: straight on the ground at 115% of the walk speed (never faster).
-- From the base side it first walks out to the safe-zone point, like the hub does.
local function runToEgg(uid, egg)
	local lineX = lineInfo()
	local home = homePoint()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		if character:FindFirstChildWhichIsA("Tool") then
			pcall(function()
				humanoid:UnequipTools()
			end)
		end
	end

	local r = root()
	if not r then
		return false
	end
	local stage = "field"
	if r.Position.X < lineX - 2 and Vector3.new(r.Position.X - home.X, 0, r.Position.Z - home.Z).Magnitude > 20 then
		stage = "safe"
	end

	local started, lastCheck, lastPos, lastTake = os.clock(), os.clock(), r.Position, 0
	local wsRun = walkSpeed() -- 1x aqui: require + leaderstats nao entra no loop
	while os.clock() - started < 120 and not state.Cancel do
		r = root()
		if not r then
			return false
		end
		local flatEgg = Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z)
		if stage == "field" and flatEgg.Magnitude <= 2.5 then
			break
		end
		local target = egg
		if stage == "safe" then
			if Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude <= 6 then
				stage = "field"
			else
				target = home
			end
		end

		local waypoint = avoid(r.Position, target)
		local flat = Vector3.new(waypoint.X - r.Position.X, 0, waypoint.Z - r.Position.Z)
		local unit = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
		local speed = math.max(wsRun * CFG.SpeedCap, 8)
		local v = unit * math.min(speed, flat.Magnitude / 0.05)
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, r.AssemblyLinearVelocity.Y, v.Z)
			if humanoid and unit.Magnitude > 0 then
				humanoid:Move(unit, false)
			end
		end)

		-- stuck on something: jump
		if os.clock() - lastCheck >= 1.5 then
			if (r.Position - lastPos).Magnitude < 3 and humanoid and flatEgg.Magnitude > 15 then
				pcall(function()
					humanoid.Jump = true
				end)
			end
			lastPos, lastCheck = r.Position, os.clock()
		end

		-- close enough for the prompt: ask for the egg while arriving
		if stage == "field" and flatEgg.Magnitude <= 9 and os.clock() - lastTake > 0.1 then
			lastTake = os.clock()
			takeEgg(uid)
		end
		RunService.Heartbeat:Wait()
	end

	r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			if humanoid then
				humanoid:Move(Vector3.zero, false)
			end
		end)
	end
	return state.Carrying or (r ~= nil and Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z).Magnitude <= 6)
end

-- current position of an egg lying in the world (cheap), with the snapshot as fallback
local function eggNow(uid, cache)
	local node = workspace:FindFirstChild(uid)
	local slots = workspace:FindFirstChild("AreaEggSlotsClient")
	node = node or (slots and slots:FindFirstChild(uid))
	if node then
		local ok, pos = pcall(function()
			return node:GetPivot().Position
		end)
		if ok and pos then
			cache.Pos, cache.At = pos, os.clock()
			return pos
		end
	end
	-- carregando: o ovo tá na mão (posição = player), servidor quase nunca precisa;
	-- solto: fallback normal de 0.5s. Evita InvokeServer com yield no meio do loop.
	local fallbackGap = (state.Carrying and state.Uid == uid) and 2 or 0.5
	if os.clock() - cache.At >= fallbackGap then
		cache.At = os.clock()
		if state.Carrying and state.Uid == uid then
			local hr = root()
			cache.Pos = (hr and hr.Position) or eggPosition(uid) or cache.Pos
		else
			cache.Pos = eggPosition(uid) or cache.Pos
		end
	end
	return cache.Pos
end

-- take the egg that lies next to us (also used to take it back after the drop): follow it, fire its prompt and send the request
local function grab(uid, timeout)
	local cache = { At = 0 }
	local waited, since = 0, 1
	local wsGrab = walkSpeed() -- 1x aqui, nao por frame
	local promptAt, promptGot = 0, nil -- prompt varrido no maximo 2x por segundo
	while not state.Carrying and waited < timeout and not state.Cancel do
		local r = root()
		local egg = eggNow(uid, cache)
		local dt = math.max(RunService.Heartbeat:Wait(), 1 / 240)
		waited += dt
		since += dt
		if r and egg then
			local delta = egg - r.Position
			if delta.Magnitude > 2 then
				local pace = math.max(wsGrab * CFG.SpeedCap, 16)
				local v = delta / math.max(0.08, dt)
				if v.Magnitude > pace then
					v = v.Unit * pace
				end
				pcall(function()
					r.AssemblyLinearVelocity = v + Vector3.new(0, workspace.Gravity * dt * 0.5, 0)
					r.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			if since >= CFG.GrabInterval then
				since = 0
				if os.clock() - promptAt > 0.5 then
					promptAt = os.clock()
					promptGot = promptNear(egg - Vector3.new(0, 3, 0), 10)
				end
				local prompt = promptGot
				if prompt and typeof(fireproximityprompt) == "function" then
					pcall(function()
						prompt.HoldDuration = 0
					end)
					pcall(fireproximityprompt, prompt)
				end
				task.spawn(takeEgg, uid)
			end
		elseif since >= CFG.GrabInterval then
			since = 0
			task.spawn(takeEgg, uid)
		end
	end
	local r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.zero
		end)
	end
	return state.Carrying and state.Uid == uid
end

local function regrab(uid)
	if state.Carrying then
		return true
	end
	local r = root()
	local egg = eggPosition(uid)
	if r and egg and Vector3.new(r.Position.X - egg.X, 0, r.Position.Z - egg.Z).Magnitude > CFG.RegrabFar then
		status("The egg fell far behind, teleporting onto it")
		place(egg + Vector3.new(0, 3, 0))
	else
		status("The egg fell close, taking it back")
	end
	return grab(uid, 3)
end

local function groundY(position, fallback)
	local y = fallback
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { localPlayer.Character }
		params.IgnoreWater = true
		local hit = workspace:Raycast(position + Vector3.new(0, 60, 0), Vector3.new(0, -140, 0), params)
		if hit and hit.Material ~= Enum.Material.Water and math.abs(hit.Position.Y - fallback) < 40 then
			y = hit.Position.Y + 3.5
		end
	end)
	return y
end

-- safe zone: same route as the Normal mode: checkpoint 7 studs past the line, then the base.
-- Speed = the hub's carry plan (never above 115% of the walk speed), the run starts above the base and comes down.
local function carrySpeed(distance)
	local ws = walkSpeed()
	local base = ws * math.min(CFG.CarryRatio, CFG.SpeedCap) * state.Mult
	local fast = base * 1.5 -- SpeedRatio
	local excess = 5.5 * base -- ExcessSeconds
	local limit = fast
	if distance and distance > excess then
		limit = math.min(fast, base * distance / (distance - excess))
	end
	return math.min(math.max(math.min(base * CFG.EasyRatio, limit), base), math.max(ws * CFG.SpeedCap, base))
end

local function runHome(lineX, laneZ)
	local started = os.clock()
	local home = homePoint()
	local checkpoint = lineX - 7
	local height = CFG.Height
	local share = math.clamp(CFG.ClimbShare, 0.1, 0.9)
	local descent = height * math.sqrt(1 - share * share) / share
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
	end

	-- rise above the base first (no horizontal move), like the hub
	local r = root()
	if r and character and height > 0.5 and home.Y + height - 2 > r.Position.Y then
		pcall(function()
			character:PivotTo(CFrame.new(Vector3.new(r.Position.X, home.Y + height, r.Position.Z)) * r.CFrame.Rotation)
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	-- the speed is planned once, at the start, from the distance still to go (the hub does the same)
	local start = root()
	local speed = carrySpeed(start and (Vector3.new(start.Position.X - home.X, 0, start.Position.Z - home.Z).Magnitude + math.max(0, height) * 2) or nil)

	local last = os.clock()
	local timeout = 0
	status("Safe zone")
	while state.Carrying and state.Delivered < started and not state.Cancel and timeout < 25 do
		r = root()
		if not r then
			return false
		end
		local now = os.clock()
		local dt = math.max(now - last, 1 / 240)
		last = now
		timeout += dt

		local toHome = r.Position.X <= checkpoint + 2
		local target = toHome and home or Vector3.new(checkpoint, home.Y, laneZ)
		if toHome and Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude < 2 then
			break
		end
		local aim = avoid(r.Position, target)
		local flat = Vector3.new(aim.X - r.Position.X, 0, aim.Z - r.Position.Z)
		local remaining = toHome and 0 or math.max(0, r.Position.X - checkpoint)
		local wantY = home.Y + height
		if toHome or remaining <= descent then
			wantY = home.Y + height * math.clamp(remaining / math.max(descent, 1), 0, 1)
		end
		local vy = math.clamp((wantY - r.Position.Y) / 0.12, -speed * share, speed * share)
		local horizontal = math.sqrt(math.max(speed * speed - vy * vy, 0))
		local v = flat.Magnitude > 0.01 and flat.Unit * math.min(horizontal, flat.Magnitude / 0.05) or Vector3.zero
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
		end)
		RunService.Heartbeat:Wait()
	end

	if humanoid then
		pcall(function()
			humanoid:Move(Vector3.zero, false)
		end)
	end

	local settle = 0
	while settle < 2 and state.Delivered < started and state.Carrying and not state.Cancel do
		settle += RunService.Heartbeat:Wait()
	end
	-- still in the hands at home: put it down so the base takes it
	if state.Carrying and state.Delivered < started and not state.Cancel then
		task.wait(0.2)
		dropEgg()
		local waited = 0
		while state.Delivered < started and waited < 1 do
			waited += RunService.Heartbeat:Wait()
		end
	end
	return state.Delivered >= started
end

local function instantTP(uid)
	local started = os.clock()
	local lineX, lineY = lineInfo()
	local r = root()
	if not r then
		return false
	end
	local laneZ = math.clamp(r.Position.Z, -425, -300)
	local landing = Vector3.new(lineX + CFG.LandOffset, lineY + 3.35, laneZ)

	-- hops towards the line; a pull-back repeats the same hop with a longer pause (the pause is learned)
	local hopStep = math.max(walkSpeed() * CFG.HopRatio, CFG.HopMin)
	local hopY = r.Position.Y + CFG.HopLift
	local x = r.Position.X
	local retries = 0
	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	pcall(postClone)
	fpsOn()

	while x - hopStep > landing.X and not state.Cancel do
		if not state.Carrying then
			-- the server let go of the egg on the way: take it back right away
			if not regrab(uid) then
				break
			end
			local current = root()
			if current then
				x = math.min(x, current.Position.X)
			end
			continue
		end

		local nextX = x - hopStep
		status(string.format("Instant TP: hopping home, X %d", math.floor(nextX)))
		local pulledBefore = state.PulledAt
		local held = 0
		while held < CFG.HopGap do
			place(Vector3.new(nextX, hopY, laneZ))
			held += RunService.Heartbeat:Wait()
		end

		local check = root()
		local pulled = state.PulledAt > pulledBefore or (check ~= nil and (check.Position.X - nextX > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and state.Carrying and not state.Cancel then
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.02)
			if retries > CFG.HopRetries then
				break
			end
			status(string.format("Instant TP: pulled back, retry %d/%d", retries, CFG.HopRetries))
			local settle = 0
			while settle < 0.12 and not state.Cancel do
				place(Vector3.new(x, hopY, laneZ))
				settle += RunService.Heartbeat:Wait()
			end
		else
			x = nextX
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
		end
	end

	-- landing in front of the line
	status("Instant TP: landing next to the line")
	landing = Vector3.new(landing.X, groundY(landing, landing.Y), landing.Z)
	local function land()
		local current = root()
		-- never jump backwards: if we are already closer to the line than the landing spot, stay
		if current and current.Position.X <= landing.X + 1 and current.Position.Y > landing.Y - 25 then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
			end)
			return
		end
		place(landing)
	end
	land()
	for attempt = 1, 3 do
		local settle = 0
		while settle < CFG.LandSettle and not state.Cancel do
			settle += RunService.Heartbeat:Wait()
		end
		local landed = root()
		if state.Carrying and landed and (landed.Position.X - landing.X > 12 or landed.Position.Y < landing.Y - 25) then
			status("Instant TP: landing retry " .. attempt)
			land()
		else
			break
		end
	end
	dropClone()

	-- drop at the line, take it back
	if state.Carrying and not state.Cancel then
		local delay = 0
		while delay < CFG.DropDelay do
			delay += RunService.Heartbeat:Wait()
		end
		status("Instant TP: dropping the egg")
		dropEgg()
		local waited = 0
		while state.Carrying and waited < 1 and not state.Cancel do
			waited += RunService.Heartbeat:Wait()
		end
		local current = root()
		if current then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
				current.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		-- egg is down: let go of the camera and the copy, then take it back
		releaseCamera()
		dropClone()
		status("Instant TP: taking the egg back")
		if not grab(uid, 3) and not regrab(uid) then
			fpsOff()
			status("Could not take the egg back")
			return false
		end
		dropClone()
	end
	releaseCamera()

	-- straight to the safe zone
	local ok = false
	if state.Carrying then
		ok = runHome(lineX, laneZ)
	end
	fpsOff()
	return ok or state.Delivered >= started
end

-- Waypoints POS1 <-> POS2 com os hops do bypass (instantTP).
-- So dispara a WP_RADIUS da origem; do destino continua voando normal.
local function wpTP(target, force, delaySec)
	if state.Busy and not force then
		return false
	end
	if not force then
		state.Cancel = false
	end
	-- espera esfria o servidor (TP em sequencia da red)
	if delaySec and delaySec > 0 then
		local w = 0
		while w < delaySec and not state.Cancel do
			w += RunService.Heartbeat:Wait()
		end
		if state.Cancel then
			return false
		end
	end
	local r = root()
	if not r then
		return false
	end
	local hopStep = math.max(walkSpeed() * CFG.HopRatio, CFG.HopMin)
	local hopY = r.Position.Y + CFG.HopLift
	local retries = 0
	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	-- sem postClone aqui: o decoy só importa no voo de entrega (instantTP);
	-- na cadeia o clone inteiro por waypoint é hitch puro
	fpsOn()

	while not state.Cancel do
		local cur = root()
		if not cur then
			break
		end
		local flat = Vector3.new(target.X - cur.Position.X, 0, target.Z - cur.Position.Z)
		if flat.Magnitude <= hopStep then
			break
		end
		local nextP = cur.Position + flat.Unit * hopStep
		local pulledBefore = state.PulledAt
		local held = 0
		while held < CFG.HopGap do
			place(Vector3.new(nextP.X, hopY, nextP.Z))
			held += RunService.Heartbeat:Wait()
		end
		local check = root()
		local back = check and Vector3.new(check.Position.X - nextP.X, 0, check.Position.Z - nextP.Z).Magnitude or 0
		local pulled = state.PulledAt > pulledBefore or (check ~= nil and (back > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and not state.Cancel then
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.02)
			if retries > CFG.HopRetries then
				break
			end
			local settle = 0
			while settle < 0.12 and not state.Cancel do
				place(Vector3.new(cur.Position.X, hopY, cur.Position.Z))
				settle += RunService.Heartbeat:Wait()
			end
		else
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
		end
	end

	if state.Cancel then
		fpsOff()
		return false
	end
	local fin = root()
	if not fin then
		fpsOff()
		return false
	end
	if Vector3.new(target.X - fin.Position.X, 0, target.Z - fin.Position.Z).Magnitude > hopStep + 5 then
		fpsOff()
		return false
	end
	place(Vector3.new(target.X, groundY(target, target.Y), target.Z))
	local settle = 0
	while settle < CFG.LandSettle and not state.Cancel do
		settle += RunService.Heartbeat:Wait()
	end
	-- sem dropClone: wpTP não clona mais (só instantTP)
	releaseCamera()
	fpsOff()
	return not state.Cancel
end

local function waypointChain(egg)
	local savedHopGap = CFG.HopGap
	local CHAIN = { CFG.WP1, CFG.WP2, CFG.WP3 }
	local hops = 0
	while hops < 20 and not state.Cancel and egg do
		local me = root()
		if not me then
			break
		end
		local px, pz = me.Position.X, me.Position.Z
		local bi, bd = 0, math.huge
		for i, w in ipairs(CHAIN) do
			local d = Vector3.new(w.X - px, 0, w.Z - pz).Magnitude
			if d < bd then
				bi, bd = i, d
			end
		end
		if bd > CFG.WP_RADIUS then
			break
		end
		local eggD = Vector3.new(egg.X - px, 0, egg.Z - pz).Magnitude
		local ni, nd = 0, math.huge
		for _, i in ipairs({ bi - 1, bi + 1 }) do
			local w = CHAIN[i]
			if w then
				local d = Vector3.new(w.X - egg.X, 0, w.Z - egg.Z).Magnitude
				if d < nd then
					ni, nd = i, d
				end
			end
		end
		if ni == 0 or eggD <= nd + 20 then
			break
		end
		status("Indo pra POS" .. ni)
		local delay = nil
		if hops > 0 then
			local normal = walkSpeed() < 100 and CFG.WP_DELAYSlow or CFG.WP_DELAY
			delay = ni <= 3 and CFG.WP_DELAYFast or normal
		end
		if not wpTP(CHAIN[ni], true, delay) then
			break
		end
		hops += 1
	end
	CFG.HopGap = savedHopGap
	state.ReleaseCamera = nil
end

local function run(uid)
	if state.Busy then
		return false
	end
	state.Busy = true
	state.Cancel = false
	local delivered = false
	local ok, err = pcall(function()
		status("Looking for the egg")
		local egg = eggPosition(uid)
		if not egg then
			status("That egg is gone")
			return
		end
		if state.Carrying and state.Uid ~= uid then
			dropEgg()
			local waited = 0
			while state.Carrying and waited < 1 do
				waited += RunService.Heartbeat:Wait()
			end
		end
		waypointChain(egg)
		fpsOn()
		status("Going to the egg")
		if not runToEgg(uid, egg) then
			status("Could not reach the egg")
			return
		end
		status("Taking the egg")
		local settle = 0
		while settle < CFG.GrabSettle and not state.Cancel do
			settle += RunService.Heartbeat:Wait()
		end
		if not grab(uid, 4) then
			status("The egg would not come free")
			return
		end
		delivered = instantTP(uid)
		status(delivered and "Delivered" or "Delivery failed")
		if delivered then
			task.spawn(celebrate)
		end
	end)
	fpsOff()
	dropClone()
	if state.ReleaseCamera then
		pcall(state.ReleaseCamera)
		state.ReleaseCamera = nil
	end
	if not ok then
		status("Error: " .. tostring(err))
	end
	state.Busy = false
	tbl2.hideLoading()
	return delivered
end

return {
	run = run,
	state = state,
	cancel = function()
		state.Cancel = true
		tbl2.hideLoading()
	end,
	shieldStart = shieldStart,
	shieldStop = shieldStop,
}
end

local INSTANT_TP_STATUS = {
	["Looking for the egg"] = "SEARCHING EGG",
	["Going to the egg"] = "GOING TO EGG",
	["Taking the egg"] = "TAKING EGG",
	["Delivered"] = "DELIVERED",
	["Delivery failed"] = "DELIVERY FAILED",
	["That egg is gone"] = "EGG GONE",
	["Could not reach the egg"] = "COULD NOT REACH EGG",
	["The egg would not come free"] = "EGG NOT FREE",
	["Could not take the egg back"] = "COULD NOT RETAKE EGG",
}

tbl2.instantTP = buildInstantTPEngine(function(msg)
	msg = tostring(msg)
	local pos = string.match(msg, "^Indo pra (POS%d)")
	local text = INSTANT_TP_STATUS[msg] or (pos and ("GOING TO " .. pos)) or (string.sub(msg, 1, 5) == "Error" and "ERROR" or "DELIVERING")
	if string.sub(msg, 1, 5) == "Error" then
		warn("[LIMÃO INSTANT TP]", msg)
	end
	if tbl4.engineStatus ~= text then
		tbl4.engineStatus = text
		if tbl4.enabled then
			tbl2.updateToggle()
		end
	end
end)
local previousInstantTP = getgenv().LimaoInstantTP or getgenv().LennonInstantTP
if previousInstantTP then
	pcall(previousInstantTP.cancel)
	pcall(previousInstantTP.shieldStop)
end
getgenv().LimaoInstantTP = tbl2.instantTP
tbl2.instantTP.shieldStart()

tbl2.startNewTeleguiado = function()
	local newTGRuntime = tbl2.newTGRuntime
	if newTGRuntime.running or tbl2.instantTP.state.Busy then
		return false
	end

	if tick() < (newTGRuntime.cooldownUntil or 0) then
		return false
	end

	if not tbl4.enabled then
		return false
	end

	if not tbl2.canLeaveForSteal() then
		tbl4.waitingForDay = true
		tbl2.updateToggle()
		return false
	end

	tbl4.mode = "TELEGUIADO"
	tbl4.waitingForDay = false
	tbl2.refreshEggs(true)
	local egg = tbl2.getActiveTargetEgg()

	if not egg then
		tbl4.lastRefresh = 0
		if tbl4.loopEnabled then
			tbl4.engineStatus = "WAITING FOR EGG"
			tbl2.updateToggle()
		else
			tbl4.engineStatus = nil
			tbl4.enabled = false
			tbl4.runLoop = false
			tbl2.updateToggle()
		end
		return false
	end

	newTGRuntime.running = true
	tbl4.targetEgg = nil
	tbl2.createBeam(egg.Position)

	task.spawn(function()
		local delivered = tbl2.instantTP.run(egg.Uid)
		tbl2.clearBeam()
		newTGRuntime.running = false
		tbl4.lastRefresh = 0

		if not tbl4.enabled then
			tbl4.engineStatus = nil
			tbl2.updateToggle()
			return
		end

		if tbl4.loopEnabled then
			newTGRuntime.cooldownUntil = tick() + 0.15
			task.delay(0.16, function()
				if tbl4.enabled and tbl4.loopEnabled then
					tbl2.startNewTeleguiado()
				end
			end)
		else
			tbl2.showToast(delivered and "Delivered" or "Delivery failed")
			tbl4.engineStatus = nil
			tbl4.enabled = false
			tbl4.runLoop = false
			tbl4.waitingForDay = false
			tbl2.updateToggle()
		end
	end)

	return true
end


local fn2 = nil

task.spawn(function()
	while tbl4.running do
		task.wait(tbl3.REFRESH_INTERVAL)

		if tbl4.enabled or frame.Visible then
			tbl2.updateBestDisplay()
		end

		if tbl4.enabled then
			if not tbl2.canLeaveForSteal() then
				if not tbl4.waitingForDay then
					tbl4.waitingForDay = true
					tbl2.updateToggle()
				end
			else
				if tbl4.waitingForDay then
					tbl4.waitingForDay = false
					tbl2.updateToggle()
				end

				if not tbl2.newTGRuntime.running then
					fn2()
				end
			end
		end
	end
end)

tbl2.updateModeUI = function()
	tbl4.mode = "TELEGUIADO"
	textLabel8.Text = "TELEGUIADO"

	if tbl4.enabled and tbl4.waitingForDay then
		textLabel9.Text = tbl2.isDaytime() and "WAITING FOR GATE" or "WAITING FOR DAY"
	elseif tbl4.enabled and tbl4.engineStatus then
		textLabel9.Text = tbl4.engineStatus
	elseif tbl4.enabled then
		textLabel9.Text = tbl4.runLoop and "LOOP ACTIVE" or "ONE SHOT IN PROGRESS"
	else
		textLabel9.Text = tbl4.loopEnabled and "LOOP READY" or "ONE SHOT"
	end
end

fn2 = function()
	if not tbl4.enabled then
		return false
	end
	tbl4.mode = "TELEGUIADO"

	if not tbl2.canLeaveForSteal() then
		tbl4.waitingForDay = true
		tbl2.updateToggle()
		return false
	end

	tbl4.waitingForDay = false
	tbl2.updateToggle()
	tbl2.refreshEggs(true)
	tbl2.updateBestDisplay()
	return tbl2.startNewTeleguiado()
end

tbl2.loopButton.MouseButton1Click:Connect(function()
	tbl4.loopEnabled = not tbl4.loopEnabled
	tbl2.updateLoopUI()

	if not tbl4.enabled then
		tbl2.updateToggle()
	end
end)

tbl2.loopButton.MouseEnter:Connect(function()
	tbl2.loopLabel.TextColor3 = Color3.fromRGB(150, 255, 130)
end)

tbl2.loopButton.MouseLeave:Connect(function()
	tbl2.updateLoopUI()
end)

textButton3.MouseButton1Click:Connect(function()
	if tbl4.enabled then
		tbl4.enabled = false
		tbl4.waitingForDay = false
		tbl4.runLoop = false
		tbl4.guidedCycleActive = false
		tbl2.stopNewTeleguiado()
		tbl2.cancelEverything()
		tbl2.updateToggle()
		return
	end

	tbl2.stopNewTeleguiado()
	tbl2.cancelEverything()
	tbl4.mode = "TELEGUIADO"
	tbl4.runLoop = tbl4.loopEnabled
	tbl4.enabled = true
	tbl4.waitingForDay = not tbl2.canLeaveForSteal()
	tbl2.updateToggle()
	tbl2.refreshEggs(true)
	tbl2.updateBestDisplay()
	if tbl4.waitingForDay then
		tbl2.showToast(tbl2.isDaytime() and "Waiting for gate" or "Teleguiado armed: waiting for day")
		return
	end
	fn2()
end)

textButton3.MouseEnter:Connect(function()
	TweenService:Create(textButton3, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(25, 65, 30) }):Play()
end)

textButton3.MouseLeave:Connect(function()
	TweenService:Create(textButton3, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(15, 45, 20) }):Play()
end)

local flag2 = true

tbl2.openPanel = function()
	flag2 = true
	frame.Visible = true
	v15 = nil
	tbl2.updateBestDisplay()
	frame.Size = UDim2.fromOffset(n2 - 18, n3 - 15)
	TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(262, 185) }):Play()
end

tbl2.closePanel = function()
	flag2 = false

	if tbl4.dropdownOpen then
		tbl4.dropdownOpen = false
		frame11.Visible = false
		textButton3.Visible = true
		frame6.Rotation = 0
	end

	local tween = TweenService:Create(frame, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.fromOffset(n2 - 18, n3 - 15) })
	tween:Play()

	tween.Completed:Connect(function()
		if not flag2 then
			frame.Visible = false
		end
	end)
end

imageButton.MouseButton1Click:Connect(function()
	if flag2 then
		tbl2.closePanel()
	else
		tbl2.openPanel()
	end
end)

textButton.MouseButton1Click:Connect(tbl2.closePanel)
local flag3 = nil
local position = nil
local position2 = nil
local v16 = nil

frame2.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		flag3 = true
		position = input.Position
		position2 = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				flag3 = false
			end
		end)
	end
end)

frame2.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		v16 = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if flag3 and v16 and input == v16 then
		local n13 = input.Position - position
		frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n13.X, position2.Y.Scale, position2.Y.Offset + n13.Y)
	end
end)

imageButton.MouseEnter:Connect(function()
	TweenService:Create(imageButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(50, 50) }):Play()
end)

imageButton.MouseLeave:Connect(function()
	TweenService:Create(imageButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(46, 46) }):Play()
end)

if localPlayer.Character then
	task.spawn(function()
		tbl2.setupCharacter(localPlayer.Character)
	end)
end

localPlayer.CharacterAdded:Connect(function(character)
	tbl2.stopNewTeleguiado()
	tbl2.cancelEverything()
	tbl2.setupCharacter(character)

	if tbl4.enabled then
		task.wait(1)

		if tbl2.canLeaveForSteal() then
			tbl4.waitingForDay = false
			tbl2.updateToggle()
			fn2()
		else
			tbl4.waitingForDay = true
			tbl2.updateToggle()
		end
	end
end)

tbl2.updateModeUI()
tbl2.updateLoopUI()
tbl2.updateToggle()
tbl2.updateRarityChecks()
tbl2.integrityDynamicText = { [textLabel3] = true, [textLabel5] = true, [textLabel6] = true, [textLabel7] = true, [textLabel8] = true, [textLabel9] = true }
tbl2.integrityDynamicTextColor = { [textLabel6] = true, [tbl2.loopLabel] = true }
tbl2.integrityDynamicTextTransparency = { [textLabel3] = true }
tbl2.integrityDynamicBackground = { [textButton3] = true, [tbl2.loopBox] = true, [frame9] = true, [frame10] = true }
tbl2.integrityDynamicBackgroundTransparency = { [frame3] = true }
tbl2.integrityDynamicSize = { [frame] = true, [imageButton] = true }
tbl2.integrityDynamicPosition = { [frame] = true, [frame3] = true, [frame10] = true }
tbl2.integrityDynamicRotation = { [frame6] = true }
tbl2.integrityDynamicStrokeColor = { [uiStroke4] = true, [uiStroke6] = true, [tbl2.loopBoxStroke] = true }
tbl2.integrityDynamicStrokeTransparency = { [uiStroke3] = true }

for i = 1, #tbl12 do
	local v17 = tbl12[i]
	tbl2.integrityDynamicText[v17.NameLabel] = true
	tbl2.integrityDynamicText[v17.RarityLabel] = true
	tbl2.integrityDynamicText[v17.ValueLabel] = true
	tbl2.integrityDynamicTextColor[v17.RarityLabel] = true
	tbl2.integrityDynamicBackground[v17.Row] = true
end

for _, v17 in pairs(tbl13) do
	tbl2.integrityDynamicText[v17.Box] = true
	tbl2.integrityDynamicTextColor[v17.Box] = true
	tbl2.integrityDynamicBackground[v17.Row] = true
	tbl2.integrityDynamicBackground[v17.Box] = true
	tbl2.integrityDynamicBackgroundTransparency[v17.Box] = true
	tbl2.integrityDynamicStrokeColor[v17.Stroke] = true
	tbl2.integrityDynamicStrokeTransparency[v17.Stroke] = true
end

local tbl15 = { instance = textLabel5, properties = { "Text" }, repair = tbl2.updateBestDisplay }
local tbl16 = { instance = textLabel6, properties = { "Text", "TextColor3" }, repair = tbl2.updateBestDisplay }
local tbl17 = { instance = textLabel7, properties = { "Text" }, repair = tbl2.updateBestDisplay }
local tbl18 = { instance = uiStroke6, properties = { "Color" }, repair = tbl2.updateToggle }
local tbl19 = { instance = tbl2.loopBox, properties = { "BackgroundColor3" }, repair = tbl2.updateLoopUI }
local tbl20 = { instance = tbl2.loopBoxStroke, properties = { "Color" }, repair = tbl2.updateLoopUI }

tbl2.armHubIntegrity({
	gui = screenGui,
	dynamicText = tbl2.integrityDynamicText,
	dynamicTextColor = tbl2.integrityDynamicTextColor,
	dynamicTextTransparency = tbl2.integrityDynamicTextTransparency,
	dynamicBackground = tbl2.integrityDynamicBackground,
	dynamicBackgroundTransparency = tbl2.integrityDynamicBackgroundTransparency,
	dynamicSize = tbl2.integrityDynamicSize,
	dynamicPosition = tbl2.integrityDynamicPosition,
	dynamicRotation = tbl2.integrityDynamicRotation,
	dynamicStrokeColor = tbl2.integrityDynamicStrokeColor,
	dynamicStrokeTransparency = tbl2.integrityDynamicStrokeTransparency,
	computed = {
		{ instance = textLabel8, properties = { "Text" }, repair = tbl2.updateModeUI },
		{
			instance = textLabel9,
			properties = { "Text" },
			repair = function()
				tbl2.updateToggle()
				tbl2.updateModeUI()
			end,
		},
		tbl15,
		tbl16,
		tbl17,
		tbl18,
		tbl19,
		tbl20,
	},
	refresh = function()
		tbl2.updateModeUI()
		tbl2.updateLoopUI()
		tbl2.updateToggle()
		tbl2.updateRarityChecks()
		tbl2.updateBestDisplay()
	end,
})

for i = 1, #tbl12 do
	local v17 = tbl12[i]
	tbl2.integrityWatchComputed(v17.NameLabel, { "Text" }, tbl2.refreshDropdownRows)
	tbl2.integrityWatchComputed(v17.RarityLabel, { "Text", "TextColor3" }, tbl2.refreshDropdownRows)
	tbl2.integrityWatchComputed(v17.ValueLabel, { "Text" }, tbl2.refreshDropdownRows)
end

for _, v17 in pairs(tbl13) do
	tbl2.integrityWatchComputed(v17.Box, { "Text", "TextColor3", "BackgroundColor3", "BackgroundTransparency" }, tbl2.updateRarityChecks)
	tbl2.integrityWatchComputed(v17.Stroke, { "Color", "Transparency" }, tbl2.updateRarityChecks)
end

task.spawn(function()
	task.wait(1)
	tbl2.refreshEggs(true)
	tbl2.updateBestDisplay()
end)
