-- Cookies Hub (Drive A Kukirin!)
-- RightShift: show/hide (changeable) | X button or _G.CookiesHubKK.Unload(): unload
-- Console: _G.CookiesHubKK.Farm(true / false) | _G.CookiesHubKK.Set("PumpkinFarm", true)

local RS = game:GetService("ReplicatedStorage")
if not (RS:FindFirstChild("ScooterRemotes") and workspace:FindFirstChild("Dealership Kukirin")) then
    warn("[CookiesHub] This script only works in Drive A Kukirin!")
    return
end

if _G.CookiesHubKK and _G.CookiesHubKK.Unload then pcall(_G.CookiesHubKK.Unload) end

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local VirtualUser  = game:GetService("VirtualUser")
local Stats        = game:GetService("Stats")
local lp           = Players.LocalPlayer
local guiParent    = game:GetService("CoreGui")
if gethui then
    local ok, hui = pcall(gethui) -- can throw on some executors
    if ok and typeof(hui) == "Instance" then guiParent = hui end
end

local MB1, TOUCH, MOVE = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement

local Hub = { conns = {} }
_G.CookiesHubKK = Hub

local function bind(c) table.insert(Hub.conns, c) return c end

local function new(class, props)
    local inst = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

local function corner(p, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p }) end

