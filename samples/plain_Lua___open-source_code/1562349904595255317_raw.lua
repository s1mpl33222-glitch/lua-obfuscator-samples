local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser
pcall(function()
	VirtualUser = game:GetService("VirtualUser")
end)

local LP = Players.LocalPlayer
if not LP then
	return
end


local function norm(value)
	return string.lower(tostring(value))
end

if #CONFIG.Whitelist ~= 2 then
	warn("[AUTO1V1] Whitelist must contain exactly two names")
	return
end

local function configHasName(name)
	for _, item in ipairs(CONFIG.Whitelist) do
		if norm(item) == norm(name) then
			return true
		end
	end
	return false
end

if not configHasName(LP.Name) then
	warn("[AUTO1V1] This account is not in the whitelist")
	return
end

if not configHasName(CONFIG.Winner) then
	warn("[AUTO1V1] Winner must be one of the two whitelisted names")
	return
end

local PartnerName
for _, item in ipairs(CONFIG.Whitelist) do
	if norm(item) ~= norm(LP.Name) then
		PartnerName = item
	end
end

if not PartnerName then
	warn("[AUTO1V1] Partner name could not be resolved")
	return
end

local IsWinner = norm(LP.Name) == norm(CONFIG.Winner)

local function log(...)
	if CONFIG.Debug then
		print("[AUTO1V1]", ...)
	end
end

local RUN = {
	stopped = false,
	connections = {},
	mouse = {},
	lastQueue = 0,
	lastAttack = 0,
	lastRejoin = 0,
	lastStatus = nil,
	searching = false,
	searchingSince = 0,
	pendingMatch = false,
	pendingSince = 0,
	matchOpponent = nil,
	inMatchSince = 0,
	randomSince = 0,
	matchOverAt = 0,
	rejoining = false,
	attacks = 0,
	selfKillSince = 0,
	warnedQueue = false,
	waitingClean = false,
	lastHeartbeat = 0,
	warnedPartnerDead = false,
}

local function heartbeatPath(name)
	return "auto1v1_hb_" .. name .. ".txt"
end

local function partnerScriptLive()
	if not CONFIG.RequirePartnerLive then
		return true
	end
	local ok, content = pcall(readfile, heartbeatPath(PartnerName))
	if not ok or type(content) ~= "string" then
		return false
	end
	local stamp = tonumber(content)
	if not stamp then
		return false
	end
	return os.time() - stamp <= CONFIG.HeartbeatMaxAge
end

local function heartbeatStep()
	local now = os.clock()
	if now - RUN.lastHeartbeat < 1 then
		return
	end
	RUN.lastHeartbeat = now
	pcall(writefile, heartbeatPath(LP.Name), tostring(os.time()))
end

local function cleanup()
	if RUN.stopped then
		return
	end
	RUN.stopped = true
	for _, connection in ipairs(RUN.connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	for tool in pairs(RUN.mouse) do
		pcall(function()
			local mouseInput = tool and tool:FindFirstChild("MouseInput")
			if mouseInput and mouseInput:IsA("RemoteFunction") then
				mouseInput.OnClientInvoke = nil
			end
		end)
	end
	RUN.connections = {}
	RUN.mouse = {}
	pcall(delfile, heartbeatPath(LP.Name))
end

RUN.stop = cleanup

local previous = getgenv().Auto1V1State
if type(previous) == "table" and type(previous.stop) == "function" then
	pcall(previous.stop)
end
getgenv().Auto1V1State = RUN

local function bind(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(RUN.connections, connection)
	return connection
end

local function antiAfk()
	if not CONFIG.AntiAFK or not VirtualUser then
		return
	end
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new(0, 0))
	end)
	log("anti afk")
end

bind(LP.Idled, antiAfk)

local function findPlayer(name)
	for _, player in ipairs(Players:GetPlayers()) do
		if norm(player.Name) == norm(name) or norm(player.DisplayName or "") == norm(name) then
			return player
		end
	end
	return nil
