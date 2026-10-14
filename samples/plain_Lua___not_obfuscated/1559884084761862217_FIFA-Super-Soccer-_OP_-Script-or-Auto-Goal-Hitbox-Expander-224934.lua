local env = getgenv()

env.FSSAutoToken = (env.FSSAutoToken or 0) + 1
env.FSSAutoEnabled = false

if env.FSSRayfield then
	pcall(function()
		env.FSSRayfield:Destroy()
	end)
end

if env.FSSGKConnection then
	pcall(function()
		env.FSSGKConnection:Disconnect()
	end)
end

local token = env.FSSAutoToken
local config = {
	enabled = true,
	autoGoal = true,
	looseBalls = false,
	requireGoalkeeper = true,
	alternateCentered = true,
	shotSpeed = 205,
	directShotSpeed = 160,
	directGoalDistance = 11,
	teleportSettle = 0.1,
	cornerOffset = 12,
	targetHeight = 2.7,
	gravityCompensation = 55,
	goalkeeperPrediction = 0.45,
	goalkeeperSaveDistance = 80,
	centerThreshold = 2.5,
	maxStealDistance = 400,
	tackleRetry = 0.3,
	tackleCooldown = 3.05,
	ownershipWait = 0.9,
	scoreWait = 1.8,
}

assert(config.shotSpeed <= 240 and config.directShotSpeed <= 205 and config.cornerOffset < 14, "unsafe default shot settings")

local stats
local function resetStats()
	stats = {
		started = os.time(),
		tackleRequests = 0,
		tackleAccepted = 0,
		tackleRejected = 0,
		steals = 0,
		loosePickups = 0,
		acquireFailures = 0,
		shots = 0,
		goals = 0,
		saves = 0,
		saveReplies = 0,
		originRejections = 0,
		errors = 0,
		last = "Idle",
	}
	env.FSSAutoStats = stats
end

resetStats()
env.FSSConfig = config
env.FSSAutoEnabled = true

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
env.FSSRayfield = Rayfield

local Window = Rayfield:CreateWindow({
	Name = "FIFA Super Soccer",
	Icon = "shield-check",
	LoadingTitle = "FIFA Super Soccer",
	LoadingSubtitle = "discord.gg/ArtemisClient",
	ShowText = "FIFA Super Soccer",
	Theme = "Default",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = false,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "FIFASuperSoccer",
		FileName = "Settings",
	},
	KeySystem = false,
})

local Automation = Window:CreateTab("Automation", "zap")
local Shooting = Window:CreateTab("Shooting", "crosshair")
local Goalkeeper = Window:CreateTab("Goalkeeper", "shield")
local Timing = Window:CreateTab("Timing", "timer")
local Status = Window:CreateTab("Status", "activity")

Automation:CreateSection("Main")

local MasterToggle = Automation:CreateToggle({
	Name = "Enabled",
	CurrentValue = config.enabled,
	Flag = "Enabled",
	Callback = function(value)
		config.enabled = value
		env.FSSAutoEnabled = value
	end,
})

Automation:CreateToggle({
	Name = "Auto Goal",
	CurrentValue = config.autoGoal,
	Flag = "AutoGoal",
	Callback = function(value)
		config.autoGoal = value
	end,
})

Automation:CreateToggle({
	Name = "Acquire loose balls",
	CurrentValue = config.looseBalls,
	Flag = "LooseBalls",
	Callback = function(value)
		config.looseBalls = value
	end,
})

Automation:CreateSlider({
	Name = "Maximum steal distance",
	Range = { 10, 500 },
	Increment = 5,
	Suffix = " studs",
	CurrentValue = config.maxStealDistance,
	Flag = "MaxStealDistance",
	Callback = function(value)
		config.maxStealDistance = value
	end,
})

Automation:CreateKeybind({
	Name = "Toggle automation",
	CurrentKeybind = "L",
	HoldToInteract = false,
	Flag = "AutomationKey",
	Callback = function()
		config.enabled = not config.enabled
		env.FSSAutoEnabled = config.enabled
		MasterToggle:Set(config.enabled)
	end,
})

Shooting:CreateSection("Direct goal")