local function tween(inst, props)
    TweenService:Create(inst, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function getHum() local c = lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = lp.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function mounted() return lp:GetAttribute("ScooterMountedForControls") == true end

----------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------
local h0 = getHum()
local Defaults = {
    WalkSpeed  = h0 and h0.WalkSpeed or 16,
    JumpHeight = h0 and h0.JumpHeight or 7.2,
    HipHeight  = h0 and h0.HipHeight or 2,
    FOV        = workspace.CurrentCamera.FieldOfView,
}

local Settings = {
    AutoFarm = false,
    PumpkinFarm = false,
    DeliveryFarm = false,
    PoliceFarm = false,
    AutoQuests = false,
    AutoBuyScooter = false,
    QuickScooter = "Kukirin G4 Max",
    DriveMode = "RACE",
    WheelieAssist = false,
    Headlights = false,
    SmoothBody = lp:GetAttribute("SmoothBody") == true,
    PoliceMode = lp:GetAttribute("PoliceMode") or "MEDIUM",
    Rainbow = false,
    PlayerESP = false,
    ScooterESP = false,
    ESPNames = true,
    ESPDistance = true,
    ESPBoxes = true,
    ESPMaxDistance = 0,
    ESPPlayerColor = 350,
    ESPScooterColor = 200,
    Fullbright = false,
    SpeedBoost = 0,
    WalkSpeed = Defaults.WalkSpeed,
    JumpHeight = Defaults.JumpHeight,
    HipHeight = Defaults.HipHeight,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 60,
    FOV = Defaults.FOV,
    UITransparency = 0,
    ShowProfile = true,
    ShowFPS = true,
    ShowPing = true,
    ToggleKey = "RightShift",
    AntiAFK = true,
    QuickInteract = false,
    HidePlayers = false,
    BlackScreen = false,
    FPSCap = 60,
    AntiLag = false,
    AutoLoad = false,
}

-- Overrides only take effect once the user has changed that value
local touched = {}
local TOUCH_KEYS = { WalkSpeed = true, JumpHeight = true, HipHeight = true, FOV = true, FPSCap = true, DriveMode = true, Headlights = true }

local appliers, refreshers = {}, {}

local function setSetting(key, value)
    Settings[key] = value
    if TOUCH_KEYS[key] then touched[key] = true end
    local apply = appliers[key]
    if apply then apply(value) end
end

----------------------------------------------------------------------
-- Auto farm: spawn the best scooter, ride to open ground, wheelie in circles
-- Simulated key presses never reach the game, so this drives ScooterClient's
-- gamepad input state instead (upvalues of its publishLocalDriveIntent / resetAllInputs).
----------------------------------------------------------------------
local Remotes = RS.ScooterRemotes
local UP_STEER, UP_PLAYER, UP_THROTTLE, UP_BRAKE, UP_WHEELIE = 3, 4, 6, 8, 10 -- publishLocalDriveIntent
local UP_KEY_WHEELIE, UP_WHEELIE_PULSE = 9, 11 -- Shift's wheelie flag and its 0.45s pulse timer
local UP_DISMOUNT = 5 -- resetAllInputs (the Space / dismount flag)

local function findClosure(name, check)
    for _, f in ipairs(getgc(false)) do
        if type(f) == "function" and islclosure(f) and debug.info(f, "n") == name and pcall(check, f) then return f end
    end
end

local driveIntent, resetInputs
if getgc and islclosure and debug.getupvalue and debug.setupvalue then
    driveIntent = findClosure("publishLocalDriveIntent", function(f)
        assert(debug.getupvalue(f, UP_PLAYER) == lp)
        assert(type(debug.getupvalue(f, UP_STEER)) == "number")
        assert(type(debug.getupvalue(f, UP_THROTTLE)) == "number")
        assert(type(debug.getupvalue(f, UP_BRAKE)) == "number")
        assert(type(debug.getupvalue(f, UP_WHEELIE)) == "boolean")
        assert(type(debug.getupvalue(f, UP_KEY_WHEELIE)) == "boolean")
        assert(type(debug.getupvalue(f, UP_WHEELIE_PULSE)) == "number")
    end)
    resetInputs = findClosure("resetAllInputs", function(f)
        assert(type(debug.getupvalue(f, UP_DISMOUNT)) == "boolean")
    end)
end
local canFarm = driveIntent ~= nil and resetInputs ~= nil and fireproximityprompt ~= nil

-- The teleporting farms (pumpkin, delivery) take turns with the character; the money farm
-- only rides while neither has it
local busyBy
local function claim(who)
    if busyBy == nil or busyBy == who then busyBy = who return true end
    return false
end
local function release(who) if busyBy == who then busyBy = nil end end

-- Move you (and your scooter, if you're riding: the whole assembly moves together)
local function teleport(pos)
    local root = getRoot()
    if not root then return end
    local asm = root.AssemblyRootPart or root
    asm.CFrame = CFrame.new(pos)
    asm.AssemblyLinearVelocity = Vector3.zero
    asm.AssemblyAngularVelocity = Vector3.zero
end

local function moneyFarming() return Settings.AutoFarm and not Settings.DeliveryFarm and busyBy == nil end

local driving = false
local function setDrive(wheelie, throttle, steer, brake)
    debug.setupvalue(driveIntent, UP_WHEELIE, wheelie)
    debug.setupvalue(driveIntent, UP_THROTTLE, throttle)
    debug.setupvalue(driveIntent, UP_STEER, steer)
    debug.setupvalue(driveIntent, UP_BRAKE, brake or 0)
    pcall(driveIntent)
end

-- Wheelie angle: how far the scooter's nose points above horizontal (ignores leaning into turns)
local function scooterTilt()
    local root = getRoot()
    local asm = root and root.AssemblyRootPart
    if not asm then return 0 end
    return math.deg(math.asin(math.clamp(asm.CFrame.LookVector.Y, -1, 1)))
end

-- Wheelie angle per scooter, found by testing each one in circles at full throttle:
-- the steadiest angle that keeps top speed without looping out
local PROFILES = {
    ["Kukirin G4 Max"]    = 40,
    ["Kukirin G3 Pro"]    = 38,
    ["Kukirin G4"]        = 35,
    ["KuKirin G2 Master"] = 35,
    ["Kukirin G2 Ultra"]  = 35,
    ["Kukirin G3"]        = 35,
    ["Kukirin G2"]        = 35,
    ["Kukirin S1 Max"]    = 35,
}
local DEFAULT_ANGLE = 35
local LEAD = 0.18 -- seconds of tilt prediction, on top of ping

-- Flat open ground with nothing in the way for 350 studs. Pulling away from here on full
-- right lock spirals out into a steady ~226-stud circle centred on the spot (at top speed in
-- a wheelie that's as tight as it turns); steering corrections only knock the wheelie off.
local FARM_SPOT = Vector3.new(3086, 8, -2683)
local LOST_DISTANCE = 320

-- Name of the scooter you're riding (your root part joins the scooter's assembly when mounted)
local function ridingName()
    local root = getRoot()
    local asm = root and root.AssemblyRootPart
    local model = asm and asm ~= root and asm:FindFirstAncestorOfClass("Model")
    return model and model.Name
end

local WHEELIE_KEYS = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.LeftControl }
local assisting = false
local lastTilt, tiltRate = 0, 0
bind(RunService.Heartbeat:Connect(function(dt)
    if not driveIntent then return end
    local tilt = scooterTilt()
    tiltRate = tiltRate * 0.7 + (tilt - lastTilt) / dt * 0.3
    lastTilt = tilt

    -- Hold the wheelie at the scooter's angle: holding it flat out loops the scooter over
    -- (~78°), so above the angle let off wheelie and brake while the nose still rises. The
    -- server runs the physics, so act on where the tilt will be once the input lands.
    local angle = PROFILES[ridingName()] or DEFAULT_ANGLE
    local predicted = tilt + tiltRate * (LEAD + lp:GetNetworkPing() * 2)
    local over = predicted >= angle
    -- pulling away the motor lifts the nose fastest, so brake early on a fast rise
    local brake = over and (tilt > angle and tiltRate > 0 or tiltRate > 40) and 1 or 0

    local active = moneyFarming() and mounted()
    if active then
        local moving = getRoot().AssemblyRootPart.AssemblyLinearVelocity.Magnitude > 30
        setDrive(moving and not over, 1, 1, brake)
    elseif driving then
        setDrive(false, 0, 0)
    end
    driving = active

    -- Wheelie assist: same angle hold on your own Shift wheelies (your other keys are untouched)
    local held = false
    if Settings.WheelieAssist and not active and mounted() then
        for _, k in ipairs(WHEELIE_KEYS) do held = held or UIS:IsKeyDown(k) end
    end
    if held then
        debug.setupvalue(driveIntent, UP_KEY_WHEELIE, not over)
        if over then debug.setupvalue(driveIntent, UP_WHEELIE_PULSE, 0) end
        debug.setupvalue(driveIntent, UP_BRAKE, brake)
        pcall(driveIntent)
    elseif assisting then
        debug.setupvalue(driveIntent, UP_KEY_WHEELIE, false)
        debug.setupvalue(driveIntent, UP_BRAKE, 0)
        pcall(driveIntent)
    end
    assisting = held
end))

local function goToFarmSpot() teleport(FARM_SPOT) end

-- Fastest owned scooter (owner-only ones show up in OwnedScooters as false)
local function bestScooter()
    local owned, templates = lp:FindFirstChild("OwnedScooters"), RS:FindFirstChild("Scooters")
    if not (owned and templates) then return end
    local best, bestSpeed
    for _, v in ipairs(owned:GetChildren()) do
        local t = templates:FindFirstChild(v.Name)
        local speed = t and t:GetAttribute("TopSpeedKmh")
        if v.Value == true and speed and (not bestSpeed or speed > bestSpeed) then best, bestSpeed = v.Name, speed end
    end
    return best
end

local function myScooter(name)
    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") and m.Name == name and m:GetAttribute("OwnerUserId") == lp.UserId then return m end
    end
end

local function waitFor(cond, timeout)
    local t0 = os.clock()
    while not cond() do
        if Hub.unloaded or os.clock() - t0 > timeout then return false end
        task.wait(0.2)
    end
    return true
end

local function dismount()
    debug.setupvalue(resetInputs, UP_DISMOUNT, true)
    waitFor(function() return not mounted() end, 3)
    debug.setupvalue(resetInputs, UP_DISMOUNT, false)
end

-- Get on one of your scooters, spawning it the same way the spawn menu does
local function mountScooter(name)
    if mounted() then
        if ridingName() == name then return end
        dismount() -- the game won't spawn a scooter while you're riding one
        task.wait(0.5)
    end
    local m = myScooter(name)
    if not m then
        Remotes.SpawnScooter:FireServer(name)
        if not waitFor(function() m = myScooter(name) return m and m:FindFirstChild("MountPrompt", true) ~= nil end, 5) then return end
        task.wait(0.5)
    end
    for _ = 1, 5 do
        local prompt = m.Parent and m:FindFirstChild("MountPrompt", true)
        local root = getRoot()
        if prompt and root then
            -- after a crash you can land far away; the prompt only works up close
            if (root.Position - m:GetPivot().Position).Magnitude > 8 then
                root.CFrame = m:GetPivot() + Vector3.new(0, 4, 0)
                task.wait(0.3)
            end
            fireproximityprompt(prompt)
        end
        if waitFor(mounted, 0.8) then break end
    end
    return mounted()
end

local function mountBest()
    local name = bestScooter()
    if name and mountScooter(name) then goToFarmSpot() end
end

task.spawn(function()
    while not Hub.unloaded do
        if moneyFarming() and canFarm then
            local root = getRoot()
            if not mounted() or ridingName() ~= bestScooter() then
                pcall(mountBest) -- also recovers after a crash throws you off
            elseif root and (root.Position - FARM_SPOT).Magnitude > LOST_DISTANCE then
                goToFarmSpot()
            end
        end
        task.wait(1)
    end
end)

----------------------------------------------------------------------
-- Pumpkin farm: on Pumpkin Night, land on every pumpkin in turn
-- (the server collects any pumpkin you get within 8 studs of)
----------------------------------------------------------------------
local okConfig, HalloweenConfig = pcall(function() return require(RS:WaitForChild("HalloweenConfig", 5)) end)
if not okConfig then HalloweenConfig = nil end
local PUMPKIN_DELAY = 0.5

local function pumpkinsLeft()
    local folder = workspace:FindFirstChild("PumpkinNight")
    local left = {}
    if not folder then return left end
    for _, p in ipairs(folder:GetChildren()) do
        -- the game hides the pumpkins you've already collected
        if p:IsA("BasePart") and p.Transparency < 1 then table.insert(left, p) end
    end
    return left
end

task.spawn(function()
    while not Hub.unloaded do
        local left = Settings.PumpkinFarm and pumpkinsLeft() or {}
        if #left > 0 and claim("pumpkin") then
            for _, p in ipairs(left) do
                if not Settings.PumpkinFarm or Hub.unloaded then break end
                if p.Parent and p.Transparency < 1 then
                    teleport(p.Position + Vector3.new(0, p.Size.Y / 2 + 3, 0))
                end
                task.wait(PUMPKIN_DELAY)
            end
            release("pumpkin")
        end
        task.wait(1)
    end
end)

----------------------------------------------------------------------
-- Session stats (shared by the farms below and the Farm tab)
----------------------------------------------------------------------
local Session = {
    startedAt = os.clock(),
    startCash = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Cash") and lp.leaderstats.Cash.Value or 0,
    startTokens = tonumber(lp:GetAttribute("PumpkinTokens")) or 0,
    deliveries = 0,
    quests = 0,
    bought = 0,
}

----------------------------------------------------------------------
-- Delivery farm: take a job, go to the customer, hand it over. The server won't accept a
-- delivery sooner than the trip would take (~60 studs/s), so it keeps offering until it does.
----------------------------------------------------------------------
local deliveryStatus = ""
bind(Remotes.DeliveryEvent.OnClientEvent:Connect(function(kind)
    if kind == "Delivered" then Session.deliveries += 1 end
end))

local function deliveryStep()
    local job = workspace:FindFirstChild("DeliveryJOB", true)
    local target = lp:GetAttribute("DeliveryTarget")
    if not target then
        local cooldown = (lp:GetAttribute("DeliveryCooldownUntil") or 0) - workspace:GetServerTimeNow()
        if cooldown > 0 then
            deliveryStatus = string.format("Next job in %ds", math.ceil(cooldown))
            return
        end
        local prompt = job and job:FindFirstChild("DeliveryJobPrompt", true)
        if not prompt then deliveryStatus = "Can't find the delivery job board" return end
        deliveryStatus = "Taking a job..."
        teleport(job.Position + Vector3.new(0, 4, 4))
        task.wait(0.6)
        fireproximityprompt(prompt)
        waitFor(function() return lp:GetAttribute("DeliveryTarget") ~= nil end, 5)
        return
    end
    local npc = workspace:FindFirstChild(target, true)
    local prompt = npc and npc:FindFirstChild("DeliverPrompt", true)
    if not prompt then deliveryStatus = "Can't find the customer" return end
    deliveryStatus = "Delivering to " .. tostring(lp:GetAttribute("DeliveryTargetName") or target) .. " ($" .. tostring(lp:GetAttribute("DeliveryPay") or "?") .. ")"
    local pos = npc:IsA("Model") and npc:GetPivot().Position or npc.Position
    teleport(pos + Vector3.new(0, 4, 4))
    task.wait(0.6)
    local t0 = os.clock()
    while Settings.DeliveryFarm and lp:GetAttribute("DeliveryTarget") == target and os.clock() - t0 < 40 do
        fireproximityprompt(prompt)
        task.wait(2)
    end
end

task.spawn(function()
    while not Hub.unloaded do
        if Settings.DeliveryFarm and claim("delivery") then
            pcall(deliveryStep)
            release("delivery")
        elseif not Settings.DeliveryFarm then
            deliveryStatus = ""
        end
        task.wait(1)
    end
end)

----------------------------------------------------------------------
-- Auto quests: refresh progress and claim whatever is finished
----------------------------------------------------------------------
task.spawn(function()
    while not Hub.unloaded do
        local menu = Settings.AutoQuests and lp.PlayerGui:FindFirstChild("QuestMenu")
        local list = menu and menu:FindFirstChild("Main") and menu.Main:FindFirstChild("Quests") and menu.Main.Quests:FindFirstChild("List")
        if list then
            Remotes.QuestRemote:FireServer("GetData")
            task.wait(2)
            for _, card in ipairs(list:GetChildren()) do
                local goal, progress = card:GetAttribute("Goal"), card:GetAttribute("Progress")
                if card:GetAttribute("QuestId") and not card:GetAttribute("Claimed") and goal and progress and progress >= goal then
                    Remotes.QuestRemote:FireServer("Claim", card:GetAttribute("Category"), card:GetAttribute("QuestId"))
                    Session.quests += 1
                    task.wait(1)
                end
            end
        end
        task.wait(20)
    end
end)

----------------------------------------------------------------------
-- Auto buy: buy any faster scooter you can afford (the money farm then switches to it)
----------------------------------------------------------------------
task.spawn(function()
    while not Hub.unloaded do
        local owned, templates = lp:FindFirstChild("OwnedScooters"), RS:FindFirstChild("Scooters")
        local cash = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Cash")
        if Settings.AutoBuyScooter and owned and templates and cash then
            local best = bestScooter()
            local bestSpeed = best and templates:FindFirstChild(best) and templates[best]:GetAttribute("TopSpeedKmh") or 0
            local pick, pickSpeed
            for _, t in ipairs(templates:GetChildren()) do
                local have = owned:FindFirstChild(t.Name)
                local price, speed = t:GetAttribute("ShopPrice"), t:GetAttribute("TopSpeedKmh")
                local forSale = t:GetAttribute("HideFromShop") ~= true and t:GetAttribute("OwnerOnlyUserId") == nil
                if forSale and not (have and have.Value == true) and price and speed and price <= cash.Value
                    and speed > bestSpeed and (not pickSpeed or speed > pickSpeed) then
                    pick, pickSpeed = t.Name, speed
                end
            end
            if pick then
                local ok, success = pcall(function() return Remotes.PurchaseScooter:InvokeServer(pick) end)
                if ok and success then Session.bought += 1 end
            end
        end
        task.wait(15)
    end
end)

----------------------------------------------------------------------
-- Scooter settings the game itself keeps (drive mode, headlights) are re-applied whenever
-- you get on a scooter, once you've picked them here
----------------------------------------------------------------------
local DRIVE_MODES = { "ECO", "SPORT", "RACE" }
task.spawn(function()
    while not Hub.unloaded do
        local model = mounted() and getRoot() and getRoot().AssemblyRootPart:FindFirstAncestorOfClass("Model")
        if model and model:GetAttribute("OwnerUserId") == lp.UserId then
            local want = table.find(DRIVE_MODES, Settings.DriveMode)
            local have = tonumber(model:GetAttribute("DriveMode"))
            if touched.DriveMode and want and have and want ~= have then
                Remotes.DriveMode:FireServer(want > have and 1 or -1) -- the game steps one mode at a time
            end
            if touched.Headlights and model:GetAttribute("HasLights") and (model:GetAttribute("HeadlightsOn") == true) ~= Settings.Headlights then
                Remotes.ToggleHeadlight:FireServer()
            end
        end
        task.wait(1)
    end
end)

appliers.SmoothBody = function(on) Remotes.BodyStyleToggle:FireServer("Set", on) end
appliers.PoliceMode = function(mode) Remotes.PoliceMode:FireServer("Set", mode) end

----------------------------------------------------------------------
-- Rainbow scooter: you don't own the game's rainbow passes, so this one is only on your screen
----------------------------------------------------------------------
local rainbowSaved = {}
local function restoreRainbow()
    for part, color in pairs(rainbowSaved) do
        if part.Parent then part.Color = color end
    end
    rainbowSaved = {}
end
appliers.Rainbow = function(on) if not on then restoreRainbow() end end
bind(RunService.Heartbeat:Connect(function()
    if not Settings.Rainbow then return end
    local root = getRoot()
    local model = mounted() and root and root.AssemblyRootPart:FindFirstAncestorOfClass("Model")
    if not model then return end
    local color = Color3.fromHSV(os.clock() * 0.25 % 1, 0.85, 1)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            if rainbowSaved[part] == nil then rainbowSaved[part] = part.Color end
            part.Color = color
        end
    end
end))

----------------------------------------------------------------------
-- ESP: names and distances through walls for players and their scooters
----------------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "CookiesHubESP"
local espTags = {} -- target instance -> { gui, label, highlight }

local function espTag(target, adornee)
    local tag = espTags[target]
    if not tag then
        local gui = new("BillboardGui", {
            Adornee = adornee, AlwaysOnTop = true, Size = UDim2.fromOffset(200, 34),
            StudsOffset = Vector3.new(0, 3, 0), Parent = espFolder,
        })
        local label = new("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13,
            TextStrokeTransparency = 0.4, Parent = gui,
        })
        local highlight = new("Highlight", {
            Adornee = target, FillTransparency = 0.75,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = espFolder,
        })
        tag = { gui = gui, label = label, highlight = highlight }
        espTags[target] = tag
    end
    tag.seen = true
    return tag
