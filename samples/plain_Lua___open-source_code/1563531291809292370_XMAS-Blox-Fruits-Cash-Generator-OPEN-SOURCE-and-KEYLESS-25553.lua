-- Scriptblox Analytics
pcall(function() loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))("proj_90a9005b5684", "1.0.0", false) end)
-- Dynamic CanTouch farmer with a discovery pass and persistent streaming memory.
local SPEED = 190 -- Fallback horizontal speed on foot in studs per second.
local SPEED_MIN = 250 -- Minimum sinusoidal speed in studs per second.
local SPEED_MAX = 259.9 -- Maximum sinusoidal speed in studs per second.
local SPEED_PERIOD = 0.2 -- Complete sinusoidal cycle period in seconds (5 Hz).
local EFFECTIVE_AVG_SPEED = (SPEED_MAX + SPEED_MIN) * 0.5 -- 254.95 studs/s nominal average

local BOAT_PURCHASE_RANGE = 450
local BOAT_APPROACH_RANGE = 420 -- Margin for dealer position offsets.
local MIN_ROOT_Y = 2.0 -- Strict altitude floor (keeps boat above waterline at all times).
local MAX_TRAVEL_SECONDS = 180
local LOAD_UI = true
local SHOW_ROUTE_TRACERS = true
local SHOW_HITBOX_VISUALIZER = true -- Gold outlines for chest targets, including the discovery pass.
local REWARD_SEA = 1 -- Set to 1, 2, or 3 for your current Sea.
local ESTIMATED_PICKUP_SECONDS = 0.03
local LOOKAHEAD_STOPS = 4
local MAP_OUTLIER_DISTANCE = 10000 -- Ignore very distant spawns when fitting the chest map.
local DISCOVERY_RUN = true -- Discover through known chest locations once; dealers are only for getting a boat.
local DISCOVERY_RADIUS = 200 -- Nearby discovery seeds share one streaming stop.
local STREAM_TIMEOUT = 2 -- Bound each streaming request; no parallel request flood.

-- Chest trigger geometry
local HITBOX_SIZE = Vector3.new(100, 100, 100)
local HITBOX_HALF_EXTENT = 50 -- Start at the face of the 100x100x100 trigger, with no 5-stud inset.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end
print("[Chest Farmer] Script started")

-- Sinusoidal 3D Speed Generator (250 - 259.9 studs/s) Synchronized with Server Clock
local function getSinusoidalSpeed(serverTime)
    local mid = (SPEED_MAX + SPEED_MIN) * 0.5 -- 254.95
    local amp = (SPEED_MAX - SPEED_MIN) * 0.5 -- 4.95
    local omega = (2 * math.pi) / SPEED_PERIOD
    local serverTimeCycle = serverTime % SPEED_PERIOD
    return mid + amp * math.sin(serverTimeCycle * omega)
end

local C = {
    Speed = SPEED,
    BoatSpeed = EFFECTIVE_AVG_SPEED,
    MinRootY = MIN_ROOT_Y,
    PollSeconds = 0.05,
    SweepMargin = 5, -- Continue a short distance past the hitbox face for touch registration.
    MinimumTouchDepth = 4,
    ArrivalDistance = 4,
    PendingConfirmSeconds = 3,
    CharacterTimeout = 15,
    ChestFailureCooldown = 10,
    MaxChestCooldown = 120,
    MatchRadius = 1,
    ObserveSeconds = 0.5, -- Fallback polling; CanTouch changes also update state immediately.
    ReplanSeconds = 1,
    SwitchGain = 1.25,
    MinimumCommitSeconds = 1.5,
    FinishDistance = 30,
    BeamWidth = 8,
    BranchWidth = 8,
    PlanBudgetSeconds = 0.0015,
    MapRefreshSeconds = 0.5,
    Debug = true,
}

-- Loaded CanTouch is authoritative. Timers predict only known, unloaded chests.
local gradeBySpawnName = {Chest1 = "Silver", Chest2 = "Gold", Chest3 = "Diamond"}
local chestEconomy = {
    Silver = {respawn = 180, rewards = {{250, 420}, {500, 1000}, {1000, 1695}}},
    Gold = {respawn = 360, rewards = {{600, 1100}, {2300, 3120}, {3875, 5200}}},
    Diamond = {respawn = 720, rewards = {{1500, 3000}, {5000, 7250}, {8000, 12250}}},
}
local function gradeOf(record) return gradeBySpawnName[record.name] or "Gold" end
local function economyOf(record) return chestEconomy[gradeOf(record)] end
local function respawnOf(record) return record.respawnEstimate or (gradeBySpawnName[record.name] and economyOf(record).respawn) end
local function enforceAltitudeFloor(position)
    if position.Y >= C.MinRootY then return position end
    return Vector3.new(position.X, C.MinRootY, position.Z)
end

-- CALCULATED LEG SPEED TRACKER
local legHistory = {}
local maxLegHistory = 15
local avgLegSpeed = 0
local legHistoryMode = nil
local measuredMotion = {}

local function recordLegPerformance(distance, timeTaken, mode)
    if timeTaken <= 0.02 or distance <= 4.0 then return end
    if legHistoryMode ~= mode then
        table.clear(legHistory)
        legHistoryMode = mode
    end
    table.insert(legHistory, {distance = distance, time = timeTaken})
    if #legHistory > maxLegHistory then
        table.remove(legHistory, 1)
    end
    local totalDistance, totalTime = 0, 0
    for _, leg in ipairs(legHistory) do
        totalDistance += leg.distance
        totalTime += leg.time
    end
    avgLegSpeed = totalDistance / totalTime
    measuredMotion[mode] = {speed = avgLegSpeed, samples = #legHistory}
end

-- ROUTE PLANNER (Direct 3D Euclidean Distance)
local Planner = {}
function Planner.travelSeconds(a, b, speed3D)
    local dist3D = (b - a).Magnitude
    local mode = speed3D == C.Speed and "foot" or "boat"
    local observed = measuredMotion[mode]
    local calibrated = speed3D
    if observed and observed.samples >= 3 then
        calibrated = math.clamp(observed.speed, speed3D * 0.7, speed3D * 1.1)
    end
    return dist3D / calibrated
end

function Planner.sweepPath(node, fromPosition, margin)
    local center = enforceAltitudeFloor(node.position)
    local half = node.halfSize or Vector3.new(HITBOX_HALF_EXTENT, HITBOX_HALF_EXTENT, HITBOX_HALF_EXTENT)
    -- Coordinate clamping gives the nearest point on the shared trigger box,
    -- rather than intersecting a longer ray aimed at the chest's center.
    local entryPoint = Vector3.new(
        math.clamp(fromPosition.X, center.X - half.X, center.X + half.X),
        math.clamp(fromPosition.Y, center.Y - half.Y, center.Y + half.Y),
        math.clamp(fromPosition.Z, center.Z - half.Z, center.Z + half.Z))
    local inward = center - entryPoint
    local direction = inward.Magnitude > 0.001 and inward.Unit or Vector3.new(0, 0, -1)
    local exitPoint = entryPoint + direction * (margin + 6)
    -- Include the arrival tolerance so stopping short still leaves four studs inside.
    -- Thin shared regions use their center, the deepest point common to all members.
    local depth = C.MinimumTouchDepth + C.ArrivalDistance
    local inset = Vector3.new(math.min(depth, half.X), math.min(depth, half.Y), math.min(depth, half.Z))
    exitPoint = Vector3.new(
        math.clamp(exitPoint.X, center.X - half.X + inset.X, center.X + half.X - inset.X),
        math.clamp(exitPoint.Y, center.Y - half.Y + inset.Y, center.Y + half.Y - inset.Y),
        math.clamp(exitPoint.Z, center.Z - half.Z + inset.Z, center.Z + half.Z - inset.Z))

    return enforceAltitudeFloor(entryPoint), center, enforceAltitudeFloor(exitPoint)
end

function Planner.leg(position, node, startAt, now, options)
    local entry, _, exit = Planner.sweepPath(node, position, options.sweepMargin)
    local travel = options.travelEstimator and options.travelEstimator(position, entry)
        or Planner.travelSeconds(position, entry, options.speed)
    if travel > options.maxTravel then return nil end
    if node.readyAt and node.readyAt > startAt + travel then return nil end
    local sweepSeconds = options.travelEstimator(entry, exit)
    return {seconds = math.max(0.01, travel + sweepSeconds + options.service),
        probability = node.reliability, exitPosition = exit}
end

local function better(a, b)
    if math.abs(a.score - b.score) > 1e-9 then return a.score > b.score end
    if math.abs(a.elapsed - b.elapsed) > 1e-9 then return a.elapsed < b.elapsed end
    return a.first.id < b.first.id
end

local function keepBest(list, entry, limit)
    local index = #list + 1
    for i, old in ipairs(list) do if better(entry, old) then index = i; break end end
    if index <= limit then
        table.insert(list, index, entry)
        if #list > limit then table.remove(list) end
    end
end

function Planner.plan(position, nodes, now, options, forcedFirstId)
    local beam = {{position = position, elapsed = 0, reward = 0, visited = {}, route = {}}}
    local best
    local deadline = options.budget and (os.clock() + options.budget)
    -- Examine every first stop once, then bound deeper expansion by the CPU budget.
    local roots = {}
    for _, node in ipairs(nodes) do
        if not forcedFirstId or node.id == forcedFirstId then
            local leg = Planner.leg(position, node, now, now, options)
            if leg then
                local reward = node.value * leg.probability
                keepBest(roots, {position = leg.exitPosition, first = node, elapsed = leg.seconds,
                    reward = reward, score = reward / (leg.seconds + options.smoothing),
                    visited = {[node.id] = true}, route = {node}}, options.width)
            end
        end
    end
    if #roots == 0 then return nil end
    beam, best = roots, roots[1]
    for depth = 2, options.depth do
        local expanded = {}
        for _, state in ipairs(beam) do
            if depth > 1 and deadline and os.clock() >= deadline then return best end
            local branches = {}
            local exhausted = false
            for nodeIndex, node in ipairs(nodes) do
                if not state.visited[node.id] and (depth > 1 or not forcedFirstId or node.id == forcedFirstId) then
                    local leg = Planner.leg(state.position, node, now + state.elapsed, now, options)
                    if leg then
                        local elapsed = state.elapsed + leg.seconds
                        local reward = state.reward + node.value * leg.probability
                        local entry = {
                            position = leg.exitPosition, first = state.first or node,
                            elapsed = elapsed, reward = reward,
                            score = reward / (elapsed + options.smoothing),
                            parent = state, node = node,
                        }
                        keepBest(branches, entry, options.branch)
                    end
                end
                if nodeIndex % 16 == 0 and deadline and os.clock() >= deadline then
                    exhausted = true
                    break
                end
            end
            for _, entry in ipairs(branches) do
                entry.visited = table.clone(entry.parent.visited)
                entry.visited[entry.node.id] = true
                entry.route = table.clone(entry.parent.route)
                table.insert(entry.route, entry.node)
                entry.parent, entry.node = nil, nil
                keepBest(expanded, entry, options.width)
                if not best or better(entry, best) then best = entry end
            end
            if exhausted then return best end
        end
        if #expanded == 0 then break end
        beam = expanded
    end
    return best
end

-- DEALER & BOAT CORE
local dealerList, lastDealerScan = {}, -math.huge
local ownedBoat = nil

local function rememberDealer(npc)
    if not (npc:IsA("Model") or npc:IsA("BasePart"))
        or not npc.Name:lower():gsub("%s+", ""):find("boatdealer", 1, true) then return end
    local folder = workspace:FindFirstChild("NPCs")
    if not folder or not npc:IsDescendantOf(folder) then return end
    local position = npc:IsA("Model") and npc:GetPivot().Position or npc.Position
    for _, dealer in ipairs(dealerList) do
        if (dealer.position - position).Magnitude <= 5 then
            dealer.instance, dealer.position, dealer.name = npc, position, npc.Name
            return
        end
    end
    table.insert(dealerList, {instance = npc, position = position, name = npc.Name})
end

local function scanDealers(force)
    local now = workspace:GetServerTimeNow()
    if not force and now - lastDealerScan < 3 then return end
    lastDealerScan = now
    for i = #dealerList, 1, -1 do
        local dealer = dealerList[i]
        if dealer.instance and not dealer.instance:IsDescendantOf(workspace) then
            dealer.instance = nil
        end
    end
end

local function boatSeat(boat)
    if not boat or not boat.Parent then return nil end
    local seat = boat:FindFirstChild("VehicleSeat", true)
    return seat and seat:IsA("VehicleSeat") and seat or nil
end

local function boatBelongsToPlayer(boat)
    local seat = boatSeat(boat)
    if seat and seat.Occupant and seat.Occupant.Parent == player.Character then return true end
    local owner = boat:FindFirstChild("Owner", true)
    if not owner or not owner:IsA("ValueBase") then return false end
    local value = owner.Value
    return value == player or value == player.Name or value == player.UserId
        or tostring(value) == tostring(player.UserId)
end

-- CHARACTER & VELOCITY HELPERS
local function parts()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and char:IsDescendantOf(workspace) and root and hum and hum.Health > 0 then
        return char, root, hum
    end
end

local function getLiveVelocity()
    local char, root, hum = parts()
    if not char or not root then return 0 end
    if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
        local motionPart = hum.SeatPart.AssemblyRootPart or hum.SeatPart
        local vel = motionPart.AssemblyLinearVelocity or motionPart.Velocity
        return vel.Magnitude
    else
        local vel = root.AssemblyLinearVelocity or root.Velocity
        return vel.Magnitude
    end
end

-- UI CREATION
local playerGui = player:FindFirstChildOfClass("PlayerGui")
local GUI_NAME = "ChestFarmerBoat"
local globalEnvironment = getgenv and getgenv() or _G
if globalEnvironment.ChestFarmerBoatStop then pcall(globalEnvironment.ChestFarmerBoatStop) end
local oldGui = playerGui and playerGui:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn = GUI_NAME, false
if LOAD_UI then
    if playerGui then
        gui.Parent = playerGui
    else
        task.spawn(function()
            local latePlayerGui = player:WaitForChild("PlayerGui")
            if not gui.Parent then gui.Parent = latePlayerGui end
        end)
    end
end

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 224)
panel.Position = UDim2.fromOffset(15, 100)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 34)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

