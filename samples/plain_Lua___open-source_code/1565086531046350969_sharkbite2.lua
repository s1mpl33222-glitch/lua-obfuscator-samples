local players = game:GetService("Players")
local run = game:GetService("RunService")

local player = players.LocalPlayer

local env = getgenv and getgenv() or _G
if env.SharkbiteLoadedFor == player then
	return
end
env.SharkbiteLoadedFor = player

local scripts = player.PlayerScripts
local sharks = workspace:WaitForChild("Sharks")
local weapons = game:GetService("ReplicatedStorage"):WaitForChild("ClientViewportObjects"):WaitForChild("Weapons")

local skip = { Turtle = true, FlareGun = true, BaitBucket = true }
local dirs = { Vector3.xAxis, Vector3.zAxis, -Vector3.xAxis, -Vector3.zAxis }

local getUpvalue = debug.getupvalue or getupvalue

local remote
if getUpvalue then
	local ok, result = pcall(function()
		return getUpvalue(getUpvalue(getUpvalue(require(scripts.ProjectilesClient.WeaponScript.HitScanFire).Fire, 6), 5), 2)
	end)
	if ok and typeof(result) == "Instance" then
		remote = result
	end
end

local afk = scripts:FindFirstChild("AFK")
if afk then
	afk:Destroy()
end
local oxygen = scripts:FindFirstChild("HUD") and scripts.HUD:FindFirstChild("Oxygen")
if oxygen then
	oxygen:Destroy()
end
workspace.FallenPartsDestroyHeight = math.nan

local character, humanoid, hrp, backpack

local function onCharacter(char)
	local hum = char:WaitForChild("Humanoid")
	character, humanoid, hrp, backpack = char, hum, hum.RootPart, player:WaitForChild("Backpack")
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then
	task.spawn(onCharacter, player.Character)
end

local function disconnect(conns)
	for _, conn in conns do
		conn:Disconnect()
	end
	table.clear(conns)
end

local side = 1
local params = RaycastParams.new()

local function cast(origin, dir)
	local hit = workspace:Raycast(origin, dir * 300, params)
	return hit and hit.Distance or 300
end

local function sharkCenter(shark)
	local center = shark:GetBoundingBox().Position
	params.FilterDescendantsInstances = { character, shark }

	local dist = cast(center, dirs[side])
	if dist < 200 then
		local start = side
		for i, dir in dirs do
			if i ~= start then
				local d = cast(center, dir)
				if d > dist then
					side, dist = i, d
				end
			end
		end
	end
	return center + dirs[side] * dist
end

local killConn

local function farm()
	if not (hrp and tostring(player.Team) == "Survivor") then
		return
	end

	local shark = sharks:FindFirstChildOfClass("Model")
	if not shark then
		local chinook = workspace:FindFirstChild("Chinook")
		local interior = chinook and chinook:FindFirstChild("interior")
		if interior then
			humanoid.Sit = false
			hrp.CFrame = interior.CFrame
		end
		return
	end

	for _, tool in backpack:GetChildren() do
		if not skip[tool.Name] and weapons:FindFirstChild(tool.Name) then
			tool.Parent = character
		end
	end

	humanoid.Sit = false
	hrp.CFrame = CFrame.new(sharkCenter(shark))
	remote:FireServer(shark, true)
end

local winConn
local winModel
local winParts = {}

local function ownShark()
	for _, model in sharks:GetChildren() do
		local owner = model:FindFirstChild("PlayerOwner")
		if owner and owner.Value == player then
			return model
		end
	end
end

local function frontPart(model)
	local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	local look = root and root.CFrame.LookVector
	local best, bestDot = nil, -math.huge
	for part in winParts do
		if part.Parent then
			local dot = look and look:Dot((part.Position - root.Position).Unit) or 0
			if not best or dot > bestDot then
				best, bestDot = part, dot
			end
		else
			winParts[part] = nil
		end
	end
	return best
end

local function livePart(model)
	if model ~= winModel then
		winModel = model
		table.clear(winParts)
	end

	local front = frontPart(model)
	if front then
		return front
	end
	for _, desc in model:GetDescendants() do
		if desc.Name == "DestructionPart" then
			winParts[desc] = true
		end
	end
	return frontPart(model)
end