end

local function clearEsp(keep)
    for target, tag in pairs(espTags) do
        if not (keep and tag.seen and target.Parent) then
            tag.gui:Destroy()
            tag.highlight:Destroy()
            espTags[target] = nil
        end
        tag.seen = false
    end
end

-- Text, colour and box all follow the Visuals toggles, re-applied each pass
local function paintTag(tag, color, name, dist)
    local text = Settings.ESPNames and name or ""
    if Settings.ESPDistance then
        text = (text == "" and "" or text .. "  ") .. string.format("[%dm]", dist // 1)
    end
    tag.label.Text = text
    tag.label.TextColor3 = color
    tag.highlight.FillColor = color
    tag.highlight.OutlineColor = color
    tag.highlight.Enabled = Settings.ESPBoxes
end

task.spawn(function()
    while not Hub.unloaded do
        local root = getRoot()
        if root and (Settings.PlayerESP or Settings.ScooterESP) then
            espFolder.Parent = guiParent
            local maxD = Settings.ESPMaxDistance
            local playerColor = Color3.fromHSV(Settings.ESPPlayerColor / 360, 0.85, 1)
            local scooterColor = Color3.fromHSV(Settings.ESPScooterColor / 360, 0.85, 1)
            if Settings.PlayerESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    local head = p ~= lp and p.Character and p.Character:FindFirstChild("Head")
                    local dist = head and (head.Position - root.Position).Magnitude
                    if head and (maxD == 0 or dist <= maxD) then
                        paintTag(espTag(p.Character, head), playerColor, p.DisplayName, dist)
                    end
                end
            end
            if Settings.ScooterESP then
                for _, m in ipairs(workspace:GetChildren()) do
                    local owner = m:IsA("Model") and m:GetAttribute("OwnerUserId")
                    local body = owner and owner ~= lp.UserId and (m.PrimaryPart or m:FindFirstChild("Hull"))
                    local dist = body and (body.Position - root.Position).Magnitude
                    if body and (maxD == 0 or dist <= maxD) then
                        paintTag(espTag(m, body), scooterColor,
                            string.format("%s's %s", tostring(m:GetAttribute("OwnerName")), m:GetAttribute("DisplayName") or m.Name), dist)
                    end
                end
            end
            clearEsp(true)
        else
            clearEsp(false)
        end
        task.wait(0.3)
    end
end)

----------------------------------------------------------------------
-- Movement
----------------------------------------------------------------------
local noclipSaved = {}

appliers.Noclip = function(on)
    if on then return end
    for part in pairs(noclipSaved) do
        if part.Parent then part.CanCollide = true end
    end
    noclipSaved = {}
end

appliers.Fly = function(on)
    if not on then
        local h = getHum()
        if h then h.PlatformStand = false end
    end
end

appliers.FOV = function(v) workspace.CurrentCamera.FieldOfView = v end

bind(RunService.Stepped:Connect(function()
    if not Settings.Noclip then return end
    local c = lp.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            noclipSaved[p] = true
            p.CanCollide = false
        end
    end
end))

bind(UIS.JumpRequest:Connect(function()
    if not Settings.InfJump or mounted() then return end
    local h = getHum()
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

local function flyDirection(h)
    local cf = workspace.CurrentCamera.CFrame
    local dir = Vector3.zero
    local K = Enum.KeyCode
    if UIS:IsKeyDown(K.W) then dir += cf.LookVector end
    if UIS:IsKeyDown(K.S) then dir -= cf.LookVector end
    if UIS:IsKeyDown(K.D) then dir += cf.RightVector end
    if UIS:IsKeyDown(K.A) then dir -= cf.RightVector end
    if dir.Magnitude == 0 then dir = h.MoveDirection end
    if UIS:IsKeyDown(K.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(K.LeftControl) then dir -= Vector3.yAxis end
    return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

bind(RunService.Heartbeat:Connect(function(dt)
    local h, root = getHum(), getRoot()
    if not (h and root) then return end
    local onScooter = mounted()

    if not onScooter then
        if touched.WalkSpeed then h.WalkSpeed = Settings.WalkSpeed end
        if touched.JumpHeight then h.UseJumpPower = false; h.JumpHeight = Settings.JumpHeight end
        if touched.HipHeight then h.HipHeight = Settings.HipHeight end
    end

    if onScooter and Settings.SpeedBoost > 0 and (Settings.AutoFarm or UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up)) then
        local look = root.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.1 then
            local asm = root.AssemblyRootPart or root
            asm.AssemblyLinearVelocity += flat.Unit * Settings.SpeedBoost * dt
        end
    end

    if Settings.Fly and not onScooter then
        h.PlatformStand = true
        root.AssemblyLinearVelocity = flyDirection(h) * Settings.FlySpeed
    end
end))

bind(RunService.RenderStepped:Connect(function()
    if touched.FOV then workspace.CurrentCamera.FieldOfView = Settings.FOV end
end))

local tpTool
local function giveTeleportTool()
    if tpTool and tpTool.Parent then return end
    tpTool = new("Tool", { Name = "Click Teleport", RequiresHandle = false, CanBeDropped = false, Parent = lp:WaitForChild("Backpack") })
    tpTool.Activated:Connect(function()
        local root = getRoot()
        if not root or mounted() then return end
        local hit = lp:GetMouse().Hit
        if hit then root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) * root.CFrame.Rotation end
    end)
end

----------------------------------------------------------------------
-- Misc / performance
----------------------------------------------------------------------
bind(lp.Idled:Connect(function()
    if not Settings.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end))

local promptSaved = {}
local function quickPrompt(p)
    if not p:IsA("ProximityPrompt") then return end
    if promptSaved[p] == nil then promptSaved[p] = p.HoldDuration end
    p.HoldDuration = 0
end
appliers.QuickInteract = function(on)
    if on then
        for _, d in ipairs(workspace:GetDescendants()) do quickPrompt(d) end
    else
        for p, v in pairs(promptSaved) do
            if p.Parent then p.HoldDuration = v end
        end
        promptSaved = {}
    end
end
bind(workspace.DescendantAdded:Connect(function(d)
    if Settings.QuickInteract then quickPrompt(d) end
end))

local hiddenParts = {}
appliers.HidePlayers = function(on)
    if on then return end
    for part in pairs(hiddenParts) do
        if part.Parent then part.LocalTransparencyModifier = 0 end
    end
    hiddenParts = {}
end
task.spawn(function()
    while not Hub.unloaded do
        if Settings.HidePlayers then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    for _, d in ipairs(p.Character:GetDescendants()) do
                        if d:IsA("BasePart") or d:IsA("Decal") then
                            hiddenParts[d] = true
                            d.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

appliers.BlackScreen = function(on) RunService:Set3dRenderingEnabled(not on) end

appliers.FPSCap = function(v) if setfpscap then setfpscap(v) end end

local LAG_FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true, Beam = true }
local lagFx, lagShadows = {}, nil
local function killFx(d)
    if LAG_FX[d.ClassName] and d.Enabled then
        lagFx[d] = true
        d.Enabled = false
    end
end
appliers.AntiLag = function(on)
    if on then
        if lagShadows == nil then lagShadows = Lighting.GlobalShadows end
        Lighting.GlobalShadows = false
        for _, d in ipairs(workspace:GetDescendants()) do killFx(d) end
    else
        if lagShadows ~= nil then Lighting.GlobalShadows = lagShadows; lagShadows = nil end
        for d in pairs(lagFx) do
            if d.Parent then d.Enabled = true end
        end
        lagFx = {}
    end
end
bind(workspace.DescendantAdded:Connect(function(d)
    if Settings.AntiLag then killFx(d) end
end))

----------------------------------------------------------------------
-- Fullbright: hold the map fully lit (the game runs its own day/night, so re-apply each frame)
----------------------------------------------------------------------
local fbSaved
appliers.Fullbright = function(on)
    if on then
        fbSaved = fbSaved or {
            Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        }
    elseif fbSaved then
        Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd = fbSaved.Brightness, fbSaved.ClockTime, fbSaved.FogEnd
        Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient = fbSaved.GlobalShadows, fbSaved.Ambient, fbSaved.OutdoorAmbient
        fbSaved = nil
    end
end
bind(RunService.Heartbeat:Connect(function()
    if not Settings.Fullbright then return end
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1e9
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end))

----------------------------------------------------------------------
-- Theme (purple)
----------------------------------------------------------------------
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local Theme = {
    Bg = rgb(18, 12, 28), Panel = rgb(29, 19, 43), Row = rgb(40, 27, 58),
    Off = rgb(78, 55, 105), Accent = rgb(174, 92, 255), Text = rgb(244, 236, 255), Sub = rgb(174, 153, 198),
}

local painted = {}
local function paint(inst, prop, role)
    table.insert(painted, { inst = inst, prop = prop, role = role })
    inst[prop] = Theme[role]
    return inst
end

----------------------------------------------------------------------
-- Tags (profile / FPS / ping)
----------------------------------------------------------------------
local tagGui = new("ScreenGui", { Name = "CookiesHubTags", ResetOnSpawn = false, DisplayOrder = 997, Parent = guiParent })
local tagHolder = new("Frame", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 52), Size = UDim2.fromOffset(220, 0),
    AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = tagGui,
})
new("UIListLayout", { Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Parent = tagHolder })