Shooting:CreateToggle({
	Name = "Require opposing goalkeeper",
	CurrentValue = config.requireGoalkeeper,
	Flag = "RequireGoalkeeper",
	Callback = function(value)
		config.requireGoalkeeper = value
	end,
})

Shooting:CreateToggle({
	Name = "Alternate when GK is centered",
	CurrentValue = config.alternateCentered,
	Flag = "AlternateCentered",
	Callback = function(value)
		config.alternateCentered = value
	end,
})

Shooting:CreateSlider({
	Name = "Shot speed",
	Range = { 120, 240 },
	Increment = 1,
	Suffix = " studs/s",
	CurrentValue = config.shotSpeed,
	Flag = "ShotSpeed",
	Callback = function(value)
		config.shotSpeed = value
	end,
})

Shooting:CreateSlider({
	Name = "Direct shot speed",
	Range = { 100, 205 },
	Increment = 1,
	Suffix = " studs/s",
	CurrentValue = config.directShotSpeed,
	Flag = "DirectShotSpeed",
	Callback = function(value)
		config.directShotSpeed = value
	end,
})

Shooting:CreateSlider({
	Name = "Direct goal distance",
	Range = { 8, 25 },
	Increment = 0.5,
	Suffix = " studs",
	CurrentValue = config.directGoalDistance,
	Flag = "DirectGoalDistance",
	Callback = function(value)
		config.directGoalDistance = value
	end,
})

Shooting:CreateSlider({
	Name = "Corner offset",
	Range = { 5, 13 },
	Increment = 0.1,
	Suffix = " studs",
	CurrentValue = config.cornerOffset,
	Flag = "CornerOffset",
	Callback = function(value)
		config.cornerOffset = value
	end,
})

Shooting:CreateSlider({
	Name = "Target height",
	Range = { 0, 3.2 },
	Increment = 0.05,
	Suffix = " Y",
	CurrentValue = config.targetHeight,
	Flag = "TargetHeight",
	Callback = function(value)
		config.targetHeight = value
	end,
})

Shooting:CreateSlider({
	Name = "GK prediction",
	Range = { 0, 0.8 },
	Increment = 0.05,
	Suffix = " s",
	CurrentValue = config.goalkeeperPrediction,
	Flag = "GoalkeeperPrediction",
	Callback = function(value)
		config.goalkeeperPrediction = value
	end,
})

Shooting:CreateSlider({
	Name = "Centered threshold",
	Range = { 0.5, 6 },
	Increment = 0.1,
	Suffix = " studs",
	CurrentValue = config.centerThreshold,
	Flag = "CenterThreshold",
	Callback = function(value)
		config.centerThreshold = value
	end,
})

Shooting:CreateSlider({
	Name = "Gravity compensation",
	Range = { 0, 90 },
	Increment = 1,
	CurrentValue = config.gravityCompensation,
	Flag = "GravityCompensation",
	Callback = function(value)
		config.gravityCompensation = value
	end,
})

Goalkeeper:CreateSection("Automatic saves")

Goalkeeper:CreateSlider({
	Name = "Save distance",
	Range = { 10, 200 },
	Increment = 5,
	Suffix = " studs",
	CurrentValue = config.goalkeeperSaveDistance,
	Flag = "GoalkeeperSaveDistance",
	Callback = function(value)
		config.goalkeeperSaveDistance = value
	end,
})

Timing:CreateSection("Server acknowledgement")

Timing:CreateSlider({
	Name = "Rejected tackle retry",
	Range = { 0.1, 1 },
	Increment = 0.05,
	Suffix = " s",
	CurrentValue = config.tackleRetry,
	Flag = "TackleRetry",
	Callback = function(value)
		config.tackleRetry = value
	end,
})

Timing:CreateSlider({
	Name = "Accepted tackle cooldown",
	Range = { 2.8, 4 },
	Increment = 0.05,
	Suffix = " s",
	CurrentValue = config.tackleCooldown,
	Flag = "TackleCooldown",
	Callback = function(value)
		config.tackleCooldown = value
	end,
})