end

local function nameIsPartner(name)
	local player = findPlayer(name)
	if player then
		return norm(player.Name) == norm(PartnerName)
	end
	return norm(name) == norm(PartnerName)
end

local function partner()
	return findPlayer(PartnerName)
end

local function inMatch(player)
	return player ~= nil and player:GetAttribute("InMatch") == true
end

local function alive(player)
	local character = player and player.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	return humanoid ~= nil and humanoid.Health > 0 and root ~= nil
end

local function getBar()
	local gui = LP:FindFirstChild("PlayerGui")
	local hud = gui and gui:FindFirstChild("MatchHUD")
	return hud and hud:FindFirstChild("Bar")
end

local function getHudOpponentName()
	local bar = getBar()
	if not bar or not bar.Visible then
		return nil
	end
	for _, side in ipairs({ "LeftPlayer", "RightPlayer" }) do
		local frame = bar:FindFirstChild(side)
		local label = frame and frame:FindFirstChild("NameLabel")
		local text = label and label.Text
		if type(text) == "string" and text ~= "" and norm(text) ~= norm(LP.Name) and norm(text) ~= norm(LP.DisplayName or "") then
			return text
		end
	end
	return nil
end

local function getTargetRoot()
	local opponentName = getHudOpponentName()
	if not opponentName or not nameIsPartner(opponentName) then
		return nil
	end
	local player = findPlayer(opponentName)
	if not alive(player) then
		return nil
	end
	return player.Character.HumanoidRootPart
end

local function requestRejoin(reason)
	if not CONFIG.AutoRejoin or RUN.rejoining then
		return
	end
	local now = os.clock()
	if now - RUN.lastRejoin < CONFIG.RejoinCooldown then
		return
	end
	local wall = os.time()
	local lastWall = getgenv().Auto1V1LastRejoin
	if type(lastWall) == "number" and wall - lastWall < CONFIG.RejoinCooldown then
		return
	end
	RUN.lastRejoin = now
	RUN.rejoining = true
	getgenv().Auto1V1LastRejoin = wall
	log("rejoin", reason)
	local queued, queueError = pcall(function()
		local source = readfile(CONFIG.ScriptFile)
		if type(source) ~= "string" or #source < 100 then
			error("missing workspace file " .. CONFIG.ScriptFile)
		end
		queue_on_teleport(source)
	end)
	if not queued then
		warn("[AUTO1V1] Could not queue restart:", queueError)
		RUN.rejoining = false
		RUN.lastRejoin = 0
		return
	end
	task.delay(CONFIG.TeleportDelay, function()
		local teleported = false
		if CONFIG.SameServer and game.JobId ~= "" then
			teleported = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
			end)
		end
		if not teleported then
			pcall(function()
				TeleportService:Teleport(game.PlaceId, LP)
			end)
		end
		task.delay(10, function()
			RUN.rejoining = false
		end)
	end)
end

local function serverIsCleanForQueue()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP and norm(player.Name) ~= norm(PartnerName) then
			if not inMatch(player) then
				return false
			end
		end
	end
	return true
end