local function makeTag(order)
    local l = new("TextLabel", {
        Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Font = Enum.Font.GothamBold, TextSize = 12,
        LayoutOrder = order, BackgroundTransparency = 0.15, Parent = tagHolder,
    })
    paint(l, "BackgroundColor3", "Panel")
    paint(l, "TextColor3", "Text")
    corner(l, 6)
    new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = l })
    return l
end
local profileTag, fpsTag, pingTag = makeTag(1), makeTag(2), makeTag(3)
profileTag.Text = "@" .. lp.Name

local frames = 0
bind(RunService.RenderStepped:Connect(function() frames += 1 end))
task.spawn(function()
    while not Hub.unloaded do
        profileTag.Visible = Settings.ShowProfile
        fpsTag.Visible = Settings.ShowFPS
        pingTag.Visible = Settings.ShowPing
        fpsTag.Text = "FPS " .. frames * 2
        frames = 0
        local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if not ok then ping = lp:GetNetworkPing() * 1000 end
        pingTag.Text = "Ping " .. math.floor(ping) .. " ms"
        task.wait(0.5)
    end
end)

----------------------------------------------------------------------
-- UI
----------------------------------------------------------------------
local ui = new("ScreenGui", { Name = "CookiesHubUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, Parent = guiParent })

local WIN_W, WIN_H = 560, 460
local win = new("Frame", {
    Size = UDim2.fromOffset(WIN_W, WIN_H), Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2),
    BorderSizePixel = 0, ClipsDescendants = true, Parent = ui,
})
paint(win, "BackgroundColor3", "Bg")
corner(win, 10)
paint(new("UIStroke", { Transparency = 0.55, Parent = win }), "Color", "Accent")

local top = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = win })
paint(new("Frame", { Size = UDim2.fromOffset(4, 16), Position = UDim2.fromOffset(14, 12), BorderSizePixel = 0, Parent = top }), "BackgroundColor3", "Accent")
paint(new("TextLabel", {
    Text = "COOKIES HUB  |  DRIVE A KUKIRIN", Font = Enum.Font.GothamBlack, TextSize = 14,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(26, 0), Size = UDim2.new(0, 320, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left, Parent = top,
}), "TextColor3", "Text")
local keyHint = paint(new("TextLabel", {
    Font = Enum.Font.Gotham, TextSize = 11, BackgroundTransparency = 1,
    Position = UDim2.new(1, -200, 0, 0), Size = UDim2.new(0, 126, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Right, Parent = top,
}), "TextColor3", "Sub")

local function topButton(text, x, role)
    local b = new("TextButton", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false,
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, x, 0, 7), Parent = top,
    })
    paint(b, "BackgroundColor3", role)
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    return b
end
local minBtn   = topButton("–", -64, "Row")
local closeBtn = topButton("×", -34, "Accent")