local panelScale = Instance.new("UIScale")
panelScale.Parent = panel

local function label(text, x, y, width, height, size, color)
    local item = Instance.new("TextLabel")
    item.BackgroundTransparency = 1
    item.Position = UDim2.fromOffset(x, y)
    item.Size = UDim2.fromOffset(width, height)
    item.Font = Enum.Font.Gotham
    item.TextSize = size
    item.TextColor3 = color
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextTruncate = Enum.TextTruncate.AtEnd
    item.Text = text
    item.Parent = panel
    return item
end

local light = Color3.fromRGB(240, 242, 245)
local muted = Color3.fromRGB(160, 167, 178)
local titleLabel = label("Chest Farm · Initializing", 14, 10, 150, 26, 16, light)
label("Money gained", 14, 46, 130, 18, 11, muted)
label("Money / min", 157, 46, 130, 18, 11, muted)
local gainedLabel = label("—", 14, 65, 130, 24, 18, Color3.fromRGB(125, 225, 163))
local rateLabel = label("—", 157, 65, 130, 24, 18, light)

label("Live velocity", 14, 95, 130, 18, 11, muted)
label("Avg leg speed", 157, 95, 130, 18, 11, muted)
local speedLabel = label("0.0 studs/s", 14, 114, 130, 22, 14, Color3.fromRGB(80, 200, 255))
local avgSpeedLabel = label("—", 157, 114, 130, 22, 14, Color3.fromRGB(125, 225, 163))

local nextPassLabel = label("Watching for active chests…", 14, 142, 272, 17, 11, light)
local availabilityLabel = label("Finding chests…", 14, 160, 272, 17, 11, muted)
local plannerLabel = label("Live planner starting…", 14, 178, 272, 17, 10, muted)
local statusLabel = label("Starting…", 14, 198, 272, 17, 11, muted)
local updateSmallDetails

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.fromOffset(60, 26)
stopButton.Position = UDim2.fromOffset(226, 10)
stopButton.Text = "Stop"
stopButton.Font = Enum.Font.Gotham
stopButton.TextSize = 12
stopButton.TextColor3 = light
stopButton.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
stopButton.BorderSizePixel = 0
stopButton.Parent = panel

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = stopButton

local mapButton = Instance.new("TextButton")
mapButton.Size = UDim2.fromOffset(54, 26)
mapButton.Position = UDim2.fromOffset(166, 10)
mapButton.Text = "Map"
mapButton.Font = Enum.Font.Gotham
mapButton.TextSize = 12
mapButton.TextColor3 = light
mapButton.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
mapButton.BorderSizePixel = 0
mapButton.Parent = panel
local mapButtonCorner = Instance.new("UICorner")
mapButtonCorner.CornerRadius = UDim.new(0, 6)
mapButtonCorner.Parent = mapButton

local stopped = false
local connections = {}

local uiInput = game:GetService("UserInputService")
local uiLastViewport = Vector2.zero
local uiLastTouch = nil
local uiPanelPosition
local function positionStats(position)
    local camera = workspace.CurrentCamera
    if not camera then return end
    local topLeft, bottomRight = game:GetService("GuiService"):GetGuiInset()
    local usable = camera.ViewportSize - topLeft - bottomRight
    local size = Vector2.new(panel.Size.X.Offset, panel.Size.Y.Offset) * panelScale.Scale
    uiPanelPosition = Vector2.new(
        math.clamp(position.X, 0, math.max(0, usable.X - size.X)),
        math.clamp(position.Y, 0, math.max(0, usable.Y - size.Y)))
    panel.Position = UDim2.fromOffset(uiPanelPosition.X, uiPanelPosition.Y)
end
local function layoutStats()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local touch = uiInput.TouchEnabled
    if viewport == uiLastViewport and touch == uiLastTouch then return end
    uiLastViewport, uiLastTouch = viewport, touch
    local topLeft, bottomRight = game:GetService("GuiService"):GetGuiInset()
    local usable = viewport - topLeft - bottomRight
    panelScale.Scale = math.min(1, math.max(0.5, (usable.X - 16) / 300))
    panel.Size = UDim2.fromOffset(300, touch and 240 or 224)
    positionStats(uiPanelPosition or Vector2.new(touch and 8 or 15, touch and 8 or math.min(100, math.max(8, usable.Y - 232))))
    stopButton.Size = UDim2.fromOffset(60, touch and 42 or 26)
    mapButton.Size = UDim2.fromOffset(54, touch and 42 or 26)
    stopButton.Position = UDim2.fromOffset(226, touch and 4 or 10)
    mapButton.Position = UDim2.fromOffset(166, touch and 4 or 10)
    for _, child in ipairs(panel:GetChildren()) do
        if child:IsA("TextLabel") then
            local originalY = child:GetAttribute("LayoutY")
            if not originalY then originalY = child.Position.Y.Offset; child:SetAttribute("LayoutY", originalY) end
            child.Position = UDim2.fromOffset(child.Position.X.Offset, originalY + (touch and originalY >= 46 and 16 or 0))
        end
    end
end
layoutStats()

-- Drag from the title area; Map and Stop remain independent tap targets.
local dragHandle = Instance.new("Frame")
dragHandle.Name = "DragHandle"
dragHandle.BackgroundTransparency = 1
dragHandle.Size = UDim2.fromOffset(158, 44)
dragHandle.Active = true
dragHandle.ZIndex = 5
dragHandle.Parent = panel
local statsDragInput, statsDragStart, statsDragPosition
table.insert(connections, dragHandle.InputBegan:Connect(function(input)
    if stopped or statsDragInput then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    statsDragInput = input
    statsDragStart = Vector2.new(input.Position.X, input.Position.Y)
    statsDragPosition = Vector2.new(panel.Position.X.Offset, panel.Position.Y.Offset)
end))
table.insert(connections, uiInput.InputChanged:Connect(function(input)
    if not statsDragInput or stopped or not panel.Visible then return end
    if input == statsDragInput or (statsDragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement) then
        local position = Vector2.new(input.Position.X, input.Position.Y)
        positionStats(statsDragPosition + position - statsDragStart)
    end
end))
table.insert(connections, uiInput.InputEnded:Connect(function(input)
    if input == statsDragInput then statsDragInput = nil end
end))

local virtualUser = game:GetService("VirtualUser")
local antiAfkConnection = player.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)
table.insert(connections, antiAfkConnection)

local candidates, records = {}, {}
local chestOriginals = setmetatable({}, {__mode = "k"})
local currentRouteDestination
local currentTargetBoxCenter = nil
local currentTargetRecords = nil
local currentNextRoutePosition = nil
local choose, eligible, observeRecord
local liveNavigation = {plan = nil, nodeCount = 0, planMilliseconds = 0, speed = C.BoatSpeed}
local discovery = {active = DISCOVERY_RUN, regions = {}, completed = 0, skipped = 0,
    seededRecords = {}, lastSeedScan = -math.huge}
local streamingJob
local function requestStream(position)
    if not workspace.StreamingEnabled or stopped then return nil end
    if streamingJob and not streamingJob.done then
        return (streamingJob.position - position).Magnitude <= DISCOVERY_RADIUS and streamingJob or nil
    end
    local job = {position = position, done = false}
    streamingJob = job
    task.spawn(function()
        job.ok = pcall(function() player:RequestStreamAroundAsync(position, STREAM_TIMEOUT) end)
        job.done = true
    end)
    return job
end
local lastObserved = -math.huge

local function log(message)
    if C.Debug then print("[Chest Farmer] " .. message) end
end
local function display(message)
    if gui.Parent then statusLabel.Text = message end
end

local startingBeli, moneyStarted
local function formatMoney(value)
    local rounded = math.floor(math.abs(value) + 0.5)
    local digits = string.format("%.0f", rounded)
    local grouped = digits:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    return (value < 0 and rounded > 0 and "-$" or "$") .. grouped
end

local function readBeli()
    local data = player:FindFirstChild("Data")
    local value = data and data:FindFirstChild("Beli")
    if value and (value:IsA("IntValue") or value:IsA("NumberValue")) then return value.Value end
end

local function updateMoney()
    if not gui.Parent then return end
    local balance = readBeli()
    if not balance then return end
    local now = workspace:GetServerTimeNow()
    if startingBeli == nil then startingBeli, moneyStarted = balance, now end
    local gained = balance - startingBeli
    local elapsed = now - moneyStarted
    gainedLabel.Text = formatMoney(gained)
    rateLabel.Text = formatMoney(elapsed > 0 and gained * 60 / elapsed or 0)
end

local moneyRefreshAt = 0
table.insert(connections, RunService.Heartbeat:Connect(function()
    if not gui.Parent then return end
    layoutStats()
    local velocityText = string.format("%.1f studs/s", getLiveVelocity())
    if speedLabel.Text ~= velocityText then speedLabel.Text = velocityText end

    local now = os.clock()
    if now < moneyRefreshAt then return end
    moneyRefreshAt = now + 0.25
    updateMoney()
    if updateSmallDetails then updateSmallDetails() end
    if avgLegSpeed > 0 then
        avgSpeedLabel.Text = string.format("%.1f studs/s", avgLegSpeed)
    else
        avgSpeedLabel.Text = "—"
    end
end))

local function stop()
    if stopped then return end
    stopped = true
    display("Stopping farm…")
end
globalEnvironment.ChestFarmerBoatStop = stop
table.insert(connections, stopButton.Activated:Connect(stop))
table.insert(connections, gui.Destroying:Connect(stop))

local function waitCharacter(timeout)
    local deadline = workspace:GetServerTimeNow() + timeout
    repeat
        local char, root, hum = parts()
        if char then return char, root, hum end
        task.wait(C.PollSeconds)
    until stopped or workspace:GetServerTimeNow() >= deadline
end

local function available(part)
    return part and part:IsDescendantOf(workspace) and part.CanTouch == true
end
local function loadedTrigger(record)
    local trigger = record.spawnPart or record.part
    return trigger and trigger:IsDescendantOf(workspace) and trigger or nil