local function nearestRoot(part)
	local nearest, nearestDist = nil, math.huge
	for _, plr in players:GetPlayers() do
		if plr ~= player and tostring(plr.Team) == "Survivor" then
			local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
			local root = hum and hum.RootPart
			if root and not root:FindFirstChild("Attachment") then
				local dist = (root.Position - part.Position).Magnitude
				if dist < nearestDist then
					nearest, nearestDist = root, dist
				end
			end
		end
	end
	return nearest
end

local function win()
	if tostring(player.Team) ~= "Shark" then
		return
	end

	local model = ownShark()
	local front = model and livePart(model)
	local root = front and nearestRoot(front)
	if root then
		front.CFrame = CFrame.new(root.Position)
	end
end

local espConns = {}

local function highlight(h)
	h.Enabled = true
	h.OutlineTransparency = 0
	table.insert(espConns, h:GetPropertyChangedSignal("Enabled"):Connect(function()
		h.Enabled = true
	end))
	table.insert(espConns, h:GetPropertyChangedSignal("OutlineTransparency"):Connect(function()
		h.OutlineTransparency = 0
	end))
end

local function setESP(on)
	disconnect(espConns)
	for _, h in sharks:GetDescendants() do
		if h:IsA("Highlight") then
			if on then
				highlight(h)
			else
				h.Enabled = false
				h.OutlineTransparency = 1
			end
		end
	end
	if on then
		table.insert(espConns, sharks.DescendantAdded:Connect(function(desc)
			if desc:IsA("Highlight") then
				highlight(desc)
			end
		end))
	end
end

local vaseParts = {}
local vaseConns = {}

local function addVase(desc)
	if desc:IsA("TouchTransmitter") then
		vaseParts[desc.Parent] = true
	end
end

local function touch()
	if not hrp or (killConn and sharks:FindFirstChildOfClass("Model")) then
		return
	end

	humanoid.Sit = false
	for part in vaseParts do
		if part.Parent then
			hrp.CFrame = part.CFrame
			firetouchinterest(hrp, part, 0)
			firetouchinterest(hrp, part, 1)
		else
			vaseParts[part] = nil
		end
	end
end

local window = loadstring(game:HttpGet("https://sirius.menu/gen2"))():CreateWindow({
	name = "Sharkbite 2 by mafuyu",
	configuration = {
		autoSave = true,
		autoLoad = true,
		fileName = "SharkConfig",
	},
})

local function unsupported(flag, missing)
	task.delay(0.2, function()
		window:Set(flag, false)
	end)
	window:Notify({
		title = "Executor too weak",
		content = "Your executor does not support " .. missing .. ".",
		duration = 3,
	})
end

local tab = window:CreateTab({ name = "Main", icon = 4483362458 })

tab:CreateSection({ name = "Autofarm" })

tab:CreateToggle({
	name = "Auto kill shark",
	flag = "AutoKillShark",
	callback = function(on)
		if killConn then
			killConn:Disconnect()
			killConn = nil
		end
		if not on then
			return
		end
		if not remote then
			unsupported("AutoKillShark", "debug.getupvalue or require")
			return
		end
		killConn = run.Heartbeat:Connect(farm)
	end,
})

tab:CreateToggle({
	name = "Auto win as shark",
	flag = "AutoWinShark",
	callback = function(on)
		if winConn then
			winConn:Disconnect()
			winConn = nil
		end
		if on then
			winConn = run.Heartbeat:Connect(win)
		end
	end,
})

tab:CreateSection({ name = "Shark ESP" })

tab:CreateToggle({
	name = "Highlight sharks [ESP]",
	flag = "SharkESP",
	callback = setESP,
})

tab:CreateSection({ name = "Auto Vase" })

tab:CreateToggle({
	name = "Auto touch vases",
	flag = "AutoTouchVases",
	callback = function(on)
		disconnect(vaseConns)
		table.clear(vaseParts)
		if not on then
			return
		end
		if not firetouchinterest then
			unsupported("AutoTouchVases", "firetouchinterest")
			return
		end

		local vases = workspace:FindFirstChild("Vases")
		if vases then
			for _, desc in vases:GetDescendants() do
				addVase(desc)
			end
			table.insert(vaseConns, vases.DescendantAdded:Connect(addVase))
		end
		table.insert(vaseConns, run.Heartbeat:Connect(touch))
	end,
})