local body = new("Frame", { Position = UDim2.fromOffset(0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1, Parent = win })
local sidebar = new("Frame", { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(0, 124, 1, -10), BorderSizePixel = 0, Parent = body })
paint(sidebar, "BackgroundColor3", "Panel")
corner(sidebar, 8)
new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar })
new("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = sidebar })
local pages = new("Frame", { Position = UDim2.fromOffset(144, 0), Size = UDim2.new(1, -154, 1, -10), BackgroundTransparency = 1, Parent = body })

local tabs, sideOrder, currentTab, rowFrames = {}, 0, nil, {}

local function selectTab(sel)
    currentTab = sel
    for _, t in ipairs(tabs) do
        local on = t == sel
        t.page.Visible = on
        tween(t.btn, { BackgroundColor3 = on and Theme.Accent or Theme.Panel })
        t.btn.TextColor3 = on and Theme.Text or Theme.Sub
    end
end

local function SideHeader(text)
    sideOrder += 1
    paint(new("TextLabel", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 10, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = sideOrder, Parent = sidebar,
    }), "TextColor3", "Sub")
end

local function Tab(name)
    sideOrder += 1
    local btn = new("TextButton", {
        Text = name, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Panel, TextColor3 = Theme.Sub, LayoutOrder = sideOrder, Parent = sidebar,
    })
    corner(btn, 6)
    local page = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = pages,
    })
    paint(page, "ScrollBarImageColor3", "Accent")
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
    new("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6), Parent = page })
    local t = { btn = btn, page = page, order = 0 }
    btn.MouseButton1Click:Connect(function() selectTab(t) end)
    table.insert(tabs, t)
    return t
end

local function row(t, h)
    t.order += 1
    local r = new("Frame", { Size = UDim2.new(1, 0, 0, h or 34), BorderSizePixel = 0, LayoutOrder = t.order, Parent = t.page })
    paint(r, "BackgroundColor3", "Row")
    corner(r, 6)
    new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.94, Parent = r })
    table.insert(rowFrames, r)
    return r