Timing:CreateSlider({
	Name = "Ownership confirmation",
	Range = { 0.3, 1.5 },
	Increment = 0.05,
	Suffix = " s",
	CurrentValue = config.ownershipWait,
	Flag = "OwnershipWait",
	Callback = function(value)
		config.ownershipWait = value
	end,
})

Timing:CreateSlider({
	Name = "Score observation",
	Range = { 1, 3 },
	Increment = 0.1,
	Suffix = " s",
	CurrentValue = config.scoreWait,
	Flag = "ScoreWait",
	Callback = function(value)
		config.scoreWait = value
	end,
})

local Counters = Status:CreateLabel("Waiting for the next possession...")
local LastAction = Status:CreateParagraph({
	Title = "Last action",
	Content = stats.last,
})

Status:CreateButton({
	Name = "Reset counters",
	Callback = resetStats,
})

Status:CreateButton({
	Name = "Unload UI and worker",
	Callback = function()
		config.enabled = false
		env.FSSAutoEnabled = false
		env.FSSAutoToken = env.FSSAutoToken + 1
		env.FSSGKConnection:Disconnect()
		Rayfield:Destroy()
	end,
})

Rayfield:LoadConfiguration()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer
local PerformAction = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.ActionService.RE.PerformAction
local cornerFlip = false

env.FSSGKConnection = ReplicatedStorage.__GamemodeComm.RE.GetBallTouchResult.OnClientEvent:Connect(function()
	if config.enabled and LocalPlayer:GetAttribute("TeamRole") == "Goalkeeper" then
		ReplicatedStorage.__GamemodeComm.RE.SetBallTouchResult:FireServer(true)
		stats.saveReplies += 1
	end
end)

local function activeBall()
	for _, ball in CollectionService:GetTagged("Football") do
		if ball:IsA("BasePart") and ball:IsDescendantOf(workspace) and ball:GetAttribute("Enabled") == true then
			return ball
		end
	end
end

local function playerByAgentId(agentId)
	if not agentId then
		return
	end

	for _, player in Players:GetPlayers() do
		if player:GetAttribute("AgentId") == agentId then
			return player
		end
	end
end

local function opposingGoalkeeper(side)
	for _, player in Players:GetPlayers() do
		if player.Team and player.Team.Name == side and (player:GetAttribute("TeamRole") == "Goalkeeper" or player:GetAttribute("TeamPosition") == "GK") then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				return root
			end
		end
	end

	for _, model in workspace:GetDescendants() do
		if model:IsA("Model") and model:GetAttribute("TeamRole") == "Goalkeeper" and model:GetAttribute("IsHomeOrAway") == side then
			local root = model:FindFirstChild("HumanoidRootPart")
			if root then
				return root
			end
		end
	end
end

local function waitForPossession(ball, timeout)
	local deadline = os.clock() + timeout
	repeat
		if LocalPlayer:GetAttribute("HasBall") == true
			and ball:GetAttribute("PossessorId") == LocalPlayer:GetAttribute("AgentId")
			and ball:GetAttribute("NetworkOwner") == LocalPlayer.Name
		then
			return true
		end
		task.wait(0.03)
	until os.clock() >= deadline or env.FSSAutoToken ~= token
	return false
end

