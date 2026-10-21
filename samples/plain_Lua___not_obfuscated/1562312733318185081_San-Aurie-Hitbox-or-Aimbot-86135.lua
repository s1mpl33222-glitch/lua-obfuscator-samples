-- =========================================
-- BIG HEAD HITBOX TOGGLE (DEATH + HEAL AWARE)
-- =========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.BIG_HEAD_STATE = _G.BIG_HEAD_STATE or {
	enabled = false,
	data = {},         -- original head data
	paused = {},       -- paused while dead
	connections = {},
	enforceConn = nil,
}

local state = _G.BIG_HEAD_STATE

-- CONFIG
local HEAD_SCALE = Vector3.new(12, 12, 12)
local HEAD_TRANSPARENCY = 0.9

-- =========================================
-- UTIL
-- =========================================

local function getHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getHead(character)
	return character and character:FindFirstChild("Head")
end

local function getAllHeadDecals(head)
	local decals = {}
	for _, obj in ipairs(head:GetChildren()) do
		if obj:IsA("Decal") then
			table.insert(decals, obj)
		end
	end
	return decals
end

-- =========================================
-- APPLY BIG HEAD
-- =========================================

local function applyBigHead(player)
	if player == LocalPlayer then return end
	if not player.Character then return end

	local humanoid = getHumanoid(player.Character)
	if not humanoid or humanoid.Health <= 0 then
		state.paused[player] = true
		return
	end

	local head = getHead(player.Character)
	if not head then return end

	-- Save original state once
	if not state.data[player] then
		state.data[player] = {
			size = head.Size,
			transparency = head.Transparency,
			decals = getAllHeadDecals(head),
		}
	end

	-- Apply enforced state
	head.Size = HEAD_SCALE
	head.Transparency = HEAD_TRANSPARENCY
	head.CanCollide = false
	head.Massless = true

	-- Remove all decals every time (faces, etc.)
	for _, decal in ipairs(getAllHeadDecals(head)) do
		decal.Parent = nil
	end
end

-- =========================================
-- REVERT BIG HEAD
-- =========================================

local function revertBigHead(player)
	local saved = state.data[player]
	if not saved then return end
	if not player.Character then
		state.data[player] = nil
		return
	end

	local head = getHead(player.Character)
	if not head then
		state.data[player] = nil
		return
	end

	head.Size = saved.size
	head.Transparency = saved.transparency
	head.CanCollide = true
	head.Massless = false

	for _, decal in ipairs(saved.decals) do
		if decal then decal.Parent = head end
	end

	state.data[player] = nil
end

-- =========================================
-- HEALTH WATCHER (DEATH + HEAL)
-- =========================================

local function attachHealthWatcher(player, humanoid)
	humanoid.HealthChanged:Connect(function(health)
		if not state.enabled then return end

		if health <= 0 then
			-- Player died / downed
			if state.data[player] then
				revertBigHead(player)
			end
			state.paused[player] = true
		else
			-- Player healed / revived
			if state.paused[player] then
				state.paused[player] = nil
				applyBigHead(player)
			end
		end
	end)
end

-- =========================================
-- APPLY / REVERT ALL
-- =========================================

local function applyToAll()
	for _, player in ipairs(Players:GetPlayers()) do
		applyBigHead(player)
	end
end

local function revertAll()
	for player in pairs(state.data) do
		revertBigHead(player)
	end
	state.paused = {}
end

-- =========================================
-- CLEANUP
-- =========================================

local function clearConnections()
	for _, c in ipairs(state.connections) do
		c:Disconnect()
	end
	state.connections = {}

	if state.enforceConn then
		state.enforceConn:Disconnect()
		state.enforceConn = nil
	end
end

-- =========================================
-- TOGGLE
-- =========================================

if state.enabled then
	-- TURN OFF
	revertAll()
	clearConnections()
	state.enabled = false
	return
end

-- TURN ON
state.enabled = true
applyToAll()

-- =========================================
-- ENFORCEMENT LOOP
-- =========================================

state.enforceConn = RunService.Heartbeat:Connect(function()
	if not state.enabled then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local humanoid = getHumanoid(player.Character)
			local head = getHead(player.Character)

			if humanoid and humanoid.Health <= 0 then
				if state.data[player] then
					revertBigHead(player)
				end
				state.paused[player] = true
			elseif humanoid and humanoid.Health > 0 then
				if state.paused[player] then
					state.paused[player] = nil
					applyBigHead(player)
				elseif state.data[player] and head then
					if head.Size ~= HEAD_SCALE or head.Transparency ~= HEAD_TRANSPARENCY then
						applyBigHead(player)
					end
				elseif not state.data[player] then
					applyBigHead(player)
				end
			end
		end
	end
end)

-- =========================================
-- PLAYER JOIN / RESPAWN
-- =========================================

local function setupPlayer(player)
	table.insert(state.connections,
		player.CharacterAdded:Connect(function(character)
			task.wait(0.3)

			local humanoid = getHumanoid(character)
			if humanoid then
				attachHealthWatcher(player, humanoid)
				state.paused[player] = nil
				if state.enabled and humanoid.Health > 0 then
					applyBigHead(player)
				end
			end
		end)
	)
end

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

table.insert(state.connections,
	Players.PlayerAdded:Connect(setupPlayer)
)

table.insert(state.connections,
	Players.PlayerRemoving:Connect(function(player)
		state.data[player] = nil
		state.paused[player] = nil
	end)
)