end

local function rowLabel(r, text)
    return paint(new("TextLabel", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 13, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 0, 34), TextXAlignment = Enum.TextXAlignment.Left, Parent = r,
    }), "TextColor3", "Text")
end

local function Section(t, text)
    t.order += 1
    paint(new("TextLabel", {
        Text = text:upper(), Font = Enum.Font.GothamBold, TextSize = 11, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom,
        LayoutOrder = t.order, Parent = t.page,
    }), "TextColor3", "Accent")
end

local function Note(t, text)
    t.order += 1
    return paint(new("TextLabel", {
        Text = text, Font = Enum.Font.Gotham, TextSize = 11, BackgroundTransparency = 1, TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = t.order, Parent = t.page,
    }), "TextColor3", "Sub")
end

local function Toggle(t, text, key)
    local r = row(t)
    rowLabel(r, text)
    local sw = new("Frame", { Size = UDim2.fromOffset(38, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = Theme.Off, Parent = r })
    corner(sw, 10)
    local knob = new("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), Parent = sw })
    corner(knob, 8)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = r })
    local function render()
        local on = Settings[key]
        tween(sw, { BackgroundColor3 = on and Theme.Accent or Theme.Off })
        tween(knob, { Position = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) })
    end
    hit.MouseButton1Click:Connect(function()
        setSetting(key, not Settings[key])
        render()
    end)
    render()
    table.insert(refreshers, render)
end

local function Slider(t, text, key, min, max, step, fmt)
    local r = row(t, 50)
    rowLabel(r, text)
    local value = paint(new("TextLabel", {
        Font = Enum.Font.GothamBold, TextSize = 12, BackgroundTransparency = 1,
        Position = UDim2.new(1, -112, 0, 0), Size = UDim2.fromOffset(100, 34), TextXAlignment = Enum.TextXAlignment.Right, Parent = r,
    }), "TextColor3", "Sub")
    local bar = paint(new("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 34), BorderSizePixel = 0, Parent = r }), "BackgroundColor3", "Off")
    corner(bar, 3)
    local fill = paint(new("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = bar }), "BackgroundColor3", "Accent")
    corner(fill, 3)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0.5, -11), Parent = bar })
    local function render()
        local v = Settings[key]
        fill.Size = UDim2.fromScale(math.clamp((v - min) / (max - min), 0, 1), 1)
        value.Text = fmt(v)
    end
    local dragging = false
    local function update(x)
        local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        setSetting(key, math.clamp(math.floor((min + a * (max - min)) / step + 0.5) * step, min, max))
        render()
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = true; update(i.Position.X) end
    end)
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == MOVE or i.UserInputType == TOUCH) then update(i.Position.X) end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = false end
    end))
    render()
    table.insert(refreshers, render)
end

