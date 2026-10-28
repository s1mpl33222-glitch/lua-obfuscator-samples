local libSrc
do
    local ok, src = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/SoldoxD/libery/refs/heads/main/main") end)
    if not ok then warn("[DE] HttpGet failed:", src); return end
    libSrc = src
end
local libFn, lerr = loadstring(libSrc)
if not libFn then warn("[DE] loadstring failed:", lerr); return end
local lokc, libRet = pcall(libFn)
if not lokc then warn("[DE] running lib failed:", libRet); return end
local GuiLibrary = libRet

-- Re-running this script used to stack a second copy on top of the first:
-- two drive loops both PivotTo-ing the same car, doubled ESP, a second GUI.
-- Every loop below runs only while it is the current generation, and the
-- previous generation's connections and GUI are torn down here.
local GEN
do
    local g = (getgenv and getgenv()) or nil
    if g then
        if g.__DE_CLEANUP then pcall(g.__DE_CLEANUP) end
        g.__DE_GEN = (g.__DE_GEN or 0) + 1
        GEN = g.__DE_GEN
    else
        GEN = 1
    end
end
local function alive()
    local g = (getgenv and getgenv()) or nil
    return (g == nil) or g.__DE_GEN == GEN
end
local _conns = {}
local function track(conn) table.insert(_conns, conn) return conn end

local function _elevate()
    local env = getgenv and getgenv()
    local synApi = env and rawget(env, "syn")
    local s = setthreadidentity or (synApi and synApi.set_thread_identity) or setidentity
    if s then pcall(s, 8) end
end

do
    local _orig = GuiLibrary
    local methods = {
        "CreateWindow","CreateTab","CreateSection","CreateLabel","CreateButton",
        "CreateToggle","CreateSlider","CreateDropdown","CreateInput",
        "CreateColorPicker","CreateKeybind","CreateNotification","CreateSettingsTab",
    }
    local wrapped = {}
    for _, m in ipairs(methods) do
        local fn = _orig[m]
        if type(fn) == "function" then
            wrapped[m] = function(self, ...) _elevate() return fn(self, ...) end
        end
    end
    local origCreateLabel = wrapped.CreateLabel
    wrapped.CreateLabel = function(self, ...)
        local ctl = origCreateLabel(self, ...)
        if type(ctl) == "table" then
            local oS, oC, oV = ctl.SetText, ctl.SetColor, ctl.SetVisible
            if oS then ctl.SetText    = function(t) _elevate() return oS(t) end end
            if oC then ctl.SetColor   = function(c) _elevate() return oC(c) end end
            if oV then ctl.SetVisible = function(v) _elevate() return oV(v) end end
        end
        return ctl
    end
    GuiLibrary = setmetatable(wrapped, { __index = _orig })
end

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local UserInputService  = game:GetService("UserInputService")
local LocalPlayer       = Players.LocalPlayer

local function getModule(...)
    local node = ReplicatedStorage
    for _, name in ipairs({...}) do
        node = node:WaitForChild(name, 30)
        if not node then return nil end
    end
    local ok, m = pcall(require, node)
    return ok and m or nil
end

local Remotes           = getModule("Modules", "Shared", "Remotes")
local CriminalConstants = getModule("Modules", "Shared", "Jobs", "Criminal", "CriminalConstants")
local CriminalUtil      = getModule("Modules", "Shared", "Jobs", "Criminal", "CriminalUtil")
local HeistController   = getModule("Modules", "Client", "Heists", "HeistController")
local HeistRemoteConfig = getModule("Modules", "Shared", "Heists", "HeistRemoteConfig")
local SecurityConstants = getModule("Modules", "Shared", "Jobs", "Security", "SecurityConstants")
local SecurityUtil      = getModule("Modules", "Shared", "Jobs", "Security", "SecurityUtil")
local DeliveryJobTask   = getModule("Modules", "Client", "Jobs", "Tasks", "DeliveryJobTask")
local VehicleController = getModule("Modules", "Client", "Vehicles", "VehicleController")
local VehicleUtil       = getModule("Modules", "Shared", "Vehicles", "VehicleUtil")
local VehicleData       = getModule("Modules", "Shared", "DataManager", "Data", "VehicleData")
local PlayerData        = getModule("Modules", "Shared", "Data")

local function fireRemoteEvent(name, ...)
    local args = table.pack(...)
    local ok = pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild(name):FireServer(table.unpack(args, 1, args.n))
    end)
    return ok
end
local function invokeRemoteFunction(name, ...)
    local args = table.pack(...)
    local ok, a, b = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild(name):InvokeServer(table.unpack(args, 1, args.n))
    end)
    if not ok then return false, a end
    return a, b
end

local function notify(title, msg, dur, kind)
    GuiLibrary:CreateNotification(title, msg, dur or 3, kind or "info")
end

do
    local ok, VirtualUser = pcall(game.GetService, game, "VirtualUser")
    if ok and VirtualUser then
        pcall(function()
            LocalPlayer.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end)
        end)
    end
end

local FastLoad = { Enabled = false }
local function killLoadingScreens()
    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, g in ipairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") then
                local n = g.Name:lower()
                if n:find("loading") or g:FindFirstChild("Loading") then
                    pcall(function() g.Enabled = false end)
                end
            end
        end
    end
end
task.spawn(function()
    while alive() do
        task.wait(0.25)
        if FastLoad.Enabled then pcall(killLoadingScreens) end
    end
end)

local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function isInSeat()
    local h = getHumanoid()
    return h ~= nil and h.SeatPart ~= nil
end
local function tp(cf)
    local h = getHRP()
    if h then h.CFrame = cf end
end

local function inHeistNow()
    return HeistController and HeistController.IsLocalPlayerInHeist
        and HeistController.IsLocalPlayerInHeist() or false
end

local function getStars()
    local c = LocalPlayer.Character
    if not c then return 0 end
    return math.min(5, math.max(0, c:GetAttribute("CrimesCommitted") or 0))
end
local function isWanted()
    local c = LocalPlayer.Character
    if not c then return false end
    local exp = c:GetAttribute("CriminalExpireEpoch") or 0
    return exp ~= 0 and os.time() < exp
end
local function hasATMBustDebounce()
    local c = LocalPlayer.Character
    return c and c:GetAttribute("ATMBustDebounce") ~= nil
end
local function hasArrestDebounce()
    local c = LocalPlayer.Character
    return c and c:GetAttribute("ArrestDebounce") ~= nil
end
local function waitForBustDebounceClear(maxWait)
    local stop = tick() + (maxWait or 6)
    while hasATMBustDebounce() and tick() < stop do task.wait(0.1) end
    return not hasATMBustDebounce()
end
local function playerHasAnyBag()
    if CriminalUtil and CriminalUtil.PlayerHasMoneyBag then
        local ok, has = pcall(CriminalUtil.PlayerHasMoneyBag, LocalPlayer)
        if ok then return has end
    end
    local function scan(p)
        if not p then return false end
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("Tool") and c.Name == "CriminalMoneyBag" then return true end
        end
        return false
    end
    return scan(LocalPlayer.Character) or scan(LocalPlayer:FindFirstChild("Backpack"))
end
local function waitForBagsCleared(maxWait)
    local stop = tick() + (maxWait or 10)
    while playerHasAnyBag() and tick() < stop do task.wait(0.1) end
    return not playerHasAnyBag()
end
local function parseAmount(s)
    if not s then return nil end
    s = tostring(s):gsub("[%s,_$]", ""):lower()
    if s == "" then return nil end
    local num, suffix = s:match("^([%d%.]+)([kmb]?)$")
    if not num then return nil end
    num = tonumber(num)
    if not num then return nil end
    local mult = ({ k = 1e3, m = 1e6, b = 1e9 })[suffix] or 1
    return num * mult
end

local function getCurrentBagValue()
    if CriminalUtil and CriminalUtil.GetAllMoneyBagsValue then
        local ok, v = pcall(CriminalUtil.GetAllMoneyBagsValue, LocalPlayer)
        if ok then return v or 0 end
    end
    return 0
end

local function countMoneyBags()
    if CriminalUtil and CriminalUtil.GetAllMoneyBags then
        local ok, bags = pcall(CriminalUtil.GetAllMoneyBags, LocalPlayer)
        if ok and type(bags) == "table" then return #bags end
    end
    local n = 0
    local function scan(p)
        if not p then return end
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("Tool") and c.Name == "CriminalMoneyBag" then n = n + 1 end
        end
    end
    scan(LocalPlayer.Character)
    scan(LocalPlayer:FindFirstChild("Backpack"))
    return n
end

local function checkDropoffRequirements()
    if (LocalPlayer:GetAttribute("JobId") or "") ~= "Criminal" then
        return false, "Not on the Criminal job"
    end
    if not playerHasAnyBag() then
        return false, "No money bags to deposit"
    end
    if getStars() < 5 then
        return false, ("Need 5 stars (have %d)"):format(getStars())
    end
    if hasArrestDebounce() then
        return false, "Arrest debounce active"
    end
    return true
end

local function startJobSession(jobId)
    pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestStartJobSession")
            :FireServer(jobId, "jobPad")
    end)
end
local function joinCriminalJob() startJobSession("Criminal") end
local function joinDeliveryJob() startJobSession("Delivery") end

local function requestStreamAround(pos)
    task.spawn(function()
        pcall(function()
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(pos, 1)
            end
        end)
    end)
    return true
end

--=====================================================================
--  RoadNav
--  Builds a road graph out of the LIVE game, every session.
--  There are no hardcoded coordinates anywhere in here: if the devs
--  move, add or delete roads, the graph just comes out different next
--  time it is built. Road pieces keep their Model pivot even while
--  streamed out, so the whole network is visible from anywhere on the
--  map without waiting for geometry to load in.
--=====================================================================
local RoadNav = {
    Nodes    = {},          -- { [i] = { p = Vector3, ax = Vector3 } }
    Grid     = {},          -- "cx,cz" -> { node indices }
    CellSize = 200,
    Built    = false,
    BuiltAt  = 0,
    Sources  = 0,           -- how many containers we pulled from
    Building = false,
    SeenParts = setmetatable({}, { __mode = "k" }),
    Generation = 0,         -- bumped on Build; node indices change with it
    LastHarvest = 0,
    HarvestRadius = 800,
    HarvestEvery  = 3,      -- seconds between local part sweeps
}

-- A container counts as a road folder when its name ENDS in road/roads.
-- Matches: "Roads", "New_Roads", "TEMP DEALERSHIP ROADS".
-- Skips:   "OffroadingIsland", "OffRoadingPropsBoxes", "Railway".
local function looksLikeRoadFolder(name)
    return name:lower():match("roads?$") ~= nil
end

-- Whole containers that end in "roads" but are not through-roads. The
-- dealership forecourt is the big one -- it is named "TEMP DEALERSHIP ROADS"
-- and is a car park, so the graph used to route straight through it.
local ROAD_CONTAINER_REJECT = {
    "parking", "dealership", "lot", "yard", "plaza", "driveway", "garage",
    "forecourt", "showroom",
}

-- Structure and scenery that lives inside the road folders but is not tarmac.
local ROAD_NAME_REJECT = {
    "rail", "support", "brace", "sign", "light", "pole", "fence", "barrier",
    "guardrail", "lamp", "cone", "prop", "billboard", "bush", "tree", "rock",
    "curb", "sidewalk", "wall", "lod", "line", "arrow", "marking", "decal",
    "parking", "grass", "flag", "stop", "bench", "hydrant",
}

local function matchesAny(name, list)
    local n = name:lower()
    for _, bad in ipairs(list) do
        if n:find(bad, 1, true) then return true end
    end
    return false
end

local function nameIsRejected(name)
    return matchesAny(name, ROAD_NAME_REJECT)
end

local function containerIsRejected(name)
    return matchesAny(name, ROAD_CONTAINER_REJECT)
end

local function flatUnit(v)
    local f = Vector3.new(v.X, 0, v.Z)
    if f.Magnitude < 1e-4 then return nil end
    return f.Unit
end

-- Model:GetPivot() works on streamed-out models as long as WorldPivot was
-- authored, which is the case for every road piece in this map.
local function pivotOf(inst)
    local ok, cf = pcall(function() return inst:GetPivot() end)
    if not ok or typeof(cf) ~= "CFrame" then return nil end
    local p = cf.Position
    if p.Magnitude < 1 then return nil end              -- pivot never set
    if p.Y < -500 or p.Y > 2000 then return nil end     -- underground / skybox junk
    return cf
end

local function findRoadContainers()
    local out, seen = {}, {}
    local function consider(inst)
        if seen[inst] then return end
        if looksLikeRoadFolder(inst.Name) and not containerIsRejected(inst.Name) then
            seen[inst] = true
            table.insert(out, inst)
        end
    end

    local roots = { Workspace }
    local map = Workspace:FindFirstChild("Map")
    if map then
        table.insert(roots, map)
        local inner = map:FindFirstChild("Map")   -- some builds nest Map.Map
        if inner then table.insert(roots, inner) end
    end

    for _, root in ipairs(roots) do
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                consider(child)
                -- one level deeper, for things like Map/House_Update/New_Roads
                if child:IsA("Folder") and not looksLikeRoadFolder(child.Name) then
                    for _, gchild in ipairs(child:GetChildren()) do
                        if gchild:IsA("Folder") then consider(gchild) end
                    end
                end
            end
        end
    end
    return out
end

local function harvestNodes(container, nodes)
    local function take(inst)
        if nameIsRejected(inst.Name) then return end
        local cf = pivotOf(inst)
        if not cf then return end
        -- Road pieces are laid out along their local X, so RightVector is the
        -- direction of travel. Only used as a hint; routing works off geometry.
        table.insert(nodes, { p = cf.Position, ax = flatUnit(cf.RightVector) })
    end

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            take(child)
        elseif child:IsA("Folder") and not nameIsRejected(child.Name) then
            for _, gchild in ipairs(child:GetChildren()) do
                if gchild:IsA("Model") or gchild:IsA("BasePart") then take(gchild) end
            end
        end
    end
end

local function gridKey(x, z)
    return math.floor(x / RoadNav.CellSize) .. "," .. math.floor(z / RoadNav.CellSize)
end

function RoadNav.Build()
    if RoadNav.Building then return RoadNav.Built end
    RoadNav.Building = true

    local nodes = {}
    local containers = findRoadContainers()
    for _, c in ipairs(containers) do
        pcall(harvestNodes, c, nodes)
    end

    -- Last resort: anything the game tagged as a road.
    if #nodes < 40 then
        for _, tag in ipairs({ "Road", "RoadSegment", "RoadPiece" }) do
            local ok, tagged = pcall(function() return CollectionService:GetTagged(tag) end)
            if ok and tagged then
                for _, inst in ipairs(tagged) do
                    local cf = pivotOf(inst)
                    if cf then table.insert(nodes, { p = cf.Position, ax = flatUnit(cf.RightVector) }) end
                end
            end
        end
    end

    local grid = {}
    for i, n in ipairs(nodes) do
        local k = gridKey(n.p.X, n.p.Z)
        local bucket = grid[k]
        if not bucket then bucket = {}; grid[k] = bucket end
        table.insert(bucket, i)
    end

    RoadNav.Nodes    = nodes
    RoadNav.Grid     = grid
    RoadNav.SeenParts = setmetatable({}, { __mode = "k" })
    RoadNav.Generation = (RoadNav.Generation or 0) + 1
    RoadNav.Sources  = #containers
    RoadNav.Built    = #nodes >= 20
    RoadNav.BuiltAt  = tick()
    RoadNav.Building = false
    return RoadNav.Built
end