end
local function rememberedReadyAt(record, now)
    local trigger = loadedTrigger(record)
    if trigger then return trigger.CanTouch and now or math.huge end
    if not record.geometry or record.lastCanTouch == nil then return math.huge end
    if record.lastCanTouch then return now end
    return record.readyAt or math.huge
end
local function chestStatus(record, now)
    local trigger = loadedTrigger(record)
    if trigger and trigger.CanTouch then return "ready" end
    if not trigger and rememberedReadyAt(record, now) <= now then return "remembered" end
    if record.readyAt and record.readyAt < math.huge and record.readyAt > now then return "predicted" end
    return record.lastCanTouch == nil and "unknown" or "empty"
end

local function enforceChestHitbox(part)
    if stopped or not part:IsDescendantOf(workspace) then return end
    pcall(function()
        if part.Size ~= HITBOX_SIZE then part.Size = HITBOX_SIZE end
        if part.CanCollide then part.CanCollide = false end
    end)
end

local function track(obj)
    rememberDealer(obj)
    if not obj:IsA("BasePart") or not obj.Name:lower():find("chest", 1, true) then return end
    local visualFolder = workspace:FindFirstChild("ChestModels")
    if visualFolder and obj:IsDescendantOf(visualFolder) then return end

    if not chestOriginals[obj] then
        chestOriginals[obj] = {size = obj.Size, canCollide = obj.CanCollide}
        for _, property in ipairs({"Size", "CanCollide"}) do
            table.insert(connections, obj:GetPropertyChangedSignal(property):Connect(function()
                enforceChestHitbox(obj)
            end))
        end
        table.insert(connections, obj:GetPropertyChangedSignal("CanTouch"):Connect(function()
            if stopped or not obj:IsDescendantOf(workspace) then return end
            local record = candidates[obj]
            if type(record) ~= "table" then return end
            local attempt = record.pendingAttempt
            if not obj.CanTouch and attempt and not attempt.done and attempt.activeBefore and attempt.crossed
                and attempt.touchPart == obj then
                attempt.deactivatedAt = workspace:GetServerTimeNow()
            end
            if observeRecord then observeRecord(record, obj, workspace:GetServerTimeNow()) end
        end))
    end
    enforceChestHitbox(obj)

    if candidates[obj] == nil then candidates[obj] = true end
end
table.insert(connections, workspace.DescendantAdded:Connect(track))
local initialScanComplete = false
task.spawn(function()
    local pending = {workspace}
    while not stopped and #pending > 0 do
        for _ = 1, 200 do
            local item = table.remove(pending)
            if not item then break end
            track(item)
            for _, child in ipairs(item:GetChildren()) do table.insert(pending, child) end
        end
        task.wait()
    end
    initialScanComplete = not stopped
end)

-- REWARDS & COOLDOWNS (Server-Synchronized)
local function markEmpty(record, now, ours)
    if record.state == "empty" and record.emptyAt and now - record.emptyAt < 5 then
        if ours and record.lastLossCounted then
            record.otherLosses = math.max(0, (record.otherLosses or 0) - 1)
            record.lastLossCounted = false
        end
        return
    end
    record.emptyAt = now
    record.readyAt = now + (respawnOf(record) or economyOf(record).respawn)
    record.observationGap = false
    record.state = "empty"
    record.lastLossCounted = not ours
    if not ours then record.otherLosses = (record.otherLosses or 0) + 1 end
end

observeRecord = function(record, trigger, now)
    if not trigger or not trigger:IsDescendantOf(workspace) then
        record.loaded, record.observationGap = false, true
        return
    end
    local priorTouch = record.lastCanTouch
    local gap = record.observationGap
    record.spawnPart = trigger
    record.loaded = true
    if not record.geometry or record.geometry.cframe ~= trigger.CFrame or record.geometry.size ~= trigger.Size then
        record.geometry = {cframe = trigger.CFrame, size = trigger.Size}
    end
    record.position, record.lastObservedAt = trigger.Position, now
    if trigger.CanTouch then
        if priorTouch == false and record.emptyAt and not gap then
            local measured = now - record.emptyAt
            local nominal = economyOf(record).respawn
            if measured > nominal * 0.5 and measured < nominal * 1.5 then
                record.respawnEstimate = (record.respawnEstimate or nominal) * 0.8 + measured * 0.2
            end
        end
        record.part, record.state, record.collected = trigger, "ready", false
        record.emptyAt, record.readyAt = nil, now
        record.initiallyEmptyAt = nil
    else
        record.part = nil
        if priorTouch == true then
            local attempt = record.pendingAttempt
            markEmpty(record, now, attempt and attempt.deactivatedAt ~= nil)
        end
        record.state = "empty"
        if not record.emptyAt and not record.initiallyEmptyAt then
            -- Unknown startup collection time: a full respawn interval is a conservative bound.
            record.initiallyEmptyAt = now
            record.readyAt = now + (respawnOf(record) or economyOf(record).respawn)
        end
    end
    record.lastCanTouch, record.observationGap = trigger.CanTouch, false
end

local pendingAttempts = {}
local startupMissReports = 0
local lastPickupBalance = readBeli()
local function beginPending(record, sweepSeconds)
    if record.pendingAttempt then return record.pendingAttempt end
    local now = workspace:GetServerTimeNow()
    local trigger = record.spawnPart or record.part
    if not available(trigger) then return nil end
    local attempt = {record = record, touchPart = trigger, activeBefore = available(trigger) == true,
        expires = now + sweepSeconds + C.PendingConfirmSeconds + 1, crossed = false}
    record.pendingAttempt = attempt
    record.pendingUntil = attempt.expires
    table.insert(pendingAttempts, attempt)
    return attempt
end

local function confirmPickup(attempt, now)
    if attempt.done then return end
    attempt.done = true
    local record = attempt.record
    markEmpty(record, now, true)
    record.collected = true
    record.successes = (record.successes or 0) + 1
    record.failures = 0
    record.cooldown = now + 1
end

table.insert(connections, RunService.Heartbeat:Connect(function()
    local now, balance = workspace:GetServerTimeNow(), readBeli()
    if balance and lastPickupBalance and balance > lastPickupBalance then
        local gain = balance - lastPickupBalance
        -- Beli can combine several pickups or come from another source.
        -- Retain it as supporting evidence; it cannot identify a chest by itself.
        for _, attempt in ipairs(pendingAttempts) do
            if not attempt.done and attempt.crossed and now <= attempt.expires then
                attempt.beliEvidence = (attempt.beliEvidence or 0) + gain
            end
        end
    end
    if balance then lastPickupBalance = balance end
    for i = #pendingAttempts, 1, -1 do
        local attempt = pendingAttempts[i]
        -- A pass alone is not a pickup: require contact, deactivation and reward evidence.
        local observedPart = attempt.touchPart
        if not attempt.done and attempt.crossed and attempt.activeBefore and now <= attempt.expires
            and (attempt.beliEvidence or 0) > 0
            and (attempt.deactivatedAt or (observedPart and observedPart:IsDescendantOf(workspace) and observedPart.CanTouch == false)) then
            confirmPickup(attempt, attempt.deactivatedAt or now)
        end
        if attempt.done or now >= attempt.expires then
            local record = attempt.record
            if record.pendingAttempt == attempt then
                record.pendingAttempt, record.pendingUntil = nil, nil
                if not attempt.done and attempt.crossed and attempt.activeBefore
                    and observedPart and observedPart:IsDescendantOf(workspace) and observedPart.CanTouch then
                    if startupMissReports < 5 then
                        startupMissReports += 1
                        local char, root, hum = parts()
                        local touchParts, anchoredParts = 0, 0
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    if part.CanTouch then touchParts += 1 end
                                    if part.Anchored then anchoredParts += 1 end
                                end
                            end
                        end
                        local trigger = record.part or record.spawnPart
                        log(string.format("Miss %d: %s | active trigger=%s | trigger CanTouch=%s | character touch parts=%d | anchored parts=%d | seated=%s | scan complete=%s",
                            startupMissReports, record.name, tostring(available(trigger) == true),
                            tostring(trigger and trigger.CanTouch), touchParts, anchoredParts,
                            tostring(hum and hum.SeatPart ~= nil), tostring(initialScanComplete)))
                    end
                    record.misses = (record.misses or 0) + 1
                    record.failures = (record.failures or 0) + 1
                    record.cooldown = now + math.min(C.MaxChestCooldown, C.ChestFailureCooldown * 2 ^ math.min(record.failures - 1, 4))
                end
            end
            table.remove(pendingAttempts, i)
        end
    end
end))

local function refreshChests(force)
    local now = workspace:GetServerTimeNow()
    if not force and now - lastObserved < C.ObserveSeconds then return end
    local observedSeconds = math.min(2, math.max(0, now - lastObserved))
    lastObserved = now
    for _, r in ipairs(records) do r.spawnPart = nil; r.part = nil end
    for part in pairs(candidates) do
        if not part:IsDescendantOf(workspace) then
            candidates[part] = nil
        else
            enforceChestHitbox(part)

            local r = candidates[part]
            if r == true then
                r = nil
                for _, existing in ipairs(records) do
                    if existing.name == part.Name and (existing.position - part.Position).Magnitude <= C.MatchRadius then
                        r = existing
                        break
                    end
                end
                if not r then
                    r = {id = #records + 1, name = part.Name, position = part.Position,
                        cooldown = 0, failures = 0, successes = 0, misses = 0,
                        exposure = 0, otherLosses = 0, state = "unknown",
                        readyAt = math.huge}
                    table.insert(records, r)
                end
                candidates[part] = r
            end
            r.spawnPart = part
            if available(part) then r.part = part end
            r.position = part.Position
        end
    end
    for _, r in ipairs(records) do
        if r.state == "ready" then r.exposure = (r.exposure or 0) + observedSeconds end
        observeRecord(r, r.spawnPart, now)
    end
end

-- FALLBACK WALKING MOVEMENT (Only used when acquiring initial boat)
local function approachPosition(target, stopRadius)
    local char, root, hum = parts()
    if not char then return false end
    target = enforceAltitudeFloor(target)
    local previousFlight = root:FindFirstChild("ContinuousFlightVelocity")
    local flightWasEnabled = previousFlight and previousFlight.Enabled
    if previousFlight then previousFlight.Enabled = false end
    local attachment = Instance.new("Attachment", root)
    local drive = Instance.new("LinearVelocity", root)
    drive.Attachment0 = attachment
    drive.RelativeTo = Enum.ActuatorRelativeTo.World
    drive.ForceLimitsEnabled = false

    local originals = {}
    local function disableCollision(part)
        if not part:IsA("BasePart") then return end
        if originals[part] == nil then originals[part] = part.CanCollide end
        part.CanCollide = false
    end
    for _, part in ipairs(char:GetDescendants()) do disableCollision(part) end
    local added = char.DescendantAdded:Connect(disableCollision)
    local noclipConn = RunService.PreSimulation:Connect(function()
        for part in pairs(originals) do
            if part.Parent and part.CanCollide then part.CanCollide = false end
        end
    end)

    local estimate = Planner.travelSeconds(root.Position, target, C.Speed)
    local began = workspace:GetServerTimeNow()
    local arrived = false
    while not stopped and player.Character == char and hum.Health > 0 and workspace:GetServerTimeNow() - began <= estimate * 2 + 3 do
        RunService.Heartbeat:Wait()
        local delta = target - root.Position
        if delta.Magnitude <= stopRadius then arrived = true; break end
        drive.VectorVelocity = delta.Unit * C.Speed
    end
    noclipConn:Disconnect()
    added:Disconnect()
    for part, canCollide in pairs(originals) do
        if part.Parent then part.CanCollide = canCollide end
    end
    drive:Destroy()
    attachment:Destroy()
    if previousFlight and previousFlight.Parent then
        previousFlight.Enabled = flightWasEnabled
    end
    return arrived
end

local preparedBoat, boatSeatCleanupConnection
local function prepareDinghySeats(boat)
    if not boat or not boat.Parent or preparedBoat == boat then return end
    if boatSeatCleanupConnection then boatSeatCleanupConnection:Disconnect() end
    preparedBoat = boat
    local function removePassengerSeat(part)
        if part:IsA("Seat") or (part:IsA("VehicleSeat") and part.Name ~= "VehicleSeat") then
            part:Destroy()
        end
    end
    -- Watch before scanning so seats arriving with streamed boat parts are covered too.
    boatSeatCleanupConnection = boat.DescendantAdded:Connect(function(part)
        if not stopped then removePassengerSeat(part) end
    end)
    for _, part in ipairs(boat:GetDescendants()) do removePassengerSeat(part) end