local function tryQueue()
	if not CONFIG.AutoQueue or RUN.rejoining or inMatch(LP) then
		return
	end
	local now = os.clock()
	if RUN.pendingMatch then
		if now - RUN.pendingSince <= 15 then
			return
		end
		RUN.pendingMatch = false
		RUN.pendingSince = 0
	end
	local partnerPlayer = partner()
	if not partnerPlayer or inMatch(partnerPlayer) then
		return
	end
	if not partnerScriptLive() then
		if not RUN.warnedPartnerDead then
			RUN.warnedPartnerDead = true
			log("partner script not running; waiting")
		end
		return
	end
	if RUN.warnedPartnerDead then
		RUN.warnedPartnerDead = false
		log("partner script is running")
	end
	if CONFIG.CleanServerQueue and not serverIsCleanForQueue() then
		if not RUN.waitingClean then
			RUN.waitingClean = true
			log("waiting for other lobby players to leave")
		end
		return
	end
	if RUN.waitingClean then
		RUN.waitingClean = false
		log("server clean")
	end
	if RUN.searching then
		if now - RUN.searchingSince > 30 then
			RUN.searching = false
		else
			return
		end
	end
	if now - RUN.lastQueue < CONFIG.QueueInterval then
		return
	end
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local request = remotes and remotes:FindFirstChild("MatchmakingRequest")
	if not request or not request:IsA("RemoteEvent") then
		if not RUN.warnedQueue then
			RUN.warnedQueue = true
			warn("[AUTO1V1] MatchmakingRequest was not found")
		end
		return
	end
	RUN.lastQueue = now
	RUN.searching = true
	RUN.searchingSince = now
	local ok, err = pcall(function()
		request:FireServer()
	end)
	if not ok then
		RUN.searching = false
		warn("[AUTO1V1] Queue request failed:", err)
		return
	end
	log("queue request")
end

local function checkArena()
	if not CONFIG.ArenaCheck or RUN.rejoining then
		return
	end
	local now = os.clock()
	local selfIn = inMatch(LP)
	local opponentName = getHudOpponentName()

	if selfIn then
		RUN.pendingMatch = false
		RUN.pendingSince = 0
		if RUN.inMatchSince == 0 then
			RUN.inMatchSince = now
		end
	else
		RUN.inMatchSince = 0
		if RUN.pendingMatch and now - RUN.pendingSince > 15 then
			RUN.pendingMatch = false
			RUN.pendingSince = 0
			RUN.randomSince = 0
			RUN.matchOpponent = nil
		end
		if not RUN.pendingMatch then
			RUN.randomSince = 0
			RUN.matchOpponent = nil
		end
		if RUN.matchOverAt > 0 then
			RUN.matchOverAt = 0
		end
	end

	if RUN.matchOverAt > 0 and selfIn and now - RUN.matchOverAt > CONFIG.MatchOverGrace then
		requestRejoin("still in match after match over")
		return
	end

	if selfIn and opponentName then
		RUN.matchOpponent = opponentName
		if nameIsPartner(opponentName) then
			RUN.randomSince = 0
			if RUN.lastStatus ~= "arena" then
				RUN.lastStatus = "arena"
				log("arena", opponentName)
			end
		else
			if RUN.randomSince == 0 then
				RUN.randomSince = now
			end
			if now - RUN.randomSince > CONFIG.RandomGrace then
				requestRejoin("opponent is not " .. PartnerName .. ": " .. opponentName)
				return
			end
		end
	elseif selfIn and not opponentName then
		if RUN.matchOverAt == 0 and now - RUN.inMatchSince > CONFIG.ArenaGrace then
			requestRejoin("no opponent appeared in the match HUD")
			return
		end
	end

	if selfIn and RUN.matchOpponent and not nameIsPartner(RUN.matchOpponent) then
		if RUN.randomSince > 0 and now - RUN.randomSince > CONFIG.RandomGrace then
			requestRejoin("random matchmaking result: " .. RUN.matchOpponent)
			return
		end
	end

	if not selfIn and RUN.lastStatus ~= "lobby" then
		RUN.lastStatus = "lobby"
		log("lobby")
	end
end

local function allTools()
	local tools = {}
	local character = LP.Character
	if character then
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") then
				table.insert(tools, child)
			end
		end
	end
	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		for _, child in ipairs(backpack:GetChildren()) do
			if child:IsA("Tool") then
				table.insert(tools, child)
			end
		end
	end
	return tools
end

local function toolScore(tool)
	local name = norm(tool.Name)
	if string.find(name, "bubbleperiastron", 1, true) then
		return 100
	end
	if string.find(name, "noirperiastron", 1, true) then
		return 90
	end
	if string.find(name, "periastron", 1, true) then
		return 80
	end
	if tool:FindFirstChild("Remote") then
		return 60
	end
	return 10