-- Add one node and index it. Used by both harvest passes.
function RoadNav.AddNode(pos, ax)
    table.insert(RoadNav.Nodes, { p = pos, ax = ax })
    local k = gridKey(pos.X, pos.Z)
    local bucket = RoadNav.Grid[k]
    if not bucket then bucket = {}; RoadNav.Grid[k] = bucket end
    table.insert(bucket, #RoadNav.Nodes)
end

-- The model-pivot pass only sees folders named "...Roads", which misses whole
-- districts -- the entire city road network lives in NewMapAdditions. Those
-- roads are ordinary Asphalt parts, so sweep up whatever is streamed in around
-- us and lay nodes along each one. Streamed-out parts are invisible here, which
-- is fine: this only ever needs to cover the ground we are actually driving on,
-- and the pivot pass still provides the long-range skeleton.
function RoadNav.HarvestNearby(pos, radius, ignore)
    if #RoadNav.Nodes > 60000 then return 0 end   -- long session guard
    local op = OverlapParams.new()
    op.FilterType = Enum.RaycastFilterType.Exclude
    op.FilterDescendantsInstances = ignore or {}
    op.MaxParts = 12000
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(pos, radius or 800, op)
    end)
    if not ok or not parts then return 0 end

    local added = 0
    for _, part in ipairs(parts) do
        if not RoadNav.SeenParts[part] then
            local isRoad = part.Material == Enum.Material.Asphalt
                or (part.Name:lower():find("road", 1, true) ~= nil
                    and not nameIsRejected(part.Name))
            if isRoad and part.Size.X >= 8 and part.Size.Z >= 8 then
                RoadNav.SeenParts[part] = true
                local sx, sz = part.Size.X, part.Size.Z
                local long = math.max(sx, sz)
                local axis = (sx >= sz) and part.CFrame.RightVector or part.CFrame.LookVector
                local surfaceY = part.Position.Y + part.Size.Y / 2
                local count = math.clamp(math.floor(long / 60), 1, 24)
                local flatAx = flatUnit(axis)
                for i = 1, count do
                    -- spread the samples evenly down the middle of the slab
                    local t = (count == 1) and 0 or ((i - 1) / (count - 1) - 0.5)
                    local p = part.Position + axis * (long * t * 0.92)
                    RoadNav.AddNode(Vector3.new(p.X, surfaceY, p.Z), flatAx)
                    added = added + 1
                end
            end
        end
    end
    return added
end

-- Every node index inside `radius` studs of pos (square-ish, grid based).
function RoadNav.Query(pos, radius)
    local out = {}
    local span = math.ceil(radius / RoadNav.CellSize)
    local cx = math.floor(pos.X / RoadNav.CellSize)
    local cz = math.floor(pos.Z / RoadNav.CellSize)
    for dx = -span, span do
        for dz = -span, span do
            local bucket = RoadNav.Grid[(cx + dx) .. "," .. (cz + dz)]
            if bucket then
                for _, i in ipairs(bucket) do table.insert(out, i) end
            end
        end
    end
    return out
end

function RoadNav.Nearest(pos, maxRadius)
    local best, bestD
    local radius = 250
    while radius <= (maxRadius or 4000) do
        for _, i in ipairs(RoadNav.Query(pos, radius)) do
            local d = (RoadNav.Nodes[i].p - pos).Magnitude
            if not bestD or d < bestD then best, bestD = i, d end
        end
        if best then return best, bestD end
        radius = radius * 2
    end
    return nil
end

--=====================================================================
--  Router
--  Walks the graph forever without repeating itself much. Picks the
--  neighbour that best continues the current heading, penalising nodes
--  it visited recently so it keeps exploring instead of ping-ponging
--  between two pieces of road.
--=====================================================================
local Router = {
    Node      = nil,
    Graph     = -1,       -- RoadNav.Generation these indices belong to
    Heading   = Vector3.new(0, 0, -1),
    Radius    = 450,      -- outermost look-ahead for the next node
    MinStep   = 15,       -- ignore nodes basically on top of us
    YTolerance = 18,      -- keeps us off overpasses stacked above/below

    -- Nearest rung first, so we track the road piece by piece and only stride
    -- across a gap when the graph really has one.
    Ladder    = { 120, 200, 320, 450 },

    -- How far off the current heading still counts as "the same road". Roads
    -- bend, so this is deliberately generous: a run should survive a curve and
    -- only end at a real junction or a dead end.
    SameRoadCone = 0.80,      -- cos(37 deg)
    BendCone     = 0.62,      -- cos(52 deg): a sharp bend is still one road

    -- The sharpest turn we will take at a junction. Anything beyond this is a
    -- U-turn, and we only ever do those when there is genuinely nothing else.
    TurnCone     = -0.50,     -- cos(120 deg)

    -- When a run ends we look ahead down each option and take whichever leads
    -- onto the longest stretch of road.
    Lookahead       = 16,
    PotentialWeight = 0.05,
    SpurPenalty     = 8.0,    -- heavy nudge away from short dead-end stubs
    SpurLength      = 250,

    VisitPenalty = 4.0,
    -- 300 nodes was only ~100 seconds of memory at speed, after which the
    -- router forgot its own tracks and could settle into a loop.
    RecentMax = 4000,
    Recent    = {},       -- ring buffer of indices
    RecentAt  = 1,
    Visits    = {},       -- index -> count still inside the ring buffer
    Seen      = {},       -- index -> lifetime count, never forgotten
    SeenPenalty = 0.6,    -- gentle, lasting bias towards roads we have not driven
    SeenCap     = 8,

    RunStuds  = 0,        -- length of the stretch we are currently driving
    Validate  = nil,      -- optional (fromPos, toPos) -> bool road check
    NoUTurn   = true,     -- refuse reversals; the driver clears this at a real dead end
}

-- Clears only the short-term ring. Router.Seen deliberately survives, so that
-- re-anchoring after a coast or a teleport does not wipe the knowledge of which
-- roads we have already driven.
function Router.Forget()
    Router.Recent = {}
    Router.RecentAt = 1
    Router.Visits = {}
    Router.RunStuds = 0
end

local function markVisited(i)
    local ring = Router.Recent
    local slot = Router.RecentAt
    local old = ring[slot]
    if old then
        Router.Visits[old] = (Router.Visits[old] or 1) - 1
        if Router.Visits[old] <= 0 then Router.Visits[old] = nil end
    end
    ring[slot] = i
    Router.Visits[i] = (Router.Visits[i] or 0) + 1
    Router.Seen[i] = math.min((Router.Seen[i] or 0) + 1, Router.SeenCap)
    Router.RecentAt = (slot % Router.RecentMax) + 1
end

-- Anchor the router at whatever node is closest to `pos`, heading `dir`.
function Router.Reset(pos, dir)
    if not RoadNav.Built then return false end
    -- A rebuilt graph renumbers everything, so the lifetime counts no longer
    -- refer to the roads we think they do.
    if Router.Graph ~= RoadNav.Generation then
        Router.Seen = {}
        Router.Graph = RoadNav.Generation
    end
    local i = RoadNav.Nearest(pos)
    if not i then return false end
    Router.Node = i
    Router.Heading = flatUnit(dir or Vector3.new(0, 0, -1)) or Vector3.new(0, 0, -1)
    Router.Forget()
    markVisited(i)
    return true
end

-- Every node within `radius` of `from` that sits at least `cone` off `heading`.
-- Returns an array of { index, dir, dist }.
function Router.Neighbours(fromIdx, radius, cone, heading, skip)
    local here = RoadNav.Nodes[fromIdx]
    local out = {}
    if not here then return out end
    for _, j in ipairs(RoadNav.Query(here.p, radius)) do
        if j ~= fromIdx and not (skip and skip[j]) then
            local n = RoadNav.Nodes[j]
            if math.abs(n.p.Y - here.p.Y) <= Router.YTolerance then
                local delta = n.p - here.p
                local dist = Vector3.new(delta.X, 0, delta.Z).Magnitude
                if dist >= Router.MinStep and dist <= radius then
                    local dir = flatUnit(delta)
                    if dir and (not heading or heading:Dot(dir) >= cone) then
                        table.insert(out, { index = j, dir = dir, dist = dist })
                    end
                end
            end
        end
    end
    return out
end

-- Carry on down the road we are already on. No visit penalty here on purpose:
-- once we commit to a stretch we drive it to the end rather than turning off
-- halfway because we have been down it before.
function Router.ContinueRun(fromIdx, heading, skip)
    -- Straight-on first; then one wider sweep, because a sharp bend in a road
    -- is still the same road and ending the run there was costing us a whole
    -- junction decision (and sometimes a U-turn) mid-highway.
    for _, cone in ipairs({ Router.SameRoadCone, Router.BendCone }) do
        for _, radius in ipairs(Router.Ladder) do
            local best, bestScore
            for _, c in ipairs(Router.Neighbours(fromIdx, radius, cone, heading, skip)) do
                local score = heading:Dot(c.dir) * 4.0 - (c.dist / radius) * 0.3
                if not bestScore or score > bestScore then best, bestScore = c, score end
            end
            if best then return best end
        end
    end
    return nil
end

-- Rough length of road available if we head off in this direction.
function Router.RunPotential(fromIdx, heading)
    local cur, head, total = fromIdx, heading, 0
    for _ = 1, Router.Lookahead do
        local step = Router.ContinueRun(cur, head)
        if not step then break end
        total = total + step.dist
        head = flatUnit(step.dir * 0.7 + head * 0.3) or step.dir
        cur = step.index
    end
    return total
end

-- The road ran out. Pick the turn that opens onto the longest new stretch.
function Router.PickTurn(fromIdx, heading, skip)
    for _, radius in ipairs(Router.Ladder) do
        local best, bestScore
        for _, c in ipairs(Router.Neighbours(fromIdx, radius, Router.TurnCone, heading, skip)) do
            local potential = Router.RunPotential(c.index, c.dir)
            local score = potential * Router.PotentialWeight
                + heading:Dot(c.dir) * 1.5
                - (Router.Visits[c.index] or 0) * Router.VisitPenalty
                - (Router.Seen[c.index] or 0) * Router.SeenPenalty
                - (c.dist / radius) * 0.3
                + math.random() * 0.05
            if potential < Router.SpurLength then
                score = score - Router.SpurPenalty
            end
            if not bestScore or score > bestScore then best, bestScore = c, score end
        end
        if best then return best end
    end
    return nil
end

-- Returns the next node index, or nil when the graph has nothing to offer.
function Router.Next()
    if not Router.Node then return nil end
    local here = RoadNav.Nodes[Router.Node]
    if not here then return nil end

    local skip = nil
    local choice, turned
    local firstChoice, firstTurned   -- best guess before the road check vetoed it

    -- Up to a few goes, in case the road check rejects a leg that would have
    -- taken us through a building.
    for _ = 1, 3 do
        turned = false
        choice = Router.ContinueRun(Router.Node, Router.Heading, skip)
        if not choice then
            choice = Router.PickTurn(Router.Node, Router.Heading, skip)
            turned = true
        end
        if not choice then break end
        if not firstChoice then firstChoice, firstTurned = choice, turned end
        if not Router.Validate then break end
        if Router.Validate(here.p, RoadNav.Nodes[choice.index].p) then break end
        skip = skip or {}
        skip[choice.index] = true
        choice = nil
    end

    -- The road check is advisory. If it vetoed everything we still had real
    -- road ahead, so carry on down it -- turning the car round because a
    -- raycast was unconvinced is far worse than driving a slightly odd leg.
    if not choice and firstChoice then
        choice, turned = firstChoice, firstTurned
    end

    -- Genuine dead end: this is the only place a U-turn can happen.
    if not choice then
        local fallback = Router.Neighbours(Router.Node, Router.Radius * 1.6, -1.0, nil, nil)
        if #fallback == 0 then
            -- Last resort, allow a change of level (ramp on/off an overpass).
            local savedY = Router.YTolerance
            Router.YTolerance = 400
            fallback = Router.Neighbours(Router.Node, Router.Radius * 2, -1.0, nil, nil)
            Router.YTolerance = savedY
        end
        local best, bestDist
        for _, c in ipairs(fallback) do
            if not bestDist or c.dist < bestDist then best, bestDist = c, c.dist end
        end
        if not best then return nil end
        -- Running out of graph usually means the map simply has not streamed in
        -- yet, not that the road ended. Turning round is the wrong answer to
        -- that, so refuse and let the caller coast straight while it loads.
        if Router.NoUTurn and Router.Heading:Dot(best.dir) < -0.35 then
            return nil
        end
        choice, turned = best, true
    end

    if turned then
        Router.RunStuds = choice.dist
    else
        Router.RunStuds = Router.RunStuds + choice.dist
    end

    -- Ease the heading round so corners are taken as a curve, not a snap.
    Router.Heading = flatUnit(choice.dir * 0.7 + Router.Heading * 0.3) or choice.dir
    Router.Node = choice.index
    markVisited(choice.index)
    return choice.index
end

--=====================================================================
--  Vehicle helpers
--=====================================================================
local function getDrivenVehicleModel()
    local hum = getHumanoid()
    local seat = hum and hum.SeatPart
    if not seat or not seat:IsA("VehicleSeat") then return nil, nil end

    local current = seat
    while current do
        if current:IsA("Model") and current:FindFirstChild("Core") then
            return current, seat
        end
        current = current.Parent
    end

    local model = seat:FindFirstAncestorOfClass("Model")
    return model, seat
end

local function getWeightPart(model)
    if not model then return nil end
    return model:FindFirstChild("Weight")
        or model:FindFirstChild("WeightPart")
        or model.PrimaryPart
end

local function getVehicleId(model)
    if not model then return nil end
    local fromAttr = model:GetAttribute("VehicleId")
    if fromAttr then return fromAttr end
    local vo = model:FindFirstChild("VehicleObject")
    if vo and vo:IsA("ObjectValue") and vo.Value then
        return vo.Value.Name
    end
    return nil
end