local function shoot(ball, root, source, releaseOverride)
	local targetSide = LocalPlayer.Team and LocalPlayer.Team.Name == "Home" and "Away" or "Home"
	local teamFolder = workspace.Stadium.Teams:FindFirstChild(targetSide)
	local goal = teamFolder and teamFolder:FindFirstChild("Goal")
	local goalHitbox = goal and goal:FindFirstChild("Hitbox")
	local goalkeeper = opposingGoalkeeper(targetSide)

	if not goalHitbox or (config.requireGoalkeeper and not goalkeeper) then
		stats.last = "Waiting for opposing goal/GK"
		return
	end

	local center = goalHitbox.Position
	local kick = root:FindFirstChild("KickAttachment")
	local origin = releaseOverride or (kick and kick.WorldPosition) or (root.Position + root.CFrame.LookVector * 3 + Vector3.new(0, -1, 0))
	local flatCenter = Vector3.new(center.X - origin.X, 0, center.Z - origin.Z)
	if flatCenter.Magnitude < 1 then
		return
	end

	local directGoal = not releaseOverride
	local flightTime = flatCenter.Magnitude / config.shotSpeed
	local goalkeeperPosition = goalkeeper
			and goalkeeper.Position + goalkeeper.AssemblyLinearVelocity * (directGoal and 0 or math.min(flightTime, config.goalkeeperPrediction))
		or center
	local chooseLeft

	if config.alternateCentered and math.abs(goalkeeperPosition.X - center.X) < config.centerThreshold then
		cornerFlip = not cornerFlip
		chooseLeft = cornerFlip
	else
		chooseLeft = goalkeeperPosition.X >= center.X
	end

	local aim = Vector3.new(
		center.X + (chooseLeft and -config.cornerOffset or config.cornerOffset),
		config.targetHeight,
		center.Z
	)

	if directGoal then
		local otherSide = targetSide == "Home" and "Away" or "Home"
		local otherGoal = workspace.Stadium.Teams[otherSide].Goal.Hitbox.Position
		local towardField = Vector3.new(otherGoal.X - center.X, 0, otherGoal.Z - center.Z).Unit
		local destination = Vector3.new(aim.X, root.Position.Y, center.Z) + towardField * config.directGoalDistance
		root.CFrame = CFrame.lookAt(destination, Vector3.new(aim.X, destination.Y, center.Z))
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		task.wait(config.teleportSettle)
		kick = root:FindFirstChild("KickAttachment")
		origin = (kick and kick.WorldPosition) or root.Position
	end

	local shotSpeed = directGoal and config.directShotSpeed or config.shotSpeed
	local flat = Vector3.new(aim.X - origin.X, 0, aim.Z - origin.Z)
	flightTime = flat.Magnitude / shotSpeed
	local velocity = flat.Unit * shotSpeed
		+ Vector3.new(0, (aim.Y - origin.Y + 0.5 * config.gravityCompensation * flightTime ^ 2) / flightTime, 0)
	local ownTeam = LocalPlayer.Team
	local oldScore = ownTeam and ownTeam:GetAttribute("Score") or 0

	ball:SetAttribute("State", "Released")
	LocalPlayer:SetAttribute("HasBall", false)
	ball:SetAttribute("PossessorId", nil)
	ball.Velocity = Vector3.zero
	ball:PivotTo(CFrame.new(origin))
	ball.Velocity = velocity
	PerformAction:FireServer("ActionPrimary", origin, velocity)
	stats.shots += 1
	stats.last = string.format("%s %s at %s corner", source, directGoal and "direct shot" or "long shot", chooseLeft and "left" or "right")

	local minimumGoalDistance = math.huge
	local deadline = os.clock() + config.scoreWait
	repeat
		task.wait(0.1)
		if ball.Parent then
			minimumGoalDistance = math.min(minimumGoalDistance, (ball.Position - center).Magnitude)
		end
	until os.clock() >= deadline or env.FSSAutoToken ~= token

	local newScore = ownTeam and ownTeam:GetAttribute("Score") or oldScore
	if newScore > oldScore then
		stats.goals += newScore - oldScore
		stats.last ..= " - GOAL"
	elseif minimumGoalDistance > 100 then
		stats.originRejections += 1
		stats.last ..= " - origin rejected"
	else
		stats.last ..= " - saved/missed"
	end
end