end

local function equipBest()
	if RUN.rejoining or RUN.stopped then
		return
	end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	local current = character:FindFirstChildOfClass("Tool")
	if not IsWinner then
		if CONFIG.BotUnequip and current then
			pcall(function()
				humanoid:UnequipTools()
			end)
		end
		return
	end
	if not CONFIG.AutoEquip then
		return
	end
	local best = nil
	local bestScore = -1
	for _, tool in ipairs(allTools()) do
		local score = toolScore(tool)
		if score > bestScore then
			best = tool
			bestScore = score
		end
	end
	if not best or current == best then
		return
	end
	if current and toolScore(current) >= bestScore then
		return
	end
	local ok = pcall(function()
		humanoid:EquipTool(best)
	end)
	if ok then
		log("equip", best.Name)
	end
end

local function installMouseInput(tool)
	local mouseInput = tool:FindFirstChild("MouseInput")
	if not mouseInput or not mouseInput:IsA("RemoteFunction") then
		return
	end
	RUN.mouse[tool] = true
	mouseInput.OnClientInvoke = function()
		local root = getTargetRoot()
		if root then
			return root.Position
		end
		return Vector3.zero
	end
end

local function fireTool(tool)
	local remote = tool:FindFirstChild("Remote")
	if remote and remote:IsA("RemoteEvent") then
		local name = norm(tool.Name)
		local first = Enum.KeyCode.E
		local second = Enum.KeyCode.Q
		if string.find(name, "bubbleperiastron", 1, true) then
			first = Enum.KeyCode.Q
			second = Enum.KeyCode.E
		end
		local ok = pcall(function()
			remote:FireServer(first)
			task.wait(0.04)
			remote:FireServer(second)
		end)
		return ok
	end
	local ok = pcall(function()
		tool:Activate()
	end)
	return ok
end

local function moveToTarget(myRoot, targetRoot)
	local delta = targetRoot.Position - myRoot.Position
	local distance = delta.Magnitude
	if distance < 0.05 then
		return false
	end
	if distance > CONFIG.AttackRange then
		local direction = delta.Unit
		myRoot.CFrame = CFrame.lookAt(targetRoot.Position - direction * CONFIG.TeleportDistance, targetRoot.Position)
		myRoot.AssemblyLinearVelocity = Vector3.zero
		return true
	end
	return false
end

local function attackStep()
	if not CONFIG.AutoAttack or RUN.rejoining or RUN.stopped then
		return
	end
	if IsWinner and not CONFIG.WinnerAutoSwings then
		return
	end
	if not IsWinner and not CONFIG.BotAttacks then
		return
	end
	if not inMatch(LP) then
		return
	end
	local now = os.clock()
	if now - RUN.lastAttack < CONFIG.AttackInterval then
		return
	end
	local targetRoot = getTargetRoot()
	if not targetRoot then
		return
	end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local myRoot = character and character:FindFirstChild("HumanoidRootPart")
	local tool = character and character:FindFirstChildOfClass("Tool")
	if not humanoid or humanoid.Health <= 0 or not myRoot or not tool then
		return
	end
	RUN.lastAttack = now
	installMouseInput(tool)
	local moved = moveToTarget(myRoot, targetRoot)
	if moved then
		task.wait(0.06)
	end
	if fireTool(tool) then
		RUN.attacks = RUN.attacks + 1
		if RUN.attacks == 1 or RUN.attacks % 20 == 0 then
			log("attack", tool.Name, RUN.attacks)
		end
	end
end