local function killMomentum(model)
    local wp = getWeightPart(model)
    if wp then
        pcall(function()
            wp.AssemblyLinearVelocity = Vector3.zero
            wp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

-- Each wheel hangs off the chassis on its own suspension, so it is a separate
-- physics assembly. Setting the velocity on the chassis alone leaves the four
-- wheels behind, the suspension constraints snap them back, and the rims jitter.
-- Cache every assembly root once per vehicle so we can move them together.
local _assemblyCache = setmetatable({}, { __mode = "k" })

local function getAssemblyRoots(model)
    local cached = _assemblyCache[model]
    if cached then return cached end
    local roots, seen = {}, {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            local ok, root = pcall(function() return d.AssemblyRootPart end)
            if ok and root and not seen[root] then
                seen[root] = true
                table.insert(roots, root)
            end
        end
    end
    _assemblyCache[model] = roots
    return roots
end

-- The game works out driving pay from how fast the vehicle reports it is
-- going, not from where it has been. A car that is teleported with zero
-- velocity reads as parked and earns nothing, so publish a real speed that
-- matches the distance we are actually covering -- on every assembly, so the
-- wheels travel with the body instead of fighting it.
local function reportDrivingVelocity(model, dir, studsPerSecond)
    if not dir then return end
    local vel = Vector3.new(dir.X * studsPerSecond, 0, dir.Z * studsPerSecond)
    local roots = getAssemblyRoots(model)
    if #roots == 0 then
        local wp = getWeightPart(model)
        if wp then roots = { wp } end
    end
    for _, root in ipairs(roots) do
        if root.Parent then
            pcall(function()
                root.AssemblyLinearVelocity = vel
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
end

local function raycastDown(pos, model, upOffset, dist)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local filter = { model }
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    -- Other people's cars sit on the road and are not road. Without this a
    -- parked stranger reads as "no tarmac here" and the router turns away.
    for _, folderName in ipairs({ "Vehicles", "ClientVehicles", "Bots", "NPCs" }) do
        local f = Workspace:FindFirstChild(folderName)
        if f then table.insert(filter, f) end
    end
    rp.FilterDescendantsInstances = filter
    rp.IgnoreWater = true
    local from = pos + Vector3.new(0, upOffset or 5, 0)
    return Workspace:Raycast(from, Vector3.new(0, -(dist or 500), 0), rp)
end

-- Is what we just hit something a car belongs on? Material first (the main
-- roads are Asphalt), then a name check up the ancestry for everything else.
local DRIVABLE_MATERIALS = {
    [Enum.Material.Asphalt] = true,
    [Enum.Material.Concrete] = true,
    [Enum.Material.Cobblestone] = true,
    [Enum.Material.Pavement] = true,
    [Enum.Material.Metal] = true,      -- bridge decks
    [Enum.Material.DiamondPlate] = true,
}

local function isDrivableSurface(hit)
    if not hit or not hit.Instance then return false end
    if DRIVABLE_MATERIALS[hit.Instance.Material] then return true end
    local node, depth = hit.Instance, 0
    while node and node ~= Workspace and depth < 4 do
        local n = node.Name:lower()
        if n:find("road", 1, true) or n:find("street", 1, true)
            or n:find("bridge", 1, true) or n:find("asphalt", 1, true)
            or n:find("i-10", 1, true) or n:find("route", 1, true) then
            return true
        end
        node = node.Parent
        depth = depth + 1
    end
    return false
end

-- Look straight down, then step sideways until we find tarmac. Returns the
-- lateral offset that lands on road, plus the hit we should ride on.

-- Sweep across the road and work out where the lane is.
--
-- Nodes sit at the CENTRE of a road slab, and a slab is usually the whole
-- carriageway, so following nodes literally puts the car astride the middle
-- line. This measures the drivable span we are standing in and returns the
-- offset that would put us in the right-hand lane instead, along with a hit
-- on the surface there.
local LANE_SCAN_HALF = 78    -- how far either side to look, studs
local LANE_SCAN_STEP = 6

local function findLane(model, pos, right, laneHalfWidth, maxOffset)
    local n = math.floor(LANE_SCAN_HALF / LANE_SCAN_STEP)
    local drivable, hits = {}, {}
    for i = -n, n do
        local off = i * LANE_SCAN_STEP
        local hit = raycastDown(pos + right * off, model, 40, 220)
        drivable[i] = isDrivableSurface(hit)
        hits[i] = hit
    end

    -- the contiguous drivable run we are in, or the nearest one
    local start
    if drivable[0] then
        start = 0
    else
        for d = 1, n do
            if drivable[-d] then start = -d break end
            if drivable[d] then start = d break end
        end
    end
    if not start then return nil, hits[0] end

    local lo, hi = start, start
    while lo - 1 >= -n and drivable[lo - 1] do lo = lo - 1 end
    while hi + 1 <= n and drivable[hi + 1] do hi = hi + 1 end

    local leftEdge  = lo * LANE_SCAN_STEP
    local rightEdge = hi * LANE_SCAN_STEP
    local width = rightEdge - leftEdge

    local centre = (leftEdge + rightEdge) * 0.5
    local target
    if width <= laneHalfWidth * 2.2 then
        target = centre                                -- single lane: sit in it
    else
        -- Keep right, but never wander more than a carriageway from the node
        -- line. On a divided road the sweep sees the far side as drivable too
        -- and would otherwise aim us across the median into oncoming lanes.
        target = math.clamp(rightEdge - laneHalfWidth,
                            math.min(centre, 0),
                            maxOffset or 28)
    end

    local idx = math.clamp(math.floor(target / LANE_SCAN_STEP + 0.5), -n, n)
    return target, hits[idx] or hits[0], width
end

-- Sample along a proposed leg and ask whether there is actually road under it.
-- Streaming means far-away legs report nothing at all, and "nothing" must not
-- count against a leg -- we only reject when we can see solid non-road there,
-- which is what cutting the corner of a building looks like.
local function legLooksDrivable(model, a, b)
    local good, bad = 0, 0
    for i = 1, 4 do
        local hit = raycastDown(a:Lerp(b, i / 5), model, 60, 300)
        if hit then
            if isDrivableSurface(hit) then good = good + 1 else bad = bad + 1 end
        end
    end
    if bad == 0 then return true end
    if good == 0 and bad >= 3 then return false end
    return good >= bad
end

-- Catmull-Rom through four consecutive road nodes, so bends are driven as a
-- curve instead of a chord across the corner.
local function catmullRom(p0, p1, p2, p3, t)
    local t2 = t * t
    local t3 = t2 * t
    return (p1 * 2
        + (p2 - p0) * t
        + (p0 * 2 - p1 * 5 + p2 * 4 - p3) * t2
        + (p1 * 3 - p0 - p2 * 3 + p3) * t3) * 0.5
end

local function teleportEntity(pos, yOff)
    yOff = yOff or 5
    local model = getDrivenVehicleModel()
    if model then
        local ok, pivot = pcall(function() return model:GetPivot() end)
        local rot = ok and pivot and (pivot - pivot.Position) or CFrame.identity
        pcall(function()
            model:PivotTo(rot + (pos + Vector3.new(0, yOff, 0)))
        end)
        killMomentum(model)
        return true
    end
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, yOff, 0)) end
    return false
end

--=====================================================================
--  Car spawning
--  The spawn pad is no longer a hardcoded CFrame -- the car is spawned
--  wherever you are standing, facing down the nearest road.
--=====================================================================
local VEHICLE_REMOTE_PATH = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("VehicleEvent")
local CAR_SPAWN_WAIT      = 3.2

-- Leave empty to auto-detect from what you own.
local MANUAL_BEST_CAR = ""

local GOOD_CARS_PRIORITY = {
    "Bugatti La Voiture Noire",
    "Koenigsegg Jesko",
    "Bugatti Chiron",
    "Rimac Nevera",
    "Pininfarina Battista",
    "Nissan-GTR2017",
}

-- Ask the game itself what you own. VehicleUtil is the module the dealership
-- and inventory UIs use, so this stays correct no matter how the save data is
-- laid out. Note these are vehicle IDs, not showroom display names.
local function listOwnedVehicleIds()
    local ids = {}
    local seen = {}
    local function add(v)
        if type(v) == "string" and v ~= "" and not seen[v] then
            seen[v] = true
            table.insert(ids, v)
        end
    end

    if VehicleUtil and VehicleUtil.getActiveOwnedVehicles then
        local ok, owned = pcall(VehicleUtil.getActiveOwnedVehicles, LocalPlayer)
        if ok and type(owned) == "table" then
            for _, v in ipairs(owned) do add(v) end
        end
    end

    if #ids == 0 and VehicleData and VehicleData.GetOwnedVehicleIds then
        local ok, owned = pcall(VehicleData.GetOwnedVehicleIds, LocalPlayer)
        if ok and type(owned) == "table" then
            for k, v in pairs(owned) do
                add(type(v) == "string" and v or k)
            end
        end
    end

    -- Last resort: the replicated stats folder keeps one child per owned car.
    if #ids == 0 and PlayerData and PlayerData.GetStatsFolderIfLoaded then
        local ok, stats = pcall(PlayerData.GetStatsFolderIfLoaded, LocalPlayer)
        if ok and stats then
            local veh = stats:FindFirstChild("Vehicles")
            if veh then
                for _, child in ipairs(veh:GetChildren()) do add(child.Name) end
            end
        end
    end

    return ids
end

local function GetBestOwnedCar()
    if MANUAL_BEST_CAR and MANUAL_BEST_CAR ~= "" then
        return MANUAL_BEST_CAR
    end

    local owned = listOwnedVehicleIds()
    local ownedSet = {}
    for _, v in ipairs(owned) do ownedSet[v] = true end

    for _, carName in ipairs(GOOD_CARS_PRIORITY) do
        if ownedSet[carName] then return carName end
    end

    -- Whatever you drove last is almost always the one you want.
    if VehicleUtil and VehicleUtil.getLastVehicleSpawned then
        local ok, last = pcall(VehicleUtil.getLastVehicleSpawned, LocalPlayer, "Generic")
        if ok and type(last) == "string" and last ~= "" then return last end
    end

    return owned[1]
end

-- Spawned cars live in Workspace.Vehicles under a model named after their
-- OWNER, with the vehicle id in a CarType StringValue. Matching the car name
-- against the model name therefore never hits, and the old fallback -- nearest
-- unoccupied car -- happily picked whatever stranger had parked next to you.
local function findNearbyVehicle(maxDist, targetCarName)
    local function usable(model)
        if not model or not model:IsA("Model") then return nil end
        if model == LocalPlayer.Character then return nil end
        if not model:FindFirstChild("Core") then return nil end
        local seat = model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChildOfClass("Seat")
        return seat and model or nil
    end

    -- 1. The one named after us. This is our car, full stop.
    for _, folderName in ipairs({ "Vehicles", "ClientVehicles", "Cars", "SpawnedCars" }) do
        local folder = Workspace:FindFirstChild(folderName)
        local mine = folder and folder:FindFirstChild(LocalPlayer.Name)
        if usable(mine) then return mine end
    end

    -- 2. Otherwise something whose CarType is the model we asked for, as long
    --    as it is not named after another player in the server.
    local hrp = getHRP()
    local playerPos = hrp and hrp.Position
    local byType, byTypeDist
    local anyFree, anyFreeDist
    for _, folderName in ipairs({ "Vehicles", "ClientVehicles", "Cars", "SpawnedCars" }) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, model in ipairs(folder:GetChildren()) do
                if usable(model) and not Players:FindFirstChild(model.Name) then
                    local dist = playerPos and (model:GetPivot().Position - playerPos).Magnitude or 0
                    if dist <= (maxDist or 300) then
                        local carType = model:FindFirstChild("CarType")
                        local isTarget = targetCarName and carType and carType.Value
                            and string.lower(tostring(carType.Value)) == string.lower(targetCarName)
                        if isTarget and (not byTypeDist or dist < byTypeDist) then
                            byType, byTypeDist = model, dist
                        end
                        local seat = model:FindFirstChildOfClass("VehicleSeat")
                        if seat and not seat.Occupant and (not anyFreeDist or dist < anyFreeDist) then
                            anyFree, anyFreeDist = model, dist
                        end
                    end
                end
            end
        end
    end
    return byType or anyFree
end

-- Spawns your best car at your current spot, pointing along the road.
local function ensureCarSpawnedAndEntered()
    if getDrivenVehicleModel() then return true end

    local hrp = getHRP()
    if not hrp then
        warn("[DE][Drive] no HumanoidRootPart")
        return false
    end

    local carName = GetBestOwnedCar()
    if not carName then
        warn("[DE][Drive] no owned vehicle found. Hit 'Refresh Vehicle List' on the")
        warn("[DE][Drive] Car tab -- it prints every id it can see -- then pick one")
        warn("[DE][Drive] from the dropdown. Spawning one car by hand once also works.")
        return false
    end

    -- Stand on the nearest road first so the car lands on tarmac instead of
    -- wherever you happened to be. Orientation is irrelevant: AutoDrive
    -- re-aims the car on its first frame.
    if RoadNav.Built then
        local i = RoadNav.Nearest(hrp.Position)
        if i then
            local n = RoadNav.Nodes[i]
            local facing = n.ax or hrp.CFrame.LookVector
            hrp.CFrame = CFrame.lookAt(n.p + Vector3.new(0, 6, 0), n.p + Vector3.new(0, 6, 0) + facing)
            task.wait(0.4)
        end
    end

    pcall(function()
        VEHICLE_REMOTE_PATH:FireServer("Spawn", carName)
    end)

    local car
    local deadline = tick() + CAR_SPAWN_WAIT + 10
    while tick() < deadline and not car do
        car = findNearbyVehicle(260, carName)
        if not car then task.wait(0.4) end
    end
    if not car then
        warn("[DE][Drive] no vehicle appeared after Spawn -- is the car name right?")
        return false
    end

    local seat = car:FindFirstChildOfClass("VehicleSeat") or car:FindFirstChildOfClass("Seat")
    local hum = getHumanoid()
    if seat and hum then
        -- Sit only takes at close range, and the car does not spawn on top of us.
        local h = getHRP()
        if h then
            h.CFrame = car:GetPivot() * CFrame.new(0, 5, 8)
            task.wait(0.5)
        end
        pcall(function() seat:Sit(hum) end)
        task.wait(1.0)
        if not (hum.SeatPart == seat) and h then
            h.CFrame = seat.CFrame
            task.wait(0.4)
            pcall(function() seat:Sit(hum) end)
            task.wait(0.6)
        end
    end
    return getDrivenVehicleModel() ~= nil
end

--=====================================================================
--  AutoDrive
--  Flies the car along the road graph. Speed is in studs per SECOND and
--  is frame-rate independent, so a 240Hz client drives at the same pace
--  as a 60Hz one.
--=====================================================================
local AutoDrive = {
    Enabled     = false,
    Speed       = 430,      -- studs/second
    -- Ride height must stay at or below 1. Any higher and the game stops
    -- counting the car as driving, so the run earns nothing.
    Hover       = 0.8,
    HoverMax    = 1,
    Status      = "idle",
    Distance    = 0,        -- studs driven since the toggle went on
    -- The periodic full rebuild used to run every 3 minutes. It threw away
    -- every locally harvested node (measured: 2532 -> 1509) and renumbered the
    -- rest, so the router's memory of where it had been became meaningless and
    -- it started going round in circles. The local harvest keeps the graph
    -- fresh on its own; use the Rebuild button if the map really changes.
    RebuildEvery = 0,
    AutoRespawn = true,     -- put you back in a car if you lose it
    HugRoad     = true,     -- find the lane instead of tracking the centreline
    CheckLegs   = true,     -- reject legs that cut across non-road
    LaneHalfWidth = 12,     -- half a lane; road generator uses ~24 stud lanes
    LaneMaxOffset = 28,     -- never sit further than this from the node line
    LaneScanEvery = 0.2,    -- seconds between lane sweeps
    LaneEase      = 0.12,   -- how fast to slide across into the lane
    LaneTarget    = 0,
    LaneAt        = 0,
    RoadWidth     = 0,
    SmoothY       = nil,
    Up            = nil,
    Coasting      = false,  -- holding a heading while the map streams in
    Coasted       = 0,      -- studs coasted since we last had real road
    CoastStep     = 110,    -- length of each synthetic straight-ahead hop
    MaxCoast      = 2600,   -- past this it is a genuine dead end, not streaming
    StreamAt      = 0,
    Path        = {},       -- upcoming node positions; needs 4 for the curve
    T           = 0,
    Dir         = Vector3.new(0, 0, -1),
    Lateral     = 0,        -- current sideways correction, eased
    LastRebuild = 0,
    Respawning  = false,
}

local function autoDriveStop(reason)
    AutoDrive.Enabled = false
    AutoDrive.Status = reason or "stopped"
end

-- Keep at least four nodes queued so the curve always has its control points.
local function fillPath()
    local guard = 0
    while #AutoDrive.Path < 4 and guard < 12 do
        guard = guard + 1
        local nextIdx = Router.Next()

        if nextIdx then
            table.insert(AutoDrive.Path, RoadNav.Nodes[nextIdx].p)
            AutoDrive.Coasted = 0
            AutoDrive.Coasting = false

        elseif AutoDrive.Coasted < AutoDrive.MaxCoast then
            -- No graph ahead. Almost always this is the map not having streamed
            -- in yet rather than the road ending, so hold the current heading,
            -- pull the terrain in, and pick the road back up on the far side.
            local last = AutoDrive.Path[#AutoDrive.Path]
            if not last then return false end
            local p = last + AutoDrive.Dir * AutoDrive.CoastStep
            table.insert(AutoDrive.Path, p)
            AutoDrive.Coasted = AutoDrive.Coasted + AutoDrive.CoastStep
            AutoDrive.Coasting = true
            requestStreamAround(p)
            RoadNav.HarvestNearby(p, RoadNav.HarvestRadius, { LocalPlayer.Character })
            -- If anything has appeared near the coast point, re-join the road.
            local found = RoadNav.Nearest(p, 260)
            if found then
                Router.Reset(RoadNav.Nodes[found].p, AutoDrive.Dir)
                AutoDrive.Coasted = 0
                AutoDrive.Coasting = false
            end

        else
            -- Coasted a long way with nothing at all: this really is the end of
            -- the road (map edge, cul-de-sac). Now a turn is the right answer.
            Router.NoUTurn = false
            local turnIdx = Router.Next()
            Router.NoUTurn = true
            if not turnIdx then return false end
            table.insert(AutoDrive.Path, RoadNav.Nodes[turnIdx].p)
            AutoDrive.Coasted = 0
            AutoDrive.Coasting = false
        end
    end
    return #AutoDrive.Path >= 4
end

local function resetPath(fromPos)
    -- Path[2] must be where the car already is, otherwise the first frame
    -- jumps it to the first node. Path[1] is only a curve control point.
    local back = fromPos - (AutoDrive.Dir or Vector3.new(0, 0, -1)) * 20
    AutoDrive.Path = { back, fromPos }
    AutoDrive.T = 0
    AutoDrive.Lateral = 0
    if not fillPath() then return false end
    requestStreamAround(AutoDrive.Path[3])
    return true
end

-- Step onto the next segment of the queued path.
local function advancePath()
    table.remove(AutoDrive.Path, 1)
    AutoDrive.T = 0
    if not fillPath() then return false end
    requestStreamAround(AutoDrive.Path[#AutoDrive.Path])
    return true
end

local function autoDriveStart()
    if not RoadNav.Built then
        AutoDrive.Status = "building road graph"
        RoadNav.Build()
    end
    if not RoadNav.Built then
        notify("Auto Drive", ("Found only %d road nodes -- graph too small."):format(#RoadNav.Nodes), 5, "error")
        return false
    end

    local model = getDrivenVehicleModel()
    if not model and AutoDrive.AutoRespawn then
        AutoDrive.Status = "spawning car"
        notify("Auto Drive", "Spawning your car...", 3, "info")
        pcall(ensureCarSpawnedAndEntered)
        model = getDrivenVehicleModel()
    end
    if not model then
        notify("Auto Drive", "Sit in a car first.", 5, "warning")
        return false
    end

    local pivot = model:GetPivot()

    -- Seed dense local coverage before anchoring, or the router starts on the
    -- sparse skeleton and immediately dead-ends.
    RoadNav.HarvestNearby(pivot.Position, RoadNav.HarvestRadius,
        { model, LocalPlayer.Character })
    RoadNav.LastHarvest = tick()

    if not Router.Reset(pivot.Position, pivot.LookVector) then
        notify("Auto Drive", "No road found near you.", 5, "error")
        return false
    end

    AutoDrive.Distance = 0
    AutoDrive.Dir = flatUnit(pivot.LookVector) or Vector3.new(0, 0, -1)
    AutoDrive.SmoothY, AutoDrive.Up = nil, nil
    AutoDrive.Lateral, AutoDrive.LaneTarget, AutoDrive.LaneAt = 0, 0, 0
    AutoDrive.Coasted, AutoDrive.Coasting = 0, false
    Router.NoUTurn = true

    -- Let the router reject legs that do not have road under them.
    Router.Validate = function(fromPos, toPos)
        if not AutoDrive.CheckLegs then return true end
        local m = getDrivenVehicleModel()
        if not m then return true end
        return legLooksDrivable(m, fromPos, toPos)
    end

    if not resetPath(pivot.Position) then
        notify("Auto Drive", "Road graph is a dead end here.", 5, "error")
        return false
    end
    AutoDrive.LastRebuild = tick()
    AutoDrive.Status = "driving"
    return true
end

task.spawn(function()
    while alive() do
        local dt = RunService.Heartbeat:Wait()
        if not AutoDrive.Enabled then continue end

        local model = getDrivenVehicleModel()
        if not model then
            AutoDrive.Status = "no vehicle"
            if AutoDrive.AutoRespawn and not AutoDrive.Respawning then
                AutoDrive.Respawning = true
                task.spawn(function()
                    local ok = pcall(ensureCarSpawnedAndEntered)
                    if ok and getDrivenVehicleModel() then
                        local p = getDrivenVehicleModel():GetPivot()
                        Router.Reset(p.Position, p.LookVector)
                        resetPath(p.Position)
                        AutoDrive.Status = "driving"
                    end
                    AutoDrive.Respawning = false
                end)
            end
            continue
        end

        -- At 300 studs/s the car outruns Roblox's streaming, arrives somewhere
        -- with no geometry and no nodes, and used to turn round. Ask for the
        -- ground well ahead of where we actually are.
        if tick() - AutoDrive.StreamAt > 0.75 then
            AutoDrive.StreamAt = tick()
            local ahead = model:GetPivot().Position + AutoDrive.Dir * 1000
            requestStreamAround(ahead)
        end

        -- Keep laying nodes on the tarmac around us as it streams in. This is
        -- what stops the router running out of road and turning back.
        if tick() - RoadNav.LastHarvest > RoadNav.HarvestEvery then
            RoadNav.LastHarvest = tick()
            local anchor = model:GetPivot().Position
            task.spawn(function()
                RoadNav.HarvestNearby(anchor, RoadNav.HarvestRadius,
                    { model, LocalPlayer.Character })
            end)
        end

        -- Periodic refresh so roads added or moved mid-session get picked up.
        if AutoDrive.RebuildEvery > 0 and tick() - AutoDrive.LastRebuild > AutoDrive.RebuildEvery then
            AutoDrive.LastRebuild = tick()
            task.spawn(function()
                local before = #RoadNav.Nodes
                RoadNav.Build()
                if #RoadNav.Nodes ~= before then
                    local p = model:GetPivot()
                    Router.Reset(p.Position, AutoDrive.Dir)
                    resetPath(p.Position)
                end
            end)
        end

        if #AutoDrive.Path < 4 then
            local p = model:GetPivot()
            if not fillPath() then
                Router.Reset(p.Position, AutoDrive.Dir)
                if not resetPath(p.Position) then
                    autoDriveStop("graph dead end")
                end
            end
            continue
        end

        local p0, p1, p2, p3 = AutoDrive.Path[1], AutoDrive.Path[2], AutoDrive.Path[3], AutoDrive.Path[4]
        local segLen = (p2 - p1).Magnitude
        if segLen < 1 then
            if not advancePath() then autoDriveStop("graph dead end") end
            continue
        end

        local step = AutoDrive.Speed * math.min(dt, 0.1)
        AutoDrive.T = AutoDrive.T + step / segLen
        AutoDrive.Distance = AutoDrive.Distance + step

        if AutoDrive.T >= 1 then
            -- Carry on from the node we just reached; never teleport back to a
            -- start point, which is what made the old fixed loop obvious.
            if not advancePath() then
                local here = p2
                Router.Reset(here, AutoDrive.Dir)
                if not resetPath(here) then
                    autoDriveStop("graph dead end")
                    continue
                end
            end
            p0, p1, p2, p3 = AutoDrive.Path[1], AutoDrive.Path[2], AutoDrive.Path[3], AutoDrive.Path[4]
        end

        -- Curve through the node chain rather than cutting the corner.
        local t = math.clamp(AutoDrive.T, 0, 1)
        local pos = catmullRom(p0, p1, p2, p3, t)

        local want = flatUnit(catmullRom(p0, p1, p2, p3, math.min(t + 0.06, 1)) - pos)
            or flatUnit(p2 - p1)
        if want then
            AutoDrive.Dir = flatUnit(AutoDrive.Dir:Lerp(want, 0.18)) or want
        end
        local right = AutoDrive.Dir:Cross(Vector3.new(0, 1, 0))
        right = (right.Magnitude > 1e-3) and right.Unit or Vector3.new(1, 0, 0)

        -- Find the tarmac. If the spot under us is not road, step sideways
        -- until we find some and ease over to it instead of ploughing on.
        local hit, surfaceNormal
        if AutoDrive.HugRoad then
            -- The lane sweep is ~26 raycasts, so run it a few times a second
            -- and ease towards the answer rather than re-deciding every frame.
            if tick() - AutoDrive.LaneAt > AutoDrive.LaneScanEvery then
                AutoDrive.LaneAt = tick()
                local target, _, width = findLane(model, pos, right,
                    AutoDrive.LaneHalfWidth, AutoDrive.LaneMaxOffset)
                if target then
                    AutoDrive.LaneTarget = target
                    AutoDrive.RoadWidth = width or 0
                else
                    AutoDrive.LaneTarget = 0
                end
            end
            AutoDrive.Lateral = AutoDrive.Lateral
                + (AutoDrive.LaneTarget - AutoDrive.Lateral) * AutoDrive.LaneEase
            if math.abs(AutoDrive.Lateral) > 0.05 then
                pos = pos + right * AutoDrive.Lateral
            end
        end
        hit = raycastDown(pos, model, 40, 220)

        -- Sit on the actual road surface where it has streamed in; fall back to
        -- the interpolated node height where it has not. A big disagreement
        -- means we hit an overpass deck or the ground under a bridge rather
        -- than our own road, so the node height wins.
        if hit and math.abs((hit.Position.Y + math.min(AutoDrive.Hover, AutoDrive.HoverMax)) - pos.Y) <= 25 then
            local hover = math.clamp(AutoDrive.Hover, 0, AutoDrive.HoverMax)
            local wantY = hit.Position.Y + hover
            -- Ease onto the surface instead of snapping. Road seams, kerbs and
            -- bridge joints are a stud or two apart and snapping to each one is
            -- what made the car look like it was vibrating.
            if not AutoDrive.SmoothY then
                AutoDrive.SmoothY = wantY
            else
                AutoDrive.SmoothY = AutoDrive.SmoothY + (wantY - AutoDrive.SmoothY) * 0.25
                if math.abs(wantY - AutoDrive.SmoothY) > 12 then AutoDrive.SmoothY = wantY end
            end
            pos = Vector3.new(pos.X, AutoDrive.SmoothY, pos.Z)
            if hit.Normal and hit.Normal.Y > 0.5 then surfaceNormal = hit.Normal end
        else
            AutoDrive.SmoothY = pos.Y
        end

        -- Bank the car onto the road surface. Staying rigidly level on a slope
        -- drives the suspension through the tarmac, which is half of why the
        -- rims were shaking. Ease the normal too, or a kerb clipped by one ray
        -- tips the whole car for a frame.
        local rawUp = surfaceNormal or Vector3.new(0, 1, 0)
        AutoDrive.Up = AutoDrive.Up and AutoDrive.Up:Lerp(rawUp, 0.15) or rawUp
        if AutoDrive.Up.Magnitude < 1e-3 then AutoDrive.Up = Vector3.new(0, 1, 0) end
        local up = AutoDrive.Up.Unit
        local rx = AutoDrive.Dir:Cross(up)
        local cf
        if rx.Magnitude > 1e-3 then
            rx = rx.Unit
            cf = CFrame.fromMatrix(pos, rx, rx:Cross(AutoDrive.Dir).Unit)
        else
            cf = CFrame.lookAt(pos, pos + AutoDrive.Dir)
        end

        pcall(function() model:PivotTo(cf) end)
        reportDrivingVelocity(model, AutoDrive.Dir, AutoDrive.Speed)
        AutoDrive.Status = AutoDrive.Coasting and "waiting for map" or "driving"
    end
end)

--=====================================================================
--  Criminal / ATM farm
--=====================================================================
-- Last-resort seeds, only used before the road graph is ready. Everything the
-- farms actually search is derived from the live map below.
local HUNT_POSITIONS = {
    Vector3.new(-2060, 15, 3415),
    Vector3.new(-2846, 11, -1549),
    Vector3.new(-1055, 12, 5048),
    Vector3.new(-1893, 14, 2198),
    Vector3.new(-300,  26, -654),
}

-- ATMs, crime scenes and the rest are streamed out until you are near them, so
-- every farm has to go looking. Rather than a fixed list of coordinates that
-- rots on the next map update, spread search points across the road network we
-- already built: one per large grid cell, so they cover the whole map.
local _huntCache, _huntCacheGen = nil, -1
local function huntPositions()
    if _huntCache and _huntCacheGen == RoadNav.Generation then return _huntCache end
    if not RoadNav.Built or #RoadNav.Nodes < 50 then return HUNT_POSITIONS end

    -- Streaming does not reach across the old 2,500-stud cells. Keep the
    -- samples close enough together that an ATM near a road actually loads.
    local CELL = 650
    local cells, out = {}, {}
    for _, n in ipairs(RoadNav.Nodes) do
        local gx, gz = math.floor(n.p.X / CELL), math.floor(n.p.Z / CELL)
        local key = gx .. "," .. gz
        local centre = Vector3.new((gx + 0.5) * CELL, n.p.Y, (gz + 0.5) * CELL)
        local score = (n.p - centre).Magnitude
        if not cells[key] or score < cells[key].score then
            cells[key] = { p = n.p, score = score }
        end
    end
    for _, sample in pairs(cells) do table.insert(out, sample.p) end
    if #out < 4 then return HUNT_POSITIONS end

    -- shuffle so two sessions do not sweep in the same order
    for i = #out, 2, -1 do
        local j = math.random(i)
        out[i], out[j] = out[j], out[i]
    end
    _huntCache, _huntCacheGen = out, RoadNav.Generation
    return out
end

local _huntIdx = 0
local function nextHuntPosition()
    local list = huntPositions()
    _huntIdx = (_huntIdx % #list) + 1
    return list[_huntIdx], #list
end

task.spawn(function()
    task.wait(3)
    for _, pos in ipairs(HUNT_POSITIONS) do
        requestStreamAround(pos)
        task.wait(0.5)
    end
end)

local function getAtmModel(adornee)
    local n = adornee
    while n and n ~= Workspace do
        local ok, has = pcall(function() return CollectionService:HasTag(n, "CriminalATM") end)
        if ok and has then return n end
        n = n.Parent
    end
    return adornee.Parent
end

-- A rejected ATM can remain tagged and look available for several seconds.
-- Without a local cooldown getNearestATM selects it again every loop forever.
local ATMRetry = {
    after = setmetatable({}, { __mode = "k" }),
    failures = setmetatable({}, { __mode = "k" }),
}
function ATMRetry.cool(model, succeeded)
    if not model then return end
    if succeeded then
        ATMRetry.failures[model] = 0
        ATMRetry.after[model] = tick() + 20
        return
    end
    local failures = (ATMRetry.failures[model] or 0) + 1
    ATMRetry.failures[model] = failures
    ATMRetry.after[model] = tick() + math.min(60, 5 * (2 ^ math.min(failures - 1, 4)))
end
local function listAvailableATMs()
    local out = {}
    for _, comp in ipairs(CollectionService:GetTagged("CriminalATMClient")) do
        local model = getAtmModel(comp)
        if model and model.Parent
           and (ATMRetry.after[model] or 0) <= tick()
           and model:GetAttribute("State") ~= "Busted" then
            local engaging = model:GetAttribute("EngagingPlayerId")
            if engaging == nil or engaging == LocalPlayer.UserId then
                table.insert(out, { adornee = comp, model = model })
            end
        end
    end
    return out
end
local function getNearestATM()
    local hrp = getHRP()
    if not hrp then return nil end
    local best, bestDist
    for _, e in ipairs(listAvailableATMs()) do
        local ok, pv = pcall(function() return e.model:GetPivot() end)
        local pos = (ok and pv) and pv.Position
            or (e.adornee:IsA("BasePart") and e.adornee.Position)
        if pos then
            local d = (hrp.Position - pos).Magnitude
            if not bestDist or d < bestDist then best, bestDist = e, d end
        end
    end
    return best
end

local DROPOFF_FALLBACK_POS = Vector3.new(-2543, 15, 4030)
local function getDropoffSpawner()
    local jobs = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Jobs")
    if not jobs then return nil end
    local s = jobs:FindFirstChild("CriminalDropOffSpawners")
    return s and s:FindFirstChild("CriminalDropOffSpawnerPermanent")
end
local function getDropoffPosition()
    local s = getDropoffSpawner()
    if s then
        if s:IsA("BasePart") then return s.Position end
        if s:IsA("Model") and s.PrimaryPart then return s.PrimaryPart.Position end
        for _, c in ipairs(s:GetDescendants()) do
            if c:IsA("BasePart") then return c.Position end
        end
    end
    return DROPOFF_FALLBACK_POS
end
local function waitForDropoffSpawner(timeout)
    local stop = tick() + (timeout or 4)
    while tick() < stop do
        local s = getDropoffSpawner()
        if s then return s end
        task.wait(0.1)
    end
    return nil
end

local _heistDataCache = nil
local function refreshHeistDataCache()
    if not HeistRemoteConfig then return end
    local ok, cfg = pcall(HeistRemoteConfig.GetHeistsConfig)
    if ok and cfg and cfg.HeistData then _heistDataCache = cfg.HeistData end
end
task.spawn(function()
    while alive() do refreshHeistDataCache() task.wait(30) end
end)

local HeistTiming = { LastStartedId = nil, LastStartedAt = 0 }
if Remotes then
    pcall(function()
        Remotes.connect("HeistStarted", function(heistId)
            HeistTiming.LastStartedId = heistId
            HeistTiming.LastStartedAt = workspace:GetServerTimeNow()
        end)
        Remotes.connect("HeistHazardReturnOffer", function()
            pcall(function() Remotes.fireServer("HeistHazardReturnChoice", false) end)
        end)
    end)
end

local function computeHeistState(heistId, data)
    if not data or not data.MinStartTime or not data.HeistDuration then
        return false, math.huge
    end
    local now = workspace:GetServerTimeNow()
    if heistId and HeistTiming.LastStartedId == heistId then
        local elapsed = now - HeistTiming.LastStartedAt
        if elapsed >= 0 and elapsed < data.HeistDuration then
            return true, data.HeistDuration - elapsed
        end
    end
    local cycle = data.MinStartTime + data.HeistDuration
    local cyclePos = now % cycle
    if cyclePos >= data.MinStartTime then
        return true, cycle - cyclePos
    else
        return false, data.MinStartTime - cyclePos
    end
end
local function isAnyHeistOpen()
    if not _heistDataCache then return false, nil end
    for id, data in pairs(_heistDataCache) do
        local active = computeHeistState(id, data)
        if active then return true, id end
    end
    return false, nil
end

local function getLootChildren()
    local heists = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Heists")
    if not heists then return {} end
    local out = {}
    for _, heist in ipairs(heists:GetChildren()) do
        local asset = heist:FindFirstChild("HeistAsset")
        local loot = asset and asset:FindFirstChild("Loot")
        if loot then
            for _, c in ipairs(loot:GetChildren()) do table.insert(out, c) end
        end
    end
    return out
end
local function getMoneyFloorParts()
    local fl = Workspace:FindFirstChild("BankMoneyPrintingFloor_STREAM")
    fl = fl and fl:FindFirstChild("MoneyFloorOptimized")
    if not fl then return {} end
    local out = {}
    for _, c in ipairs(fl:GetChildren()) do
        if c:IsA("BasePart") then table.insert(out, c) end
    end
    return out
end
local function findRepresentativePart(inst)
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") and inst.PrimaryPart then return inst.PrimaryPart end
    for _, d in ipairs(inst:GetDescendants()) do
        if d:IsA("BasePart") then return d end
    end
    return nil
end
local function fireAllPromptsUnder(inst)
    if not fireproximityprompt then return end
    for _, d in ipairs(inst:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.Enabled then
            pcall(fireproximityprompt, d)
        end
    end
end
local function bagIsFull()
    local cap = LocalPlayer:GetAttribute("BagCapacityHeistLoot") or 0
    local cur = LocalPlayer:GetAttribute("CarryingHeistLoot") or 0
    return cap > 0 and cur >= cap
end
local function fastSweepHeistLoot()
    local h = getHRP()
    if not h then return end
    for _, lootInst in ipairs(getLootChildren()) do
        if bagIsFull() then return end
        fireAllPromptsUnder(lootInst)
        local rep = findRepresentativePart(lootInst)
        if rep and firetouchinterest then
            pcall(firetouchinterest, h, rep, 0)
            pcall(firetouchinterest, h, rep, 1)
        end
    end
    for _, part in ipairs(getMoneyFloorParts()) do
        if bagIsFull() then return end
        if firetouchinterest then
            pcall(firetouchinterest, h, part, 0)
            pcall(firetouchinterest, h, part, 1)
        end
    end
end
local function tpSweepHeistLoot()
    for _, lootInst in ipairs(getLootChildren()) do
        if bagIsFull() then return end
        local rep = findRepresentativePart(lootInst)
        if rep then
            tp(CFrame.new(rep.Position + Vector3.new(0, 3, 0)))
            task.wait(0.05)
            fireAllPromptsUnder(lootInst)
            if firetouchinterest then
                local h = getHRP()
                if h then pcall(firetouchinterest, h, rep, 0); pcall(firetouchinterest, h, rep, 1) end
            end
        end
    end
end
local function getBankExitGatePart()
    local h = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Heists")
    h = h and h:FindFirstChild("BankHeist")
    local asset = h and h:FindFirstChild("HeistAsset")
    local prereq = asset and asset:FindFirstChild("PrerequisiteModels")
    if not prereq then return nil end
    local target = prereq:GetChildren()[3]
    if not target then return nil end
    local door = target:FindFirstChild("Door")
    local mdl = door and door:FindFirstChild("DoorModel")
    return mdl and mdl:FindFirstChild("MovingDoor")
end

local AutoFarm = {
    Enabled = false,
    Phase = "idle",
    Stats = { ATMs = 0, Heists = 0, Failed = 0, Deposits = 0 },
    HoldGrace = 0.4,
    DepositThreshold = 0,
    NextDepositAt = 0,
    LastError = nil,
}

local function atmPivotPos(model, adornee)
    local ok, pv = pcall(function() return model:GetPivot() end)
    if ok and pv then return pv.Position end
    if adornee and adornee:IsA("BasePart") then return adornee.Position end
    return nil
end

local function bustOneATM(entry)
    local atm, adornee = entry.model, entry.adornee
    if not atm or not adornee then return false, "missingModel" end
    local cfg = atm:GetAttribute("IsWaterATM") == true
        and CriminalConstants.ATMConfig.Water or CriminalConstants.ATMConfig.Default
    local actDist = cfg.ActivationDistance

    if hasATMBustDebounce() then
        if not waitForBustDebounceClear(8) then return false, "ATMBustDebounce" end
    end

    local pivotPos = atmPivotPos(atm, adornee)
    if not pivotPos then return false, "noPivot" end
    local function standNear()
        local h = getHRP()
        if h then h.CFrame = CFrame.new(pivotPos + Vector3.new(0, 3, 0)) end
    end
    standNear()
    task.wait(0.1)

    local ok, accepted, reason = pcall(function()
        return Remotes.invokeServer(CriminalConstants.RemoteFunctions.AttemptATMBustStart, atm)
    end)
    if not ok or not accepted then
        ATMRetry.cool(atm, false)
        return false, ("BustStart failed: %s"):format(tostring(reason or accepted))
    end

    local hold = CriminalUtil.GetATMBustTime(LocalPlayer)
    local realMin = math.max(0, hold - 2.5)
    local stopAt = tick() + realMin + AutoFarm.HoldGrace
    while tick() < stopAt do
        if not AutoFarm.Enabled then return false, "userCancelled" end
        local h = getHRP()
        if h and (h.Position - pivotPos).Magnitude > actDist then standNear() end
        task.wait(0.05)
    end

    local ok2, completed, reason2 = pcall(function()
        return Remotes.invokeServer(CriminalConstants.RemoteFunctions.AttemptATMBustComplete, atm)
    end)
    if not ok2 or not completed then
        ATMRetry.cool(atm, false)
        return false, ("BustComplete failed: %s"):format(tostring(reason2 or completed))
    end
    ATMRetry.cool(atm, true)
    return true
end

local function tryDepositAtDropoff()
    if not Remotes or not CriminalConstants then return false, "noRemotes" end
    if not playerHasAnyBag() then return true, "noBags" end
    local h = getHRP()
    if not h then return false, "noHRP" end

    h.CFrame = CFrame.new(getDropoffPosition() + Vector3.new(0, 3, 0))
    task.wait(0.4)
    local spawner = waitForDropoffSpawner(4)
    if not spawner then return false, "spawnerNotStreamed" end

    local triggerPart = (spawner:IsA("BasePart") and spawner)
        or (spawner:IsA("Model") and spawner.PrimaryPart)
    if not triggerPart then
        for _, c in ipairs(spawner:GetDescendants()) do
            if c:IsA("BasePart") then triggerPart = c; break end
        end
    end
    if not triggerPart then return false, "noTriggerPart" end

    local centre = triggerPart.Position
    local outside = CFrame.new(centre + Vector3.new(10, 3, 0))
    local inside  = CFrame.new(centre + Vector3.new(0, 3, 0))

    local lastOk, lastAccepted, lastReason = false, nil, nil
    for pass = 1, 3 do
        if not playerHasAnyBag() then break end
        h.CFrame = outside
        task.wait(0.15)
        h.CFrame = inside
        if firetouchinterest then pcall(firetouchinterest, h, triggerPart, 0) end
        task.wait(0.2)
        lastOk, lastAccepted, lastReason = pcall(function()
            return Remotes.invokeServer(CriminalConstants.RemoteFunctions.AttemptCriminalJobComplete, spawner)
        end)
        task.wait(0.15)
        if firetouchinterest then pcall(firetouchinterest, h, triggerPart, 1) end
        h.CFrame = outside
        task.wait(0.1)
        if not playerHasAnyBag() then break end
    end
    if not lastOk then return false, tostring(lastAccepted) end
    if not lastAccepted then return false, ("Deposit rejected: %s"):format(tostring(lastReason)) end
    if not waitForBagsCleared(10) then return false, "bagsNotCleared" end
    return true
end

local STAR_EVADE_HEIGHT = 5000
local function tpHighAndWaitForStars(maxWait)
    local h = getHRP()
    if not h then return end
    h.CFrame = h.CFrame + Vector3.new(0, STAR_EVADE_HEIGHT, 0)
    local stop = tick() + (maxWait or 90)
    while tick() < stop do
        if not isWanted() and getStars() <= 0 then break end
        local hh = getHRP()
        if hh and hh.Position.Y < STAR_EVADE_HEIGHT - 1000 then
            hh.CFrame = hh.CFrame + Vector3.new(0, STAR_EVADE_HEIGHT, 0)
        end
        task.wait(0.5)
    end
end

task.spawn(function()
    while alive() do
        task.wait(0.2)
        -- Do not fight AutoDrive for the seat.
        if AutoFarm.Enabled and not AutoDrive.Enabled then
            local hum = getHumanoid()
            if hum and hum.SeatPart then
                pcall(function() hum.Sit = false end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end
    end
end)

local AntiArrest = { Enabled = false, Threshold = 0.4, LastTrigger = 0 }

local function antiArrestPanic()
    if inHeistNow() then return end
    if tick() - AntiArrest.LastTrigger < 1.5 then return end
    AntiArrest.LastTrigger = tick()
    local h = getHRP()
    if h then
        h.CFrame = h.CFrame + Vector3.new(0, STAR_EVADE_HEIGHT, 0)
        notify("AntiArrest", "Yeeted -- waiting for circle to clear", 2, "warning")
    end
    local stop = tick() + 30
    while tick() < stop do
        local c = LocalPlayer.Character
        local pct = c and c:GetAttribute("ArrestCirclePercentage") or 0
        if (pct or 0) <= 0 then break end
        task.wait(0.3)
    end
end

task.spawn(function()
    while alive() do
        task.wait(0.2)
        if AntiArrest.Enabled and not inHeistNow() then
            local c = LocalPlayer.Character
            local pct = c and c:GetAttribute("ArrestCirclePercentage")
            if pct and pct >= AntiArrest.Threshold then
                antiArrestPanic()
            end
        end
    end
end)

if Remotes then
    pcall(function()
        Remotes.connect("LocalCriminalArrested", function()
            if AntiArrest.Enabled and not inHeistNow() then antiArrestPanic() end
        end)
    end)
end

local function depositAndEvade(reason)
    AutoFarm.Phase = "depositing"
    notify("Farm", reason or "Depositing...", 2, "info")
    local ok, err = tryDepositAtDropoff()
    if ok then
        AutoFarm.NextDepositAt = 0
        AutoFarm.LastError = nil
        AutoFarm.Stats.Deposits = AutoFarm.Stats.Deposits + 1
        AutoFarm.Phase = "evadingStars"
        tpHighAndWaitForStars(90)
    else
        -- A missing/streaming dropoff used to cause a teleport retry every
        -- 0.4 seconds. Back off and keep the player in a stable state.
        AutoFarm.NextDepositAt = tick() + 10
        AutoFarm.LastError = "deposit: " .. tostring(err)
        warn("[DE] deposit failed:", err)
    end
end

local function runHeistOnce()
    AutoFarm.Phase = "heistLoot"
    fastSweepHeistLoot()
    if not bagIsFull() then tpSweepHeistLoot() end
    if not bagIsFull() then return end
    AutoFarm.Phase = "heistExit"
    local gate = getBankExitGatePart()
    if gate then
        tp(CFrame.new(gate.Position + Vector3.new(0, 4, 0)))
        task.wait(0.3)
        local h = getHRP()
        if h then
            h.CFrame = CFrame.new(gate.Position)
            if firetouchinterest then pcall(firetouchinterest, h, gate, 0) end
            task.wait(0.2)
            if firetouchinterest then pcall(firetouchinterest, h, gate, 1) end
            h.CFrame = CFrame.new(gate.Position + Vector3.new(0, 4, 6))
        end
        task.wait(0.2)
    end
    depositAndEvade("Heist bag full -- depositing")
    AutoFarm.Stats.Heists = AutoFarm.Stats.Heists + 1
end

task.spawn(function()
    while alive() do
        task.wait(0.4)
        if not AutoFarm.Enabled then AutoFarm.Phase = "idle" continue end
        if isInSeat() then
            AutoFarm.Phase = "inSeat"
            continue
        end

        if (LocalPlayer:GetAttribute("JobId") or "") ~= "Criminal" then
            joinCriminalJob()
            task.wait(0.5)
            continue
        end

        -- Deposit is the terminal action for a full criminal run. Do this
        -- before choosing another visible ATM, otherwise a full player can get
        -- stuck retrying ATMs that the server will never accept.
        local canDeposit, depositReason = checkDropoffRequirements()
        if canDeposit then
            if tick() >= (AutoFarm.NextDepositAt or 0) then
                depositAndEvade("Ready to cash out -- depositing")
            else
                AutoFarm.Phase = "depositCooldown"
                task.wait(1)
            end
            continue
        elseif playerHasAnyBag() and getStars() >= 5 then
            -- Usually this is the short arrest debounce. Do not attempt more
            -- ATMs while cash-out is otherwise ready.
            AutoFarm.Phase = "waitingDropoff: " .. tostring(depositReason)
            task.wait(1)
            continue
        end

        local entry = getNearestATM()
        if entry then
            AutoFarm.Phase = "bustingATM"
            local ok, err = bustOneATM(entry)
            if ok then
                AutoFarm.LastError = nil
                AutoFarm.Stats.ATMs = AutoFarm.Stats.ATMs + 1
            else
                AutoFarm.LastError = tostring(err)
                AutoFarm.Stats.Failed = AutoFarm.Stats.Failed + 1
                if err and err:find("Debounce") then
                    waitForBustDebounceClear(6)
                elseif err and err:find("ExploitingBustTime") then
                    AutoFarm.HoldGrace = math.min(AutoFarm.HoldGrace + 0.2, 2)
                end
            end
            if AutoFarm.DepositThreshold > 0
               and getCurrentBagValue() >= AutoFarm.DepositThreshold
               and checkDropoffRequirements() then
                depositAndEvade(("Hit threshold $%d -- depositing"):format(getCurrentBagValue()))
            end
            continue
        end

        local meets = checkDropoffRequirements()
        if meets then
            depositAndEvade("All ATMs busted -- depositing")
            continue
        end

        local canHeist = getStars() == 0 and not isWanted()
        if canHeist and isAnyHeistOpen() then
            runHeistOnce()
            continue
        end

        AutoFarm.Phase = "huntingATMs"
        local hp = nextHuntPosition()

        requestStreamAround(hp)
        local hh = getHRP()
        if hh then hh.CFrame = CFrame.new(hp + Vector3.new(0, 5, 0)) end
        -- RequestStreaming normally resolves quickly; long waits made the farm
        -- look frozen at every empty sample.
        for _ = 1, 6 do
            if not AutoFarm.Enabled then break end
            task.wait(1)
            if getNearestATM() then break end
            if getStars() == 0 and not isWanted() and isAnyHeistOpen() then break end
            if checkDropoffRequirements() then break end
        end
    end
end)

--=====================================================================
--  Police
--=====================================================================
local Police = { CrimeScene = false, Arrest = false, CSStats = 0, ArrStats = 0,
                 ArrStatus = "idle", ArrestTeleport = true, CSStatus = "idle" }

local function joinSecurityJob() startJobSession("Security") end

local function getCrimeSceneParts()
    local out = {}
    local jobs = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Jobs")
    local spawners = jobs and jobs:FindFirstChild("SecurityCrimeSceneSpawners")
    if not spawners then return out end
    for _, spawner in ipairs(spawners:GetChildren()) do
        local cs = spawner:FindFirstChild("CrimeScene2") or spawner:FindFirstChild("CrimeScene")
        if cs and cs:GetAttribute("State") ~= "Used" then
            local eng = cs:GetAttribute("EngagingPlayerId")
            if eng == nil or eng == LocalPlayer.UserId then
                table.insert(out, cs)
            end
        end
    end
    return out
end

local function csPos(cs)
    local ok, pv = pcall(function() return cs:GetPivot() end)
    return ok and pv and pv.Position or (cs:IsA("BasePart") and cs.Position) or nil
end

local function getSortedCrimeScenes()
    local list = {}
    local hrp = getHRP()
    local mypos = hrp and hrp.Position or Vector3.zero
    for _, cs in ipairs(getCrimeSceneParts()) do
        local p = csPos(cs)
        if p then table.insert(list, { cs = cs, pos = p, d = (mypos - p).Magnitude }) end
    end
    table.sort(list, function(a, b) return a.d < b.d end)
    return list
end

local function hasCrimeSceneDebounce()
    local c = LocalPlayer.Character
    return c and c:GetAttribute("CrimeSceneUsedDebounce") ~= nil
end

local function useCrimeSceneOnce(cs, pos)
    if not Remotes then return false, "noModules" end

    local dstop = tick() + 6
    while hasCrimeSceneDebounce() and tick() < dstop do task.wait(0.1) end

    local function stand()
        local h = getHRP()
        if h then h.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
    end
    stand()
    task.wait(0.15)
    local started = invokeRemoteFunction("AttemptStartUsingCrimeScene", cs)
    if not started then return false, "startRejected" end
    local stop = tick() + 2.5 + 0.4
    while tick() < stop do
        if not Police.CrimeScene then return false, "cancelled" end
        local h = getHRP()
        if h and (h.Position - pos).Magnitude > 7.5 then stand() end
        task.wait(0.1)
    end
    local fin = invokeRemoteFunction("AttemptFinishUsingCrimeScene", cs)
    if not fin then return false, "finishRejected" end
    return true
end

task.spawn(function()
    while alive() do
        task.wait(0.3)
        if not Police.CrimeScene then continue end
        if isInSeat() then continue end
        if (LocalPlayer:GetAttribute("JobId") or "") ~= "Security" then
            joinSecurityJob(); task.wait(0.6); continue
        end
        local scenes = getSortedCrimeScenes()
        if #scenes == 0 then
            -- Crime scenes are streamed out until you are near them, so the old
            -- behaviour of waiting in place found nothing forever. Sweep the map
            -- the same way the ATM farm does.
            local hp, total = nextHuntPosition()
            Police.CSStatus = ("searching (%d spots)"):format(total)
            requestStreamAround(hp)
            local h = getHRP()
            if h then h.CFrame = CFrame.new(hp + Vector3.new(0, 5, 0)) end
            for _ = 1, 12 do
                if not Police.CrimeScene then break end
                task.wait(0.5)
                if #getCrimeSceneParts() > 0 then break end
            end
            continue
        end
        Police.CSStatus = ("%d scene(s)"):format(#scenes)

        for _, e in ipairs(scenes) do
            if not Police.CrimeScene then break end
            requestStreamAround(e.pos)
            local ok = useCrimeSceneOnce(e.cs, e.pos)
            if ok then Police.CSStats = Police.CSStats + 1 end
            task.wait(0.1)
        end
    end
end)

-- A criminal is only wanted if their character exists and carries the
-- CriminalExpireEpoch attribute, which replicates to everyone.
local function isWantedPlayer(plr)
    if plr == LocalPlayer then return false end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    if CriminalUtil and CriminalUtil.IsPlayerWanted then
        local ok, wanted = pcall(CriminalUtil.IsPlayerWanted, plr)
        if ok then return wanted == true end
    end
    local exp = char:GetAttribute("CriminalExpireEpoch") or 0
    return exp ~= 0 and os.time() < exp
end

local function getWantedCriminals()
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if isWantedPlayer(plr) then table.insert(out, plr) end
    end
    local myHRP = getHRP()
    if myHRP then
        table.sort(out, function(a, b)
            local ah = a.Character and a.Character:FindFirstChild("HumanoidRootPart")
            local bh = b.Character and b.Character:FindFirstChild("HumanoidRootPart")
            if not ah or not bh then return false end
            return (ah.Position - myHRP.Position).Magnitude < (bh.Position - myHRP.Position).Magnitude
        end)
    end
    return out
end

-- Move to a spot, taking the car with us if we are sitting in one. Setting
-- HumanoidRootPart.CFrame while seated fights the seat weld and leaves the
-- car behind, which is why arresting from a vehicle never worked.
local function moveSelfTo(cf)
    local model = getDrivenVehicleModel()
    if model then
        local ok = pcall(function() model:PivotTo(cf) end)
        if ok then
            killMomentum(model)
            return true
        end
    end
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = cf
        return true
    end
    return false
end

-- How close the server wants us. On foot this is 15 studs; in a car it scales
-- with the criminal's top speed, so sit well inside whatever it returns --
-- but never so close that a car body lands on top of them.
local function arrestStandoff(crim)
    local radius = 15
    if SecurityUtil and SecurityUtil.GetArrestRadius then
        local ok, r = pcall(SecurityUtil.GetArrestRadius, LocalPlayer, crim)
        if ok and type(r) == "number" and r > 0 then radius = r end
    elseif SecurityConstants and SecurityConstants.NotDrivingArrestRadius then
        radius = SecurityConstants.NotDrivingArrestRadius
    end
    local minGap = getDrivenVehicleModel() and 14 or 3
    return math.clamp(radius * 0.35, minGap, math.max(minGap, radius - 2))
end

local function arrestHoldSeconds()
    local t = (SecurityConstants and SecurityConstants.ArrestTimeSeconds) or 4
    return t + 1.5    -- margin for latency
end

-- One arrest attempt: announce, hold station for the full arrest timer, then
-- make a single request. The old version fired RequestArrestCriminal every
-- 0.4s, which the server has no reason to honour and which is exactly the
-- pattern their ArrestAbuse detection looks for.
local function tryArrest(crim)
    local myHRP = getHRP()
    local cHRP = crim.Character and crim.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not cHRP then return false, "gone" end

    local standoff = arrestStandoff(crim)
    local function station()
        local ch = crim.Character and crim.Character:FindFirstChild("HumanoidRootPart")
        if not ch then return false end
        if not Police.ArrestTeleport then
            return getHRP() ~= nil    -- you are driving there yourself
        end
        return moveSelfTo(ch.CFrame * CFrame.new(0, 0, standoff))
    end

    if not station() then return false, "gone" end
    pcall(function() fireRemoteEvent("NotifyStartArresting", crim, 0) end)

    local deadline = tick() + arrestHoldSeconds()
    while tick() < deadline do
        if not Police.Arrest then
            pcall(function() fireRemoteEvent("NotifyStopArresting", crim) end)
            return false, "cancelled"
        end
        if not station() then
            pcall(function() fireRemoteEvent("NotifyStopArresting", crim) end)
            return false, "target left"
        end
        if not isWantedPlayer(crim) then
            -- Someone else got them, or the wanted timer ran out.
            pcall(function() fireRemoteEvent("NotifyStopArresting", crim) end)
            return false, "no longer wanted"
        end
        task.wait(0.1)
    end

    pcall(function() fireRemoteEvent("RequestArrestCriminal", crim) end)

    local check = tick() + 2.5
    local ok = false
    while tick() < check do
        if not isWantedPlayer(crim) then ok = true break end
        station()
        task.wait(0.15)
    end

    pcall(function() fireRemoteEvent("NotifyStopArresting", crim) end)
    return ok, ok and "arrested" or "rejected"
end

task.spawn(function()
    while alive() do
        task.wait(0.5)
        if not Police.Arrest then continue end
        if (LocalPlayer:GetAttribute("JobId") or "") ~= "Security" then
            joinSecurityJob(); task.wait(1.5); continue
        end
        local targets = getWantedCriminals()
        if #targets == 0 then
            Police.ArrStatus = "no wanted criminals in server"
            continue
        end
        for _, crim in ipairs(targets) do
            if not Police.Arrest then break end
            Police.ArrStatus = "arresting " .. crim.Name
            local ok, why = tryArrest(crim)
            if ok then
                Police.ArrStats = Police.ArrStats + 1
                Police.ArrStatus = "arrested " .. crim.Name
            else
                Police.ArrStatus = crim.Name .. ": " .. tostring(why)
            end
            task.wait(1)   -- let the server settle before the next one
        end
    end
end)

--=====================================================================
--  Delivery
--=====================================================================
local AutoDelivery = { Enabled = false, Delay = 0.45 }
local function getDeliveryState()
    if not DeliveryJobTask or not DeliveryJobTask.GetCurrentDeliveryState then return nil end
    local ok, st = pcall(DeliveryJobTask.GetCurrentDeliveryState)
    return ok and st or nil
end
local function getDeliveryLocations()
    local jobs = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Jobs")
    local d = jobs and jobs:FindFirstChild("Delivery")
    local locs = d and d:FindFirstChild("DeliveryLocations")
    return locs and locs:GetChildren() or {}
end
local function nearestDeliveryLocationTo(pos)
    local best, bestD
    for _, loc in ipairs(getDeliveryLocations()) do
        local ok, pv = pcall(function() return loc:GetPivot() end)
        local lp = ok and pv and pv.Position or (loc:IsA("BasePart") and loc.Position)
        if lp then
            local d = (pos - lp).Magnitude
            if not bestD or d < bestD then best, bestD = loc, d end
        end
    end
    return best
end

local function deliveryGoInteract(targetPos)
    local loc = nearestDeliveryLocationTo(targetPos)
    if not loc then return false end
    local d = math.max(0.1, AutoDelivery.Delay or 0.45)
    teleportEntity(targetPos, 5)
    task.wait(d)

    for _ = 1, 3 do
        pcall(function() Remotes.fireServer("DeliveryLocationInteracted", loc) end)
        task.wait(d * 0.8)
    end
    return true, loc
end

task.spawn(function()
    while alive() do
        task.wait(0.6)
        if not AutoDelivery.Enabled then continue end
        if (LocalPlayer:GetAttribute("JobId") or "") ~= "Delivery" then
            joinDeliveryJob(); task.wait(1); continue
        end
        local st = getDeliveryState()
        if not st then task.wait(0.6); continue end

        local carried = st.ItemsCarried or 0
        local cap = st.MaxCapacity or 4

        if st.PickupPosition and carried < cap then
            local ok, loc = deliveryGoInteract(st.PickupPosition)
            if ok and loc then
                local before = carried
                local stop = tick() + 2
                while tick() < stop and AutoDelivery.Enabled do
                    local s2 = getDeliveryState()
                    if not s2 then break end
                    if (s2.ItemsCarried or 0) > before or not s2.PickupPosition then break end
                    task.wait(0.2)
                end
                pcall(function() Remotes.fireServer("DeliveryLocationLeft", loc) end)
            end
            continue
        end

        if st.DestinationPosition then
            local ok, loc = deliveryGoInteract(st.DestinationPosition)
            if ok and loc then
                local stop = tick() + 2.5
                while tick() < stop and AutoDelivery.Enabled do
                    local s2 = getDeliveryState()
                    if not s2 or (s2.ItemsCarried or 0) == 0 then break end
                    task.wait(0.2)
                end
                pcall(function() Remotes.fireServer("DeliveryLocationLeft", loc) end)
            end
            continue
        end

        task.wait(0.5)
    end
end)

--=====================================================================
--  Misc farms and vehicle tweaks
--=====================================================================
local PlaytimeRewards = { Enabled = false }
local function claimAllPlaytime()
    for i = 1, 12 do
        fireRemoteEvent("PlayRewards", i, false)
        task.wait(0.08)
    end
    pcall(function() Remotes.fireServer("ClaimRewards") end)
    pcall(function() Remotes.fireServer("RaceLeaderboardClaimRewards") end)
end
task.spawn(function()
    while alive() do
        if PlaytimeRewards.Enabled then claimAllPlaytime() end
        task.wait(15)
    end
end)

local Rainbow = { Enabled = false, Speed = 0.5, Interval = 0.4, Sections = { "Primary", "Secondary" } }
local function applyPaint(section, vehicleId, col)
    return invokeRemoteFunction("CustomizationPurchase", "Paint", section, vehicleId, { Color = col })
end
task.spawn(function()
    while alive() do
        local iv = math.max(0.2, Rainbow.Interval or 0.4)
        if not Rainbow.Enabled then task.wait(0.3); continue end
        local model = getDrivenVehicleModel()
        local vid = model and getVehicleId(model)
        if not vid then task.wait(0.3); continue end
        local hue = (tick() * Rainbow.Speed) % 1
        local col = Color3.fromHSV(hue, 1, 1)
        for _, sec in ipairs(Rainbow.Sections) do
            pcall(applyPaint, sec, vid, col)
        end
        task.wait(iv)
    end
end)

local VehFly = { Enabled = false, Speed = 80 }
task.spawn(function()
    while alive() do
        RunService.Heartbeat:Wait()
        if not VehFly.Enabled then continue end
        local model = getDrivenVehicleModel()
        if not model then continue end
        local wp = getWeightPart(model)
        if not wp then continue end
        local cam = Workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0.01 then dir = dir.Unit end
        pcall(function()
            wp.AssemblyLinearVelocity = dir * VehFly.Speed
            wp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end)

local AntiFlip = { Enabled = false }
task.spawn(function()
    while alive() do
        task.wait(0.2)
        if not AntiFlip.Enabled then continue end
        if AutoDrive.Enabled then continue end
        local model = getDrivenVehicleModel()
        if not model then continue end
        local ok, pivot = pcall(function() return model:GetPivot() end)
        if not ok or not pivot then continue end
        if pivot.UpVector.Y < 0.4 then
            local fwd = pivot.LookVector
            local flatFwd = Vector3.new(fwd.X, 0, fwd.Z)
            if flatFwd.Magnitude < 0.01 then flatFwd = Vector3.new(0, 0, -1) end
            flatFwd = flatFwd.Unit
            local upright = CFrame.lookAt(pivot.Position + Vector3.new(0, 3, 0), pivot.Position + Vector3.new(0, 3, 0) + flatFwd)
            pcall(function() model:PivotTo(upright) end)
            killMomentum(model)
        end
    end
end)

local PlayerMods = { WalkEnabled = false, WalkSpeed = 32 }
task.spawn(function()
    while alive() do
        task.wait(0.3)
        if not PlayerMods.WalkEnabled then continue end
        local hum = getHumanoid()
        if hum then pcall(function() hum.WalkSpeed = PlayerMods.WalkSpeed end) end
    end
end)

local CashCollect = { Enabled = false }
task.spawn(function()
    while alive() do
        task.wait(0.5)
        if not CashCollect.Enabled then continue end
        local hrp = getHRP()
        if not hrp then continue end
        for _, drop in ipairs(CollectionService:GetTagged("CashDrop")) do
            local part = drop:IsA("BasePart") and drop
                or (drop:IsA("Model") and (drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")))
            if part and firetouchinterest then
                pcall(firetouchinterest, hrp, part, 0)
                pcall(firetouchinterest, hrp, part, 1)
            end
        end
    end
end)

local CarMods = {
    Enabled   = false,
    SpeedMult = 1,
    AccelMult = 1,
    BrakeMult = 1,
    GripMult  = 1,
    TurnMult  = 1,
    NitroMult = 1,
    InfNitro  = false,
    InstantStop = false,
}
local _modTuneRef = nil
local _baseTune   = nil

local function snapshotTune(t)
    local snap = {
        TransmissionSpeeds = {},
        TransmissionTorque = {},
        BrakeTorque = t.BrakeTorque,
        RearWheelsTraction = t.RearWheelsTraction,
        FrontWheelsTraction = t.FrontWheelsTraction,
        TurnSpeed = t.TurnSpeed,
        TurnRadius = t.TurnRadius,
        NitrousForce = t.NitrousForce,
    }
    if type(t.TransmissionSpeeds) == "table" then
        for i, v in ipairs(t.TransmissionSpeeds) do snap.TransmissionSpeeds[i] = v end
    end
    if type(t.TransmissionTorque) == "table" then
        for i, v in ipairs(t.TransmissionTorque) do snap.TransmissionTorque[i] = v end
    end
    return snap
end

local function applyTune(t, snap, m)
    if type(t.TransmissionSpeeds) == "table" then
        for i, v in ipairs(snap.TransmissionSpeeds) do t.TransmissionSpeeds[i] = v * m.SpeedMult end
    end
    if type(t.TransmissionTorque) == "table" then
        for i, v in ipairs(snap.TransmissionTorque) do t.TransmissionTorque[i] = v * m.AccelMult end
    end
    if snap.BrakeTorque then t.BrakeTorque = snap.BrakeTorque * m.BrakeMult end
    if snap.RearWheelsTraction then t.RearWheelsTraction = snap.RearWheelsTraction * m.GripMult end
    if snap.FrontWheelsTraction then t.FrontWheelsTraction = snap.FrontWheelsTraction * m.GripMult end
    if snap.TurnSpeed then t.TurnSpeed = snap.TurnSpeed * m.TurnMult end
    if snap.NitrousForce then t.NitrousForce = snap.NitrousForce * m.NitroMult end
end
local STOCK_MULTS = { SpeedMult=1, AccelMult=1, BrakeMult=1, GripMult=1, TurnMult=1, NitroMult=1 }

local _modsDirty = false
task.spawn(function()
    while alive() do
        RunService.Heartbeat:Wait()
        if not VehicleController then continue end
        local ok, ctrl = pcall(VehicleController.getActiveChassisController)
        if not ok or not ctrl then _modTuneRef = nil; continue end
        local t = ctrl.Tune
        if type(t) ~= "table" then continue end

        if t ~= _modTuneRef then
            _modTuneRef = t
            _baseTune = snapshotTune(t)
            _modsDirty = false
        end

        if CarMods.Enabled then
            pcall(applyTune, t, _baseTune, CarMods)
            _modsDirty = true
        elseif _modsDirty then
            pcall(applyTune, t, _baseTune, STOCK_MULTS)
            _modsDirty = false
        end

        if CarMods.InfNitro then
            pcall(function()
                if t.NitrousSupplyTime then
                    ctrl.CurrentBoostSupply = t.NitrousSupplyTime
                    ctrl.NitrousAppliedDepletionRate = 0
                end
            end)
        end

        if CarMods.InstantStop then
            pcall(function()
                local braking = (ctrl.BrakeInput and ctrl.BrakeInput > 0.5) or ctrl.Handbrake
                if braking then
                    local wp = getWeightPart(ctrl.VehicleModel)
                    if not wp then
                        local m = getDrivenVehicleModel()
                        wp = m and getWeightPart(m)
                    end
                    if wp then
                        local v = wp.AssemblyLinearVelocity
                        wp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
                        wp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end)
        end
    end
end)

--=====================================================================
--  ESP
--=====================================================================
local ESP = {
    Enabled = false, Box = true, Name = true, Distance = true,
    Tracer = false, HealthBar = true, TeamCheck = false,
    Color = Color3.fromRGB(232, 65, 78),
    MaxDist = 2000,
}
local Camera = Workspace.CurrentCamera
local espObjects = {}

local function makeDrawing(class, props)
    local ok, d = pcall(Drawing.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function createESPFor(plr)
    if espObjects[plr] then return espObjects[plr] end
    local o = {
        box  = makeDrawing("Square", { Thickness = 1, Filled = false, Visible = false, Color = ESP.Color }),
        name = makeDrawing("Text", { Size = 13, Center = true, Outline = true, Visible = false, Color = Color3.new(1,1,1) }),
        dist = makeDrawing("Text", { Size = 12, Center = true, Outline = true, Visible = false, Color = Color3.new(1,1,1) }),
        tracer = makeDrawing("Line", { Thickness = 1, Visible = false, Color = ESP.Color }),
        hp   = makeDrawing("Square", { Thickness = 1, Filled = true, Visible = false, Color = Color3.fromRGB(60,220,90) }),
        hpbg = makeDrawing("Square", { Thickness = 1, Filled = true, Visible = false, Color = Color3.fromRGB(20,20,20) }),
    }
    espObjects[plr] = o
    return o
end

local function hideESP(o)
    if not o then return end
    for _, d in pairs(o) do if d then d.Visible = false end end
end

local function removeESP(plr)
    local o = espObjects[plr]
    if o then
        for _, d in pairs(o) do if d then pcall(function() d:Remove() end) end end
        espObjects[plr] = nil
    end
end

track(Players.PlayerRemoving:Connect(removeESP))

track(RunService.RenderStepped:Connect(function()
    if not ESP.Enabled then
        for _, o in pairs(espObjects) do hideESP(o) end
        return
    end
    Camera = Workspace.CurrentCamera
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local o = createESPFor(plr)
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")
        if not (hrp and hum and head) or hum.Health <= 0 then hideESP(o); continue end
        if ESP.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            hideESP(o); continue
        end
        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
        if dist > ESP.MaxDist then hideESP(o); continue end

        local topV, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
        local botV = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        if not topOn then hideESP(o); continue end

        local h = math.abs(botV.Y - topV.Y)
        local w = h * 0.5
        local cx, top = topV.X, topV.Y

        if ESP.Box and o.box then
            o.box.Size = Vector2.new(w, h)
            o.box.Position = Vector2.new(cx - w/2, top)
            o.box.Color = ESP.Color
            o.box.Visible = true
        elseif o.box then o.box.Visible = false end

        if ESP.Name and o.name then
            o.name.Text = plr.Name
            o.name.Position = Vector2.new(cx, top - 16)
            o.name.Visible = true
        elseif o.name then o.name.Visible = false end

        if ESP.Distance and o.dist then
            o.dist.Text = ("%dm"):format(math.floor(dist))
            o.dist.Position = Vector2.new(cx, top + h + 2)
            o.dist.Visible = true
        elseif o.dist then o.dist.Visible = false end

        if ESP.Tracer and o.tracer then
            local vp = Camera.ViewportSize
            o.tracer.From = Vector2.new(vp.X/2, vp.Y)
            o.tracer.To = Vector2.new(cx, top + h)
            o.tracer.Color = ESP.Color
            o.tracer.Visible = true
        elseif o.tracer then o.tracer.Visible = false end

        if ESP.HealthBar and o.hp and o.hpbg then
            local frac = math.clamp(hum.Health / math.max(1, hum.MaxHealth), 0, 1)
            local bx = cx - w/2 - 5
            o.hpbg.Size = Vector2.new(3, h)
            o.hpbg.Position = Vector2.new(bx, top)
            o.hpbg.Visible = true
            o.hp.Size = Vector2.new(3, h * frac)
            o.hp.Position = Vector2.new(bx, top + h * (1 - frac))
            o.hp.Color = Color3.fromRGB(math.floor(255*(1-frac)), math.floor(220*frac), 60)
            o.hp.Visible = true
        elseif o.hp then o.hp.Visible = false; o.hpbg.Visible = false end
    end
end))

--=====================================================================
--  GUI
--=====================================================================
local window
do
    local ok, w = pcall(function()
        return GuiLibrary:CreateWindow("Driving Empire", UDim2.new(0, 460, 0, 360), nil)
    end)
    if not ok then warn("[DE] CreateWindow errored:", w); return end
    window = w
end

do
    local mf = window.MainFrame
    local sg = mf and mf.Parent
    if sg and sg:IsA("ScreenGui") and sg.Parent == nil then
        local target = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
        sg.Parent = target
        sg.Enabled = true
        sg.DisplayOrder = 999999
        sg.IgnoreGuiInset = true
    end
    if mf then
        mf.Visible = true
        mf.AnchorPoint = Vector2.new(0, 0)
        mf.Size = UDim2.new(0, 460, 0, 360)
        mf.Position = UDim2.new(0.5, -230, 0.5, -180)
    end
end

local tabFarm = GuiLibrary:CreateTab(window, "Auto Farm")
local tabCar  = GuiLibrary:CreateTab(window, "Car")
local tabTele = GuiLibrary:CreateTab(window, "Teleports")
local tabESP  = GuiLibrary:CreateTab(window, "ESP")
local tabMisc = GuiLibrary:CreateTab(window, "Misc")
local tabCrim, tabPolice, tabDelivery = tabFarm, tabFarm, tabFarm

GuiLibrary:CreateSection(tabCrim, "ATM / Heist Farm")
GuiLibrary:CreateToggle(tabCrim, "Criminal Auto Farm", false, function(s)
    AutoFarm.Enabled = s
    AutoFarm.Stats = { ATMs = 0, Heists = 0, Failed = 0, Deposits = 0 }
    AutoFarm.NextDepositAt = 0
    AutoFarm.LastError = nil
    notify("Farm", s and "Started" or "Stopped", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabCrim, "TP up on arrest (off in heist)", false, function(s)
    AntiArrest.Enabled = s
end)
GuiLibrary:CreateInput(tabCrim, "Auto-deposit at $ (e.g. 100k, 1M)", function(text)
    local v = parseAmount(text)
    if v and v > 0 then
        AutoFarm.DepositThreshold = v
        notify("Threshold", ("Auto-deposit at $%s"):format(tostring(math.floor(v))), 2, "success")
    else
        AutoFarm.DepositThreshold = 0
        if text and text ~= "" then notify("Threshold", "Invalid -- disabled", 3, "warning") end
    end
end)
GuiLibrary:CreateSlider(tabCrim, "ATM hold grace (s)", 0, 1.5, 0.4, function(v) AutoFarm.HoldGrace = v end)
GuiLibrary:CreateButton(tabCrim, "Deposit Now", function()
    task.spawn(function()
        local ok, reason = checkDropoffRequirements()
        if not ok then notify("Deposit", "Cannot: " .. reason, 4, "error") return end
        local dok, derr = tryDepositAtDropoff()
        if dok then
            notify("Deposit", "Success -- escaping stars", 2, "success")
            tpHighAndWaitForStars(90)
        else
            notify("Deposit", "Failed: " .. tostring(derr), 4, "error")
        end
    end)
end)

GuiLibrary:CreateSection(tabCrim, "Status")
local lblCrim1 = GuiLibrary:CreateLabel(tabCrim, "Idle")
local lblCrim2 = GuiLibrary:CreateLabel(tabCrim, "-")
AutoFarm.ErrorLabel = GuiLibrary:CreateLabel(tabCrim, "No farm errors")

--------------------------------------------------------------------
-- Car tab
--------------------------------------------------------------------
GuiLibrary:CreateSection(tabCar, "Auto Drive")
GuiLibrary:CreateLabel(tabCar, "Reads the map's own roads each session. No fixed route.")
GuiLibrary:CreateToggle(tabCar, "Auto Drive", false, function(s)
    if s then
        AutoDrive.Enabled = false
        task.spawn(function()
            if autoDriveStart() then
                AutoDrive.Enabled = true
                notify("Auto Drive", ("Rolling -- %d road nodes"):format(#RoadNav.Nodes), 3, "success")
            else
                AutoDrive.Enabled = false
            end
        end)
    else
        AutoDrive.Enabled = false
        AutoDrive.Status = "idle"
        notify("Auto Drive", "Stopped.", 2, "info")
    end
end)
GuiLibrary:CreateButton(tabCar, "Rebuild Road Graph", function()
    task.spawn(function()
        RoadNav.Build()
        notify("Auto Drive", ("%d road nodes from %d folders"):format(#RoadNav.Nodes, RoadNav.Sources),
            4, RoadNav.Built and "success" or "warning")
        local model = getDrivenVehicleModel()
        if model and AutoDrive.Enabled then
            local p = model:GetPivot()
            Router.Reset(p.Position, AutoDrive.Dir)
            resetPath(p.Position)
        end
    end)
end)
local function ownedCarOptions()
    local ids = listOwnedVehicleIds()
    if #ids == 0 then return { "(none detected)" } end
    table.insert(ids, 1, "(auto)")
    return ids
end
local carDropdown = GuiLibrary:CreateDropdown(tabCar, "Vehicle to spawn", ownedCarOptions(), function(v)
    if v == "(auto)" or v == "(none detected)" then
        MANUAL_BEST_CAR = ""
        notify("Car", "Using auto-detect.", 2, "info")
    else
        MANUAL_BEST_CAR = v
        notify("Car", "Will spawn: " .. v, 2, "success")
    end
end)
GuiLibrary:CreateButton(tabCar, "Refresh Vehicle List", function()
    local opts = ownedCarOptions()
    if carDropdown and carDropdown.UpdateOptions then carDropdown.UpdateOptions(opts, true) end
    print("[DE] owned vehicle ids:", table.concat(opts, ", "))
    notify("Car", ("%d vehicles found (see console)"):format(math.max(0, #opts - 1)), 4, "info")
end)
GuiLibrary:CreateButton(tabCar, "Spawn + Sit In Best Car", function()
    task.spawn(function()
        if ensureCarSpawnedAndEntered() then
            notify("Car", "In the car.", 2, "success")
        else
            notify("Car", "Could not spawn -- pick one in the dropdown.", 5, "error")
        end
    end)
end)
local lblCar = GuiLibrary:CreateLabel(tabCar, "Idle")

GuiLibrary:CreateSection(tabCar, "Car Mods")
GuiLibrary:CreateLabel(tabCar, "Sit in a car. Toggle on, then tune the multipliers.")
GuiLibrary:CreateToggle(tabCar, "Enable Car Mods", false, function(s)
    CarMods.Enabled = s
    notify("Car", s and "Car mods ON" or "OFF (stock restored)", 2, s and "success" or "info")
end)
GuiLibrary:CreateSlider(tabCar, "Top Speed x", 1, 10, 1, function(v) CarMods.SpeedMult = v end)
GuiLibrary:CreateSlider(tabCar, "Acceleration x", 1, 10, 1, function(v) CarMods.AccelMult = v end)
GuiLibrary:CreateSlider(tabCar, "Brake Force x", 1, 10, 1, function(v) CarMods.BrakeMult = v end)
GuiLibrary:CreateSlider(tabCar, "Grip x", 1, 6, 1, function(v) CarMods.GripMult = v end)
GuiLibrary:CreateSlider(tabCar, "Turn Speed x", 1, 5, 1, function(v) CarMods.TurnMult = v end)
GuiLibrary:CreateSlider(tabCar, "Nitro Force x", 1, 8, 1, function(v) CarMods.NitroMult = v end)
GuiLibrary:CreateToggle(tabCar, "Infinite Nitro", false, function(s)
    CarMods.InfNitro = s
    notify("Car", s and "Infinite nitro ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabCar, "Anti-Flip (auto-upright)", false, function(s)
    AntiFlip.Enabled = s
end)
GuiLibrary:CreateToggle(tabCar, "Instant Stop (brake = stop)", false, function(s)
    CarMods.InstantStop = s
    notify("Car", s and "Instant stop ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabCar, "Rainbow Car (server)", false, function(s)
    Rainbow.Enabled = s
    notify("Car", s and "Rainbow ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateSlider(tabCar, "Rainbow Speed", 0.1, 3, 0.5, function(v) Rainbow.Speed = v end)
GuiLibrary:CreateSlider(tabCar, "Rainbow Interval (s)", 0.2, 2, 0.4, function(v) Rainbow.Interval = v end)
GuiLibrary:CreateButton(tabCar, "Despawn Vehicle", function()
    AutoDrive.Enabled = false
    pcall(function() ReplicatedStorage.Remotes.VehicleEvent:FireServer("Despawn") end)
end)

--------------------------------------------------------------------
-- Police / Delivery
--------------------------------------------------------------------
GuiLibrary:CreateSection(tabPolice, "Security Job")
GuiLibrary:CreateButton(tabPolice, "Join Security Job", function()
    joinSecurityJob()
    notify("Police", "Requested security job.", 2, "info")
end)
GuiLibrary:CreateToggle(tabPolice, "Auto Crime Scene", false, function(s)
    Police.CrimeScene = s
    if s then Police.CSStats = 0 end
    notify("Police", s and "Crime scene farm ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabPolice, "Auto Arrest Criminals", false, function(s)
    Police.Arrest = s
    if s then Police.ArrStats = 0 end
    notify("Police", s and "Auto-arrest ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabPolice, "Teleport to criminal", true, function(s)
    Police.ArrestTeleport = s
    notify("Police", s and "Will TP to targets (car comes too)" or "Drive there yourself", 3, "info")
end)
GuiLibrary:CreateButton(tabPolice, "Teleport To Nearest Wanted", function()
    task.spawn(function()
        local targets = getWantedCriminals()
        local crim = targets[1]
        if not crim then
            notify("Police", "Nobody in this server is wanted.", 3, "warning")
            return
        end
        local ch = crim.Character and crim.Character:FindFirstChild("HumanoidRootPart")
        if not ch then
            notify("Police", crim.Name .. " is not loaded in.", 3, "warning")
            return
        end
        moveSelfTo(ch.CFrame * CFrame.new(0, 0, arrestStandoff(crim)))
        notify("Police", "-> " .. crim.Name, 2, "info")
    end)
end)
GuiLibrary:CreateSection(tabPolice, "Status")
local lblPolice = GuiLibrary:CreateLabel(tabPolice, "Idle")

GuiLibrary:CreateSection(tabDelivery, "Delivery Job")
GuiLibrary:CreateButton(tabDelivery, "Join Delivery Job", function()
    joinDeliveryJob()
    notify("Delivery", "Requested delivery job.", 2, "info")
end)
GuiLibrary:CreateLabel(tabDelivery, "Spawn a car & sit in it. Drives the car to deliveries.")
GuiLibrary:CreateToggle(tabDelivery, "Full Auto Delivery (Car)", false, function(s)
    AutoDelivery.Enabled = s
    notify("Delivery", s and "Full auto ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateInput(tabDelivery, "Teleport delay (s) -- higher = safer", function(text)
    local v = tonumber(text)
    if v and v >= 0.1 and v <= 30 then
        AutoDelivery.Delay = v
        notify("Delivery", ("Delay set to %.2fs"):format(v), 2, "success")
    else
        notify("Delivery", "Enter a number 0.1 - 30", 3, "warning")
    end
end)
GuiLibrary:CreateSection(tabDelivery, "Status")
local lblDelivery = GuiLibrary:CreateLabel(tabDelivery, "Idle")

--------------------------------------------------------------------
-- ESP
--------------------------------------------------------------------
GuiLibrary:CreateSection(tabESP, "Player ESP")
GuiLibrary:CreateToggle(tabESP, "Enable ESP", false, function(s) ESP.Enabled = s end)
GuiLibrary:CreateToggle(tabESP, "Box", true, function(s) ESP.Box = s end)
GuiLibrary:CreateToggle(tabESP, "Name", true, function(s) ESP.Name = s end)
GuiLibrary:CreateToggle(tabESP, "Distance", true, function(s) ESP.Distance = s end)
GuiLibrary:CreateToggle(tabESP, "Health Bar", true, function(s) ESP.HealthBar = s end)
GuiLibrary:CreateToggle(tabESP, "Tracers", false, function(s) ESP.Tracer = s end)
GuiLibrary:CreateToggle(tabESP, "Team Check (hide allies)", false, function(s) ESP.TeamCheck = s end)
GuiLibrary:CreateSlider(tabESP, "Max Distance", 100, 5000, 2000, function(v) ESP.MaxDist = v end)

--------------------------------------------------------------------
-- Teleports
--------------------------------------------------------------------
local TELE_LOCATIONS = {
    { "Spawn",            Vector3.new(-300, 16, -1698) },
    { "ATM Area",         Vector3.new(-2060, 16, 3415) },
    { "Criminal Dropoff", Vector3.new(-2543, 16, 4030) },
    { "Crime Scene Area", Vector3.new(1479, 11, 608) },
    { "Dealership",       Vector3.new(-422, 18, -1772) },
    { "Water ATM Area",   Vector3.new(-1055, 14, 5048) },
    { "City Center",      Vector3.new(-1893, 16, 2198) },
}
GuiLibrary:CreateSection(tabTele, "Teleport (car if seated, else you)")

-- Teleporting mid-drive would be undone on the next frame, so re-anchor the
-- router at the new spot instead of fighting it.
local function teleportAndReanchor(pos, label)
    teleportEntity(pos, 5)
    if AutoDrive.Enabled then
        Router.Reset(pos, AutoDrive.Dir)
        resetPath(pos)
    end
    if label then notify("Teleport", "-> " .. label, 2, "info") end
end

GuiLibrary:CreateButton(tabTele, "Nearest Road (live)", function()
    task.spawn(function()
        if not RoadNav.Built then RoadNav.Build() end
        local hrp = getHRP()
        if not hrp then return end
        local i = RoadNav.Nearest(hrp.Position)
        if not i then notify("Teleport", "No road found.", 3, "warning") return end
        teleportAndReanchor(RoadNav.Nodes[i].p, "nearest road")
    end)
end)
for _, e in ipairs(TELE_LOCATIONS) do
    GuiLibrary:CreateButton(tabTele, e[1], function()
        teleportAndReanchor(e[2], e[1])
    end)
end
GuiLibrary:CreateSection(tabTele, "Players")
local teleTargetName = nil
local function playerNameList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    if #names == 0 then names = { "(none)" } end
    return names
end
local teleDropdown = GuiLibrary:CreateDropdown(tabTele, "Target Player", playerNameList(), function(v)
    teleTargetName = v
end)
GuiLibrary:CreateButton(tabTele, "Refresh Players", function()
    local names = playerNameList()
    if teleDropdown and teleDropdown.UpdateOptions then teleDropdown.UpdateOptions(names, true) end
end)
GuiLibrary:CreateButton(tabTele, "Teleport To Player", function()
    local target = teleTargetName and Players:FindFirstChild(teleTargetName)
    local tchar = target and target.Character
    local thrp = tchar and tchar:FindFirstChild("HumanoidRootPart")
    if thrp then
        teleportAndReanchor(thrp.Position + Vector3.new(0, 0, 6), teleTargetName)
    else
        notify("Teleport", "Player not found.", 3, "warning")
    end
end)

--------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------
GuiLibrary:CreateSection(tabMisc, "Auto Claim")
GuiLibrary:CreateToggle(tabMisc, "Auto Claim Rewards (playtime+pending)", false, function(s)
    PlaytimeRewards.Enabled = s
    if s then task.spawn(claimAllPlaytime) end
    notify("Misc", s and "Auto-claim ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateButton(tabMisc, "Claim Playtime Now", function()
    task.spawn(claimAllPlaytime)
    notify("Misc", "Fired playtime claims.", 2, "info")
end)
GuiLibrary:CreateToggle(tabMisc, "Auto Collect Cash Drops", false, function(s)
    CashCollect.Enabled = s
    notify("Misc", s and "Cash drop collect ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateToggle(tabMisc, "Fast Loading (skip load screens)", false, function(s)
    FastLoad.Enabled = s
    if s then pcall(killLoadingScreens) end
    notify("Misc", s and "Fast loading ON" or "OFF", 2, s and "success" or "info")
end)

GuiLibrary:CreateSection(tabMisc, "Vehicle Fly")
GuiLibrary:CreateLabel(tabMisc, "In a car: WASD move, Space up, Shift down.")
GuiLibrary:CreateToggle(tabMisc, "Vehicle Fly", false, function(s)
    VehFly.Enabled = s
    if s then AutoDrive.Enabled = false end
    notify("Misc", s and "Vehicle fly ON" or "OFF", 2, s and "success" or "info")
end)
GuiLibrary:CreateSlider(tabMisc, "Fly Speed", 20, 400, 80, function(v) VehFly.Speed = v end)

GuiLibrary:CreateSection(tabMisc, "Player")
GuiLibrary:CreateToggle(tabMisc, "Walk Speed", false, function(s)
    PlayerMods.WalkEnabled = s
    if not s then local h = getHumanoid() if h then pcall(function() h.WalkSpeed = 16 end) end end
end)
GuiLibrary:CreateSlider(tabMisc, "Walk Speed Value", 16, 200, 32, function(v)
    PlayerMods.WalkSpeed = v
end)

GuiLibrary:CreateSection(tabMisc, "Debug")
GuiLibrary:CreateButton(tabMisc, "Print Status", function()
    print("[DE] road nodes:", #RoadNav.Nodes, "from", RoadNav.Sources, "folders")
    print("[DE] autodrive:", AutoDrive.Status, "node", Router.Node, "dist", math.floor(AutoDrive.Distance))
    if _heistDataCache then
        for id, data in pairs(_heistDataCache) do
            local active, secLeft = computeHeistState(id, data)
            print("[DE] heist", id, active and "OPEN" or "closed", math.floor(secLeft or 0) .. "s")
        end
    end
    notify("Debug", "Printed to console.", 2, "info")
end)

--=====================================================================
--  Status readout
--=====================================================================
task.spawn(function()
    while alive() do
        task.wait(0.5)

        lblCrim1.SetText(("Phase: %s  |  Job: %s"):format(
            AutoFarm.Phase, LocalPlayer:GetAttribute("JobId") or "-"))

        local heistTxt
        if not _heistDataCache then
            heistTxt = "loading"
        else
            local open, id = isAnyHeistOpen()
            heistTxt = open and ((id or "?") .. " OPEN") or "closed"
        end
        lblCrim2.SetText(("Stars %d | Bags %d ($%s) | ATMs %d | Heist %s | Busted %d | Dep %d"):format(
            getStars(), countMoneyBags(), tostring(math.floor(getCurrentBagValue())),
            #listAvailableATMs(), heistTxt, AutoFarm.Stats.ATMs, AutoFarm.Stats.Deposits))
        AutoFarm.ErrorLabel.SetText(AutoFarm.LastError
            and ("Last error: " .. AutoFarm.LastError)
            or ("Failed ATM attempts: " .. tostring(AutoFarm.Stats.Failed)))

        if AutoDrive.Enabled then
            lblCar.SetText(("%s | on this road %d studs | %.1fk driven"):format(
                AutoDrive.Status, math.floor(Router.RunStuds or 0), AutoDrive.Distance / 1000))
        elseif RoadNav.Built then
            lblCar.SetText(("Idle | %d road nodes ready"):format(#RoadNav.Nodes))
        else
            lblCar.SetText("Idle | road graph not built yet")
        end

        local jid = LocalPlayer:GetAttribute("JobId") or "-"

        lblPolice.SetText(("Job %s | Scenes %d (%s) | Arrests %d | Wanted %d | %s"):format(
            jid, Police.CSStats, Police.CrimeScene and Police.CSStatus or "off",
            Police.ArrStats, #getWantedCriminals(),
            Police.Arrest and Police.ArrStatus or "off"))

        local dst = getDeliveryState()
        local dtxt
        if dst then
            local carrying = (dst.ItemsCarried or 0) > 0
            dtxt = carrying and ("Dropoff (carrying %d)"):format(dst.ItemsCarried) or "Pickup"
        else
            dtxt = "no active delivery"
        end
        lblDelivery.SetText(("Job %s | %s | Auto %s"):format(
            jid, dtxt, AutoDelivery.Enabled and "ON" or "off"))
    end
end)

-- Build the road graph in the background so the first toggle is instant.
task.spawn(function()
    task.wait(4)
    local ok = RoadNav.Build()
    if ok then
        print(("[DE] road graph: %d nodes from %d folders"):format(#RoadNav.Nodes, RoadNav.Sources))
    else
        warn(("[DE] road graph looks thin (%d nodes) -- hit Rebuild Road Graph once the map streams in"):format(#RoadNav.Nodes))
    end
end)

-- Everything this run owns, so the next run can remove it. Drawing objects are
-- the dangerous ones: they are not parented to anything, so without this they
-- survive forever and stack up on screen with every reload.
pcall(function()
    if not getgenv then return end
    local myGen = GEN
    local myWindow = window
    getgenv().__DE_CLEANUP = function()
        for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
        table.clear(_conns)
        AutoDrive.Enabled = false
        AutoFarm.Enabled = false
        Police.CrimeScene, Police.Arrest = false, false
        AutoDelivery.Enabled = false
        ESP.Enabled = false
        for plr in pairs(espObjects) do removeESP(plr) end
        pcall(function()
            local mf = myWindow and myWindow.MainFrame
            local sg = mf and mf.Parent
            if sg and sg:IsA("ScreenGui") then sg:Destroy() elseif mf then mf:Destroy() end
        end)
        if getgenv().__DE_GEN == myGen then getgenv().DE = nil end
    end
end)

-- The GUI library fires slider callbacks while it builds them, which overwrites
-- these with whatever position it starts the handle at. Re-assert them once the
-- window is finished; dragging a slider still wins after this.
AutoDrive.Speed = 430
AutoDrive.Hover = math.clamp(AutoDrive.Hover, 0, AutoDrive.HoverMax)
Router.SameRoadCone = math.cos(math.rad(37))
Router.TurnCone     = math.cos(math.rad(120))

-- Handle for debugging and for driving the script from the console:
--   getgenv().DE.StartDrive()   getgenv().DE.StopDrive()
--   getgenv().DE.AutoDrive.Speed = 400
pcall(function()
    if not getgenv then return end
    getgenv().DE = {
        RoadNav    = RoadNav,
        Router     = Router,
        AutoDrive  = AutoDrive,
        AutoFarm   = AutoFarm,
        Police     = Police,
        StartDrive = function()
            AutoDrive.Enabled = false
            if autoDriveStart() then AutoDrive.Enabled = true end
            return AutoDrive.Enabled, AutoDrive.Status
        end,
        StopDrive  = function()
            AutoDrive.Enabled = false
            AutoDrive.Status = "idle"
        end,
        Vehicle    = getDrivenVehicleModel,
    }
end)

notify("Driving Empire", "Loaded", 4, "success")