end

local function buyDinghy()
    local boats = workspace:FindFirstChild("Boats") or workspace:WaitForChild("Boats", 3)
    local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
    local event = remoteFolder and remoteFolder:FindFirstChild("CommF_")
    if not boats or not event then return nil end
    local _, root = parts()
    for _, existing in ipairs(boats:GetChildren()) do
        local seat = boatSeat(existing)
        if seat and root and boatBelongsToPlayer(existing) and (root.Position - seat.Position).Magnitude <= 500 then
            prepareDinghySeats(existing)
            return existing
        end
    end
    local seen = {}
    for _, child in ipairs(boats:GetChildren()) do seen[child] = true end
    local arrivals = {}
    local added = boats.ChildAdded:Connect(function(child) table.insert(arrivals, child) end)
    task.spawn(function() pcall(function() event:InvokeServer("BuyBoat", "Dinghy") end) end)
    local deadline = workspace:GetServerTimeNow() + 8
    local found
    repeat
        for _, boat in ipairs(arrivals) do
            if boat.Parent == boats and not seen[boat] and boatBelongsToPlayer(boat) and boatSeat(boat) then
                found = boat
                break
            end
        end
        if found then break end
        task.wait(0.1)
    until stopped or workspace:GetServerTimeNow() >= deadline
    added:Disconnect()
    if found then prepareDinghySeats(found) end
    return found
end

local function boardBoat(boat)
    prepareDinghySeats(boat)
    local char, root, hum = parts()
    local seat = boatSeat(boat)
    if not char or not seat then return false end
    seat:Sit(hum)
    local deadline = workspace:GetServerTimeNow() + 2
    while not stopped and workspace:GetServerTimeNow() < deadline and seat.Occupant ~= hum do task.wait(0.05) end
    return seat.Occupant == hum
end

-- SMART VEHICLE/FALLBACK RESOLVER
local function getActiveVehicleOrCharacter()
    local char, root, hum = parts()
    if not char then return nil, nil end

    if hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
        local boat = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if boat then
            ownedBoat = boat
            prepareDinghySeats(boat)
            local seat = boatSeat(boat)
            if seat and seat.Occupant == hum then
                titleLabel.Text = "Chest Farm · 100% Boat"
                return boat, seat
            end
        end
    end

    if ownedBoat and ownedBoat.Parent then
        prepareDinghySeats(ownedBoat)
        local seat = boatSeat(ownedBoat)
        if seat and (root.Position - seat.Position).Magnitude <= 350 then
            display("Boarding owned Dinghy…")
            approachPosition(seat.Position + Vector3.new(0, 3, 0), 10)
            if boardBoat(ownedBoat) then
                titleLabel.Text = "Chest Farm · 100% Boat"
                return ownedBoat, seat
            end
        end
    end

    scanDealers(true)
    local nearestDealer, nearestDist = nil, math.huge
    for _, dealer in ipairs(dealerList) do
        local dist = (root.Position - dealer.position).Magnitude
        if dist < nearestDist then
            nearestDealer, nearestDist = dealer, dist
        end
    end

    if nearestDealer and nearestDist <= 1200 then
        display("Boat Dealer found! Getting Dinghy…")
        if (root.Position - nearestDealer.position).Magnitude > BOAT_APPROACH_RANGE then
            approachPosition(nearestDealer.position, BOAT_APPROACH_RANGE)
        end
        local boat = buyDinghy()
        if boat then
            ownedBoat = boat
            local seat = boatSeat(boat)
            if seat then
                approachPosition(seat.Position + Vector3.new(0, 3, 0), 8)
                if boardBoat(boat) then
                    titleLabel.Text = "Chest Farm · 100% Boat"
                    return boat, seat
                end
            end
        end
    end

    titleLabel.Text = "Chest Farm · On Foot (Scanning)"
    return nil, nil
end

-- 3D CONTINUOUS FLIGHT CONTROLLER
local persistentLinearVelocity = nil
local persistentAttachment = nil
local persistentNoclipConn = nil
local noclipChar, noclipBoat = nil, nil
local noclipOriginals = {}
local noclipAdded = {}

local function restoreFlightCollision()
    for _, connection in ipairs(noclipAdded) do connection:Disconnect() end
    table.clear(noclipAdded)
    for part, canCollide in pairs(noclipOriginals) do
        if part.Parent then part.CanCollide = canCollide end
    end
    table.clear(noclipOriginals)
    noclipChar, noclipBoat = nil, nil
end