local function botStep()
	if IsWinner or not CONFIG.BotSelfKill or RUN.rejoining or RUN.stopped then
		return
	end
	if not inMatch(LP) then
		RUN.selfKillSince = 0
		return
	end
	local opponentName = getHudOpponentName()
	if not opponentName or not nameIsPartner(opponentName) then
		RUN.selfKillSince = 0
		return
	end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if humanoid.Health <= 0 then
		RUN.selfKillSince = 0
		return
	end
	local now = os.clock()
	if RUN.selfKillSince == 0 then
		RUN.selfKillSince = now
	end
	if now - RUN.selfKillSince < CONFIG.BotSelfKillDelay then
		return
	end
	RUN.selfKillSince = now
	local ok = pcall(function()
		humanoid.Health = 0
	end)
	if ok then
		log("self kill")
	end
end

local function handleStatus(eventName, data, extra)
	if RUN.stopped then
		return
	end
	local payload = type(eventName) == "table" and eventName or nil
	local status = payload and payload.status or eventName
	local info = payload or (type(data) == "table" and data or nil)
	if status == "Searching" then
		RUN.searching = true
		RUN.searchingSince = os.clock()
		log("status searching")
	elseif status == "Cancelled" then
		RUN.searching = false
		RUN.searchingSince = 0
		RUN.pendingMatch = false
		RUN.pendingSince = 0
		RUN.lastQueue = 0
		log("status cancelled")
	elseif status == "MatchFound" then
		RUN.searching = false
		RUN.searchingSince = 0
		RUN.pendingMatch = true
		RUN.pendingSince = os.clock()
		local opponentName = info and (info.opponentName or info.OpponentName or info.name) or nil
		local weapon = info and (info.weapon or info.Weapon) or nil
		if not opponentName and type(data) == "string" then
			opponentName = data
			weapon = type(extra) == "string" and extra or nil
		end
		RUN.matchOpponent = opponentName
		if opponentName and not nameIsPartner(opponentName) then
			RUN.randomSince = os.clock()
			log("match found random", opponentName, weapon or "")
		else
			RUN.randomSince = 0
			log("match found", opponentName or "?", weapon or "")
		end
	elseif status == "RoundResult" then
		if info then
			log("round", tostring(info.myWins or info.playerWins or "?"), tostring(info.opponentWins or info.enemyWins or "?"))
		else
			log("round", tostring(data), tostring(extra))
		end
	elseif status == "MatchOver" then
		RUN.searching = false
		RUN.searchingSince = 0
		RUN.pendingMatch = false
		RUN.pendingSince = 0
		RUN.matchOpponent = nil
		RUN.matchOverAt = os.clock()
		RUN.lastQueue = os.clock()
		if info then
			log("match over", tostring(info.youWon), tostring(info.myWins or "?"), tostring(info.opponentWins or "?"))
		else
			log("match over", tostring(data))
		end
	elseif status == "KillConfirmed" then
		return
	elseif status == "WinsLoaded" then
		log("wins loaded", tostring(data))
	else
		log("status", tostring(status))
	end
end

local statusConnected, statusError = pcall(function()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local status = remotes and remotes:FindFirstChild("MatchmakingStatus")
	if status and status:IsA("RemoteEvent") then
		bind(status.OnClientEvent, function(eventName, data, extra)
			pcall(handleStatus, eventName, data, extra)
		end)
	end
end)

if not statusConnected then
	warn("[AUTO1V1] Could not connect MatchmakingStatus:", statusError)
end

bind(LP.CharacterAdded, function()
	RUN.lastAttack = 0
	RUN.selfKillSince = 0
	log("character spawned")
end)

bind(TeleportService.TeleportInitFailed, function(_, result, message)
	warn("[AUTO1V1] Teleport failed:", tostring(result), tostring(message))
	RUN.rejoining = false
end)

log("start", LP.Name, IsWinner and "winner" or "bot", "partner=" .. PartnerName)
pcall(heartbeatStep)

task.spawn(function()
	while not RUN.stopped do
		pcall(heartbeatStep)
		pcall(checkArena)
		pcall(botStep)
		pcall(tryQueue)
		pcall(equipBest)
		task.wait(0.25)
	end
end)

task.spawn(function()
	while not RUN.stopped do
		pcall(attackStep)
		task.wait(0.1)
	end
end)