local function Cycle(t, text, key, options)
    local r = row(t)
    rowLabel(r, text)
    local b = new("TextButton", {
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
        Size = UDim2.fromOffset(110, 22), Position = UDim2.new(1, -120, 0.5, -11), Parent = r,
    })
    paint(b, "BackgroundColor3", "Off")
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    local function render() b.Text = tostring(Settings[key]) end
    b.MouseButton1Click:Connect(function()
        local idx = table.find(options, Settings[key]) or 0
        setSetting(key, options[idx % #options + 1])
        render()
    end)
    render()
    table.insert(refreshers, render)
end

-- Click to rebind: shows "Press a new button", then the next key you press becomes the key.
-- capturingKey keeps that same keypress from also reaching the toggle-UI handler below.
local capturingKey = false
local function Keybind(t, text, key)
    local r = row(t)
    rowLabel(r, text)
    local b = new("TextButton", {
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
        Size = UDim2.fromOffset(110, 22), Position = UDim2.new(1, -120, 0.5, -11), Parent = r,
    })
    paint(b, "BackgroundColor3", "Off")
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    local listening = false
    local function render() b.Text = listening and "Press a new button" or tostring(Settings[key]) end
    b.MouseButton1Click:Connect(function()
        listening = not listening
        capturingKey = listening
        render()
    end)
    bind(UIS.InputBegan:Connect(function(i)
        if not listening or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
        listening = false
        setSetting(key, i.KeyCode.Name)
        render()
        task.defer(function() capturingKey = false end)
    end))
    render()
    table.insert(refreshers, render)
end

local function Button(t, text, role, cb)
    t.order += 1
    local b = new("TextButton", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = true,
        Size = UDim2.new(1, 0, 0, 34), LayoutOrder = t.order, Parent = t.page,
    })
    paint(b, "BackgroundColor3", role)
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    b.MouseButton1Click:Connect(cb)
end

-- Refresh every control from Settings (used after loading a config / console Set)
local function repaint()
    for _, r in ipairs(refreshers) do r() end
    if currentTab then selectTab(currentTab) end
end

-- Console access: same effect as using the UI
function Hub.Set(key, value)
    if Settings[key] == nil or type(Settings[key]) ~= type(value) then return end
    setSetting(key, value)
    repaint()
end

function Hub.Farm(on) Hub.Set("AutoFarm", on) end

appliers.UITransparency = function(v)
    win.BackgroundTransparency = v
    sidebar.BackgroundTransparency = v
    for _, r in ipairs(rowFrames) do r.BackgroundTransparency = v end
end

appliers.ToggleKey = function(v) keyHint.Text = v .. " to hide" end
appliers.ToggleKey(Settings.ToggleKey)

-- Formatters
local pct   = function(v) return string.format("%d%%", math.floor(v * 100 + 0.5)) end
local int   = function(v) return tostring(math.floor(v + 0.5)) end
local one   = function(v) return string.format("%.1f", v) end
local deg   = function(v) return math.floor(v + 0.5) .. "°" end
local boost = function(v) return v == 0 and "Off" or (math.floor(v) .. " st/s²") end
local studs = function(v) return v == 0 and "Unlimited" or (math.floor(v) .. " st") end

----------------------------------------------------------------------
-- Config manager
----------------------------------------------------------------------
local CFG_DIR, CFG_FILE = "CookiesHub", "CookiesHub/DriveAKukirin.json"
local canFiles = writefile ~= nil and readfile ~= nil and isfile ~= nil

local function applyConfigTable(tbl)
    for k, v in pairs(tbl) do
        if Settings[k] ~= nil and type(Settings[k]) == type(v) then setSetting(k, v) end
    end
    repaint()
end

local function saveConfig()
    if not canFiles then return false end
    if makefolder and isfolder and not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
    writefile(CFG_FILE, HttpService:JSONEncode(Settings))
    return true
end

local function loadConfig()
    if not (canFiles and isfile(CFG_FILE)) then return false end
    local ok, tbl = pcall(HttpService.JSONDecode, HttpService, readfile(CFG_FILE))
    if not ok or type(tbl) ~= "table" then return false end
    applyConfigTable(tbl)
    return true
end

----------------------------------------------------------------------
-- Pages
----------------------------------------------------------------------
local function commas(n)
    local s = tostring(math.floor(n))
    local sign, digits = s:match("^(-?)(%d+)$")
    return sign .. digits:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

SideHeader("MAIN")
local farmTab = Tab("Farm")
Section(farmTab, "Money")
if canFarm then
    Toggle(farmTab, "Auto money farm", "AutoFarm")
    Note(farmTab, "Spawns your fastest scooter, rides to open ground and holds a full-speed wheelie in circles.")
    local farmStatus = Note(farmTab, "")
    task.spawn(function()
        local lastCash, lastAt, rate = nil, os.clock(), nil
        while not Hub.unloaded do
            local cash = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Cash")
            if Settings.AutoFarm and cash then
                if lastCash and os.clock() - lastAt >= 10 then
                    rate = (cash.Value - lastCash) / (os.clock() - lastAt) * 60
                    lastCash, lastAt = cash.Value, os.clock()
                elseif not lastCash then
                    lastCash, lastAt = cash.Value, os.clock()
                end
                local doing = Settings.DeliveryFarm and "paused for deliveries" or busyBy == "pumpkin" and "paused for pumpkins" or ridingName() or "getting on..."
                farmStatus.Text = string.format("Riding: %s%s", doing, rate and string.format("  ·  %d cash/min", rate) or "")
            else
                lastCash, rate = nil, nil
                farmStatus.Text = ""
            end
            task.wait(1)
        end
    end)
else
    Note(farmTab, "Auto money farm isn't supported here: this executor needs getgc, debug.setupvalue and fireproximityprompt.")
end
Toggle(farmTab, "Delivery farm", "DeliveryFarm")
Note(farmTab, "Takes delivery jobs and hands them in (~375 cash/min, less than the money farm, which pauses meanwhile).")
local deliveryNote = Note(farmTab, "")
Toggle(farmTab, "Auto claim quests", "AutoQuests")
Toggle(farmTab, "Auto buy faster scooters", "AutoBuyScooter")
Note(farmTab, "Buys the fastest scooter you can afford that beats yours; the money farm switches to it.")

Section(farmTab, "Halloween")
Toggle(farmTab, "Pumpkin farm", "PumpkinFarm")
Note(farmTab, "On Pumpkin Night (every hour) lands on every pumpkin, 0.5s apart. Other farms pause meanwhile.")
local pumpkinStatus = Note(farmTab, "")

Section(farmTab, "Session")
local statsCash, statsMore = Note(farmTab, ""), Note(farmTab, "")
task.spawn(function()
    while not Hub.unloaded do
        local cash = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Cash")
        local elapsed = os.clock() - Session.startedAt
        local earned = cash and cash.Value - Session.startCash or 0
        statsCash.Text = string.format("%d:%02d:%02d played  ·  +$%s  ·  $%s/hour", elapsed // 3600, elapsed % 3600 // 60, elapsed % 60, commas(earned), commas(earned / math.max(elapsed, 1) * 3600))
        statsMore.Text = string.format("Pumpkin tokens +%d  ·  Deliveries %d  ·  Quests claimed %d  ·  Scooters bought %d",
            (tonumber(lp:GetAttribute("PumpkinTokens")) or 0) - Session.startTokens, Session.deliveries, Session.quests, Session.bought)
        deliveryNote.Text = Settings.DeliveryFarm and deliveryStatus or ""
        task.wait(1)
    end
end)
task.spawn(function()
    while not Hub.unloaded do
        local left = #pumpkinsLeft()
        local now = workspace:GetServerTimeNow()
        if workspace:FindFirstChild("PumpkinNight") then
            pumpkinStatus.Text = left > 0 and string.format("Pumpkin Night! %d pumpkins left", left) or "Pumpkin Night: all pumpkins collected"
        elseif HalloweenConfig and HalloweenConfig.seasonActive(now) then
            local wait = math.max(0, HalloweenConfig.nextNight(now) - now)
            pumpkinStatus.Text = string.format("Next Pumpkin Night in %d:%02d", wait // 60, wait % 60)
        else
            pumpkinStatus.Text = "No Pumpkin Nights right now"
        end
        task.wait(1)
    end
end)
local scooterTab = Tab("Scooter")
Section(scooterTab, "Spawn")
local ownedNames = {}
do
    local owned, templates = lp:FindFirstChild("OwnedScooters"), RS:FindFirstChild("Scooters")
    for _, v in ipairs(owned and owned:GetChildren() or {}) do
        if v.Value == true and templates and templates:FindFirstChild(v.Name) then table.insert(ownedNames, v.Name) end
    end
    table.sort(ownedNames, function(a, b) return (templates[a]:GetAttribute("TopSpeedKmh") or 0) > (templates[b]:GetAttribute("TopSpeedKmh") or 0) end)
    if not table.find(ownedNames, Settings.QuickScooter) then Settings.QuickScooter = ownedNames[1] or "" end
end
if canFarm and #ownedNames > 0 then
    Cycle(scooterTab, "Scooter", "QuickScooter", ownedNames)
    Button(scooterTab, "Spawn and ride", "Row", function() task.spawn(mountScooter, Settings.QuickScooter) end)
end
Section(scooterTab, "Riding")
if driveIntent then
    Toggle(scooterTab, "Wheelie assist", "WheelieAssist")
    Note(scooterTab, "Hold Shift to wheelie: it holds your scooter's best angle so it never loops out.")
end
Cycle(scooterTab, "Drive mode", "DriveMode", DRIVE_MODES)
Slider(scooterTab, "Speed boost", "SpeedBoost", 0, 150, 5, boost)
Note(scooterTab, "Extra push while throttling. Experimental: high values can flip you.")
Section(scooterTab, "Looks")
Toggle(scooterTab, "Headlights", "Headlights")
Toggle(scooterTab, "Smooth body", "SmoothBody")
Toggle(scooterTab, "Rainbow scooter (only you see it)", "Rainbow")
Cycle(scooterTab, "Police", "PoliceMode", { "OFF", "EASY", "MEDIUM", "HARD" })

local teleportTab = Tab("Teleport")
Section(teleportTab, "Places")
local PLACES = {
    { "Spawn", "SpawnLocation" },
    { "Dealership", "Dealership Kukirin" },
    { "Customization garage", "OpenCustomization" },
    { "Delivery jobs", "DeliveryJOB" },
    { "Race board", "RaceBoard" },
    { "Halloween board", "HalloweenBoard" },
    { "Events machine", "EventsMachine" },
    { "House", "HOUSETP" },
}
for _, place in ipairs(PLACES) do
    Button(teleportTab, place[1], "Row", function()
        local target = workspace:FindFirstChild(place[2])
        local pos = target and (target:IsA("Model") and target:GetPivot().Position or target:IsA("BasePart") and target.Position)
        if pos then teleport(pos + Vector3.new(0, 5, 0)) end
    end)
end
Button(teleportTab, "Money farm spot", "Row", goToFarmSpot)
Note(teleportTab, "Takes your scooter along if you're riding.")

local visualsTab = Tab("Visuals")
Section(visualsTab, "ESP")
Toggle(visualsTab, "Player ESP", "PlayerESP")
Toggle(visualsTab, "Scooter ESP", "ScooterESP")
Note(visualsTab, "Through walls. Scooter ESP shows other players' parked and ridden scooters.")
Toggle(visualsTab, "Names", "ESPNames")
Toggle(visualsTab, "Distance", "ESPDistance")
Toggle(visualsTab, "Boxes", "ESPBoxes")
Slider(visualsTab, "Max distance", "ESPMaxDistance", 0, 2000, 50, studs)
Slider(visualsTab, "Player colour", "ESPPlayerColor", 0, 360, 5, deg)
Slider(visualsTab, "Scooter colour", "ESPScooterColor", 0, 360, 5, deg)
Section(visualsTab, "World")
Toggle(visualsTab, "Fullbright", "Fullbright")
Note(visualsTab, "Removes darkness, shadows and fog so the whole map stays lit.")

local playerTab = Tab("Player")
Section(playerTab, "Movement")
Slider(playerTab, "WalkSpeed", "WalkSpeed", 0, 200, 1, int)
Slider(playerTab, "Jump height", "JumpHeight", 0, 100, 0.5, one)
Slider(playerTab, "Hip height", "HipHeight", 0, 20, 0.1, one)
Toggle(playerTab, "Infinite jump", "InfJump")
Toggle(playerTab, "Noclip", "Noclip")
Toggle(playerTab, "Fly", "Fly")
Slider(playerTab, "Fly speed", "FlySpeed", 10, 300, 5, int)
Note(playerTab, "Fly: WASD + Space up / Ctrl down. Movement changes apply when you're off the scooter.")
Section(playerTab, "Camera")
Slider(playerTab, "FOV", "FOV", 30, 120, 1, deg)
Section(playerTab, "Tools")
Button(playerTab, "Give teleport tool", "Row", giveTeleportTool)

SideHeader("SETTINGS")
local uiTab = Tab("Interface")
Section(uiTab, "Look")
Slider(uiTab, "Transparency", "UITransparency", 0, 0.6, 0.05, pct)
Section(uiTab, "Tags")
Toggle(uiTab, "Show profile tag", "ShowProfile")
Toggle(uiTab, "Show FPS tag", "ShowFPS")
Toggle(uiTab, "Show ping tag", "ShowPing")
Section(uiTab, "Keybind")
Keybind(uiTab, "Toggle UI key", "ToggleKey")

local perfTab = Tab("Performance")
Section(perfTab, "Utility")
Toggle(perfTab, "Anti AFK", "AntiAFK")
Toggle(perfTab, "Quick interact", "QuickInteract")
Toggle(perfTab, "Hide players", "HidePlayers")
Section(perfTab, "Performance")
Toggle(perfTab, "Reduce CPU (black screen)", "BlackScreen")
if setfpscap then
    Slider(perfTab, "FPS cap", "FPSCap", 15, 240, 5, int)
else
    Note(perfTab, "FPS cap isn't supported by this executor.")
end
Toggle(perfTab, "Anti lag", "AntiLag")
Note(perfTab, "Anti lag turns off shadows and particle effects.")

local cfgTab = Tab("Config")
Section(cfgTab, "Config")
local status
if canFiles then
    Toggle(cfgTab, "Auto-load on execute", "AutoLoad")
    Button(cfgTab, "Save config", "Row", function() status.Text = saveConfig() and "Saved." or "Save failed." end)
    Button(cfgTab, "Load config", "Row", function() status.Text = loadConfig() and "Loaded." or "No saved config found." end)
else
    Note(cfgTab, "This executor can't save files; use Export instead.")
end
Button(cfgTab, "Export to clipboard", "Row", function()
    if setclipboard then setclipboard(HttpService:JSONEncode(Settings)); status.Text = "Copied to clipboard." else status.Text = "Clipboard not supported." end
end)
status = Note(cfgTab, "")
Section(cfgTab, "Script")
Button(cfgTab, "Unload", "Accent", function() Hub.Unload() end)

selectTab(farmTab)

-- Drag
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then
            dragging, dragStart, startPos = true, i.Position, win.Position
        end
    end)
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == MOVE or i.UserInputType == TOUCH) then
            local d = i.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = false end
    end))