task.spawn(function()
	local nextTackle = 0

	while env.FSSAutoToken == token do
		if not config.enabled then
			task.wait(0.15)
			continue
		end

		local ok, message = pcall(function()
			if LocalPlayer:GetAttribute("DisableControls") == true
				or LocalPlayer:GetAttribute("Freeze") == true
				or LocalPlayer:GetAttribute("IsOnPitch") ~= true
			then
				return
			end

			local character = LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local hitbox = character and character:FindFirstChild("Hitbox")
			local tackleHitbox = character and character:FindFirstChild("TackleHitbox")
			local ball = activeBall()
			if not root or not hitbox or not tackleHitbox or not ball then
				return
			end

			if LocalPlayer:GetAttribute("HasBall") == true
				and ball:GetAttribute("PossessorId") == LocalPlayer:GetAttribute("AgentId")
				and ball:GetAttribute("NetworkOwner") == LocalPlayer.Name
			then
				if config.autoGoal then
					shoot(ball, root, "owned")
				end
				return
			end

			if LocalPlayer:GetAttribute("TeamRole") == "Goalkeeper" and ball:GetAttribute("State") == "Released" and ball.Position.Y > -50 then
				local teamFolder = LocalPlayer.Team and workspace.Stadium.Teams:FindFirstChild(LocalPlayer.Team.Name)
				local goal = teamFolder and teamFolder:FindFirstChild("Goal")
				local goalHitbox = goal and goal:FindFirstChild("Hitbox")
				local toGoal = goalHitbox and goalHitbox.Position - ball.Position

				if toGoal and ball.AssemblyLinearVelocity:Dot(toGoal) > 0 and (ball.Position - root.Position).Magnitude <= config.goalkeeperSaveDistance then
					firetouchinterest(hitbox, ball, 0)
					task.wait(0.03)
					firetouchinterest(hitbox, ball, 1)
					if waitForPossession(ball, config.ownershipWait) then
						stats.saves += 1
						stats.last = "Goalkeeper save"
					end
					return
				end
			end

			if not config.autoGoal then
				return
			end

			local possessor = playerByAgentId(ball:GetAttribute("PossessorId"))
			if not possessor then
				if not config.looseBalls or ball.Position.Y < -50 then
					return
				end

				local releasePosition = ball.Position
				firetouchinterest(hitbox, ball, 0)
				task.wait(0.03)
				firetouchinterest(hitbox, ball, 1)
				if waitForPossession(ball, config.ownershipWait) then
					stats.loosePickups += 1
					shoot(ball, root, "loose-ball", releasePosition)
				end
				return
			end

			if possessor.Team == LocalPlayer.Team or os.clock() < nextTackle then
				return
			end

			local targetCharacter = possessor.Character
			local targetHitbox = targetCharacter and targetCharacter:FindFirstChild("Hitbox")
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
			if not targetHitbox or not targetRoot then
				return
			end

			local distance = (targetRoot.Position - root.Position).Magnitude
			if distance > config.maxStealDistance then
				return
			end

			stats.tackleRequests += 1
			PerformAction:FireServer("Tackle")
			local accepted = false
			for _ = 1, 12 do
				task.wait(0.025)
				if LocalPlayer:GetAttribute("Tackling") == true then
					accepted = true
					break
				end
			end

			if not accepted then
				stats.tackleRejected += 1
				stats.last = "Tackle rejected; retrying"
				nextTackle = os.clock() + config.tackleRetry
				return
			end

			stats.tackleAccepted += 1
			nextTackle = os.clock() + config.tackleCooldown
			firetouchinterest(tackleHitbox, targetHitbox, 0)
			task.wait(0.03)
			firetouchinterest(tackleHitbox, targetHitbox, 1)
			task.wait(0.08)
			firetouchinterest(hitbox, ball, 0)
			task.wait(0.03)
			firetouchinterest(hitbox, ball, 1)

			if not waitForPossession(ball, config.ownershipWait) then
				stats.acquireFailures += 1
				stats.last = string.format("Acquire failed on %s at %.1f studs", possessor.Name, distance)
				return
			end

			stats.steals += 1
			stats.last = string.format("Stole from %s at %.1f studs", possessor.Name, distance)
			task.wait(0.08)
			shoot(ball, root, "steal")
		end)

		if not ok then
			stats.errors += 1
			stats.last = "Error: " .. tostring(message)
		end

		task.wait(0.08)
	end
end)

task.spawn(function()
	while env.FSSAutoToken == token do
		Counters:Set(string.format(
			"Steals %d | Goals %d | Saves %d | Shots %d",
			stats.steals,
			stats.goals,
			stats.saves,
			stats.shots
		))
		LastAction:Set({
			Title = "Last action",
			Content = stats.last,
		})
		task.wait(0.5)
	end
end)

Rayfield:Notify({
	Title = "FIFA Super Soccer",
	Content = "discord.gg/ArtemisClient",
	Duration = 6,
	Image = "shield-check",
})