local function setFlightCollisionTargets(char, boat, motionPart)
    if char == noclipChar and boat == noclipBoat then return end
    restoreFlightCollision()
    noclipChar, noclipBoat = char, boat
    local function disable(part)
        if not part:IsA("BasePart") then return end
        if noclipOriginals[part] == nil then noclipOriginals[part] = part.CanCollide end
        part.CanCollide = false
    end
    local function watch(container)
        if not container then return end
        for _, part in ipairs(container:GetDescendants()) do disable(part) end
        table.insert(noclipAdded, container.DescendantAdded:Connect(disable))
    end
    watch(char)
    watch(boat)
    if motionPart then
        disable(motionPart)
        local ok, connected = pcall(function() return motionPart:GetConnectedParts(true) end)
        if ok then for _, part in ipairs(connected) do disable(part) end end
    end
    if not persistentNoclipConn then
        persistentNoclipConn = RunService.PreSimulation:Connect(function()
            for part in pairs(noclipOriginals) do
                if not part.Parent then
                    noclipOriginals[part] = nil
                elseif part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    end
end

local activeFlightCommand
local function applyFlightCommand(command, now)
    local motionPart, lv, dir = command.part, command.constraint, command.direction
    if stopped or not motionPart.Parent or not lv.Parent then return end
    local speed = command.isBoat and math.clamp(getSinusoidalSpeed(now), SPEED_MIN, SPEED_MAX) or C.Speed
    local velocity = dir * speed
    if command.seat and command.seat.Parent then
        -- Native propulsion must not compete with the world-space flight velocity.
        command.seat.ThrottleFloat = 0
        command.seat.SteerFloat = 0
    end
    local up = math.abs(dir.Y) > 0.999 and Vector3.new(0, 0, -1) or Vector3.yAxis
    motionPart.CFrame = CFrame.lookAt(motionPart.Position, motionPart.Position + dir, up)
    motionPart.AssemblyAngularVelocity = Vector3.zero
    lv.VectorVelocity = velocity
    motionPart.AssemblyLinearVelocity = velocity
end
-- Persistent across adjacent legs; update before physics without stopping at boundaries.
table.insert(connections, RunService.PreSimulation:Connect(function()
    local command = activeFlightCommand
    if command then
        if command.character ~= player.Character or not command.part.Parent or not command.constraint.Parent then
            activeFlightCommand = nil
            return
        end
        applyFlightCommand(command, workspace:GetServerTimeNow())
    end
end))

local function getFlightConstraint(boat, seat)
    local char, root = parts()
    local motionPart = seat and (seat.AssemblyRootPart or seat) or root
    if not motionPart then return nil, nil end

    if not persistentLinearVelocity or persistentLinearVelocity.Parent ~= motionPart then
        if persistentLinearVelocity then persistentLinearVelocity:Destroy() end
        if persistentAttachment then persistentAttachment:Destroy() end

        persistentAttachment = Instance.new("Attachment")
        persistentAttachment.Name = "ContinuousFlightAttachment"
        persistentAttachment.Parent = motionPart

        persistentLinearVelocity = Instance.new("LinearVelocity")
        persistentLinearVelocity.Name = "ContinuousFlightVelocity"
        persistentLinearVelocity.Attachment0 = persistentAttachment
        persistentLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        persistentLinearVelocity.ForceLimitsEnabled = false
        persistentLinearVelocity.MaxForce = math.huge
        persistentLinearVelocity.VectorVelocity = Vector3.zero
        persistentLinearVelocity.Parent = motionPart
    end

    setFlightCollisionTargets(char, boat, motionPart)

    return persistentLinearVelocity, motionPart
end

local function pauseFlight()
    activeFlightCommand = nil
    if persistentLinearVelocity and persistentLinearVelocity.Parent then
        persistentLinearVelocity.VectorVelocity = Vector3.zero
        local motionPart = persistentLinearVelocity.Parent
        if motionPart:IsA("BasePart") then
            motionPart.AssemblyLinearVelocity = Vector3.zero
            motionPart.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

-- Moves in a single straight 3D vector directly to the destination with INSTANT acceleration and FULL 3D PITCH
local function move3D(boat, seat, destination, recordsToArm, guard)
    local char, root, hum = parts()
    if not char then return "interrupted" end

    local lv, motionPart = getFlightConstraint(boat, seat)
    if not lv or not motionPart then return "interrupted" end

    local began = workspace:GetServerTimeNow()
    local startPos = root.Position
    local delta = destination - startPos
    local totalDist = delta.Magnitude
    local function armNearby(position)
        if not recordsToArm then return end
        for _, rec in ipairs(recordsToArm) do
            local trigger = rec.spawnPart or rec.part
            local offset = trigger and trigger.CFrame:PointToObjectSpace(position)
            local half = trigger and trigger.Size * 0.5
            if available(trigger) and math.abs(offset.X) <= half.X + 12
                and math.abs(offset.Y) <= half.Y + 12 and math.abs(offset.Z) <= half.Z + 12 then
                local attempt = beginPending(rec, 0.05)
                if attempt and math.abs(offset.X) <= half.X and math.abs(offset.Y) <= half.Y
                    and math.abs(offset.Z) <= half.Z then attempt.crossed = true end
            end
        end
    end

    armNearby(startPos)
    if totalDist <= C.ArrivalDistance then return "arrived" end

    local initialDir = delta.Unit
    local isBoat = (boat ~= nil and seat ~= nil)
    local minSpeed = isBoat and SPEED_MIN or C.Speed
    local timeout = (totalDist / minSpeed) + 3.0
    local outcome = "arrived"
    local movingDistance, movingTime = 0, 0
    local previousPosition, previousTime = motionPart.Position, os.clock()

    local command = {part = motionPart, constraint = lv, direction = initialDir,
        seat = seat, isBoat = isBoat, character = char}
    local function drive(dir, now)
        command.direction = dir
        activeFlightCommand = command
        applyFlightCommand(command, now)
    end

    drive(initialDir, began)

    while not stopped and player.Character == char and hum.Health > 0 do
        RunService.Heartbeat:Wait()
        local frameTime = os.clock()
        local framePosition = motionPart.Position
        movingDistance += (framePosition - previousPosition).Magnitude
        movingTime += frameTime - previousTime
        previousPosition, previousTime = framePosition, frameTime
        if isBoat and seat.Occupant ~= hum then
            seat:Sit(hum)
            if seat.Occupant ~= hum then outcome = "interrupted"; break end
        end

        local now = workspace:GetServerTimeNow()
        if now - began > timeout then outcome = "timeout"; break end

        local currentPos = root.Position
        local currentDelta = destination - currentPos
        local currentDist = currentDelta.Magnitude

        armNearby(currentPos)
        if guard then
            local decision = guard(now, currentPos, currentDist)
            if decision then outcome = decision; break end
        end

        -- Cutoff check
        local passed = (currentPos - startPos):Dot(initialDir) >= totalDist
        if currentDist <= C.ArrivalDistance or passed then
            outcome = "arrived"
            break
        end

        -- Each leg is a straight velocity vector; do not chase an overshot endpoint.
        drive(initialDir, now)
    end

    if stopped or player.Character ~= char or hum.Health <= 0 then
        outcome = "interrupted"
    end
    if outcome == "arrived" then
        recordLegPerformance(movingDistance, movingTime, isBoat and "boat" or "foot")
    elseif outcome == "timeout" or outcome == "interrupted" then
        pauseFlight()
    end

    return outcome
end

-- One short pass collects every chest in an overlapping trigger cluster.
local function flyThroughTarget(boat, seat, node)
    local char, root = parts()
    if not char then return "interrupted" end
    local recordsList = node.records
    local entryPoint, centerPoint, exitPoint = Planner.sweepPath(node, root.Position, C.SweepMargin)
    currentTargetBoxCenter, currentTargetRecords = centerPoint, recordsList
    local function finish(outcome)
        currentRouteDestination, currentTargetBoxCenter = nil, nil
        currentTargetRecords, currentNextRoutePosition = nil, nil
        return outcome
    end
    local function hasActive()
        for _, record in ipairs(recordsList) do
            if available(record.spawnPart or record.part) then return true end
        end
        return false
    end
    local function hasMissing()
        for _, record in ipairs(recordsList) do if not loadedTrigger(record) then return true end end
        return false
    end
    local function hasPotential(now, seconds)
        for _, record in ipairs(recordsList) do
            if rememberedReadyAt(record, now) <= now + seconds then return true end
        end
        return false
    end
    local approachSeconds = Planner.travelSeconds(root.Position, entryPoint, liveNavigation.speed)
    if not hasPotential(workspace:GetServerTimeNow(), approachSeconds) then return finish("unavailable") end
    local verificationJob
    local began, lastReplan = workspace:GetServerTimeNow(), workspace:GetServerTimeNow()
    local targetName = node.isCluster and ("Pass · " .. #recordsList .. " chests") or node.record.name
    local function guard(now, position, remaining)
        if not hasPotential(now, Planner.travelSeconds(position, entryPoint, liveNavigation.speed)) then return "unavailable" end
        if hasMissing() and not verificationJob and remaining <= liveNavigation.speed * STREAM_TIMEOUT + DISCOVERY_RADIUS then
            verificationJob = requestStream(centerPoint)
        end
        if remaining <= C.FinishDistance or now - began < C.MinimumCommitSeconds
            or now - lastReplan < C.ReplanSeconds then return end
        -- Finish the short pass once contact is possible; never reroute during confirmation.
        for _, record in ipairs(recordsList) do
            if record.pendingAttempt then return end
        end
        lastReplan = now
        refreshChests()
        local _, currentRoot = parts()
        if not currentRoot then return "interrupted" end
        local best = choose(currentRoot, nil, liveNavigation.speed)
        if not best then return "unavailable" end
        local sameTarget = best.first.id == node.id
        local retained = sameTarget and best or choose(currentRoot, node.record, liveNavigation.speed)
        if not sameTarget and (not retained or best.score > retained.score * C.SwitchGain) then
            return "reroute"
        end
        -- Preserve the displayed committed route when a marginal alternative is rejected.
        if retained then
            liveNavigation.plan = retained
            currentNextRoutePosition = retained.route[2] and retained.route[2].position or nil
        end
    end
    display("Approach · " .. targetName)
    currentRouteDestination = entryPoint
    local approach = move3D(boat, seat, entryPoint, recordsList, guard)
    if approach ~= "arrived" then return finish(approach) end
    refreshChests(true)
    if not hasActive() and hasMissing() then
        if workspace.StreamingEnabled then
            verificationJob = verificationJob or requestStream(centerPoint)
            pauseFlight()
            local deadline = workspace:GetServerTimeNow() + STREAM_TIMEOUT
            while not stopped and not hasActive() and workspace:GetServerTimeNow() < deadline do
                RunService.Heartbeat:Wait()
                refreshChests()
                local allLoaded = true
                for _, record in ipairs(recordsList) do if not loadedTrigger(record) then allLoaded = false; break end end
                if allLoaded then break end
                if not verificationJob then verificationJob = requestStream(centerPoint) end
            end
            refreshChests(true)
        end
    end
    if stopped then return finish("interrupted") end
    if not hasActive() then
        for _, record in ipairs(recordsList) do
            if not loadedTrigger(record) then record.cooldown = workspace:GetServerTimeNow() + C.ChestFailureCooldown end
        end
        return finish("unavailable")
    end
    display("Passing through · " .. targetName)
    currentRouteDestination = exitPoint
    -- No timer wait and no artificial confirmation pause: continue through the hitboxes.
    return finish(move3D(boat, seat, exitPoint, recordsList))
end
-- Loaded inactivity wins. Remembered data is usable only when its hitbox is unloaded.
eligible = function(record, now)
    local pending = record.pendingAttempt
    return rememberedReadyAt(record, now) < math.huge
        and not (pending and not pending.done)
        and now >= (record.cooldown or 0)
end

-- Conservatively inscribe an axis-aligned cube in a rotated hitbox.
local function triggerBounds(record)
    local geometry = record.geometry
    if geometry.low then return geometry.low, geometry.high end
    local half = geometry.size * 0.5
    local rotation = geometry.cframe
    local right, up, look = rotation.RightVector, rotation.UpVector, rotation.LookVector
    local radius = math.min(
        half.X / (math.abs(right.X) + math.abs(right.Y) + math.abs(right.Z)),
        half.Y / (math.abs(up.X) + math.abs(up.Y) + math.abs(up.Z)),
        half.Z / (math.abs(look.X) + math.abs(look.Y) + math.abs(look.Z)))
    local extent = Vector3.new(radius, radius, radius)
    local low, high = rotation.Position - extent, rotation.Position + extent
    low = Vector3.new(low.X, math.max(low.Y, C.MinRootY), low.Z)
    geometry.low, geometry.high = low, high
    return low, high
end
local function overlapBounds(aLow, aHigh, bLow, bHigh)
    local low = Vector3.new(math.max(aLow.X, bLow.X), math.max(aLow.Y, bLow.Y), math.max(aLow.Z, bLow.Z))
    local high = Vector3.new(math.min(aHigh.X, bHigh.X), math.min(aHigh.Y, bHigh.Y), math.min(aHigh.Z, bHigh.Z))
    return low, high
end
local function buildFusedClusters(rawNodes)
    local nodes, used = {}, {}
    for index, anchor in ipairs(rawNodes) do
        if used[index] then continue end
        local group, low, high = {anchor.record}, anchor.low, anchor.high
        local value, expected, readyAt = anchor.value, anchor.value * anchor.reliability, anchor.readyAt
        used[index] = true
        for other = index + 1, #rawNodes do
            if used[other] then continue end
            local candidate = rawNodes[other]
            if anchor.inferred ~= candidate.inferred or math.abs(readyAt - candidate.readyAt) > 3 then continue end
            if candidate.low.X > high.X - 4 or candidate.high.X < low.X + 4
                or candidate.low.Y > high.Y - 4 or candidate.high.Y < low.Y + 4
                or candidate.low.Z > high.Z - 4 or candidate.high.Z < low.Z + 4 then continue end
            local nextLow, nextHigh = overlapBounds(low, high, candidate.low, candidate.high)
            local span = nextHigh - nextLow
            -- Every member shares a real touch region; one short pass can collect all.
            if math.min(span.X, span.Y, span.Z) >= 4 then
                low, high = nextLow, nextHigh
                value += candidate.value
                expected += candidate.value * candidate.reliability
                readyAt = math.max(readyAt, candidate.readyAt)
                table.insert(group, candidate.record)
                used[other] = true
            end
        end
        table.insert(nodes, {id = anchor.record.id, record = anchor.record, records = group,
            position = (low + high) * 0.5, halfSize = (high - low) * 0.5,
            value = value, reliability = expected / value,
            readyAt = readyAt, inferred = anchor.inferred,
            isCluster = #group > 1, clusterCount = #group})
    end
    return nodes
end
local function snapshotNodes(now)
    local raw = {}
    for _, record in ipairs(records) do
        if not eligible(record, now) then continue end
        local low, high = triggerBounds(record)
        if high.Y <= low.Y then continue end
        local reward = economyOf(record).rewards[REWARD_SEA]
        local inferred = loadedTrigger(record) == nil
        table.insert(raw, {record = record, low = low, high = high, value = (reward[1] + reward[2]) * 0.5,
            readyAt = rememberedReadyAt(record, now), inferred = inferred,
            reliability = math.clamp((record.successes + 8) / (record.successes + record.misses + 8), 0.3, 1)
                * (inferred and 0.85 or 1)})
    end
    return buildFusedClusters(raw)
end
local function plannerOptions(speed)
    return {speed = speed, maxTravel = MAX_TRAVEL_SECONDS,
        travelEstimator = function(from, dest) return Planner.travelSeconds(from, dest, speed) end,
        service = ESTIMATED_PICKUP_SECONDS, sweepMargin = C.SweepMargin,
        depth = LOOKAHEAD_STOPS, width = C.BeamWidth, branch = C.BranchWidth,
        smoothing = 5, budget = C.PlanBudgetSeconds}
end
choose = function(root, forcedRecord, currentSpeed)
    local now, began = workspace:GetServerTimeNow(), os.clock()
    local nodes = snapshotNodes(now)
    local plan = Planner.plan(root.Position, nodes, now, plannerOptions(currentSpeed or C.BoatSpeed),
        forcedRecord and forcedRecord.id)
    if plan then plan.node, plan.record = plan.first, plan.first.record end
    if not forcedRecord then
        liveNavigation.plan = plan
        liveNavigation.nodeCount, liveNavigation.planMilliseconds = #nodes, (os.clock() - began) * 1000
    end
    return plan
end

-- Discovery visits chest locations only and expands as more chest parts stream in.
-- It is separate from dynamic farming and never treats a visit as collection evidence.
local function addDiscoveryRegion(record)
    local position = enforceAltitudeFloor(record.position)
    for _, region in ipairs(discovery.regions) do
        if (region.position - position).Magnitude <= DISCOVERY_RADIUS then return end
    end
    table.insert(discovery.regions, {position = position, name = record.name, record = record, visits = 0})
end
local function collectDiscoverySeeds(force)
    if not discovery.active then return end
    local now = os.clock()
    if not force and now - discovery.lastSeedScan < 1 then return end
    discovery.lastSeedScan = now
    for _, record in ipairs(records) do
        if not discovery.seededRecords[record.id] then
            discovery.seededRecords[record.id] = true
            addDiscoveryRegion(record)
        end
    end
end
local function discoveryNode(region)
    if region.record.geometry then
        local low, high = triggerBounds(region.record)
        return {position = (low + high) * 0.5, halfSize = (high - low) * 0.5}
    end
    return {position = region.position}
end
local function chooseDiscovery(root, speed)
    collectDiscoverySeeds(true)
    local nearest, distance
    for _, region in ipairs(discovery.regions) do
        local trigger = loadedTrigger(region.record)
        if not region.visited and trigger and not trigger.CanTouch then
            -- Its state is already observed; discovery does not need a trip to an empty chest.
            region.visited = true
            discovery.completed += 1
        end
        if not region.visited then
            local entry = Planner.sweepPath(discoveryNode(region), root.Position, C.SweepMargin)
            local candidate = Planner.travelSeconds(root.Position, entry, speed)
            if candidate <= MAX_TRAVEL_SECONDS and (not distance or candidate < distance) then
                nearest, distance = region, candidate
            end
        end
    end
    if not nearest then
        for _, region in ipairs(discovery.regions) do
            if not region.visited then region.visited = true; discovery.skipped += 1 end
        end
        discovery.active = false
        log(string.format("Discovery complete: %d areas sampled, %d chest locations remembered, %d far areas skipped",
            discovery.completed, #records, discovery.skipped))
    end
    return nearest
end
local function discoverArea(boat, seat, region)
    local _, root = parts()
    if not root then return "interrupted" end
    local entryPoint, centerPoint, exitPoint = Planner.sweepPath(discoveryNode(region), root.Position, C.SweepMargin)
    local nearRecords = {}
    for _, record in ipairs(records) do
        if (record.position - region.position).Magnitude <= DISCOVERY_RADIUS then table.insert(nearRecords, record) end
    end
    liveNavigation.plan = nil
    currentRouteDestination, currentTargetRecords = entryPoint, nearRecords
    currentTargetBoxCenter, currentNextRoutePosition = centerPoint, nil
    display(string.format("Discovering %d/%d · %s", discovery.completed + 1, #discovery.regions, region.name))
    local job
    local knownRecordCount = #records
    local function streamGuard(_, _, remaining)
        refreshChests()
        local trigger = loadedTrigger(region.record)
        if trigger and not trigger.CanTouch then return "unavailable" end
        for index = knownRecordCount + 1, #records do
            local record = records[index]
            if (record.position - region.position).Magnitude <= DISCOVERY_RADIUS then
                table.insert(nearRecords, record)
            end
        end
        knownRecordCount = #records
        if not job and remaining <= liveNavigation.speed * STREAM_TIMEOUT + DISCOVERY_RADIUS then
            job = requestStream(region.position)
        end
    end
    local outcome = move3D(boat, seat, entryPoint, nearRecords, streamGuard)
    if outcome == "arrived" then
        if workspace.StreamingEnabled and not loadedTrigger(region.record) and (not job or not job.done) then
            job = job or requestStream(region.position)
            pauseFlight()
            local deadline = workspace:GetServerTimeNow() + STREAM_TIMEOUT
            repeat
                RunService.Heartbeat:Wait()
                refreshChests()
                if not job then job = requestStream(region.position) end
            until stopped or loadedTrigger(region.record) or (job and job.done) or workspace:GetServerTimeNow() >= deadline
        end
        refreshChests(true)
        collectDiscoverySeeds(true)
        if available(loadedTrigger(region.record)) then
            currentRouteDestination = exitPoint
            outcome = move3D(boat, seat, exitPoint, nearRecords)
        end
        if outcome == "arrived" then
            region.visited = true
            discovery.completed += 1
        elseif outcome == "timeout" then
            region.visits += 1
            if region.visits >= 2 then region.visited = true; discovery.skipped += 1 end
        end
    elseif outcome == "timeout" then
        region.visits += 1
        if region.visits >= 2 then region.visited = true; discovery.skipped += 1 end
    end
    currentRouteDestination, currentTargetBoxCenter = nil, nil
    currentTargetRecords, currentNextRoutePosition = nil, nil
    return outcome
end

updateSmallDetails = function()
    local ready, expected, waiting, confirmed, loaded = 0, 0, 0, 0, 0
    local now = workspace:GetServerTimeNow()
    for _, record in ipairs(records) do
        confirmed += record.successes or 0
        if loadedTrigger(record) then loaded += 1 end
        local state = chestStatus(record, now)
        if state == "ready" then ready += 1
        elseif state == "remembered" then expected += 1
        else waiting += 1 end
    end
    availabilityLabel.Text = string.format("%d live · %d expected · %d cooling/empty", ready, expected, waiting)
    if discovery.active then
        nextPassLabel.Text = string.format("Discovery %d/%d areas · %d known chests",
            discovery.completed + discovery.skipped, #discovery.regions, #records)
        plannerLabel.Text = string.format("%d loaded · %d confirmed · learning locations", loaded, confirmed)
        return
    end
    local plan = liveNavigation.plan
    if plan then
        local _, root = parts()
        local seconds = root and Planner.travelSeconds(root.Position,
            Planner.sweepPath(plan.first, root.Position, C.SweepMargin), liveNavigation.speed or C.BoatSpeed) or 0
        nextPassLabel.Text = string.format("Next pass ~%s · ETA %.1fs", formatMoney(plan.first.value), seconds)
    else
        nextPassLabel.Text = "Watching known chest respawns…"
    end
    plannerLabel.Text = string.format("%d confirmed · %d candidate stops · %d ahead",
        confirmed, liveNavigation.nodeCount, plan and #plan.route or 0)
end

local function installChestMap()
    if not LOAD_UI then return end
    local inputService = game:GetService("UserInputService")
    local guiService = game:GetService("GuiService")
    local colors = {
        ready = Color3.fromRGB(99, 225, 160), predicted = Color3.fromRGB(255, 204, 111),
        remembered = Color3.fromRGB(125, 190, 255),
        unknown = Color3.fromRGB(126, 166, 231), empty = Color3.fromRGB(113, 125, 143),
        target = Color3.fromRGB(255, 113, 132), dealer = Color3.fromRGB(186, 147, 247),
    }
    local function rounded(object, radius)
        Instance.new("UICorner", object).CornerRadius = UDim.new(0, radius)
    end
    local function text(parent, value, size, color)
        local item = Instance.new("TextLabel")
        item.BackgroundTransparency = 1
        item.Font = Enum.Font.Gotham
        item.TextSize = size
        item.TextColor3 = color or light
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.TextTruncate = Enum.TextTruncate.AtEnd
        item.Text = value
        item.Parent = parent
        return item
    end
    local frame = Instance.new("Frame")
    frame.Name = "ChestMap"
    frame.Visible = false
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(19, 24, 33)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    rounded(frame, 12)
    local border = Instance.new("UIStroke", frame)
    border.Color = Color3.fromRGB(57, 69, 87)
    local heading = text(frame, "CHEST MAP · LIVE ROUTE", 16)
    heading.Font = Enum.Font.GothamBold
    heading.Position, heading.Size = UDim2.fromOffset(14, 10), UDim2.new(1, -64, 0, 24)
    local subtitle = text(frame, "Finding nearby spawns…", 11, muted)
    subtitle.Position, subtitle.Size = UDim2.fromOffset(14, 36), UDim2.new(1, -28, 0, 18)
    local function button(value, x, width, y)
        local item = Instance.new("TextButton")
        item.Text, item.Font, item.TextSize = value, Enum.Font.GothamMedium, 12
        item.TextColor3 = light
        item.BackgroundColor3 = Color3.fromRGB(38, 47, 62)
        item.BorderSizePixel = 0
        item.Position, item.Size = UDim2.fromOffset(x, y or 62), UDim2.fromOffset(width, 32)
        item.Parent = frame
        rounded(item, 6)
        return item
    end
    local fitButton = button("Fit", 12, 42)
    local followButton = button("Follow", 60, 62)
    local timersButton = button("Timers Off", 128, 88)
    local minusButton = button("−", 222, 32)
    local plusButton = button("+", 260, 32)
    local closeButton = button("×", 0, 30, 8)
    closeButton.Position = UDim2.new(1, -42, 0, 8)
    local canvas = Instance.new("Frame")
    canvas.Position, canvas.Size = UDim2.fromOffset(12, 104), UDim2.new(1, -24, 1, -234)
    canvas.BackgroundColor3 = Color3.fromRGB(25, 33, 45)
    canvas.BorderSizePixel = 0
    canvas.ClipsDescendants = true
    canvas.Parent = frame
    local function footer(value, y, height, size)
        local item = text(frame, value, size or 11, muted)
        item.Position, item.Size = UDim2.new(0, 14, 1, y), UDim2.new(1, -28, 0, height)
        return item
    end
    local legend = footer('', -120, 18, 11)
    legend.RichText = true
    legend.Text = '<font color="#63E1A0">●</font> Live   <font color="#7DBEFF">●</font> Expected   <font color="#FFCC6F">●</font> Cooling'
    local legend2 = footer('', -102, 18, 11)
    legend2.RichText = true
    legend2.Text = '<font color="#717D8F">●</font> Empty   <font color="#FF7184">●</font> Target   <font color="#BA93F7">◆</font> Dealer   <font color="#FFFFFF">▲</font> You'
    local help = footer("Drag to pan · Tap a group to zoom · S / G / D = grade", -81, 18, 10)
    local details = footer("Tap a chest for its value, distance and respawn time.", -60, 50, 12)
    details.TextWrapped, details.TextTruncate = true, Enum.TextTruncate.None
    details.TextYAlignment = Enum.TextYAlignment.Top
    details.TextColor3 = light

    local center, pixelsPerStud = Vector2.zero, 0.1
    local initialized, follow, timers = false, false, false
    local autoFitUntil, fittedRecordCount = os.clock() + 2, 0
    local selected, selectedGroup = nil, nil
    local dirty, lastRefresh, suppressClickUntil = true, 0, 0
    local markerPool, dealerPool, gridPool = {}, {}, {}
    local lastViewport = Vector2.zero
    local function flat(position) return Vector2.new(position.X, position.Z) end
    local function project(position)
        local delta = flat(position) - center
        return canvas.AbsoluteSize * 0.5 + Vector2.new(delta.X, -delta.Y) * pixelsPerStud
    end
    local function unproject(point)
        local delta = (point - canvas.AbsoluteSize * 0.5) / pixelsPerStud
        return center + Vector2.new(delta.X, -delta.Y)
    end
    local function isInRange(position, root)
        return not root or (flat(position) - flat(root.Position)).Magnitude <= MAP_OUTLIER_DISTANCE
    end
    local function countdown(seconds)
        local value = math.max(0, math.ceil(seconds))
        return string.format("%d:%02d", math.floor(value / 60), value % 60)
    end
    local function status(record, now)
        return chestStatus(record, now)
    end
    local function setFollow(value)
        follow = value
        followButton.Text = value and "Following" or "Follow"
        followButton.BackgroundColor3 = value and Color3.fromRGB(39, 87, 100) or Color3.fromRGB(38, 47, 62)
    end
    local function fit()
        local _, root = parts()
        if not root then return end
        local low, high = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
        local count = 0
        local function include(position)
            local p = flat(position)
            low = Vector2.new(math.min(low.X, p.X), math.min(low.Y, p.Y))
            high = Vector2.new(math.max(high.X, p.X), math.max(high.Y, p.Y))
        end
        for _, record in ipairs(records) do
            if isInRange(record.position, root) then include(record.position); count += 1 end
        end
        if root then include(root.Position) end
        if low.X == math.huge then return end
        center = (low + high) * 0.5
        local size, span = canvas.AbsoluteSize, high - low
        pixelsPerStud = math.clamp(math.min(math.max(40, size.X - 64) / math.max(200, span.X),
            math.max(40, size.Y - 64) / math.max(200, span.Y)), 0.002, 4)
        initialized = count > 0
        setFollow(false)
        dirty = true
    end
    local function zoom(factor, point)
        autoFitUntil = 0
        point = point or canvas.AbsoluteSize * 0.5
        local before = unproject(point)
        pixelsPerStud = math.clamp(pixelsPerStud * factor, 0.002, 4)
        center += before - unproject(point)
        setFollow(false)
        dirty = true
    end
    local function line(color, thickness)
        local item = Instance.new("Frame")
        item.BorderSizePixel, item.BackgroundColor3 = 0, color
        item.AnchorPoint = Vector2.new(0.5, 0.5)
        item.ZIndex = 2
        item.Size = UDim2.fromOffset(0, thickness or 2)
        item.Parent = canvas
        return item
    end
    local routeLine, nextLine = line(Color3.fromRGB(88, 205, 237)), line(colors.predicted)
    routeLine.ZIndex, nextLine.ZIndex = 3, 3
    local lookaheadLines = {}
    local function drawLine(item, a, b)
        item.Visible = a ~= nil and b ~= nil
        if not item.Visible then return end
        -- Clip before rotating so a long route cannot spill across the surrounding UI.
        local travel, enter, leave = b - a, 0, 1
        local function clip(p, q)
            if math.abs(p) < 1e-9 then return q >= 0 end
            local ratio = q / p
            if p < 0 then enter = math.max(enter, ratio) else leave = math.min(leave, ratio) end
            return enter <= leave
        end
        local bounds = canvas.AbsoluteSize
        if not (clip(-travel.X, a.X) and clip(travel.X, bounds.X - a.X)
            and clip(-travel.Y, a.Y) and clip(travel.Y, bounds.Y - a.Y)) then
            item.Visible = false
            return
        end
        b, a = a + travel * leave, a + travel * enter
        local delta, midpoint = b - a, (a + b) * 0.5
        item.Position, item.Size = UDim2.fromOffset(midpoint.X, midpoint.Y),
            UDim2.fromOffset(delta.Magnitude, item.Size.Y.Offset)
        item.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    end
    local playerDot = text(canvas, "▲", 23, Color3.new(1, 1, 1))
    playerDot.AnchorPoint, playerDot.Size = Vector2.new(0.5, 0.5), UDim2.fromOffset(26, 26)
    playerDot.TextXAlignment, playerDot.ZIndex = Enum.TextXAlignment.Center, 7
    playerDot.TextStrokeTransparency = 0.3
    local scaleLabel = text(canvas, "", 10, muted)
    scaleLabel.Position, scaleLabel.Size, scaleLabel.ZIndex = UDim2.fromOffset(8, 6), UDim2.new(1, -16, 0, 16), 8

    local function newMarker()
        local item = {}
        item.button = Instance.new("TextButton")
        local b = item.button
        b.AnchorPoint, b.Size = Vector2.new(0.5, 0.5), UDim2.fromOffset(inputService.TouchEnabled and 34 or 24, inputService.TouchEnabled and 34 or 24)
        b.Font, b.TextSize, b.TextColor3 = Enum.Font.GothamBold, 11, Color3.fromRGB(17, 24, 33)
        b.BorderSizePixel, b.ZIndex, b.Parent = 0, 4, canvas
        rounded(b, 12)
        item.stroke = Instance.new("UIStroke", b)
        item.stroke.ApplyStrokeMode, item.stroke.Thickness = Enum.ApplyStrokeMode.Border, 2
        item.timer = text(canvas, "", 10, colors.predicted)
        item.timer.BackgroundColor3, item.timer.BackgroundTransparency = Color3.fromRGB(15, 21, 30), 0.05
        item.timer.TextXAlignment, item.timer.Size, item.timer.ZIndex = Enum.TextXAlignment.Center, UDim2.fromOffset(52, 18), 6
        rounded(item.timer, 4)
        table.insert(connections, b.Activated:Connect(function()
            if os.clock() < suppressClickUntil or not item.group then return end
            local group = item.group
            selectedGroup, selected = group.records, group.records[1]
            if #group.records > 1 then
                if pixelsPerStud >= 4 then
                    item.inspectIndex = (item.inspectIndex or 0) % #group.records + 1
                    selected, selectedGroup = group.records[item.inspectIndex], nil
                else
                    center = group.world / #group.records
                    pixelsPerStud = math.min(4, pixelsPerStud * 2.2)
                end
                autoFitUntil = 0
                setFollow(false)
            end
            dirty = true
        end))
        return item
    end
    local function layout()
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 700)
        if not gui.IgnoreGuiInset then
            local topLeft, bottomRight = guiService:GetGuiInset()
            viewport -= topLeft + bottomRight
        end
        if viewport == lastViewport then return end
        lastViewport = viewport
        local touch = inputService.TouchEnabled
        local width = math.max(260, math.min(520, viewport.X - 16))
        local height = math.max(240, math.min(600, viewport.Y - 16))
        frame.Size = UDim2.fromOffset(width, height)
        frame.Position = UDim2.new(1, -8, 0, touch and 8 or math.min(76, math.max(8, (viewport.Y - height) * 0.5)))
        local controls = {fitButton, followButton, timersButton, minusButton, plusButton}
        local controlWidth = (width - 40) / #controls
        for index, control in ipairs(controls) do
            control.Size = UDim2.fromOffset(controlWidth, touch and 42 or 32)
            control.Position = UDim2.fromOffset(12 + (index - 1) * (controlWidth + 4), 60)
            control.TextSize = controlWidth < 65 and 10 or 12
        end
        closeButton.Size = UDim2.fromOffset(touch and 42 or 30, touch and 42 or 32)
        closeButton.Position = UDim2.new(1, touch and -50 or -42, 0, 6)
        local compact = height < 430
        local canvasTop = touch and 110 or 104
        local footerHeight = compact and 108 or 130
        canvas.Position = UDim2.fromOffset(12, canvasTop)
        canvas.Size = UDim2.new(1, -24, 1, -canvasTop - footerHeight)
        legend.Visible = not compact
        legend2.Position = UDim2.new(0, 14, 1, compact and -98 or -102)
        help.Position = UDim2.new(0, 14, 1, compact and -78 or -81)
        details.Position = UDim2.new(0, 14, 1, -58)
        details.TextSize = compact and 11 or 12
        panel.Visible = not (touch and frame.Visible)
        dirty = true
    end
    local function render()
        local _, root = parts()
        local now, size = workspace:GetServerTimeNow(), canvas.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then return end
        if not initialized or (#records ~= fittedRecordCount and os.clock() < autoFitUntil) then
            fit()
            fittedRecordCount = #records
        end
        if follow and root then center = flat(root.Position) end
        local targets = {}
        for _, record in ipairs(currentTargetRecords or {}) do targets[record] = true end
        local groups, bins = {}, {}
        local ready, expected, respawning, omitted, visible = 0, 0, 0, 0, 0
        for _, record in ipairs(records) do
            if not isInRange(record.position, root) then omitted += 1; continue end
            local state, p = status(record, now), project(record.position)
            if state == "ready" then ready += 1 elseif state == "remembered" then expected += 1
            elseif state == "predicted" then respawning += 1 end
            local markerInset = inputService.TouchEnabled and 19 or 14
            if p.X < markerInset or p.Y < 26 or p.X > size.X - markerInset or p.Y > size.Y - markerInset then continue end
            visible += 1
            local spacing = inputService.TouchEnabled and 42 or 30
            local bx, by = math.floor(p.X / spacing), math.floor(p.Y / spacing)
            local group
            for x = bx - 1, bx + 1 do
                for y = by - 1, by + 1 do
                    for _, candidate in ipairs(bins[x .. ":" .. y] or {}) do
                        if (candidate.point - p).Magnitude < spacing then group = candidate; break end
                    end
                    if group then break end
                end
                if group then break end
            end
            if not group then
                group = {point = p, world = Vector2.zero, records = {}, ready = 0, target = false, state = state}
                table.insert(groups, group)
                local key = bx .. ":" .. by
                bins[key] = bins[key] or {}
                table.insert(bins[key], group)
            end
            table.insert(group.records, record)
            group.world += flat(record.position)
            group.target = group.target or targets[record] == true
            if state == "ready" then group.ready += 1; group.state = "ready" end
            if state == "remembered" and group.ready == 0 then group.state = "remembered" end
            if state == "predicted" then
                group.remaining = math.min(group.remaining or math.huge, record.readyAt - now)
                if group.ready == 0 and group.state ~= "remembered" then group.state = "predicted" end
            end
        end
        -- A world-aligned grid and distance key give scale without inventing terrain.
        local rawStep = 70 / pixelsPerStud
        local power = 10 ^ math.floor(math.log10(rawStep))
        local step = math.ceil(rawStep / power) * power
        local topLeft = unproject(Vector2.zero)
        local gridCount = 0
        local function gridLine(position, dimensions)
            gridCount += 1
            local item = gridPool[gridCount]
            if not item then
                item = Instance.new("Frame")
                item.BackgroundColor3, item.BorderSizePixel, item.ZIndex, item.Parent = Color3.fromRGB(36, 46, 61), 0, 1, canvas
                gridPool[gridCount] = item
            end
            item.Position, item.Size, item.Visible = position, dimensions, true
        end
        local firstX = (math.ceil(topLeft.X / step) * step - topLeft.X) * pixelsPerStud
        local firstY = (topLeft.Y - math.floor(topLeft.Y / step) * step) * pixelsPerStud
        for x = firstX, size.X, step * pixelsPerStud do gridLine(UDim2.fromOffset(x, 0), UDim2.fromOffset(1, size.Y)) end
        for y = firstY, size.Y, step * pixelsPerStud do gridLine(UDim2.fromOffset(0, y), UDim2.fromOffset(size.X, 1)) end
        for i = gridCount + 1, #gridPool do gridPool[i].Visible = false end
        local route = liveNavigation.plan and liveNavigation.plan.route or {}
        scaleLabel.Text = string.format("+Z ↑ · grid %s · purple: lookahead · cyan: current · gold: next", tostring(step))
        local segmentCount = math.max(0, #route - 1)
        local createdSegments = 0
        for index = 1, segmentCount do
            local segment = lookaheadLines[index]
            if not segment then
                if createdSegments >= 24 then dirty = true; break end
                segment = line(Color3.fromRGB(180, 115, 255), 2)
                segment.BackgroundTransparency = 0.25
                local direction = text(segment, "▶", 12, Color3.fromRGB(216, 174, 255))
                direction.Name = "Direction"
                direction.AnchorPoint = Vector2.new(0.5, 0.5)
                direction.Position = UDim2.new(0.62, 0, 0.5, 0)
                direction.Size = UDim2.fromOffset(14, 14)
                direction.TextXAlignment = Enum.TextXAlignment.Center
                direction.TextStrokeTransparency = 0.35
                direction.ZIndex = 2
                lookaheadLines[index] = segment
                createdSegments += 1
            end
            local fromStop, toStop = route[index], route[index + 1]
            if isInRange(fromStop.position, root) and isInRange(toStop.position, root) then
                drawLine(segment, project(fromStop.position), project(toStop.position))
            else
                segment.Visible = false
            end
            local direction = segment:FindFirstChild("Direction")
            if direction then direction.Visible = segment.Visible and segment.Size.X.Offset >= 26 end
        end
        for index = segmentCount + 1, #lookaheadLines do lookaheadLines[index].Visible = false end
        -- Place timer labels only in free space; the selected chest always has a detailed countdown below.
        local occupied = {}
        for _, group in ipairs(groups) do
            table.insert(occupied, {group.point.X - 14, group.point.Y - 14, group.point.X + 14, group.point.Y + 14})
        end
        for i, group in ipairs(groups) do
            local item = markerPool[i]
            if not item then item = newMarker(); markerPool[i] = item end
            item.group = group
            local b, p = item.button, group.point
            b.Visible, b.Position = true, UDim2.fromOffset(p.X, p.Y)
            b.BackgroundColor3 = colors[group.state]
            b.Text = #group.records > 1 and tostring(#group.records) or gradeOf(group.records[1]):sub(1, 1)
            item.stroke.Color = group.target and colors.target or (selected and table.find(group.records, selected) and light or Color3.fromRGB(15, 22, 32))
            item.stroke.Thickness = group.target and 3 or 2
            item.timer.Visible = false
            if timers and group.remaining then
                for _, offset in ipairs({Vector2.new(-26, -34), Vector2.new(-26, 16), Vector2.new(16, -9), Vector2.new(-68, -9)}) do
                    local origin = p + offset
                    local rect = {origin.X, origin.Y, origin.X + 52, origin.Y + 18}
                    local free = rect[1] >= 0 and rect[2] >= 24 and rect[3] <= size.X and rect[4] <= size.Y
                    if free then
                        for _, other in ipairs(occupied) do
                            if rect[1] < other[3] and rect[3] > other[1] and rect[2] < other[4] and rect[4] > other[2] then free = false; break end
                        end
                    end
                    if free then
                        item.timer.Position = UDim2.fromOffset(origin.X, origin.Y)
                        item.timer.Text = "~" .. countdown(group.remaining)
                        item.timer.Visible = true
                        table.insert(occupied, rect)
                        break
                    end
                end
            end
        end
        for i = #groups + 1, #markerPool do markerPool[i].button.Visible = false; markerPool[i].timer.Visible = false end
        local dealerCount = 0
        for _, dealer in ipairs(dealerList) do
            if dealer.instance and isInRange(dealer.position, root) then
                local p = project(dealer.position)
                if p.X >= 12 and p.Y >= 24 and p.X <= size.X - 12 and p.Y <= size.Y - 12 then
                    dealerCount += 1
                    local item = dealerPool[dealerCount]
                    if not item then
                        item = text(canvas, "◆", 19, colors.dealer)
                        item.AnchorPoint, item.Size, item.ZIndex = Vector2.new(0.5, 0.5), UDim2.fromOffset(20, 20), 3
                        item.TextXAlignment = Enum.TextXAlignment.Center
                        dealerPool[dealerCount] = item
                    end
                    item.Position, item.Visible = UDim2.fromOffset(p.X, p.Y), true
                end
            end
        end
        for i = dealerCount + 1, #dealerPool do dealerPool[i].Visible = false end
        playerDot.Visible = root ~= nil
        if root then
            local p, look = project(root.Position), root.CFrame.LookVector
            playerDot.Position = UDim2.fromOffset(p.X, p.Y)
            playerDot.Rotation = math.deg(math.atan2(look.X, look.Z))
        end
        drawLine(routeLine, root and project(root.Position), currentRouteDestination and project(currentRouteDestination))
        drawLine(nextLine, currentTargetBoxCenter and project(currentTargetBoxCenter), currentNextRoutePosition and project(currentNextRoutePosition))
        subtitle.Text = string.format("%d live · %d expected · %d cooling · %d far hidden", ready, expected, respawning, omitted)
        help.Text = string.format("%d in view · Drag to pan · Tap groups to zoom · S/G/D = grade", visible)
        if selected then
            local state = status(selected, now)
            local reward = economyOf(selected).rewards[REWARD_SEA]
            local distance = root and (selected.position - root.Position).Magnitude or 0
            if selectedGroup and #selectedGroup > 1 then
                local groupReady, value = 0, 0
                for _, record in ipairs(selectedGroup) do
                    if status(record, now) == "ready" then groupReady += 1 end
                    local range = economyOf(record).rewards[REWARD_SEA]
                    value += (range[1] + range[2]) * 0.5
                end
                local hint = pixelsPerStud >= 4 and "Tap the group again to inspect each overlapping chest."
                    or "Zoom in, then tap a letter to inspect a single chest."
                details.Text = string.format("%d chests · %d ready · ~%s total value\n%s", #selectedGroup, groupReady, formatMoney(value), hint)
            else
                local stateText = state == "predicted" and ((selected.initiallyEmptyAt and "Ready by ~" or "Respawn ~") .. countdown(selected.readyAt - now))
                    or state == "remembered" and "Expected ready · unloaded"
                    or state == "unknown" and "Unverified / streamed out"
                    or state == "ready" and "Ready to collect" or "Empty"
                details.Text = string.format("%s · %s · %.0f studs\n%s · %s–%s · %d confirmed pickups",
                    gradeOf(selected), selected.name, distance,
                    stateText, formatMoney(reward[1]), formatMoney(reward[2]), selected.successes or 0)
            end
        else
            local plan = liveNavigation.plan
            if plan then
                details.Text = string.format("Next pass: %d chests · ~%s value\n%d stops ahead · blue = expected while unloaded",
                    #plan.first.records, formatMoney(plan.first.value), #plan.route)
            else
                details.Text = "Locations and states stay in memory when unloaded.\nTap a chest for value, distance and respawn time."
            end
        end
    end

    table.insert(connections, fitButton.Activated:Connect(fit))
    table.insert(connections, followButton.Activated:Connect(function() setFollow(not follow); dirty = true end))
    table.insert(connections, plusButton.Activated:Connect(function() zoom(1.6) end))
    table.insert(connections, minusButton.Activated:Connect(function() zoom(1 / 1.6) end))
    table.insert(connections, timersButton.Activated:Connect(function()
        timers = not timers
        timersButton.Text = timers and "Timers On" or "Timers Off"
        timersButton.BackgroundColor3 = timers and Color3.fromRGB(87, 71, 38) or Color3.fromRGB(38, 47, 62)
        dirty = true
    end))
    local function toggle()
        frame.Visible = not frame.Visible
        panel.Visible = not (inputService.TouchEnabled and frame.Visible)
        mapButton.BackgroundColor3 = frame.Visible and Color3.fromRGB(45, 75, 95) or Color3.fromRGB(55, 60, 70)
        dirty = true
    end
    table.insert(connections, closeButton.Activated:Connect(toggle))
    table.insert(connections, mapButton.Activated:Connect(toggle))
    local dragInput, dragStart, dragCenter, dragged
    local function inside(position)
        local inset = not gui.IgnoreGuiInset and guiService:GetGuiInset() or Vector2.zero
        local p = Vector2.new(position.X, position.Y) - inset - canvas.AbsolutePosition
        return p.X >= 0 and p.Y >= 0 and p.X <= canvas.AbsoluteSize.X and p.Y <= canvas.AbsoluteSize.Y, p
    end
    table.insert(connections, inputService.InputBegan:Connect(function(input)
        if not frame.Visible or not gui.Parent or dragInput then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not inside(input.Position) then return end
        dragInput, dragStart, dragCenter, dragged = input, Vector2.new(input.Position.X, input.Position.Y), center, false
    end))
    table.insert(connections, inputService.InputChanged:Connect(function(input)
        if not frame.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            local hit, p = inside(inputService:GetMouseLocation())
            if hit then zoom(input.Position.Z > 0 and 1.3 or 1 / 1.3, p) end
        elseif dragInput and (input == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)) then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            if delta.Magnitude > 4 then dragged = true end
            if dragged then
                autoFitUntil = 0
                center = dragCenter + Vector2.new(-delta.X, delta.Y) / pixelsPerStud
                suppressClickUntil = os.clock() + 0.25
                setFollow(false)
                dirty = true
            end
        end
    end))
    table.insert(connections, inputService.InputEnded:Connect(function(input)
        if input == dragInput then
            if dragged then suppressClickUntil = os.clock() + 0.25 end
            dragInput = nil
        end
    end))
    layout()
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if stopped or not gui.Parent or not frame.Visible then return end
        layout()
        local now = os.clock()
        if now - lastRefresh < (dirty and 1 / 30 or C.MapRefreshSeconds) then return end
        lastRefresh, dirty = now, false
        render()
    end))
end
installChestMap()


-- TRACERS & GOLD 100x100x100 HITBOX VISUALIZER
local traceParts = {}
if SHOW_ROUTE_TRACERS or SHOW_HITBOX_VISUALIZER then
    local hitboxes = {}
    local function getHitbox(index)
        if hitboxes[index] then return hitboxes[index] end
        local part = Instance.new("Part")
        part.Name = "Hitbox100VisualizerPart"
        part.Size, part.Transparency = HITBOX_SIZE, 1
        part.Anchored = true -- Visual marker only; never anchors the character or boat.
        part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
        part.Parent = workspace.Terrain
        local outline = Instance.new("SelectionBox")
        outline.Name = "Hitbox100GoldOutline"
        outline.Color3 = Color3.fromRGB(255, 215, 0)
        outline.LineThickness, outline.SurfaceTransparency = 0.25, 1
        outline.Adornee, outline.Visible = part, false
        outline.Parent = workspace.Terrain
        local item = {part = part, outline = outline}
        hitboxes[index] = item
        table.insert(traceParts, outline)
        table.insert(traceParts, part)
        return item
    end
    local function makeTracer(name, color)
        local from = Instance.new("Attachment", workspace.Terrain)
        local dest = Instance.new("Attachment", workspace.Terrain)
        local beam = Instance.new("Beam", workspace.Terrain)
        beam.Name = name
        beam.Attachment0, beam.Attachment1 = from, dest
        beam.FaceCamera, beam.Segments = true, 1
        beam.Width0, beam.Width1 = 0.35, 0.35
        beam.Color, beam.Transparency = ColorSequence.new(color), NumberSequence.new(0.2)
        beam.Enabled = false
        table.insert(traceParts, beam)
        table.insert(traceParts, from)
        table.insert(traceParts, dest)
        return {from = from, dest = dest, beam = beam}
    end
    local currentTrace = SHOW_ROUTE_TRACERS and makeTracer("FarmRouteCurrent", Color3.fromRGB(75, 215, 255))
    local nextTrace = SHOW_ROUTE_TRACERS and makeTracer("FarmRouteNext", Color3.fromRGB(255, 210, 95))
    local function updateTracer(tracer, from, dest)
        if not tracer then return end
        tracer.beam.Enabled = from ~= nil and dest ~= nil
        if tracer.beam.Enabled then
            tracer.from.WorldPosition, tracer.dest.WorldPosition = from, dest
        end
    end
    table.insert(connections, RunService.RenderStepped:Connect(function()
        local _, root = parts()
        local count = 0
        local function showHitbox(frame)
            count += 1
            local item = getHitbox(count)
            if item.part.CFrame ~= frame then item.part.CFrame = frame end
            item.outline.Visible = true
        end
        if not stopped and root and SHOW_HITBOX_VISUALIZER then
            -- Draw each real chest in the pass, including cached geometry when unloaded.
            for _, record in ipairs(currentTargetRecords or {}) do
                local trigger = loadedTrigger(record)
                local frame = trigger and trigger.CFrame or (record.geometry and record.geometry.cframe)
                if frame then showHitbox(frame) end
            end
            if count == 0 and currentTargetBoxCenter then showHitbox(CFrame.new(currentTargetBoxCenter)) end
        end
        for index = count + 1, #hitboxes do hitboxes[index].outline.Visible = false end
        local enabled = not stopped and root ~= nil
        updateTracer(currentTrace, enabled and root.Position or nil, enabled and currentRouteDestination or nil)
        updateTracer(nextTrace, enabled and currentTargetBoxCenter or nil, enabled and currentNextRoutePosition or nil)
    end))
end

-- MAIN FARM LOOP
-- An immediately completed/rejected leg must not restart planning indefinitely in one frame.
local farmFrame = 0
table.insert(connections, RunService.Heartbeat:Connect(function() farmFrame += 1 end))
task.spawn(function()
    local ok, err = xpcall(function()
        display("Preparing chest locations…")
        local startupDeadline = os.clock() + C.CharacterTimeout
        while not stopped and (not initialScanComplete or not game:IsLoaded()) and os.clock() < startupDeadline do
            RunService.Heartbeat:Wait()
        end
        if stopped then return end
        refreshChests(true)
        local startupBalance = readBeli()
        if startupBalance then
            lastPickupBalance = startupBalance
            if startingBeli == nil then
                startingBeli, moneyStarted = startupBalance, workspace:GetServerTimeNow()
            end
        end
        if not initialScanComplete then log("Initial discovery still running; continuing with known spawns") end
        local lastPlanningFrame = -1
        while not stopped do
            if farmFrame == lastPlanningFrame then RunService.Heartbeat:Wait() end
            if stopped then break end
            lastPlanningFrame = farmFrame
            scanDealers()
            refreshChests()
            local _, root = waitCharacter(C.CharacterTimeout)
            if stopped then break end
            if not root then task.wait(0.5); continue end

            -- Resolve Boat or seamless Foot mode
            local boat, seat = getActiveVehicleOrCharacter()
            local currentSpeed = boat and C.BoatSpeed or C.Speed

            liveNavigation.speed = currentSpeed
            if discovery.active then
                local region = chooseDiscovery(root, currentSpeed)
                if region then
                    discoverArea(boat, seat, region)
                    continue
                end
            end
            local plan = choose(root, nil, currentSpeed)
            if not plan then
                liveNavigation.plan = nil
                currentRouteDestination, currentTargetBoxCenter = nil, nil
                currentTargetRecords, currentNextRoutePosition = nil, nil
                display("Watching known chest respawns…")
                pauseFlight()
                task.wait(C.PollSeconds)
                continue
            end
            local node = plan.node
            currentNextRoutePosition = plan.route and plan.route[2] and plan.route[2].position or nil
            display(string.format("%s · %s", boat and "Boat" or "Foot",
                node.isCluster and ("Cluster (" .. node.clusterCount .. " chests)") or node.record.name))

            -- Execute direct 3D flight (auto-adjusts speed and physics based on boat or foot)
            local outcome = flyThroughTarget(boat, seat, node)

            if outcome ~= "arrived" and outcome ~= "unavailable" and outcome ~= "interrupted" and outcome ~= "reroute" then
                for _, record in ipairs(node.records or {node.record}) do
                    record.failures = (record.failures or 0) + 1
                    record.cooldown = workspace:GetServerTimeNow() + 10
                end
            end
        end
    end, debug.traceback)

    stopped = true
    pauseFlight()
    if boatSeatCleanupConnection then boatSeatCleanupConnection:Disconnect() end
    preparedBoat = nil
    if persistentNoclipConn then persistentNoclipConn:Disconnect() end
    restoreFlightCollision()
    if persistentLinearVelocity then persistentLinearVelocity:Destroy() end
    if persistentAttachment then persistentAttachment:Destroy() end
    for _, conn in ipairs(connections) do conn:Disconnect() end
    for _, part in ipairs(traceParts) do part:Destroy() end
    for part, original in pairs(chestOriginals) do
        if part.Parent then
            pcall(function()
                part.Size = original.size
                part.CanCollide = original.canCollide
            end)
        end
    end
    if ok then
        gui:Destroy()
    else
        titleLabel.Text = "Chest Farm · Error"
        statusLabel.Text = "Stopped: check developer console"
        statusLabel.TextColor3 = Color3.fromRGB(255, 130, 130)
    end
    if globalEnvironment.ChestFarmerBoatStop == stop then globalEnvironment.ChestFarmerBoatStop = nil end
    if not ok then warn("[Chest Farmer] " .. tostring(err)) end
end)