end

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    tween(win, { Size = UDim2.fromOffset(WIN_W, minimized and 40 or WIN_H) })
end)
closeBtn.MouseButton1Click:Connect(function() Hub.Unload() end)

bind(UIS.InputBegan:Connect(function(i, processed)
    if processed or capturingKey then return end
    local ok, key = pcall(function() return Enum.KeyCode[Settings.ToggleKey] end)
    if ok and i.KeyCode == key then ui.Enabled = not ui.Enabled end
end))

----------------------------------------------------------------------
-- Unload
----------------------------------------------------------------------
function Hub.Unload()
    if Hub.unloaded then return end
    Hub.unloaded = true
    for _, c in ipairs(Hub.conns) do pcall(function() c:Disconnect() end) end
    if driving then setDrive(false, 0, 0) end
    local h = getHum()
    if h then
        if touched.WalkSpeed then h.WalkSpeed = Defaults.WalkSpeed end
        if touched.JumpHeight then h.JumpHeight = Defaults.JumpHeight end
        if touched.HipHeight then h.HipHeight = Defaults.HipHeight end
        if Settings.Fly then h.PlatformStand = false end
    end
    if touched.FOV then workspace.CurrentCamera.FieldOfView = Defaults.FOV end
    appliers.Noclip(false)
    appliers.QuickInteract(false)
    appliers.HidePlayers(false)
    appliers.AntiLag(false)
    appliers.Fullbright(false)
    if Settings.BlackScreen then RunService:Set3dRenderingEnabled(true) end
    if touched.FPSCap and setfpscap then setfpscap(60) end
    if assisting then
        debug.setupvalue(driveIntent, UP_KEY_WHEELIE, false)
        debug.setupvalue(driveIntent, UP_BRAKE, 0)
    end
    restoreRainbow()
    espFolder:Destroy()
    if tpTool then tpTool:Destroy() end
    ui:Destroy()
    tagGui:Destroy()
    if _G.CookiesHubKK == Hub then _G.CookiesHubKK = nil end
    print("[CookiesHub] Unloaded.")
end

-- Auto-load saved config if it asks for it
if canFiles and isfile(CFG_FILE) then
    local ok, tbl = pcall(HttpService.JSONDecode, HttpService, readfile(CFG_FILE))
    if ok and type(tbl) == "table" and tbl.AutoLoad then applyConfigTable(tbl) end
end

print("[CookiesHub] Drive A Kukirin loaded. Press " .. Settings.ToggleKey .. " to hide.")