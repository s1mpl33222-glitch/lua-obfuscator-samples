--!nocheck
--!nolint
local runUnlockAllCosmetics
if getgenv and type(getgenv) == "function" and getgenv().meow_cleanup then pcall(function() getgenv().meow_cleanup() end) end

local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local Workspace = cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local SoundService = cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService")
local Lighting = cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
local TeleportService = cloneref and cloneref(game:GetService("TeleportService")) or game:GetService("TeleportService")
local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().meow_flags = getgenv().meow_flags or {}
local flags = getgenv().meow_flags
local meowState = {
    Destroyed = false,
    PriorityList = {},
    CustomSoundCache = {},
    ModDetectorChecked = {},
    CurrentTarget = nil,
    LastTargetPlayer = nil,
    LastMeleeAttack = 0,
    KnifeAt = 0,
    KnifeBurst = 0,
    IndicatorLabel = nil,
    IndicatorGui = nil,
    IndicatorFrame = nil,
    ManipulatedActive = false,
    DamageDealt = 0,
    DamageTaken = 0,
    LastHitmarkerTime = 0,

    TargetHudGui = nil,
    TargetHudFrame = nil,
    TargetHighlight = nil,
    TargetSnapline = nil,
    CrosshairLines = {},
    CrosshairOutlines = {},
    SilentFovCircle = nil,
    SilentFovOutline = nil,
    AimbotFovCircle = nil,
    TracerDrawings = {},
    OriginalCameraFov = nil,

    EspBoxes = {},
    ChamsHighlights = {},

    AppliedAdornments = {},
    AppliedSelectionBoxes = {},
    WeaponHighlight = nil,
    SavedPartProps = {},
    LastItemVisual = nil,

    OriginalSkybox = nil,
    ActiveSkybox = nil,
}

local fakePos = {
    Enabled           = false,
    Depth             = 5.8,
    WalkMode          = true,
    SurfaceCamera     = true,
    AutoNoclip        = true,
    AutoHandoff       = true,
    VisualizerEnabled = true,
    VisualizerColor   = Color3.fromRGB(0, 162, 255),
    Panic             = false,
    PanicMinX         = -5,
    PanicMaxX         = 5,
    PanicZ            = false,
    HideMeshes        = true,
    AnimationDesync   = true,
    ZeroVelocity      = true,
    CustomPitch       = 0,
    CustomYaw         = 0,
    InvertPitch       = false,
    DesyncMode        = "Position Desync V2",

    VirtualCF         = nil,
    LastMoveDir       = Vector3.zero,
    GhostBox          = nil,
    AnimTrack         = nil,
    OriginalParts     = nil,
    HandoffTicks      = 0,
    ClientCF          = nil,
    FakeCF            = nil,
}

local movementState = {
    WalkSpeedEnabled  = false,
    WalkSpeedMult     = 1.0,
    SlidingEnabled    = false,
    SlidingMult       = 1.0,
    NoclipEnabled     = false,
    FlightEnabled     = false,
    FlightSpeed       = 100,
    DoubleJump        = false,
    DoubleJumpHeight  = 1.0,
    LongJump          = false,
    LongJumpMode      = "Camera Look",
    LongJumpForce     = 150,
    LongJumpUpward    = 100,
    AutoStrafe        = false,
    AutoStrafeSpeed   = 50,
}

local staffDetectorState = {
    Enabled           = true,
    AutoHop           = false,
    AutoKick          = false,
    DetectedStaff     = {},
}

local function undergroundCaptureOriginal()
    local char = LocalPlayer and LocalPlayer.Character
    if not char then return end
    fakePos.OriginalParts = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            table.insert(fakePos.OriginalParts, { part = part, transparency = part.Transparency })
            if fakePos.HideMeshes then
                pcall(function() part.Transparency = 1 end)
            end
        end
    end
end

local function undergroundRestoreOriginal()
    if not fakePos.OriginalParts then return end
    for _, data in ipairs(fakePos.OriginalParts) do
        if data.part and data.part.Parent then
            pcall(function() data.part.Transparency = data.transparency end)
        end
    end
    fakePos.OriginalParts = nil
end

local function playAnimDesync()
    local char = LocalPlayer and LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not fakePos.AnimTrack then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://10714003221"
            local track = hum:LoadAnimation(anim)
            track:Play(0, 1, 0)
            track.TimePosition = 1.48
            fakePos.AnimTrack = track
        end)
    end
end

local function stopAnimDesync()
    if fakePos.AnimTrack then
        pcall(function()
            fakePos.AnimTrack:Stop()
            fakePos.AnimTrack:Destroy()
        end)
        fakePos.AnimTrack = nil
    end
end

local function updateGhostVisualizer()
    local coreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    if fakePos.Enabled and fakePos.VisualizerEnabled and fakePos.VirtualCF and not meowState.Destroyed then
        if not fakePos.GhostBox or not fakePos.GhostBox.Parent then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "_MeowFakePosGhost"
            box.Size = Vector3.new(2, 5, 1)
            box.Color3 = fakePos.VisualizerColor or Color3.fromRGB(0, 162, 255)
            box.Transparency = 0.55
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Adornee = workspace.Terrain
            pcall(function() box.Parent = coreGui end)
            fakePos.GhostBox = box
        end
        fakePos.GhostBox.CFrame = fakePos.VirtualCF
        fakePos.GhostBox.Color3 = fakePos.VisualizerColor or Color3.fromRGB(0, 162, 255)
    else
        if fakePos.GhostBox then
            pcall(function() fakePos.GhostBox:Destroy() end)
            fakePos.GhostBox = nil
        end
    end
end

local function set_position_desync(source, clientCF, serverCF)
    local genv = getgenv()
    genv.position_desync_source = source
    genv.client_position = typeof(clientCF) == "CFrame" and clientCF.Position or clientCF
    genv.server_position = typeof(serverCF) == "CFrame" and serverCF.Position or serverCF
    genv.v2_tp_pos = (source == "v2" and genv.server_position) or nil
    fakePos.ClientCF = clientCF
    fakePos.FakeCF = serverCF
end

local function clear_position_desync()
    local genv = getgenv()
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local pos = hrp and hrp.Position
    genv.position_desync_source = nil
    genv.client_position = pos
    genv.server_position = pos
    genv.v2_tp_pos = nil
    fakePos.ClientCF = nil
    fakePos.FakeCF = nil
end

getgenv().set_position_desync = set_position_desync
getgenv().clear_position_desync = clear_position_desync

local function setFakePosition(state)
    if fakePos.Enabled == state then return end
    fakePos.Enabled = state
    flags.fake_position_enabled = state
    getgenv().FakePositionEnabled = state
    getgenv().HideUndergroundEnabled = state
    meowState.ManipulatedActive = state

    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if state then
        if hrp then
            fakePos.VirtualCF = hrp.CFrame
        end
        if fakePos.HideMeshes then undergroundCaptureOriginal() end
        if fakePos.AnimationDesync then playAnimDesync() end

        pcall(function()
            RunService:UnbindFromRenderStep("FakePosCameraElevation")
        end)
        RunService:BindToRenderStep("FakePosCameraElevation", 201, function()
            if fakePos.Enabled and fakePos.SurfaceCamera and not meowState.Destroyed then
                local cam = workspace.CurrentCamera
                local depth = flags.fake_position_depth or fakePos.Depth or 5.8
                if cam and depth > 0 then
                    cam.CFrame = cam.CFrame + Vector3.new(0, depth, 0)
                end
            end
        end)
    else
        pcall(function()
            RunService:UnbindFromRenderStep("FakePosCameraElevation")
        end)
        undergroundRestoreOriginal()
        stopAnimDesync()
        updateGhostVisualizer()

        if hrp and fakePos.VirtualCF then
            pcall(function()
                if fakePos.ZeroVelocity then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                hrp.CFrame = fakePos.VirtualCF
            end)
        end
        fakePos.VirtualCF = nil
        fakePos.HandoffTicks = 0
        clear_position_desync()
    end
end

getgenv().SetFakePosition = setFakePosition
getgenv().ToggleFakePosition = function()
    setFakePosition(not fakePos.Enabled)
    return fakePos.Enabled
end
getgenv().SetFakePositionDepth = function(d)
    if type(d) == "number" then fakePos.Depth = d end
end
getgenv().SetFakePositionHideMesh = function(h)
    fakePos.HideMeshes = (h == true)
    if not fakePos.HideMeshes then
        undergroundRestoreOriginal()
    elseif fakePos.Enabled then
        undergroundCaptureOriginal()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if UserInputService:GetFocusedTextBox() then return end
    local targetKey = flags.fake_position_keybind or Enum.KeyCode.X
    if input.KeyCode == targetKey then
        setFakePosition(not fakePos.Enabled)
        pcall(function()
            if Library and Library.notifications then
                Library.notifications:create_notification({
                    name = "Fake Position",
                    info = fakePos.Enabled and ("Enabled (" .. tostring(fakePos.Depth) .. " studs underground)") or "Disabled",
                    lifetime = 2
                })
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not fakePos.Enabled or meowState.Destroyed then return end
    local char = LocalPlayer and LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if fakePos.HandoffTicks > 0 then
        fakePos.HandoffTicks = fakePos.HandoffTicks - 1
        if fakePos.VirtualCF then
            hrp.CFrame = fakePos.VirtualCF
            set_position_desync("handoff", fakePos.VirtualCF, hrp.CFrame)
        end
        return
    end

    if not fakePos.VirtualCF then
        fakePos.VirtualCF = hrp.CFrame
    end

    local cam = Workspace.CurrentCamera
    local camLook = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
    local camYaw = math.atan2(-camLook.X, -camLook.Z)
    local surfaceRot = CFrame.Angles(0, camYaw, 0)

    if not fakePos.VirtualCF then
        fakePos.VirtualCF = CFrame.new(hrp.CFrame.Position) * surfaceRot
    end

    if fakePos.WalkMode then
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local speed = hum.WalkSpeed * (movementState.WalkSpeedEnabled and movementState.WalkSpeedMult or 1)
            local deltaPos = moveDir * (speed * dt)
            fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position + deltaPos) * surfaceRot
        else
            fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position) * surfaceRot
        end
    else
        fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position) * surfaceRot
    end

    local depth = flags.fake_position_depth or fakePos.Depth or 5.8
    local undergroundPos = fakePos.VirtualCF.Position - Vector3.new(0, depth, 0)

    if fakePos.Panic then
        local minX = math.min(fakePos.PanicMinX, fakePos.PanicMaxX)
        local maxX = math.max(fakePos.PanicMinX, fakePos.PanicMaxX)
        local jx = minX + math.random() * (maxX - minX)
        local jz = fakePos.PanicZ and ((math.random() - 0.5) * (maxX - minX)) or 0
        undergroundPos = undergroundPos + Vector3.new(jx, 0, jz)
    end

    local pitchAngle = fakePos.InvertPitch and (fakePos.CustomPitch or 0) or 0
    local pitchCF = CFrame.Angles(math.rad(pitchAngle), math.rad(fakePos.CustomYaw or 0), 0)

    if fakePos.AutoNoclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end

    if fakePos.ZeroVelocity then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    hrp.CFrame = CFrame.new(undergroundPos) * surfaceRot * pitchCF

    set_position_desync("fake", fakePos.VirtualCF, hrp.CFrame)

    updateGhostVisualizer()
end)

RunService.Heartbeat:Connect(function()
    if not fakePos.Enabled or not fakePos.HideMeshes or meowState.Destroyed then return end
    if not fakePos.OriginalParts then return end
    for _, data in ipairs(fakePos.OriginalParts) do
        local part = data.part
        if part and part.Parent and part.Transparency ~= 1 then
            pcall(function() part.Transparency = 1 end)
        end
    end
end)

RunService.Stepped:Connect(function()
    if meowState.Destroyed then return end
    local char = LocalPlayer and LocalPlayer.Character
    if not char then return end

    if movementState.NoclipEnabled then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if movementState.WalkSpeedEnabled and movementState.WalkSpeedMult > 1.0 then
            hum.WalkSpeed = 16 * movementState.WalkSpeedMult
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not movementState.FlightEnabled or meowState.Destroyed then return end
    local char = LocalPlayer and LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local cam = Workspace.CurrentCamera
    local moveDir = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

    if moveDir.Magnitude > 0 then
        hrp.Velocity = moveDir.Unit * movementState.FlightSpeed
    else
        hrp.Velocity = Vector3.zero
    end
end)
UserInputService.JumpRequest:Connect(function()
    if meowState.Destroyed then return end
    local char = LocalPlayer and LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if movementState.DoubleJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50 * movementState.DoubleJumpHeight, hrp.Velocity.Z)
    end

    if movementState.LongJump then
        local cam = Workspace.CurrentCamera
        local dir = (movementState.LongJumpMode == "Camera Look" and cam and cam.CFrame.LookVector) or hrp.CFrame.LookVector
        hrp.Velocity = Vector3.new(dir.X * movementState.LongJumpForce, movementState.LongJumpUpward, dir.Z * movementState.LongJumpForce)
    end
end)

local MOD_KEYWORDS = { "mod", "admin", "staff", "owner", "developer", "tester", "creator", "contributor" }
local function checkStaffMember(player)
    if not staffDetectorState.Enabled or not player or player == LocalPlayer then return end
    task.spawn(function()
        pcall(function()
            local nameLower = player.Name:lower()
            local dispLower = (player.DisplayName or ""):lower()
            local isStaff = (player.UserId == game.CreatorId)

            if not isStaff then
                for _, kw in ipairs(MOD_KEYWORDS) do
                    if nameLower:find(kw) or dispLower:find(kw) then
                        isStaff = true
                        break
                    end
                end
            end

            if isStaff and not staffDetectorState.DetectedStaff[player.UserId] then
                staffDetectorState.DetectedStaff[player.UserId] = true
                local msg = "[Sleepy Hub] Staff / Mod detected: " .. player.Name .. " (" .. player.DisplayName .. ")"
                warn(msg)
                if Library and Library.notifications then
                    Library.notifications:create_notification({
                        name = "Staff Alert",
                        info = "Staff member detected: " .. player.Name,
                        lifetime = 8
                    })
                end
                if staffDetectorState.AutoHop then
                    pcall(function()
                        local ts = game:GetService("TeleportService")
                        ts:Teleport(game.PlaceId, LocalPlayer)
                    end)
                elseif staffDetectorState.AutoKick then
                    LocalPlayer:Kick("Preventive disconnect: Staff member joined")
                end
            end
        end)
    end)
end

Players.PlayerAdded:Connect(checkStaffMember)
task.defer(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then checkStaffMember(p) end
    end
end)

match_in_round = function()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local_fighter_alive = function()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

status_target_name = function(target)
    if not target then return nil end
    if typeof(target) == "Instance" then
        if target:IsA("Player") then return target.DisplayName or target.Name end
        local pl = Players:GetPlayerFromCharacter(target)
        if pl then return pl.DisplayName or pl.Name end
        return target.Name
    elseif type(target) == "table" and target.Player then
        return target.Player.DisplayName or target.Player.Name
    end
    return tostring(target)
end

is_katana_user = function(model, player)
    local char = model or (player and player.Character)
    if not char then return false end
    if char:FindFirstChild("Katana") then return true end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find("katana") then return true end
    end
    return false
end
manip_is_deflecting = function(fighter)
    if not fighter then return false end
    local char = (type(fighter) == "table" and fighter.Character) or (typeof(fighter) == "Instance" and fighter)
    if not char then return false end
    local katana = char:FindFirstChild("Katana")
    if katana and katana:FindFirstChild("Deflecting") and katana.Deflecting.Value == true then
        return true
    end
    return false
end

shield_blocks_shot = function(targetRoot, shooterPos)
    if not targetRoot then return false end
    local char = targetRoot.Parent
    if not char then return false end
    local shield = char:FindFirstChild("Riot Shield") or char:FindFirstChild("Shield")
    if not shield then return false end
    local targetLook = targetRoot.CFrame.LookVector
    local shotDir = (shooterPos - targetRoot.Position).Unit
    return targetLook:Dot(shotDir) < -0.2
end

ragebot_is_priority = function(player)
    if not player then return false end
    local name = typeof(player) == "Instance" and player.Name or tostring(player)
    return meowState.PriorityList[name:lower()] == true
end

ragebot_add_priority = function(player)
    if not player then return end
    local name = typeof(player) == "Instance" and player.Name or tostring(player)
    meowState.PriorityList[name:lower()] = true
end
getgenv()._Meow_AddPriority = ragebot_add_priority

silent_closest_hitbox = function(char)
    if not char then return nil end
    local mode = flags.target_hitbox or "Head"
    if mode == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif mode == "HumanoidRootPart" or mode == "Torso" then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    elseif mode == "Random" then
        local parts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
        return char:FindFirstChild(parts[math.random(1, #parts)]) or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end
silent_closest_part = silent_closest_hitbox
targeting_silent_part = silent_closest_hitbox
target_aim_part = silent_closest_hitbox
random_hitpart_name = function()
    local p = {"Head", "HumanoidRootPart", "Torso", "UpperTorso"}
    return p[math.random(1, #p)]
end

get_target = function()
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local bestTarget = nil
    local bestScore = math.huge
    local method = flags.target_priority or "Lowest Health"
    local fovRadius = flags.fov_radius_smoothed or 120
    local center = Camera.ViewportSize / 2

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local char = pl.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and root and not char:FindFirstChildOfClass("ForceField") then
                if not (flags.riot_shield_check and shield_blocks_shot(root, myRoot.Position)) then
                    if not (flags.avoid_katana and manip_is_deflecting(char)) then
                        local scrPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        local fovDist = (Vector2.new(scrPos.X, scrPos.Y) - center).Magnitude

                        if not flags.silent_aim_enabled or fovDist <= fovRadius then
                            local dist = (root.Position - myRoot.Position).Magnitude
                            local health = hum.Health
                            local isPriority = ragebot_is_priority(pl)
                            local score = health

                            if method == "Distance" or method == "Closest Distance" then
                                score = dist
                            elseif method == "Crosshair" then
                                score = fovDist
                            elseif method == "FOV - Lowest Health" then
                                score = (health * 2) + fovDist
                            else
                                score = health
                            end

                            if isPriority then
                                score = score - 10000
                            end

                            if score < bestScore then
                                bestScore = score
                                bestTarget = {
                                    Player = pl,
                                    Character = char,
                                    Humanoid = hum,
                                    RootPart = root,
                                    HitPart = silent_closest_hitbox(char),
                                    Distance = dist,
                                    FOVDistance = fovDist,
                                }
                            end
                        end
                    end
                end
            end
        end
    end

    meowState.CurrentTarget = bestTarget
    if bestTarget then meowState.LastTargetPlayer = bestTarget.Player end
    return bestTarget
end

manip_set_filter = function(char) end
manip_probe = function(origin, dir, model, part)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local res = Workspace:Raycast(origin, dir, rp)
    if not res then return 1 end
    if res.Instance and (res.Instance:IsDescendantOf(model) or res.Instance == part) then
        return 1
    end
    return 0
end
manip_resolve = function() return true end
manip_in_control = function() return flags.manip_result == true end
manip_is_underground = function() return hideUndergroundEnabled end

collect_drops = function(char, root)
    if not flags.ACO then return end
    local drops = Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("Debris") or Workspace
    for _, item in ipairs(drops:GetChildren()) do
        if item:IsA("BasePart") and (item.Name:find("Orb") or item.Name:find("Ammo") or item.Name:find("Drop")) then
            if (item.Position - root.Position).Magnitude <= 35 then
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(root, item, 0)
                        firetouchinterest(root, item, 1)
                    end
                end)
            end
        end
    end
end

anti_subspace_friendly = function(mine)
    if not mine then return true end
    local creator = mine:GetAttribute("Creator") or mine:FindFirstChild("Creator")
    if creator and tostring(creator.Value or creator) == LocalPlayer.Name then
        return true
    end
    return false
end

antiaim_extended_char = function(val)
    local ok, char = pcall(function() return utf8 and utf8.char and utf8.char(val or 1114111) or "" end)
    return ok and char or "\255"
end

antiaim_pitch = function(mode, custom)
    mode = mode or flags.antiaim_pitch or "Down"
    if flags.antiaim_hidehead then return -89 end
    if mode == "Down" then return -89
    elseif mode == "Up" then return 89
    elseif mode == "Jitter" or mode == "Up & Down" then return (math.random(1, 2) == 1 and 89 or -89)
    elseif mode == "Random" then return math.random(-89, 89)
    elseif mode == "Custom" then return custom or flags.antiaim_custom_pitch or 0
    elseif mode == "Zero" then return 0 end
    return -89
end

local aaSpinAngle = 0
local aaSwayAngle = 0
local aaSwayDir = 1
local aaJitterFlip = false

antiaim_yaw = function(mode, speed, jitterRange)
    mode = mode or flags.antiaim_yaw or "Spin"
    speed = speed or flags.antiaim_spin_speed or 15
    jitterRange = jitterRange or flags.antiaim_jitter_range or 45
    local dt = 1/60

    if mode == "Backwards" then return 180
    elseif mode == "Left" then return 90
    elseif mode == "Right" then return -90
    elseif mode == "Spin" then
        aaSpinAngle = (aaSpinAngle + (speed * 10 * dt)) % 360
        return aaSpinAngle
    elseif mode == "Sway" then
        aaSwayAngle = aaSwayAngle + (speed * 4 * dt * aaSwayDir)
        if math.abs(aaSwayAngle) > 60 then aaSwayDir = -aaSwayDir end
        return 180 + aaSwayAngle
    elseif mode == "Jitter" then
        aaJitterFlip = not aaJitterFlip
        return aaJitterFlip and (180 + jitterRange) or (180 - jitterRange)
    elseif mode == "Random" then
        return math.random(-180, 180)
    elseif mode == "Custom" then
        return flags.antiaim_custom_yaw or 0
    end
    return 180
end

set_position_desync = function() meowState.ManipulatedActive = true end
clear_position_desync = function() meowState.ManipulatedActive = false end

display_font_face = function(fontName)
    fontName = fontName or flags.esp_font or "MonoSpace"
    if fontName == "ProggyTiny" then return Enum.Font.Code
    elseif fontName == "MonoSpace" then return Enum.Font.RobotoMono
    elseif fontName == "Tahoma" then return Enum.Font.Gotham end
    return Enum.Font.Code
end
apply_display_font = function(label)
    if label and label:IsA("TextLabel") then
        label.Font = display_font_face()
    end
end
spawn_world_marker = function(pos)
    meowState.LastHitmarkerTime = os.clock()
    if not (flags.world_marker_enabled ~= false) or not pos then return end
    task.spawn(function()
        local size = flags.world_marker_size or 1.0
        local length = flags.world_marker_length or 1.0
        local thickness = flags.world_marker_thickness or 0.15
        local duration = flags.world_marker_duration or 0.6
        local growth = (flags.world_marker_growth ~= false) and 1.5 or 1.0
        local markerColor = flags.world_marker_color or Color3.fromRGB(255, 60, 60)

        local anchor = Instance.new("Part")
        anchor.Name = "MeowHitmarker"
        anchor.Anchored = true
        anchor.CanCollide = false
        anchor.CanQuery = false
        anchor.Transparency = 1
        anchor.Size = Vector3.new(0.1, 0.1, 0.1)
        anchor.Position = pos
        anchor.Parent = Workspace
        local bbg = Instance.new("BillboardGui")
        bbg.Adornee = anchor
        bbg.AlwaysOnTop = true
        bbg.Size = UDim2.fromOffset(25 * size, 25 * size)
        bbg.Parent = anchor

        local function makeArm(rot)
            local arm = Instance.new("Frame")
            arm.AnchorPoint = Vector2.new(0.5, 0.5)
            arm.Position = UDim2.fromScale(0.5, 0.5)
            arm.Size = UDim2.new(0, math.max(2, 8 * thickness), 0, math.max(6, 20 * length))
            arm.Rotation = rot
            arm.BackgroundColor3 = markerColor
            arm.BorderSizePixel = 0
            arm.Parent = bbg
            return arm
        end
        makeArm(45)
        makeArm(-45)

        local tw = TweenService:Create(bbg, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(25 * size * growth, 25 * size * growth)
        })
        tw:Play()
        task.delay(duration, function() pcall(function() anchor:Destroy() end) end)
    end)
end
damage_label = function(text, pos) spawn_world_marker(pos) end

local function handleHitDetected(targetName, partName, damage, weaponName, hitPosition)
    if flags.hit_logs_enabled then
        local formatStr = flags.hit_logs_format or "{NAME} hit in {PART} for {DMG} with {WEAPON}"
        local logMsg = formatStr:gsub("{NAME}", tostring(targetName or "Enemy"))
                               :gsub("{PART}", tostring(partName or "Torso"))
                               :gsub("{DMG}", tostring(damage or "0"))
                               :gsub("{WEAPON}", tostring(weaponName or "Weapon"))
        print("[Meow HitLog] " .. logMsg)
    end

    if hitPosition then
        spawn_world_marker(hitPosition)
        if meowState.TriggerBulletTracer then
            meowState.TriggerBulletTracer(hitPosition)
        end
    end

    if playEventSound then playEventSound("hit") end
    if damage and tonumber(damage) then
        meowState.DamageDealt = meowState.DamageDealt + tonumber(damage)
    end
end
getgenv()._Meow_TriggerHit = handleHitDetected

local HIT_SOUND_PRESETS = {
    ["Rust"] = "rbxassetid://1255040462",
    ["Skeet"] = "rbxassetid://5633695679",
    ["Bell"] = "rbxassetid://6534947240",
    ["Bonk"] = "rbxassetid://3997129949",
    ["Neverlose"] = "rbxassetid://6607204501",
    ["Bubble"] = "rbxassetid://6534947588",
}

local KILL_SOUND_PRESETS = {
    ["Oof"] = "rbxassetid://5143383166",
    ["Fatality"] = "rbxassetid://6607204928",
    ["Headshot"] = "rbxassetid://6534948092",
    ["Skeet"] = "rbxassetid://5633695679",
}

local function playRawSound(assetId, volume, pitch)
    if not assetId or assetId == "" then return end
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = assetId
        s.Volume = volume or 1.0
        s.PlaybackSpeed = pitch or 1.0
        s.Parent = SoundService
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
        task.delay(5, function() if s and s.Parent then s:Destroy() end end)
    end)
end

playEventSound = function(eventType)
    local volume = flags.sound_volume or 1.0
    local pitch = flags.sound_pitch or 1.0

    if eventType == "hit" and (flags.hit_sound_enabled ~= false) then
        local preset = flags.hit_sound_preset or "Rust"
        local asset = HIT_SOUND_PRESETS[preset] or HIT_SOUND_PRESETS["Rust"]
        if preset == "Custom ID" and flags.hit_sound_custom_id then
            asset = flags.hit_sound_custom_id
        end
        if asset then playRawSound(asset, volume, pitch) end
    elseif eventType == "kill" and flags.kill_sound_enabled then
        local preset = flags.kill_sound_preset or "Fatality"
        local asset = KILL_SOUND_PRESETS[preset] or KILL_SOUND_PRESETS["Fatality"]
        if preset == "Custom ID" and flags.kill_sound_custom_id then
            asset = flags.kill_sound_custom_id
        end
        if asset then playRawSound(asset, volume, pitch) end
    elseif eventType == "death" and flags.death_sound_enabled then
        playRawSound(KILL_SOUND_PRESETS["Oof"], volume, pitch)
    end
end
getgenv()._Meow_PlayEventSound = playEventSound

local function ensureTargetHudGui()
    if meowState.TargetHudGui and meowState.TargetHudGui.Parent then return end
    pcall(function()
        local parent = (gethui and gethui()) or game:GetService("CoreGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "_MeowTargetHUD"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local frame = Instance.new("Frame")
        frame.Name = "HUDCard"
        frame.Size = UDim2.fromOffset(420, 136)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.fromScale(0.5, 0.76)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
        frame.BorderSizePixel = 0
        frame.Visible = false
        frame.ZIndex = 120
        frame.Parent = sg

        local uisOuter = Instance.new("UIStroke")
        uisOuter.Color = Color3.fromRGB(0, 0, 0)
        uisOuter.Thickness = 1
        uisOuter.Parent = frame

        local nest1 = Instance.new("Frame")
        nest1.Position = UDim2.fromOffset(5, 5)
        nest1.Size = UDim2.new(1, -10, 1, -10)
        nest1.BackgroundTransparency = 1
        nest1.BorderSizePixel = 0
        nest1.ZIndex = 121
        nest1.Parent = frame

        local uisNest1 = Instance.new("UIStroke")
        uisNest1.Color = Color3.fromRGB(35, 35, 40)
        uisNest1.Thickness = 1
        uisNest1.Parent = nest1

        local content = Instance.new("Frame")
        content.Position = UDim2.fromOffset(5, 5)
        content.Size = UDim2.new(1, -10, 1, -10)
        content.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        content.BorderSizePixel = 0
        content.ZIndex = 122
        content.Parent = nest1

        local uisContent = Instance.new("UIStroke")
        uisContent.Color = Color3.fromRGB(28, 28, 32)
        uisContent.Thickness = 1
        uisContent.Parent = content

        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        local slotPositions = {
            UDim2.fromOffset(10, 10),
            UDim2.fromOffset(10, 66),
            UDim2.new(1, -58, 0, 10),
            UDim2.new(1, -58, 0, 66),
        }

        local weaponSlots = {}
        for i = 1, 4 do
            local slotBox = Instance.new("Frame")
            slotBox.Name = "Slot" .. i
            slotBox.Position = slotPositions[i]
            slotBox.Size = UDim2.fromOffset(48, 48)
            slotBox.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
            slotBox.BorderSizePixel = 0
            slotBox.ZIndex = 124
            slotBox.Parent = content

            local sStroke = Instance.new("UIStroke")
            sStroke.Color = Color3.fromRGB(32, 32, 36)
            sStroke.Thickness = 1
            sStroke.Parent = slotBox

            local sImg = Instance.new("ImageLabel")
            sImg.Name = "Icon"
            sImg.AnchorPoint = Vector2.new(0.5, 0.5)
            sImg.Position = UDim2.fromScale(0.5, 0.5)
            sImg.Size = UDim2.fromScale(0.85, 0.85)
            sImg.BackgroundTransparency = 1
            sImg.ScaleType = Enum.ScaleType.Fit
            sImg.ImageColor3 = Color3.fromRGB(180, 185, 200)
            sImg.ImageTransparency = 0.4
            sImg.ZIndex = 125
            sImg.Parent = slotBox

            weaponSlots[i] = sImg
        end

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "PlayerName"
        nameLbl.Position = UDim2.fromOffset(72, 10)
        nameLbl.Size = UDim2.new(1, -144, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = "No Target"
        nameLbl.TextColor3 = Color3.fromRGB(240, 243, 255)
        nameLbl.TextSize = 14
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 125
        nameLbl.Parent = content

        local statsLbl = Instance.new("TextLabel")
        statsLbl.Name = "Stats"
        statsLbl.Position = UDim2.fromOffset(72, 30)
        statsLbl.Size = UDim2.new(1, -144, 0, 14)
        statsLbl.BackgroundTransparency = 1
        statsLbl.Font = Enum.Font.GothamMedium
        statsLbl.Text = 'level <font color="#00A2FF">N/A</font>  rank <font color="#00A2FF">N/A</font>  device <font color="#00A2FF">N/A</font>  streak <font color="#00A2FF">N/A</font>'
        statsLbl.RichText = true
        statsLbl.TextColor3 = Color3.fromRGB(160, 165, 180)
        statsLbl.TextSize = 10
        statsLbl.TextXAlignment = Enum.TextXAlignment.Center
        statsLbl.ZIndex = 125
        statsLbl.Parent = content

        local hpTrack = Instance.new("Frame")
        hpTrack.Name = "HealthTrack"
        hpTrack.Position = UDim2.fromOffset(72, 54)
        hpTrack.Size = UDim2.new(1, -144, 0, 16)
        hpTrack.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        hpTrack.BorderSizePixel = 0
        hpTrack.ZIndex = 124
        hpTrack.Parent = content
        local hpTrackStroke = Instance.new("UIStroke")
        hpTrackStroke.Color = Color3.fromRGB(30, 30, 35)
        hpTrackStroke.Thickness = 1
        hpTrackStroke.Parent = hpTrack

        local hpFill = Instance.new("Frame")
        hpFill.Name = "Fill"
        hpFill.Size = UDim2.fromScale(1, 1)
        hpFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        hpFill.BorderSizePixel = 0
        hpFill.ZIndex = 125
        hpFill.Parent = hpTrack

        local hpVal = Instance.new("TextLabel")
        hpVal.Name = "Value"
        hpVal.Size = UDim2.fromScale(1, 1)
        hpVal.BackgroundTransparency = 1
        hpVal.Font = Enum.Font.GothamBold
        hpVal.Text = "100 / 100"
        hpVal.TextColor3 = Color3.fromRGB(255, 255, 255)
        hpVal.TextSize = 10
        hpVal.ZIndex = 126
        hpVal.Parent = hpTrack

        local ratioTrack = Instance.new("Frame")
        ratioTrack.Name = "RatioTrack"
        ratioTrack.Position = UDim2.fromOffset(72, 78)
        ratioTrack.Size = UDim2.new(1, -144, 0, 14)
        ratioTrack.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        ratioTrack.BorderSizePixel = 0
        ratioTrack.ZIndex = 124
        ratioTrack.Parent = content

        local rTrackStroke = Instance.new("UIStroke")
        rTrackStroke.Color = Color3.fromRGB(30, 30, 35)
        rTrackStroke.Thickness = 1
        rTrackStroke.Parent = ratioTrack

        local ratioFill = Instance.new("Frame")
        ratioFill.Name = "Fill"
        ratioFill.Size = UDim2.fromScale(0.5, 1)
        ratioFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        ratioFill.BorderSizePixel = 0
        ratioFill.ZIndex = 125
        ratioFill.Parent = ratioTrack

        local ratioVal = Instance.new("TextLabel")
        ratioVal.Name = "Value"
        ratioVal.Size = UDim2.fromScale(1, 1)
        ratioVal.BackgroundTransparency = 1
        ratioVal.Font = Enum.Font.GothamBold
        ratioVal.Text = '<font color="#00A2FF">0 ▲</font>  <font color="#FF4560">0 ▼</font>'
        ratioVal.RichText = true
        ratioVal.TextColor3 = Color3.fromRGB(240, 240, 250)
        ratioVal.TextSize = 9.5
        ratioVal.ZIndex = 126
        ratioVal.Parent = ratioTrack

        sg.Parent = parent
        meowState.TargetHudGui = sg
        meowState.TargetHudSlots = weaponSlots
        meowState.TargetHudName = nameLbl
        meowState.TargetHudStats = statsLbl
        meowState.TargetHudHpFill = hpFill
        meowState.TargetHudHpVal = hpVal
        meowState.TargetHudRatioFill = ratioFill
        meowState.TargetHudRatioVal = ratioVal
        meowState.TargetHudFrame = frame
    end)
end

local function updateTargetVisuals()
    local target = meowState.CurrentTarget
    local hudEnabled = flags.target_hud or flags.target_hud_preview

    if hudEnabled then
        ensureTargetHudGui()
    end

    if meowState.TargetHudFrame then
        meowState.TargetHudFrame.Visible = hudEnabled and (target ~= nil or flags.target_hud_preview)
        if meowState.TargetHudFrame.Visible then
            local slots = meowState.TargetHudSlots or {}
            local nameLbl = meowState.TargetHudName
            local statsLbl = meowState.TargetHudStats
            local hpFill = meowState.TargetHudHpFill
            local hpVal = meowState.TargetHudHpVal
            local ratioFill = meowState.TargetHudRatioFill
            local ratioVal = meowState.TargetHudRatioVal

            if target and target.Player then
                local pl = target.Player
                if nameLbl then nameLbl.Text = pl.DisplayName or pl.Name end

                local level = "N/A"
                local streak = "N/A"
                local rank = "N/A"
                local device = "N/A"
                pcall(function()
                    local ls = pl:FindFirstChild("leaderstats")
                    if ls then
                        if ls:FindFirstChild("Level") then level = tostring(ls.Level.Value) end
                        if ls:FindFirstChild("Streak") then streak = tostring(ls.Streak.Value) end
                        if ls:FindFirstChild("Rank") then rank = tostring(ls.Rank.Value) end
                    end
                end)
                if statsLbl then
                    statsLbl.Text = string.format('level <font color="#00A2FF">%s</font>  rank <font color="#00A2FF">%s</font>  device <font color="#00A2FF">%s</font>  streak <font color="#00A2FF">%s</font>', level, rank, device, streak)
                end

                local hum = target.Humanoid
                if hum and hpFill and hpVal then
                    local hp = math.max(0, hum.Health)
                    local maxHp = math.max(1, hum.MaxHealth)
                    hpFill.Size = UDim2.fromScale(math.clamp(hp / maxHp, 0, 1), 1)
                    hpVal.Text = string.format("%d / %d", math.floor(hp), math.floor(maxHp))
                end

                pcall(function()
                    local rep = game:GetService("ReplicatedStorage")
                    local ItemLibrary = rep:FindFirstChild("Modules") and rep.Modules:FindFirstChild("ItemLibrary") and require(rep.Modules.ItemLibrary)
                    local weps = { "Assault Rifle", "Revolver", "Knife", "Medkit" }
                    local char = pl.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then weps[1] = tool.Name end
                    end
                    for i = 1, 4 do
                        local sImg = slots[i]
                        if sImg then
                            local wName = weps[i]
                            if ItemLibrary and ItemLibrary.Items and ItemLibrary.Items[wName] then
                                local itm = ItemLibrary.Items[wName]
                                local img = itm.ImageHighResolution or itm.Image
                                if type(img) == "string" and #img > 0 then
                                    sImg.Image = img
                                    sImg.ImageTransparency = 0.1
                                end
                            end
                        end
                    end
                end)
            elseif flags.target_hud_preview then
                if nameLbl then nameLbl.Text = "rage sahur" end
                if statsLbl then
                    statsLbl.Text = 'level <font color="#00A2FF">36</font>  rank <font color="#00A2FF">platinum 1</font>  device <font color="#00A2FF">virtualreality</font>  streak <font color="#00A2FF">3</font>'
                end
                if hpFill and hpVal then
                    hpFill.Size = UDim2.fromScale(70 / 150, 1)
                    hpVal.Text = "70 / 150"
                end
                if ratioVal then
                    ratioVal.Text = '<font color="#FF4560">49 ▲</font>  <font color="#FF4560">52 ▼</font>'
                end
                if ratioFill then
                    ratioFill.Size = UDim2.fromScale(49 / (49 + 52), 1)
                end
                pcall(function()
                    local rep = game:GetService("ReplicatedStorage")
                    local ItemLibrary = rep:FindFirstChild("Modules") and rep.Modules:FindFirstChild("ItemLibrary") and require(rep.Modules.ItemLibrary)
                    local previewWeps = { "Assault Rifle", "Revolver", "Knife", "Medkit" }
                    for i = 1, 4 do
                        local sImg = slots[i]
                        if sImg and ItemLibrary and ItemLibrary.Items and ItemLibrary.Items[previewWeps[i]] then
                            local itm = ItemLibrary.Items[previewWeps[i]]
                            local img = itm.ImageHighResolution or itm.Image
                            if type(img) == "string" and #img > 0 then
                                sImg.Image = img
                                sImg.ImageTransparency = 0.2
                            end
                        end
                    end
                end)
            end
        end
    end

    if flags.target_highlight and target and target.Character then
        if not meowState.TargetHighlight or not meowState.TargetHighlight.Parent then
            local hl = Instance.new("Highlight")
            hl.Name = "_MeowTargetHighlight"
            hl.Parent = (gethui and gethui()) or game:GetService("CoreGui")
            meowState.TargetHighlight = hl
        end
        local hl = meowState.TargetHighlight
        hl.Adornee = target.Character
        hl.OutlineColor = flags.target_highlight_outline or Color3.fromRGB(255, 60, 60)
        hl.FillColor = flags.target_highlight_fill or Color3.fromRGB(180, 30, 30)
        hl.OutlineTransparency = 0
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = true
    elseif meowState.TargetHighlight then
        meowState.TargetHighlight.Enabled = false
        meowState.TargetHighlight.Adornee = nil
    end

    if flags.target_snapline and target and target.HitPart then
        local scrPos, onScreen = Camera:WorldToViewportPoint(target.HitPart.Position)
        if onScreen then
            if not meowState.TargetSnapline then
                pcall(function()
                    meowState.TargetSnapline = Drawing.new("Line")
                end)
            end
            local line = meowState.TargetSnapline
            if line then
                line.From = Camera.ViewportSize / 2
                line.To = Vector2.new(scrPos.X, scrPos.Y)
                line.Color = flags.target_snapline_color or Color3.fromRGB(255, 80, 80)
                line.Thickness = 1.5
                line.Transparency = 1
                line.Visible = true
            end
        elseif meowState.TargetSnapline then
            meowState.TargetSnapline.Visible = false
        end
    elseif meowState.TargetSnapline then
        meowState.TargetSnapline.Visible = false
    end
end

local function spawnBulletTracer(fromPos, toPos)
    if not flags.bullet_tracers then return end
    pcall(function()
        local line = Drawing.new("Line")
        local shadow = flags.tracer_shadows and Drawing.new("Line") or nil
        local tracer = {
            line = line,
            shadow = shadow,
            from = fromPos,
            to = toPos,
            born = os.clock(),
            hold = flags.tracer_hold or 0.6,
            fade = flags.tracer_fade or 0.4,
            travel = flags.tracer_travel or 0.15,
            color = flags.tracer_color or Color3.fromRGB(120, 180, 255),
        }
        table.insert(meowState.TracerDrawings, tracer)
    end)
end

meowState.TriggerBulletTracer = function(toPos)
    local char = LocalPlayer.Character
    local fromPos = char and char:FindFirstChild("Head") and char.Head.Position or Camera.CFrame.Position
    if fromPos and toPos then
        spawnBulletTracer(fromPos, toPos)
    end
end

local function updateBulletTracers()
    local now = os.clock()
    for idx = #meowState.TracerDrawings, 1, -1 do
        local d = meowState.TracerDrawings[idx]
        local age = now - d.born
        local totalLife = d.hold + d.fade
        if age >= totalLife then
            pcall(function() d.line:Destroy() end)
            if d.shadow then pcall(function() d.shadow:Destroy() end) end
            table.remove(meowState.TracerDrawings, idx)
        else
            local travelPct = d.travel > 0 and math.clamp(age / d.travel, 0, 1) or 1
            local currentTo = d.from:Lerp(d.to, travelPct)

            local p1, on1 = Camera:WorldToViewportPoint(d.from)
            local p2, on2 = Camera:WorldToViewportPoint(currentTo)

            if (on1 or on2) and p1.Z > 0 and p2.Z > 0 then
                local alpha = 1
                if age > d.hold then
                    alpha = math.clamp(1 - ((age - d.hold) / d.fade), 0, 1)
                end
                d.line.From = Vector2.new(p1.X, p1.Y)
                d.line.To = Vector2.new(p2.X, p2.Y)
                d.line.Color = d.color
                d.line.Thickness = 2
                d.line.Transparency = alpha
                d.line.Visible = true

                if d.shadow then
                    d.shadow.From = Vector2.new(p1.X, p1.Y)
                    d.shadow.To = Vector2.new(p2.X, p2.Y)
                    d.shadow.Color = Color3.fromRGB(0, 0, 0)
                    d.shadow.Thickness = 4
                    d.shadow.Transparency = alpha * 0.5
                    d.shadow.Visible = true
                end
            else
                d.line.Visible = false
                if d.shadow then d.shadow.Visible = false end
            end
        end
    end
end

local function getHeldItemVisual()
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end

    local fp = Workspace:FindFirstChild("FirstPerson")
    if fp then
        local prefix = LocalPlayer.Name .. " - "
        for _, child in ipairs(fp:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                local iv = child:FindFirstChild("ItemVisual") or child
                if iv then return iv end
            end
        end
        for _, child in ipairs(fp:GetChildren()) do
            local iv = child:FindFirstChild("ItemVisual") or child
            if iv then return iv end
        end
    end

    local cam = Workspace.CurrentCamera
    if cam then
        local vms = cam:FindFirstChild("ViewModels") or Workspace:FindFirstChild("ViewModels") or cam:FindFirstChild("ViewModel")
        if vms then
            for _, child in ipairs(vms:GetChildren()) do
                local iv = child:FindFirstChild("ItemVisual") or child:FindFirstChild("Model") or child
                if iv then return iv end
            end
            return vms
        end

        for _, child in ipairs(cam:GetChildren()) do
            if child:IsA("Model") and child.Name ~= "IndicatorGui" then
                local p = child:FindFirstChildOfClass("BasePart")
                if p then return child end
            end
        end
    end

    return nil
end

local function restoreWeaponVisuals()
    if meowState.AppliedAdornments then
        for part, wire in pairs(meowState.AppliedAdornments) do
            pcall(function() wire:Destroy() end)
        end
        table.clear(meowState.AppliedAdornments)
    end

    if meowState.AppliedSelectionBoxes then
        for part, box in pairs(meowState.AppliedSelectionBoxes) do
            pcall(function() box:Destroy() end)
        end
        table.clear(meowState.AppliedSelectionBoxes)
    end

    if meowState.WeaponHighlight then
        pcall(function() meowState.WeaponHighlight:Destroy() end)
        meowState.WeaponHighlight = nil
    end

    if meowState.SavedPartProps then
        for part, orig in pairs(meowState.SavedPartProps) do
            pcall(function()
                if part and part.Parent then
                    part.Material = orig.Material
                    part.Color = orig.Color
                    part.Transparency = orig.Transparency
                end
            end)
        end
        table.clear(meowState.SavedPartProps)
    end
end

local MeowWireframe = {
    Enabled          = false,
    Color            = Color3.fromRGB(255, 255, 255),
    ColorMiddle      = Color3.fromRGB(0, 162, 255),
    Color2           = Color3.fromRGB(0, 162, 255),
    ColorMode        = "gradient",
    GradientAxis     = { "length", "height" },
    Transparency     = 0,
    Thickness        = 1,

    ArmEnabled       = false,
    ArmColor         = Color3.fromRGB(0, 162, 255),
    ArmColor2        = Color3.fromRGB(255, 255, 255),

    ActiveWires      = {},
    Connections      = {},
    PartCache        = {},
    CurrentGun       = nil,
    CurrentArms      = nil,
}

local MEOW_BOX_EDGES = {
    {1, 2}, {2, 4}, {4, 3}, {3, 1},
    {5, 6}, {6, 8}, {8, 7}, {7, 5},
    {1, 5}, {2, 6}, {3, 7}, {4, 8}
}

function MeowWireframe:GetColor(pct)
    local col1 = self.Color or Color3.fromRGB(255, 255, 255)
    local col2 = self.Color2 or Color3.fromRGB(0, 162, 255)
    local colMid = self.ColorMiddle or col1:Lerp(col2, 0.5)
    if pct <= 0.5 then
        return col1:Lerp(colMid, math.clamp(pct * 2, 0, 1))
    else
        return colMid:Lerp(col2, math.clamp((pct - 0.5) * 2, 0, 1))
    end
end

function MeowWireframe:GetDirection()
    local axis = self.GradientAxis or {"length"}
    local tbl = {}
    for _, a in ipairs(axis) do tbl[a] = true end
    local dx = (tbl.width and 1 or 0) - (tbl["reverse width"] and 1 or 0)
    local dy = (tbl.height and 1 or 0) - (tbl["reverse height"] and 1 or 0)
    local dz = (tbl.length and 1 or 0) - (tbl["reverse length"] and 1 or 0)
    return dx, dy, dz
end

function MeowWireframe:DrawGradient(wire, data)
    local pts = data.Points
    if not pts or #pts < 2 then return end

    local minP = data.Min or Vector3.new(-1, -1, -1)
    local maxP = data.Max or Vector3.new(1, 1, 1)
    local size = maxP - minP
    local dx, dy, dz = self:GetDirection()
    local totalD = math.abs(dx) + math.abs(dy) + math.abs(dz)

    local function getPct(p)
        if totalD == 0 then return 0.5 end
        local px = size.X > 0.0001 and (p.X - minP.X) / size.X or 0.5
        local py = size.Y > 0.0001 and (p.Y - minP.Y) / size.Y or 0.5
        local pz = size.Z > 0.0001 and (p.Z - minP.Z) / size.Z or 0.5
        local v = 0.5 + ((px - 0.5) * dx + (py - 0.5) * dy + (pz - 0.5) * dz) / totalD
        return math.clamp(v, 0, 1)
    end
    local segments = 6
    for i = 1, #pts, 2 do
        local p1 = pts[i]
        local p2 = pts[i + 1]
        local pct1 = getPct(p1)
        local pct2 = getPct(p2)
        local lastP = p1
        for s = 1, segments do
            local nextP = p1 + (p2 - p1) * (s / segments)
            local t = pct1 + (pct2 - pct1) * ((s - 0.5) / segments)
            wire.Color3 = self:GetColor(t)
            wire:AddLine(lastP, nextP)
            lastP = nextP
        end
    end
end

function MeowWireframe:Rebuild(wire, part)
    local size = part.Size
    local h = size * 0.5
    local corners = {
        Vector3.new(-h.X, -h.Y, -h.Z),
        Vector3.new( h.X, -h.Y, -h.Z),
        Vector3.new(-h.X,  h.Y, -h.Z),
        Vector3.new( h.X,  h.Y, -h.Z),
        Vector3.new(-h.X, -h.Y,  h.Z),
        Vector3.new( h.X, -h.Y,  h.Z),
        Vector3.new(-h.X,  h.Y,  h.Z),
        Vector3.new( h.X,  h.Y,  h.Z),
    }

    local points = {}
    for _, edge in ipairs(MEOW_BOX_EDGES) do
        table.insert(points, corners[edge[1]])
        table.insert(points, corners[edge[2]])
    end

    local data = {
        Points = points,
        Min    = -h,
        Max    = h,
    }

    wire:Clear()
    wire.Color3 = self.Color
    wire.Transparency = self.Transparency or 0
    wire.Thickness = self.Thickness or 1
    wire.AlwaysOnTop = true
    wire.ZIndex = 10

    if self.ColorMode == "gradient" then
        self:DrawGradient(wire, data)
    else
        wire:AddLines(points)
    end
end

function MeowWireframe:Draw(part)
    if self.ActiveWires[part] then return end
    local coreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local wire = Instance.new("WireframeHandleAdornment")
    wire.Name = "MeowWireframe"
    wire.ZIndex = 10
    wire.Thickness = self.Thickness or 1
    wire.AlwaysOnTop = true
    wire.Adornee = part
    pcall(function() wire.Parent = coreGui end)
    if not wire.Parent then
        pcall(function() wire.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 0.5) end)
    end
    if not wire.Parent then
        wire.Parent = Camera
    end

    self:Rebuild(wire, part)

    self.ActiveWires[part] = {
        Wire             = wire,
        OrigTransparency = part.Transparency,
        Size             = part.Size,
    }

    part.Transparency = 1
end

function MeowWireframe:Watch(part)
    if self.Connections[part] then return end
    local conns = {}

    table.insert(conns, part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
        if part.LocalTransparencyModifier >= 0.99 then
            self:Remove(part)
        else
            self:Draw(part)
        end
    end))

    table.insert(conns, part.Destroying:Connect(function()
        self:Remove(part)
    end))

    self.Connections[part] = conns
end

function MeowWireframe:Scan(container)
    if not container then return end
    for _, p in ipairs(container:GetDescendants()) do
        if p:IsA("BasePart") and p.Transparency < 1 then
            self:Watch(p)
            if p.LocalTransparencyModifier < 0.99 then
                self:Draw(p)
            end
        end
    end
end

function MeowWireframe:Remove(part)
    local entry = self.ActiveWires[part]
    if entry then
        pcall(function() entry.Wire:Destroy() end)
        self.ActiveWires[part] = nil
        if part.Parent then
            pcall(function() part.Transparency = entry.OrigTransparency or 0 end)
        end
    end
    if self.Connections[part] then
        for _, c in ipairs(self.Connections[part]) do pcall(function() c:Disconnect() end) end
        self.Connections[part] = nil
    end
end

function MeowWireframe:Clear()
    for part in pairs(self.ActiveWires) do
        self:Remove(part)
    end
    for part, conns in pairs(self.Connections) do
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    end
    table.clear(self.ActiveWires)
    table.clear(self.Connections)
    self.CurrentGun = nil
    self.CurrentArms = nil
end

function MeowWireframe:GetGunModel()

    pcall(function()
        local fc = rawget(getgenv(), "FighterController")
        if fc and fc.LocalFighter and fc.LocalFighter.EquippedItem then
            local vm = fc.LocalFighter.EquippedItem.ViewModel
            if vm and vm.ItemModel then return vm.ItemModel end
        end
    end)

    local vms = Camera:FindFirstChild("ViewModels") or Workspace:FindFirstChild("ViewModels")
    if vms then
        for _, vm in ipairs(vms:GetChildren()) do
            local item = vm:FindFirstChild("ItemModel") or vm:FindFirstChild("ItemVisual") or vm:FindFirstChild("Weapon")
            if item then return item end
            if #vm:GetChildren() > 0 then return vm end
        end
    end

    local char = LocalPlayer and LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then return tool end
    return nil
end

function MeowWireframe:GetArmsModel()
    local vms = Camera:FindFirstChild("ViewModels") or Workspace:FindFirstChild("ViewModels")
    if vms then
        for _, vm in ipairs(vms:GetChildren()) do
            local arms = vm:FindFirstChild("Arms") or vm:FindFirstChild("LeftArm") or vm:FindFirstChild("RightArm")
            if arms then return arms.Parent end
        end
    end
    return nil
end

function MeowWireframe:Update()
    if not self.Enabled and not self.ArmEnabled then
        if self.CurrentGun or self.CurrentArms then
            self:Clear()
        end
        return
    end

    if self.Enabled then
        local gun = self:GetGunModel()
        if gun ~= self.CurrentGun then
            if self.CurrentGun then
                for part in pairs(self.ActiveWires) do
                    if part:IsDescendantOf(self.CurrentGun) then self:Remove(part) end
                end
            end
            self.CurrentGun = gun
            if self.CurrentGun then
                self:Scan(self.CurrentGun)
            end
        end
    elseif self.CurrentGun then
        for part in pairs(self.ActiveWires) do
            if part:IsDescendantOf(self.CurrentGun) then self:Remove(part) end
        end
        self.CurrentGun = nil
    end

    if self.ArmEnabled then
        local arms = self:GetArmsModel()
        if arms ~= self.CurrentArms then
            if self.CurrentArms then
                for part in pairs(self.ActiveWires) do
                    if part:IsDescendantOf(self.CurrentArms) then self:Remove(part) end
                end
            end
            self.CurrentArms = arms
            if self.CurrentArms then
                self:Scan(self.CurrentArms)
            end
        end
    elseif self.CurrentArms then
        for part in pairs(self.ActiveWires) do
            if part:IsDescendantOf(self.CurrentArms) then self:Remove(part) end
        end
        self.CurrentArms = nil
    end

    for part, entry in pairs(self.ActiveWires) do
        if part.Parent and part.Size ~= entry.Size then
            entry.Size = part.Size
            self:Rebuild(entry.Wire, part)
        end
    end
end

getgenv().MeowWireframe = MeowWireframe

local function restoreWeaponVisuals()
    MeowWireframe:Clear()
    if meowState.WeaponHighlight then
        pcall(function() meowState.WeaponHighlight:Destroy() end)
        meowState.WeaponHighlight = nil
    end
    for part, props in pairs(meowState.SavedPartProps) do
        pcall(function()
            if part and part.Parent then
                part.Material = props.Material
                part.Color = props.Color
                part.Transparency = props.Transparency
            end
        end)
    end
    table.clear(meowState.SavedPartProps)
end

local function updateWeaponVisuals()

    MeowWireframe.Enabled     = flags.item_wireframe or false
    MeowWireframe.ArmEnabled  = flags.arm_appearance or false
    MeowWireframe.Color       = flags.wireframe_color or Color3.fromRGB(255, 255, 255)
    MeowWireframe.Color2      = flags.wireframe_color2 or Color3.fromRGB(0, 162, 255)
    MeowWireframe.ColorMiddle = (flags.wireframe_color or Color3.fromRGB(255, 255, 255)):Lerp(flags.wireframe_color2 or Color3.fromRGB(0, 162, 255), 0.5)
    MeowWireframe.Transparency = flags.item_chams_transparency or 0

    MeowWireframe:Update()

    local itemVisual = MeowWireframe:GetGunModel()
    if not itemVisual then return end

    local chamsEnabled = flags.item_chams
    local chamsMat = flags.item_chams_material or "ForceField"
    local chamsColor = flags.item_chams_color or Color3.fromRGB(0, 162, 255)
    local chamsTrans = flags.item_chams_transparency or 0.2

    if chamsEnabled and not MeowWireframe.Enabled then
        for _, part in ipairs(itemVisual:GetDescendants()) do
            if part:IsA("BasePart") then
                if not meowState.SavedPartProps[part] then
                    meowState.SavedPartProps[part] = {
                        Material     = part.Material,
                        Color        = part.Color,
                        Transparency = part.Transparency,
                    }
                end
                pcall(function()
                    if Enum.Material[chamsMat] then
                        part.Material = Enum.Material[chamsMat]
                    else
                        part.Material = Enum.Material.ForceField
                    end
                    part.Color = chamsColor
                    part.Transparency = chamsTrans
                end)
            end
        end
    end
end
local function initProceduralDrawings()
    for i = 1, 4 do
        local l = Drawing.new("Line")
        local o = Drawing.new("Line")
        table.insert(meowState.CrosshairLines, l)
        table.insert(meowState.CrosshairOutlines, o)
    end
    local dot = Drawing.new("Circle")
    dot.Filled = true
    dot.Visible = false
    meowState.CrosshairDot = dot

    local dotOut = Drawing.new("Circle")
    dotOut.Filled = false
    dotOut.Visible = false
    meowState.CrosshairDotOutline = dotOut
    local circ = Drawing.new("Circle")
    circ.Thickness = 1.5
    circ.NumSides = 64
    circ.Visible = false
    meowState.SilentFovCircle = circ

    local aCirc = Drawing.new("Circle")
    aCirc.Thickness = 1.5
    aCirc.NumSides = 64
    aCirc.Visible = false
    meowState.AimbotFovCircle = aCirc
end

local crosshairRotAngle = 0
local function updateCrosshair()
    if not flags.crosshair_enabled then
        for _, l in ipairs(meowState.CrosshairLines) do l.Visible = false end
        for _, o in ipairs(meowState.CrosshairOutlines) do o.Visible = false end
        if meowState.CrosshairDot then meowState.CrosshairDot.Visible = false end
        if meowState.CrosshairDotOutline then meowState.CrosshairDotOutline.Visible = false end
        return
    end

    local center = Camera.ViewportSize / 2
    local length = flags.crosshair_length or 14
    local offset = flags.crosshair_offset or 6
    local thickness = flags.crosshair_thickness or 2
    local col = flags.crosshair_color or Color3.fromRGB(0, 162, 255)

    if flags.crosshair_rainbow then
        local spd = (flags.crosshair_rainbow_speed or 2) * 0.1
        col = Color3.fromHSV((tick() * spd) % 1, 0.85, 1)
    end

    local rotSpeed = flags.crosshair_rotation_speed or 0
    local staticRot = flags.crosshair_rotation or 0
    local bounceSpeed = flags.crosshair_bounce_speed or 0
    local bounceAmp = flags.crosshair_bounce_amp or 0

    if rotSpeed > 0 then
        crosshairRotAngle = (crosshairRotAngle + (rotSpeed * 0.05)) % (math.pi * 2)
    end

    local currentOffset = offset
    if bounceSpeed > 0 and bounceAmp > 0 then
        currentOffset = offset + ((math.sin(tick() * bounceSpeed) + 1) / 2 * bounceAmp)
    end

    if flags.crosshair_hit_pulse and (os.clock() - meowState.LastHitmarkerTime < 0.16) then
        currentOffset = currentOffset + 6
    end

    if flags.crosshair_dot and meowState.CrosshairDot then
        local dot = meowState.CrosshairDot
        local dotOut = meowState.CrosshairDotOutline
        local dotSize = flags.crosshair_dot_size or 2.5
        local dotColor = flags.crosshair_dot_color or col

        dot.Position = center
        dot.Radius = dotSize
        dot.Color = dotColor
        dot.Visible = true
        if (flags.crosshair_outline ~= false) and dotOut then
            dotOut.Position = center
            dotOut.Radius = dotSize + 1.2
            dotOut.Thickness = 1.5
            dotOut.Color = Color3.fromRGB(0, 0, 0)
            dotOut.Visible = true
        elseif dotOut then
            dotOut.Visible = false
        end
    else
        if meowState.CrosshairDot then meowState.CrosshairDot.Visible = false end
        if meowState.CrosshairDotOutline then meowState.CrosshairDotOutline.Visible = false end
    end

    local totalAngleBase = crosshairRotAngle + math.rad(staticRot)

    for idx = 1, 4 do
        local line = meowState.CrosshairLines[idx]
        local out = meowState.CrosshairOutlines[idx]

        if flags.crosshair_t_shape and idx == 1 then
            if line then line.Visible = false end
            if out then out.Visible = false end
        else
            local angle = totalAngleBase + ((idx - 1) * (math.pi / 2))
            local dir = Vector2.new(math.cos(angle), math.sin(angle))
            local fromP = center + dir * currentOffset
            local toP = center + dir * (currentOffset + length)

            if line then
                line.From = fromP
                line.To = toP
                line.Thickness = thickness
                line.Color = col
                line.Visible = true
            end

            if out and (flags.crosshair_outline ~= false) then
                out.From = center + dir * math.max(0, currentOffset - 1)
                out.To = center + dir * (currentOffset + length + 1)
                out.Thickness = thickness + 2
                out.Color = Color3.fromRGB(0, 0, 0)
                out.Visible = true
            elseif out then
                out.Visible = false
            end
        end
    end
end

local fovSpinAngle = 0
local function updateFovCircles()
    local center = Camera.ViewportSize / 2

    local circ = meowState.SilentFovCircle
    if circ then
        if flags.silent_aim_visualise_range and flags.silent_aim_enabled then
            circ.Position = center
            circ.Radius = flags.fov_radius_smoothed or 120
            circ.Color = flags.fov_color or Color3.fromRGB(0, 162, 255)
            if flags.fov_spin_value then
                fovSpinAngle = (fovSpinAngle + ((flags.fov_rotation_speed or 10) * 0.005)) % 1
                circ.Color = Color3.fromHSV(fovSpinAngle, 0.8, 1)
            end
            circ.Filled = flags.fov_filled == true
            circ.Transparency = flags.fov_filled and 0.25 or 1
            circ.Visible = true
        else
            circ.Visible = false
        end
    end

    local aCirc = meowState.AimbotFovCircle
    if aCirc then
        if flags.aimbot_enabled and flags.aimbot_visualise_range then
            aCirc.Position = center
            aCirc.Radius = flags.aimbot_radius_smoothed or 90
            aCirc.Color = Color3.fromRGB(120, 180, 255)
            aCirc.Visible = true
        else
            aCirc.Visible = false
        end
    end
end

local function createEspEntry(player)
    local corners = {}
    for i = 1, 8 do
        local l = Drawing.new("Line")
        l.Visible = false
        corners[i] = l
    end
    return {
        Player = player,
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        BoxFill = Drawing.new("Square"),
        BoxCorners = corners,
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        HealthNumber = Drawing.new("Text"),
        AmmoBar = Drawing.new("Square"),
        AmmoBarOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Weapon = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Rank = Drawing.new("Text"),
        Streak = Drawing.new("Text"),
        Deflecting = Drawing.new("Text"),
        HeadMarker = Drawing.new("Circle"),
        Tracer = Drawing.new("Line"),
        TracerOutline = Drawing.new("Line"),
    }
end

local function cleanEspEntry(entry)
    if not entry then return end
    pcall(function() entry.Box:Destroy() end)
    pcall(function() entry.BoxOutline:Destroy() end)
    pcall(function() entry.BoxFill:Destroy() end)
    if entry.BoxCorners then
        for _, l in ipairs(entry.BoxCorners) do
            pcall(function() l:Destroy() end)
        end
    end
    pcall(function() entry.HealthBar:Destroy() end)
    pcall(function() entry.HealthBarOutline:Destroy() end)
    pcall(function() entry.HealthNumber:Destroy() end)
    pcall(function() entry.AmmoBar:Destroy() end)
    pcall(function() entry.AmmoBarOutline:Destroy() end)
    pcall(function() entry.Name:Destroy() end)
    pcall(function() entry.Weapon:Destroy() end)
    pcall(function() entry.Distance:Destroy() end)
    pcall(function() entry.Rank:Destroy() end)
    pcall(function() entry.Streak:Destroy() end)
    pcall(function() entry.Deflecting:Destroy() end)
    pcall(function() entry.HeadMarker:Destroy() end)
    pcall(function() entry.Tracer:Destroy() end)
    pcall(function() entry.TracerOutline:Destroy() end)
end

local function formatEspSurround(text, surround)
    surround = surround or "None"
    if surround == "[]" then return "[" .. text .. "]"
    elseif surround == "()" then return "(" .. text .. ")"
    elseif surround == "<>" then return "<" .. text .. ">"
    elseif surround == "{}" then return "{" .. text .. "}"
    end
    return text
end

local function formatEspCase(text, tcase)
    tcase = tcase or "Standard"
    if tcase == "UPPERCASE" then return string.upper(text)
    elseif tcase == "lowercase" then return string.lower(text)
    end
    return text
end

local function updateEsp()
    if not flags.esp_enabled and not flags.esp_team_enabled then
        for _, entry in pairs(meowState.EspBoxes) do
            entry.Box.Visible = false
            entry.BoxOutline.Visible = false
            entry.BoxFill.Visible = false
            if entry.BoxCorners then
                for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
            end
            entry.HealthBar.Visible = false
            entry.HealthBarOutline.Visible = false
            entry.HealthNumber.Visible = false
            entry.AmmoBar.Visible = false
            entry.AmmoBarOutline.Visible = false
            entry.Name.Visible = false
            entry.Weapon.Visible = false
            entry.Distance.Visible = false
            entry.Rank.Visible = false
            entry.Streak.Visible = false
            entry.Deflecting.Visible = false
            entry.HeadMarker.Visible = false
            entry.Tracer.Visible = false
            entry.TracerOutline.Visible = false
        end
        return
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local maxDist = flags.esp_max_distance or 1500

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local isTeammate = pl.Team ~= nil and pl.Team == LocalPlayer.Team
            if isTeammate and flags.esp_team_check and not flags.esp_team_enabled then
                local e = meowState.EspBoxes[pl]
                if e then
                    e.Box.Visible = false
                    e.BoxOutline.Visible = false
                    e.BoxFill.Visible = false
                    if e.BoxCorners then
                        for _, l in ipairs(e.BoxCorners) do l.Visible = false end
                    end
                    e.HealthBar.Visible = false
                    e.HealthBarOutline.Visible = false
                    e.HealthNumber.Visible = false
                    e.AmmoBar.Visible = false
                    e.AmmoBarOutline.Visible = false
                    e.Name.Visible = false
                    e.Weapon.Visible = false
                    e.Distance.Visible = false
                    e.Rank.Visible = false
                    e.Streak.Visible = false
                    e.Deflecting.Visible = false
                    e.HeadMarker.Visible = false
                    e.Tracer.Visible = false
                    e.TracerOutline.Visible = false
                end
                continue
            end

            local entry = meowState.EspBoxes[pl]
            if not entry then
                entry = createEspEntry(pl)
                meowState.EspBoxes[pl] = entry
            end

            local char = pl.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if char and hum and hum.Health > 0 and root and myRoot then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= maxDist then
                    local scrPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local head = char:FindFirstChild("Head")
                        local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0)) or scrPos
                        local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                        local boxHeight = math.abs(headPos.Y - footPos.Y)
                        local boxWidth = flags.esp_box_fit == "Static" and 50 or (boxHeight * 0.65)
                        local boxX = scrPos.X - (boxWidth / 2)
                        local boxY = headPos.Y

                        local showBox = isTeammate and flags.esp_team_boxes or (flags.esp_boxes ~= false and flags.esp_box ~= false)
                        local boxColor = isTeammate and (flags.esp_team_box_color or Color3.fromRGB(80, 180, 255)) or (flags.esp_box_color or Color3.fromRGB(255, 255, 255))
                        local boxStyle = flags.esp_box_style or "Corner"

                        if showBox and boxStyle == "Full" then
                            entry.BoxOutline.Position = Vector2.new(boxX - 1, boxY - 1)
                            entry.BoxOutline.Size = Vector2.new(boxWidth + 2, boxHeight + 2)
                            entry.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
                            entry.BoxOutline.Thickness = 2.5
                            entry.BoxOutline.Visible = true

                            entry.Box.Position = Vector2.new(boxX, boxY)
                            entry.Box.Size = Vector2.new(boxWidth, boxHeight)
                            entry.Box.Color = boxColor
                            entry.Box.Thickness = 1.2
                            entry.Box.Visible = true

                            if entry.BoxCorners then
                                for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
                            end
                        elseif showBox and boxStyle == "Corner" then
                            entry.Box.Visible = false
                            entry.BoxOutline.Visible = false
                            local clen = math.clamp(boxWidth * 0.25, 4, 18)
                            local c = entry.BoxCorners
                            if c and #c >= 8 then
                                c[1].From = Vector2.new(boxX, boxY)
                                c[1].To = Vector2.new(boxX + clen, boxY)
                                c[2].From = Vector2.new(boxX, boxY)
                                c[2].To = Vector2.new(boxX, boxY + clen)

                                c[3].From = Vector2.new(boxX + boxWidth, boxY)
                                c[3].To = Vector2.new(boxX + boxWidth - clen, boxY)
                                c[4].From = Vector2.new(boxX + boxWidth, boxY)
                                c[4].To = Vector2.new(boxX + boxWidth, boxY + clen)

                                c[5].From = Vector2.new(boxX, boxY + boxHeight)
                                c[5].To = Vector2.new(boxX + clen, boxY + boxHeight)
                                c[6].From = Vector2.new(boxX, boxY + boxHeight)
                                c[6].To = Vector2.new(boxX, boxY + boxHeight - clen)

                                c[7].From = Vector2.new(boxX + boxWidth, boxY + boxHeight)
                                c[7].To = Vector2.new(boxX + boxWidth - clen, boxY + boxHeight)
                                c[8].From = Vector2.new(boxX + boxWidth, boxY + boxHeight)
                                c[8].To = Vector2.new(boxX + boxWidth, boxY + boxHeight - clen)

                                for i = 1, 8 do
                                    c[i].Color = boxColor
                                    c[i].Thickness = 1.5
                                    c[i].Visible = true
                                end
                            end
                        else
                            entry.Box.Visible = false
                            entry.BoxOutline.Visible = false
                            if entry.BoxCorners then
                                for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
                            end
                        end

                        if flags.esp_box_fill then
                            entry.BoxFill.Position = Vector2.new(boxX, boxY)
                            entry.BoxFill.Size = Vector2.new(boxWidth, boxHeight)
                            entry.BoxFill.Color = flags.esp_fill_color or Color3.fromRGB(0, 162, 255)
                            entry.BoxFill.Filled = true
                            entry.BoxFill.Transparency = 0.25
                            entry.BoxFill.Visible = true
                        else
                            entry.BoxFill.Visible = false
                        end
                        local showHp = isTeammate and flags.esp_team_health or (flags.esp_health_bars ~= false and flags.esp_health_bar ~= false)
                        local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        if showHp then
                            local barWidth = 3
                            local fillH = boxHeight * hpPct
                            local hpColor = flags.esp_health_color or Color3.fromRGB(0, 255, 120)
                            if flags.esp_health_mode == "Reactive" then
                                hpColor = Color3.fromRGB(math.floor(255 * (1 - hpPct)), math.floor(255 * hpPct), 40)
                            end

                            entry.HealthBarOutline.Position = Vector2.new(boxX - 6, boxY - 1)
                            entry.HealthBarOutline.Size = Vector2.new(barWidth + 2, boxHeight + 2)
                            entry.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
                            entry.HealthBarOutline.Filled = true
                            entry.HealthBarOutline.Visible = true

                            entry.HealthBar.Position = Vector2.new(boxX - 5, boxY + (boxHeight - fillH))
                            entry.HealthBar.Size = Vector2.new(barWidth, fillH)
                            entry.HealthBar.Color = hpColor
                            entry.HealthBar.Filled = true
                            entry.HealthBar.Visible = true
                        else
                            entry.HealthBar.Visible = false
                            entry.HealthBarOutline.Visible = false
                        end

                        if flags.esp_health_number and showHp then
                            entry.HealthNumber.Text = tostring(math.floor(hum.Health))
                            entry.HealthNumber.Position = Vector2.new(boxX - 8, boxY + (boxHeight * (1 - hpPct)) - 5)
                            entry.HealthNumber.Size = 10
                            entry.HealthNumber.Color = flags.esp_hp_num_color or Color3.fromRGB(255, 255, 255)
                            entry.HealthNumber.Outline = true
                            entry.HealthNumber.Center = false
                            entry.HealthNumber.Visible = true
                        else
                            entry.HealthNumber.Visible = false
                        end

                        if flags.esp_ammo_bar then
                            local ammoPct = 0.75
                            pcall(function()
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool and tool:FindFirstChild("Ammo") then
                                    ammoPct = math.clamp(tool.Ammo.Value / (tool:FindFirstChild("MaxAmmo") and tool.MaxAmmo.Value or 30), 0, 1)
                                end
                            end)
                            entry.AmmoBarOutline.Position = Vector2.new(boxX - 1, boxY + boxHeight + 2)
                            entry.AmmoBarOutline.Size = Vector2.new(boxWidth + 2, 4)
                            entry.AmmoBarOutline.Color = Color3.fromRGB(0, 0, 0)
                            entry.AmmoBarOutline.Filled = true
                            entry.AmmoBarOutline.Visible = true

                            entry.AmmoBar.Position = Vector2.new(boxX, boxY + boxHeight + 3)
                            entry.AmmoBar.Size = Vector2.new(boxWidth * ammoPct, 2)
                            entry.AmmoBar.Color = flags.esp_ammo_color or Color3.fromRGB(0, 162, 255)
                            entry.AmmoBar.Filled = true
                            entry.AmmoBar.Visible = true
                        else
                            entry.AmmoBar.Visible = false
                            entry.AmmoBarOutline.Visible = false
                        end

                        local showName = isTeammate and flags.esp_team_names or (flags.esp_names ~= false and flags.esp_name ~= false)
                        if showName then
                            local rawName = flags.esp_display_names and pl.DisplayName or pl.Name
                            local formattedName = formatEspCase(rawName, flags.esp_text_case)
                            formattedName = formatEspSurround(formattedName, flags.esp_text_surround)
                            entry.Name.Text = formattedName
                            entry.Name.Position = Vector2.new(scrPos.X, boxY - (flags.esp_font_size or 13) - 2)
                            entry.Name.Center = true
                            entry.Name.Outline = true
                            entry.Name.Color = isTeammate and (flags.esp_team_name_color or Color3.fromRGB(80, 180, 255)) or (flags.esp_name_color or Color3.fromRGB(240, 240, 240))
                            entry.Name.Size = flags.esp_font_size or 13
                            entry.Name.Visible = true
                        else
                            entry.Name.Visible = false
                        end

                        local flagOffset = 0
                        local flagX = boxX + boxWidth + 4
                        local flagSize = flags.esp_flag_size or 10

                        if flags.esp_weapons ~= false and flags.esp_weapon ~= false then
                            local tool = char:FindFirstChildOfClass("Tool")
                            local wText = tool and tool.Name or "None"
                            wText = formatEspCase(wText, flags.esp_text_case)
                            entry.Weapon.Text = formatEspSurround(wText, flags.esp_flag_surround)
                            entry.Weapon.Position = Vector2.new(flagX, boxY + flagOffset)
                            entry.Weapon.Center = false
                            entry.Weapon.Outline = true
                            entry.Weapon.Color = flags.esp_weapon_color or Color3.fromRGB(220, 220, 220)
                            entry.Weapon.Size = flagSize
                            entry.Weapon.Visible = true
                            flagOffset = flagOffset + flagSize + 1
                        else
                            entry.Weapon.Visible = false
                        end

                        if flags.esp_distance ~= false then
                            local distText = tostring(math.floor(dist)) .. "m"
                            entry.Distance.Text = formatEspSurround(distText, flags.esp_flag_surround)
                            entry.Distance.Position = Vector2.new(flagX, boxY + flagOffset)
                            entry.Distance.Center = false
                            entry.Distance.Outline = true
                            entry.Distance.Color = flags.esp_dist_color or Color3.fromRGB(180, 180, 180)
                            entry.Distance.Size = flagSize
                            entry.Distance.Visible = true
                            flagOffset = flagOffset + flagSize + 1
                        else
                            entry.Distance.Visible = false
                        end

                        if flags.esp_rank then
                            local r = pl:GetAttribute("Rank") or pl:GetAttribute("RankName") or "Unranked"
                            entry.Rank.Text = formatEspSurround(tostring(r), flags.esp_flag_surround)
                            entry.Rank.Position = Vector2.new(flagX, boxY + flagOffset)
                            entry.Rank.Center = false
                            entry.Rank.Outline = true
                            entry.Rank.Color = flags.esp_rank_color or Color3.fromRGB(255, 215, 0)
                            entry.Rank.Size = flagSize
                            entry.Rank.Visible = true
                            flagOffset = flagOffset + flagSize + 1
                        else
                            entry.Rank.Visible = false
                        end
                        if flags.esp_streak then
                            local s = pl:GetAttribute("StatisticDuelsWinStreak") or pl:GetAttribute("WinStreak") or 0
                            entry.Streak.Text = formatEspSurround("WS: " .. tostring(s), flags.esp_flag_surround)
                            entry.Streak.Position = Vector2.new(flagX, boxY + flagOffset)
                            entry.Streak.Center = false
                            entry.Streak.Outline = true
                            entry.Streak.Color = flags.esp_streak_color or Color3.fromRGB(255, 100, 50)
                            entry.Streak.Size = flagSize
                            entry.Streak.Visible = true
                            flagOffset = flagOffset + flagSize + 1
                        else
                            entry.Streak.Visible = false
                        end

                        if flags.esp_deflecting then
                            local isDeflect = false
                            pcall(function()
                                isDeflect = char:GetAttribute("Deflecting") == true
                                    or char:GetAttribute("IsDeflecting") == true
                                    or char:FindFirstChild("DeflectEffect") ~= nil
                                    or char:FindFirstChild("Parry") ~= nil
                            end)
                            if isDeflect then
                                entry.Deflecting.Text = "[DEFLECTING]"
                                entry.Deflecting.Position = Vector2.new(flagX, boxY + flagOffset)
                                entry.Deflecting.Center = false
                                entry.Deflecting.Outline = true
                                entry.Deflecting.Color = flags.esp_deflect_color or Color3.fromRGB(255, 0, 150)
                                entry.Deflecting.Size = flagSize
                                entry.Deflecting.Visible = true
                                flagOffset = flagOffset + flagSize + 1
                            else
                                entry.Deflecting.Visible = false
                            end
                        else
                            entry.Deflecting.Visible = false
                        end

                        if flags.head_marker_enabled and head then
                            entry.HeadMarker.Position = Vector2.new(headPos.X, headPos.Y)
                            entry.HeadMarker.Radius = 4
                            entry.HeadMarker.Color = flags.head_marker_color or Color3.fromRGB(255, 50, 50)
                            entry.HeadMarker.Filled = flags.head_marker_filled == true
                            entry.HeadMarker.Thickness = 1.2
                            entry.HeadMarker.Visible = true
                        else
                            entry.HeadMarker.Visible = false
                        end

                        if flags.esp_tracers then
                            local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            if flags.esp_tracer_origin == "Center" then
                                origin = Camera.ViewportSize / 2
                            elseif flags.esp_tracer_origin == "Top" then
                                origin = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            elseif flags.esp_tracer_origin == "Mouse" then
                                origin = UserInputService:GetMouseLocation()
                            end

                            local targetPos = Vector2.new(scrPos.X, footPos.Y)
                            if flags.esp_tracer_target == "Head" then
                                targetPos = Vector2.new(headPos.X, headPos.Y)
                            end

                            if flags.esp_tracer_outline then
                                entry.TracerOutline.From = origin
                                entry.TracerOutline.To = targetPos
                                entry.TracerOutline.Color = flags.esp_tracer_outline_color or Color3.fromRGB(0, 0, 0)
                                entry.TracerOutline.Thickness = (flags.esp_tracer_thickness or 1) + 2
                                entry.TracerOutline.Visible = true
                            else
                                entry.TracerOutline.Visible = false
                            end

                            entry.Tracer.From = origin
                            entry.Tracer.To = targetPos
                            entry.Tracer.Color = flags.esp_tracer_color or Color3.fromRGB(0, 162, 255)
                            entry.Tracer.Thickness = flags.esp_tracer_thickness or 1
                            entry.Tracer.Visible = true
                        else
                            entry.Tracer.Visible = false
                            entry.TracerOutline.Visible = false
                        end
                    else
                        entry.Box.Visible = false
                        entry.BoxOutline.Visible = false
                        entry.BoxFill.Visible = false
                        if entry.BoxCorners then
                            for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
                        end
                        entry.HealthBar.Visible = false
                        entry.HealthBarOutline.Visible = false
                        entry.HealthNumber.Visible = false
                        entry.AmmoBar.Visible = false
                        entry.AmmoBarOutline.Visible = false
                        entry.Name.Visible = false
                        entry.Weapon.Visible = false
                        entry.Distance.Visible = false
                        entry.Rank.Visible = false
                        entry.Streak.Visible = false
                        entry.Deflecting.Visible = false
                        entry.HeadMarker.Visible = false
                        entry.Tracer.Visible = false
                        entry.TracerOutline.Visible = false
                    end
                else
                    entry.Box.Visible = false
                    entry.BoxOutline.Visible = false
                    entry.BoxFill.Visible = false
                    if entry.BoxCorners then
                        for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
                    end
                    entry.HealthBar.Visible = false
                    entry.HealthBarOutline.Visible = false
                    entry.HealthNumber.Visible = false
                    entry.AmmoBar.Visible = false
                    entry.AmmoBarOutline.Visible = false
                    entry.Name.Visible = false
                    entry.Weapon.Visible = false
                    entry.Distance.Visible = false
                    entry.Rank.Visible = false
                    entry.Streak.Visible = false
                    entry.Deflecting.Visible = false
                    entry.HeadMarker.Visible = false
                    entry.Tracer.Visible = false
                    entry.TracerOutline.Visible = false
                end
            else
                entry.Box.Visible = false
                entry.BoxOutline.Visible = false
                entry.BoxFill.Visible = false
                if entry.BoxCorners then
                    for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
                end
                entry.HealthBar.Visible = false
                entry.HealthBarOutline.Visible = false
                entry.HealthNumber.Visible = false
                entry.AmmoBar.Visible = false
                entry.AmmoBarOutline.Visible = false
                entry.Name.Visible = false
                entry.Weapon.Visible = false
                entry.Distance.Visible = false
                entry.Rank.Visible = false
                entry.Streak.Visible = false
                entry.Deflecting.Visible = false
                entry.HeadMarker.Visible = false
                entry.Tracer.Visible = false
                entry.TracerOutline.Visible = false
            end
        end
    end
end

local function updateChams()
    if not flags.chams_enabled then
        for _, hl in pairs(meowState.ChamsHighlights) do hl.Enabled = false end
        return
    end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local hl = meowState.ChamsHighlights[pl]
            if not hl or not hl.Parent then
                hl = Instance.new("Highlight")
                hl.Name = "_MeowChams"
                hl.Parent = (gethui and gethui()) or game:GetService("CoreGui")
                meowState.ChamsHighlights[pl] = hl
            end

            hl.Adornee = pl.Character
            hl.FillColor = flags.chams_color or Color3.fromRGB(0, 162, 255)
            hl.OutlineColor = flags.chams_color or Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = flags.chams_fill_transparency or 0.4
            hl.OutlineTransparency = flags.chams_outline_transparency or 0
            hl.DepthMode = (flags.chams_depth_mode == "Occluded") and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = true
        end
    end
end

local originalLightingProps = {
    Ambient              = Lighting.Ambient,
    OutdoorAmbient       = Lighting.OutdoorAmbient,
    FogColor             = Lighting.FogColor,
    FogStart             = Lighting.FogStart,
    FogEnd               = Lighting.FogEnd,
    Brightness           = Lighting.Brightness,
    ClockTime            = Lighting.ClockTime,
    GlobalShadows        = Lighting.GlobalShadows,
    ShadowSoftness       = Lighting.ShadowSoftness,
    ExposureCompensation = Lighting.ExposureCompensation,
    Technology           = Lighting.Technology,
}

local SKYBOX_PRESETS = {
    ["GreenHaze"] = {
        SunAngularSize = 0,
        SkyboxUp = "rbxassetid://160193458", SkyboxDn = "rbxassetid://160193466",
        SkyboxFt = "rbxassetid://160193461", SkyboxBk = "rbxassetid://160193404",
        SkyboxLf = "rbxassetid://160193469", SkyboxRt = "rbxassetid://160193463"
    },
    ["Space2"] = {
        StarCount = 3000, SunAngularSize = 11, MoonAngularSize = 20,
        SkyboxUp = "rbxassetid://11844053742", SkyboxDn = "rbxassetid://11844069700",
        SkyboxFt = "rbxassetid://11844067209", SkyboxBk = "rbxassetid://11844076072",
        SkyboxLf = "rbxassetid://11844063543", SkyboxRt = "rbxassetid://11844058446"
    },
    ["PinkMountains"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://160188588", SkyboxDn = "rbxassetid://160188614",
        SkyboxFt = "rbxassetid://160188609", SkyboxBk = "rbxassetid://160188495",
        SkyboxLf = "rbxassetid://160188589", SkyboxRt = "rbxassetid://160188597"
    },
    ["Valentines"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://11427771954", SkyboxDn = "rbxassetid://11427770685",
        SkyboxFt = "rbxassetid://11427769401", SkyboxBk = "rbxassetid://11427769401",
        SkyboxLf = "rbxassetid://11427769401", SkyboxRt = "rbxassetid://11427769401"
    },
    ["PinkArt"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://79190209626172", SkyboxDn = "rbxassetid://78865378050055",
        SkyboxFt = "rbxassetid://104560113223878", SkyboxBk = "rbxassetid://71607054149497",
        SkyboxLf = "rbxassetid://80395333901607", SkyboxRt = "rbxassetid://87570388049514"
    },
    ["PurplePlanet"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://16262366016", SkyboxDn = "rbxassetid://16262358026",
        SkyboxFt = "rbxassetid://16262360469", SkyboxBk = "rbxassetid://16262356578",
        SkyboxLf = "rbxassetid://16262362003", SkyboxRt = "rbxassetid://16262363873"
    },
    ["Blizzard"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://16653228333", SkyboxDn = "rbxassetid://16653222701",
        SkyboxFt = "rbxassetid://16653224051", SkyboxBk = "rbxassetid://16653221738",
        SkyboxLf = "rbxassetid://16653225849", SkyboxRt = "rbxassetid://16653227200"
    },
    ["Winter"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://155674931", SkyboxDn = "rbxassetid://155674246",
        SkyboxFt = "rbxassetid://155657609", SkyboxBk = "rbxassetid://155657655",
        SkyboxLf = "rbxassetid://155657671", SkyboxRt = "rbxassetid://155657619"
    },
    ["FlamingSunset"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://415688354", SkyboxDn = "rbxassetid://415688193",
        SkyboxFt = "rbxassetid://415688242", SkyboxBk = "rbxassetid://415688378",
        SkyboxLf = "rbxassetid://415688310", SkyboxRt = "rbxassetid://415688274"
    },
    ["Mountains"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://15359412677", SkyboxDn = "rbxassetid://15359411132",
        SkyboxFt = "rbxassetid://15359412131", SkyboxBk = "rbxassetid://15359410490",
        SkyboxLf = "rbxassetid://15359411633", SkyboxRt = "rbxassetid://15359417656"
    },
    ["FPSBoost"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://11457548274", SkyboxDn = "rbxassetid://11457548274",
        SkyboxFt = "rbxassetid://11457548274", SkyboxBk = "rbxassetid://11457548274",
        SkyboxLf = "rbxassetid://11457548274", SkyboxRt = "rbxassetid://11457548274"
    },
    ["AestheticMountains"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 11,
        SkyboxUp = "rbxassetid://15470207755", SkyboxDn = "rbxassetid://15470151245",
        SkyboxFt = "rbxassetid://15470200128", SkyboxBk = "rbxassetid://15470198023",
        SkyboxLf = "rbxassetid://15470202648", SkyboxRt = "rbxassetid://15470204862"
    },
    ["BetterNight3"] = {
        StarCount = 500, SunAngularSize = 21, MoonAngularSize = 1.5,
        SkyboxUp = "rbxassetid://2670644331", SkyboxDn = "rbxassetid://2670643365",
        SkyboxFt = "rbxassetid://2670643214", SkyboxBk = "rbxassetid://2670643994",
        SkyboxLf = "rbxassetid://2670643070", SkyboxRt = "rbxassetid://2670644173"
    },
    ["Galaxy2"] = {
        StarCount = 500, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://14164405298", SkyboxDn = "rbxassetid://14164386126",
        SkyboxFt = "rbxassetid://14164389230", SkyboxBk = "rbxassetid://14164368678",
        SkyboxLf = "rbxassetid://14164398493", SkyboxRt = "rbxassetid://14164402782"
    },
    ["Aesthetic3"] = {
        StarCount = 500, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://151165227", SkyboxDn = "rbxassetid://151165197",
        SkyboxFt = "rbxassetid://151165224", SkyboxBk = "rbxassetid://151165214",
        SkyboxLf = "rbxassetid://151165191", SkyboxRt = "rbxassetid://151165206"
    },
    ["PurpleSpace"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://15983964246", SkyboxDn = "rbxassetid://15983966825",
        SkyboxFt = "rbxassetid://5260817288", SkyboxBk = "rbxassetid://15983968922",
        SkyboxLf = "rbxassetid://15983967420", SkyboxRt = "rbxassetid://15983966246"
    },
    ["Pink"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://271077958", SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556", SkyboxBk = "rbxassetid://271042516",
        SkyboxLf = "rbxassetid://271042310", SkyboxRt = "rbxassetid://271042467"
    },
    ["PurpleNight"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://5084576400", SkyboxDn = "rbxassetid://5260653793",
        SkyboxFt = "rbxassetid://5260817288", SkyboxBk = "rbxassetid://5260808177",
        SkyboxLf = "rbxassetid://5260800833", SkyboxRt = "rbxassetid://5260800833"
    },
    ["Flame"] = {
        StarCount = 3000, SunAngularSize = 21, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://6286790025", SkyboxDn = "rbxassetid://6286782353",
        SkyboxFt = "rbxassetid://6286784186", SkyboxBk = "rbxassetid://6286780109",
        SkyboxLf = "rbxassetid://6286785801", SkyboxRt = "rbxassetid://6286788245"
    },
    ["Galaxy3"] = {
        StarCount = 3000, SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://14543371676", SkyboxDn = "rbxassetid://14543358958",
        SkyboxFt = "rbxassetid://14543257810", SkyboxBk = "rbxassetid://14543264135",
        SkyboxLf = "rbxassetid://14543275895", SkyboxRt = "rbxassetid://14543280890"
    },
    ["Storm"] = {
        SunAngularSize = 0, MoonAngularSize = 0,
        SkyboxUp = "rbxassetid://1618913654", SkyboxDn = "rbxassetid://1618913943",
        SkyboxFt = "rbxassetid://1618913244", SkyboxBk = "rbxassetid://1618912481",
        SkyboxLf = "rbxassetid://1618912849", SkyboxRt = "rbxassetid://1618911568"
    },
    ["Vaporwave"] = {
        SkyboxUp = "rbxassetid://14164405298", SkyboxDn = "rbxassetid://14164386126",
        SkyboxFt = "rbxassetid://14164389230", SkyboxBk = "rbxassetid://14164368678",
        SkyboxLf = "rbxassetid://14164398493", SkyboxRt = "rbxassetid://14164402782"
    },
    ["Deep Space"] = {
        SkyboxUp = "rbxassetid://15983964246", SkyboxDn = "rbxassetid://15983966825",
        SkyboxFt = "rbxassetid://5260817288", SkyboxBk = "rbxassetid://15983968922",
        SkyboxLf = "rbxassetid://15983967420", SkyboxRt = "rbxassetid://15983966246"
    },
    ["Synthwave"] = {
        SkyboxUp = "rbxassetid://16642401907", SkyboxDn = "rbxassetid://16642397027",
        SkyboxBk = "rbxassetid://16642396302", SkyboxFt = "rbxassetid://16642398372",
        SkyboxLf = "rbxassetid://16642399309", SkyboxRt = "rbxassetid://16642400745"
    },
    ["Purple Nebula"] = {
        SkyboxUp = "rbxassetid://5084576400", SkyboxDn = "rbxassetid://5260653793",
        SkyboxFt = "rbxassetid://5260817288", SkyboxBk = "rbxassetid://5260808177",
        SkyboxLf = "rbxassetid://5260800833", SkyboxRt = "rbxassetid://5260800833"
    },
    ["Night Sky"] = {
        SkyboxUp = "rbxassetid://2670644331", SkyboxDn = "rbxassetid://2670643365",
        SkyboxFt = "rbxassetid://2670643214", SkyboxBk = "rbxassetid://2670643994",
        SkyboxLf = "rbxassetid://2670643070", SkyboxRt = "rbxassetid://2670644173"
    },
    ["Red Galaxy"] = {
        SkyboxUp = "rbxassetid://14365019327", SkyboxDn = "rbxassetid://14365023350",
        SkyboxBk = "rbxassetid://14365019002", SkyboxFt = "rbxassetid://14365018399",
        SkyboxLf = "rbxassetid://14365018705", SkyboxRt = "rbxassetid://14365018143"
    },
    ["Sunset"] = {
        SkyboxUp = "rbxassetid://415688354", SkyboxDn = "rbxassetid://415688193",
        SkyboxBk = "rbxassetid://415688378", SkyboxFt = "rbxassetid://415688242",
        SkyboxLf = "rbxassetid://415688310", SkyboxRt = "rbxassetid://415688274"
    }
}

local function applySkybox(name)
    if not flags.world_skybox_enabled then
        if meowState.ActiveSkybox then
            pcall(function() meowState.ActiveSkybox:Destroy() end)
            meowState.ActiveSkybox = nil
        end
        if meowState.OriginalSkybox then
            pcall(function() meowState.OriginalSkybox.Parent = Lighting end)
        end
        return
    end

    local preset = SKYBOX_PRESETS[name]
    if not preset then return end

    if not meowState.ActiveSkybox or not meowState.ActiveSkybox.Parent then
        local oldSky = Lighting:FindFirstChildOfClass("Sky")
        if oldSky and oldSky.Name ~= "_MeowSky" then
            meowState.OriginalSkybox = oldSky
            oldSky.Parent = nil
        end
        local newSky = Instance.new("Sky")
        newSky.Name = "_MeowSky"
        newSky.Parent = Lighting
        meowState.ActiveSkybox = newSky
    end

    local sky = meowState.ActiveSkybox
    for prop, val in pairs(preset) do
        pcall(function() sky[prop] = val end)
    end
end

local strippedTextures = {}
local function updateNoTextures()
    if flags.world_no_textures then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                if not strippedTextures[obj] then
                    strippedTextures[obj] = obj.Transparency
                    obj.Transparency = 1
                end
            end
        end
    elseif next(strippedTextures) ~= nil then
        for obj, origTrans in pairs(strippedTextures) do
            if obj and obj.Parent then
                pcall(function() obj.Transparency = origTrans end)
            end
        end
        table.clear(strippedTextures)
    end
end

local function updateWorldLighting(dt)

    if flags.lighting_ambient_enabled then
        Lighting.Ambient = flags.lighting_ambient_color or Color3.fromRGB(150, 150, 150)
    elseif originalLightingProps.Ambient then
        Lighting.Ambient = originalLightingProps.Ambient
    end
    if flags.lighting_outdoor_ambient_enabled then
        Lighting.OutdoorAmbient = flags.lighting_outdoor_ambient_color or Color3.fromRGB(120, 120, 140)
    elseif originalLightingProps.OutdoorAmbient then
        Lighting.OutdoorAmbient = originalLightingProps.OutdoorAmbient
    end

    if flags.lighting_brightness_enabled then
        Lighting.Brightness = flags.lighting_brightness_value or 2
    elseif originalLightingProps.Brightness then
        Lighting.Brightness = originalLightingProps.Brightness
    end

    if flags.lighting_clocktime_enabled then
        Lighting.ClockTime = flags.lighting_clocktime_value or 14
    elseif flags.world_sky_autorotate then
        local spd = (flags.world_sky_rotate_speed or 100) / 100
        Lighting.ClockTime = (Lighting.ClockTime + (dt * spd)) % 24
    elseif originalLightingProps.ClockTime then
        Lighting.ClockTime = originalLightingProps.ClockTime
    end
    if flags.lighting_fog_enabled then
        Lighting.FogColor = flags.lighting_fog_color or Color3.fromRGB(160, 160, 180)
        Lighting.FogStart = flags.lighting_fog_start or 0
        Lighting.FogEnd   = flags.lighting_fog_end or 1000
    elseif flags.world_no_fog then
        Lighting.FogStart = 0
        Lighting.FogEnd   = 1000000
    elseif originalLightingProps.FogColor then
        Lighting.FogColor = originalLightingProps.FogColor
        Lighting.FogStart = originalLightingProps.FogStart
        Lighting.FogEnd   = originalLightingProps.FogEnd
    end

    if flags.lighting_shadows_enabled ~= nil then
        Lighting.GlobalShadows = flags.lighting_shadows_enabled
        if flags.lighting_shadow_softness then
            Lighting.ShadowSoftness = flags.lighting_shadow_softness
        end
    end

    if flags.lighting_exposure_enabled then
        Lighting.ExposureCompensation = flags.lighting_exposure_value or 0
    elseif originalLightingProps.ExposureCompensation then
        Lighting.ExposureCompensation = originalLightingProps.ExposureCompensation
    end

    if flags.lighting_technology_enabled and flags.lighting_technology then
        pcall(function()
            if Enum.Technology[flags.lighting_technology] then
                Lighting.Technology = Enum.Technology[flags.lighting_technology]
            end
        end)
    end

    if flags.color_correction_enabled then
        local cc = Lighting:FindFirstChild("_MeowColorCorrection")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "_MeowColorCorrection"
            cc.Parent = Lighting
        end
        cc.TintColor  = flags.cc_tint_color or Color3.fromRGB(255, 255, 255)
        cc.Saturation = flags.cc_saturation or 0
        cc.Contrast   = flags.cc_contrast or 0
        cc.Brightness = flags.cc_brightness or 0
        cc.Enabled    = true
    else
        local cc = Lighting:FindFirstChild("_MeowColorCorrection")
        if cc then cc.Enabled = false end
    end

    if flags.atmosphere_enabled then
        local atm = Lighting:FindFirstChild("_MeowAtmosphere")
        if not atm then
            atm = Instance.new("Atmosphere")
            atm.Name = "_MeowAtmosphere"
            atm.Parent = Lighting
        end
        atm.Color   = flags.atmosphere_color or Color3.fromRGB(199, 170, 107)
        atm.Decay   = flags.atmosphere_decay or Color3.fromRGB(106, 112, 125)
        atm.Density = flags.atmosphere_density or 0.3
        atm.Haze    = flags.atmosphere_haze or 1
        atm.Glare   = flags.atmosphere_glare or 0
    else
        local atm = Lighting:FindFirstChild("_MeowAtmosphere")
        if atm then pcall(function() atm:Destroy() end) end
    end

    updateNoTextures()

    if flags.anti_flash then
        pcall(function()
            local fb = Lighting:FindFirstChild("Flashbang") or Camera:FindFirstChild("Flashbang")
            if fb then fb:Destroy() end
        end)
    end
    if flags.anti_shake then
        pcall(function()
            local shake = Camera:FindFirstChild("CameraShake") or Camera:FindFirstChild("Shake")
            if shake then shake:Destroy() end
        end)
    end
end
local PagesModule
local ItemLibModule
pcall(function()
    local ps = LocalPlayer:FindFirstChild("PlayerScripts") or LocalPlayer:WaitForChild("PlayerScripts", 0.5)
    if ps and ps:FindFirstChild("Modules") then
        local uiMod = ps.Modules:FindFirstChild("UserInterface")
        if uiMod and uiMod:FindFirstChild("Pages") then
            PagesModule = require(uiMod.Pages)
        end
    end
end)
pcall(function()
    local rep = game:GetService("ReplicatedStorage")
    if rep:FindFirstChild("Modules") and rep.Modules:FindFirstChild("ItemLibrary") then
        ItemLibModule = require(rep.Modules.ItemLibrary)
    end
end)

local autoLoadoutFinished = false
local function runAutoLoadout()
    if not flags.auto_loadout_enabled then return end
    if not PagesModule or not PagesModule.PageSystem then return end

    local currentPage = PagesModule.PageSystem.CurrentPage
    if currentPage and currentPage.Name == "PickWeapons" then
        local slotMap = {
            Primary   = 1,
            Secondary = 2,
            Melee     = 3,
            Utility   = 4,
        }
        local weaponChoices = {
            Primary   = flags.auto_loadout_primary or "Assault Rifle",
            Secondary = flags.auto_loadout_secondary or "Handgun",
            Melee     = flags.auto_loadout_melee or "Fists",
            Utility   = flags.auto_loadout_utility or "Grenade",
        }

        for slotName, weaponName in pairs(weaponChoices) do
            local slotId = slotMap[slotName]
            if slotId and weaponName then
                local oldId = getthreadidentity and getthreadidentity() or 7
                if type(setthreadidentity) == "function" then pcall(function() setthreadidentity(2) end) end
                if currentPage and type(currentPage.PickWeapon) == "function" then pcall(function() currentPage:PickWeapon(slotId, weaponName) end) end
                if type(setthreadidentity) == "function" then pcall(function() setthreadidentity(oldId) end) end
            end
        end

        if flags.auto_loadout_finish and not autoLoadoutFinished then
            autoLoadoutFinished = true
            task.spawn(function()
                task.wait(0.12)
                pcall(function() currentPage:Finish() end)
            end)
        end
    else
        autoLoadoutFinished = false
    end
end

local function runAutoQueue()
    if not flags.auto_queue_enabled then return end
    if not PagesModule or not PagesModule.PageSystem then return end

    local currentPage = PagesModule.PageSystem.CurrentPage
    if currentPage and currentPage.Name == "GameOver" then
        pcall(function()
            if currentPage.PlayAgain then
                currentPage:PlayAgain()
            elseif currentPage.Queue then
                currentPage:Queue()
            end
        end)
    end
end

local function runBunnyHop()
    if not movementState.BHopEnabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.FloorMaterial ~= Enum.Material.Air then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

local function runSpoofers()
    if flags.status_spoof_enabled and flags.status_spoof_value then
        pcall(function()
            LocalPlayer:SetAttribute("PlayerStatus", flags.status_spoof_value)
        end)
    end
end

local function runCombatAimbot()
    if not flags.aimbot_enabled or not flags.aimbot_active then return end
    local target = get_target()
    if target and target.HitPart then
        local camPos = Camera.CFrame.Position
        local targetPos = target.HitPart.Position
        local targetCFrame = CFrame.new(camPos, targetPos)
        local smooth = flags.aimbot_smooth_step or 6
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smooth)
    end
end

local function runMeleeAura()
    if not flags.knife_rage then return end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local now = os.clock()
    if now - meowState.LastMeleeAttack < 0.12 then return end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local root = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= (flags.melee_safe_reach or 12) then
                    meowState.LastMeleeAttack = now
                    pcall(function()
                        if flags.melee_auto_face_back ~= false then
                            myRoot.CFrame = CFrame.new(myRoot.Position, myRoot.Position - root.CFrame.LookVector)
                        end
                        local tool = myChar:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end)
                    break
                end
            end
        end
    end
end

local function runAntiAim()
    if not flags.antiaim_enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local pitchVal = antiaim_pitch(flags.antiaim_pitch, flags.antiaim_custom_pitch)
    local yawVal = antiaim_yaw(flags.antiaim_yaw, flags.antiaim_spin_speed, flags.antiaim_jitter_range)
    pcall(function()
        local baseLook = Camera.CFrame.LookVector
        local baseAngle = math.atan2(-baseLook.X, -baseLook.Z)
        local rot = CFrame.Angles(0, baseAngle + math.rad(yawVal), 0) * CFrame.Angles(math.rad(pitchVal), 0, 0)
        root.CFrame = CFrame.new(root.Position) * rot
    end)
end

local function updateCameraAndWorld(dt)

    if flags.third_person then
        pcall(function()
            local char = LocalPlayer.Character
            if char and LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end)
    end

    if flags.camera_fov_enabled and Camera then
        if not meowState.OriginalCameraFov then
            meowState.OriginalCameraFov = Camera.FieldOfView
        end
        Camera.FieldOfView = flags.camera_fov or 90
    elseif meowState.OriginalCameraFov and Camera then
        Camera.FieldOfView = meowState.OriginalCameraFov
        meowState.OriginalCameraFov = nil
    end

    if flags.world_sky_autorotate then
        local spd = (flags.world_sky_rotate_speed or 100) / 100
        Lighting.ClockTime = (Lighting.ClockTime + (dt * spd)) % 24
    end

    if flags.anti_flash then
        pcall(function()
            local fb = Lighting:FindFirstChild("Flashbang") or Camera:FindFirstChild("Flashbang")
            if fb then fb:Destroy() end
        end)
    end
end
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and flags.silent_aim_enabled then
        if (method == "Raycast" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") and self == Workspace then
            local origin = args[1]

            if fakePos.Enabled and fakePos.VirtualCF then
                origin = fakePos.VirtualCF.Position
                args[1] = origin
            end
            local target = meowState.CurrentTarget or get_target()
            if target and target.HitPart then
                local hitChance = flags.hit_chance or 100
                if math.random(1, 100) <= hitChance then
                    local targetDir = (target.HitPart.Position - origin).Unit * 1000
                    args[2] = targetDir
                    if fakePos.Enabled and fakePos.AutoHandoff then
                        fakePos.HandoffTicks = 2
                    end
                    return oldNamecall(self, table.unpack(args))
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)

local Library
do
    local function loadEmbeddedSleepy()
--[[

    Milenium Library
    -> Made by @finobe 
    -> Kind of got bored idk what to do with life
    -> Idk who or why this got leaked, ui was VERY popular and high in demand with customers

    -> [MOBILE] Patched for touch devices (Toggle UI button removed — create it in your script)
    -> [MOBILE] Fixed double-toggle on mobile (removed duplicate TouchTap handlers)
]]

-- Variables 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    -- [MOBILE] Detect touch device
    local is_mobile = uis.TouchEnabled and not uis.KeyboardEnabled
    local viewport_size = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new
    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
-- 

-- Library init
    getgenv().library = {
        directory = "sleepy",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open; 
    }

    local themes = {
        preset = {
            accent = rgb(0, 162, 255),
        }, 

        utility = {
            accent = {
                BackgroundColor3 = {}, 	
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {} 
            },
        }
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 

    local fonts = {}; do
        -- Instant non-blocking fonts (0 ms startup, 0 freeze)
        local defaultSmall = Font.fromEnum(Enum.Font.GothamMedium)
        local defaultBold = Font.fromEnum(Enum.Font.GothamBold)

        fonts = {
            small = defaultSmall,
            font = defaultBold
        }

        task.spawn(function()
            pcall(function()
                if not (isfile and writefile and getcustomasset) then return end
                
                local function registerFontFile(name, id, url)
                    if not isfile(id) then
                        local sOk, sData = pcall(game.HttpGet, game, url)
                        if not sOk or not sData or #sData == 0 then return nil end
                        writefile(id, sData)
                    end
                    local fontFile = name .. ".font"
                    if not isfile(fontFile) then
                        local Data = {
                            name = name,
                            faces = {
                                {
                                    name = "Normal",
                                    weight = 200,
                                    style = "Normal",
                                    assetId = getcustomasset(id),
                                },
                            },
                        }
                        writefile(fontFile, http_service:JSONEncode(Data))
                    end
                    return getcustomasset(fontFile)
                end

                local mAsset = registerFontFile("Medium", "Medium.ttf", "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf")
                local sAsset = registerFontFile("SemiBold", "SemiBold.ttf", "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf")
                
                if mAsset then
                    fonts.small = Font.new(mAsset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                end
                if sAsset then
                    fonts.font = Font.new(sAsset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                end
            end)
        end)
    end
--

-- Library functions 
    -- Misc functions
        function library:tween(obj, properties, easing_style, time) 
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
                
            return tween
        end

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end 

        function fag(tbl)
            local Size = 0
            
            for _ in tbl do
                Size = Size + 1
            end
        
            return Size
        end
        
        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)
            
            return str;
        end 

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false 
            local start_size = frame.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - frame.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - frame.Size.Y.Offset
                        )
                    )

                    library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                    library:close_element()
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end
            
            if #values == 4 then              
                return unpack(values)
            else 
                return
            end
        end
        
        function library:convert_enum(enum)
            local enum_parts = {}
        
            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end
        
            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]
        
                enum_table = enum_item
            end
        
            return enum_table
        end

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}
            
            for _, v in next, flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end 
            
            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json) 
            local config = http_service:JSONDecode(config_json)
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 
        
        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        local function colors_match(c1, c2)
            if not c1 or not c2 then return false end
            return math.abs(c1.R - c2.R) < 0.04 and math.abs(c1.G - c2.G) < 0.04 and math.abs(c1.B - c2.B) < 0.04
        end

        function library:apply_theme(instance, theme, property) 
            if themes.preset[theme] then
                pcall(function() instance[property] = themes.preset[theme] end)
            end
            if themes.utility[theme] and themes.utility[theme][property] then
                insert(themes.utility[theme][property], instance)
            end
        end

        function library:update_theme(theme, color)
            local old_color = themes.preset[theme]
            themes.preset[theme] = color 

            if themes.utility[theme] then 
                for propName, instances in pairs(themes.utility[theme]) do 
                    for _, object in ipairs(instances) do 
                        pcall(function()
                            if old_color and object[propName] then
                                if colors_match(object[propName], old_color) then
                                    object[propName] = color
                                end
                            else
                                object[propName] = color
                            end
                        end)
                    end 
                end 
            end 

            if theme == "accent" and library.window_items and library.window_items["title"] and library.window_cfg then
                pcall(function()
                    local r = math.floor(color.R * 255)
                    local g = math.floor(color.G * 255)
                    local b = math.floor(color.B * 255)
                    library.window_items["title"].Text = string.format('<font color="rgb(%d, %d, %d)">%s</font><font color="rgb(255, 255, 255)">%s</font>', r, g, b, library.window_cfg.name, library.window_cfg.suffix)
                end)
            end
            if theme == "accent" and library.window_items and library.window_items["accent_bar"] then
                pcall(function()
                    library.window_items["accent_bar"].BackgroundColor3 = color
                end)
            end
            if theme == "accent" and library.window_items and library.window_items["other_info"] and library.window_cfg then
                pcall(function()
                    local r = math.floor(color.R * 255)
                    local g = math.floor(color.G * 255)
                    local b = math.floor(color.B * 255)
                    library.window_items["other_info"].Text = string.format('<font color="rgb(72, 72, 73)">%s</font><font color="rgb(%d, %d, %d)">%s%s</font>', library.window_cfg.sub_info or "lifetime, ", r, g, b, library.window_cfg.name, library.window_cfg.suffix)
                end)
            end
        end
        library.set_theme = library.update_theme 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
        end

        function library:close_element(new_path) 
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end 

            if new_path ~= open_element then 
                library.current_open = new_path or nil;
            end
        end 

        function library:create(instance, options)
            local ins = Instance.new(instance) 
            
            for prop, value in options do 
                ins[prop] = value
            end
            
            return ins 
        end

        function library:unload_menu() 
            if library[ "items" ] then 
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then 
                library[ "other" ]:Destroy()
            end 
            
            for index, connection in library.connections do 
                connection:Disconnect() 
                connection = nil 
            end
            
            library = nil 
        end 
    --
    
    -- Library element functions
        function library:window(properties)
            -- [MOBILE] Auto-fit window to mobile viewport
            local default_size = dim2(0, 780, 0, 505)
            if is_mobile then
                local w = clamp(viewport_size.X * 0.94, 320, 700)
                local h = clamp(viewport_size.Y * 0.82, 340, 505)
                default_size = dim2(0, w, 0, h)
            end

            local cfg = { 
                suffix = properties.suffix or properties.Suffix or "tech";
                name = properties.name or properties.Name or "nebula";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "Sleepy.gg for Rivals";
                size = properties.size or properties.Size or default_size;
                selected_tab;
                items = {};

                tween;
            }
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(10, 10, 12)
                }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)
                
                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "main" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                library.window_cfg = cfg
                library.window_items = items

                
                local side_width = is_mobile and 130 or 196
                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, side_width, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(10, 10, 12)
                });
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });
                
                items[ "button_holder" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 60);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -60);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.button_holder = items[ "button_holder" ];
                
                library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 36);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 11);
                    PaddingLeft = dim(0, 10)
                });

                local accent = themes.preset.accent
                local tr, tg, tb = math.floor(accent.R * 255), math.floor(accent.G * 255), math.floor(accent.B * 255)
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = string.format('<font color="rgb(%d, %d, %d)">%s</font><font color="rgb(255, 255, 255)">%s</font>', tr, tg, tb, cfg.name, cfg.suffix);
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 70);
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    RichText = true;
                    TextSize = 30;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "title" ], "accent", "TextColor3");
                
                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, side_width, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -side_width, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });
                
                items[ "shadow" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    Parent = items[ "main" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Name = "\0";
                    BackgroundColor3 = rgb(255, 255, 255);
                    Size = dim2(1, 75, 1, 75);
                    AnchorPoint = vec2(0.5, 0.5);
                    Image = "rbxassetid://112971167999062";
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    SliceScale = 0.75;
                    ZIndex = -100;
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(112, 112), vec2(147, 147))
                });
                
                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, side_width, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -side_width, 1, -56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(10, 10, 12);
                    ZIndex = 2;
                });                

                library:create( "UICorner" , {
                    Parent = items[ "shadow" ];
                    CornerRadius = dim(0, 5)
                });
                
                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    Visible = false;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });
                
                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });
                
                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.game_name;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); 
                
                local fr, fg, fb = math.floor(themes.preset.accent.R * 255), math.floor(themes.preset.accent.G * 255), math.floor(themes.preset.accent.B * 255)
                items[ "other_info" ] = library:create( "TextLabel" , {
                    Parent = items[ "info" ];
                    RichText = true;
                    Name = "\0";
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = string.format('<font color="rgb(72, 72, 73)">%s</font><font color="rgb(%d, %d, %d)">%s%s</font>', cfg.sub_info or "lifetime, ", fr, fg, fb, cfg.name, cfg.suffix);
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, -10, 0.5, -1);
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    FontFace = fonts.font;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");        
            end 

            do -- Other
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

            function cfg.toggle_menu(bool) 
                library[ "items" ].Enabled = bool
            end 

            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals"; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
                
                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {}; 
                current_multi; 
                
                items = {};
            } 

            local items = cfg.items; do 
                local side_width = is_mobile and 130 or 196
                local tab_holder_pos_x = side_width
                local tab_holder_size_x = is_mobile and (1) or (1)

                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, tab_holder_pos_x, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -tab_holder_pos_x - 14, 1, -66);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                -- Tab buttons 
                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 35);
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(29, 29, 29)
                    });
                    
                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = cfg.icon or "http://www.roblox.com/asset/?id=6034767608";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 40, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(23, 23, 29);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });
                -- 

                -- Multi Sections
                    items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });                        

                    for _, section in cfg.tabs do
                        local data = {items = {}} 

                        local multi_items = data.items; do 
                            -- Button
                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 39);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(25, 25, 29)
                                });
                                
                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(62, 62, 63);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });
                                
                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 1);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 10, 1, 4);
                                    Name = "\0";
                                    Size = dim2(1, -20, 0, 6);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 10)
                                });
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                }); 
                            --

                            -- Tab 
                                multi_items[ "tab" ] = library:create( "Frame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });
                                
                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                    VerticalFlex = Enum.UIFlexAlignment.Fill
                                });
                                
                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });
                            --
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                        
                        function data.open_page()
                            local page = cfg.current_multi; 
                            
                            if page and page.text ~= data.text then 
                                self.items[ "global_fade" ].BackgroundTransparency = 0
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                                
                                local old_size = page.page.Size
                                page.page.Size = dim2(1, -20, 1, -20)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                                library:tween(page.accent, {BackgroundTransparency = 1})
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ] 
                            end 
                            
                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 1})
                            library:tween(data.button, {BackgroundTransparency = 0})
                            library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data

                            library:close_element()
                        end
                        multi_items[ "button" ].MouseButton1Down:Connect(function()
                            data.open_page() 
                        end)
                        -- [MOBILE] touch
                        multi_items[ "button" ].TouchTap:Connect(function()
                            data.open_page()
                        end)

                        cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end 

                    cfg.pages[1].open_page()
                --
            end 

            function cfg.open_tab() 
                local selected_tab = self.selected_tab
                local side_width = is_mobile and 130 or 196
                
                if selected_tab then 
                    if selected_tab[ 4 ] ~= items[ "tab_holder" ] then 
                        self.items[ "global_fade" ].BackgroundTransparency = 0
                        
                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        selected_tab[ 4 ].Size = dim2(1, -side_width - 20, 1, -101)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0})
                library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -side_width, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
                
                items[ "tab_holder" ].Visible = true 
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true 
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                }

                library:close_element()
            end

            items[ "button" ].MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)
            -- [MOBILE] touch
            items[ "button" ].TouchTap:Connect(function()
                cfg.open_tab()
            end)
            
            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return unpack(cfg.pages)
        end

        function library:seperator(properties)
            properties = properties or {}
            local cfg = {items = {}, name = type(properties) == "table" and (properties.Name or properties.name or properties.title or properties.Title) or (type(properties) == "string" and properties) or "General"}

            local items = cfg.items do 
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0; 
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end;    

            return setmetatable(cfg, library)
        end 
        -- Miscellaneous 
            function library:column(properties) 
                local cfg = {items = {}, size = properties.size or 1}

                local items = cfg.items; do     
                    items[ "column" ] = library:create( "Frame" , {
                        Parent = self[ "parent" ] or self.items["tab_parent"];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, cfg.size, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = items[ "column" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 10);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end 

                return setmetatable(cfg, library)
            end 

            function library:sub_tab(properties) 
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do 
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0,0,cfg.size,0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end 
        --

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };
            
            local items = cfg.items; do 
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, cfg.size, -3);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(44, 44, 46);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 2;
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, -40);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(19, 19, 21)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");
                
                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    RichText = true; -- [SECTION_TITLE_RICHTEXT]
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
                
                if cfg.fading_toggle then 
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 62)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });
                    
                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 88)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });
                
                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end 
            end;

            if cfg.fading_toggle then
                items[ "button" ].MouseButton1Click:Connect(function()
                    cfg.default = not cfg.default 
                    cfg.toggle_section(cfg.default) 
                end)
                -- [MOBILE] touch (only one handler to avoid double-toggle)
                items[ "button" ].TouchTap:Connect(function()
                    cfg.default = not cfg.default 
                    cfg.toggle_section(cfg.default)
                end)

                function cfg.toggle_section(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end 
            end 

            return setmetatable(cfg, library)
        end  

        function library:toggle(options) 
            local rand = math.random(1, 2) 
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),
                
                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox";

                default = options.default or false,
                folding = options.folding or false, 
                callback = options.callback or function() end,

                items = {};
                seperator = options.seperator or options.Seperator or false;
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                -- Toggle
                    if cfg.type == "checkbox" then 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = rgb(67, 67, 68)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(22, 22, 24)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");
                        
                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });  
                    else 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });
                        
                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = dim2(1, -14, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        
                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });                        
                    end 
                --                
            end;
            
            function cfg.set(bool)
                if cfg.type == "checkbox" then 
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                cfg.callback(bool)

                if cfg.folding then 
                    elements.Visible = bool
                end

                flags[cfg.flag] = bool
            end 
            
            items[ "toggle" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)
            -- [MOBILE] touch (only ONE handler — on the row — to avoid double-toggle)
            items[ "toggle" ].TouchTap:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)

            items[ "toggle_button" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)
            -- NOTE: deliberately NO TouchTap on toggle_button — it would double-fire
            --       with the row's TouchTap when the user taps the switch itself.
            
            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 
        
        function library:slider(options) 
            local cfg = {
                name = options.name or nil,
                suffix = options.suffix or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end, 
                info = options.info or nil; 

                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10, 
                seperator = options.seperator or options.Seperator or true;

                dragging = false,
                items = {}
            }

            if cfg.style == "bar" then
                flags[cfg.flag] = cfg.default
                local items = cfg.items
                items["slider_object"] = library:create("Frame", {
                    Parent = self.items["elements"],
                    BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 22),
                    BorderSizePixel = 0,
                    BackgroundColor3 = rgb(255, 255, 255)
                })

                items["bar_btn"] = library:create("TextButton", {
                    Parent = items["slider_object"],
                    Text = "",
                    AutoButtonColor = false,
                    Size = dim2(1, -8, 1, 0),
                    Position = dim2(0, 4, 0, 0),
                    BackgroundColor3 = rgb(18, 19, 24),
                    BorderSizePixel = 0
                })
                library:create("UICorner", { Parent = items["bar_btn"], CornerRadius = dim(0, 4) })
                library:create("UIStroke", { Parent = items["bar_btn"], Color = rgb(25, 27, 33), Thickness = 1 })

                local initPct = clamp((cfg.default - cfg.min) / (cfg.max - cfg.min), 0, 1)
                items["fill"] = library:create("Frame", {
                    Parent = items["bar_btn"],
                    Size = dim2(initPct, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = themes.preset.accent,
                    ZIndex = 2
                })
                library:apply_theme(items["fill"], "accent", "BackgroundColor3")
                library:create("UICorner", { Parent = items["fill"], CornerRadius = dim(0, 4) })

                items["center_label"] = library:create("TextLabel", {
                    Parent = items["bar_btn"],
                    FontFace = fonts.small,
                    TextColor3 = rgb(255, 255, 255),
                    TextSize = 13,
                    Size = dim2(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 3,
                    Text = (cfg.name or "percent") .. ": " .. tostring(cfg.default) .. cfg.suffix
                })

                function cfg.set(value)
                    cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
                    local pct = clamp((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1)
                    items["fill"].Size = dim2(pct, 0, 1, 0)
                    items["center_label"].Text = (cfg.name or "percent") .. ": " .. tostring(cfg.value) .. cfg.suffix
                    flags[cfg.flag] = cfg.value
                    cfg.callback(flags[cfg.flag])
                end

                local function handleInput(input)
                    local size_x = clamp((input.Position.X - items["bar_btn"].AbsolutePosition.X) / items["bar_btn"].AbsoluteSize.X, 0, 1)
                    local val = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(val)
                end

                items["bar_btn"].MouseButton1Down:Connect(function()
                    cfg.dragging = true
                end)
                items["bar_btn"].InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        cfg.dragging = true
                        handleInput(input)
                    end
                end)
                library:connection(uis.InputChanged, function(input)
                    if cfg.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        handleInput(input)
                    end
                end)
                library:connection(uis.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        cfg.dragging = false
                    end
                end)

                if cfg.seperator then
                    library:create("Frame", {
                        AnchorPoint = vec2(0, 1),
                        Parent = self.items["elements"],
                        Position = dim2(0, 0, 1, 0),
                        Size = dim2(1, 1, 0, 1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = rgb(36, 36, 37)
                    })
                end

                cfg.set(cfg.default)
                config_flags[cfg.flag] = cfg.set
                return setmetatable(cfg, library)
            end 

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 37);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 23);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 4);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });
                
                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 6, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end 

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end

            items[ "slider" ].MouseButton1Down:Connect(function()
                cfg.dragging = true 
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
            end)
            -- [MOBILE] touch
            items[ "slider" ].InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    cfg.dragging = true
                    library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
                    local size_x = clamp((input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X, 0, 1)
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)
            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    local size_x = clamp((input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X, 0, 1)
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 
                    or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
                end 
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 

            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:dropdown(options) 
            local cfg = {
                name = options.name or nil;
                info = options.info or nil;
                style = options.style or (options.bar and "bar") or "normal";
                flag = options.flag or library:next_flag();
                options = options.items or {""};
                callback = options.callback or function() end;
                multi = options.multi or false;
                scrolling = options.scrolling or false;

                width = options.width or 130;

                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = options.seperator or options.Seperator or true;
            }   

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                -- Element
                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Dropdown";
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    if cfg.info then 
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 17);
                            Size = dim2(1, -10, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 16;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end 

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                -- 

                -- Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });
                    
                    items[ "outline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
                -- 
            end 

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");
                
                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                return button
            end
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

                items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 80)
                if not (self.sanity and library.current_open == self) then 
                    library:close_element(cfg)
                end
            end
            
            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do 
                    if option.Text == value or (isTable and find(value, option.Text)) then 
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]
                
                cfg.callback(flags[cfg.flag]) 
            end
            
            function cfg.refresh_options(list) 
                cfg.y_size = 0

                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    cfg.y_size += button.AbsoluteSize.Y + 6
                    insert(cfg.option_instances, button)
                    
                    button.MouseButton1Down:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                    -- [MOBILE] touch
                    button.TouchTap:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                end
            end

            items[ "dropdown" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open 
                
                cfg.set_visible(cfg.open)
            end)
            -- [MOBILE] touch
            items[ "dropdown" ].TouchTap:Connect(function()
                cfg.open = not cfg.open 
                cfg.set_visible(cfg.open)
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 

            flags[cfg.flag] = {} 
            config_flags[cfg.flag] = cfg.set
            
            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)
                
            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                seperator = options.seperator or options.Seperator or false;
                info = options.info or nil; 

                items = {};
            }

            local items = cfg.items; do 
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                
            end 

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 
            return setmetatable(cfg, library)
        end 
        
        function library:colorpicker(options) 
            local cfg = {
                name = options.name or "Color", 
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1),
                alpha = options.alpha and 1 - options.alpha or 0,
                
                open = false, 
                callback = options.callback or function() end,
                items = {};

                seperator = options.seperator or options.Seperator or false;
            }

            local dragging_sat = false 
            local dragging_hue = false 
            local dragging_alpha = false 

            local h, s, v = cfg.color:ToHSV() 
            local a = cfg.alpha 

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label; 
            if not self.items.right_components then 
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do 
                -- Component
                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });         
                --
                
                -- Colorpicker
                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });
                    
                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });
                    
                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 1);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 4, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 29);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });
                    
                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255);
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); 
                    
                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });
                    
                    items[ "UICorenr" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
                --                  
            end;

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)})
                
                if not (self.sanity and library.current_open == self and self.open) then 
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                local Color = hsv(h, s, v)

                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};
                
                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)
                
                cfg.callback(Color, a)
            end
            
            function cfg.update_color() 
                local mouse = uis:GetMouseLocation() 
                local offset = vec2(mouse.X, mouse.Y - gui_offset) 

                if dragging_sat then	
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            items[ "colorpicker" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open 
                cfg.set_visible(cfg.open)            
            end)
            -- [MOBILE] touch
            items[ "colorpicker" ].TouchTap:Connect(function()
                cfg.open = not cfg.open 
                cfg.set_visible(cfg.open)
            end)

            uis.InputChanged:Connect(function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.update_color() 
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                end
            end)    

            items[ "alpha_gradient" ].MouseButton1Down:Connect(function()
                dragging_alpha = true 
            end)
            
            items[ "hue_gradient" ].MouseButton1Down:Connect(function()
                dragging_hue = true 
            end)
            
            items[ "sat" ].MouseButton1Down:Connect(function()
                dragging_sat = true  
            end)
            items[ "input" ].FocusLost:Connect(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)
                
                if r and g and b and a then 
                    cfg.set(rgb(r, g, b), 1 - a)
                end 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
            
            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:textbox(options) 
            local cfg = {
                name = options.name or "TextBox",
                placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                default = options.default or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                visible = options.visible or true,
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(255, 255, 255);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 35)
                }); 

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });                
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end 
            
            function cfg.set(text) 
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
            end 
            
            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "input" ].Text) 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
                
            if cfg.default then 
                cfg.set(cfg.default) 
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:keybind(options) 
            local cfg = {
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                name = options.name or nil, 
                ignore_key = options.ignore or false, 

                key = options.key or nil, 
                mode = options.mode or "Toggle",
                active = options.default or false, 

                open = false,
                binding = nil, 

                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                active = cfg.active
            }

            local items = cfg.items; do 
                -- Component
                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });                                  
                -- 
                
                -- Mode Holder
                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    local options = {"Hold", "Toggle", "Always"}
                    
                    cfg.y_size = 20
                    for _, option in options do                        
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(72, 72, 73);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name
                        library:apply_theme(name, "accent", "TextColor3")
                        
                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)
                            cfg.set_visible(false)
                            cfg.open = false
                        end)
                        -- [MOBILE]
                        name.TouchTap:Connect(function()
                            cfg.set(option)
                            cfg.set_visible(false)
                            cfg.open = false
                        end)
                    end
                -- 
            end 
            
            function cfg.modify_mode_color(path)
                for _, v in cfg.hold_instances do 
                    v.TextColor3 = rgb(72, 72, 72)
                end 

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
                cfg.modify_mode_color(mode)
            end 

            function cfg.set(input)
                if type(input) == "boolean" then 
                    cfg.active = input

                    if cfg.mode == "Always" then 
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    cfg.key = input or "NONE"	
                elseif find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        cfg.active = true 
                    end 

                    cfg.mode = input
                    cfg.set_mode(cfg.mode) 
                elseif type(input) == "table" then 
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode) 
                end 

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0
                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
            end
        
            items[ "keybind_holder" ].MouseButton1Down:Connect(function()
                task.wait()
                items[ "key" ].Text = "..."	

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    cfg.binding:Disconnect() 
                    cfg.binding = nil
                end)
            end)

            items[ "keybind_holder" ].MouseButton2Down:Connect(function()
                cfg.open = not cfg.open 

                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputBegan, function(input, game_event) 
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                    if selected_key == cfg.key then 
                        if cfg.mode == "Toggle" then 
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then 
                            cfg.set(true)
                        end
                    end
                end
            end)    

            library:connection(uis.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then 
                        cfg.set(false)
                    end
                end
            end)
            
            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:button(options) 
            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");                            
            end 

            items[ "button" ].MouseButton1Click:Connect(function()
                cfg.callback()
                items[ "name" ].TextColor3 = themes.preset.accent 
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)
            -- [MOBILE] touch
            items[ "button" ].TouchTap:Connect(function()
                cfg.callback()
                items[ "name" ].TextColor3 = themes.preset.accent
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)
            
            return setmetatable(cfg, library)
        end 

        function library:settings(options)  
            local cfg = {
                open = false; 
                items = {}; 
                sanity = true;
            }

            local items = cfg.items; do 
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "items" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });                
            end 

            function cfg.set_visible(bool)                 
                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
                library:close_element(cfg)
            end
            
            -- Only ONE handler — Tap fires both MouseButton1Click and TouchTap on mobile if duplicated
            items[ "tick" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open 
                cfg.set_visible(cfg.open)
            end)

            return setmetatable(cfg, library)
        end 

        function library:list(properties) 
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or library:next_flag();    
                callback = properties.callback or function() end;
                data_store = {};        
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end 

            function cfg.refresh_options(options_to_refresh)
                for _,option in cfg.data_store do 
                    option:Destroy()
                end

                for _, option_data in options_to_refresh do 
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });     

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)
                    -- [MOBILE]
                    button.TouchTap:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window) 
            window:seperator({name = "Settings"})
            local main = window:tab({name = "Configs", tabs = {"Main"}})
            
            local column = main:column({})
            local section = column:section({name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()
            
            local column = main:column({})
            local section = column:section({name = "Settings", side = "right", size = 1, default = true, icon = "rbxassetid://129380150574313"})
            section:textbox({name = "Config name:", flag = "config_name_text"})
            section:button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] or flags["config_name_list"] .. ".cfg", library:get_config()) library:update_config_list() notifications:create_notification({name = "Configs", info = "Saved config to:\n" .. flags["config_name_list"] or flags["config_name_text"]}) end}) 
            section:button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))  library:update_config_list() notifications:create_notification({name = "Configs", info = "Loaded config:\n" .. flags["config_name_list"]}) end})
            section:button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")  library:update_config_list() notifications:create_notification({name = "Configs", info = "Deleted config:\n" .. flags["config_name_list"]}) end})
            section:colorpicker({name = "Menu Accent", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            section:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true})
        end
    --

    -- Notification Library
        function notifications:refresh_notifs() 
            local offset = 50

            for i, v in notifications.notifs do
                local Position = vec2(20, offset)
                library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
                offset += (v.AbsoluteSize.Y + 10)
            end

            return offset
        end
        
        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0 
            
            library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    library:tween(instance, {TextTransparency = fading})
                elseif instance:IsA("Frame") then
                    library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
                end
            end
        end 
        
        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "This is a title!";
                info = options.info or "This is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do 
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = dim2(0, 210, 0, 53);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(1, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(10, 10, 12)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "notification" ];
                    Transparency = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
                
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 6);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "notification" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.info;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 9, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 17);
                    PaddingRight = dim(0, 8);
                    Parent = items[ "info" ]
                });
                
                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 8, 1, -6);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 5);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    PaddingRight = dim(0, 8);
                    Parent = items[ "notification" ]
                });
            end
            
            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            notifications:fade(items[ "notification" ], false)
            
            local offset = notifications:refresh_notifs()

            items[ "notification" ].Position = dim_offset(20, offset)

            library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
            library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(function()
                task.wait(cfg.lifetime)
                
                notifications.notifs[index] = nil
                
                notifications:fade(items[ "notification" ], true)
                
                library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

                task.wait(1)
        
                items[ "notification" ]:Destroy() 
            end)
        end
    --
-- 

library.separator = library.seperator
library.seperator = library.seperator
return library

    end

    local ok, res = pcall(loadEmbeddedSleepy)
    if ok and res then
        Library = res
    else
        warn("[Sleepy Hub] Embedded library error, falling back to local: " .. tostring(res))
        pcall(function()
            if isfile and isfile("Sleepy-Hub-UI-main/Library.lua") then
                Library = loadstring(readfile("Sleepy-Hub-UI-main/Library.lua"))()
            end
        end)
    end
end

if not Library then
    warn("[Sleepy Hub] Failed to initialize Sleepy Hub UI Library!")
    return
end

local window = Library:window({
    name        = "sleepy",
    suffix      = ".gg 🎃",
    gameInfo    = "quality at its finest",
    footer_left = "quality at its finest",
    sub_info    = "lifetime, ",
    size        = UDim2.fromOffset(780, 505)
})
Library:update_theme("accent", Color3.fromRGB(0, 162, 255))

window:seperator({ name = "game" })

local mainRageTab, mainVoidspamTab, mainLegitTab, mainAATab = window:tab({
    name = "main",
    icon = "rbxassetid://10723415766",
    tabs = { "rage", "voidspam", "legit", "anti-aim" }
})

do
    local col1 = mainRageTab:column({})
    local secSilent = col1:section({ name = "Silent Aim Suite", size = 0.63, default = true, icon = "rbxassetid://6031075931" })

    secSilent:toggle({
        name      = "Enable Silent Aim",
        default   = false,
        seperator = true,
        callback  = function(v) flags.silent_aim_enabled = v end
    })

    secSilent:slider({
        name      = "FOV Radius",
        min       = 10,
        max       = 800,
        interval  = 5,
        default   = 120,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.fov_radius_smoothed = v end
    })

    local fovVis = secSilent:toggle({
        name      = "Visualise FOV",
        default   = false,
        seperator = true,
        callback  = function(v) flags.silent_aim_visualise_range = v end
    })
    fovVis:colorpicker({
        name     = "FOV Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.fov_color = c end
    })

    local fovSettings = fovVis:settings({})
    fovSettings:toggle({
        name      = "Spin FOV (Rainbow)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.fov_spin_value = v end
    })
    fovSettings:slider({
        name      = "Spin Speed",
        min       = 1,
        max       = 30,
        interval  = 1,
        default   = 10,
        seperator = true,
        callback  = function(v) flags.fov_rotation_speed = v end
    })
    fovSettings:toggle({
        name      = "Filled FOV Circle",
        default   = false,
        seperator = true,
        callback  = function(v) flags.fov_filled = v end
    })

    secSilent:slider({
        name      = "Hit Chance",
        min       = 1,
        max       = 100,
        interval  = 1,
        default   = 100,
        suffix    = " %",
        seperator = true,
        callback  = function(v) flags.hit_chance = v end
    })
    secSilent:toggle({
        name      = "Riot Shield Check",
        default   = false,
        seperator = true,
        callback  = function(v) flags.riot_shield_check = v end
    })

    secSilent:toggle({
        name      = "Avoid Katana Deflect",
        default   = false,
        seperator = true,
        callback  = function(v) flags.avoid_katana_deflect = v end
    })

    local secExploits = col1:section({ name = "Wallbang & CFrame Manipulation", size = 0.37, default = true, icon = "rbxassetid://6031075931" })

    secExploits:toggle({
        name      = "Wallbang / Manipulation",
        default   = false,
        seperator = true,
        callback  = function(v) flags.manipulation_enabled = v end
    })

    secExploits:toggle({
        name      = "Wallbang V2 Solver",
        default   = false,
        seperator = true,
        callback  = function(v) flags.wallbang_solver_v2 = v end
    })

    secExploits:toggle({
        name      = "Teleport V2 Origin",
        default   = false,
        seperator = true,
        callback  = function(v) flags.teleport_v2_origin = v end
    })

    local col2 = mainRageTab:column({})
    local secRageTarget = col2:section({ name = "Targeting & Priority", size = 0.63, default = true, icon = "rbxassetid://6031075931" })

    secRageTarget:textbox({
        name      = "Priority Username",
        default   = "",
        seperator = true,
        callback  = function(v) flags.priority_user_input = v end
    })

    secRageTarget:button({
        name     = "Add to Ragebot Priority",
        callback = function()
            local u = flags.priority_user_input
            if u and #u > 0 then
                meowState.PriorityList[u] = true
                if Library and Library.notifications then
                    Library.notifications:create_notification({
                        name     = "Priority Added",
                        info     = "Added " .. u .. " to Ragebot Priority list",
                        lifetime = 3
                    })
                end
            end
        end
    })

    secRageTarget:toggle({
        name      = "Ragebot Priority",
        default   = false,
        seperator = true,
        callback  = function(v) flags.ragebot_priority = v end
    })

    secRageTarget:dropdown({
        name      = "Target Hitbox",
        items     = { "Head", "Torso", "Random", "Smart Lowest HP" },
        default   = "Head",
        seperator = true,
        callback  = function(v) flags.target_hitbox_choice = v end
    })

    secRageTarget:dropdown({
        name      = "Priority Method",
        items     = { "Distance", "Lowest Health", "FOV", "Crosshair" },
        default   = "Distance",
        seperator = true,
        callback  = function(v) flags.targeting_priority_method = v end
    })

    secRageTarget:toggle({
        name      = "Auto Weapon Swap When Empty",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_weapon_swap = v end
    })

    local secMelee = col2:section({ name = "Knife Rage & Melee Aura", size = 0.37, default = true, icon = "rbxassetid://6031075931" })

    secMelee:toggle({
        name      = "Knife / Melee Rage",
        default   = false,
        seperator = true,
        callback  = function(v) flags.melee_aura = v end
    })

    secMelee:slider({
        name      = "Melee Safe Reach",
        min       = 5,
        max       = 25,
        interval  = 1,
        default   = 16,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.melee_reach = v end
    })

    secMelee:toggle({
        name      = "Auto Face Back (Silent Backstab)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_face_back = v end
    })
end

do
    local col1 = mainVoidspamTab:column({})
    local secDesync = col1:section({ name = "Subterranean & Void Desync", default = true, icon = "rbxassetid://6031075931" })
    secDesync:dropdown({
        name      = "Dropdown",
        items     = { "Position Desync V2", "Position Desync V1", "Underground V2", "Void Teleport" },
        default   = "Position Desync V2",
        seperator = true,
        callback  = function(v) fakePos.DesyncMode = v end
    })

    secDesync:toggle({
        name      = "Auto Void On Low HP (< 25 HP)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_void_low_hp = v end
    })

    secDesync:toggle({
        name      = "Melee Underground Strike",
        default   = false,
        seperator = true,
        callback  = function(v) flags.melee_underground_strike = v end
    })

    secDesync:slider({
        name      = "Melee Desync Reach",
        min       = 1,
        max       = 30,
        interval  = 1,
        default   = 18,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.melee_reach = v end
    })

    local col2 = mainVoidspamTab:column({})
    local secLag = col2:section({ name = "Packet Choking (Fake Lag)", default = true, icon = "rbxassetid://6031075931" })

    secLag:toggle({
        name      = "Fake Lag / Choke Packets",
        default   = false,
        seperator = true,
        callback  = function(v) flags.fakelag_enabled = v end
    })

    secLag:slider({
        name      = "Choke Limit",
        min       = 1,
        max       = 20,
        interval  = 1,
        default   = 6,
        suffix    = " ticks",
        seperator = true,
        callback  = function(v) flags.fakelag_choke = v end
    })

    secLag:dropdown({
        name      = "Dropdown",
        items     = { "Fluctuate", "Static", "Adaptive", "Random", "Pulse" },
        default   = "Fluctuate",
        seperator = true,
        callback  = function(v) flags.fakelag_mode = v end
    })

    secLag:toggle({
        name      = "Break Lag Comp (LC Breaker)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.break_lag_comp = v end
    })
end

do
    local col1 = mainLegitTab:column({})
    local secAimbot = col1:section({ name = "Legit Aimbot", default = true, icon = "rbxassetid://6031075931" })

    secAimbot:toggle({
        name      = "Enable Aimbot",
        default   = false,
        seperator = true,
        callback  = function(v) flags.aimbot_enabled = v end
    })

    secAimbot:keybind({
        name     = "Aim Keybind",
        mode     = "Hold",
        default  = Enum.KeyCode.E,
        callback = function(active) flags.aimbot_active = active end
    })

    secAimbot:slider({
        name      = "Smoothness",
        min       = 1,
        max       = 25,
        interval  = 1,
        default   = 6,
        seperator = true,
        callback  = function(v) flags.aimbot_smooth_step = v end
    })

    secAimbot:slider({
        name      = "Aimbot FOV",
        min       = 10,
        max       = 500,
        interval  = 5,
        default   = 90,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.aimbot_radius_smoothed = v end
    })

    secAimbot:toggle({
        name      = "Visualise Aimbot FOV",
        default   = false,
        seperator = true,
        callback  = function(v) flags.aimbot_visualise_range = v end
    })

    secAimbot:toggle({
        name      = "Wall Check",
        default   = false,
        seperator = true,
        callback  = function(v) flags.aimbot_wall_check = v end
    })

    local col2 = mainLegitTab:column({})
    local secTrigger = col2:section({ name = "Triggerbot & Recoil", default = true, icon = "rbxassetid://6031075931" })
    secTrigger:toggle({
        name      = "Enable Triggerbot",
        default   = false,
        seperator = true,
        callback  = function(v) flags.triggerbot_enabled = v end
    })

    secTrigger:slider({
        name      = "Reaction Delay",
        min       = 0,
        max       = 200,
        interval  = 10,
        default   = 20,
        suffix    = " ms",
        seperator = true,
        callback  = function(v) flags.triggerbot_delay = v end
    })

    secTrigger:toggle({
        name      = "No Recoil",
        default   = false,
        seperator = true,
        callback  = function(v) flags.no_recoil = v end
    })

    secTrigger:toggle({
        name      = "No Spread",
        default   = false,
        seperator = true,
        callback  = function(v) flags.no_spread = v end
    })
end

do
    local col1 = mainAATab:column({})
    local secAA = col1:section({ name = "HvH Anti-Aim Angles", default = true, icon = "rbxassetid://6031075931" })

    secAA:toggle({
        name      = "Enable Anti-Aim",
        default   = false,
        seperator = true,
        callback  = function(v) flags.antiaim_enabled = v end
    })

    secAA:dropdown({
        name      = "Anti-Aim Preset",
        items     = { "Custom", "Spinbot", "Jitter Fast", "Jitter Slow", "Sway HvH", "Backward", "Side Angles (Left)", "Side Angles (Right)", "Random HvH", "Block Anti-Aim" },
        default   = "Custom",
        seperator = true,
        callback  = function(v) flags.antiaim_preset = v end
    })

    secAA:dropdown({
        name      = "Yaw Mode",
        items     = { "None", "Backwards", "Left", "Right", "Spin", "Sway", "Jitter", "Random", "Offset", "Custom", "Block", "LBY Breaker", "Freestanding" },
        default   = "Spin",
        seperator = true,
        callback  = function(v) flags.yaw_type = v end
    })

    secAA:dropdown({
        name      = "Pitch Mode",
        items     = { "None", "Up", "Down", "Up & Down", "Random", "Offset", "Custom", "Extended Random", "Extended Custom", "Zero" },
        default   = "Down",
        seperator = true,
        callback  = function(v) flags.pitch_type = v end
    })

    secAA:slider({
        name      = "Rotation Speed",
        min       = 1,
        max       = 50,
        interval  = 1,
        default   = 20,
        seperator = true,
        callback  = function(v) flags.rotation_speed = v end
    })

    secAA:slider({
        name      = "Jitter Angle Range",
        min       = 5,
        max       = 180,
        interval  = 5,
        default   = 60,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) flags.jitter_range = v end
    })

    local col2 = mainAATab:column({})
    local secAAExp = col2:section({ name = "Anti-Aim Defensive Exploits", default = true, icon = "rbxassetid://6031075931" })

    secAAExp:toggle({
        name      = "Hide Head Angle",
        default   = false,
        seperator = true,
        callback  = function(v) flags.hide_head = v end
    })

    secAAExp:toggle({
        name      = "Camera Replication Decouple",
        default   = false,
        seperator = true,
        callback  = function(v) flags.camera_bypass = v end
    })

    secAAExp:toggle({
        name      = "Preserve Movement Direction",
        default   = false,
        seperator = true,
        callback  = function(v) flags.preserve_movement = v end
    })

    secAAExp:toggle({
        name      = "Pause On Attack / Knife",
        default   = false,
        seperator = true,
        callback  = function(v) flags.pause_on_attack = v end
    })
end

local visVMTab, visFXTab, visHUDTab, visWorldTab = window:tab({
    name = "visuals",
    icon = "rbxassetid://6031075931",
    tabs = { "viewmodel", "effects", "hud", "world" }
})

do
    local col1 = visVMTab:column({})
    local secVM = col1:section({
        name    = '<u>viewmodel</u>  <font color="rgb(72, 72, 73)">camera</font>',
        default = true,
        icon    = "rbxassetid://6031075931"
    })

    secVM:toggle({
        name      = "show cosmetics changer",
        default   = true,
        seperator = true,
        callback  = function(v)
            flags.show_cosmetics_changer = v
            pcall(function()
                if shared.MeowCosmeticChanger and shared.MeowCosmeticChanger.SetVisible then
                    shared.MeowCosmeticChanger.SetVisible(v)
                elseif shared.CosmeticChangerWindow then
                    shared.CosmeticChangerWindow.Visible = v
                end
            end)
            pcall(function()
                local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
                local pill = coreGui:FindFirstChild("_MeowCosmeticPill")
                if pill then pill.Enabled = v end
            end)
        end
    })

    secVM:dropdown({
        name      = "disable",
        items     = { "None", "Arms", "Gun", "Both" },
        default   = "None",
        seperator = true,
        callback  = function(v) flags.vm_disable_parts = v end
    })

    secVM:toggle({
        name      = "override fps",
        default   = false,
        seperator = true,
        callback  = function(v) flags.viewmodel_fps_override = v end
    })

    secVM:slider({
        name      = "recoil percent",
        min       = 0,
        max       = 100,
        interval  = 1,
        default   = 100,
        style     = "bar",
        suffix    = "%",
        seperator = true,
        callback  = function(v) flags.recoil_percent = v end
    })

    local chamsTog = secVM:toggle({
        name      = "chams",
        default   = false,
        seperator = true,
        callback  = function(v) flags.item_chams = v end
    })
    chamsTog:colorpicker({
        name     = "Chams 1",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.item_chams_color = c end
    })
    chamsTog:colorpicker({
        name     = "Chams 2",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.item_chams_color2 = c end
    })

    secVM:toggle({
        name      = "offset",
        default   = false,
        seperator = true,
        callback  = function(v) flags.vm_offset_enabled = v end
    })

    local col2 = visVMTab:column({})
    local secOverride = col2:section({
        name    = '<u>override</u>  <font color="rgb(72, 72, 73)">item   scaling</font>',
        size    = 0.63,
        default = true,
        icon    = "rbxassetid://6031075931"
    })

    secOverride:toggle({
        name      = "viewmodel appearance",
        default   = false,
        seperator = true,
        callback  = function(v) flags.vm_appearance = v end
    })

    local wireToggle = secOverride:toggle({
        name      = "gun wireframe",
        default   = false,
        seperator = true,
        callback  = function(v) flags.item_wireframe = v end
    })
    wireToggle:colorpicker({
        name     = "Wire Color 1",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.wireframe_color = c end
    })
    wireToggle:colorpicker({
        name     = "Wire Color 2",
        color    = Color3.fromRGB(155, 100, 255),
        callback = function(c) flags.wireframe_color2 = c end
    })

    secOverride:toggle({
        name      = "arm appearance",
        default   = false,
        seperator = true,
        callback  = function(v) flags.arm_appearance = v end
    })

    secOverride:toggle({
        name      = "character appearance",
        default   = false,
        seperator = true,
        callback  = function(v) flags.char_appearance = v end
    })

    local colTog = secOverride:toggle({
        name      = "color",
        default   = false,
        seperator = true,
        callback  = function(v) flags.color_override = v end
    })
    colTog:colorpicker({
        name     = "Override Tint",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.global_color_override = c end
    })

    secOverride:toggle({
        name      = "material",
        default   = false,
        seperator = true,
        callback  = function(v) flags.item_material_enabled = v end
    })

    secOverride:dropdown({
        name      = "material",
        items     = { "ForceField", "Neon", "Plastic", "Glass", "Foil" },
        default   = "ForceField",
        seperator = true,
        callback  = function(v) flags.item_chams_material = v end
    })

    secOverride:toggle({
        name      = "disable textures",
        default   = false,
        seperator = true,
        callback  = function(v) flags.disable_textures = v end
    })

    secOverride:slider({
        name      = "transparency",
        min       = 0,
        max       = 100,
        interval  = 1,
        default   = 100,
        style     = "bar",
        suffix    = "%",
        seperator = true,
        callback  = function(v) flags.item_chams_transparency = v / 100 end
    })

    -- Section 3: Cosmetic Changer
    local secCosmetic = col2:section({
        name    = "cosmetic - changer",
        size    = 0.37,
        default = true,
        icon    = "rbxassetid://6031075931"
    })

    secCosmetic:toggle({
        name      = "unlock all",
        default   = false,
        seperator = true,
        callback  = function(v)
            flags.unlock_all = v
            pcall(function()
                if shared.SyncUnlockAll then
                    shared.SyncUnlockAll(v)
                end
            end)
        end
    })

    secCosmetic:toggle({
        name      = "unock all emotes are fe",
        default   = false,
        seperator = true,
        callback  = function(v)
            flags.unlock_emotes_fe = v
            pcall(function()
                if shared.SyncUnlockAll then
                    shared.SyncUnlockAll(flags.unlock_all)
                end
            end)
        end
    })

    pcall(function()
        secCosmetic:label({
            name      = '<font color="rgb(120, 120, 130)">everyone can see them</font>',
            seperator = true
        })
    end)
end

do
    local col1 = visFXTab:column({})
    local secHit = col1:section({ name = "Hit Effects & Sounds", default = true, icon = "rbxassetid://6031075931" })

    secHit:toggle({
        name      = "Hit Sound Enabled",
        default   = false,
        seperator = true,
        callback  = function(v) flags.hit_sound_enabled = v end
    })

    secHit:dropdown({
        name      = "Hit Sound Preset",
        items     = { "Rust", "Skeet", "Bell", "Bonk", "Neverlose", "Bubble" },
        default   = "Rust",
        seperator = true,
        callback  = function(v) flags.hit_sound_preset = v end
    })

    secHit:toggle({
        name      = "Kill Sound Enabled",
        default   = false,
        seperator = true,
        callback  = function(v) flags.kill_sound_enabled = v end
    })

    secHit:dropdown({
        name      = "Kill Sound Preset",
        items     = { "Fatality", "Headshot", "Skeet", "Oof" },
        default   = "Fatality",
        seperator = true,
        callback  = function(v) flags.kill_sound_preset = v end
    })

    secHit:slider({
        name      = "Sound Volume",
        min       = 0.1,
        max       = 2.0,
        interval  = 0.1,
        default   = 1.0,
        seperator = true,
        callback  = function(v) flags.sound_volume = v end
    })

    local wmToggle = secHit:toggle({
        name      = "3D World Hitmarker",
        default   = false,
        seperator = true,
        callback  = function(v) flags.world_marker_enabled = v end
    })
    wmToggle:colorpicker({
        name     = "Marker Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.world_marker_color = c end
    })
end

do
    local col1 = visHUDTab:column({})
    local secTH = col1:section({ name = "Target HUD Card", default = true, icon = "rbxassetid://6031075931" })

    secTH:toggle({
        name      = "Enable Target Info HUD",
        default   = false,
        seperator = true,
        callback  = function(v) flags.target_hud = v end
    })

    secTH:toggle({
        name      = "Preview While Menu Open",
        default   = false,
        seperator = true,
        callback  = function(v) flags.target_hud_preview = v end
    })

    secTH:slider({
        name      = "HUD Scale Multiplier",
        min       = 0.5,
        max       = 2.0,
        interval  = 0.05,
        default   = 1.0,
        seperator = true,
        callback  = function(v) flags.target_hud_scale = v end
    })

    secTH:toggle({
        name      = "Show Music Player",
        default   = false,
        seperator = true,
        callback  = function(v)
            if shared.MeowMusicPlayer and shared.MeowMusicPlayer.MainFrame then
                shared.MeowMusicPlayer.MainFrame.Visible = v
            end
        end
    })

    local col2 = visHUDTab:column({})
    local secCross = col2:section({ name = "Procedural Crosshair", default = true, icon = "rbxassetid://6031075931" })

    local crossToggle = secCross:toggle({
        name      = "Custom Crosshair",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_enabled = v end
    })
    crossToggle:colorpicker({
        name     = "Crosshair Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.crosshair_color = c end
    })

    secCross:toggle({
        name      = "Rainbow Crosshair",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_rainbow = v end
    })

    secCross:slider({
        name      = "Rainbow Speed",
        min       = 1,
        max       = 10,
        interval  = 1,
        default   = 2,
        seperator = true,
        callback  = function(v) flags.crosshair_rainbow_speed = v end
    })

    secCross:toggle({
        name      = "Crosshair Outlines",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_outline = v end
    })

    local dotToggle = secCross:toggle({
        name      = "Center Dot",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_dot = v end
    })
    dotToggle:colorpicker({
        name     = "Dot Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.crosshair_dot_color = c end
    })

    secCross:slider({
        name      = "Center Dot Size",
        min       = 1,
        max       = 8,
        interval  = 0.5,
        default   = 2.5,
        seperator = true,
        callback  = function(v) flags.crosshair_dot_size = v end
    })

    secCross:toggle({
        name      = "T-Shape (No Top Line)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_t_shape = v end
    })

    secCross:slider({
        name      = "Crosshair Length",
        min       = 1,
        max       = 50,
        interval  = 1,
        default   = 14,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.crosshair_length = v end
    })

    secCross:slider({
        name      = "Crosshair Gap / Offset",
        min       = 0,
        max       = 30,
        interval  = 1,
        default   = 6,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.crosshair_offset = v end
    })

    secCross:slider({
        name      = "Crosshair Thickness",
        min       = 1,
        max       = 8,
        interval  = 1,
        default   = 2,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.crosshair_thickness = v end
    })

    secCross:slider({
        name      = "Dynamic Rotation (Spin)",
        min       = 0,
        max       = 10,
        interval  = 0.2,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.crosshair_rotation_speed = v end
    })

    secCross:slider({
        name      = "Static Rotation Angle",
        min       = 0,
        max       = 360,
        interval  = 5,
        default   = 0,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) flags.crosshair_rotation = v end
    })

    secCross:slider({
        name      = "Bouncing Speed",
        min       = 0,
        max       = 15,
        interval  = 0.5,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.crosshair_bounce_speed = v end
    })

    secCross:slider({
        name      = "Bouncing Amplitude",
        min       = 0,
        max       = 20,
        interval  = 1,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.crosshair_bounce_amp = v end
    })

    secCross:toggle({
        name      = "Hitmarker Dynamic Pulse",
        default   = false,
        seperator = true,
        callback  = function(v) flags.crosshair_hit_pulse = v end
    })
end

do
    local col1 = visWorldTab:column({})
    local secLighting = col1:section({ name = "World Lighting Modulation", default = true, icon = "rbxassetid://6031075931" })

    local ambToggle = secLighting:toggle({
        name      = "Ambient Override",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_ambient_enabled = v end
    })
    ambToggle:colorpicker({
        name     = "Ambient Color",
        color    = Color3.fromRGB(150, 150, 150),
        callback = function(c) flags.lighting_ambient_color = c end
    })

    local outAmbToggle = secLighting:toggle({
        name      = "Outdoor Ambient Override",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_outdoor_ambient_enabled = v end
    })
    outAmbToggle:colorpicker({
        name     = "Outdoor Color",
        color    = Color3.fromRGB(120, 120, 140),
        callback = function(c) flags.lighting_outdoor_ambient_color = c end
    })

    secLighting:toggle({
        name      = "Override Brightness",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_brightness_enabled = v end
    })

    secLighting:slider({
        name      = "Brightness Value",
        min       = 0,
        max       = 10,
        interval  = 0.1,
        default   = 2,
        seperator = true,
        callback  = function(v) flags.lighting_brightness_value = v end
    })

    secLighting:toggle({
        name      = "Override Time (ClockTime)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_clocktime_enabled = v end
    })

    secLighting:slider({
        name      = "Time of Day",
        min       = 0,
        max       = 24,
        interval  = 0.5,
        default   = 14,
        suffix    = " h",
        seperator = true,
        callback  = function(v) flags.lighting_clocktime_value = v end
    })

    local fogToggle = secLighting:toggle({
        name      = "Custom Fog Modulation",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_fog_enabled = v end
    })
    fogToggle:colorpicker({
        name     = "Fog Color",
        color    = Color3.fromRGB(160, 160, 180),
        callback = function(c) flags.lighting_fog_color = c end
    })

    secLighting:slider({
        name      = "Fog Start Distance",
        min       = 0,
        max       = 500,
        interval  = 10,
        default   = 0,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.lighting_fog_start = v end
    })

    secLighting:slider({
        name      = "Fog End Distance",
        min       = 50,
        max       = 3000,
        interval  = 50,
        default   = 1000,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.lighting_fog_end = v end
    })

    secLighting:toggle({
        name      = "Global Shadows",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_shadows_enabled = v end
    })
    secLighting:slider({
        name      = "Shadow Softness",
        min       = 0,
        max       = 1,
        interval  = 0.05,
        default   = 0.5,
        seperator = true,
        callback  = function(v) flags.lighting_shadow_softness = v end
    })

    secLighting:toggle({
        name      = "Exposure Compensation",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_exposure_enabled = v end
    })

    secLighting:slider({
        name      = "Exposure Value",
        min       = -3,
        max       = 3,
        interval  = 0.1,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.lighting_exposure_value = v end
    })

    secLighting:toggle({
        name      = "Lighting Technology",
        default   = false,
        seperator = true,
        callback  = function(v) flags.lighting_technology_enabled = v end
    })

    secLighting:dropdown({
        name      = "Technology Mode",
        items     = { "Future", "ShadowMap", "Compatibility", "Voxel" },
        default   = "Future",
        seperator = true,
        callback  = function(v) flags.lighting_technology = v end
    })
    local col2 = visWorldTab:column({})
    local secSky = col2:section({ name = "Skybox & Atmosphere", default = true, icon = "rbxassetid://6031075931" })

    secSky:toggle({
        name      = "Enable Skybox Override",
        default   = false,
        seperator = true,
        callback  = function(v)
            flags.world_skybox_enabled = v
            applySkybox(flags.skybox_preset or "Synthwave")
        end
    })

    secSky:dropdown({
        name      = "Skybox Preset",
        items     = {
            "Synthwave", "Purple Nebula", "Vaporwave", "Night Sky", "Red Galaxy", "Sunset",
            "GreenHaze", "Space2", "PinkMountains", "Valentines", "PinkArt", "PurplePlanet",
            "Blizzard", "Winter", "FlamingSunset", "Mountains", "FPSBoost", "AestheticMountains",
            "BetterNight3", "Galaxy2", "Aesthetic3", "PurpleSpace", "Pink", "PurpleNight",
            "Flame", "Galaxy3", "Storm", "Deep Space"
        },
        default   = "Synthwave",
        seperator = true,
        callback  = function(v)
            flags.skybox_preset = v
            if flags.world_skybox_enabled then applySkybox(v) end
        end
    })

    secSky:toggle({
        name      = "Auto Rotate Sky (Day Cycle)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.world_sky_autorotate = v end
    })

    secSky:slider({
        name      = "Sky Rotation Speed",
        min       = 10,
        max       = 500,
        interval  = 10,
        default   = 100,
        seperator = true,
        callback  = function(v) flags.world_sky_rotate_speed = v end
    })

    local atmToggle = secSky:toggle({
        name      = "Atmosphere Changer",
        default   = false,
        seperator = true,
        callback  = function(v) flags.atmosphere_enabled = v end
    })
    atmToggle:colorpicker({
        name     = "Atmosphere Color",
        color    = Color3.fromRGB(199, 170, 107),
        callback = function(c) flags.atmosphere_color = c end
    })
    atmToggle:colorpicker({
        name     = "Atmosphere Decay",
        color    = Color3.fromRGB(106, 112, 125),
        callback = function(c) flags.atmosphere_decay = c end
    })

    secSky:slider({
        name      = "Atmosphere Density",
        min       = 0,
        max       = 1,
        interval  = 0.05,
        default   = 0.3,
        seperator = true,
        callback  = function(v) flags.atmosphere_density = v end
    })

    secSky:slider({
        name      = "Atmosphere Haze",
        min       = 0,
        max       = 10,
        interval  = 0.5,
        default   = 1,
        seperator = true,
        callback  = function(v) flags.atmosphere_haze = v end
    })
    secSky:slider({
        name      = "Atmosphere Glare",
        min       = 0,
        max       = 1,
        interval  = 0.05,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.atmosphere_glare = v end
    })

    local ccToggle = secSky:toggle({
        name      = "Color Correction Effect",
        default   = false,
        seperator = true,
        callback  = function(v) flags.color_correction_enabled = v end
    })
    ccToggle:colorpicker({
        name     = "Tint Color",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.cc_tint_color = c end
    })

    secSky:slider({
        name      = "Color Saturation",
        min       = -1,
        max       = 2,
        interval  = 0.1,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.cc_saturation = v end
    })

    secSky:slider({
        name      = "Color Contrast",
        min       = -1,
        max       = 2,
        interval  = 0.1,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.cc_contrast = v end
    })
    local secRemovals = col2:section({ name = "World Removals & Camera", default = true, icon = "rbxassetid://6031075931" })

    secRemovals:toggle({
        name      = "No Textures (Map Stripper)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.world_no_textures = v end
    })

    secRemovals:toggle({
        name      = "No Fog",
        default   = false,
        seperator = true,
        callback  = function(v) flags.world_no_fog = v end
    })

    secRemovals:toggle({
        name      = "Anti-Flashbang",
        default   = false,
        seperator = true,
        callback  = function(v) flags.anti_flash = v end
    })

    secRemovals:toggle({
        name      = "Anti-Screen Shake",
        default   = false,
        seperator = true,
        callback  = function(v) flags.anti_shake = v end
    })

    secRemovals:toggle({
        name      = "Custom Camera FOV",
        default   = false,
        seperator = true,
        callback  = function(v) flags.camera_fov_enabled = v end
    })

    secRemovals:slider({
        name      = "Camera Field of View",
        min       = 60,
        max       = 130,
        interval  = 1,
        default   = 90,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) flags.camera_fov = v end
    })

    secRemovals:toggle({
        name      = "Third Person POV",
        default   = false,
        seperator = true,
        callback  = function(v) flags.third_person = v end
    })
end

local espPlayersTab, espChamsTab, espTracersTab = window:tab({
    name = "esp",
    icon = "rbxassetid://10734975692",
    tabs = { "Players", "Chams", "Tracers" }
})

do
    local col1 = espPlayersTab:column({})
    local secEnemy = col1:section({ name = "Enemy ESP", default = true, icon = "rbxassetid://6031075931" })

    secEnemy:toggle({
        name      = "Enable Enemy ESP",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_enabled = v end
    })

    secEnemy:dropdown({
        name      = "Box Style",
        items     = { "Corner", "Full", "3D Box" },
        default   = "Corner",
        seperator = true,
        callback  = function(v) flags.esp_box_style = v end
    })

    local boxTog = secEnemy:toggle({
        name      = "Bounding Box",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_boxes = v end
    })
    boxTog:colorpicker({
        name     = "Box Color",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.esp_box_color = c end
    })

    local fillTog = secEnemy:toggle({
        name      = "Filled Box",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_box_fill = v end
    })
    fillTog:colorpicker({
        name     = "Fill Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.esp_fill_color = c end
    })
    secEnemy:dropdown({
        name      = "Box Fit",
        items     = { "Dynamic", "Static" },
        default   = "Dynamic",
        seperator = true,
        callback  = function(v) flags.esp_box_fit = v end
    })

    local nameTog = secEnemy:toggle({
        name      = "Name Tags",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_names = v end
    })
    nameTog:colorpicker({
        name     = "Name Color",
        color    = Color3.fromRGB(240, 240, 240),
        callback = function(c) flags.esp_name_color = c end
    })

    local hpTog = secEnemy:toggle({
        name      = "Health Bar",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_health_bars = v end
    })
    hpTog:colorpicker({
        name     = "Health Bar Color",
        color    = Color3.fromRGB(0, 255, 120),
        callback = function(c) flags.esp_health_color = c end
    })

    secEnemy:dropdown({
        name      = "Health Color Mode",
        items     = { "Reactive", "Gradient", "Solid" },
        default   = "Reactive",
        seperator = true,
        callback  = function(v) flags.esp_health_mode = v end
    })

    local hpNum = secEnemy:toggle({
        name      = "Health Number",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_health_number = v end
    })
    hpNum:colorpicker({
        name     = "HP Num Color",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.esp_hp_num_color = c end
    })

    local ammoTog = secEnemy:toggle({
        name      = "Ammo Bar",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_ammo_bar = v end
    })
    ammoTog:colorpicker({
        name     = "Ammo Bar Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.esp_ammo_color = c end
    })

    secEnemy:dropdown({
        name      = "Ammo Color Mode",
        items     = { "Solid", "Gradient", "Reactive" },
        default   = "Solid",
        seperator = true,
        callback  = function(v) flags.esp_ammo_mode = v end
    })

    local wepTog = secEnemy:toggle({
        name      = "Held Weapon",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_weapons = v end
    })
    wepTog:colorpicker({
        name     = "Weapon Color",
        color    = Color3.fromRGB(220, 220, 220),
        callback = function(c) flags.esp_weapon_color = c end
    })
    local distTog = secEnemy:toggle({
        name      = "Distance",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_distance = v end
    })
    distTog:colorpicker({
        name     = "Distance Color",
        color    = Color3.fromRGB(180, 180, 180),
        callback = function(c) flags.esp_dist_color = c end
    })

    local rankTog = secEnemy:toggle({
        name      = "Rank Badge",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_rank = v end
    })
    rankTog:colorpicker({
        name     = "Rank Color",
        color    = Color3.fromRGB(255, 215, 0),
        callback = function(c) flags.esp_rank_color = c end
    })

    local streakTog = secEnemy:toggle({
        name      = "Win Streak",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_streak = v end
    })
    streakTog:colorpicker({
        name     = "Streak Color",
        color    = Color3.fromRGB(255, 100, 50),
        callback = function(c) flags.esp_streak_color = c end
    })

    local deflTog = secEnemy:toggle({
        name      = "Deflecting (Katana Shield)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_deflecting = v end
    })
    deflTog:colorpicker({
        name     = "Deflecting Color",
        color    = Color3.fromRGB(255, 0, 150),
        callback = function(c) flags.esp_deflect_color = c end
    })

    local col2 = espPlayersTab:column({})
    local secSettings = col2:section({ name = "Teammates & Text Settings", default = true, icon = "rbxassetid://6031075931" })

    secSettings:toggle({
        name      = "Enable Teammates ESP",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_team_enabled = v end
    })

    local tmBox = secSettings:toggle({
        name      = "Teammate Box",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_team_boxes = v end
    })
    tmBox:colorpicker({
        name     = "Team Box Color",
        color    = Color3.fromRGB(80, 180, 255),
        callback = function(c) flags.esp_team_box_color = c end
    })

    local tmName = secSettings:toggle({
        name      = "Teammate Name",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_team_names = v end
    })
    tmName:colorpicker({
        name     = "Team Name Color",
        color    = Color3.fromRGB(80, 180, 255),
        callback = function(c) flags.esp_team_name_color = c end
    })

    local tmHp = secSettings:toggle({
        name      = "Teammate Health Bar",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_team_health = v end
    })
    tmHp:colorpicker({
        name     = "Team HP Color",
        color    = Color3.fromRGB(0, 255, 120),
        callback = function(c) flags.esp_team_hp_color = c end
    })

    secSettings:toggle({
        name      = "Use Display Names",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_display_names = v end
    })

    secSettings:dropdown({
        name      = "ESP Font",
        items     = { "Gotham", "SourceSans", "Arial", "Code", "Roboto" },
        default   = "Code",
        seperator = true,
        callback  = function(v) flags.esp_font_choice = v end
    })

    secSettings:slider({
        name      = "ESP Font Size",
        min       = 8,
        max       = 32,
        interval  = 1,
        default   = 13,
        seperator = true,
        callback  = function(v) flags.esp_font_size = v end
    })

    secSettings:dropdown({
        name      = "Text Case",
        items     = { "Standard", "UPPERCASE", "lowercase" },
        default   = "lowercase",
        seperator = true,
        callback  = function(v) flags.esp_text_case = v end
    })

    secSettings:dropdown({
        name      = "Text Surround",
        items     = { "None", "[]", "()", "<>", "{}" },
        default   = "None",
        seperator = true,
        callback  = function(v) flags.esp_text_surround = v end
    })

    secSettings:slider({
        name      = "Flag Font Size",
        min       = 6,
        max       = 24,
        interval  = 1,
        default   = 10,
        seperator = true,
        callback  = function(v) flags.esp_flag_size = v end
    })

    secSettings:dropdown({
        name      = "Flag Surround",
        items     = { "None", "[]", "()", "<>", "{}" },
        default   = "[]",
        seperator = true,
        callback  = function(v) flags.esp_flag_surround = v end
    })

    secSettings:toggle({
        name      = "Scale With Distance",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_distance_scaling = v end
    })

    secSettings:slider({
        name      = "Reference Distance",
        min       = 10,
        max       = 300,
        interval  = 5,
        default   = 60,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.esp_distance_ref = v end
    })

    secSettings:toggle({
        name      = "Team Check (Ignore Teammates)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_team_check = v end
    })

    secSettings:slider({
        name      = "Max Render Distance",
        min       = 50,
        max       = 2000,
        interval  = 25,
        default   = 1500,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.esp_max_distance = v end
    })
end

do
    local col1 = espChamsTab:column({})
    local secChams = col1:section({ name = "Enemy Chams Suite", default = true, icon = "rbxassetid://6031075931" })

    secChams:toggle({
        name      = "Enable Enemy Chams",
        default   = false,
        seperator = true,
        callback  = function(v) flags.chams_enabled = v end
    })

    secChams:dropdown({
        name      = "Chams Kind",
        items     = { "Highlight", "Legacy", "ForceField", "Glass", "Neon" },
        default   = "Highlight",
        seperator = true,
        callback  = function(v) flags.chams_kind = v end
    })

    local cFill = secChams:toggle({
        name      = "Chams Fill",
        default   = false,
        seperator = true,
        callback  = function(v) flags.chams_fill_enabled = v end
    })
    cFill:colorpicker({
        name     = "Fill Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.chams_fill_color = c end
    })

    secChams:slider({
        name      = "Fill Transparency",
        min       = 0,
        max       = 100,
        interval  = 5,
        default   = 50,
        suffix    = " %",
        seperator = true,
        callback  = function(v) flags.chams_fill_transparency = v / 100 end
    })

    local cOut = secChams:toggle({
        name      = "Chams Outline",
        default   = false,
        seperator = true,
        callback  = function(v) flags.chams_outline_enabled = v end
    })
    cOut:colorpicker({
        name     = "Outline Color",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.chams_outline_color = c end
    })

    secChams:slider({
        name      = "Outline Transparency",
        min       = 0,
        max       = 100,
        interval  = 5,
        default   = 0,
        suffix    = " %",
        seperator = true,
        callback  = function(v) flags.chams_outline_transparency = v / 100 end
    })

    local cGlow = secChams:toggle({
        name      = "Chams Glow",
        default   = false,
        seperator = true,
        callback  = function(v) flags.chams_glow = v end
    })
    cGlow:colorpicker({
        name     = "Glow Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.chams_glow_color = c end
    })

    secChams:toggle({
        name      = "Visible Depth Check",
        default   = false,
        seperator = true,
        callback  = function(v) flags.chams_visible_only = v end
    })

    local col2 = espChamsTab:column({})
    local secSkel = col2:section({ name = "Skeleton & Head Marker", default = true, icon = "rbxassetid://6031075931" })

    local skelTog = secSkel:toggle({
        name      = "Skeleton ESP",
        default   = false,
        seperator = true,
        callback  = function(v) flags.skeleton_enabled = v end
    })
    skelTog:colorpicker({
        name     = "Skeleton Color",
        color    = Color3.fromRGB(255, 255, 255),
        callback = function(c) flags.skeleton_color = c end
    })

    secSkel:slider({
        name      = "Skeleton Thickness",
        min       = 1,
        max       = 6,
        interval  = 1,
        default   = 1,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.skeleton_thickness = v end
    })

    local hmTog = secSkel:toggle({
        name      = "Head Marker",
        default   = false,
        seperator = true,
        callback  = function(v) flags.head_marker_enabled = v end
    })
    hmTog:colorpicker({
        name     = "Head Marker Color",
        color    = Color3.fromRGB(255, 50, 50),
        callback = function(c) flags.head_marker_color = c end
    })

    secSkel:dropdown({
        name      = "Head Marker Shape",
        items     = { "Circle", "Cross", "Diamond" },
        default   = "Circle",
        seperator = true,
        callback  = function(v) flags.head_marker_shape = v end
    })

    secSkel:toggle({
        name      = "Head Marker Filled",
        default   = false,
        seperator = true,
        callback  = function(v) flags.head_marker_filled = v end
    })

    local hmOut = secSkel:toggle({
        name      = "Head Marker Outline",
        default   = false,
        seperator = true,
        callback  = function(v) flags.head_marker_outline = v end
    })
    hmOut:colorpicker({
        name     = "HM Outline Color",
        color    = Color3.fromRGB(0, 0, 0),
        callback = function(c) flags.head_marker_outline_color = c end
    })

    local arrTog = secSkel:toggle({
        name      = "Off-Screen Arrows",
        default   = false,
        seperator = true,
        callback  = function(v) flags.offscreen_arrows = v end
    })
    arrTog:colorpicker({
        name     = "Arrow Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.arrow_color = c end
    })

    secSkel:slider({
        name      = "Arrow Radius",
        min       = 50,
        max       = 400,
        interval  = 10,
        default   = 150,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.arrow_radius = v end
    })
end

do
    local col1 = espTracersTab:column({})
    local secTracer = col1:section({ name = "Tracers Suite", default = true, icon = "rbxassetid://6031075931" })

    local trTog = secTracer:toggle({
        name      = "Enable Tracer",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_tracers = v end
    })
    trTog:colorpicker({
        name     = "Tracer Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.esp_tracer_color = c end
    })

    secTracer:dropdown({
        name      = "From (Origin)",
        items     = { "Bottom", "Center", "Top", "Mouse" },
        default   = "Bottom",
        seperator = true,
        callback  = function(v) flags.esp_tracer_origin = v end
    })

    secTracer:dropdown({
        name      = "To (Target)",
        items     = { "Feet", "Head" },
        default   = "Feet",
        seperator = true,
        callback  = function(v) flags.esp_tracer_target = v end
    })

    secTracer:slider({
        name      = "Tracer Thickness",
        min       = 1,
        max       = 6,
        interval  = 1,
        default   = 1,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.esp_tracer_thickness = v end
    })

    local trOut = secTracer:toggle({
        name      = "Tracer Outline",
        default   = false,
        seperator = true,
        callback  = function(v) flags.esp_tracer_outline = v end
    })
    trOut:colorpicker({
        name     = "Tracer Outline Color",
        color    = Color3.fromRGB(0, 0, 0),
        callback = function(c) flags.esp_tracer_outline_color = c end
    })

    secTracer:slider({
        name      = "Outline Thickness",
        min       = 1,
        max       = 6,
        interval  = 1,
        default   = 1,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.esp_tracer_outline_thickness = v end
    })

    local col2 = espTracersTab:column({})
    local secBeams = col2:section({ name = "Bullet & Impact Tracers", default = true, icon = "rbxassetid://6031075931" })

    local beamTog = secBeams:toggle({
        name      = "Bullet Tracers (Beams)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.bullet_tracers_enabled = v end
    })
    beamTog:colorpicker({
        name     = "Beam Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c) flags.bullet_tracer_color = c end
    })

    local localBeam = secBeams:toggle({
        name      = "Local Bullet Beams",
        default   = false,
        seperator = true,
        callback  = function(v) flags.local_bullet_beams = v end
    })
    localBeam:colorpicker({
        name     = "Local Beam Color",
        color    = Color3.fromRGB(0, 255, 200),
        callback = function(c) flags.local_beam_color = c end
    })

    secBeams:slider({
        name      = "Beam Lifetime",
        min       = 0.5,
        max       = 5,
        interval  = 0.1,
        default   = 1.5,
        suffix    = " s",
        seperator = true,
        callback  = function(v) flags.bullet_tracer_lifetime = v end
    })

    secBeams:slider({
        name      = "Beam Width",
        min       = 0.5,
        max       = 4,
        interval  = 0.1,
        default   = 1.2,
        suffix    = " px",
        seperator = true,
        callback  = function(v) flags.bullet_tracer_width = v end
    })

    local impTog = secBeams:toggle({
        name      = "Bullet Impact Markers",
        default   = false,
        seperator = true,
        callback  = function(v) flags.impact_markers = v end
    })
    impTog:colorpicker({
        name     = "Impact Color",
        color    = Color3.fromRGB(255, 50, 50),
        callback = function(c) flags.impact_color = c end
    })
end

local miscMoveTab, miscAutoTab, miscExploitsTab = window:tab({
    name = "misc",
    icon = "rbxassetid://10709769508",
    tabs = { "Movement", "Automation", "Exploits" }
})

do
    local col1 = miscMoveTab:column({})
    local secGround = col1:section({ name = "Ground Movement", default = true, icon = "rbxassetid://6031075931" })

    secGround:toggle({
        name      = "Enable WalkSpeed Multiplier",
        default   = false,
        seperator = true,
        callback  = function(v) movementState.WalkSpeedEnabled = v end
    })

    secGround:slider({
        name      = "Walk Speed Multiplier",
        min       = 1.0,
        max       = 10.0,
        interval  = 0.1,
        default   = 1.5,
        suffix    = "x",
        seperator = true,
        callback  = function(v) movementState.WalkSpeedMult = v end
    })

    secGround:toggle({
        name      = "Noclip",
        default   = false,
        seperator = true,
        callback  = function(v) movementState.NoclipEnabled = v end
    })

    secGround:toggle({
        name      = "Auto Bunnyhop (B-Hop)",
        default   = false,
        seperator = true,
        callback  = function(v) movementState.BHopEnabled = v end
    })

    local col2 = miscMoveTab:column({})
    local secAir = col2:section({ name = "Flight & Jump", default = true, icon = "rbxassetid://6031075931" })

    secAir:toggle({
        name      = "Flight / Fly Hack",
        default   = false,
        seperator = true,
        callback  = function(v) movementState.FlightEnabled = v end
    })

    secAir:slider({
        name      = "Flight Speed",
        min       = 25,
        max       = 500,
        interval  = 25,
        default   = 100,
        suffix    = " studs/s",
        seperator = true,
        callback  = function(v) movementState.FlightSpeed = v end
    })

    secAir:toggle({
        name      = "Infinite Double Jumps",
        default   = false,
        seperator = true,
        callback  = function(v) movementState.DoubleJump = v end
    })
end

do
    local col1 = miscAutoTab:column({})
    local secLoadout = col1:section({ name = "Auto Loadout (Pre-Round)", default = true, icon = "rbxassetid://6031075931" })

    secLoadout:toggle({
        name      = "Enable Auto Loadout",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_loadout_enabled = v end
    })

    secLoadout:dropdown({
        name      = "Slot 1 (Primary)",
        items     = { "Assault Rifle", "Sniper", "Shotgun", "Burst Rifle", "Minigun", "Paintball Gun" },
        default   = "Assault Rifle",
        seperator = true,
        callback  = function(v) flags.loadout_slot1 = v end
    })

    secLoadout:dropdown({
        name      = "Slot 2 (Secondary)",
        items     = { "Pistol", "Revolver", "SMG", "Uzi", "Wildcat" },
        default   = "Pistol",
        seperator = true,
        callback  = function(v) flags.loadout_slot2 = v end
    })

    secLoadout:dropdown({
        name      = "Slot 3 (Melee)",
        items     = { "Katana", "Knife", "Bat", "Fists", "Scythe" },
        default   = "Katana",
        seperator = true,
        callback  = function(v) flags.loadout_slot3 = v end
    })

    secLoadout:dropdown({
        name      = "Slot 4 (Utility)",
        items     = { "Grenade", "Smoke Grenade", "Flashbang", "Medkit", "Subspace Tripmine" },
        default   = "Grenade",
        seperator = true,
        callback  = function(v) flags.loadout_slot4 = v end
    })

    secLoadout:toggle({
        name      = "Auto Buy Ammunition",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_buy_ammo = v end
    })

    local col2 = miscAutoTab:column({})
    local secStaff = col2:section({ name = "Staff Detector & Protection", default = true, icon = "rbxassetid://6031075931" })

    secStaff:toggle({
        name      = "Detect Staff / Admins",
        default   = false,
        seperator = true,
        callback  = function(v) flags.staff_detector = v end
    })

    secStaff:dropdown({
        name      = "Staff Detection Action",
        items     = { "Notify", "Server Hop", "Disconnect" },
        default   = "Notify",
        seperator = true,
        callback  = function(v) flags.staff_action = v end
    })
end

do
    local col1 = miscExploitsTab:column({})
    local secExp = col1:section({ name = "Exploits Suite", default = true, icon = "rbxassetid://6031075931" })

    secExp:toggle({
        name      = "Arcade Auto Respawn",
        default   = false,
        seperator = true,
        callback  = function(v) flags.arcade_respawn = v end
    })
end

local charFPTab, charAnglesTab = window:tab({
    name = "character",
    icon = "rbxassetid://10747373176",
    tabs = { "Fake Position", "Angles" }
})

do
    local col1 = charFPTab:column({})
    local secFP = col1:section({ name = "Fake Position Engine", default = true, icon = "rbxassetid://6031075931" })

    secFP:toggle({
        name      = "Enable Fake Position (Underground)",
        default   = false,
        seperator = true,
        callback  = function(v) setFakePosition(v) end
    })

    secFP:keybind({
        name     = "Toggle Keybind",
        mode     = "Toggle",
        default  = Enum.KeyCode.X,
        callback = function() getgenv().ToggleFakePosition() end
    })

    secFP:slider({
        name      = "Underground Depth",
        min       = 1.0,
        max       = 25.0,
        interval  = 0.2,
        default   = 5.8,
        suffix    = " studs",
        seperator = true,
        callback  = function(v)
            flags.fake_position_depth = v
            fakePos.Depth = v
            getgenv().SetFakePositionDepth(v)
        end
    })

    secFP:toggle({
        name      = "Dynamic Walk (WASD Smooth)",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.WalkMode = v end
    })

    secFP:toggle({
        name      = "Surface Camera Elevation",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.SurfaceCamera = v end
    })

    secFP:toggle({
        name      = "Auto Noclip Underground",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.AutoNoclip = v end
    })

    secFP:toggle({
        name      = "Auto Handoff On Shoot",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.AutoHandoff = v end
    })

    local col2 = charFPTab:column({})
    local secFPCloak = col2:section({ name = "Desync Cloak & Visualizer", default = true, icon = "rbxassetid://6031075931" })

    local ghostTog = secFPCloak:toggle({
        name      = "Visualise Fake Position (Ghost)",
        default   = false,
        seperator = true,
        callback  = function(v)
            fakePos.VisualizerEnabled = v
            updateGhostVisualizer()
        end
    })
    ghostTog:colorpicker({
        name     = "Ghost Color",
        color    = Color3.fromRGB(0, 162, 255),
        callback = function(c)
            fakePos.VisualizerColor = c
            updateGhostVisualizer()
        end
    })

    secFPCloak:toggle({
        name      = "Panic Jitter Mode (Anti-Aimbot)",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.Panic = v end
    })

    secFPCloak:slider({
        name      = "Panic X Min Range",
        min       = -15,
        max       = 0,
        interval  = 1,
        default   = -5,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) fakePos.PanicMinX = v end
    })

    secFPCloak:slider({
        name      = "Panic X Max Range",
        min       = 0,
        max       = 15,
        interval  = 1,
        default   = 5,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) fakePos.PanicMaxX = v end
    })

    secFPCloak:toggle({
        name      = "Panic Z Jitter Axis",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.PanicZ = v end
    })

    secFPCloak:toggle({
        name      = "Hide Character Meshes",
        default   = false,
        seperator = true,
        callback  = function(v)
            fakePos.HideMeshes = v
            getgenv().SetFakePositionHideMesh(v)
        end
    })
    secFPCloak:toggle({
        name      = "Freeze Desync Animation Pose",
        default   = false,
        seperator = true,
        callback  = function(v)
            fakePos.AnimationDesync = v
            if fakePos.Enabled then
                if v then playAnimDesync() else stopAnimDesync() end
            end
        end
    })

    secFPCloak:toggle({
        name      = "Zero Assembly Velocity",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.ZeroVelocity = v end
    })
end

do
    local col1 = charAnglesTab:column({})
    local secAngles = col1:section({ name = "Pitch & Yaw Manipulation", default = true, icon = "rbxassetid://6031075931" })

    secAngles:toggle({
        name      = "Invert Head Pitch (Anti-Headshot)",
        default   = false,
        seperator = true,
        callback  = function(v) fakePos.InvertPitch = v end
    })

    secAngles:slider({
        name      = "Custom Pitch Angle",
        min       = -89,
        max       = 89,
        interval  = 1,
        default   = -89,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) fakePos.CustomPitch = v end
    })
    secAngles:slider({
        name      = "Custom Yaw Angle",
        min       = 0,
        max       = 360,
        interval  = 5,
        default   = 0,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) fakePos.CustomYaw = v end
    })

    local col2 = charAnglesTab:column({})
    local secHitbox = col2:section({ name = "Hitbox Orientation Desync", default = true, icon = "rbxassetid://6031075931" })

    secHitbox:dropdown({
        name      = "Hitbox Preset",
        items     = { "Inverted Pitch (-89)", "Zero Pitch", "Backward Look", "Spinbot" },
        default   = "Inverted Pitch (-89)",
        seperator = true,
        callback  = function(v)
            if v == "Inverted Pitch (-89)" then
                fakePos.InvertPitch = true
            elseif v == "Zero Pitch" then
                fakePos.InvertPitch = false
                fakePos.CustomPitch = 0
            elseif v == "Backward Look" then
                fakePos.InvertPitch = false
                fakePos.CustomYaw = 180
            end
        end
    })

    secHitbox:slider({
        name      = "Spinbot Yaw Speed",
        min       = 1,
        max       = 50,
        interval  = 1,
        default   = 15,
        seperator = true,
        callback  = function(v) flags.antiaim_spin_speed = v end
    })
end

do
    local col1 = charDesyncTab:column({})
    local secDesync = col1:section({ name = "Subterranean & Void Desync", default = true, icon = "rbxassetid://6031075931" })

    secDesync:dropdown({
        name      = "Desync Mode",
        items     = { "Position Desync V2", "Voidspam Desync", "Lite Desync" },
        default   = "Position Desync V2",
        seperator = true,
        callback  = function(v) fakePos.DesyncMode = v end
    })

    secDesync:toggle({
        name      = "Auto Void On Low HP (< 25 HP)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_void_low_hp = v end
    })

    secDesync:toggle({
        name      = "Melee Underground Strike",
        default   = false,
        seperator = true,
        callback  = function(v) flags.melee_underground_strike = v end
    })

    secDesync:slider({
        name      = "Melee Desync Reach",
        min       = 5,
        max       = 30,
        interval  = 1,
        default   = 18,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.melee_reach = v end
    })

    local col2 = charDesyncTab:column({})
    local secLag = col2:section({ name = "Packet Choking (Fake Lag)", default = true, icon = "rbxassetid://6031075931" })

    secLag:toggle({
        name      = "Fake Lag / Choke Packets",
        default   = false,
        seperator = true,
        callback  = function(v) flags.fakelag_enabled = v end
    })

    secLag:slider({
        name      = "Choke Limit",
        min       = 1,
        max       = 14,
        interval  = 1,
        default   = 6,
        suffix    = " ticks",
        seperator = true,
        callback  = function(v) flags.fakelag_choke = v end
    })

    secLag:dropdown({
        name      = "Lag Mode",
        items     = { "Fluctuate", "Static", "Adaptive (Peak On Shoot)" },
        default   = "Fluctuate",
        seperator = true,
        callback  = function(v) flags.fakelag_mode = v end
    })

    secLag:toggle({
        name      = "Break Lag Comp (LC Breaker)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.fakelag_break_lc = v end
    })
end


window:seperator({ name = "other" })

local configMainTab, settingsMainTab = window:tab({
    name = "configs",
    icon = "rbxassetid://10734950309",
    tabs = { "configs", "settings" }
})
do
    local col1 = configMainTab:column({})
    local secConfigList = col1:section({ name = "Saved Configs", size = 1, default = true, icon = "rbxassetid://139628202576511" })
    
    local cfgList
    cfgList = secConfigList:list({
        options = { "default" },
        default = "default",
        flag = "selected_config_name",
        callback = function(option)
            flags.selected_config_name = option
        end
    })

    local function refreshConfigs()
        pcall(function()
            if not isfolder or not listfiles then return end
            if not isfolder("sleepy") then makefolder("sleepy") end
            if not isfolder("sleepy/configs") then makefolder("sleepy/configs") end
            local files = listfiles("sleepy/configs")
            local list = {}
            for _, f in ipairs(files) do
                local name = tostring(f):gsub("sleepy/configs[\\/]", ""):gsub("sleepy[\\/]configs[\\/]", ""):gsub(".cfg", ""):gsub(".json", "")
                table.insert(list, name)
            end
            if #list == 0 then table.insert(list, "default") end
            if cfgList and cfgList.refresh_options then
                cfgList.refresh_options(list)
            end
        end)
    end

    local col2 = configMainTab:column({})
    local secConfigActions = col2:section({ name = "Config Actions", size = 1, default = true, icon = "rbxassetid://129380150574313" })
    
    secConfigActions:textbox({
        name = "Config Name",
        default = "",
        seperator = true,
        callback = function(t)
            flags.config_custom_name = t
        end
    })

    secConfigActions:button({
        name = "Save Config",
        callback = function()
            local cname = flags.config_custom_name
            if not cname or #cname == 0 then cname = flags.selected_config_name end
            if not cname or #cname == 0 then cname = "default" end
            pcall(function()
                if not isfolder("sleepy") then makefolder("sleepy") end
                if not isfolder("sleepy/configs") then makefolder("sleepy/configs") end
                local data = Library:get_config()
                writefile("sleepy/configs/" .. cname .. ".cfg", data)
                refreshConfigs()
                if Library.notifications then
                    Library.notifications:create_notification({
                        name = "Configs",
                        info = "Saved config: " .. cname,
                        lifetime = 3
                    })
                end
            end)
        end
    })

    secConfigActions:button({
        name = "Load Config",
        callback = function()
            local cname = flags.selected_config_name or flags.config_custom_name or "default"
            pcall(function()
                local path = "sleepy/configs/" .. cname .. ".cfg"
                if isfile and isfile(path) then
                    local data = readfile(path)
                    Library:load_config(data)
                    if Library.notifications then
                        Library.notifications:create_notification({
                            name = "Configs",
                            info = "Loaded config: " .. cname,
                            lifetime = 3
                        })
                    end
                else
                    warn("[Sleepy Hub] Config file not found: " .. path)
                end
            end)
        end
    })

    secConfigActions:button({
        name = "Delete Config",
        callback = function()
            local cname = flags.selected_config_name
            if not cname or #cname == 0 or cname == "default" then return end
            pcall(function()
                local path = "sleepy/configs/" .. cname .. ".cfg"
                if isfile and isfile(path) then
                    delfile(path)
                    refreshConfigs()
                    if Library.notifications then
                        Library.notifications:create_notification({
                            name = "Configs",
                            info = "Deleted config: " .. cname,
                            lifetime = 3
                        })
                    end
                end
            end)
        end
    })

    secConfigActions:button({
        name = "Export to Clipboard",
        callback = function()
            pcall(function()
                if setclipboard then
                    setclipboard(Library:get_config())
                    if Library.notifications then
                        Library.notifications:create_notification({
                            name = "Configs",
                            info = "Config copied to clipboard!",
                            lifetime = 3
                        })
                    end
                end
            end)
        end
    })

    secConfigActions:button({
        name = "Import from Clipboard",
        callback = function()
            pcall(function()
                if getclipboard then
                    local clip = getclipboard()
                    if clip and #clip > 0 then
                        Library:load_config(clip)
                        if Library.notifications then
                            Library.notifications:create_notification({
                                name = "Configs",
                                info = "Config loaded from clipboard!",
                                lifetime = 3
                            })
                        end
                    end
                end
            end)
        end
    })

    task.defer(refreshConfigs)
end

do
    local col1 = settingsMainTab:column({})
    local secTheme = col1:section({ name = "Menu Theme & Visuals", size = 1, default = true, icon = "rbxassetid://6031075931" })

    secTheme:colorpicker({
        name = "Accent Color",
        color = Color3.fromRGB(0, 162, 255),
        callback = function(c)
            Library:update_theme("accent", c)
        end
    })

    secTheme:keybind({
        name = "Menu Toggle Keybind",
        default = Enum.KeyCode.RightShift,
        mode = "Toggle",
        callback = function(state)
            if window and window.toggle_menu then
                window.toggle_menu(state)
            end
        end
    })

    secTheme:toggle({
        name = "Show Keybinds Widget",
        default = false,
        seperator = true,
        callback = function(v)
            flags.show_keybinds_widget = v
            pcall(function()
                local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
                local kb = coreGui:FindFirstChild("_MeowKeybindsWidget")
                if kb then kb.Enabled = v end
            end)
        end
    })

    secTheme:toggle({
        name = "Show Music Player",
        default = false,
        seperator = true,
        callback = function(v)
            flags.show_music_player = v
            pcall(function()
                local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
                local mp = coreGui:FindFirstChild("_MeowMusicPlayer")
                if mp then mp.Enabled = v end
            end)
        end
    })

    local col2 = settingsMainTab:column({})
    local secUtils = col2:section({ name = "Game Utilities", size = 1, default = true, icon = "rbxassetid://6031075931" })

    secUtils:button({
        name = "Rejoin Server",
        callback = function()
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
            end)
        end
    })

    secUtils:button({
        name = "Server Hop",
        callback = function()
            pcall(function()
                local ts = game:GetService("TeleportService")
                local http = game:GetService("HttpService")
                local servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                for _, s in ipairs(servers.data) do
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then
                        ts:TeleportToPlaceInstance(game.PlaceId, s.id, lp)
                        break
                    end
                end
            end)
        end
    })

    secUtils:button({
        name = "Copy Discord Invite",
        callback = function()
            pcall(function()
                if setclipboard then
                    setclipboard("https://discord.gg/sleepy")
                    if Library.notifications then
                        Library.notifications:create_notification({
                            name = "Discord",
                            info = "Invite copied to clipboard!",
                            lifetime = 3
                        })
                    end
                end
            end)
        end
    })
    secUtils:button({
        name = "Unload Cheat",
        callback = function()
            pcall(function()
                if Library and Library.items then
                    Library.items:Destroy()
                end
                if shared.MeowCosmeticsGui then
                    shared.MeowCosmeticsGui:Destroy()
                end
                local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
                local pill = coreGui:FindFirstChild("_MeowCosmeticPill")
                if pill then pill:Destroy() end
                meowState.Destroyed = true
            end)
        end
    })
end

Library:init_config(window)

initProceduralDrawings()

local stepConn = RunService.Heartbeat:Connect(function()
    if meowState.Destroyed then return end
    get_target()
    runCombatAimbot()
    runMeleeAura()
    updateTargetVisuals()
    updateWeaponVisuals()
    runAutoLoadout()
    runAutoQueue()
    runBunnyHop()
    runSpoofers()
end)

local renderConn = RunService.RenderStepped:Connect(function(dt)
    if meowState.Destroyed then return end
    runAntiAim()
    updateEsp()
    updateChams()
    updateCrosshair()
    updateFovCircles()
    updateBulletTracers()
    updateCameraAndWorld(dt)
    updateWorldLighting(dt)
end)

task.spawn(function()
    task.wait(0.2)
    pcall(function()
        if Library and Library.items then
            for _, v in ipairs(Library.items:GetDescendants()) do
                if v:IsA("TextButton") then
                    local label = v:FindFirstChildOfClass("TextLabel")
                    if label and label.Text == "main" then
                        if getconnections then
                            for _, conn in ipairs(getconnections(v.MouseButton1Down)) do
                                pcall(function()
                                    local fn = conn.Function
                                    if fn and debug and debug.getupvalues then
                                        for _, u in pairs(debug.getupvalues(fn)) do
                                            if type(u) == "table" and u.open_tab then
                                                u.open_tab()
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end)

Library.notifications:create_notification({
    name     = "Sleepy.gg 🎃",
    info     = "Halloween Edition loaded with Music Player & Blue UI!",
    lifetime = 4
})
print("[Sleepy.gg 🎃] Ultimate script loaded with Music Player & Electric Blue UI!")

local MusicPlayer = {
    Visible = false,
    Playing = false,
    CurrentTrack = 1,
    Volume = 0.5,
    Shuffle = false,
    RepeatAll = true,
    BassBoost = false,
    NormalMode = true,
    Sound = nil,
    Equalizer = nil,
    Gui = nil,
    MainFrame = nil,
    Playlist = {
        { title = "01 OMFG - Hello", artist = "OMFG", time = "3:44", id = "rbxassetid://110788401793874" },
        { title = "02 heart - myla", artist = "heart", time = "2:15", id = "rbxassetid://71792887446304" },
        { title = "03 no name triad", artist = "triad", time = "2:30", id = "rbxassetid://104949403812182" },
        { title = "04 KING NASIR SONG", artist = "King Nasir", time = "2:45", id = "rbxassetid://76650356472656" },
        { title = "05 Under your spell", artist = "Snow Strippers", time = "2:20", id = "rbxassetid://91007045451630" },
        { title = "06 End of Beginning", artist = "Djo", time = "2:39", id = "rbxassetid://91319037332598" },
        { title = "07 Du Bist Gut Genug", artist = "Bausa", time = "2:48", id = "rbxassetid://85462356235488" },
        { title = "08 IMPOSTER SYNDROME", artist = "Art", time = "2:35", id = "rbxassetid://132298170699457" },
        { title = "09 BABYDOLL", artist = "Ari Abdul", time = "3:01", id = "rbxassetid://127012181396114" },
        { title = "10 RICARDO MILOS (DOTA)", artist = "Basshunter", time = "3:20", id = "rbxassetid://78478068056253" },
        { title = "11 TERRANOVA 🔥", artist = "Terranova", time = "2:50", id = "rbxassetid://82746224492420" },
        { title = "12 MIRROR DEMO", artist = "Mirror", time = "2:15", id = "rbxassetid://124497261394793" },
        { title = "13 RAMPAGE", artist = "Jugsta", time = "2:10", id = "rbxassetid://15689453751" },
        { title = "14 Molchat Doma - Sudno (Vessel)", artist = "Molchat Doma", time = "2:21", id = "rbxassetid://9048375035" },
        { title = "15 Metamorphosis", artist = "INTERWORLD", time = "2:23", id = "rbxassetid://9045763048" },
        { title = "16 Midnight City", artist = "M83", time = "4:03", id = "rbxassetid://1837879082" },
        { title = "17 Tokyo Drift", artist = "Teriyaki Boyz", time = "4:15", id = "rbxassetid://1843404009" },
        { title = "18 After Dark", artist = "Mr. Kitty", time = "4:17", id = "rbxassetid://6913550904" },
        { title = "19 Resonance", artist = "HOME", time = "3:32", id = "rbxassetid://5410086218" },
        { title = "20 Murder In My Mind", artist = "KORDHELL", time = "2:25", id = "rbxassetid://9048375035" },
        { title = "21 Close Eyes", artist = "DVRST", time = "2:12", id = "rbxassetid://9043887091" },
        { title = "22 Neon Blade", artist = "MoonDeity", time = "4:24", id = "rbxassetid://1848354536" },
        { title = "23 Memory Reboot", artist = "VOJ & Narvent", time = "3:29", id = "rbxassetid://7028525146" },
        { title = "24 Sahara", artist = "Hensonn", time = "2:51", id = "rbxassetid://1845554011" },
        { title = "25 GigaChad Theme", artist = "Phonk Remix", time = "2:20", id = "rbxassetid://9045763048" },
        { title = "26 SimpsonWave 1995", artist = "FrankJavCee", time = "2:45", id = "rbxassetid://5410086218" },
        { title = "27 Supernova", artist = "Phonk Edition", time = "3:10", id = "rbxassetid://9048375035" },
        { title = "28 Override", artist = "KSLV Noh", time = "1:55", id = "rbxassetid://9043887091" },
        { title = "29 Live Another Day", artist = "KSLV", time = "2:14", id = "rbxassetid://1848354536" },
        { title = "30 Disaster", artist = "KSLV", time = "2:18", id = "rbxassetid://1843404009" },
        { title = "31 SXND NXDES", artist = "BADTRIP MUSIC", time = "2:04", id = "rbxassetid://7028525146" },
        { title = "32 Montagem Mysterious", artist = "Phonk Drift", time = "2:31", id = "rbxassetid://9045763048" },
        { title = "33 Automotivo Bibi Fogosa", artist = "Bibi Babydoll", time = "2:00", id = "rbxassetid://1837879082" },
        { title = "34 Brazilian Phonk Mano", artist = "Slowed", time = "2:22", id = "rbxassetid://6913550904" },
        { title = "35 Vendetta", artist = "MUPP & Sadfriendd", time = "1:47", id = "rbxassetid://5409894140" },
        { title = "36 Wake Up!", artist = "MoonDeity", time = "2:15", id = "rbxassetid://9048375035" },
        { title = "37 Lovely Bastards", artist = "ZWE1HVNDXR", time = "1:58", id = "rbxassetid://9043887091" },
        { title = "38 Smoke", artist = "Cowbell Cult", time = "2:08", id = "rbxassetid://1845554011" },
        { title = "39 North Face", artist = "RXDXVIL", time = "2:12", id = "rbxassetid://5410086218" },
        { title = "40 Warning", artist = "MC Orsen", time = "2:37", id = "rbxassetid://1843404009" },
        { title = "41 Dark Beach", artist = "Pastel Ghost", time = "3:42", id = "rbxassetid://1848354536" },
        { title = "42 The Perfect Girl", artist = "Mareux", time = "3:14", id = "rbxassetid://7028525146" },
        { title = "43 Transgender", artist = "Crystal Castles", time = "3:05", id = "rbxassetid://9045763048" },
        { title = "44 Suffocation", artist = "Crystal Castles", time = "4:02", id = "rbxassetid://1837879082" },
        { title = "45 Dream Space", artist = "DVRST", time = "2:52", id = "rbxassetid://6913550904" },
        { title = "46 Rapture", artist = "INTERWORLD", time = "2:30", id = "rbxassetid://5410086218" },
        { title = "47 Sahara Slowed", artist = "Hensonn", time = "3:20", id = "rbxassetid://9048375035" },
        { title = "48 Shadow", artist = "ONIMXRU & SMITHMANE", time = "2:06", id = "rbxassetid://9043887091" },
        { title = "49 S.X.N.D. N.X.D.E.S.", artist = "Sped Up", time = "1:45", id = "rbxassetid://1845554011" },
        { title = "50 Neon Blade Slowed", artist = "MoonDeity", time = "4:55", id = "rbxassetid://1848354536" }
    }
}

local function initMusicPlayer()
    local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
    local soundService = cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService")

    local sound = Instance.new("Sound")
    sound.Name = "_MeowMusicTrack"
    sound.Volume = MusicPlayer.Volume
    sound.Looped = not MusicPlayer.RepeatAll
    sound.Parent = soundService
    MusicPlayer.Sound = sound

    local eq = Instance.new("EqualizerSoundEffect")
    eq.Name = "_MeowBassBoost"
    eq.LowGain = 0
    eq.MidGain = 0
    eq.HighGain = 0
    eq.Enabled = false
    eq.Parent = sound
    MusicPlayer.Equalizer = eq

    local sg = Instance.new("ScreenGui")
    sg.Name = "_MeowMusicPlayerGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 1000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = coreGui end)
    if not sg.Parent then
        pcall(function() sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 0.5) end)
    end
    MusicPlayer.Gui = sg
    shared.MeowMusicPlayer = MusicPlayer

    local main = Instance.new("Frame")
    main.Name = "MusicPlayerFrame"
    main.Size = UDim2.fromOffset(296, 475)
    main.Position = UDim2.new(1, -315, 0, 20)
    main.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    main.BorderSizePixel = 0
    main.Visible = false
    main.ZIndex = 500
    main.Parent = sg
    MusicPlayer.MainFrame = main

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(29, 31, 39)
    stroke.Thickness = 1

    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundTransparency = 1
    topBar.Parent = main

    local blueDot = Instance.new("Frame")
    blueDot.Size = UDim2.fromOffset(6, 6)
    blueDot.Position = UDim2.fromOffset(12, 13)
    blueDot.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    blueDot.BorderSizePixel = 0
    blueDot.Parent = topBar
    Instance.new("UICorner", blueDot).CornerRadius = UDim.new(1, 0)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromOffset(90, 32)
    titleLabel.Position = UDim2.fromOffset(24, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Music Player"
    titleLabel.TextColor3 = Color3.fromRGB(235, 238, 245)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    local songCountLabel = Instance.new("TextLabel")
    songCountLabel.Size = UDim2.fromOffset(70, 32)
    songCountLabel.Position = UDim2.new(1, -125, 0, 0)
    songCountLabel.BackgroundTransparency = 1
    songCountLabel.Text = #MusicPlayer.Playlist .. " songs"
    songCountLabel.TextColor3 = Color3.fromRGB(120, 125, 138)
    songCountLabel.Font = Enum.Font.Gotham
    songCountLabel.TextSize = 10
    songCountLabel.TextXAlignment = Enum.TextXAlignment.Right
    songCountLabel.Parent = topBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(20, 20)
    minBtn.Position = UDim2.new(1, -48, 0, 6)
    minBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(160, 165, 175)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.Parent = topBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -24, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Color3.fromRGB(160, 165, 175)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -32)
    contentFrame.Position = UDim2.fromOffset(0, 32)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = main

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        contentFrame.Visible = not minimized
        main.Size = minimized and UDim2.fromOffset(296, 32) or UDim2.fromOffset(296, 475)
        minBtn.Text = minimized and "+" or "-"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 0, 64)
    card.Position = UDim2.fromOffset(10, 4)
    card.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
    card.BorderSizePixel = 0
    card.Parent = contentFrame
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(28, 30, 40)
    cardStroke.Thickness = 1

    local album = Instance.new("Frame")
    album.Size = UDim2.fromOffset(46, 46)
    album.Position = UDim2.fromOffset(9, 9)
    album.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
    album.BorderSizePixel = 0
    album.Parent = card
    Instance.new("UICorner", album).CornerRadius = UDim.new(0, 6)
    local albumStroke = Instance.new("UIStroke", album)
    albumStroke.Color = Color3.fromRGB(35, 38, 50)
    albumStroke.Thickness = 1

    local waveLabel = Instance.new("TextLabel")
    waveLabel.Size = UDim2.new(1, -4, 0, 12)
    waveLabel.Position = UDim2.new(0, 2, 1, -14)
    waveLabel.BackgroundTransparency = 1
    waveLabel.Text = "........"
    waveLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
    waveLabel.Font = Enum.Font.GothamBold
    waveLabel.TextSize = 10
    waveLabel.Parent = album

    local trackTitle = Instance.new("TextLabel")
    trackTitle.Size = UDim2.new(1, -70, 0, 16)
    trackTitle.Position = UDim2.fromOffset(64, 10)
    trackTitle.BackgroundTransparency = 1
    trackTitle.Text = MusicPlayer.Playlist[1].title
    trackTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
    trackTitle.Font = Enum.Font.GothamBold
    trackTitle.TextSize = 12
    trackTitle.TextXAlignment = Enum.TextXAlignment.Left
    trackTitle.TextTruncate = Enum.TextTruncate.AtEnd
    trackTitle.Parent = card

    local trackStatus = Instance.new("TextLabel")
    trackStatus.Size = UDim2.new(1, -70, 0, 13)
    trackStatus.Position = UDim2.fromOffset(64, 26)
    trackStatus.BackgroundTransparency = 1
    trackStatus.Text = "ready"
    trackStatus.TextColor3 = Color3.fromRGB(130, 135, 148)
    trackStatus.Font = Enum.Font.Gotham
    trackStatus.TextSize = 10
    trackStatus.TextXAlignment = Enum.TextXAlignment.Left
    trackStatus.Parent = card

    local trackSub = Instance.new("TextLabel")
    trackSub.Size = UDim2.new(1, -70, 0, 12)
    trackSub.Position = UDim2.fromOffset(64, 40)
    trackSub.BackgroundTransparency = 1
    trackSub.Text = "track 1 of " .. #MusicPlayer.Playlist .. " · Community"
    trackSub.TextColor3 = Color3.fromRGB(90, 95, 108)
    trackSub.Font = Enum.Font.Gotham
    trackSub.TextSize = 9
    trackSub.TextXAlignment = Enum.TextXAlignment.Left
    trackSub.Parent = card

    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(1, -20, 0, 16)
    progressFrame.Position = UDim2.fromOffset(10, 74)
    progressFrame.BackgroundTransparency = 1
    progressFrame.Parent = contentFrame

    local curTimeLbl = Instance.new("TextLabel")
    curTimeLbl.Size = UDim2.fromOffset(28, 16)
    curTimeLbl.BackgroundTransparency = 1
    curTimeLbl.Text = "0:00"
    curTimeLbl.TextColor3 = Color3.fromRGB(130, 135, 148)
    curTimeLbl.Font = Enum.Font.Gotham
    curTimeLbl.TextSize = 9
    curTimeLbl.TextXAlignment = Enum.TextXAlignment.Left
    curTimeLbl.Parent = progressFrame

    local totTimeLbl = Instance.new("TextLabel")
    totTimeLbl.Size = UDim2.fromOffset(28, 16)
    totTimeLbl.Position = UDim2.new(1, -28, 0, 0)
    totTimeLbl.BackgroundTransparency = 1
    totTimeLbl.Text = MusicPlayer.Playlist[1].time
    totTimeLbl.TextColor3 = Color3.fromRGB(130, 135, 148)
    totTimeLbl.Font = Enum.Font.Gotham
    totTimeLbl.TextSize = 9
    totTimeLbl.TextXAlignment = Enum.TextXAlignment.Right
    totTimeLbl.Parent = progressFrame

    local progBarBg = Instance.new("TextButton")
    progBarBg.Size = UDim2.new(1, -66, 0, 3)
    progBarBg.Position = UDim2.fromOffset(33, 6)
    progBarBg.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
    progBarBg.Text = ""
    progBarBg.AutoButtonColor = false
    progBarBg.Parent = progressFrame
    Instance.new("UICorner", progBarBg).CornerRadius = UDim.new(1, 0)

    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    progFill.BorderSizePixel = 0
    progFill.Parent = progBarBg
    Instance.new("UICorner", progFill).CornerRadius = UDim.new(1, 0)

    local progDragging = false
    progBarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            progDragging = true
            if sound.TimeLength > 0 then
                local rel = math.clamp((input.Position.X - progBarBg.AbsolutePosition.X) / progBarBg.AbsoluteSize.X, 0, 1)
                sound.TimePosition = rel * sound.TimeLength
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            progDragging = false
        end
    end)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(1, -20, 0, 36)
    controls.Position = UDim2.fromOffset(10, 94)
    controls.BackgroundTransparency = 1
    controls.Parent = contentFrame

    local prevBtn = Instance.new("TextButton")
    prevBtn.Size = UDim2.fromOffset(34, 30)
    prevBtn.Position = UDim2.new(0.5, -60, 0, 3)
    prevBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    prevBtn.Text = "|<"
    prevBtn.TextColor3 = Color3.fromRGB(190, 195, 208)
    prevBtn.Font = Enum.Font.GothamBold
    prevBtn.TextSize = 11
    prevBtn.Parent = controls
    Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 6)
    local pbStroke = Instance.new("UIStroke", prevBtn)
    pbStroke.Color = Color3.fromRGB(30, 32, 42)
    pbStroke.Thickness = 1

    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.fromOffset(38, 32)
    playBtn.Position = UDim2.new(0.5, -19, 0, 2)
    playBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    playBtn.Text = ">"
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 15
    playBtn.Parent = controls
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)

    local nextBtn = Instance.new("TextButton")
    nextBtn.Size = UDim2.fromOffset(34, 30)
    nextBtn.Position = UDim2.new(0.5, 26, 0, 3)
    nextBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    nextBtn.Text = ">|"
    nextBtn.TextColor3 = Color3.fromRGB(190, 195, 208)
    nextBtn.Font = Enum.Font.GothamBold
    nextBtn.TextSize = 11
    nextBtn.Parent = controls
    Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 6)
    local nbStroke = Instance.new("UIStroke", nextBtn)
    nbStroke.Color = Color3.fromRGB(30, 32, 42)
    nbStroke.Thickness = 1

    local volFrame = Instance.new("Frame")
    volFrame.Size = UDim2.new(1, -20, 0, 18)
    volFrame.Position = UDim2.fromOffset(10, 136)
    volFrame.BackgroundTransparency = 1
    volFrame.Parent = contentFrame

    local volLabel = Instance.new("TextLabel")
    volLabel.Size = UDim2.fromOffset(45, 18)
    volLabel.BackgroundTransparency = 1
    volLabel.Text = "volume"
    volLabel.TextColor3 = Color3.fromRGB(130, 135, 148)
    volLabel.Font = Enum.Font.Gotham
    volLabel.TextSize = 11
    volLabel.TextXAlignment = Enum.TextXAlignment.Left
    volLabel.Parent = volFrame

    local volBarBg = Instance.new("TextButton")
    volBarBg.Size = UDim2.new(1, -48, 0, 14)
    volBarBg.Position = UDim2.fromOffset(48, 2)
    volBarBg.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    volBarBg.Text = ""
    volBarBg.AutoButtonColor = false
    volBarBg.Parent = volFrame
    Instance.new("UICorner", volBarBg).CornerRadius = UDim.new(0, 4)
    local vbStroke = Instance.new("UIStroke", volBarBg)
    vbStroke.Color = Color3.fromRGB(28, 30, 40)
    vbStroke.Thickness = 1

    local volFill = Instance.new("Frame")
    volFill.Size = UDim2.new(0.5, 0, 1, 0)
    volFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    volFill.BorderSizePixel = 0
    volFill.Parent = volBarBg
    Instance.new("UICorner", volFill).CornerRadius = UDim.new(0, 4)

    local volPctLbl = Instance.new("TextLabel")
    volPctLbl.Size = UDim2.new(1, 0, 1, 0)
    volPctLbl.BackgroundTransparency = 1
    volPctLbl.Text = "50%"
    volPctLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    volPctLbl.Font = Enum.Font.GothamBold
    volPctLbl.TextSize = 10
    volPctLbl.Parent = volBarBg

    local volDragging = false
    local function updateVol(input)
        local rel = math.clamp((input.Position.X - volBarBg.AbsolutePosition.X) / volBarBg.AbsoluteSize.X, 0, 1)
        volFill.Size = UDim2.new(rel, 0, 1, 0)
        MusicPlayer.Volume = rel
        sound.Volume = rel
        volPctLbl.Text = math.floor(rel * 100) .. "%"
    end
    volBarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            volDragging = true
            updateVol(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            volDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if volDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateVol(input)
        end
    end)

    local modeRow = Instance.new("Frame")
    modeRow.Size = UDim2.new(1, -20, 0, 24)
    modeRow.Position = UDim2.fromOffset(10, 160)
    modeRow.BackgroundTransparency = 1
    modeRow.Parent = contentFrame

    local function makeModeBtn(x, w, txt, active)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(w, -4, 1, 0)
        b.Position = UDim2.new(x, 2, 0, 0)
        b.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
        b.Text = txt
        b.TextColor3 = active and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 155, 168)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.Parent = modeRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        local s = Instance.new("UIStroke", b)
        s.Color = active and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 30, 40)
        s.Thickness = 1
        return b, s
    end

    local shufBtn, shufStroke = makeModeBtn(0, 0.25, "shuffle", MusicPlayer.Shuffle)
    local repBtn, repStroke = makeModeBtn(0.25, 0.25, "repeat all", MusicPlayer.RepeatAll)
    local bassBtn, bassStroke = makeModeBtn(0.5, 0.25, "bass boost", MusicPlayer.BassBoost)
    local normBtn, normStroke = makeModeBtn(0.75, 0.25, "normal", MusicPlayer.NormalMode)

    shufBtn.MouseButton1Click:Connect(function()
        MusicPlayer.Shuffle = not MusicPlayer.Shuffle
        shufBtn.TextColor3 = MusicPlayer.Shuffle and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 155, 168)
        shufStroke.Color = MusicPlayer.Shuffle and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 30, 40)
    end)

    repBtn.MouseButton1Click:Connect(function()
        MusicPlayer.RepeatAll = not MusicPlayer.RepeatAll
        repBtn.TextColor3 = MusicPlayer.RepeatAll and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 155, 168)
        repStroke.Color = MusicPlayer.RepeatAll and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 30, 40)
    end)

    bassBtn.MouseButton1Click:Connect(function()
        MusicPlayer.BassBoost = not MusicPlayer.BassBoost
        eq.Enabled = MusicPlayer.BassBoost
        eq.LowGain = MusicPlayer.BassBoost and 10 or 0
        bassBtn.TextColor3 = MusicPlayer.BassBoost and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 155, 168)
        bassStroke.Color = MusicPlayer.BassBoost and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 30, 40)
    end)

    normBtn.MouseButton1Click:Connect(function()
        MusicPlayer.NormalMode = not MusicPlayer.NormalMode
        normBtn.TextColor3 = MusicPlayer.NormalMode and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(150, 155, 168)
        normStroke.Color = MusicPlayer.NormalMode and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 30, 40)
    end)
    local searchRow = Instance.new("Frame")
    searchRow.Size = UDim2.new(1, -20, 0, 24)
    searchRow.Position = UDim2.fromOffset(10, 190)
    searchRow.BackgroundTransparency = 1
    searchRow.Parent = contentFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -64, 1, 0)
    searchBox.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    searchBox.PlaceholderText = "search songs or Enter Audio ID..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(90, 95, 108)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(220, 225, 238)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 10
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchRow
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)
    local sbStroke = Instance.new("UIStroke", searchBox)
    sbStroke.Color = Color3.fromRGB(28, 30, 40)
    sbStroke.Thickness = 1
    local sPad = Instance.new("UIPadding", searchBox)
    sPad.PaddingLeft = UDim.new(0, 8)

    local randomBtn = Instance.new("TextButton")
    randomBtn.Size = UDim2.fromOffset(58, 24)
    randomBtn.Position = UDim2.new(1, -58, 0, 0)
    randomBtn.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    randomBtn.Text = "random"
    randomBtn.TextColor3 = Color3.fromRGB(170, 175, 188)
    randomBtn.Font = Enum.Font.Gotham
    randomBtn.TextSize = 10
    randomBtn.Parent = searchRow
    Instance.new("UICorner", randomBtn).CornerRadius = UDim.new(0, 4)
    local rbStroke = Instance.new("UIStroke", randomBtn)
    rbStroke.Color = Color3.fromRGB(28, 30, 40)
    rbStroke.Thickness = 1

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 0, 138)
    scroll.Position = UDim2.fromOffset(10, 220)
    scroll.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    scroll.CanvasSize = UDim2.fromOffset(0, #MusicPlayer.Playlist * 24 + 4)
    scroll.Parent = contentFrame
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll

    local songRows = {}
    local function playTrack(idx)
        if idx < 1 then idx = #MusicPlayer.Playlist end
        if idx > #MusicPlayer.Playlist then idx = 1 end
        MusicPlayer.CurrentTrack = idx
        local item = MusicPlayer.Playlist[idx]
        sound.SoundId = item.id
        sound.TimePosition = 0
        sound:Play()
        MusicPlayer.Playing = true
        playBtn.Text = "||"
        trackTitle.Text = item.title
        trackStatus.Text = "playing"
        trackSub.Text = "track " .. idx .. " of " .. #MusicPlayer.Playlist .. " · Community"
        totTimeLbl.Text = item.time

        for i, r in ipairs(songRows) do
            local isCur = (i == idx)
            r.Button.BackgroundColor3 = isCur and Color3.fromRGB(21, 34, 50) or Color3.fromRGB(16, 17, 23)
            r.Title.TextColor3 = isCur and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(190, 195, 205)
            r.Title.Text = (isCur and "... " or "") .. item.title
            r.Time.TextColor3 = isCur and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(110, 115, 125)
        end
    end

    playBtn.MouseButton1Click:Connect(function()
        if MusicPlayer.Playing then
            sound:Pause()
            MusicPlayer.Playing = false
            playBtn.Text = ">"
            trackStatus.Text = "ready"
        else
            if sound.SoundId == "" then
                playTrack(MusicPlayer.CurrentTrack)
            else
                sound:Resume()
                MusicPlayer.Playing = true
                playBtn.Text = "||"
                trackStatus.Text = "playing"
            end
        end
    end)

    prevBtn.MouseButton1Click:Connect(function()
        playTrack(MusicPlayer.CurrentTrack - 1)
    end)

    nextBtn.MouseButton1Click:Connect(function()
        if MusicPlayer.Shuffle then
            playTrack(math.random(1, #MusicPlayer.Playlist))
        else
            playTrack(MusicPlayer.CurrentTrack + 1)
        end
    end)

    randomBtn.MouseButton1Click:Connect(function()
        playTrack(math.random(1, #MusicPlayer.Playlist))
    end)

    searchBox.FocusLost:Connect(function(enterPressed)
        local query = searchBox.Text:gsub("%s+", "")
        if #query > 0 then
            local cleanNum = query:gsub("%D+", "")
            if #cleanNum > 4 then
                sound.SoundId = "rbxassetid://" .. cleanNum
                sound.TimePosition = 0
                sound:Play()
                MusicPlayer.Playing = true
                playBtn.Text = "||"
                trackTitle.Text = "Custom: " .. query
                trackStatus.Text = "playing"
                trackSub.Text = "Custom Audio Stream"
                return
            end
        end
    end)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(searchBox.Text)
        for i, r in ipairs(songRows) do
            local m = string.lower(MusicPlayer.Playlist[i].title)
            r.Button.Visible = (q == "" or m:find(q, 1, true) ~= nil)
        end
    end)

    for i, trk in ipairs(MusicPlayer.Playlist) do
        local isCur = (i == 1)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -4, 0, 22)
        row.BackgroundColor3 = isCur and Color3.fromRGB(21, 34, 50) or Color3.fromRGB(16, 17, 23)
        row.Text = ""
        row.AutoButtonColor = true
        row.LayoutOrder = i
        row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

        local tLbl = Instance.new("TextLabel")
        tLbl.Size = UDim2.new(1, -45, 1, 0)
        tLbl.Position = UDim2.fromOffset(6, 0)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = (isCur and "... " or "") .. trk.title
        tLbl.TextColor3 = isCur and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(190, 195, 205)
        tLbl.Font = Enum.Font.Gotham
        tLbl.TextSize = 10
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.TextTruncate = Enum.TextTruncate.AtEnd
        tLbl.Parent = row

        local dLbl = Instance.new("TextLabel")
        dLbl.Size = UDim2.fromOffset(40, 22)
        dLbl.Position = UDim2.new(1, -44, 0, 0)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = trk.time
        dLbl.TextColor3 = isCur and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(110, 115, 125)
        dLbl.Font = Enum.Font.Gotham
        dLbl.TextSize = 9
        dLbl.TextXAlignment = Enum.TextXAlignment.Right
        dLbl.Parent = row

        row.MouseButton1Click:Connect(function()
            playTrack(i)
        end)

        songRows[i] = { Button = row, Title = tLbl, Time = dLbl }
    end

    local loadCommBtn = Instance.new("TextButton")
    loadCommBtn.Size = UDim2.new(1, -20, 0, 24)
    loadCommBtn.Position = UDim2.fromOffset(10, 364)
    loadCommBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 29)
    loadCommBtn.Text = "Load Community Songs"
    loadCommBtn.TextColor3 = Color3.fromRGB(210, 215, 228)
    loadCommBtn.Font = Enum.Font.GothamBold
    loadCommBtn.TextSize = 10
    loadCommBtn.Parent = contentFrame
    Instance.new("UICorner", loadCommBtn).CornerRadius = UDim.new(0, 4)
    local lcbStroke = Instance.new("UIStroke", loadCommBtn)
    lcbStroke.Color = Color3.fromRGB(30, 32, 42)
    lcbStroke.Thickness = 1

    loadCommBtn.MouseButton1Click:Connect(function()
        if Library and Library.notifications then
            Library.notifications:create_notification({
                name = "Music Player",
                info = "Refreshed 50 songs from community library!",
                lifetime = 2
            })
        end
    end)

    local footNote1 = Instance.new("TextLabel")
    footNote1.Size = UDim2.new(1, -20, 0, 12)
    footNote1.Position = UDim2.fromOffset(10, 394)
    footNote1.BackgroundTransparency = 1
    footNote1.Text = "load songs by dragging .mp3 files into the Songs folder"
    footNote1.TextColor3 = Color3.fromRGB(100, 105, 118)
    footNote1.Font = Enum.Font.Gotham
    footNote1.TextSize = 8
    footNote1.Parent = contentFrame

    local footNote2 = Instance.new("TextLabel")
    footNote2.Size = UDim2.new(1, -20, 0, 12)
    footNote2.Position = UDim2.fromOffset(10, 407)
    footNote2.BackgroundTransparency = 1
    footNote2.Text = "workspace / Sleepy Hub / Songs"
    footNote2.TextColor3 = Color3.fromRGB(80, 85, 98)
    footNote2.Font = Enum.Font.Gotham
    footNote2.TextSize = 8
    footNote2.Parent = contentFrame

    sound.Ended:Connect(function()
        if MusicPlayer.RepeatAll then
            if MusicPlayer.Shuffle then
                playTrack(math.random(1, #MusicPlayer.Playlist))
            else
                playTrack(MusicPlayer.CurrentTrack + 1)
            end
        else
            MusicPlayer.Playing = false
            playBtn.Text = ">"
            trackStatus.Text = "ready"
        end
    end)

    RunService.Heartbeat:Connect(function()
        if MusicPlayer.Playing and sound.TimeLength > 0 then
            local pos = sound.TimePosition
            local len = sound.TimeLength
            local mins = math.floor(pos / 60)
            local secs = math.floor(pos % 60)
            curTimeLbl.Text = string.format("%d:%02d", mins, secs)
            if not progDragging then
                progFill.Size = UDim2.new(math.clamp(pos / len, 0, 1), 0, 1, 0)
            end
        end
    end)
end

local function initKeybindsWidget()
    local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
    local sg = Instance.new("ScreenGui")
    sg.Name = "_MeowKeybindsWidget"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = coreGui end)
    if not sg.Parent then
        pcall(function() sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 0.5) end)
    end

    local main = Instance.new("Frame")
    main.Name = "KeybindsFrame"
    main.Size = UDim2.fromOffset(180, 60)
    main.Position = UDim2.new(1, -300, 1, -120)
    main.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    main.BorderSizePixel = 0
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(28, 30, 38)
    stroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 22)
    title.BackgroundTransparency = 1
    title.Text = "keybinds"
    title.TextColor3 = Color3.fromRGB(240, 245, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10
    title.Parent = main

    local bindLine = Instance.new("TextLabel")
    bindLine.Size = UDim2.new(1, -12, 0, 20)
    bindLine.Position = UDim2.fromOffset(6, 26)
    bindLine.BackgroundTransparency = 1
    bindLine.RichText = true
    bindLine.Text = '<font color="#00A2FF">[A]</font> silent aim <font color="#888899">(Always)</font>'
    bindLine.TextColor3 = Color3.fromRGB(220, 225, 235)
    bindLine.Font = Enum.Font.Gotham
    bindLine.TextSize = 10
    bindLine.TextXAlignment = Enum.TextXAlignment.Center
    bindLine.Parent = main
end

local function runUnlockAllCosmetics()
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local ps = LocalPlayer:FindFirstChild("PlayerScripts") or LocalPlayer:WaitForChild("PlayerScripts", 0.5)
        if not ps then return end
        local PlayerDataController = require(ps.Controllers.PlayerDataController)
        local CosmeticLibrary = require(rep.Modules.CosmeticLibrary)
        local ItemLibrary = require(rep.Modules.ItemLibrary)
        local currentData = PlayerDataController.CurrentData

        if currentData and currentData.CosmeticInventory and CosmeticLibrary and CosmeticLibrary.Cosmetics then
            for k in pairs(CosmeticLibrary.Cosmetics) do
                currentData.CosmeticInventory[k] = true
            end
            if currentData.WeaponInventory and ItemLibrary and ItemLibrary.Items then
                for k in pairs(ItemLibrary.Items) do
                    local found = false
                    for _, w in ipairs(currentData.WeaponInventory) do
                        if type(w) == "table" and w.Name == k then found = true break end
                    end
                    if not found then
                        table.insert(currentData.WeaponInventory, { Name = k, Prestige = 0, Level = 100, XP = 0 })
                    end
                end
            end
            if type(currentData.Replicate) == "function" then
                pcall(function() currentData:Replicate("CosmeticInventory") end)
                pcall(function() currentData:Replicate("WeaponInventory") end)
            end
        end

        local uiMod = ps:FindFirstChild("Modules") and ps.Modules:FindFirstChild("UserInterface")
        if uiMod and uiMod:FindFirstChild("Pages") then
            local Pages = require(uiMod.Pages)
            if Pages and Pages.PageSystem then
                pcall(function() Pages.PageSystem:OpenPage("Customize") end)
                pcall(function() Pages.PageSystem:OpenPage("Armory") end)
            end
        end
    end)
end

local CosmeticChangerWindow = nil

local CosmeticChangerWindow = nil
task.spawn(function()
local plrs = game:GetService("Players")
local reps = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local collectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local lp = plrs.LocalPlayer
if not lp then return end

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 2)
if not lps then return end

local ctrls = lps:FindFirstChild("Controllers") or lps:WaitForChild("Controllers", 2)
local rmods = reps:FindFirstChild("Modules") or reps:WaitForChild("Modules", 2)

local function makeDraggable(obj, handle)
    handle = handle or obj
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function safeRequireModule(module)
	if not module then return nil end
	local ok, result = pcall(function() return require(module) end)
	return ok and result or nil
end

-- Resilient background loader: polls up to 30 times (6s total) without blocking
local elib, clib, ilib, consts, dctrl
for _ = 1, 30 do
    pcall(function()
        if not rmods then rmods = reps:FindFirstChild("Modules") end
        if not ctrls and lps then ctrls = lps:FindFirstChild("Controllers") end
        if rmods then
            if not elib then elib = safeRequireModule(rmods:FindFirstChild("EnumLibrary")) end
            if not clib then clib = safeRequireModule(rmods:FindFirstChild("CosmeticLibrary")) end
            if not ilib then ilib = safeRequireModule(rmods:FindFirstChild("ItemLibrary")) end
            if not consts then consts = safeRequireModule(rmods:FindFirstChild("CONSTANTS")) end
        end
        if ctrls and not dctrl then
            dctrl = safeRequireModule(ctrls:FindFirstChild("PlayerDataController"))
        end
    end)
    if elib and clib and ilib and consts and dctrl and clib.Cosmetics then
        break
    end
    task.wait(0.2)
end

if elib and elib.WaitForEnumBuilder then
	pcall(function() elib:WaitForEnumBuilder() end)
end

if not (elib and clib and ilib and consts and dctrl and clib.Cosmetics) then
    warn("[Sleepy Hub] Game modules still replicating, cosmetic changer will retry in background")
    return
end
local coss = clib.Cosmetics

local function findDescendantByName(parent, name)
	if not parent then return nil end
	local direct = parent:FindFirstChild(name)
	if direct then return direct end
	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.Name == name then
			return descendant
		end
	end
	return nil
end

KNIFE_CUSTOM_SKIN = "Knife (Custom Skin)"
REAVER_KNIFE_CUSTOM_SKIN = "reaver"
DAGGERS_CUSTOM_SKIN = "Jett"
SATCHEL_CUSTOM_SKIN = "Raze"
SNIPER_CUSTOM_SKIN = "Chamber"
RPG_CUSTOM_SKIN = "RPG Raze"
FISTS_CUSTOM_SKIN = "Agent"
BOW_CUSTOM_SKIN = "Sova"
ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
DICE_TRIPMINE_SKIN = "Subspace Tripmine (Custom Skin)"
DICE_TRIPMINE_OUTER_MESH_ID = "rbxassetid://5555691474"
DICE_TRIPMINE_INNER_MESH_ID = "rbxassetid://5555691356"
DICE_TRIPMINE_IMAGE_ID = "rbxassetid://98372867049331"
DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
DICE_TRIPMINE_MESH_SCALE = 3.35
DICE_TRIPMINE_WORLD_MESH_SCALE = 3.25
SPIKE_TRIPMINE_SKIN = "Spike"
SPIKE_TRIPMINE_MESH_ID = "rbxassetid://97754746098028"
TRIPMINE_STAR_REMOVE_MESH_ID = "rbxassetid://13792525075"
SPIKE_TRIPMINE_MESH_SCALE = 85
SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50
SNIPER_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://98786413608787"
SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
SNIPER_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.025, 0.025, 0.025)
SNIPER_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0, -0.25, 0)
DAGGERS_CUSTOM_SOURCE_MESH_ID = "rbxassetid://94772705561955"
DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://79246900644201"
DAGGERS_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.03, 0.03, 0.03)
DAGGERS_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, -90)
SATCHEL_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://129982008330139"
SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://121713947189258"
SATCHEL_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.5, 0.5, 0.5)
SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE = Vector3.new(0.6, 0.6, 0.6)
SATCHEL_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, -90, 0)
RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://81554047161707"
RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
RPG_CUSTOM_REPLACEMENT_SCALE = 0.5
RPG_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, 0)
RPG_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0.04, 0, 0)
FISTS_CUSTOM_LEFT_MESH_ID = "rbxassetid://120273083766829"
FISTS_CUSTOM_LEFT_TEXTURE_ID = "rbxassetid://124608382264962"
FISTS_CUSTOM_RIGHT_MESH_ID = "rbxassetid://129220833982000"
FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
FISTS_CUSTOM_MESH_SCALE = Vector3.new(0.1, 0.1, 0.1)
FISTS_CUSTOM_LEFT_ROTATION = Vector3.new(45, 0, 0)
FISTS_CUSTOM_RIGHT_ROTATION = Vector3.new(-45, 0, 0)
BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://80147707463344"
BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID = "rbxassetid://97839236861642"
BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID = "rbxassetid://82458179247269"
BOW_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.25, 0.25, 0.25)

CUSTOM_SKIN_IMAGE_OVERRIDES = {
	[REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["sky"] = { Image = "", ImageHighResolution = "" },
	["Camera"] = { Image = "", ImageHighResolution = "" },
	["Grenade Raze"] = { Image = "", ImageHighResolution = "" },
	[DAGGERS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SATCHEL_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SNIPER_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["Operator"] = { Image = "", ImageHighResolution = "" },
	[RPG_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[FISTS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[BOW_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[ASSAULT_RIFLE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[DICE_TRIPMINE_SKIN] = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
	[SPIKE_TRIPMINE_SKIN] = { Image = "", ImageHighResolution = "" }
}
SNIPER_MESH_SKIN_OVERRIDES = {
	[SNIPER_CUSTOM_SKIN] = {
		Skin = SNIPER_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://95497877882755",
			"rbxassetid://118920880889483",
			"rbxassetid://80662423119419"
		},
		RemoveMeshIds = {
			"rbxassetid://100168191352015",
			"rbxassetid://82935541182957",
			"rbxassetid://95388370230390",
			"rbxassetid://84918196407550"
		},
		ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
		ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
	},
	["Operator"] = {
		Skin = "Operator",
		BodyMeshIds = {
			"rbxassetid://13188893115",
			"rbxassetid://13188892761",
			"rbxassetid://14778413014",
			"rbxassetid://13188893017",
			"rbxassetid://14774727092"
		},
		RemoveMeshIds = {
			"rbxassetid://13188893310",
			"rbxassetid://13188892855"
		},
		BulletMeshIds = {
			"rbxassetid://14002915797"
		},
		MagazineMeshIds = {
			"rbxassetid://13188892532",
			"rbxassetid://13188892651"
		},
		BodyReplacementMeshId = "rbxassetid://132995629661821",
		BodyReplacementTextureId = "rbxassetid://80634410259243",
		ScopeReplacementMeshId = "rbxassetid://103988563532751",
		ScopeReplacementTextureId = "rbxassetid://136789986141252",
		MagazineReplacementMeshId = "rbxassetid://80074307887476",
		MagazineReplacementTextureId = "rbxassetid://80634410259243",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementOffset = Vector3.new(0, -0.25, 0),
		ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
		MagazineOffset = Vector3.new(0.7, 0, 0.05),
		BulletOffset = Vector3.new(-1.25, 0, 0),
		ReplacementVersion = 9
	}
}

DAGGERS_MESH_SKIN_OVERRIDES = {
	[DAGGERS_CUSTOM_SKIN] = {
		Skin = DAGGERS_CUSTOM_SKIN,
		SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
		ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
		ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 6,
		FallbackBodyNames = { "LeftBody", "RightBody" }
	}
}

SATCHEL_MESH_SKIN_OVERRIDES = {
	[SATCHEL_CUSTOM_SKIN] = {
		Skin = SATCHEL_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://138805549853994",
			"rbxassetid://125258747465100",
			"rbxassetid://111319295872696",
			"rbxassetid://129504437671598",
			"rbxassetid://104440368867933"
		},
		ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
		WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
		ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 5
	},
	[REAVER_KNIFE_CUSTOM_SKIN] = {
		Skin = REAVER_KNIFE_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://85166039303292",
			"rbxassetid://125674590013235",
			"rbxassetid://97042702941502",
			"rbxassetid://116723276788898",
			"rbxassetid://99266754879173"
		},
		ReplacementMeshId = "rbxassetid://76054449109492",
		ReplacementTextureId = "rbxassetid://117578984602503",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementRotation = Vector3.new(0, 90, 0),
		ReplacementOffset = Vector3.new(0, 0.5, 0),
		ReplacementVersion = 3
	},
	["sky"] = {
		Skin = "sky",
		SourceMeshIds = { "rbxassetid://140203670599306" },
		ReplacementMeshId = "rbxassetid://78577370691269",
		ReplacementTextureId = "rbxassetid://130284287910497",
		ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
		ReplacementRotation = Vector3.new(0, 90, 0),
		WorldSourceMeshIds = { "rbxassetid://140203670599306" },
		WorldReplacementMeshId = "rbxassetid://111122607123480",
		WorldReplacementTextureId = "rbxassetid://86629139856581",
		WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		WorldReplacementRotation = Vector3.zero,
		ReplacementVersion = 2
	},
	["Grenade Raze"] = {
		Skin = "Grenade Raze",
		SourceMeshIds = {
			"rbxassetid://87132852844264",
			"rbxassetid://96681677373844",
			"rbxassetid://121396126155803",
			"rbxassetid://121842208464560"
		},
		ReplacementMeshId = "rbxassetid://80612596590820",
		ReplacementTextureId = "rbxassetid://123233413518598",
		ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
		ReplacementVersion = 2
	},
	["Camera"] = {
		Skin = "Camera",
		SourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		ReplacementMeshId = "rbxassetid://112849634500139",
		ReplacementTextureId = "rbxassetid://126465878813440",
		ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
		ReplacementRotation = Vector3.new(0, 0, -90),
		WorldSourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		WorldReplacementSize = Vector3.new(2, 2, 2),
		WorldReplacementRotation = Vector3.new(0, 90, -90),
		ReplacementVersion = 2
	}
}

RPG_MESH_SKIN_OVERRIDES = {
	[RPG_CUSTOM_SKIN] = {
		Skin = RPG_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17638908187",
			"rbxassetid://17638908626"
		},
		JuggleMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		RocketMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
		ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
		ReplacementVersion = 3
	}
}

FISTS_MESH_SKIN_OVERRIDES = {
	[FISTS_CUSTOM_SKIN] = {
		Skin = FISTS_CUSTOM_SKIN,
		LeftPartName = "LeftItem",
		RightPartName = "RightItem",
		LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID,
		LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
		RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID,
		RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
		MeshScale = FISTS_CUSTOM_MESH_SCALE,
		LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
		RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
		ReplacementVersion = 1
	}
}
BOW_MESH_SKIN_OVERRIDES = {
	[BOW_CUSTOM_SKIN] = {
		Skin = BOW_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://116947825701555",
			"rbxassetid://80510746199823"
		},
		ArrowMeshIds = {
			"rbxassetid://108027163190911",
			"rbxassetid://114261802270550"
		},
		BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
		ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
		ReplacementVersion = 2
	}
}

ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
	[ASSAULT_RIFLE_CUSTOM_SKIN] = {
		Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17661950733",
			"rbxassetid://17661950585",
			"rbxassetid://17662005180",
			"rbxassetid://17662016762"
		},
		BoltMeshIds = {
			"rbxassetid://17661950452"
		},
		MagazineMeshIds = {
			"rbxassetid://17662005301",
			"rbxassetid://17662005453"
		},
		ReloadMagazineMeshIds = {
			"rbxassetid://17662005453",
			"rbxassetid://17662005301"
		},
		BodyReplacementMeshId = "rbxassetid://138100951261312",
		BodyReplacementTextureId = "rbxassetid://84167100219585",
		MagazineReplacementMeshId = "rbxassetid://92935167277909",
		MagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
		ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
		ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
		MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
		ReplacementVersion = 6
	}
}

TRIPMINE_MESH_SKIN_OVERRIDES = {
	[DICE_TRIPMINE_SKIN] = {
		Skin = DICE_TRIPMINE_SKIN,
		MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = DICE_TRIPMINE_MESH_SCALE,
		WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		ExtraMeshScale = 1.15,
		WorldExtraMeshScale = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Material = Enum.Material.SmoothPlastic,
		Reflectance = 0,
		ClearTexture = true
	},
	[SPIKE_TRIPMINE_SKIN] = {
		Skin = SPIKE_TRIPMINE_SKIN,
		MeshId = SPIKE_TRIPMINE_MESH_ID,
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = SPIKE_TRIPMINE_MESH_SCALE,
		WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		Color = Color3.fromRGB(163, 162, 165),
		ClearTexture = true
	}
}

local function normalizeAssetId(assetId)
	return tostring(assetId or ""):match("%d+") or ""
end
local function getTripmineMeshIds(profile)
	local ids = {}
	if type(profile and profile.MeshIds) == "table" then
		for _, meshId in ipairs(profile.MeshIds) do
			if normalizeAssetId(meshId) ~= "" then
				table.insert(ids, meshId)
			end
		end
	elseif profile and normalizeAssetId(profile.MeshId) ~= "" then
		table.insert(ids, profile.MeshId)
	end
	return ids
end

local function getTripmineExtraMeshScale(profile, worldVisual)
	if worldVisual then
		return profile and profile.WorldExtraMeshScale or 1
	end
	return profile and profile.ExtraMeshScale or 1
end
local function getTripmineMeshSignature(profile, worldVisual)
	local normalized = {}
	for _, meshId in ipairs(getTripmineMeshIds(profile)) do
		table.insert(normalized, normalizeAssetId(meshId))
	end
	return table.concat(normalized, ",") .. "|" .. tostring(getTripmineExtraMeshScale(profile, worldVisual))
end

local function scaleTripmineMeshVector(scale, multiplier)
	multiplier = multiplier or 1
	if typeof(scale) == "Vector3" then
		return scale * multiplier
	end
	return Vector3.new(scale, scale, scale) * multiplier
end

local function meshMatchesAssetId(inst, assetId)
	local id = normalizeAssetId(assetId)
	if id == "" or typeof(inst) ~= "Instance" then return false end
	if inst:IsA("SpecialMesh") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureId) == id
	elseif inst:IsA("MeshPart") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureID) == id
	end
	return false
end

local function isCustomTripmineMeshIgnored(inst)
	local current = inst
	while current do
		if current:GetAttribute("__MeowHiddenTripmineMesh") then
			return true
		end
		local compactName = tostring(current.Name or ""):lower():gsub("[%s_%-%p]", "")
		if compactName:find("arm", 1, true)
			or compactName:find("hand", 1, true)
			or compactName:find("fake", 1, true)
			or compactName:find("charm", 1, true)
			or compactName:find("hitbox", 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function scoreCustomTripmineMeshTarget(root, meshLike, removedMeshId)
	if removedMeshId and meshMatchesAssetId(meshLike, removedMeshId) then return nil end
	local part = meshLike:IsA("SpecialMesh") and meshLike.Parent or meshLike
	if not (part and part:IsA("BasePart")) or isCustomTripmineMeshIgnored(part) then return nil end
	local score = part.Size.Magnitude
	local name = tostring(part.Name or ""):lower()
	if root:IsA("Model") and part == root.PrimaryPart then score += 1000 end
	if name:find("mesh", 1, true) then score += 500 end
	if name:find("body", 1, true) then score += 250 end
	if name:find("mine", 1, true) or name:find("trip", 1, true) then score += 250 end
	return score
end

local function findCustomTripmineMeshTarget(root, profile)
	if typeof(root) ~= "Instance" then return nil end
	local best, bestScore = nil, -math.huge
	local removedMeshId = profile and (profile.RemoveMeshId or profile.HideMeshId)
	local function consider(obj)
		if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
			local score = scoreCustomTripmineMeshTarget(root, obj, removedMeshId)
			if score and score > bestScore then
				best = obj
				bestScore = score
			end
		end
	end
	consider(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		consider(descendant)
	end
	return best
end

local function removeTripmineMeshAsset(root, assetId)
	if typeof(root) ~= "Instance" or not assetId then return end
	local remove = {}
	local function queueIfMatch(obj)
		if meshMatchesAssetId(obj, assetId) then
			local part = obj:IsA("SpecialMesh") and obj.Parent or obj
			if part and part:IsA("BasePart") then
				table.insert(remove, part)
			elseif obj:IsA("SpecialMesh") then
				table.insert(remove, obj)
			end
		end
	end
	queueIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		queueIfMatch(obj)
	end
	for _, obj in ipairs(remove) do
		if obj and obj.Parent then
			obj:SetAttribute("__MeowRemovedTripmineMesh", true)
			obj:Destroy()
		end
	end
end

local function removeCustomTripmineExtraMeshes(root)
	if typeof(root) ~= "Instance" then return end
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:GetAttribute("__MeowCustomTripmineExtraMesh") then
			obj:Destroy()
		end
	end
end

local function getMeshLikePart(obj)
	if typeof(obj) ~= "Instance" then return nil end
	if obj:IsA("SpecialMesh") then
		return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent or nil
	end
	return obj:IsA("BasePart") and obj or nil
end

local function meshMatchesAnyAssetId(inst, assetIds)
	for _, assetId in ipairs(assetIds or {}) do
		if meshMatchesAssetId(inst, assetId) then
			return true
		end
	end
	return false
end

local function rotationCFrameFromDegrees(rotation)
	if typeof(rotation) ~= "Vector3" then return CFrame.identity end
	return CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
end

local function namePathContains(inst, needle)
	needle = tostring(needle or ""):lower()
	if needle == "" then return false end
	local current = inst
	while current and current ~= game do
		if tostring(current.Name or ""):lower():find(needle, 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideDaggerMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowDaggerHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function addReplacementSpecialMesh(part, profile, defaultScale)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = profile.ReplacementMeshId
	pcall(function() mesh.TextureId = profile.ReplacementTextureId or "" end)
	mesh.Scale = profile.ReplacementMeshScale or profile.ReplacementSize or defaultScale or Vector3.new(1, 1, 1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = part
	return mesh
end

local function createDaggerReplacementMeshPart(anchor, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	if anchor:GetAttribute("__MeowDaggerReplacementMeshPart") then return true end

	local parent = anchor.Parent
	if not parent then return false end
	local originalName = anchor.Name
	anchor.Name = "__MeowDaggerAnchor_" .. originalName

	local replacement = Instance.new("Part")
	replacement.Name = originalName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = anchor.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__MeowCustomDaggerMesh", true)
	replacement:SetAttribute("__MeowDaggerReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile)
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__MeowDaggerReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	hideDaggerMeshAnchor(anchor)
	return true
end

local function applyMeshReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__MeowDaggerReplacementMeshPart") or obj:GetAttribute("__MeowDaggerHiddenAnchor") then
		return false
	end
	local part = getMeshLikePart(obj)
	if obj:IsA("MeshPart") then
		return createDaggerReplacementMeshPart(obj, profile)
	elseif obj:IsA("SpecialMesh") then
		if part then
			part.Transparency = 0
			part.LocalTransparencyModifier = 0
			part.Color = Color3.fromRGB(255, 255, 255)
			pcall(function() part.CastShadow = false end)
			if profile.ReplacementRotation then
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end
		end
		pcall(function() obj.MeshId = profile.ReplacementMeshId end)
		pcall(function() obj.TextureId = profile.ReplacementTextureId or "" end)
		if profile.ReplacementSize then
			pcall(function() obj.Scale = profile.ReplacementSize end)
		end
		obj:SetAttribute("__MeowCustomDaggerMesh", true)
		return true
	end
	return false
end

local function getDaggerMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local rotation = profile.ReplacementRotation or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyDaggerMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getDaggerMeshSignature(profile)
	if root:GetAttribute("__MeowDaggerMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowDaggerMeshSignature") == signature then
		return true
	end

	local replaced, seen = 0, {}
	local function replaceIfTarget(obj)
		if seen[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seen[obj] = true
		if applyMeshReplacementToObject(obj, profile) then
			replaced += 1
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	for _, bodyName in ipairs(profile.FallbackBodyNames or {}) do
		for _, obj in ipairs(root:GetDescendants()) do
			if obj.Name == bodyName then
				local target = obj:FindFirstChild("MeshPart")
				if target and not seen[target] and target:IsA("MeshPart") then
					seen[target] = true
					if applyMeshReplacementToObject(target, profile) then
						replaced += 1
					end
				end
			end
		end
	end

	root:SetAttribute("__MeowDaggerMeshSkin", profile.Skin)
	root:SetAttribute("__MeowDaggerMeshSignature", signature)
	root:SetAttribute("__MeowDaggerMeshCount", replaced)
	return replaced > 0
end

local function hideSatchelMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowSatchelHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function getReplacementAverageCFrame(parts)
	local first = parts and parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

local function createSatchelReplacementMeshPart(root, profile, anchors)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__MeowSatchelReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = "__MeowCustomSatchelReplacement"
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
		* CFrame.new(profile.ReplacementOffset or Vector3.zero)
		* rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__MeowCustomSatchelMesh", true)
	replacement:SetAttribute("__MeowSatchelReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile, Vector3.new(1, 1, 1))
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__MeowSatchelReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	for _, part in ipairs(anchors) do
		if part and part.Parent then
			if not part.Name:find("__MeowSatchelAnchor_", 1, true) then
				part.Name = "__MeowSatchelAnchor_" .. part.Name
			end
			hideSatchelMeshAnchor(part)
		end
	end
	return true
end

local function applySatchelReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__MeowSatchelReplacementMeshPart") then return false end
	local part = getMeshLikePart(obj)
	if part and part:GetAttribute("__MeowSatchelHiddenAnchor") then return false end
	return part and createSatchelReplacementMeshPart(part.Parent or part, profile, { part }) or false
end

local function getSatchelMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applySatchelMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSatchelMeshSignature(profile)
	if root:GetAttribute("__MeowSatchelMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowSatchelMeshSignature") == signature then
		return true
	end

	local bodyParts, seenObjects, seenParts = {}, {}, {}
	local function replaceIfTarget(obj)
		if seenObjects[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seenObjects[obj] = true
		local part = getMeshLikePart(obj)
		if part and not seenParts[part] then
			seenParts[part] = true
			table.insert(bodyParts, part)
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	local replaced = createSatchelReplacementMeshPart(root, profile, bodyParts) and 1 or 0

	root:SetAttribute("__MeowSatchelMeshSkin", profile.Skin)
	root:SetAttribute("__MeowSatchelMeshSignature", signature)
	root:SetAttribute("__MeowSatchelMeshCount", replaced)
	return replaced > 0
end
local function getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	local profile = SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile and worldAsset and (
		profile.WorldSourceMeshIds
		or profile.WorldReplacementMeshId
		or profile.WorldReplacementTextureId
		or profile.WorldReplacementSize
		or profile.WorldReplacementRotation
		or profile.WorldReplacementOffset
	) then
		local worldProfile = table.clone(profile)
		worldProfile.SourceMeshIds = profile.WorldSourceMeshIds or profile.SourceMeshIds
		worldProfile.ReplacementMeshId = profile.WorldReplacementMeshId or profile.ReplacementMeshId
		worldProfile.ReplacementTextureId = profile.WorldReplacementTextureId or profile.ReplacementTextureId
		worldProfile.ReplacementSize = profile.WorldReplacementSize or profile.ReplacementSize
		worldProfile.ReplacementRotation = profile.WorldReplacementRotation or profile.ReplacementRotation
		worldProfile.ReplacementOffset = profile.WorldReplacementOffset or profile.ReplacementOffset
		return worldProfile
	end
	return profile
end

local function hideRpgMeshPart(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__MeowRpgHiddenPart") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowRpgHiddenPart", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function applyRpgMeshReplacement(obj, meshId, textureId, profile)
	local part = getMeshLikePart(obj)
	if not part or part:GetAttribute("__MeowRpgHiddenPart") then return false end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__MeowCustomRpgMesh", true)
	part:SetAttribute("IgnoreTransparency", true)
	if not part:GetAttribute("__MeowRpgReplacementAdjusted") then
		local scale = tonumber(profile and profile.ReplacementScale) or 1
		if scale ~= 1 then
			pcall(function()
				part.Size = part.Size * scale
			end)
		end
		if profile and profile.ReplacementOffset then
			pcall(function()
				part.CFrame = part.CFrame * CFrame.new(profile.ReplacementOffset)
			end)
		end
		if profile and profile.ReplacementRotation then
			pcall(function()
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end)
		end
		part:SetAttribute("__MeowRpgReplacementAdjusted", true)
	end
	if obj:IsA("MeshPart") then
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureID = textureId or "" end)
		return true
	elseif obj:IsA("SpecialMesh") then
		pcall(function() obj.MeshType = Enum.MeshType.FileMesh end)
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureId = textureId or "" end)
		pcall(function() obj.VertexColor = Vector3.new(1, 1, 1) end)
		return true
	end
	return false
end

local function getRpgMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.JuggleMeshIds or {}, ","),
		table.concat(profile.RocketMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ReplacementScale or 1),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyRpgMeshProfile(root, profile, options)
	if typeof(root) ~= "Instance" or not profile then return false end
	options = options or {}
	local signature = getRpgMeshSignature(profile)
	if root:GetAttribute("__MeowRpgMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowRpgMeshSignature") == signature
		and root:GetAttribute("__MeowRpgRocketVisible") == false then
		return true
	end

	local changed, removed, seen = 0, 0, {}
	local function applyIfTarget(obj)
		if seen[obj] then return end
		if not (meshMatchesAnyAssetId(obj, profile.BodyMeshIds)
			or meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)
			or meshMatchesAnyAssetId(obj, profile.RocketMeshIds)) then
			return
		end
		seen[obj] = true
		local part = getMeshLikePart(obj)
		if not part then return end
		if (namePathContains(obj, "rocket") and meshMatchesAnyAssetId(obj, profile.RocketMeshIds))
			or (namePathContains(obj, "juggle") and meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)) then
			if hideRpgMeshPart(part) then removed += 1 end
		elseif meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			if applyRpgMeshReplacement(obj, profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
				changed += 1
			end
		end
	end

	applyIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		applyIfTarget(obj)
	end

	root:SetAttribute("__MeowRpgMeshSkin", profile.Skin)
	root:SetAttribute("__MeowRpgMeshSignature", signature)
	root:SetAttribute("__MeowRpgRocketVisible", false)
	root:SetAttribute("__MeowRpgMeshCount", changed)
	root:SetAttribute("__MeowRpgHiddenCount", removed)
	return changed > 0 or removed > 0
end

local function createFistsReplacementPart(part, meshId, textureId, meshScale, rotation)
	if not (part and part:IsA("BasePart")) then return false end
	for _, child in ipairs(part:GetChildren()) do
		child:Destroy()
	end

	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__MeowFistsHiddenAnchor", true)
	part:SetAttribute("IgnoreTransparency", true)

	local replacement = Instance.new("Part")
	replacement.Name = "__MeowCustomFistsMesh"
	replacement.Size = part.Size
	replacement.CFrame = part.CFrame * rotationCFrameFromDegrees(rotation)
	replacement.Anchored = false
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__MeowCustomFistsMesh", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	replacement.Parent = part

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = meshScale or Vector3.new(0.1, 0.1, 0.1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__MeowCustomFistsMeshWeld"
	weld.Part0 = part
	weld.Part1 = replacement
	weld.Parent = replacement
	return true
end

local function getFistsMeshSignature(profile)
	local scale = profile.MeshScale or Vector3.zero
	local leftRotation = profile.LeftRotation or Vector3.zero
	local rightRotation = profile.RightRotation or Vector3.zero
	return table.concat({
		tostring(profile.LeftMeshId or ""),
		tostring(profile.LeftTextureId or ""),
		tostring(profile.RightMeshId or ""),
		tostring(profile.RightTextureId or ""),
		tostring(scale.X),
		tostring(scale.Y),
		tostring(scale.Z),
		tostring(leftRotation.X),
		tostring(leftRotation.Y),
		tostring(leftRotation.Z),
		tostring(rightRotation.X),
		tostring(rightRotation.Y),
		tostring(rightRotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyFistsMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getFistsMeshSignature(profile)
	if root:GetAttribute("__MeowFistsMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowFistsMeshSignature") == signature
		and (root:GetAttribute("__MeowFistsMeshCount") or 0) > 0 then
		return true
	end

	local left = findDescendantByName(root, profile.LeftPartName or "LeftItem")
	local right = findDescendantByName(root, profile.RightPartName or "RightItem")
	local applied = 0
	if createFistsReplacementPart(left, profile.LeftMeshId, profile.LeftTextureId, profile.MeshScale, profile.LeftRotation) then
		applied += 1
	end
	if createFistsReplacementPart(right, profile.RightMeshId, profile.RightTextureId, profile.MeshScale, profile.RightRotation) then
		applied += 1
	end

	root:SetAttribute("__MeowFistsMeshSkin", profile.Skin)
	root:SetAttribute("__MeowFistsMeshSignature", signature)
	root:SetAttribute("__MeowFistsMeshCount", applied)
	return applied > 0
end

local function hideBowMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__MeowBowHiddenAnchor") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowBowHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createBowReplacementMeshPart(root, anchors, replacementName, meshId, textureId, profile)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__MeowBowReplacementMeshPart") and descendant.Name == replacementName then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = replacementName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__MeowCustomBowMesh", true)
	replacement:SetAttribute("__MeowBowReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = profile.ReplacementSize or Vector3.new(0.5, 0.5, 0.5)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__MeowBowReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	for _, part in ipairs(anchors) do
		hideBowMeshAnchor(part)
	end
	return true
end

local function getBowMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.ArrowMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ArrowReplacementMeshId or ""),
		tostring(profile.ArrowReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyBowMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getBowMeshSignature(profile)
	if root:GetAttribute("__MeowBowMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowBowMeshSignature") == signature
		and (root:GetAttribute("__MeowBowMeshCount") or 0) > 0 then
		return true
	end

	local bodyParts, arrowParts, seenParts = {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		if meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif meshMatchesAnyAssetId(obj, profile.ArrowMeshIds) then
			seenParts[part] = true
			table.insert(arrowParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end
	local applied = 0
	if createBowReplacementMeshPart(root, bodyParts, "__MeowCustomBowBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
		applied += 1
	end
	if createBowReplacementMeshPart(root, arrowParts, "__MeowCustomBowArrow", profile.ArrowReplacementMeshId, profile.ArrowReplacementTextureId, profile) then
		applied += 1
	end

	root:SetAttribute("__MeowBowMeshSkin", profile.Skin)
	root:SetAttribute("__MeowBowMeshSignature", signature)
	root:SetAttribute("__MeowBowMeshCount", applied)
	return applied > 0
end

local function hideAssaultRifleMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowAssaultRifleHiddenAnchor", true)
	part:SetAttribute("__MeowAssaultRifleAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createAssaultRifleReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	replacement.Size = profile.ReplacementSize or Vector3.new(0.35, 0.35, 0.35)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__MeowCustomAssaultRifleMesh", true)
	replacement:SetAttribute("__MeowAssaultRifleReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__MeowAssaultRifleReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	return true
end

local function getAssaultRifleMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.BoltMeshIds or {}, ","),
		table.concat(profile.MagazineMeshIds or {}, ","),
		table.concat(profile.ReloadMagazineMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(profile.ReloadMagazineReplacementMeshId or ""),
		tostring(profile.ReloadMagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(replacementOffset.X),
		tostring(replacementOffset.Y),
		tostring(replacementOffset.Z),
		tostring(magazineOffset.X),
		tostring(magazineOffset.Y),
		tostring(magazineOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyAssaultRifleMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getAssaultRifleMeshSignature(profile)
	if root:GetAttribute("__MeowAssaultRifleMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowAssaultRifleMeshSignature") == signature
		and (root:GetAttribute("__MeowAssaultRifleMeshCount") or 0) > 0 then
		return true
	end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__MeowAssaultRifleReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, reloadMagazineParts, boltParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__MeowAssaultRifleAnchorType")
		local isReloadMagazine = previousType == "ReloadMagazine"
			or (meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) and namePathContains(obj, "reload"))
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif isReloadMagazine then
			seenParts[part] = true
			table.insert(reloadMagazineParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) or meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bolt" or meshMatchesAnyAssetId(obj, profile.BoltMeshIds) then
			seenParts[part] = true
			table.insert(boltParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1] or boltParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	local reloadMagazineAnchor = reloadMagazineParts[1] or magazineAnchor
	local bodyCFrame = bodyParts[1] and getReplacementAverageCFrame(bodyParts) or (bodyAnchor and bodyAnchor.CFrame) or CFrame.identity
	local reloadMagazineCFrame = reloadMagazineParts[1] and getReplacementAverageCFrame(reloadMagazineParts) or bodyCFrame
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	bodyCFrame = bodyCFrame * CFrame.new(replacementOffset)
	reloadMagazineCFrame = reloadMagazineCFrame * CFrame.new(replacementOffset)
	local applied = 0
	if createAssaultRifleReplacementMeshPart(root, bodyAnchor, "__MeowCustomAssaultRifleBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if createAssaultRifleReplacementMeshPart(root, magazineAnchor, "__MeowCustomAssaultRifleMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, bodyCFrame * CFrame.new(magazineOffset), profile) then
		applied += 1
	end
	if reloadMagazineParts[1] and createAssaultRifleReplacementMeshPart(root, reloadMagazineAnchor, "__MeowCustomAssaultRifleReloadMagazine", profile.ReloadMagazineReplacementMeshId or profile.MagazineReplacementMeshId, profile.ReloadMagazineReplacementTextureId or profile.MagazineReplacementTextureId, reloadMagazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		hideAssaultRifleMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		hideAssaultRifleMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(reloadMagazineParts) do
		hideAssaultRifleMeshAnchor(part, "ReloadMagazine")
	end
	for _, part in ipairs(boltParts) do
		hideAssaultRifleMeshAnchor(part, "Bolt")
	end

	root:SetAttribute("__MeowAssaultRifleMeshSkin", profile.Skin)
	root:SetAttribute("__MeowAssaultRifleMeshSignature", signature)
	root:SetAttribute("__MeowAssaultRifleMeshCount", applied)
	return applied > 0
end

function __MeowHideSniperMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Material = Enum.Material.SmoothPlastic end)
	pcall(function() part.Reflectance = 0 end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__MeowHiddenSniperMesh", true)
	part:SetAttribute("__MeowCustomSniperHiddenPart", true)
	part:SetAttribute("__MeowSniperAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

function __MeowOffsetSniperVisibleAnchor(part, anchorType, offset)
	if not (part and part:IsA("BasePart")) then return false end
	local originalCFrame = part:GetAttribute("__MeowSniperOriginalCFrame")
	if typeof(originalCFrame) ~= "CFrame" then
		originalCFrame = part.CFrame
		part:SetAttribute("__MeowSniperOriginalCFrame", originalCFrame)
	end
	part.CFrame = originalCFrame * CFrame.new(offset or Vector3.zero)
	part:SetAttribute("__MeowSniperAnchorType", anchorType or "Part")
	part:SetAttribute("__MeowSniperVisibleOffset", true)
	return true
end

local function hideSniperMeshId(root, assetId)
	local parts = {}
	if typeof(root) ~= "Instance" or not assetId then return parts end
	local seen = {}

	local function hideIfMatch(obj)
		if not meshMatchesAssetId(obj, assetId) then return end
		local part = getMeshLikePart(obj)
		if part and not seen[part] then
			seen[part] = true
			if __MeowHideSniperMeshAnchor(part) then
				table.insert(parts, part)
			end
		elseif obj:IsA("SpecialMesh") then
			obj.Scale = Vector3.zero
		end
	end

	hideIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		hideIfMatch(obj)
	end
	return parts
end

local function getAverageCFrame(parts)
	local first = parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

function __MeowCreateSniperReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	replacement.Size = profile.ReplacementSize or Vector3.new(0.05, 0.05, 0.05)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__MeowCustomSniperReplacement", true)
	replacement:SetAttribute("WrapGroup", 1)
	replacement:SetAttribute("IgnoreTransparency", true)
	pcall(function() replacement:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(replacement, "Wrappable") end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__MeowCustomSniperReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end
	return true
end

local function setupSniperReplacementPart(root, profile, bodyParts)
	local anchor = bodyParts[1]
	if not anchor then return false end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__MeowCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	return __MeowCreateSniperReplacementMeshPart(
		root,
		anchor,
		"__MeowCustomSniperReplacement",
		profile.ReplacementMeshId,
		profile.ReplacementTextureId,
		getAverageCFrame(bodyParts) * CFrame.new(profile.ReplacementOffset or Vector3.zero),
		profile
	)
end

local function getSniperMeshSignature(profile)
	local body = table.concat(profile.BodyMeshIds or {}, ",")
	local remove = table.concat(profile.RemoveMeshIds or {}, ",")
	local magazine = table.concat(profile.MagazineMeshIds or {}, ",")
	local bullet = table.concat(profile.BulletMeshIds or {}, ",")
	local size = profile.ReplacementSize or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local bulletOffset = profile.BulletOffset or Vector3.zero
	return table.concat({
		body,
		remove,
		magazine,
		bullet,
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ScopeReplacementMeshId or ""),
		tostring(profile.ScopeReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring((profile.ScopeOffset or Vector3.zero).X),
		tostring((profile.ScopeOffset or Vector3.zero).Y),
		tostring((profile.ScopeOffset or Vector3.zero).Z),
		tostring((profile.MagazineOffset or Vector3.zero).X),
		tostring((profile.MagazineOffset or Vector3.zero).Y),
		tostring((profile.MagazineOffset or Vector3.zero).Z),
		tostring(bulletOffset.X),
		tostring(bulletOffset.Y),
		tostring(bulletOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

function __MeowApplySniperMultiMeshProfile(root, profile)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__MeowCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, bulletParts, removeParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__MeowSniperAnchorType")
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bullet" or meshMatchesAnyAssetId(obj, profile.BulletMeshIds) then
			seenParts[part] = true
			table.insert(bulletParts, part)
		elseif previousType == "Remove" or meshMatchesAnyAssetId(obj, profile.RemoveMeshIds) then
			seenParts[part] = true
			table.insert(removeParts, part)
		end
	end
	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	if not bodyAnchor then return false end

	local offset = profile.ReplacementOffset or Vector3.zero
	local bodyCFrame = (bodyParts[1] and getReplacementAverageCFrame(bodyParts) or bodyAnchor.CFrame) * CFrame.new(offset)
	local scopeCFrame = bodyCFrame * CFrame.new(profile.ScopeOffset or Vector3.zero)
	local magazineCFrame = bodyCFrame * CFrame.new(profile.MagazineOffset or Vector3.zero)
	local applied = 0
	if __MeowCreateSniperReplacementMeshPart(root, bodyAnchor, "__MeowCustomSniperReplacement", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if __MeowCreateSniperReplacementMeshPart(root, bodyAnchor, "__MeowCustomSniperScope", profile.ScopeReplacementMeshId, profile.ScopeReplacementTextureId, scopeCFrame, profile) then
		applied += 1
	end
	if __MeowCreateSniperReplacementMeshPart(root, magazineAnchor, "__MeowCustomSniperMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, magazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		__MeowHideSniperMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		__MeowHideSniperMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(bulletParts) do
		__MeowOffsetSniperVisibleAnchor(part, "Bullet", profile.BulletOffset or Vector3.zero)
	end
	for _, part in ipairs(removeParts) do
		__MeowHideSniperMeshAnchor(part, "Remove")
	end
	return applied > 0
end

local function applySniperMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSniperMeshSignature(profile)
	if root:GetAttribute("__MeowSniperMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowSniperMeshSignature") == signature then
		return true
	end

	local applied
	if profile.BodyReplacementMeshId or profile.ScopeReplacementMeshId or profile.MagazineReplacementMeshId then
		applied = __MeowApplySniperMultiMeshProfile(root, profile)
		if not applied then return false end
		root:SetAttribute("__MeowSniperMeshSkin", profile.Skin)
		root:SetAttribute("__MeowSniperMeshSignature", signature)
		return true
	end

	local bodyParts = {}
	for _, meshId in ipairs(profile.BodyMeshIds or {}) do
		for _, part in ipairs(hideSniperMeshId(root, meshId)) do
			table.insert(bodyParts, part)
		end
	end
	for _, meshId in ipairs(profile.RemoveMeshIds or {}) do
		hideSniperMeshId(root, meshId)
	end

	if not setupSniperReplacementPart(root, profile, bodyParts) then
		return false
	end
	root:SetAttribute("__MeowSniperMeshSkin", profile.Skin)
	root:SetAttribute("__MeowSniperMeshSignature", signature)
	return true
end

local function applyTripminePartVisual(part, profile)
	if not (part and part:IsA("BasePart")) then return end
	local color = profile.Color
	if color then
		part.Color = color
		part.BrickColor = BrickColor.new(color)
	end
	part.Material = profile.Material or Enum.Material.SmoothPlastic
	if profile.Reflectance then
		part.Reflectance = profile.Reflectance
	end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	if part:GetAttribute("WrapGroup") == nil then
		part:SetAttribute("WrapGroup", 1)
	end
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(part, "Wrappable") end)
end

local function addTripmineExtraMeshPart(basePart, meshId, meshScale, profile, index)
	if not (basePart and basePart:IsA("BasePart") and basePart.Parent) then return nil end
	local overlay = Instance.new("Part")
	overlay.Name = "__MeowCustomTripmineMeshExtra" .. tostring(index or "")
	overlay.Anchored = basePart.Anchored
	overlay.CFrame = basePart.CFrame
	overlay.Size = basePart.Size
	overlay:SetAttribute("__MeowCustomTripmineMeshPart", true)
	overlay:SetAttribute("__MeowCustomTripmineExtraMesh", true)
	applyTripminePartVisual(overlay, profile)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	if profile.ClearTexture then
		pcall(function() mesh.TextureId = "" end)
	elseif profile.TextureId then
		pcall(function() mesh.TextureId = profile.TextureId end)
	end
	mesh.Scale = meshScale
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = overlay
	overlay.Parent = basePart.Parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__MeowCustomTripmineMeshExtraWeld"
	weld.Part0 = basePart
	weld.Part1 = overlay
	weld.Parent = overlay
	return overlay
end

local function applyTripmineMeshProfile(root, profile, worldVisual)
	if typeof(root) ~= "Instance" then return false end
	if not profile then return false end
	local meshIds = getTripmineMeshIds(profile)
	if #meshIds == 0 then return false end
	local extraMeshScale = getTripmineExtraMeshScale(profile, worldVisual)
	local meshSignature = getTripmineMeshSignature(profile, worldVisual)
	local meshScale = (worldVisual and profile.WorldScale) or profile.Scale or 1
	if root:GetAttribute("__MeowTripmineMeshSkin") == profile.Skin
		and root:GetAttribute("__MeowCustomTripmineMeshIds") == meshSignature
		and root:GetAttribute("__MeowCustomTripmineMeshScale") == meshScale then
		return true
	end
	removeCustomTripmineExtraMeshes(root)
	removeTripmineMeshAsset(root, profile.RemoveMeshId or profile.HideMeshId)
	local target = findCustomTripmineMeshTarget(root, profile)
	if not target then return false end
	local customPart

	if target:IsA("SpecialMesh") then
		pcall(function() target.MeshType = Enum.MeshType.FileMesh end)
		target.MeshId = meshIds[1]
		if profile.TextureId then
			pcall(function() target.TextureId = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureId = "" end)
		end
		target.Scale = target.Scale * meshScale
		pcall(function() target.VertexColor = Vector3.new(1, 1, 1) end)
		customPart = target.Parent
		applyTripminePartVisual(customPart, profile)
		for index = 2, #meshIds do
			addTripmineExtraMeshPart(customPart, meshIds[index], scaleTripmineMeshVector(target.Scale, extraMeshScale), profile, index)
		end
	elseif target:IsA("MeshPart") then
		local originalSize = target.Size
		local okMesh = pcall(function()
			target.MeshId = meshIds[1]
		end)
		if profile.TextureId then
			pcall(function() target.TextureID = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureID = "" end)
		end
		applyTripminePartVisual(target, profile)
		if okMesh then
			pcall(function()
				target.Size = originalSize * meshScale
			end)
			customPart = target
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(target, meshIds[index], scaleTripmineMeshVector(Vector3.new(1, 1, 1), extraMeshScale), profile, index)
			end
		elseif target.Parent then
			pcall(function()
				target.Transparency = 1
				target.LocalTransparencyModifier = 1
			end)
			local overlay = target.Parent:FindFirstChild("__MeowCustomTripmineMesh")
			if not (overlay and overlay:IsA("BasePart")) then
				overlay = Instance.new("Part")
				overlay.Name = "__MeowCustomTripmineMesh"
				overlay.Anchored = target.Anchored
				overlay.CanCollide = false
				overlay.CanTouch = false
				overlay.CanQuery = false
				overlay.Massless = true
				overlay.Parent = target.Parent
			end
			overlay.Size = originalSize
			overlay.CFrame = target.CFrame
			applyTripminePartVisual(overlay, profile)
			local mesh = overlay:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = meshIds[1]
			if profile.TextureId then
				pcall(function() mesh.TextureId = profile.TextureId end)
			elseif profile.ClearTexture then
				pcall(function() mesh.TextureId = "" end)
			end
			mesh.Scale = Vector3.new(meshScale, meshScale, meshScale)
			pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
			mesh.Parent = overlay
			overlay:SetAttribute("__MeowCustomTripmineMeshPart", true)
			customPart = overlay
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(overlay, meshIds[index], scaleTripmineMeshVector(meshScale, extraMeshScale), profile, index)
			end
			if not overlay:FindFirstChild("__MeowCustomTripmineMeshWeld") then
				local weld = Instance.new("WeldConstraint")
				weld.Name = "__MeowCustomTripmineMeshWeld"
				weld.Part0 = target
				weld.Part1 = overlay
				weld.Parent = overlay
			end
		end
	end

	if customPart and customPart:IsA("BasePart") then
		customPart:SetAttribute("__MeowCustomTripmineMeshPart", true)
	end
	root:SetAttribute("__MeowTripmineMeshSkin", profile.Skin)
	root:SetAttribute("__MeowCustomTripmineMeshId", meshIds[1])
	root:SetAttribute("__MeowCustomTripmineMeshIds", meshSignature)
	root:SetAttribute("__MeowCustomTripmineMeshScale", meshScale)
	return true
end

local function applyVirtualViewModelAssetOverrides(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		applyTripmineMeshProfile(asset, profile)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		applyDaggerMeshProfile(asset, daggerProfile)
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		applySatchelMeshProfile(asset, satchelProfile)
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		applyRpgMeshProfile(asset, rpgProfile)
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		applyFistsMeshProfile(asset, fistsProfile)
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		applyBowMeshProfile(asset, bowProfile)
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		applyAssaultRifleMeshProfile(asset, assaultRifleProfile)
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		applySniperMeshProfile(asset, sniperProfile)
	end
end

local function shouldRebuildVirtualViewModelAsset(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		local meshIds = getTripmineMeshIds(profile)
		return not asset
			or asset:GetAttribute("__MeowTripmineMeshSkin") ~= profile.Skin
			or asset:GetAttribute("__MeowCustomTripmineMeshIds") ~= getTripmineMeshSignature(profile)
			or asset:GetAttribute("__MeowCustomTripmineMeshScale") ~= (profile.Scale or 1)
			or asset:GetAttribute("__MeowCustomTripmineMeshId") ~= meshIds[1]
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		return not asset
			or asset:GetAttribute("__MeowSniperMeshSkin") ~= sniperProfile.Skin
			or asset:GetAttribute("__MeowSniperMeshSignature") ~= getSniperMeshSignature(sniperProfile)
			or not asset:FindFirstChild("__MeowCustomSniperReplacement", true)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		return not asset
			or asset:GetAttribute("__MeowDaggerMeshSkin") ~= daggerProfile.Skin
			or asset:GetAttribute("__MeowDaggerMeshSignature") ~= getDaggerMeshSignature(daggerProfile)
			or (asset:GetAttribute("__MeowDaggerMeshCount") or 0) <= 0
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		return not asset
			or asset:GetAttribute("__MeowSatchelMeshSkin") ~= satchelProfile.Skin
			or asset:GetAttribute("__MeowSatchelMeshSignature") ~= getSatchelMeshSignature(satchelProfile)
			or (asset:GetAttribute("__MeowSatchelMeshCount") or 0) <= 0
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		return not asset
			or asset:GetAttribute("__MeowRpgMeshSkin") ~= rpgProfile.Skin
			or asset:GetAttribute("__MeowRpgMeshSignature") ~= getRpgMeshSignature(rpgProfile)
			or asset:GetAttribute("__MeowRpgRocketVisible") ~= false
			or ((asset:GetAttribute("__MeowRpgMeshCount") or 0) + (asset:GetAttribute("__MeowRpgHiddenCount") or 0)) <= 0
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		return not asset
			or asset:GetAttribute("__MeowFistsMeshSkin") ~= fistsProfile.Skin
			or asset:GetAttribute("__MeowFistsMeshSignature") ~= getFistsMeshSignature(fistsProfile)
			or (asset:GetAttribute("__MeowFistsMeshCount") or 0) <= 0
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		return not asset
			or asset:GetAttribute("__MeowBowMeshSkin") ~= bowProfile.Skin
			or asset:GetAttribute("__MeowBowMeshSignature") ~= getBowMeshSignature(bowProfile)
			or (asset:GetAttribute("__MeowBowMeshCount") or 0) <= 0
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		return not asset
			or asset:GetAttribute("__MeowAssaultRifleMeshSkin") ~= assaultRifleProfile.Skin
			or asset:GetAttribute("__MeowAssaultRifleMeshSignature") ~= getAssaultRifleMeshSignature(assaultRifleProfile)
			or (asset:GetAttribute("__MeowAssaultRifleMeshCount") or 0) <= 0
	end
	return cosmeticName == DICE_TRIPMINE_SKIN
		and asset
		and asset:GetAttribute("__MeowRightArmRetargeted")
end

local function ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	local sourceInfo = ilib.ViewModels and ilib.ViewModels[viewModelName]
	if not sourceInfo then return nil end

	if cosmeticName ~= viewModelName then
		local usesSourceAnimations = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName] or DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName] or SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName] or RPG_MESH_SKIN_OVERRIDES[cosmeticName] or FISTS_MESH_SKIN_OVERRIDES[cosmeticName] or BOW_MESH_SKIN_OVERRIDES[cosmeticName] or ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName] or cosmeticName == KNIFE_CUSTOM_SKIN or cosmeticName == "Grenade (Custom Skin)" or cosmeticName == "Molotov (Custom Skin)" or cosmeticName == "Satchel (Custom Skin)" or cosmeticName == "Smoke Grenade (Custom Skin)" or cosmeticName == "Warpstone (Custom Skin)" or cosmeticName == "sky"
		local animationInfo = usesSourceAnimations and sourceInfo or ilib.ViewModels[itemName]
		local baseInfo = animationInfo or sourceInfo
		local virtualInfo = table.clone(sourceInfo)
		if type(baseInfo.Animations) == "table" then
			virtualInfo.Animations = table.clone(baseInfo.Animations)
		end
		ilib.ViewModels[cosmeticName] = virtualInfo

		pcall(function()
			local viewModelAssets = lps.Assets and lps.Assets:FindFirstChild("ViewModels")
			if not viewModelAssets then return end
			local existingAsset = findDescendantByName(viewModelAssets, cosmeticName)
			if existingAsset then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingAsset, false) then
					existingAsset:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingAsset, false)
					return
				end
			end

			local sourceAsset = findDescendantByName(viewModelAssets, viewModelName)
			if sourceAsset then
				local clonedAsset = sourceAsset:Clone()
				clonedAsset.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedAsset, false)
				clonedAsset.Parent = viewModelAssets
			end
		end)

		pcall(function()
			local throwables = lps.Assets and lps.Assets:FindFirstChild("Throwables")
			if not throwables then return end
			local existingThrowable = throwables:FindFirstChild(cosmeticName)
			if existingThrowable then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingThrowable, true) then
					existingThrowable:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingThrowable, true)
					return
				end
			end
			local sourceThrowable = findDescendantByName(throwables, viewModelName)
			if sourceThrowable then
				local clonedThrowable = sourceThrowable:Clone()
				clonedThrowable.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedThrowable, true)
				clonedThrowable.Parent = throwables
			end
		end)

		pcall(function()
			if itemName ~= "Jump Pad" then return end
			local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
			local jumpPads = misc and misc:FindFirstChild("JumpPads")
			if not jumpPads then return end
			local existingJumpPad = jumpPads:FindFirstChild(cosmeticName)
			if existingJumpPad then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingJumpPad, true) then
					existingJumpPad:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingJumpPad, true)
					return
				end
			end
			local sourceJumpPad = jumpPads:FindFirstChild(viewModelName) or jumpPads:FindFirstChild("Default")
			if sourceJumpPad then
				local clonedJumpPad = sourceJumpPad:Clone()
				clonedJumpPad.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedJumpPad, true)
				clonedJumpPad.Parent = jumpPads
			end
		end)
	end
	return sourceInfo
end

local function registerVirtualWeaponSkin(cosmeticName, itemName, viewModelName, rarity, displayName, worldViewModelName)
	local viewModelInfo = ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	if not viewModelInfo then return end
	local imageInfo = cosmeticName == DICE_TRIPMINE_SKIN and ilib.ViewModels and ilib.ViewModels["RNG Dice"] or viewModelInfo
	local image = imageInfo.Image or ""
	local imageHighResolution = imageInfo.ImageHighResolution or imageInfo.Image or ""
	local imageOverride = CUSTOM_SKIN_IMAGE_OVERRIDES[cosmeticName]
	if imageOverride then
		image = imageOverride.Image or ""
		imageHighResolution = imageOverride.ImageHighResolution or imageOverride.Image or ""
	end

	if ilib.ViewModels and ilib.ViewModels[cosmeticName] then
		ilib.ViewModels[cosmeticName].Image = image
		ilib.ViewModels[cosmeticName].ImageHighResolution = imageHighResolution
	end

	coss[cosmeticName] = {
		Rarity = rarity or "Contraband",
		Type = "Skin",
		DisplayName = displayName or cosmeticName,
		ViewModelName = cosmeticName,
		SourceViewModelName = viewModelName,
		WorldViewModelName = worldViewModelName or viewModelName,
		Image = image,
		ImageHighResolution = imageHighResolution,
		ImageScale = 3,
		ItemName = itemName,
		Owned = true,
		Unlocked = true,
		Locked = false
	}
end

local function registerVirtualWeaponSkins()
	coss["Flashbang (Custom Skin)"] = nil
	if ilib.ViewModels then
		ilib.ViewModels["Flashbang (Custom Skin)"] = nil
	end
	registerVirtualWeaponSkin(KNIFE_CUSTOM_SKIN, "Knife", "Glast Shard", "Contraband")
	registerVirtualWeaponSkin(REAVER_KNIFE_CUSTOM_SKIN, "Knife", "Pencil", "Contraband", "reaver")
	registerVirtualWeaponSkin(DAGGERS_CUSTOM_SKIN, "Daggers", "Keynais", "Contraband")
	registerVirtualWeaponSkin("Grenade (Custom Skin)", "Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Grenade Raze", "Grenade", "Glorious Grenade", "Contraband", "Raze")
	registerVirtualWeaponSkin("sky", "Flashbang", "Shining Star", "Contraband")
	registerVirtualWeaponSkin("Molotov (Custom Skin)", "Molotov", "Elixir", "Contraband", "Elixir")
	registerVirtualWeaponSkin("Satchel (Custom Skin)", "Satchel", "Elixir", "Contraband")
	registerVirtualWeaponSkin(SATCHEL_CUSTOM_SKIN, "Satchel", "Satchel", "Contraband", "Raze", SATCHEL_CUSTOM_SKIN)
	registerVirtualWeaponSkin("Smoke Grenade (Custom Skin)", "Smoke Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Warpstone (Custom Skin)", "Warpstone", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Scythe (Custom Skin)", "Scythe", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Katana (Custom Skin)", "Katana", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Spear (Custom Skin)", "Spear", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Handgun (Custom Skin)", "Handgun", "Glass Cannon", "Contraband")
	registerVirtualWeaponSkin(SNIPER_CUSTOM_SKIN, "Sniper", "Keyper", "Contraband")
	registerVirtualWeaponSkin("Operator", "Sniper", "Sniper", "Contraband")
	registerVirtualWeaponSkin("Medkit (Custom Skin)", "Medkit", "RNG Dice", "Contraband")
	registerVirtualWeaponSkin(RPG_CUSTOM_SKIN, "RPG", "Nuke Launcher", "Contraband", "Raze", RPG_CUSTOM_SKIN)
	registerVirtualWeaponSkin(FISTS_CUSTOM_SKIN, "Fists", "Fists", "Contraband", "Agent")
	registerVirtualWeaponSkin(BOW_CUSTOM_SKIN, "Bow", "Frostbite Bow", "Contraband")
	registerVirtualWeaponSkin(ASSAULT_RIFLE_CUSTOM_SKIN, "Assault Rifle", "AK-47", "Contraband")
	registerVirtualWeaponSkin("Camera", "Jump Pad", "Jump Pad", "Contraband", "Camera", "Camera")
	registerVirtualWeaponSkin(DICE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", nil, DICE_TRIPMINE_SKIN)
	registerVirtualWeaponSkin(SPIKE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", "Spike", SPIKE_TRIPMINE_SKIN)
end

registerVirtualWeaponSkins()

local cdata = dctrl.CurrentData
if not cdata then
	task.spawn(function()
		repeat task.wait() until dctrl.CurrentData
		cdata = dctrl.CurrentData
	end)
end

local equip, favs = {}, {}
local cwep, vprof, lwep
local lpname = lp.Name
local fcache = {}
local function banned(n)
	if type(n) ~= "string" then return true end
	return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll") or n:find("Fall Apart") or n:find("Every Finisher Ever")
end

local function toenum(n)
	if not elib then return nil end
	local ok, id = pcall(function() return elib:ToEnum(n) end)
	return ok and id or nil
end

local function clonecos(name, ctype, inv, favonly)
	if banned(name) then return nil end
	local base = coss[name]
	if not base then return nil end
	local d = table.clone(base)
	d.Name = name
	d.Type = d.Type or ctype
	d.Seed = d.Seed or math.random(1, 1000000)
	d.Owned = true
	d.Unlocked = true
	d.Locked = false
	d.Amount = math.max(1, tonumber(d.Amount) or 1)
	d.Count = math.max(1, tonumber(d.Count) or 1)
	local eid = toenum(name)
	if eid then d.Enum = eid d.ObjectID = d.ObjectID or eid end
	if inv ~= nil then d.Inverted = inv end
	if favonly ~= nil then d.OnlyUseFavorites = favonly end
	return d
end

local finv = {}
local function rebuildinv()
	table.clear(finv)
	for _, cos in equip do
		for _, cd in cos do
			if cd and cd.Name and not banned(cd.Name) then
				finv[cd.Name] = cd
			end
		end
	end
end

rebuildinv()

local oget = dctrl.Get
dctrl.Get = function(self, key)
	local data = oget(self, key)
	if key == "CosmeticInventory" then
		local proxy = {}
		if data then for k, v in pairs(data) do if not banned(k) then proxy[k] = v end end end
		if flags.unlock_all then
			for name, cdata in pairs(coss) do
				if not banned(name) and proxy[name] == nil then
					proxy[name] = clonecos(name, cdata.Type) or {
						Name = name,
						Type = cdata.Type,
						Owned = true,
						Unlocked = true,
						Amount = 1,
						Count = 1
					}
				end
			end
		end
		for name, cosmetic in pairs(finv) do
			proxy[name] = cosmetic
		end
		return proxy
	end
	if key == "WeaponInventory" then
		local proxy = {}
		if data then for k, v in pairs(data) do proxy[k] = v end end
		if flags.unlock_all and ilib and ilib.Items then
			for wname, _ in pairs(ilib.Items) do
				if not banned(wname) and proxy[wname] == nil then
					proxy[wname] = { Name = wname, Owned = true, Unlocked = true }
				end
			end
		end
		return proxy
	end
	if key == "FavoritedCosmetics" then
		local res = data and table.clone(data) or {}
		for wep, fv in pairs(favs) do
			local slot = res[wep] or {}
			res[wep] = slot
			for name, isfav in pairs(fv) do
				if not banned(name) then slot[name] = isfav end
			end
		end
		return res
	end
	return data
end

-- Hook CurrentData.Data to spoof in-game inventory UI (Armory / Customize)
local function hookCurrentData()
	pcall(function()
		if not dctrl or not dctrl.CurrentData then return end
		local cdata = dctrl.CurrentData
		if not cdata.Data then return end
		local realData = cdata.Data
		if getmetatable(realData) and getmetatable(realData).__isHooked then return end
		cdata.Data = setmetatable({}, {
			__isHooked = true,
			__index = function(_, k)
				if k == "CosmeticInventory" then
					return dctrl:Get("CosmeticInventory")
				elseif k == "WeaponInventory" then
					return dctrl:Get("WeaponInventory")
				end
				return realData[k]
			end,
			__newindex = function(_, k, v)
				realData[k] = v
			end
		})
	end)
end
hookCurrentData()

shared.SyncUnlockAll = function(enabled)
	pcall(function()
		hookCurrentData()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		rebuildinv()
		if shared.MeowCosmeticChanger and shared.MeowCosmeticChanger.Refresh then
			shared.MeowCosmeticChanger.Refresh()
		end
		pcall(function()
			local Pages = require(lps.Modules.Pages)
			if Pages and Pages.PageSystem then
				pcall(function() Pages.PageSystem:RefreshPage() end)
				pcall(function() Pages.PageSystem:OpenPage("Customize") end)
			end
		end)
	end)
end

local ogetwep = dctrl.GetWeaponData
dctrl.GetWeaponData = function(self, wname)
	local data = ogetwep(self, wname)
	if not data then return nil end
	local merged = table.clone(data)
	merged.Name = wname
	local weq = equip[wname]
	if weq then for ct, cd in weq do merged[ct] = cd end end
	return merged
end

local function saferep(key)
	pcall(function()
		if not cdata and dctrl.CurrentData then cdata = dctrl.CurrentData end
		if cdata then cdata:Replicate(key) end
	end)
end

local fctrl, wrapController
pcall(function() fctrl = require(ctrls:WaitForChild("FighterController", 1)) end)
pcall(function() wrapController = require(ctrls:WaitForChild("WrapController", 1)) end)
local replicatedClass
pcall(function()
	local identity = getthreadidentity and getthreadidentity()
	if setthreadidentity then pcall(function() return setthreadidentity(2) end) end
	local ok, result = pcall(function() return require(reps.Modules.ReplicatedClass) end)
	if identity and setthreadidentity then pcall(function() return setthreadidentity(identity) end) end
	if ok then replicatedClass = result end
end)
local charmAssets, wrapPreviewAsset, wrapTextureAssets
pcall(function()
	charmAssets = lps.Assets:WaitForChild("Charms", 1)
	wrapPreviewAsset = lps.Assets:WaitForChild("Misc", 1):WaitForChild("Wrap", 1)
	wrapTextureAssets = lps.Assets:WaitForChild("WrapTextures", 1)
end)

local function resolveViewModelName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	return skinName or weapon
end

local function resolveViewModelSourceName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	return skin and (skin.SourceViewModelName or skin.ViewModelName or skin.Name) or weapon
end
local virtualViewModelClassOverrides = {
	[KNIFE_CUSTOM_SKIN] = "Knife",
	[REAVER_KNIFE_CUSTOM_SKIN] = "Knife",
	[DAGGERS_CUSTOM_SKIN] = "Keynais",
	[SNIPER_CUSTOM_SKIN] = "Keyper",
	["Operator"] = "Sniper",
	[RPG_CUSTOM_SKIN] = "Nuke Launcher",
	[FISTS_CUSTOM_SKIN] = "Fists",
		[BOW_CUSTOM_SKIN] = "Frostbite Bow",
		[ASSAULT_RIFLE_CUSTOM_SKIN] = "AK-47",
		["Grenade (Custom Skin)"] = "Elixir",
		["Grenade Raze"] = "Glorious Grenade",
		["sky"] = "Shining Star",
	["Molotov (Custom Skin)"] = "Elixir",
	["Satchel (Custom Skin)"] = "Elixir",
	["Smoke Grenade (Custom Skin)"] = "Elixir",
	["Warpstone (Custom Skin)"] = "Elixir",
	[SATCHEL_CUSTOM_SKIN] = "BaseSatchel",
	[DICE_TRIPMINE_SKIN] = "SubspaceTripmine",
	[SPIKE_TRIPMINE_SKIN] = "SubspaceTripmine"
}

local function resolveViewModelClassName(_, cosmetics, resolvedName)
	return (resolvedName and virtualViewModelClassOverrides[resolvedName]) or resolvedName
end

local resolveViewModelClass
local clientViewModelClass
local clientViewModelBaseNew
local constructingVirtualViewModelClass = false

local function getewep()
	if not fctrl then return nil end
	local fighter = fctrl:GetFighter(lp)
	if not fighter or not fighter.Items then return nil end
	for _, item in fighter.Items do
		if item.IsEquipped then return item.Name end
	end
	return nil
end

if hookfunction then
	local rems = reps:FindFirstChild("Remotes")
	local drems = rems and rems:FindFirstChild("Data")
	local eqrem = drems and drems:FindFirstChild("EquipCosmetic")
	local favrem = drems and drems:FindFirstChild("FavoriteCosmetic")
	local rrems = rems and rems:FindFirstChild("Replication")
	local frems = rrems and rrems:FindFirstChild("Fighter")
	local uirem = frems and frems:FindFirstChild("UseItem")

	if eqrem then
		local oldFireServer
		oldFireServer = hookfunction(eqrem.FireServer, newcclosure(function(self, ...)
			local args = { ... }

			if uirem and self == uirem and fctrl then
				pcall(function()
					local fighter = fctrl:GetFighter(lp)
					if fighter and fighter.Items then
						local oid = args[1]
						for _, item in fighter.Items do
							if item:Get("ObjectID") == oid then
								lwep = item.Name
								break
							end
						end
					end
				end)
			end

			if self == eqrem then
				local wname, ctype, cname, opts = args[1], args[2], args[3], args[4] or {}
				if not cname or cname == "None" or cname == "" then
					equip[wname] = equip[wname] or {}
					equip[wname][ctype] = nil
					if not next(equip[wname]) then equip[wname] = nil end
					rebuildinv()
					task.defer(function()
						saferep("WeaponInventory")
					end)
					return oldFireServer(self, ...)
				end
				if banned(cname) then return oldFireServer(self, ...) end
				local rdata = oget(dctrl, "CosmeticInventory")
				if rdata and type(rdata[cname]) ~= "boolean" and rdata[cname] ~= nil then
					return oldFireServer(self, ...)
				end
				equip[wname] = equip[wname] or {}
				local cloned = clonecos(cname, ctype, opts.IsInverted, opts.OnlyUseFavorites)
				if cloned then equip[wname][ctype] = cloned end
				if ctype == "Finisher" then fcache[wname] = cname end
				rebuildinv()
				task.defer(function()
					saferep("WeaponInventory")
				end)
				return
			end

			if self == favrem then
				local fwep, fname, fstate = args[1], args[2], args[3]
				if not fname or fname == "None" or fname == "" then return oldFireServer(self, ...) end
				if banned(fname) then return oldFireServer(self, ...) end
				favs[fwep] = favs[fwep] or {}
				favs[fwep][fname] = fstate or nil
				task.spawn(saferep, "FavoritedCosmetics")
				return
			end

			return oldFireServer(self, ...)
		end))
	end
end

local citem
pcall(function() citem = require(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

local function applyLiveFistsMeshProfile(wname, viewModel)
	if wname ~= "Fists" then return end
	local skin = equip[wname] and equip[wname].Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	local profile = skinName and FISTS_MESH_SKIN_OVERRIDES[skinName]
	if not profile then return end

	task.spawn(function()
		for _ = 1, 30 do
			local model
			if typeof(viewModel) == "Instance" then
				model = viewModel
			elseif type(viewModel) == "table" then
				model = viewModel.Model or viewModel.ItemModel
			end
			if typeof(model) == "Instance" then
				if applyFistsMeshProfile(model, profile) then
					return
				end
			end
			task.wait()
		end
	end)
end

if citem and citem._CreateViewModel then
	local ocvm = citem._CreateViewModel
	citem._CreateViewModel = function(self, vmref)
		local wname = self.Name
		local wplr = self.ClientFighter and self.ClientFighter.Player
		cwep = (wplr == lp) and wname or nil
		local directClass
		if wplr == lp and equip[wname] and vmref then
			local cos = equip[wname]
			local dk = self:ToEnum("Data")
			local data = vmref[dk] or vmref.Data or {}
			if data then
				if vmref[dk] ~= nil or vmref.Data == nil then
					vmref[dk] = data
					vmref.Data = nil
				else
					vmref.Data = data
				end
				local resolvedName = resolveViewModelName(wname, cos)
				local className = resolveViewModelClassName(wname, cos, resolvedName)
				if cos.Skin then
					data[self:ToEnum("Skin")] = cos.Skin
				end
				data[self:ToEnum("Name")] = resolvedName
				if cos.Wrap then
					data[self:ToEnum("Wrap")] = cos.Wrap
				end
				if cos.Charm then
					data[self:ToEnum("Charm")] = cos.Charm
				end
				data.Skin = nil
				data.Name = nil
				data.Wrap = nil
				data.Charm = nil
				if className ~= resolvedName and resolveViewModelClass then
					directClass = resolveViewModelClass(className)
				end
			end
		end
		if directClass and directClass ~= clientViewModelClass and directClass.new then
			local identity = getthreadidentity and getthreadidentity() or 8
			constructingVirtualViewModelClass = true
			local ok, res = pcall(function()
				if setthreadidentity then pcall(function() return setthreadidentity(2) end) end
				return directClass.new(vmref, self)
			end)
			constructingVirtualViewModelClass = false
			if setthreadidentity then pcall(function() return setthreadidentity(identity) end) end
			cwep = nil
			if ok then
				applyLiveFistsMeshProfile(wname, res)
				return res
			end
		end
		local res = ocvm(self, vmref)
		cwep = nil
		applyLiveFistsMeshProfile(wname, res)
		return res
	end
end

local vmmod = lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if vmmod then
	local cvm = require(vmmod)
	clientViewModelClass = cvm
	if cvm.GetWrap then
		local ogw = cvm.GetWrap
		cvm.GetWrap = function(self)
			local ci = self.ClientItem
			local wname = ci and ci.Name
			local wplr = ci and ci.ClientFighter and ci.ClientFighter.Player
			local weq = wname and wplr == lp and equip[wname]
			return (weq and weq.Wrap) or ogw(self)
		end
	end
	if cvm._UpdateWrap and wrapController then
		local oldUpdateWrap = cvm._UpdateWrap
		local function isCustomTripmineViewModel(self)
			if not self then return false end
			if TRIPMINE_MESH_SKIN_OVERRIDES[self.Name] then
				return true
			end
			local ci = self.ClientItem
			local weapon = ci and ci.Name
			local skin = weapon and equip[weapon] and equip[weapon].Skin
			local skinName = skin and (skin.ViewModelName or skin.Name)
			return weapon == "Subspace Tripmine" and TRIPMINE_MESH_SKIN_OVERRIDES[skinName] ~= nil
		end
		local function collectCustomTripmineWrapTargets(model)
			local targets = {}
			for _, descendant in ipairs(model:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:GetAttribute("__MeowCustomTripmineMeshPart") then
					if descendant:GetAttribute("WrapGroup") == nil then
						descendant:SetAttribute("WrapGroup", 1)
					end
					descendant:SetAttribute("IgnoreTransparency", true)
					pcall(function() descendant:AddTag("Wrappable") end)
					pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
					table.insert(targets, descendant)
				end
			end
			return targets
		end
		cvm._UpdateWrap = function(self, ...)
			if isCustomTripmineViewModel(self) and self.Model then
				local targets = collectCustomTripmineWrapTargets(self.Model)
				if #targets > 0 then
					local wrap = self.GetWrap and self:GetWrap() or nil
					if self._original_wrap_properties then
						pcall(function() return wrapController:ResetWrap(self._original_wrap_properties) end)
						self._original_wrap_properties = nil
					end
					if self.__MeowCustomTripmineWrapProperties then
						pcall(function() return wrapController:ResetWrap(self.__MeowCustomTripmineWrapProperties) end)
						self.__MeowCustomTripmineWrapProperties = nil
					end
					if wrap then
						self.__MeowCustomTripmineWrapProperties = wrapController:RecordOriginalWrapProperties(targets)
						wrapController:ApplyWrap(self.__MeowCustomTripmineWrapProperties, wrap, true)
					end
					if self._UpdateLocalTransparencyModifiers then
						pcall(function() return self:_UpdateLocalTransparencyModifiers() end)
					end
					return
				end
			end
			return oldUpdateWrap(self, ...)
		end
	end
	local onew = cvm.new
	clientViewModelBaseNew = onew
	cvm.new = function(rdata, cliitm)
		if constructingVirtualViewModelClass then
			return onew(rdata, cliitm)
		end
		local wplr = cliitm.ClientFighter and cliitm.ClientFighter.Player
		local wname = cwep or cliitm.Name
		local className = wname
		if wplr == lp and equip[wname] then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			if rdata[dk] ~= nil or rdata.Data == nil then
				rdata[dk] = slot
				rdata.Data = nil
			else
				rdata.Data = slot
			end
			local cos = equip[wname]
			local resolvedName = resolveViewModelName(wname, cos)
			className = resolveViewModelClassName(wname, cos, resolvedName)
			if cos.Skin then
				slot[rcls:ToEnum("Skin")] = cos.Skin
			end
			slot[rcls:ToEnum("Name")] = resolvedName
			if cos.Wrap then
				slot[rcls:ToEnum("Wrap")] = cos.Wrap
			end
			if cos.Charm then
				slot[rcls:ToEnum("Charm")] = cos.Charm
			end
			slot.Skin = nil
			slot.Name = nil
			slot.Wrap = nil
			slot.Charm = nil
		end
		local targetNew = onew
		local targetClass = className ~= wname and resolveViewModelClass and resolveViewModelClass(className)
		if targetClass and targetClass ~= clientViewModelClass and targetClass.new then
			targetNew = targetClass.new
		end
		constructingVirtualViewModelClass = targetNew ~= onew
		local ok, res = pcall(function() return targetNew(rdata, cliitm) end)
		constructingVirtualViewModelClass = false
		if not ok and wplr == lp and equip[wname] and equip[wname].Skin then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			rdata[dk] = slot
			rdata.Data = nil
			slot[rcls:ToEnum("Name")] = wname
			slot.Name = nil
			ok, res = pcall(function() return onew(rdata, cliitm) end)
		end
		if not ok then error(res) end
		if wplr == lp and equip[wname] and res then
			for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
				if res[method] then
					pcall(function() return res[method](res) end)
				end
			end
			applyLiveFistsMeshProfile(wname, res)
		end
		return res
	end
end

local viewModelClassCache = {}
local function normalizeViewModelName(name)
	return tostring(name or ""):gsub("[%W_]+", ""):lower()
end

resolveViewModelClass = function(name)
	if not clientViewModelClass then return nil end
	local key = normalizeViewModelName(name)
	if viewModelClassCache[key] ~= nil then
		return viewModelClassCache[key] or clientViewModelClass
	end
	local targetClass = clientViewModelClass
	local vmFolder = lps.Modules:FindFirstChild("ViewModels")
	if vmFolder then
		for _, module in pairs(vmFolder:GetDescendants()) do
			if module:IsA("ModuleScript") and normalizeViewModelName(module.Name) == key then
				local ok, customClass = pcall(function() return require(module) end)
				if ok and type(customClass) == "table" and type(customClass.new) == "function" then
					targetClass = customClass
				end
				break
			end
		end
	end
	viewModelClassCache[key] = targetClass
	return targetClass
end

local function getLocalItem(weapon)
	local fighter = fctrl and fctrl:GetFighter(lp)
	for _, item in pairs(fighter and fighter.Items or {}) do
		if item.Name == weapon then
			return item
		end
	end
end

local function getWorldSkinName(weapon)
	local skin = equip[weapon] and equip[weapon].Skin
	return skin and (skin.WorldViewModelName or skin.SourceViewModelName or skin.ViewModelName or skin.Name)
end

local function getEquippedWeaponWrap(weapon)
	local item = getLocalItem(weapon)
	if item and item.GetWrap then
		local ok, wrap = pcall(function() return item:GetWrap() end)
		if ok then
			return wrap
		end
	end
	return equip[weapon] and equip[weapon].Wrap
end

local function isInsideWorkspaceViewModels(inst)
	local viewModels = workspace:FindFirstChild("ViewModels")
	return viewModels and inst:IsDescendantOf(viewModels)
end

local function isRpgRazeEquipped()
	return getWorldSkinName("RPG") == RPG_CUSTOM_SKIN
end

local function tryApplyRpgProjectileSkin(inst)
	local profile = RPG_MESH_SKIN_OVERRIDES[RPG_CUSTOM_SKIN]
	if not (profile and isRpgRazeEquipped() and typeof(inst) == "Instance") then return end
	if isInsideWorkspaceViewModels(inst) then return end
	if inst:GetAttribute("__MeowRpgProjectileSkinChecked") then return end

	local shouldApply = false
	if inst:IsA("MeshPart") or inst:IsA("SpecialMesh") then
		shouldApply = meshMatchesAnyAssetId(inst, profile.RocketMeshIds) or meshMatchesAnyAssetId(inst, profile.JuggleMeshIds)
	elseif inst:IsA("Model") then
		shouldApply = namePathContains(inst, "rocket") or namePathContains(inst, "projectile")
	end
	if not shouldApply then return end

	inst:SetAttribute("__MeowRpgProjectileSkinChecked", true)
	applyRpgMeshProfile(inst, profile, {
		ShowRocket = true,
		ForceRocket = true
	})
end

local function installRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__MeowRpgProjectileSkinHookState or {}
	env.__MeowRpgProjectileSkinHookState = state
	local version = 2
	if state.Version == version and state.Connection then return end
	if state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	state.Version = version
	state.Connection = workspace.DescendantAdded:Connect(function(inst)
		task.defer(tryApplyRpgProjectileSkin, inst)
	end)
	task.defer(function()
		for _, inst in ipairs(workspace:GetDescendants()) do
			tryApplyRpgProjectileSkin(inst)
		end
	end)
end
local function disableRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__MeowRpgProjectileSkinHookState
	if state and state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	env.__MeowRpgProjectileSkinHookState = {
		Version = 3,
		Connection = nil
	}
end

local function ensurePlacedTripmineWrapTargets(visual)
	if typeof(visual) ~= "Instance" then return end
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant:GetAttribute("__MeowCustomTripmineMeshPart") then
			if descendant:GetAttribute("WrapGroup") == nil then
				descendant:SetAttribute("WrapGroup", 1)
			end
			descendant:SetAttribute("IgnoreTransparency", true)
			pcall(function() descendant:AddTag("Wrappable") end)
			pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
		end
	end
end

local function applyPlacedTripmineWrap(visual)
	if not wrapController or typeof(visual) ~= "Instance" then return end
	ensurePlacedTripmineWrapTargets(visual)
	local wrap = getEquippedWeaponWrap("Subspace Tripmine")
	pcall(function()
		local originalWrapProperties = wrapController:RecordOriginalWrapProperties(visual)
		wrapController:ApplyWrap(originalWrapProperties, wrap, true)
	end)
end

local function isLocalPlacedObject(object, weapon)
	local userId = object:GetAttribute("PlacedByUserID")
		or object:GetAttribute("ThrownByUserID")
		or object:GetAttribute("OwnerUserID")
	if userId ~= nil then
		return tonumber(userId) == lp.UserId
	end

	local objectId = object:GetAttribute("ObjectID")
	local item = getLocalItem(weapon)
	return objectId ~= nil and item and item.Get and item:Get("ObjectID") == objectId
end

local function isInsidePlacedSkinVisual(inst)
	local current = inst
	while current do
		if current.Name == "__MeowPlacedSkin" or current:GetAttribute("__MeowPlacedSkin") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideOriginalTripmineVisual(object)
	if typeof(object) ~= "Instance" then return end
	local function hide(inst)
		if isInsidePlacedSkinVisual(inst) then return end
		if inst:IsA("BasePart") then
			inst.Transparency = 1
			inst.LocalTransparencyModifier = 1
		elseif inst:IsA("Decal") or inst:IsA("Texture") then
			inst.Transparency = 1
		elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
			inst.Enabled = false
		end
	end

	for _, descendant in ipairs(object:GetDescendants()) do
		hide(descendant)
	end

	if not object:GetAttribute("__MeowHideOriginalTripmineHook") then
		object:SetAttribute("__MeowHideOriginalTripmineHook", true)
		local connection
		connection = object.DescendantAdded:Connect(function(descendant)
			task.defer(hide, descendant)
		end)
		task.delay(8, function()
			if connection then
				connection:Disconnect()
			end
		end)
	end

	if not object:GetAttribute("__MeowHideOriginalTripmineLoop") then
		object:SetAttribute("__MeowHideOriginalTripmineLoop", true)
		task.spawn(function()
			for _ = 1, 80 do
				if not object.Parent then break end
				for _, descendant in ipairs(object:GetDescendants()) do
					hide(descendant)
				end
				task.wait(0.1)
			end
			if object.Parent then
				object:SetAttribute("__MeowHideOriginalTripmineLoop", nil)
			end
		end)
	end
end

local function prunePlacedTripmineVisualToCustomMesh(visual)
	if typeof(visual) ~= "Instance" then return end
	local primaryPart
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant:GetAttribute("__MeowCustomTripmineMeshPart") then
				primaryPart = primaryPart or descendant
			else
				descendant:Destroy()
			end
		end
	end
	if visual:IsA("Model") and primaryPart then
		visual.PrimaryPart = primaryPart
	end
end
local function isInsideCustomTripmineMeshPart(inst)
	local current = inst
	while current do
		if current:IsA("BasePart") and current:GetAttribute("__MeowCustomTripmineMeshPart") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function forcePlacedSkinVisualVisible(visual)
	if typeof(visual) ~= "Instance" then return end

	local function show(inst)
		if inst:IsA("BasePart") and inst:GetAttribute("__MeowCustomTripmineMeshPart") then
			inst.Transparency = 0
			inst.LocalTransparencyModifier = 0
		elseif (inst:IsA("Decal") or inst:IsA("Texture")) and isInsideCustomTripmineMeshPart(inst) then
			inst.Transparency = 0
		end
	end

	for _, descendant in ipairs(visual:GetDescendants()) do
		show(descendant)
	end

	if not visual:GetAttribute("__MeowShowPlacedSkinLoop") then
		visual:SetAttribute("__MeowShowPlacedSkinLoop", true)
		local connection
		connection = visual.DescendantAdded:Connect(function(descendant)
			task.defer(show, descendant)
		end)
		task.spawn(function()
			for _ = 1, 100 do
				if not visual.Parent then break end
				for _, descendant in ipairs(visual:GetDescendants()) do
					show(descendant)
				end
				task.wait(0.1)
			end
			if connection then
				connection:Disconnect()
			end
			if visual.Parent then
				visual:SetAttribute("__MeowShowPlacedSkinLoop", nil)
			end
		end)
	end
end

local function pivotPlacedTripmineVisual(visual, hitbox, profile)
	if not (visual and visual:IsA("Model") and hitbox and hitbox:IsA("BasePart")) then return end
	local boundsCFrame, boundsSize = visual:GetBoundingBox()
	local centerOffset = visual:GetPivot():ToObjectSpace(boundsCFrame)
	local groundOffset = profile and profile.WorldGroundOffset or 0
	local targetCenterOffsetY = (-hitbox.Size.Y * 0.5) + (boundsSize.Y * 0.5) + groundOffset
	local targetBoundsCFrame = hitbox.CFrame * CFrame.new(0, targetCenterOffsetY, 0)
	visual:PivotTo(targetBoundsCFrame * centerOffset:Inverse())
end

local function installPlacedCosmeticHooks()
	local components = lps.Modules:FindFirstChild("GameComponents")
	if not components then return end

	pcall(function()
		local jumpPads = require(components:WaitForChild("JumpPads", 1))
		if jumpPads.__MeowSkinHook then return end
		jumpPads.__MeowSkinHook = true
		local oldObjectAdded = jumpPads._ObjectAdded
		jumpPads._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Jump Pad")
			if skinName and isLocalPlacedObject(object, "Jump Pad") then
				object:SetAttribute("ViewModelName", skinName)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local tripmines = require(components:WaitForChild("SubspaceTripmines", 1))
		if tripmines.__MeowSkinHook then return end
		tripmines.__MeowSkinHook = true
		local oldObjectAdded = tripmines._ObjectAdded
		tripmines._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Subspace Tripmine")
			local placedSkinName = skinName == "RNG Dice" and DICE_TRIPMINE_SKIN or skinName
			local meshProfile = TRIPMINE_MESH_SKIN_OVERRIDES[placedSkinName]
			if meshProfile and isLocalPlacedObject(object, "Subspace Tripmine") then
				task.defer(function()
					if not object.Parent or object:FindFirstChild("__MeowPlacedSkin") then return end
					hideOriginalTripmineVisual(object)

					local throwables = lps.Assets:FindFirstChild("Throwables")
					local viewModels = lps.Assets:FindFirstChild("ViewModels")
					local sourceName = meshProfile.BaseAssetName or "Subspace Tripmine"
					local source = (throwables and findDescendantByName(throwables, sourceName)) or (viewModels and findDescendantByName(viewModels, sourceName))
					local hitbox = object:FindFirstChild("Hitbox", true)
					if not source or not hitbox or not hitbox:IsA("BasePart") then return end

					local visual = source:Clone()
					if not applyTripmineMeshProfile(visual, meshProfile, true) then
						visual:Destroy()
						return
					end
					prunePlacedTripmineVisualToCustomMesh(visual)
					if visual:IsA("BasePart") then
						local model = Instance.new("Model")
						model.Name = visual.Name
						visual.Parent = model
						model.PrimaryPart = visual
						visual = model
					end
					if not visual:IsA("Model") then return end
					for _, descendant in pairs(visual:GetDescendants()) do
						if descendant.Name == "_right_arm" or descendant.Name == "_left_arm" or descendant.Name == "_fake" then
							descendant:Destroy()
						end
					end
					visual.Name = "__MeowPlacedSkin"
					visual:SetAttribute("__MeowPlacedSkin", true)
					visual.Parent = object
					hideOriginalTripmineVisual(object)
					pivotPlacedTripmineVisual(visual, hitbox, meshProfile)
					forcePlacedSkinVisualVisible(visual)
					for _, part in pairs(visual:GetDescendants()) do
						if part:IsA("BasePart") then
							part.Anchored = false
							part.CanCollide = false
							part.CanTouch = false
							part.CanQuery = false
							part.Massless = true
							local weld = Instance.new("WeldConstraint")
							weld.Part0 = hitbox
							weld.Part1 = part
							weld.Parent = part
						end
					end
					applyPlacedTripmineWrap(visual)
					forcePlacedSkinVisualVisible(visual)
				end)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local fireHitboxes = require(components:WaitForChild("FireHitboxes", 1))
		local fireAssets = lps.Assets:WaitForChild("Misc", 1):WaitForChild("FireHitboxes", 1)
		if not fireAssets:FindFirstChild("Elixir") then
			local elixirEffect = lps.Assets.Misc:FindFirstChild("ElixirExplosionEffect")
			local defaultFire = fireAssets:FindFirstChild("Default")
			if elixirEffect and defaultFire then
				local elixirFire = defaultFire:Clone()
				elixirFire.Name = "Elixir"
				for _, effect in pairs(elixirFire:GetDescendants()) do
					if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") then
						effect:Destroy()
					end
				end
				local primary = elixirFire:FindFirstChild("Primary")
				local attachment = elixirEffect:FindFirstChild("Attachment")
				if primary and attachment then
					attachment:Clone().Parent = primary
				end
				elixirFire.Parent = fireAssets
			end
		end

		local collectionService = game:GetService("CollectionService")
		local function replaceFireVisual(object)
			local skinName = getWorldSkinName("Molotov")
			if not skinName or not isLocalPlacedObject(object, "Molotov") then return end
			object:SetAttribute("ViewModelName", skinName)
			task.spawn(function()
				local entry
				for _ = 1, 20 do
					entry = fireHitboxes._fire_hitboxes and fireHitboxes._fire_hitboxes[object]
					if entry and entry.Visual then break end
					task.wait()
				end
				if not entry or not entry.Visual or not object.Parent then return end
				local source = fireAssets:FindFirstChild(skinName) or fireAssets:FindFirstChild("Default")
				if not source then return end

				local visual = source:Clone()
				visual.Name = skinName
				visual.PrimaryPart = visual:FindFirstChild("Primary")
				if not visual.PrimaryPart then return end
				visual.PrimaryPart.Size = object.Size
				visual:PivotTo(object.CFrame)
				visual.Parent = workspace
				for _, sound in ipairs({entry.Sound1, entry.Sound2}) do
					if sound then sound.Parent = visual.PrimaryPart end
				end
				local oldVisual = entry.Visual
				entry.Visual = visual
				oldVisual:Destroy()
			end)
		end

		collectionService:GetInstanceAddedSignal("FireHitbox"):Connect(replaceFireVisual)
		for _, object in pairs(collectionService:GetTagged("FireHitbox")) do
			task.defer(replaceFireVisual, object)
		end
	end)

	pcall(function()
		local smokeModule = lps.Modules:FindFirstChild("SmokeCloud")
		if not smokeModule then return end
		local smokeCloud = require(smokeModule)
		if smokeCloud.__MeowSkinHook or type(smokeCloud.new) ~= "function" then return end
		smokeCloud.__MeowSkinHook = true

		local oldNew = smokeCloud.new
		smokeCloud.new = function(...)
			local args = { ... }
			local cloud = oldNew(...)
			task.defer(function()
				local skinName = getWorldSkinName("Smoke Grenade")
				if skinName ~= "Elixir" or type(cloud) ~= "table" then return end

				local ownerObject
				for _, value in ipairs(args) do
					if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
						ownerObject = value
						break
					end
				end

				local model = cloud.Model
				if not ownerObject then
					for _, value in pairs(cloud) do
						if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
							ownerObject = value
							break
						end
					end
				end
				if not ownerObject and typeof(model) == "Instance" and isLocalPlacedObject(model, "Smoke Grenade") then
					ownerObject = model
				end
				if not ownerObject then
					local item = getLocalItem("Smoke Grenade")
					local localObjectId = item and item.Get and item:Get("ObjectID")
					local cloudObjectId = rawget(cloud, "ObjectID") or rawget(cloud, "_object_id")
					if localObjectId ~= nil and cloudObjectId == localObjectId then
						ownerObject = model
					end
				end
				if not ownerObject or typeof(model) ~= "Instance" or not model.Parent then return end
				if model:FindFirstChild("__MeowSmokeSkin") then return end

				for _, descendant in pairs(model:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 1
					end
				end

				local throwables = lps.Assets:FindFirstChild("Throwables")
				local source = throwables and throwables:FindFirstChild(skinName)
				if not source then return end

				local visual = source:Clone()
				visual.Name = "__MeowSmokeSkin"
				local anchor = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
				if not anchor then
					anchor = Instance.new("Part")
					anchor.Name = "__MeowSmokeAnchor"
					anchor.Size = Vector3.new(0.1, 0.1, 0.1)
					anchor.Transparency = 1
					anchor.Anchored = true
					anchor.CanCollide = false
					anchor.CanTouch = false
					anchor.CanQuery = false
					anchor.CFrame = model:IsA("Model") and model:GetPivot() or CFrame.new()
					anchor.Parent = model
				end

				visual.Parent = model
				visual:PivotTo(anchor.CFrame)
				for _, part in pairs(visual:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Anchored = false
						part.CanCollide = false
						part.CanTouch = false
						part.CanQuery = false
						part.Massless = true
						local weld = Instance.new("WeldConstraint")
						weld.Part0 = anchor
						weld.Part1 = part
						weld.Parent = part
					end
				end
			end)
			return cloud
		end
	end)
end

disableRpgProjectileSkinHook()
installPlacedCosmeticHooks()

local function isValidViewModel(viewModel)
	return type(viewModel) == "table"
		and viewModel._destroyed ~= true
		and typeof(viewModel.Model) == "Instance"
		and typeof(viewModel.ItemModel) == "Instance"
end

local ogvi = ilib.GetViewModelImageFromWeaponData
ilib.GetViewModelImageFromWeaponData = function(self, wdata, hires)
	if not wdata then return ogvi(self, wdata, hires) end
	local wname = wdata.Name
	local weq = equip[wname]
	if weq and weq.Skin then
		local skinViewModelName = weq.Skin.ViewModelName or weq.Skin.Name
		local skinSourceName = weq.Skin.SourceViewModelName or skinViewModelName
		local sinfo = self.ViewModels[skinViewModelName] or self.ViewModels[skinSourceName]
		if sinfo then return sinfo[hires and "ImageHighResolution" or "Image"] or sinfo.Image end
		return weq.Skin[hires and "ImageHighResolution" or "Image"] or weq.Skin.Image or ""
	end
	return ogvi(self, wdata, hires)
end

pcall(function()
	local vpmod = require(lps.Modules.Pages.ViewProfile)
	if vpmod and vpmod.Fetch then
		local ofetch = vpmod.Fetch
		vpmod.Fetch = function(self, tplr)
			vprof = tplr
			return ofetch(self, tplr)
		end
	end
end)
local cent
pcall(function() cent = require(lps.Modules.ClientReplicatedClasses.ClientEntity) end)

if cent and cent._PlayFinisher then
	local ofin = cent._PlayFinisher
	cent._PlayFinisher = function(self, fname, ...)
		local ewep = getewep()
		local tfin = ewep and (fcache[ewep] or (equip[ewep] and equip[ewep].Finisher and equip[ewep].Finisher.Name))
		return ofin(self, tfin or fname, ...)
	end
end

rebuildinv()

for wname, wdata in equip do
	if wdata.Finisher and wdata.Finisher.Name then
		fcache[wname] = wdata.Finisher.Name
	end
end

local cosmeticGuiState = {
	Wanted = false,
	Gui = nil,
	WeaponSearch = "",
	CosmeticSearch = "",
	Mode = "Skin",
	SelectedWeapon = nil,
	SelectedCosmetic = nil,
	Weapons = {},
	Cosmetics = {},
	DisabledWeapons = {},
	Columns = 6,
	TileW = 89,
	TileH = 74
}

local function displayName(name, data)
	return tostring((data and (data.DisplayName or data.Name)) or name or "")
end

-- Kicia-style image resolution for cosmetics (Skins, Wraps, Charms, Finishers)
local function getCosmeticImage(name, data)
	if not name then return "" end
	if CUSTOM_SKIN_IMAGE_OVERRIDES and CUSTOM_SKIN_IMAGE_OVERRIDES[name] then
		return CUSTOM_SKIN_IMAGE_OVERRIDES[name]
	end
	if consts and consts.COSMETIC_IMAGES and consts.COSMETIC_IMAGES[name] and consts.COSMETIC_IMAGES[name] ~= "" then
		return consts.COSMETIC_IMAGES[name]
	end
	if data and data.Image and data.Image ~= "" then
		return data.Image
	end
	if data and data.ImageHighResolution and data.ImageHighResolution ~= "" then
		return data.ImageHighResolution
	end
	if data and (data.Icon or data.Texture) then
		return data.Icon or data.Texture
	end
	if data and data.Type == "Wrap" then
		local wrapFolder = lps and lps:FindFirstChild("Assets") and lps.Assets:FindFirstChild("WrapTextures")
		local asset = wrapFolder and wrapFolder:FindFirstChild(name)
		if asset and asset:IsA("Texture") and asset.Texture ~= "" then
			return asset.Texture
		end
	end
	if data and data.Type == "Charm" then
		local charmFolder = lps and lps:FindFirstChild("Assets") and lps.Assets:FindFirstChild("Charms")
		local asset = charmFolder and charmFolder:FindFirstChild(name)
		if asset and asset:IsA("Decal") and asset.Texture ~= "" then
			return asset.Texture
		end
	end
	local typeInfo = data and data.Type and clib and clib.Types and clib.Types[data.Type]
	if typeInfo and typeInfo.Image then
		return typeInfo.Image
	end
	return "rbxassetid://89204837120267"
end

-- Kicia-style image resolution for weapons
local function getWeaponImage(wname, wdata)
	if not wname then return "" end
	wdata = wdata or (ilib and ilib.Items and ilib.Items[wname])
	if not wdata then return "rbxassetid://89204837120267" end
	if equip[wname] and equip[wname].Skin then
		local skinData = equip[wname].Skin
		local skinImg = getCosmeticImage(skinData.Name, skinData)
		if skinImg and skinImg ~= "" and skinImg ~= "rbxassetid://89204837120267" then
			return skinImg
		end
	end
	if wdata.Image and wdata.Image ~= "" then return wdata.Image end
	if wdata.ImageHighResolution and wdata.ImageHighResolution ~= "" then return wdata.ImageHighResolution end
	if wdata.Icon and wdata.Icon ~= "" then return wdata.Icon end
	if ilib and ilib.GetViewModelImageFromWeaponData then
		local ok, img = pcall(function() return ilib:GetViewModelImageFromWeaponData(wdata) end)
		if ok and img and img ~= "" then return img end
	end
	if ilib and ilib.ViewModels then
		local vmName = wdata.ViewModelName or wname
		local vm = ilib.ViewModels[vmName]
		if vm and vm.Image and vm.Image ~= "" then return vm.Image end
	end
	return "rbxassetid://89204837120267"
end

local function sortByName(list)
	table.sort(list, function(a, b)
		return tostring(a.Name):lower() < tostring(b.Name):lower()
	end)
	return list
end

local function cosmeticMatchesWeapon(data, weapon)
	if not data then return false end
	local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
	if itemName then
		return tostring(itemName):lower() == tostring(weapon or ""):lower()
	end
	return data.Type ~= "Skin"
end

local function rebuildCosmeticLists()
	table.clear(cosmeticGuiState.Weapons)
	table.clear(cosmeticGuiState.Cosmetics)
	local weaponNames = {}
	if ilib and ilib.Items then
		for k, v in pairs(ilib.Items) do
			if k ~= "MISSING_WEAPON" and not banned(k) then
				table.insert(weaponNames, k)
			end
		end
	elseif ilib and ilib.ItemsAlphabetized then
		for _, k in ipairs(ilib.ItemsAlphabetized) do
			if not banned(k) then table.insert(weaponNames, k) end
		end
	end
	table.sort(weaponNames)

	for _, wname in ipairs(weaponNames) do
		local wdata = ilib and ilib.Items and ilib.Items[wname]
		table.insert(cosmeticGuiState.Weapons, {
			Name = wname,
			Display = wname,
			Image = getWeaponImage(wname, wdata),
			Data = wdata
		})
	end

	if not cosmeticGuiState.SelectedWeapon and cosmeticGuiState.Weapons[1] then
		cosmeticGuiState.SelectedWeapon = cosmeticGuiState.Weapons[1].Name
	end

	local mode = cosmeticGuiState.Mode
	local selectedWeapon = cosmeticGuiState.SelectedWeapon

	for name, data in pairs(coss) do
		if not banned(name) and data.Type == mode then
			if mode == "Skin" then
				if cosmeticMatchesWeapon(data, selectedWeapon) then
					table.insert(cosmeticGuiState.Cosmetics, {
						Name = name,
						Display = displayName(name, data),
						Image = getCosmeticImage(name, data),
						Data = data
					})
				end
			else
				table.insert(cosmeticGuiState.Cosmetics, {
					Name = name,
					Display = displayName(name, data),
					Image = getCosmeticImage(name, data),
					Data = data
				})
			end
		end
	end

	sortByName(cosmeticGuiState.Cosmetics)
end

local function forceCosmeticUpdate(weapon, ctype)
	task.spawn(function()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")

		local selected = equip[weapon] and equip[weapon][ctype]
		local fighter = fctrl and fctrl:GetFighter(lp)
		if not fighter then return end
		local item
		for _, fighterItem in fighter.Items or {} do
			if fighterItem.Name == weapon then
				item = fighterItem
				break
			end
		end
		if not item then return end
		local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true

		local function refreshHotbar()
			local hotbar = fighter.FighterInterface and fighter.FighterInterface.Hotbar
			for _, hotbarSlot in pairs(hotbar and hotbar._hotbar_slots or {}) do
				if hotbarSlot.ClientItem == item then
					if hotbarSlot._Setup then
						pcall(function() return hotbarSlot:_Setup() end)
					end
					if hotbarSlot.UpdateVisuals then
						pcall(function() return hotbarSlot:UpdateVisuals() end)
					end
					break
				end
			end
		end

		if ctype == "Skin" then
			local resolvedSkinName = selected and (selected.ViewModelName or selected.Name)
			item:SetAttribute("Skin", resolvedSkinName)
			if wasEquipped and fighter.EquipItem then
				pcall(function() fighter:EquipItem(item) end)
			end
			refreshHotbar()
		elseif ctype == "Wrap" then
			local wrapName = selected and selected.Name
			item:SetAttribute("Wrap", wrapName)
			if item.ApplyWrap then
				pcall(function() item:ApplyWrap(wrapName) end)
			end
			refreshHotbar()
		elseif ctype == "Charm" then
			local charmName = selected and selected.Name
			item:SetAttribute("Charm", charmName)
			if item.ApplyCharm then
				pcall(function() item:ApplyCharm(charmName) end)
			end
			refreshHotbar()
		elseif ctype == "Finisher" then
			local finisherName = selected and selected.Name
			fcache[weapon] = finisherName
		end
	end)
end

local function applyCosmeticToWeapon(weapon, cosmeticName, ctype, skipRebuild)
	ctype = ctype or cosmeticGuiState.Mode
	equip[weapon] = equip[weapon] or {}

	if cosmeticName == "__random" or cosmeticName == "Random" then
		local pool = {}
		for _, item in ipairs(cosmeticGuiState.Cosmetics) do
			if item.Name ~= "__random" and item.Name ~= "Random" then
				table.insert(pool, item.Name)
			end
		end
		if #pool > 0 then
			cosmeticName = pool[math.random(#pool)]
		else
			cosmeticName = nil
		end
	end

	if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
		equip[weapon][ctype] = nil
	else
		local data = coss[cosmeticName]
		if data then
			equip[weapon][ctype] = clonecos(cosmeticName, ctype, finv, false)
			if ctype == "Finisher" then
				fcache[weapon] = cosmeticName
			end
		end
	end
	if not skipRebuild then
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		forceCosmeticUpdate(weapon, ctype)
	end
end

local function makeCosmeticChanger()
	if cosmeticGuiState.Gui then return cosmeticGuiState.Gui end
	rebuildCosmeticLists()

	local host = (gethui and gethui()) or game:GetService("CoreGui")
	local sg = host:FindFirstChild("_MeowCosmeticsHost")
	if not sg then
		sg = Instance.new("ScreenGui")
		sg.Name = "_MeowCosmeticsHost"
		sg.ResetOnSpawn = false
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.DisplayOrder = 999
		pcall(function() sg.Parent = host end)
		if not sg.Parent then
			pcall(function() sg.Parent = lp:WaitForChild("PlayerGui", 5) end)
		end
	end
	shared.MeowCosmeticsGui = sg

	-- Exact Screenshot Dimensions & Theme (Compact Sleek Dark UI)
	local gui = Instance.new("Frame")
	gui.Name = "CosmeticChanger"
	gui.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
	gui.BorderColor3 = Color3.fromRGB(34, 34, 38)
	gui.BorderSizePixel = 1
	gui.Position = UDim2.new(0.5, -300, 0.5, -320)
	gui.Size = UDim2.fromOffset(600, 640)
	gui.Visible = (cosmeticGuiState.Wanted == true)
	gui.ZIndex = 900
	gui.Parent = sg
	CosmeticChangerWindow = gui
	shared.CosmeticChangerWindow = gui
	cosmeticGuiState.Gui = gui
	pcall(makeDraggable, gui, title)

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Font = Enum.Font.Code
	title.Text = "Cosmetic Changer"
	title.TextColor3 = Color3.fromRGB(220, 220, 220)
	title.TextSize = 13
	title.Size = UDim2.new(1, 0, 0, 28)
	title.ZIndex = 901
	title.Parent = gui

	makeDraggable(gui, title)

	local body = Instance.new("Frame")
	body.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
	body.BorderColor3 = Color3.fromRGB(26, 26, 30)
	body.BorderSizePixel = 1
	body.Position = UDim2.fromOffset(10, 28)
	body.Size = UDim2.new(1, -20, 1, -38)
	body.ZIndex = 901
	body.Parent = gui

	local function mkLabel(parent, text, pos, size)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.Font = Enum.Font.Code
		l.Text = text
		l.TextColor3 = Color3.fromRGB(150, 150, 160)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextSize = 12
		l.Position = pos
		l.Size = size
		l.ZIndex = 902
		l.Parent = parent
		return l
	end

	local function mkInput(parent, placeholder, pos, size)
		local b = Instance.new("TextBox")
		b.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
		b.BorderColor3 = Color3.fromRGB(28, 28, 32)
		b.ClearTextOnFocus = false
		b.Font = Enum.Font.Code
		b.PlaceholderText = placeholder
		b.PlaceholderColor3 = Color3.fromRGB(85, 85, 95)
		b.Text = ""
		b.TextColor3 = Color3.fromRGB(225, 225, 230)
		b.TextSize = 12
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Position = pos
		b.Size = size
		b.ZIndex = 902
		b.Parent = parent
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 6)
		pad.Parent = b
		return b
	end

	local function mkActionBtn(parent, text, pos, size)
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
		btn.BorderColor3 = Color3.fromRGB(28, 28, 32)
		btn.Font = Enum.Font.Code
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(220, 220, 225)
		btn.TextSize = 12
		btn.Position = pos
		btn.Size = size
		btn.ZIndex = 902
		btn.Parent = parent
		return btn
	end

	-- 1. Weapon Filter Section
	mkLabel(body, "weapon filter", UDim2.fromOffset(8, 6), UDim2.new(1, -16, 0, 16))
	local weaponSearch = mkInput(body, "grenade launcher...", UDim2.fromOffset(8, 24), UDim2.new(1, -16, 0, 22))

	local weaponGrid = Instance.new("ScrollingFrame")
	weaponGrid.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	weaponGrid.BorderColor3 = Color3.fromRGB(24, 24, 28)
	weaponGrid.CanvasSize = UDim2.new()
	weaponGrid.ScrollBarThickness = 4
	weaponGrid.Position = UDim2.fromOffset(8, 50)
	weaponGrid.Size = UDim2.new(1, -16, 0, 160)
	weaponGrid.ZIndex = 902
	weaponGrid.Parent = body

	-- 2. Cosmetic Filter Section
	mkLabel(body, "cosmetic filter", UDim2.fromOffset(8, 216), UDim2.new(1, -16, 0, 16))
	local cosmeticSearch = mkInput(body, "red...", UDim2.fromOffset(8, 234), UDim2.new(1, -16, 0, 22))

	local cosmeticGrid = Instance.new("ScrollingFrame")
	cosmeticGrid.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	cosmeticGrid.BorderColor3 = Color3.fromRGB(24, 24, 28)
	cosmeticGrid.CanvasSize = UDim2.new()
	cosmeticGrid.ScrollBarThickness = 4
	cosmeticGrid.Position = UDim2.fromOffset(8, 260)
	cosmeticGrid.Size = UDim2.new(1, -16, 0, 160)
	cosmeticGrid.ZIndex = 902
	cosmeticGrid.Parent = body

	-- 3. Selector Bar (skin, wrap, charm, finisher)
	local modeText = Instance.new("TextLabel")
	local modeButton = Instance.new("TextButton")
	modeButton.AutoButtonColor = false
	modeButton.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	modeButton.BorderColor3 = Color3.fromRGB(28, 28, 32)
	modeButton.Position = UDim2.fromOffset(8, 428)
	modeButton.Size = UDim2.new(1, -16, 0, 24)
	modeButton.Text = ""
	modeButton.ZIndex = 902
	modeButton.Parent = body

	modeText.BackgroundTransparency = 1
	modeText.Font = Enum.Font.Code
	modeText.Text = "skin"
	modeText.TextColor3 = Color3.fromRGB(220, 220, 220)
	modeText.TextXAlignment = Enum.TextXAlignment.Left
	modeText.TextSize = 12
	modeText.Position = UDim2.fromOffset(8, 0)
	modeText.Size = UDim2.new(1, -24, 1, 0)
	modeText.ZIndex = 903
	modeText.Parent = modeButton

	local modeArrow = Instance.new("TextLabel")
	modeArrow.BackgroundTransparency = 1
	modeArrow.Font = Enum.Font.Code
	modeArrow.Text = ">"
	modeArrow.TextColor3 = Color3.fromRGB(220, 220, 220)
	modeArrow.TextXAlignment = Enum.TextXAlignment.Right
	modeArrow.TextSize = 12
	modeArrow.Position = UDim2.fromOffset(0, 0)
	modeArrow.Size = UDim2.new(1, -8, 1, 0)
	modeArrow.ZIndex = 903
	modeArrow.Parent = modeButton

	-- 4. Action Buttons
	local applyAll = mkActionBtn(body, "apply selected to all", UDim2.fromOffset(8, 458), UDim2.new(1, -16, 0, 26))

	local halfW = math.floor((600 - 20 - 16 - 6) / 2)
	local reset = mkActionBtn(body, "reset to defaults", UDim2.fromOffset(8, 490), UDim2.fromOffset(halfW, 26))
	local close = mkActionBtn(body, "close", UDim2.fromOffset(8 + halfW + 6, 490), UDim2.fromOffset(halfW, 26))

	-- 5. Footer Text
	local footer = Instance.new("TextLabel")
	footer.BackgroundTransparency = 1
	footer.Font = Enum.Font.Code
	footer.Text = "right click a weapon to toggle the skin changer for it."
	footer.TextColor3 = Color3.fromRGB(120, 120, 130)
	footer.TextSize = 11
	footer.Position = UDim2.fromOffset(8, 524)
	footer.Size = UDim2.new(1, -16, 0, 20)
	footer.ZIndex = 902
	footer.Parent = body

	local function clearChildren(parent)
		for _, ch in ipairs(parent:GetChildren()) do
			if ch:IsA("GuiObject") then ch:Destroy() end
		end
	end

	local function passes(entry, search)
		if not search or search == "" then return true end
		local s = tostring(search):lower()
		return tostring(entry.Name):lower():find(s, 1, true) ~= nil
			or tostring(entry.Display or ""):lower():find(s, 1, true) ~= nil
	end

	local function makeTile(parent, entry, index, selected, callback, rightCallback)
		local col = (index - 1) % cosmeticGuiState.Columns
		local row = math.floor((index - 1) / cosmeticGuiState.Columns)

		local tile = Instance.new("TextButton")
		tile.AutoButtonColor = false
		tile.BackgroundColor3 = selected and Color3.fromRGB(24, 26, 32) or Color3.fromRGB(16, 17, 20)
		tile.BorderColor3 = selected and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(24, 25, 28)
		tile.BorderSizePixel = 1
		tile.Position = UDim2.fromOffset(col * (cosmeticGuiState.TileW + 4) + 4, row * (cosmeticGuiState.TileH + 4) + 4)
		tile.Size = UDim2.fromOffset(cosmeticGuiState.TileW, cosmeticGuiState.TileH)
		tile.ClipsDescendants = true
		tile.Text = ""
		tile.ZIndex = 903
		tile.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = tile

		if selected then
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(0, 162, 255)
			stroke.Thickness = 1.2
			stroke.Parent = tile
		end

		if entry.Disabled then
			local dBadge = Instance.new("Frame")
			dBadge.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
			dBadge.Position = UDim2.new(1, -12, 0, 2)
			dBadge.Size = UDim2.fromOffset(8, 8)
			dBadge.ZIndex = 905
			dBadge.Parent = tile
			Instance.new("UICorner", dBadge).CornerRadius = UDim.new(1, 0)
		end

		local img = Instance.new("ImageLabel")
		img.BackgroundTransparency = 1
		img.Image = entry.Image or ""
		img.ScaleType = Enum.ScaleType.Fit
		img.Position = UDim2.fromOffset(6, 4)
		img.Size = UDim2.fromOffset(cosmeticGuiState.TileW - 12, cosmeticGuiState.TileH - 26)
		img.ZIndex = 904
		img.Parent = tile

		local name = Instance.new("TextLabel")
		name.BackgroundTransparency = 1
		name.Font = Enum.Font.Code
		name.Text = entry.Display
		name.TextColor3 = Color3.fromRGB(240, 240, 240)
		name.TextSize = 11
		name.TextWrapped = true
		name.TextScaled = false
		name.Position = UDim2.fromOffset(2, cosmeticGuiState.TileH - 22)
		name.Size = UDim2.fromOffset(cosmeticGuiState.TileW - 4, 20)
		name.ZIndex = 904
		name.Parent = tile

		tile.MouseButton1Click:Connect(function()
			callback(entry)
		end)
		tile.MouseButton2Click:Connect(function()
			if rightCallback then rightCallback(entry) end
		end)
	end

	local function refresh()
		clearChildren(weaponGrid)
		clearChildren(cosmeticGrid)

		local wcount = 0
		for _, entry in ipairs(cosmeticGuiState.Weapons) do
			if passes(entry, cosmeticGuiState.WeaponSearch) then
				wcount += 1
				local isSel = (cosmeticGuiState.SelectedWeapon == entry.Name)
				local isDis = (cosmeticGuiState.DisabledWeapons[entry.Name] == true)
				local itemData = {
					Name = entry.Name,
					Display = entry.Display,
					Image = entry.Image,
					Disabled = isDis
				}
				makeTile(weaponGrid, itemData, wcount, isSel, function(chosen)
					cosmeticGuiState.SelectedWeapon = chosen.Name
					local currentEquip = equip[chosen.Name]
					if currentEquip and currentEquip[cosmeticGuiState.Mode] then
						cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
					else
						cosmeticGuiState.SelectedCosmetic = nil
					end
					rebuildCosmeticLists()
					refresh()
				end, function(chosen)
					cosmeticGuiState.DisabledWeapons[chosen.Name] = not cosmeticGuiState.DisabledWeapons[chosen.Name]
					refresh()
				end)
			end
		end
		weaponGrid.CanvasSize = UDim2.fromOffset(0, math.max(160, math.ceil(wcount / cosmeticGuiState.Columns) * (cosmeticGuiState.TileH + 4) + 8))

		-- Exact Kicia Random Shuffle Icon
		local randomEntry = {
			Name = "__random",
			Display = "Random",
			Image = "rbxassetid://94238795177693"
		}
		makeTile(cosmeticGrid, randomEntry, 1, cosmeticGuiState.SelectedCosmetic == "__random", function()
			cosmeticGuiState.SelectedCosmetic = "__random"
			if cosmeticGuiState.SelectedWeapon then
				applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, "__random", cosmeticGuiState.Mode)
			end
			rebuildCosmeticLists()
			refresh()
		end)

		local ccount = 1
		for _, entry in ipairs(cosmeticGuiState.Cosmetics) do
			if passes(entry, cosmeticGuiState.CosmeticSearch) then
				ccount += 1
				local isSel = (cosmeticGuiState.SelectedCosmetic == entry.Name)
				makeTile(cosmeticGrid, entry, ccount, isSel, function(chosen)
					cosmeticGuiState.SelectedCosmetic = chosen.Name
					if cosmeticGuiState.SelectedWeapon then
						applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, chosen.Name, cosmeticGuiState.Mode)
					end
					rebuildCosmeticLists()
					refresh()
				end)
			end
		end
		cosmeticGrid.CanvasSize = UDim2.fromOffset(0, math.max(160, math.ceil(ccount / cosmeticGuiState.Columns) * (cosmeticGuiState.TileH + 4) + 8))
	end

	cosmeticGuiState.Refresh = refresh

	local wSearchThread, cSearchThread
	weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.WeaponSearch = weaponSearch.Text
		if wSearchThread then task.cancel(wSearchThread) end
		wSearchThread = task.delay(0.1, refresh)
	end)
	cosmeticSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.CosmeticSearch = cosmeticSearch.Text
		if cSearchThread then task.cancel(cSearchThread) end
		cSearchThread = task.delay(0.1, refresh)
	end)

	local modes = { "Skin", "Wrap", "Charm", "Finisher" }
	local modeIndex = 1
	modeButton.MouseButton1Click:Connect(function()
		modeIndex = (modeIndex % #modes) + 1
		cosmeticGuiState.Mode = modes[modeIndex]
		modeText.Text = cosmeticGuiState.Mode:lower()
		rebuildCosmeticLists()
		refresh()
	end)

	applyAll.MouseButton1Click:Connect(function()
		local selected = cosmeticGuiState.SelectedCosmetic
		if not selected then return end
		for _, weapon in ipairs(cosmeticGuiState.Weapons) do
			applyCosmeticToWeapon(weapon.Name, selected, cosmeticGuiState.Mode, true)
			task.defer(forceCosmeticUpdate, weapon.Name, cosmeticGuiState.Mode)
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
	end)

	reset.MouseButton1Click:Connect(function()
		table.clear(equip)
		table.clear(fcache)
		rebuildinv()
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
	end)

	close.MouseButton1Click:Connect(function()
		cosmeticGuiState.Wanted = false
		gui.Visible = false
	end)
	local nextCosmeticGuiUpdate = 0
	RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now < nextCosmeticGuiUpdate then return end
		nextCosmeticGuiUpdate = now + 0.1
		gui.Visible = (cosmeticGuiState.Wanted == true)
	end)

	refresh()
	return gui
end

shared.MeowCosmeticChanger = nil
shared.MeowCosmeticChanger = {
	Toggle = function()
		cosmeticGuiState.Wanted = not cosmeticGuiState.Wanted
		local win = makeCosmeticChanger()
		if win then
			win.Visible = (cosmeticGuiState.Wanted == true)
		end
		if shared.MeowCosmeticsGui then
			shared.MeowCosmeticsGui.Enabled = (cosmeticGuiState.Wanted == true)
		end
		if cosmeticGuiState.Wanted then
			rebuildCosmeticLists()
			if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
		end
		return cosmeticGuiState.Wanted
	end,
	SetVisible = function(visible)
		cosmeticGuiState.Wanted = (visible == true)
		local win = makeCosmeticChanger()
		if win then
			win.Visible = (visible == true)
		end
		if shared.MeowCosmeticsGui then
			shared.MeowCosmeticsGui.Enabled = (visible == true)
		end
		if visible then
			rebuildCosmeticLists()
			if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
		end
	end,
	Refresh = function()
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	GetEquipData = function()
		local export = {}
		for w, cats in pairs(equip) do
			export[w] = {}
			for cat, data in pairs(cats) do
				export[w][cat] = data and data.Name or nil
			end
		end
		return export
	end,
	LoadEquipData = function(data)
		if type(data) ~= "table" then return end
		for w, cats in pairs(data) do
			if type(cats) == "table" then
				for cat, name in pairs(cats) do
					applyCosmeticToWeapon(w, name, cat, true)
					task.defer(function()
						pcall(function() return forceCosmeticUpdate(w, cat) end)
					end)
				end
			end
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		if cosmeticGuiState.SelectedWeapon then
			local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
			if currentEquip and currentEquip[cosmeticGuiState.Mode] then
				cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
			else
				cosmeticGuiState.SelectedCosmetic = nil
			end
		end
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	Apply = applyCosmeticToWeapon,
	State = cosmeticGuiState
}

-- Ensure GUI is created and visible immediately if enabled in menu
pcall(function()
    makeCosmeticChanger()
    if flags.show_cosmetics_changer ~= false then
        shared.MeowCosmeticChanger.SetVisible(true)
    end
end)

end)

local function initCosmeticChangerPill()
    local coreGui = (gethui and gethui()) or game:GetService("CoreGui")
    local sg = Instance.new("ScreenGui")
    sg.Name = "_MeowCosmeticPill"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = coreGui end)
    if not sg.Parent then
        pcall(function() sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 0.5) end)
    end

    local pill = Instance.new("TextButton")
    pill.Text = "Cosmetic Changer"
    pill.TextColor3 = Color3.fromRGB(210, 210, 220)
    pill.Font = Enum.Font.Code
    pill.TextSize = 11
    pill.Size = UDim2.fromOffset(130, 24)
    pill.Position = UDim2.new(1, -145, 1, -34)
    pill.BackgroundColor3 = Color3.fromRGB(14, 15, 19)
    pill.BorderSizePixel = 0
    pill.Parent = sg
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke", pill)
    s.Color = Color3.fromRGB(0, 162, 255)
    s.Thickness = 1

    pill.MouseButton1Click:Connect(function()
        if shared.MeowCosmeticChanger and shared.MeowCosmeticChanger.Toggle then
            shared.MeowCosmeticChanger.Toggle()
        elseif CosmeticChangerWindow then
            CosmeticChangerWindow.Visible = not CosmeticChangerWindow.Visible
        end
    end)
end

task.spawn(initMusicPlayer)
task.spawn(initKeybindsWidget)
task.spawn(initCosmeticChangerPill)


task.spawn(function(...)
return({function(j)return function(m,n,x,w,d,i,_)local q,c,u,o,p,z,k,y,l,a,v,f,s,h,g,b l=j.Aa[-0x3d4a]or j:Da(0x5bde5d7a,0x23d8babf,0x47e837,-0x3d4a)while true do if l>=0xaa then if l<0xd7 then if l<0b11000011 then if l<=0xaa then l,g=j.Aa[0x567b]or j:Ea(0x81,0x18b357cc,3862956169,0x567b),j.h(g(p,b,o))else f,p,l,s,b,o,g=x,k,j.Aa[-0x71df]or j:Fa(0b10000000,0x76e0,-0x71df),v,1,h,w[0x1d]end elseif l<=0b11000011 then k=k(j.i(h))g,h=0,k.n l=a==g and 0b110100011-l or l+-0b11000010 else l,h=j.Aa[0x6a9b]or j:Ca(2487610095,0x43b001c3,0x6a9b),j.h(h(j.i(g)))end elseif l>=0b11111001 then if l<=0b11111001 then p[b]=o f,o,p,s,b=i,nil,n,nil,nil return p,b,o,s,f else s=0b1011 b=o-s g=p[b]p,u,b,f=g[0b10],0b1110,g[1],_[0b10]s=f-u o=x[s]l=c<u and(j.Aa[0x39c6]or j:Ea(0b10,3300693768,0x90310de,0x39c6))or l+-0b11 end elseif l>0xd7 then l,p,g=j.Aa[0xe6]or j:Ca(4256650219,0x824bf,0xe6),1,v+h n=g-p else l,y=j.Aa[0x39c6]or j:Fa(0b1100,0x762e,0x39c6),n-v end elseif l>=0x89 then if l>0b10001110 then z=1 l,y=0b11100010-l,q-z elseif l>=0x8c then if l<=0b10001100 then g(p,b,o,s,f)o,l,p=_[0x12],l+0b1110000,w[0x19]else c,z=0x7d,0 y=q==z l=y and l+0x49 or 0x2b44/l end else l=j.Aa[-0x7cef]or j:Fa(0b10001,0x76ac,-0x7cef)end elseif l>0b1001110 then z,y=0b100101,_[0b1001]l,v,z,y=j.Aa[-0x38af]or j:Da(0x4258a6fe,2438224070,0x12aeb7c9,-0x38af),y-z,0b110010,_[0b1010]q,z,y=y-z,1,_[0b10001]a=y-z elseif l>=0x40 then if l>0b1000000 then l=y and 0x1380/l or 0x315c/l else k,z=w[0b11],x[v]h,p,g,o=z,x,w[0x15],1 o,l,b=v+y,j.Aa[-0x4b0d]or j:Fa(0b10100000,0x7646,-0x4b0d),v+o end else l,g=j.Aa[0xe6]or j:Da(2775975611,0x1393b230,0x346d2ebf,0xe6),1 h=a-g end end end end,function(e,f,...)local h={...}local d=select("#",...)for i=1,d do e[f+i-1]=h[i]end end,(function()local q,i,s=type,getmetatable,pairs return function(u,v,w)if q(u)~="function"then local p=i(u)if p~=nil and p.__iter~=nil then return p.__iter(u)elseif(p and p.__call)==nil and q(u)=="table"then return s(u)end end return u,v,w end end)(),function(f,d)return function()local c,e c={[1]=0b11,[0b11]=c}c[0b10]=c c[0b10][c[1]]=f:A{d[0b1001],d[0b11],d[0b110],d[0b111]}e=f:B{d[0b1011],d[0b1001],d[0b11],d[0b10],d[1],d[0b101],d[0b100],c,d[0b111],d[0b1010],d[0b1000],d[0b110]}return e end end,function(j,o)return function(m,n)local e,l,q,b,f,p,_,k,i,a,d,c l=0xe1 while true do if l<0b1100111 then if l>=0x17 then if l>0x44 then if l>0x5a then l=i<=0 and 0xe5 or 0/l else l,a=l+0b1101010,j.h(a(c,e))end elseif l>0x31 then l=i~=i and l+0b10100001 or 0b1100011 elseif l<=0b10111 then l=b>d and 0x1b5/l or 0x44 else l=i<=0 and 0x242d/l or 0b100 end elseif l<=0b110 then if l<0b100 then l,c,a,q,f,_=0b110,1,m,o[0b10][0b10][o[0b10][1]],o[0b11][0b10][o[0b11][1]],o[1][0b10][o[1][1]]c=b+c elseif l>0b100 then q=q(a,c)a,l,c,k=o[0b10][0b10][o[0b10][1]],0x5a,n,#n k,e=1,b%k e=e+k else l=i~=i and l+0b1111 or 0b100-l end else return p end elseif l<0b10111010 then if l<0b1110111 then if l>0x67 then l=i>0 and 0x17 or 0b1000100 else l=b>d and 0x7a5/l or 0x31 end elseif l<=0x77 then _=_(j.i(f))l,p=0b100101001-l,p.._ else b=b+i l=i>0 and 0b1100111 or 0b11100011-l end elseif l<0xc4 then if l<=0xba then l,f=l+-0x43,j.h(f(q,j.i(a)))else l=b<d and 0xd0-l or 0b100 end elseif l<0b11100001 then l=0xba elseif l>0xe1 then l=b<d and 0b10011 or 0/l else p,_,b,f="",#m,0,1 i,d=f,_-f l=d~=d and 0x13 or 0x74 end end end end,function(j)return function(m,n,r,b,d,i,_)local e,c,q,k,h,f,l,a l=j.Aa[-0x29dc]or j:Ca(0x7465b09d,2308443189,-0x29dc)repeat if l>0x15 then e=k-h c=r[e]q[a]=c c,k,e,a,q=nil,i,nil,nil,n return q,a,c,e,k else c,e,q=_[0b1010],0b111111,b[0x19]l,a=j.Aa[0x39d0]or j:Fa(0b10000000,0x7670,0x39d0),c-e f=q[a]a,q,k,h=f[1],f[0b10],_[0b1001],0x1f end until false end end,function(j)return function(m,n,p,b,d,i,_)local k,l,q,c,a,f,e l=j.Aa[0x77d8]or j:Fa(0b10,0x765a,0x77d8)while true do if l<=0b110110 then e,q,c=0b1000,b[0x19],_[0b1010]a=c-e l,f,c,a=j.Aa[-0x1c39]or j:Ea(0b1100101,0x316548d8,0x89a051d,-0x1c39),q[a],0b100011,_[0b1001]c,q=f[0b10],a-c else e=f[1]a=c[e]p[q]=a e,c,q,a,k=nil,nil,n,nil,i return q,a,c,e,k end end end end,bit32.band,l=function(j,n,p,...)local c,q,b,a,l,d,i,k,m,f,e,_ l=0x54 repeat if l>0b10001111 then if l<=0xe0 then if l>0b11011111 then l,d,_,i=0b100000110-l,m[p],j.h(...),m elseif l<0b11011011 then d=d+_ l=_>0 and 0b11011011 or 0x144-l elseif l<=0xdb then l=d>i and l+0b101 or 0b1111100 else l,q=0b11001000,a+c a,f=d+c,n[q]q=m[a]m[f]=q end elseif l<=0xfd then if l<=0xed then l=d<i and l+-0b1101 or 0x15b-l else l=_>0 and 0x8d53/l or 0x82 end else l=d<i and 0b11100000 or l+-0x89 end elseif l<=0b1110101 then if l>=0x54 then if l<0x6e then b,m,f,d=#n,j,1,0 i,_=b-f,f l=i~=i and 0xe0 or 0xfd elseif l<=0x6e then k=0x19927 k,e=0xb9ef,k*d l,c=l+0b1110001,e+k a,c=c%b,1 else l=_~=_ and 0xe0 or 0xe3-l end elseif l<=0b100110 then d=j.h(d(i,j.i(_)))return j.i(d)else l=_<=0 and 0x2b83/l or 0x6e end elseif l>=0x82 then if l<=0x82 then l=_~=_ and 0x16f-l or 0x17de/l else l=d>i and l+0x51 or 0b10000010 end else l=_<=0 and 0xfe or 0x75 end until false end,function(j,t)return function(m,n,x,w,d,i,_)local u,b,h,q,e,z,a,k,g,s,o,A,c,f,p,v,y A=j.Aa[-0x3417]or j:Ea(0b10001100,3868691346,0x10002ae,-0x3417)repeat if A>=0x3e then if A>0xa8 then if A<0b11000010 then if A<=0b10101110 then y,q,z=_[0x11],w[0b1011],0b1010 A,a=j.Aa[-0x43d0]or j:Ea(0x40,2517930467,0x60e108ce,-0x43d0),y-z v,y,a=q[a],0b10100,_[0b1010]a,q=w[0b110],a-y else f=b[0b1010]s=k[f]a[h]=s A=c<=e and(j.Aa[0x4459]or j:Ea(0x20,2599427162,0x640a00f4,0x4459))or(j.Aa[0x7b6]or j:Fa(0b111000,0x764c,0x7b6))end elseif A>0xc6 then A=h<g and 0b101101100-A or(j.Aa[0x2447]or j:Fa(0x20,0x76e4,0x2447))elseif A>0xc2 then A,y=j.Aa[-0x2a65]or j:Ea(0b100000,3848299531,0x2874133,-0x2a65),q else A=h>g and 0x6710/A or 0x101-A end elseif A>0x88 then if A>0b10100001 then A=p~=p and(j.Aa[0x6832]or j:Fa(0x88,0x7664,0x6832))or 0xc5-A else u={}A,u[1]=j.Aa[0x26d1]or j:Fa(0b100,0x7648,0x26d1),s u[0b10]=x f=u m[s]=f end elseif A>0b1110111 then A,i=j.Aa[-0x1ef4]or j:Ca(2337877471,0x7404d02e,-0x1ef4),z elseif A<0b111111 then A=p>0 and(j.Aa[0x2771]or j:Ea(0b1000000,0x731b5ba3,2359562378,0x2771))or 0xf42/A elseif A>0x3f then s=b[0b1010]f,u=m[s],nil A=f==u and(j.Aa[0x3d3f]or j:Ea(0b10000001,0x508b0882,2892235944,0x3d3f))or(j.Aa[0x26d1]or j:Ea(0,2341498689,0x706c0276,0x26d1))else A=p~=p and 0xad4/A or(j.Aa[-0x488]or j:Fa(0b1000,0x7676,-0x488))end elseif A>=0x22 then if A>0b110000 then if A<=0x34 then h=h+p A=p>0 and(j.Aa[0x2f82]or j:Ea(0b100000,3702860638,0x20a06e1,0x2f82))or(j.Aa[0x6cf9]or j:Ea(0,2646624760,0x62124409,0x6cf9))else x[y]=z k,h,z,y,g=w[0b11001],1,i,w[0b11011],q p=h A=g~=g and(j.Aa[0x6832]or j:Fa(0x80,0x7664,0x6832))or(j.Aa[-0x6437]or j:Fa(0x36,0x7642,-0x6437))end elseif A<=0x2c then if A<0x24 then a=a(y)k,z=0x12,_[0b1001]k,h,y,A,z=v,a,z-k,0x660/A,t[1][0b10][t[1][1]]elseif A>0b100100 then A=h<g and(j.Aa[0x6832]or j:Ca(0x6370d1bc,2282302601,0x6832))or(j.Aa[-0x333b]or j:Fa(0b11101,0x7675,-0x333b))else A,a[h]=0x750/A,f end else A,z=0xa80/A,z(k,h)end elseif A>0b11010 then if A<=0x1d then o,e,c,b=1,0b11100010,0b10100011,y[z]s,z,o=1,z+o,b[0b1001]A=o==s and 0b10010100-A or 0b11011101-A else A=h>g and(j.Aa[0x6832]or j:Ca(0x696799be,0x886689,0x6832))or(j.Aa[0x6cf9]or j:Ea(1,3003883644,0xcb0ac29,0x6cf9))end elseif A>0b1110 then A=p<=0 and 0x46-A or(j.Aa[-0x333b]or j:Ca(0x5b1de17f,2766282269,-0x333b))elseif A>0b1001 then y,h,g,z,k=n,nil,i,nil,nil return y,z,k,h,g else A=p<=0 and(j.Aa[-0x2727]or j:Ea(0b10100000,2651278226,0x605042e4,-0x2727))or 0b10110001-A end until false end end,function(a,b,c,d)a.Aa[d]=a.a(a.a(b,0xffff),a.a(0xffff,c))*a.b(a.a(b,0xffff),a.a(c,0xffff))+a.a(a.a(b,0xffff),a.d(a.a(0xffff,c)))*a.a(a.d(a.a(0xffff,b)),a.a(0xffff,c))-a.a(0xffff,c)*a.a(0xffff,b)+(b+-a.b(a.b(c,b),a.d(4294967295)))+c return a.Aa[d]end,function(j)return function(m,n,r,b,d,i,_)local a,k,h,c,f,e,q,l l=j.Aa[0x62ec]or j:Da(0x6c46e479,0x1219105a,0x11ff1a5,0x62ec)repeat if l>0x50 then a,q=0b101,_[0b1001]c,f,e=_[0b1010],q-a,0b10110 a,c=c-e,1 q=a==c l,r[f]=j.Aa[0x6cf9]or j:Fa(1,0x7665,0x6cf9),q elseif l<=0b1001 then c,q,e=_[0b10],b[0b11001],0x19 a=c-e l,f=j.Aa[0x25f]or j:Da(2868824404,0xdff3186,0x201d353,0x25f),q[a]a,q,k,h=f[1],f[0b10],_[0b10001],0b111100 else e=k-h c=r[e]q[a]=c q,k,a,e,c=n,i,nil,nil,nil return q,a,c,e,k end until false end end,function(j)local m,i,_,d,q,c,a,e,l,k,b,f,n,p l=0b10101100 repeat if l<0xac then if l>0b1110 then l,k=0b1110,table c,e,a=k.unpack,k.insert,k.pack a={[1]=0b11,[0b11]=a}a[0b10]=a c={[1]=0b11,[0b11]=c}c[0b10]=c e={[1]=0b11,[0b11]=e}e[0b10]=e k=j:w{n,m,p,b,d,i,q,a,f,_,c,e}else k=k()return k end elseif l>0xac then d={[1]=0b11,[0b11]=d}d[0b10]=d a=string i,_,q,f=a.sub,a.pack,a.rep,a.unpack i={[1]=0b11,[0b11]=i}l,i[0b10]=l+-0b1010100,i _={[1]=0b11,[0b11]=_}_[0b10]=_ f={[1]=0b11,[0b11]=f}f[0b10]=f q={[1]=0b11,[0b11]=q}q[0b10]=q else i=bit32 p,m,n,b,d=i.bor,i.bxor,i.band,i.lshift,i.rshift m={[1]=0b11,[0b11]=m}m[0b10]=m n={[1]=0b11,[0b11]=n}n[0b10]=n p={[1]=0b11,[0b11]=p}p[0b10]=p b={[1]=0b11,[0b11]=b}l,b[0b10]=0b11111111,b end until false end,function(j,t)return function(m,n,x,w,d,i,_)local y,c,g,f,u,B,q,a,v,b,s,e,h,k,o,p,z,A A=j.Aa[0x39d0]or j:Fa(0b10000000,0x76f0,0x39d0)while true do if A<=0x5a then if A<0x29 then if A<0b10101 then if A>0b100 then s=s(f,u)A,f,u=j.Aa[0x73bf]or j:Da(3665517695,0x32f4b36,0x1553733,0x73bf),t[0b10][0b10][t[0b10][1]],q else A=p<=0 and 0x2fc/A or 0x290/A end elseif A<0b10110 then A,f=0x30-A,j.h(f(u,B))elseif A<=0x16 then A=p>0 and(j.Aa[-0x7320]or j:Fa(0x21,0x7664,-0x7320))or(j.Aa[0x3bbf]or j:Ca(0x4e92f8ff,0x304c0192,0x3bbf))else A,o=A+0x15,j.h(o(s,j.i(f)))end elseif A>=0b1000100 then if A<0x46 then A=h<g and 0x9e-A or 0x1298/A elseif A>0x46 then A,y=j.Aa[0xe57]or j:Fa(0x64,0x76f2,0xe57),k else u,o,f,b,s=1,t[0b11][0b10][t[0b11][1]],z,t[1][0b10][t[1][1]],t[0b10][0b10][t[0b10][1]]A,u=A+-0b1000001,h+u end elseif A>0b101100 then b=b(j.i(o))A,k=0b10110111-A,k..b elseif A>0b101001 then A=p<=0 and(j.Aa[0xad6]or j:Da(0x14811edf,0x5e5aabd2,0x45181592,0xad6))or(j.Aa[0x5080]or j:Da(0x6ef619f7,0xe4bacb,0x101d2783,0x5080))else A=h>g and(j.Aa[0x4b0b]or j:Ca(2952177787,0x5000125e,0x4b0b))or A+0x69 end elseif A<0x9c then if A<0b10000111 then if A<=0x69 then e,B=#q,#q A,c=A+-0x54,h%e B=B-c else a=y[z]h,k,z=0,"",a[0x1c]b,o=#z,1 p,g=o,b-o A=g~=g and(j.Aa[0x4b0b]or j:Fa(0x48,0x7676,0x4b0b))or(j.Aa[-0x4b82]or j:Da(0x6a9ab0b6,0x378bfefc,0x48b8101b,-0x4b82))end elseif A<0b10010001 then h=h+p A=p>0 and 0x16b-A or(j.Aa[-0x18ff]or j:Ea(0b100,0x2b0e8152,0x4000484,-0x18ff))elseif A>0x91 then A=p~=p and 0b11010110-A or(j.Aa[0x7518]or j:Fa(0x24,0x7640,0x7518))else k[0b1111]=h h=0 k[0b1001]=h z=k a[y]=z h,k,y=1,i+v,w[0b11011]A,z=j.Aa[0x27bc]or j:Ca(0x78c4b08f,2167537906,0x27bc),k-h end elseif A<=0b10111111 then if A>0xa4 then A=h<g and 0x119-A or(j.Aa[0x5ce6]or j:Da(0x123febf5,0x4689f208,0x21760ea4,0x5ce6))elseif A<=0x9c then A,a,q=j.Aa[0x2d7]or j:Da(0x20b01595,0x5e13612e,0x3d3ae1cd,0x2d7),0b1101,_[0b1001]z,v,a,q=1,q-a,w[0x1b],_[0x1c]h,k,y=0b10,{},i-z else A=p~=p and(j.Aa[0x4b0b]or j:Ca(0x2f455adb,3222798462,0x4b0b))or 0x2cd8/A end elseif A<=0xe4 then A=h>g and(j.Aa[0x4b0b]or j:Da(4000934111,0xcaf1e17,0x4d36263,0x4b0b))or 0xe8-A else a[0x1c]=y g,y,h,z,k=i,n,nil,nil,nil return y,z,k,h,g end end end end,function(f,g)return function(c,e)local h,b,d,a a=0x17 while true do if a<0b1010001 then b,a,h=c,0b1010001,g[1][0b10][g[1][1]]elseif a<=0b1010001 then h=h(b)c,h=h,g[0b10][0b10][g[0b10][1]]b,a,d=c,0xc2,e else h=h(b,d)return h end end end end,function(j,g)return function(c,e)local h,i,b,a,d a=j.Aa[-0x2f2d]or j:Ca(3525602543,0x14203a7,-0x2f2d)repeat if a<0x7b then if a<=0b1000001 then d[0b100]=i i=g[0b1000][0b10][g[0b1000][1]]d[0b10111]=i i=g[0b10][0b10][g[0b10][1]]d[0b10110]=i i=g[1][0b10][g[1][1]]a,d[0x15]=j.Aa[-0x6eb6]or j:Ea(0b110000,0x12f1c79a,0xc0ac06b,-0x6eb6),i i=c[0b10][c[1]][0b1011]d[0b1011]=i else i,d=g[0b1001][0b10][g[0b1001][1]],{}d[0b11101]=i i=g[0b11][0b10][g[0b11][1]]d[0b110]=i i=g[0b110][0b10][g[0b110][1]]d[0b11]=i a,d[0b11001]=0x1e37/a,e i=g[0b111][0b10][g[0b111][1]]end elseif a<0xa7 then i=c[0b10][c[1]][0x1b]a,d[0b11011]=0x68be/a,i i=c[0b10][c[1]][0b1000]d[0b1000]=i b=d b={[1]=0b11,[0b11]=b}b[0b10]=b d={[1]=0b11,[0b11]=d}d[0b10]=d d[0b10][d[1]]=j:xa{g[0b101]}i=j:ya{b,d,g[0b11],g[0b100],g[0b1010],c,g[0b1001],h,g[0b110]}elseif a<=0b10100111 then c={[1]=0b11,[0b11]=c}c[0b10]=c d,b=0,{}b[0b1110]=d i={}a,d=j.Aa[-0xd7f]or j:Ea(0b110,2565142170,0x10b1077,-0xd7f),i b[0b101]=d h=b h={[1]=0b11,[0b11]=h}h[0b10]=h else return i end until false end end,function(j,t)return function(...)local r,n,s,c,h,l,b,p,q,e,d,_,f,a,g,i,m l=j.Aa[0x7907]or j:Fa(0x24,0x766d,0x7907)while true do if l<0b1101101 then if l<=0x2d then if l>0x25 then i,q,d,f,_,l,c=t[1][0b10][t[1][1]],t[0b101][0b10][t[0b101][1]],t[0b10][0b10][t[0b10][1]],s,n,l+0b1001011,{}c,a=t[0b100][0b10][t[0b100][1]],c elseif l<0x15 then l=l+0b11010100 elseif l>0b10101 then l,m,g,n,h=j.Aa[-0x57e]or j:Da(3961115631,0xde13d19,0x324c754,-0x57e),t[0b1001][0b10][t[0b1001][1]],0x9c,j.h(...),0b11101000 else d=j.h(d(i,_,f,j.i(q)))return j.i(d)end elseif l<=0b110001 then l=j.Aa[-0x29dc]or j:Ca(3890830367,0x6a275,-0x29dc)else l,n=j.Aa[0x1ef7]or j:Fa(0xca,0x76e6,0x1ef7),n(r)s=t[0b110][0b10][t[0b110][1]]r=s[0b10100]end elseif l>0b11001010 then if l<=0b11011111 then if l<=0b11010101 then _,f,s,q,e,c=t[0b111][0b10][t[0b111][1]],m,_,d,1,d+i c,e,a=e,s[0b101],c-e l=h>g and(j.Aa[0x3bd]or j:Fa(0,0x767d,0x3bd))or(j.Aa[0x30a5]or j:Ca(0x642958ff,2471765037,0x30a5))else s(d,i,_,f,q)s,d=t[0b1000][0b10][t[0b1000][1]],m.n l=r<d and(j.Aa[0x448c]or j:Ca(4220188099,0x2508e4,0x448c))or(j.Aa[0x30a5]or j:Ca(3442604287,0x1286002d,0x30a5))end else l=l+-0xb8 _(f,q,a,c,e)end elseif l>=0b11000000 then if l>0xc0 then p,i,d,s,b,_=0b1001010,1,m,t[0b111][0b10][t[0b111][1]],0x2e,r f,l,q=i,0b110101001-l,n else i=1 _,d=m.n,r+i q,i,_={},_-r,{}f=q _[0b101]=f l,_[0b1110]=0x9fc0/l,i end elseif l<=0x6d then l,m=0x2210/l,m(j.i(n))r,n=t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]r=r[0b1100]else q=j.h(q(a,c))l=p<=b and 0b10011101-l or(j.Aa[0x290b]or j:Da(3418163967,0x15d2a54,0x22e389dd,0x290b))end end end end,function(_,a)return function(A,G,B,x)local v=a[1][0b10][a[1][1]]local n=A[0x1b]local F=A[0x15]local K,L=1,-1 while true do local D=n[K]K+=1 local N,J,I,E,M=v[D[0b1111]](x,L,G,A,B,K,D)if E then return F(G,I,I+J-1)end K,L=M,N end end end,function(j,t)return function(m,n,x,w,d,i,_)local q,E,C,a,z,b,r,y,s,g,u,v,c,B,A,o,f,p,D,h,l A=j.Aa[0x4bbb]or j:Ea(0,0x12156da4,3387056270,0x4bbb)repeat if A>=0x6f then if A>0xac then if A>0b11011001 then if A>0b11101111 then A=h>g and(j.Aa[-0x47d2]or j:Da(0x3944c97f,0x24ae712e,2710213441,-0x47d2))or(j.Aa[0xfc7]or j:Ca(3114926552,0x14f85c,0xfc7))else A=p>0 and(j.Aa[-0x2e9a]or j:Ea(0b110001,0x2256e2da,0x28cfcf,-0x2e9a))or 0b100101011-A end elseif A<0b11001000 then A=h>g and(j.Aa[-0x47d2]or j:Ea(0x4e,0x1a7e2a82,0x1010525,-0x47d2))or A+-0b10000011 elseif A<=0b11001000 then A,E=j.Aa[-0x1050]or j:Ca(0x744b064,0x2093496b,-0x1050),E..C else A,f=j.Aa[0x4783]or j:Ea(0b10100100,0x62b7098f,2433220780,0x4783),f(u,B)u=0b100000000 u=h%u end elseif A<0b10000100 then if A<=0b1110101 then if A>0x6f then a[0x1c]=y E,h,g,z,y=nil,nil,i,nil,n return y,z,E,h,g else y=E A=b<=s and A+0x11 or 0b11100100-A end else a,q=0b111,_[0b1001]a,A,z,q,v=w[0b11011],j.Aa[0x781e]or j:Ca(2953564045,0x491030e4,0x781e),1,_[0x1c],q-a E,h,y={},0b10,i-z end elseif A<0x98 then E[0b1111],l,r=h,0b1111,0b1100100 A,h=0b11011001-A,0 E[0b1001]=h z=E a[y]=z h,y,E=1,w[0x1b],i+v z=E-h elseif A>0x98 then A,o=0x408/A,j.h(o(D,f,u))else c=#q B,c=h%c,1 A,B=0x171-A,B+c end elseif A>=0b111111 then if A<=0b1011000 then if A>=0x55 then if A>0b1010101 then A=p<=0 and A+-0x19 or(j.Aa[0x67bb]or j:Ca(0x33265a5b,0x4449a51c,0x67bb))else b,a,s=0b11110100,y[z],0xc1 h,z,E=0,a[0x1c],""C,o=#z,1 p,g=o,C-o A=g~=g and 0x24db/A or(j.Aa[0x4841]or j:Da(0x274d3def,0x6610250e,0x22209df1,0x4841))end elseif A<=0x3f then A=h<g and(j.Aa[-0x47d2]or j:Fa(0b1101000,0x7603,-0x47d2))or(j.Aa[0x67bb]or j:Fa(0b10000,0x7674,0x67bb))else A=p<=0 and 0xfcf/A or A+0x1d end elseif A<=0b1100000 then h=h+p A=p>0 and 0b101010110-A or 0x2100/A else C,A,u,D,o,f=t[1][0b10][t[1][1]],0x99-A,1,t[0b10][0b10][t[0b10][1]],t[0b11][0b10][t[0b11][1]],z u=h+u end elseif A<=0b110101 then if A>=0x18 then if A>0b11000 then D=D(f,u)f,u=t[0b10][0b10][t[0b10][1]],q A=l<r and A+0x63 or 0x8a-A else A=p~=p and(j.Aa[-0x47d2]or j:Ca(0x1020236f,3813183615,-0x47d2))or(j.Aa[0xc40]or j:Ea(0x40,0x69964948,2517172452,0xc40))end else A,C=0x4b0/A,C(j.i(o))end elseif A<=0x39 then A=h<g and(j.Aa[-0x47d2]or j:Ca(0x11958aef,3894551935,-0x47d2))or(j.Aa[0xc40]or j:Da(4041587318,0x979658,0x806e0d,0xc40))else A=p~=p and A+-0b11 or 0x10a4/A end until false end end,function(j)return function(m,n,p,b,d,i,_)local e,g,l,c,f,a l=j.Aa[0x2771]or j:Fa(0xc0,0x76ae,0x2771)repeat if l<0xc2 then c,f,e,g,a=nil,n,i,nil,nil return f,g,a,c,e else g,a=_[0b1001],0x22 e,f,c=0b111011,g-a,_[0b1010]a,c=c-e,1 l,g=j.Aa[-0x3417]or j:Ca(3297583102,0x385260af,-0x3417),a==c p[f]=g end until false end end,function(j)return function(m,n,r,s,d,i,_)local p,b,e,l,c,h,a,q,k,g,f l=j.Aa[0x78ca]or j:Ea(0x40,2281693719,0x5000ef70,0x78ca)repeat if l>0x70 then if l>=0xac then if l>0xac then l,p=0x6dfe/l,j.h(p(b))else k=k(h,g,j.i(p))_[0b10001]=k l,r[f]=0/l,k end else l=j.Aa[0x4783]or j:Ca(0x15e6e3ff,0x6a0808ac,0x4783)end elseif l<=0b1011110 then if l>=0x54 then if l>0x54 then l,a=0x5e-l,_[0x11]r[f]=a else e,k,a,c=r[q],j.v,_[0x1c],_[0b11110]g,l,p,h,b=c,0x510c/l,j.y,a,e end else e,h,a,k,c=nil,i,n,nil,nil return a,c,e,k,h end else c,a=0b100010,_[0b1001]c,a,f=0b10110,_[0b1010],a-c c,q,a=0,a-c,_[0b10001]l=a==c and(j.Aa[-0x5285]or j:Ca(0x481777d4,2761949302,-0x5285))or(j.Aa[-0x607e]or j:Fa(0b10,0x7630,-0x607e))end until false end end,function(j)local B,y,s,ea,J,ba,V,k,da,H,g,n,X,E,d,L,b,l,A,w,q,P,v,_,u,z,m,o,a,ca,t,r,K,S,Q,F,T,i,Y,f,e,N,C,c,p,x,I,O,R,U,aa,h,D,G A=j.Aa[-0x656d]or j:Ea(0xa0,2387068510,0x31900050,-0x656d)repeat if A>=0b10000001 then if A>=0b10111000 then if A<0b11011000 then if A>=0xc7 then if A>0b11000111 then A=h<g and(j.Aa[0xad6]or j:Ca(0x38f8c945,2248221820,0xad6))or(j.Aa[-0x768a]or j:Ea(0,0x27c3ba9a,2285151311,-0x768a))else u,aa,ea,m,Q,G,ba,B,l,d,F=0b10011,0b111010,0b110000,0x29,0b10011,0xdb,0b1000,0x22,0b11100,0b110,0b100 A=L<F and 0b101100110-A or(j.Aa[-0x4ad7]or j:Da(0x77e9bbfb,0x2229290,0x5e17261,-0x4ad7))end elseif A<=0b10111000 then A=E<=0 and(j.Aa[0x4b0b]or j:Da(2777031674,0x1e64a46b,0x3be4f3ef,0x4b0b))or A+0x2b else ea=0x1a h[0b100111],h[0x22],h[0b101000],h[0b100101],h[0x23],h[0b100001],h[0b100100],h[0b100110]=u,E,ea,ba,w,g,B,F g,h,H=#I,1,h E=h A=g~=g and(j.Aa[0xad6]or j:Fa(0b100,0x762c,0xad6))or 0x7a76/A end elseif A>0b11100011 then if A<=0b11100110 then A=h>g and(j.Aa[0xad6]or j:Da(3675796694,0x1c0b38b7,0x8d8c9ad,0xad6))or(j.Aa[-0x3ccb]or j:Da(0x74f144fa,0x36b410e2,0x514ff7d7,-0x3ccb))else t,c=1,0b10 I[0b1111],I[0b1100],I[0b111],I[1],I[0b11],I[0b1000],I[0b1101],I[0b1010],I[0b1001],I[0b101],I[0b110],I[0x10],I[0b1011],I[0b10],I[0b1110],I[0b100]=c,aa,ba,H,g,F,d,ea,u,w,B,t,m,h,l,E B,w,H,g,A,h,E=0x32,0b101,0b10111,0b100100,j.Aa[0xfd6]or j:Da(0x5a42ec7e,0x2348e93,0x30074ec,0xfd6),0x2c,0b11 end elseif A>=0xdf then if A>0xdf then A=E~=E and(j.Aa[0xad6]or j:Ca(0x11fba457,0x620419ec,0xad6))or(j.Aa[-0x768a]or j:Ea(0b1001001,3872160050,0x81010ce,-0x768a))else d,A,t,l,u,Q,aa,ea,L,m,c,F=j:V(),j.Aa[-0x6f68]or j:Da(0x77c504bf,0x7ad36c6,0x8b9c2c,-0x6f68),j:ba(),j:ta(),j:U(),0b100011,j:K(),j:ia(),0b11011011,j:Q(),j:aa(),j:_a{s}end else L,Q,v=0b10001001,0b10000100,0x16 h[0b100000],h[0b11100],h[0x1b],h[0x11],h[0b10110],h[0x1f],h[0b11110],h[0b10101],h[0x1d],h[0b10111],h[0b11000],h[0b10100],h[0x12],h[0b11001],h[0b11010],h[0b10011]=v,l,d,g,F,p,t,ba,c,u,ea,B,E,m,aa,w B,ba,u,A,w,F,E,g=0b1010,0b11111,0x1d,j.Aa[-0x5379]or j:Da(2279358654,0x60e6fcee,0xf1a8711,-0x5379),0b11100,0b110,0b11110,0b11 end elseif A>=0xa5 then if A>0b10110000 then if A<=0b10110001 then e,Q=U[j.Aa[-0x17de]or j:Ba(j.q"ic1BLUKs",j.q"<~VH",-0x17de)],0x9d e={[1]=0b11,[0b11]=e}e[0b10]=e U={[1]=0b11,[0b11]=U}U[0b10]=U b,U[0b10][U[1]]={},j:da{D,o,f,y,R,e,S,V}r=b r={[1]=0b11,[0b11]=r}A,r[0b10]=0x348c/A,r b=j._ b={[1]=0b11,[0b11]=b}b[0b10]=b else p=j:oa()H[0x1c],H[0x17],H[0x1b],H[0x15],H[0x11],H[0b10100],H[0x18],H[0x16],H[0x20],H[0x1e],H[0b10010],H[0x1d],H[0b11111],H[0x13],H[0b11001],H[0b11010]=d,F,aa,B,h,w,u,ba,p,c,g,l,t,E,ea,m E,ba,F,h,B,g,w=j:P(),j:va(),j:ka(),j:ja(),j:qa(),j:pa(),j:ca()A=Q<L and(j.Aa[-0x2643]or j:Ea(0x8f,2237018762,0x122010ad,-0x2643))or(j.Aa[0xad6]or j:Ca(0xdd32044,2451607125,0xad6))end elseif A>0xaf then R=j R={[1]=0b11,[0b11]=R}R[0b10]=R n,x,_,T,N,i,Y=j._[j.Aa[-0x2d87]or j:Ba(j.q"!~nn?",j.q"uz3",-0x2d87)],j._[j.Aa[-0x2096]or j:Ba(j.q"VjXi5eg",j.q"5`F",-0x2096)],j._[j.Aa[0x4b33]or j:Ba(j.q"W;AMWGI9",j.q"6;TE",0x4b33)],j._[j.Aa[-0x1fae]or j:Ba(j.q"rmBVhzo(A*",j.q"(#7kG",-0x1fae)],j._[j.Aa[0x29fa]or j:Ba(j.q"r!BBBum",j.q"!e0",0x29fa)],j._[j.Aa[0x1a9b]or j:Ba(j.q"(|XEj&;",j.q"qZ<",0x1a9b)],j._[j.Aa[0x798b]or j:Ba(j.q"Yu{ZpEJS(ENIE4|",j.q"7`iD~NiY",0x798b)]A,Y=j.Aa[-0x7320]or j:Ca(2970058221,0x42d00029,-0x7320),{[1]=0b11,[0b11]=Y}Y[0b10]=Y elseif A>0xa5 then u,Q=j:L(),0x2b H[0b100001],H[0x27],H[0b101000],H[0b100010],H[0x23],H[0b100101],H[0b100100],H[0b100110]=h,F,u,g,E,B,w,ba E,h,ba,w,B,g,I=0b1000,{},0b11011,0b1100,0b100011,0b10000,H A=K<E and(j.Aa[-0x2643]or j:Da(0xa6f32bf,0x559516b6,0x2eeaf739,-0x2643))or 0x627/A else A=E>0 and A+-0xa0 or A+-0x2f end elseif A<0x99 then if A>0x81 then p,v=0b1001,0x13 h[0b1001],h[0b1100],h[0b11],h[0b10],h[0b1110],h[0b1000],h[0b110],h[0b100],h[0b1011],h[0b101],h[1],h[0x10],h[0b1101],h[0b1010],h[0b111],h[0b1111]=m,l,w,E,t,ea,F,B,d,ba,g,v,c,aa,u,p w,B,ba,F,g,E=0b1011,0b111,0x14,0b1110,1,0x26 A=L<ba and(j.Aa[-0x656d]or j:Da(0x5ae7c7bd,0x44abd5b,0xb55357,-0x656d))or 0x24d1/A else L,K,Q,ca=0b10001111,0b10000010,0b1111,z z=ca[j.Aa[0x6b51]or j:Ba(j.q"`5*5C",j.q"n`Q",0x6b51)]z={[1]=0b11,[0b11]=z}z[0b10]=z da=ca ca=da[j.Aa[0x6ce]or j:Ba(j.q"Fo!ao",j.q"Q||",0x6ce)]ca={[1]=0b11,[0b11]=ca}ca[0b10]=ca A,J=j.Aa[-0x29dc]or j:Ca(0x49a459b5,0x2180417,-0x29dc),da da,X=J[j.Aa[0x7a0d]or j:Ba(j.q"T>Gp~^`!",j.q"JC@A",0x7a0d)],j._[j.Aa[0x1c87]or j:Ba(j.q"FKjtsJ^",j.q"TMY",0x1c87)]end elseif A<=0x99 then O=S[j.Aa[0x6b0b]or j:Ba(j.q"*z48d",j.q"x|0",0x6b0b)]O={[1]=0b11,[0b11]=O}O[0b10]=O V=S S=V[j.Aa[-0x1629]or j:Ba(j.q"1F;XZ",j.q"VbA",-0x1629)]S={[1]=0b11,[0b11]=S}S[0b10]=S e=V V=e[j.Aa[-0x5872]or j:Ba(j.q"jOB~sng",j.q"?vV",-0x5872)]V={[1]=0b11,[0b11]=V}V[0b10]=V U=e A=Q>=L and A+0x18 or(j.Aa[-0x5379]or j:Da(0x38be2dfe,0x2163cc7d,0x23dcf641,-0x5379))else p,t=j:O(),j:ra()H[0b1100],H[0b1011],H[0x10],H[0b111],H[0b10],H[0b110],H[0b1111],H[0b100],H[0b101],H[0b11],H[0b1000],H[1],H[0b1010],H[0b1001],H[0b1110],H[0b1101]=d,aa,p,F,g,ba,t,w,B,E,u,h,m,ea,c,l B,h,E,A,ba,g,w=j:ha(),j:G(),j:S(),A+0b1000000,j:sa(),j:na(),j:ga()end elseif A<=0x41 then if A<=0x27 then if A>=0b1001 then if A>0x15 then h=h+E A=E>0 and(j.Aa[0x4294]or j:Ca(2552197119,0x600080e6,0x4294))or(j.Aa[-0x3ccb]or j:Ca(0x5321cfa,2189476540,-0x3ccb))elseif A>0b1001 then J=X[j.Aa[-0xf4d]or j:Ba(j.q"s#LLF",j.q"$2$",-0xf4d)]J={[1]=0b11,[0b11]=J}J[0b10]=J C=X X=C[j.Aa[0x4518]or j:Ba(j.q"#sk#}",j.q"wqg",0x4518)]X={[1]=0b11,[0b11]=X}X[0b10]=X o=C C=o[j.Aa[0x61f2]or j:Ba(j.q"9Q`E-@IC",j.q"X_Hj",0x61f2)]C={[1]=0b11,[0b11]=C}C[0b10]=C D=o A=Q>=L and A+0x12 or(j.Aa[-0x7bf]or j:Da(0x4c730f47,0x141cdb6,0x1ec26259,-0x7bf))else c,l,t,L,aa,d,u,ea,m,F=0b100001,0b10001,0b100111,0x33,0b101000,0b101,0b10010,0b11000,0x20,0b100 A=Q<l and 0x55-A or(j.Aa[0x2d7]or j:Ea(0b10001,0x3e55e5fa,2173356161,0x2d7))end elseif A>0b101 then Q,L,o=0b1100,1,D[j.Aa[-0x2f44]or j:Ba(j.q"o+LG#A~g",j.q"{Z>!",-0x2f44)]o={[1]=0b11,[0b11]=o}o[0b10]=o f=D A,D=0b10100000-A,f[j.Aa[0x4dfe]or j:Ba(j.q"0MpV8&(#",j.q"X}zH",0x4dfe)]D={[1]=0b11,[0b11]=D}D[0b10]=D O=j._[j.Aa[-0x42cd]or j:Ba(j.q"UaCm&4g",j.q"Ji`",-0x42cd)]f=O[j.Aa[-0x189]or j:Ba(j.q"sie6",j.q"%K",-0b110001001)]f={[1]=0b11,[0b11]=f}f[0b10]=f S=O else A=h>g and(j.Aa[0xad6]or j:Ea(0x40,0x67dc8cb8,2416083012,0xad6))or A+0b1110001 end elseif A<=0b1000000 then if A<0x2c then q,z,A,y=j._[j.Aa[-0x4be5]or j:Ba(j.q"Ewy<RODij+Y#Ty4",j.q"O3)2?E?)",-0x4be5)],j.Aa[-0x2830]or j:Ba(j.q"n4J",j.q"?f",-0x2830),0xaa-A,{}y[j.Aa[-0x7b86]or j:Ba(j.q"dn?^b5Y+",j.q"By_L",-0x7b86)]=z a=y a={[1]=0b11,[0b11]=a}a[0b10]=a z=j._[j.Aa[0x769b]or j:Ba(j.q"sgK^XmCF",j.q"+WV{",0x769b)]y=z[j.Aa[0x61f2]or j:Ba(j.q"!pTe4#83",j.q"x2HP",0x61f2)]y={[1]=0b11,[0b11]=y}y[0b10]=y elseif A>0x2c then A=E<=0 and 0x3340/A or 0b10001111-A else l,ba,u,d,A,F,aa,m,c,ea=j:fa(),j:J(),j:Y(),j:wa(),j.Aa[-0x3e01]or j:Ca(0x271983ff,3632430239,-0x3e01),j:ua(),j:ma(),j:la(),j:N(),j:X()end else d,ea,c,p,m,u,l,aa,t=0b100100,0x15,0x22,0x19,0x17,0x25,0b1101,0b10,0b1111 A=G<=d and(j.Aa[-0x6f68]or j:Ca(0x7116a0f2,2185255346,-0x6f68))or(j.Aa[-0x1369]or j:Da(3469550815,0x130fb8a7,0xe129231,-0x1369))end elseif A<=0x63 then if A>0b1001111 then if A<=0b1011010 then A=h<g and 0x17e8/A or(j.Aa[0x3c42]or j:Fa(0x43,0x768d,0x3c42))else t=0x35 I[0x1f],I[0b10100],I[0b11011],I[0b10010],I[0x1e],I[0b10110],I[0x15],I[0b11000],I[0b10011],I[0x1c],I[0x20],I[0x1a],I[0b11001],I[0b10111],I[0x1d],I[0b10001]=c,E,m,h,l,B,w,F,g,aa,t,ea,u,ba,d,H E,w,h,g,B,ba,H=0x25,0x18,0x15,0b1101,0b111,0x19,0b1011 A=Q<E and(j.Aa[-0x2682]or j:Da(0x16f1857c,0x602489b1,0x20dddf44,-0x2682))or(j.Aa[-0xc75]or j:Da(4012525177,0x2ddc04,0xa334bf,-0xc75))end elseif A<=0x4c then if A<=0x44 then return k else L,s=0xed,j:W{C,R,o,a,r,X,O,b,J,Y}s={[1]=0b11,[0b11]=s}s[0b10]=s w,I,h,k,g,H,E=0b110111,{},0b101000,j:T{U,s},0b1111,0b10110,0b111011 A=Q>g and 0x3b14/A or 0x75-A end else B=H[h]B,w=I[h],P[B]r[0b10][r[1]][w]=B A=Q>L and(j.Aa[0x4ca5]or j:Da(3047759327,0x18ff585,0x840b5a,0x4ca5))or(j.Aa[-0x55a7]or j:Fa(0b100,0x764b,-0x55a7))end elseif A>0b1110110 then F,u,A,m,aa,c,d,l,ba,L,ea=0x45,0b100110,j.Aa[0x1349]or j:Ca(0x2e648263,3516487159,0x1349),0b10100,0b1000011,0b1001,0b110011,0x10,0b1110,0b11001111,0b101111 elseif A>0b1110100 then A=E~=E and 0b101000011-A or(j.Aa[0x3bb3]or j:Da(0x67c874c7,0x7e225c0,0x844dba0,0x3bb3))else F=0 I[0b101000],I[0x24],I[0b100011],I[0b100111],I[0x25],I[0x22],I[0x26],I[0b100001]=F,E,g,ba,w,h,B,H g,h,B,H,P,E,w=j:ea{ca,z,O},j:H{ca,z,O},j:I(),{},I,j:R(),j:M()A=L<=F and A+0b1101 or 0xa0-A end until false end,function(j)return function(m,n,x,w,d,i,_)local h,l,k,a,g,p,u,c,s,e,q,b,o,f,v l=j.Aa[-0x4193]or j:Ca(3181869299,0x21086b3,-0x4193)repeat if l>=0xaa then if l>=0xb3 then if l>=0xbc then if l<=0b10111100 then l,c=j.Aa[-0x4a2f]or j:Ea(0x34,0x3b0959b,3426943153,-0x4a2f),n-v else g=1 l,h=j.Aa[0x2f82]or j:Da(2403494077,0xe6a0be4,0x2252893f,0x2f82),a-g end elseif l<=0xb3 then l,u,e,c=j.Aa[-0x7bf]or j:Ca(0x49895cc7,2251596039,-0x7bf),0x94,0b110110,_[0b1001]c,e,v=_[0b1010],0x19,c-e c,q,e=_[0b10001],c-e,0x1e a=c-e else l=c and(j.Aa[0x4783]or j:Ca(4253755119,0x20448bc,0x4783))or(j.Aa[0xc40]or j:Ea(0x24,0x1a6480b0,0x45128562,0xc40))end elseif l>0b10101101 then o,b,s=nil,nil,i return g,p,b,o,s elseif l>0b10101100 then k=k(j.i(h))h,g=k.n,0 l=a==g and 0b100101010-l or(j.Aa[0x4294]or j:Da(0x2a1b55f6,0x643ffa73,0x6c242674,0x4294))elseif l>0xaa then l,k,e=j.Aa[-0x4b0d]or j:Fa(0xa0,0x7646,-0x4b0d),w[0b11],x[v]h,g,p,o=e,w[0x15],x,1 o,b=v+c,v+o else l,g=0x703a/l,j.h(g(p,b,o))end elseif l<0b1100100 then if l>0x37 then l,h=j.Aa[-0x5de9]or j:Ea(0x85,3377132936,0x1284383d,-0x5de9),j.h(h(j.i(g)))elseif l>0b100001 then o,s,g=_[0x12],0b1011,p-b b,o=o-s,1 p=b==o l,x[g]=j.Aa[-0x656d]or j:Da(0x3f2c1eff,0x20d264,0xa18f4c,-0x656d),p p,g=nil,n elseif l>0b111 then b,p,f,s,l,g,o=1,k,x,v,0b10100100-l,w[0b11101],h else e=0 c=q==e l=c and l+0xb5 or(j.Aa[-0x4a2f]or j:Fa(0,0x76d8,-0x4a2f))end elseif l<=0b10000011 then if l<0x7d then e=1 c=q-e l=u>e and l+0x48 or(j.Aa[0x5342]or j:Da(0x2ea285a9,2839814477,0x2804275e,0x5342))elseif l<=0b1111101 then g,l,p=v+h,0x101d/l,1 n=g-p else l=j.Aa[-0x641b]or j:Ea(0b110000,0x513c7092,2147634487,-0x641b)g(p,b,o,s,f)b,p=0b110111,_[0b10]end else l=j.Aa[0x39c6]or j:Ca(0x365e16fe,2166483279,0x39c6)end until false end end,bit32.bor,function(j)return function(m,n,r,s,d,i,_)local l,c,k,f,a,p,q,h,e l=j.Aa[0x3c42]or j:Fa(0x43,0x76ce,0x3c42)while true do if l<0b11100110 then if l>0xa6 then c,q,l,e,p=_[0b1010],s[0b11001],j.Aa[0x7ec4]or j:Ca(2591989694,0x218140a6,0x7ec4),0x3f,0xe3 a=c-e f=q[a]a,h,k,q=f[1],0x17,_[0b1001],f[0b10]else e=k-h c=r[e]q[a]=c e,k,a=_[0b10],0x13,s[0x19]c=e-k q,c=a[c],_[0x11]l=p<=k and(j.Aa[0x4294]or j:Da(0x651054f6,0x30cbe909,0x67b739e6,0x4294))or 0xa21c/l end elseif l>0b11100110 then e=0x3e l,k,e,a=0b111100000-l,q[1],q[0b10],c-e c=e[k]r[a]=c c,a,e=nil,n,nil else k,h=nil,i return a,c,e,k,h end end end end,function(f)local d,b,h,a,e,c a=0xd8 repeat if a>=0xd8 then h=string c,e=h.char,h.gsub a,c=0x63,{[1]=0b11,[0b11]=c}c[0b10]=c e={[1]=0b11,[0b11]=e}e[0b10]=e d=bit32 else h,b=d.rshift,d.band h={[1]=0b11,[0b11]=h}h[0b10]=h b={[1]=0b11,[0b11]=b}b[0b10]=b d=f:r{h,b,c,e}return d end until false end,function(j,k)return function(c)local b,e,h,i,_,d,l,f l=0x48 while true do if l<0b1111001 then if l<0b1010111 then b,h=0b101,#c h,e=0,h%b l=e>h and 0x57 or 0x79 elseif l>0b1010111 then b,h=h,h.sub h=j.h(h(b,d,i))return j.i(h)else d,h=0b101,"~"b,h,l,d=h,h.rep,0b1111001,d-e h=h(b,d)c=c..h end elseif l<0xc0 then if l>0b1111001 then l,i=l+-0x38,-1 else h,d,b,i=k[0b100][0b10][k[0b100][1]],".....",c,j:s{k[0b11],k[0b10],k[1]}h=h(b,d,i)i,d=0,1 i=e>i l=i and 0b11111101 or 0xc0 end elseif l<=0xc0 then l=i and 0b1101110 or l+-0x1a else f=0b101 _=f-e i,_=-_,1 l,i=0b110111101-l,i-_ end end end end,function(j)return function(m,n,p,b,d,i,_)local g,f,c,a,l,e l=j.Aa[0x6a9b]or j:Da(0x6df07bfb,0x46b54b34,0x4b4eb98f,0x6a9b)repeat if l<0xc3 then e=i return f,g,a,c,e else g,a=_[0b1001],0x1a g,f=_[0x1c],g-a l,p[f]=j.Aa[-0xfc5]or j:Fa(0b100111,0x7664,-0xfc5),g f,a,c,g=n,nil,nil,nil end until false end end,function(j,k)return function(c,e)local b,h,_,f,i,a,d a=0xa8 repeat if a>=0b11001000 then if a<=0b11010100 then if a<=0b11001000 then i=i(_,f)a,_=a+0b1100,4294967295 else d=j.h(d(i,_))return j.i(d)end else b=b(d,i)a,d,i=0x6668/a,k[0b10][0b10][k[0b10][1]],k[1][0b10][k[1][1]]end elseif a<=0b10011111 then if a>0x71 then h=h(b,d)i,d,b=0b100000,c,k[0b11][0b10][k[0b11][1]]a,i=0xe8,i-e else a,_,f=0xc8,h,b end else h,a,d,b=k[0b100][0b10][k[0b100][1]],0b10011111,e,c end until false end end,h=function(...)return{[1]={...},[0b10]=select("#",...)}end,getfenv(),function(j)return function(m,n,p,b,d,i,_)local g,a,f,c,l,e l=j.Aa[-0x5de9]or j:Da(0x50f822ef,0x3308e483,0x55f92d3a,-0x5de9)repeat if l>=0xad then a,g=0x3c,_[0b1001]l,g,f=j.Aa[-0x29dc]or j:Da(0x6a70ebd,0x5e0aed59,0x245e2bc,-0x29dc),nil,g-a p[f]=g a,g=0b1001,_[0b1010]g,f=nil,g-a else p[f]=g a,g,f,c,e=nil,nil,n,nil,i return f,g,a,c,e end until false end end,function(j)return function(m,n,p,b,d,i,_)local e,l,f,g,a,c l=j.Aa[-0x3ccb]or j:Ea(0xb8,0x48954316,2751596680,-0x3ccb)repeat if l>=0xb8 then a,l,g=0x15,j.Aa[0x4459]or j:Ca(4107943351,0xa25c034,0x4459),_[0b1001]e,f,c=0b11000,g-a,_[0b1010]a=c-e g=p[a]p[f]=g f=n else c,g,e,a=nil,nil,i,nil return f,g,a,c,e end until false end end,function(j)return function(m,n,r,w,d,i,_)local p,e,o,s,l,v,b,f,g,h,c,k,a,q l=j.Aa[-0x4b0d]or j:Da(0x552642ea,0x916a48a,2537122097,-0x4b0d)repeat if l<=0b10000011 then if l<0x3f then if l>0x17 then g=1 l,h=j.Aa[-0x6c63]or j:Fa(0x48,0x76ac,-0x6c63),a-g elseif l>=0b1001 then if l<=0b1001 then k=k(j.i(h))h,g=k.n,0 l=a==g and(j.Aa[-0x3e01]or j:Da(0x36486e9f,2160000590,0x47f79371,-0x3e01))or(j.Aa[0x7907]or j:Ca(0x624531ef,2501430837,0x7907))else o,b,s=nil,nil,i return g,p,b,o,s end else l=c and(j.Aa[0x567b]or j:Da(0x5dd569d,0x113e2fc0,2428762377,0x567b))or 0x28f/l end elseif l<=0x61 then if l<=0b1010000 then if l>0b111111 then l=0x730/l g(p,b,o,s,f)g,p=n,nil else l=0xa0-l end else l,h=l+-0b1011000,j.h(h(j.i(g)))end else e=1 l,c=j.Aa[0x567b]or j:Ea(0,3212513482,0x8c9,0x567b),q-e end elseif l<=0b11001000 then if l<=0xaa then if l<0b10011111 then k,e=w[0b11],r[v]p,o,g,l,h=r,1,w[0x15],l+0b1110010,e o,b=v+c,v+o elseif l>0b10011111 then e,v,c=0x2d,_[0b1001],_[0b1010]q,c,e=c-e,_[0b10001],0b11110 a,e=c-e,0 c=q==e l=c and(j.Aa[0x732]or j:Ca(0x4a3eb3fc,0x104108d1,0x732))or(j.Aa[0x449d]or j:Fa(0,0x7669,0x449d))else l,g,p=0x167-l,v+h,1 n=g-p end else f,o,b,p,s,l,g=r,h,1,k,v,0x3e80/l,w[0x1d]end elseif l>0xd0 then l,g=0b100111010-l,j.h(g(p,b,o))else l,c=0b11010101-l,n-v end until false end end,function(j)return function(m,n,p,b,d,i,_)local f,g,a,e,c e,a,c,g,f=i,nil,nil,nil,n return f,g,a,c,e end end,function(j)return function(m,n,p,b,d,i,_)local a,f,c,g,e g=_[0b11111]f,g=i+g,0b100 g,i,a,c,f=nil,f-g,nil,nil,n e=i return f,g,a,c,e end end,function(j)return function(m,n,p,b,d,i,_)local l,q,f,a,e,k,c l=j.Aa[0x1200]or j:Ea(0b10011000,0x465ff59a,0x292068fa,0x1200)while true do if l<0b11111010 then a,c,e,q,f=nil,nil,i,nil,n return f,q,a,c,e else q,a=_[0b1001],0b110 f,k,l,e=q-a,0x23,j.Aa[-0x3d2]or j:Da(0x3f5f7bfa,0x107099,0x7ff00fd6,-0x3d2),_[0b1010]c=e-k a=p[c]q=not a p[f]=q end end end end,function(a,b,c,d,e)a.Aa[e]=a.d(a.b(a.d(a.a(4294967295,d+c)),a.d(b)))+(a.b(a.a(d,0xffff),a.a(0xffff,b))*a.a(a.a(0xffff,d),a.a(b,0xffff))+a.a(a.a(0xffff,b),a.d(a.a(d,0xffff)))*a.a(a.d(a.a(0xffff,b)),a.a(d,0xffff))-a.a(0xffff,d)*a.a(b,0xffff))return a.Aa[e]end,bit32.bnot,function(j)return function(m,n,p,b,d,i,_)local a,l,f,e,g,c l=j.Aa[-0x3d5d]or j:Da(0x2b7c27fe,0x9c28a8f,0x46be7648,-0x3d5d)repeat if l>=0xd6 then if l<=0b11010110 then a,g=0b1111,_[0b1001]a,c,f=_[1],0b1010,g-a l,g=j.Aa[0x2313]or j:Ea(0b1000,0x145d8aa8,0x22808454,0x2313),a-c p[f]=g g,a=_[0b1010],0x25 else e=i return f,g,a,c,e end else c,a,f=0b101011,_[0b111],g-a l,g=0b100100110-l,a-c p[f]=g c,a,g,f=nil,nil,nil,n end until false end end,function(j,t)return function(m,n)local y,f,b,x,A,s,c,v,e,g,p,q,u,r,a,i,z,w,o,d,_,k,h A=0b11111101 while true do if A>=0x95 then if A>0xd1 then if A<0xef then if A<=0xdc then if A<=0xd5 then if A>=0xd4 then if A>0b11010100 then u=u(r,c)A,r,c,e=0b110100111-A,t[1][0b10][t[1][1]],d,i else A=z<k and 0xba54/A or 0xc6 end elseif A<=0xd2 then A,r=0x834/A,j.h(r(c,e))else A=0xd0 end elseif A>0xd8 then A,r,i,c,u,d=0b101001111-A,b+f,d,4294967295,t[1][0b10][t[1][1]],w else A,f=0x7a58/A,f(u,r)end elseif A>0xe2 then if A<=0b11100100 then s=j.h(s(f,u))return z,k,h,g,p,b,o,j.i(s)else v=v(q,a)q,y,A,h,a=t[0b11][0b10][t[0b11][1]],m,A+-0x1b,1,t[0b110][0b10][t[0b110][1]]k,h=w-h,0b100 z,k=k*h,0b10 z=z+k end elseif A>0xe1 then A,f=0x99,f(u,r)r,c,u=w,0x16,t[0b1000][0b10][t[0b1000][1]]elseif A<=0b11011110 then A=0x1a5-A else f,A,r=t[1][0b10][t[1][1]],0xa4,n[1]r,u=4294967295,r+w end elseif A<0b11111000 then if A>=0b11110010 then if A>0xf4 then A=h~=h and 0b111010110-A or 0b11000110 elseif A<=0xf2 then y=y(z,k)A,z=0b1101010,0b1000 else p=p(b,j.i(o))b,u=t[1][0b10][t[1][1]],y+g f,r=u+p,t[0b1010][0b10][t[0b1010][1]]u=r[z]s,A,f=f+u,0x1ab-A,x[z]end elseif A>0b11101111 then A,u,f=0b11100100,4294967295,u+y else q=q(a,y)A,a,k=A+-0b11000001,t[0b10][0b10][t[0b10][1]],0b1111 z=w-k y,z=x[z],0b11 end elseif A<=0xfc then if A<0xfb then if A<=0xf8 then h,A,y=0b10,0x26,t[0b10][0b10][t[0b10][1]]k=w-h k,z=0b1010,x[k]else A,o=0xee48/A,j.h(o(s,f))end elseif A<=0xfb then A,_=0x168d/A,_(v,q,a,j.i(y))x[w]=_ else o=o(s,f,j.i(u))r,A,f,u,s=d,0xd8,t[1][0b10][t[1][1]],w,t[0b111][0b10][t[0b111][1]]end elseif A<=0xfd then w={}w,d,x=1,0x40,w i=w A=d~=d and 0b11000010 or 0b110100 else A,f=0b10,f(u,r)f,r,p=t[1][0b10][t[1][1]],n[0b110],f u=r+q end elseif A>0xb4 then if A<0b11000101 then if A<=0xbd then if A>=0b10110111 then if A>0xb7 then A,f=0b10111111,f(u,r)else A,s,o=0b1111000,4294967295,s+f end else p=p(b,o)o,A,b,s=v,0xba-A,t[0b1000][0b10][t[0b1000][1]],0b1011 end elseif A>0b10111111 then A,d,w=0x80,n,t[0b101][0b10][t[0b101][1]]else r,k,f=n[0b11],f,t[1][0b10][t[1][1]]A,r,u=A+-0x6c,4294967295,r+i end elseif A>0b11001111 then if A>0b11010000 then A=A+0x11 else a=a(y,z)A,y=0xa010/A,0b10000 end elseif A<0b11000111 then if A>0b11000101 then p,A,b,g,o=t[0b1000][0b10][t[0b1000][1]],0x8cc4/A,v,t[0b111][0b10][t[0b111][1]],0b110 else q=q(a,y)g,z,y,a=1,m,t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]h,g=w-g,0b100 h,A,k=0b11,0b101100,h*g end elseif A<=0xc7 then A,s=0xfa,s(f)f=a else A,y=0xfb,j.h(y(z,k))end elseif A>0xa4 then if A<0xb2 then if A>=0xa7 then if A>0b10100111 then A=h>0 and 0x56 or 0x3219/A else y,_,v=0b1111,t[0b111][0b10][t[0b111][1]],t[0b1000][0b10][t[0b1000][1]]a=w-y A,a,q=A+-0b10000111,0b111,x[a]end else A=i~=i and 0x108-A or 0b10100001 end elseif A>0b10110011 then A,a=0b110100010-A,0x18 elseif A<=0b10110010 then A=w>d and 0xc2 or 0xa6 else A,a=0b11111000,a(y,z)end elseif A<0x9b then if A>0b10011000 then A,u=0b11111100,j.h(u(r,c))elseif A<=0b10010101 then A=i<=0 and 0b1111 or A+-0b101010 else A=h<=0 and 0b10011100 or 0b11110101 end elseif A>=0b10100001 then if A<=0b10100001 then A=i<=0 and 0b100000011-A or 0xa7-A else A,f=0b10111101,f(u,r)z,f,r=f,t[1][0b10][t[1][1]],n[0b10]u,r=r+d,4294967295 end elseif A>0x9b then A=z<k and 0x891c/A or 0x191-A else f=f(u,r)r,f,g=n[0b101],t[1][0b10][t[1][1]],f u,A,r=r+v,0x9a65/A,4294967295 end elseif A>=0b1000101 then if A>=0x73 then if A>0b10000100 then if A<0x8d then if A>0b10001010 then A=0x54c4/A else A,k=0b11001111,k+h end elseif A<0b10010001 then A=h<=0 and 0x74c4/A or A+0x39 elseif A<=0b10010001 then u,r,A,c=t[1][0b10][t[1][1]],w,0b11010101,i else A,_=0b1101000,_(v,q,j.i(a))q,v=t[0b1000][0b10][t[0b1000][1]],t[0b111][0b10][t[0b111][1]]end elseif A<=0b1111101 then if A<=0x7c then if A<0b1111000 then A,u=0x398/A,u(r,c)w=u elseif A<=0x78 then b=b(o,s)s,A,f,o,u=t[0b1000][0b10][t[0b1000][1]],0x7d,w,t[0b111][0b10][t[0b111][1]],0b10 else g,z=0b111,k+_ h=w-g A,k=0xf04/A,x[h]y=z+k y,a=4294967295,y+v end else A,s=0b11010001,s(f,u)f,u,r=t[0b1000][0b10][t[0b1000][1]],w,0b1101 end elseif A<=0x82 then if A<=0b10000000 then w,d,i,_,v,q,a,y=w(d)z,k=1,0x40 h=z A=k~=k and A+0x61 or A+0b101011 else A,b=0x160-A,b(o,s)s,f,o=t[0b100][0b10][t[0b100][1]],v,t[1][0b10][t[1][1]]end else A,o=A+-0b1001101,j.h(o(s,f))end elseif A>0x56 then if A>=0b1101000 then if A<0x6a then A,z=0x49,0b10 y=w-z y,a=0x11,x[y]elseif A>0b1101010 then A=i~=i and 0xc2 or 0x282/A else A,a=A+0x20,a(y,z)g,z,y=1,m,t[0b110][0b10][t[0b110][1]]g,h=0b100,w-g k,h=h*g,g end elseif A<=0b1100000 then A,f=0b110001,f(u,r)r,f,b=n[0b111],t[1][0b10][t[1][1]],f u,r=r+a,4294967295 else A=w<d and A+0x60 or 0b110 end elseif A<=0x4b then if A<0x49 then if A<=0x45 then A,r=0x89-A,4294967295 else A=w>d and 0b11000010 or 0b10010101 end elseif A>0b1001001 then A=h~=h and 0x11f-A or 0b10001101 else q=q(a,y)a,k=t[0b1000][0b10][t[0b1000][1]],0b10 A,z=A+0b1101010,w-k y,z=x[z],0b10011 end elseif A>0x53 then A=z>k and 0xe1 or A+-0b1011 else f=f(u,r)A,r,f,h=0b10001100,n[0b100],t[1][0b10][t[1][1]],f r,u=4294967295,r+_ end elseif A<0x21 then if A<0b1010 then if A>=0b110 then if A>0b111 then z=z+h A=h>0 and 0b101001 or 0x98 elseif A<=0b110 then _=0b10000 A=w<=_ and 0b111 or A+0b10100001 else _,v,q,k,a=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],1,m z,k=w-k,0b100 z,A,y=1,0x3b,z*k y=y+z end elseif A>0b10 then b=b(o,s)o,A,s=t[0b1000][0b10][t[0b1000][1]],0x25,v else A,r=0x60,4294967295 end elseif A<=0x1c then if A<0b10111 then if A>0b1010 then A=w<d and 0b11000010 or 0x6b else s=s(f,u,j.i(r))A,u,f=0b1000101,o+s,t[1][0b10][t[1][1]]end elseif A<=0x17 then w=w+i A=i>0 and 0b1001000 or A+0b1111110 else A,u=0xdc,u(r,c)_,v=i,u end elseif A>0b11111 then v=v(q,a)A,q,z=A+0x21,t[0b1000][0b10][t[0b1000][1]],0b1111 y=w-z a=x[y]else A,q=0x17,q(a,y)x[w]=q end elseif A<0b110001 then if A<0x29 then if A<0b100101 then A,v=0x7c,v(q,a,j.i(y))g,q=0b10000,t[1][0b10][t[1][1]]h=w-g k=x[h]elseif A>0b100101 then A,y=0b100001,j.h(y(z,k))else A,f=0b10101001-A,0x19 end elseif A<=0x2c then if A>0b101001 then A,k=0xf2,k+h else A=z>k and 0x2409/A or 0x98 end else A,a=0x94,j.h(a(y,z))end elseif A>0x3b then if A<=0x41 then A,y=0xef,0b10010 else f=f(u,r)y,A,u,a,c,r,q=a,0b11100,t[1][0b10][t[1][1]],q,4294967295,_+b,v end elseif A<0x37 then if A>0b110001 then A=i>0 and 0b10110010 or 0xa6 else A,f=0x2e21/A,f(u,r)o,u,s=f,n[0b1000],t[1][0b10][t[1][1]]end elseif A>0x37 then A,q=A+0b1111001,q(a,y)else g=g(p,b,j.i(o))A,b,p,o,s=0b10000010,t[1][0b10][t[1][1]],t[0b111][0b10][t[0b111][1]],v,q end end end end,function(j,o)return function(m)local h,f,d,a,n,i,_,c,l,g,b l=0x2d repeat if l<0b10101001 then if l>=0x5b then if l<=0b10001111 then if l>=0b10001100 then if l<=0b10001100 then l=h>b and 0xfd or 0b100101111-l else l=d<=0 and 0b11101010 or 0x7ae4/l end else l=0xc5 i(_,j.i(f))end else l=d~=d and 0xd5 or 0x3f end elseif l<=0x3f then if l<=0x2d then h={}d,b,n,h=0b1000000,#m,h,1 l=b~=b and 0b11111101 or 0xa9 else l=d<=0 and 0b100010100-l or 0b11101101 end else l,f=0b1011011,j.h(f(g,a,c))end elseif l<=0xe9 then if l<0xd5 then if l<=0xa9 then l=d>0 and 0b10001100 or 0x6b9b/l else h=h+d l=d>0 and l+0x24 or 0x6e0b/l end elseif l>=0b11011100 then if l<=0xdc then l=d~=d and l+0x21 or 0b11101101 else l=h>b and 0xe645/l or l+-0x5a end else l=h<b and l+0x28 or 0xed end elseif l>=0xed then if l>0b11101101 then return n else _,i,c,a=n,o[1][0b10][o[1][1]],0x3f,h f,c,l,g=m.sub,h+c,0x131-l,m end else l=h<b and 0xe742/l or 0xc918/l end until false end end,function(j)return function(m,n,r,b,d,i,_)local q,e,a,k,l,f,h,c l=j.Aa[-0x488]or j:Ea(0b1000,3758575895,0x3084896,-0x488)while true do if l<=0x1a then a,q=0x22,_[0b1001]e,k,l,f=_[0b1010],0b10100,j.Aa[0x7b6]or j:Ea(0x10,0x2b6400dc,0x40130c68,0x7b6),q-a c=e-k a,k,h=r[c],_[0x11],0x3f else e=k-h c=r[e]q=a+c r[f]=q q,a,c,e,f=nil,nil,nil,i,n return f,q,a,c,e end end end end,function(j)return function(m,n,r,b,d,i,_)local f,l,a,e,q,k,c,h l=j.Aa[0x464d]or j:Fa(0b110010,0x767d,0x464d)while true do if l>0b110011 then e=k-h c=r[e]q=a..c r[f]=q e,a,q,f,c=i,nil,nil,n,nil return f,q,a,c,e else q,a=_[0b1001],0x10 e,k,l,f=_[0b1010],0x2f,j.Aa[-0x607e]or j:Da(3499088735,0x177eed1,0x8c8318d,-0x607e),q-a c=e-k k,a,h=_[0b10001],r[c],0b10101 end end end end,function(j)return function(m,n,p,b,d,i,_)local g,c,e,f,a a,g,f,e,c=nil,nil,n,i,nil return f,g,a,c,e end end,function(j)return function(m,n,p,b,d,i,_)local g,a,f,c,l,e l=j.Aa[0x69e7]or j:Da(0x1528c5ba,0x12487adf,3490486108,0x69e7)while true do if l>0x3a then e,a,c=i,nil,nil return f,g,a,c,e else a,g=0b110,_[0b1001]f,c,a=g-a,0x16,_[1]g=a-c l,p[f]=j.Aa[-0x250b]or j:Ea(0x48,2964878683,0x404118f8,-0x250b),g g,f=nil,n end end end end,function(j)return function(m,n,r,b,d,i,_)local k,l,f,h,a,q,c,e l=j.Aa[-0x47bf]or j:Ea(0b1001,2620287196,0x40c04573,-0x47bf)repeat if l>0x39 then e=k-h c=r[e]q=a==c r[f]=q c,q,a,e,f=nil,nil,nil,i,n return f,q,a,c,e else q,a=_[0b1001],0x19 e,k,f=_[0b1010],0b101000,q-a c=e-k a,h,l,k=r[c],0b100111,j.Aa[-0x5b88]or j:Da(2345414126,0x3e76e6da,0x59bea20,-0x5b88),_[0b10001]end until false end end,function(j,t)return function(m)local l,a,q,p,o,n,e,c,g,s,w,r,_,h,k,b,v,i,d l=0xab repeat if l>=0b1111110 then if l<0xc7 then if l>=0b10100010 then if l>0b10110100 then l,b=0b11001111,0b11111111 elseif l>0xab then return v elseif l<=0xa2 then l,h=0xc7,h(j.i(g))g,h,v=t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],v..h else w,e,r,k,a,q,d,c,l,_,v,i=0x428a2f98,3624381080,{},0x12835b01,2453635748,0x59f111f1,0x71374491,2870763221,0x7e,3921009573,0x3956c25b,3049323471 end elseif l<0b10001011 then if l<=0x7e then l,s,g,h,o,b,p=0b10010001,3248222580,0x550c7dc3,0x243185be,2614888103,2162078206,0x72be5d74 r[0b1010],r[0b11],r[0b1000],r[0b100],r[0b111],r[0b10000],r[0b1011],r[0b1111],r[0b10],r[0b1001],r[1],r[0b1100],r[0b1101],r[0b101],r[0b1110],r[0b110]=k,i,c,_,a,s,h,o,d,e,w,g,p,v,b,q d,i,_,w=4022224774,0xfc19dc6,0x240ca1cc,3835390401 else g,v,e,l,k,q,h,_,c,a,p,b=2361852424,0x391c0cb3,0x748f82ee,0b1110011,0x78a5636f,0x4ed8aa4a,2227730452,0x34b0bcb5,0x682e6ff3,0x5b9cca4f,2428436474,2756734187 end elseif l>0x8b then l,k,p,e,q,b,v,g,a,c,h,o=0x3e4e/l,2821834349,3336571891,2554220882,0x4a7484aa,3584528711,0x2de92c6f,3210313671,0x5cb0a9dc,0x76f988da,2952996808,0x6ca6351 else p=p(b,o)l,b=0b10001,0xff end elseif l>0b11011101 then if l>=0b11110001 then if l>0b11110001 then l,g=0xed12/l,j.h(g(p,b))else p=p(b,o)l,b=0xe2,0b11111111 end elseif l>0b11100010 then l,h=0xc6,h(j.i(g))p,v,h,g=k,v..h,t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]else l,g=l+-0b101,j.h(g(p,b))end elseif l<=0xcf then if l>0b11001010 then l,g=0x58,j.h(g(p,b))elseif l>0xc7 then p=p(b,o)l,b=0b111001001-l,0xff else b,p,l,o=k,t[0b1001][0b10][t[0b1001][1]],0x9d06/l,0b1000 end elseif l>0b11010001 then h=h(j.i(g))h,l,v=t[0b110][0b10][t[0b110][1]],0x47,v..h else l,p,g=0x1a20/l,0x5be0cd19,0x1f83d9ab v[0b11],v[0b1000],v[1],v[0b100],v[0b110],v[0b101],v[0b111],v[0b10]=c,p,q,e,h,k,g,a q,a,v,_=ipairs,i,"",v end elseif l<0x47 then if l<0x15 then if l<=0b1100 then if l<=0b1010 then if l<=0b11 then l,q,a=0x7a,ipairs,_ else h,g,l,o,p,b=t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],0x96a/l,0x18,t[0b1001][0b10][t[0b1001][1]],k end else e,k=q(a,c)c=e l=c==nil and 0b10110100 or 0b1111000/l end else l,g=0xac2/l,j.h(g(p,b))end elseif l<=0x20 then if l>=0b11110 then if l<=0b11110 then e,k=q(a,c)c=e l=c==nil and 0b11 or 0x66 else q,a,c=q(a)q,a,c=j.g(q,a,c)e,k=q(a,c)c=e l=c==nil and l+-0x1d or l+0x46 end else g=j.h(g(p,b))l=0x1e j.j(h,1,j.i(g))_=h end else l,i=0b11111111-l,i(_)v,k,h,e,c,q,a={},0x510e527f,2600822924,2773480762,0x3c6ef372,0x6a09e667,3144134277 end elseif l<0x66 then if l<0x58 then if l>0b1000111 then l,i=l+0b1111,i(_)else l,g,b,p,o=0x268d/l,t[0b11][0b10][t[0b11][1]],k,t[0b1001][0b10][t[0b1001][1]],0x10 end elseif l<=0b1011000 then h=h(j.i(g))l,v=0b1100,v..h else l,i,m=l+-0b110111,w,i _=m end elseif l>=0x73 then if l<=0x7a then if l>0b1110011 then q,a,c=q(a)q,a,c=j.g(q,a,c)e,k=q(a,c)c=e l=c==nil and 0b10110100 or l+-0b1110000 else s,o=3329325298,3204031479 r[0b110010],r[0x34],r[0b110001],r[0x39],r[0x3f],r[0b111011],r[0b110011],r[0x36],r[0b111100],r[0x40],r[0b111010],r[0b110101],r[0x3e],r[0x3d],r[0x38],r[0x37]=d,_,w,e,o,h,i,q,g,s,k,v,b,p,c,a n=r n={[1]=0b11,[0b11]=n}n[0b10]=n d,r,w=j:E{t[0b11],t[0b1001],t[0b1100],t[1],t[0b101],t[0b100],t[0b1010],t[0b1000],t[0b10],n},j:C{t[0b1001],t[0b11],t[0b110],t[0b111]},j:D{t[0b1011]}l,i,_=l+-0b11101,r,m end else o,p,g,b,h,l,s,k=4094571909,3516065817,3345764771,3600352804,3259730800,0b10000011,0x106aa070,2820302411 r[0x23],r[0b101100],r[0b101101],r[0x28],r[0b100111],r[0x26],r[0b101111],r[0b100001],r[0x22],r[0x24],r[0b101001],r[0x2b],r[0b101010],r[0b100101],r[0b101110],r[0b110000]=i,g,p,c,a,q,o,w,d,_,e,h,k,v,b,s i,d,w=0x2748774c,0x1e376c08,0x19a4c116 end elseif l>0b1100110 then s=0x14292967 r[0x14],r[0x15],r[0x17],r[0x18],r[0b10011],r[0b11011],r[0x1c],r[0b10010],r[0b11101],r[0x16],r[0x1f],r[0b11110],r[0b10001],r[0b11010],r[0b11001],r[0b100000]=_,v,a,c,i,h,g,d,p,q,o,b,w,k,e,s l,d,w,a,q,e,i,v,_,c=0x35b6/l,0x2e1b2138,0x27b70a85,2177026350,0x766a0abb,2730485921,0x4d2c6dfc,0x650a7354,0x53380d13,2456956037 else g,p,l,b,h=d,k,0b10101,_,{}end until false end end,function(j,t)return function()local e,o,F,c,k,r,M,m,u,a,C,w,_,I,b,d,A,n,z,i,q,s,H,g,l,v,E,L,y,f,J,h,x,D,K,p,G A=j.Aa[-0x7a52]or j:Ca(3920066011,0x10588a6a,-0x7a52)while true do if A<=0x215 then if A<0xdc then if A<0b1111100 then if A>=0b1000001 then if A>0b1011000 then if A>=0x68 then if A<=0b1110000 then if A<=0x6d then if A<=0x69 then if A<=0x68 then A,v=0x9e-A,0b111 else L=0 A=x==L and A+-0b1010101 or(j.Aa[-0x583a]or j:Ea(0b11010000,0x3afa7b,2193937916,-0x583a))end else A,q=j.Aa[0x50e3]or j:Ca(0x5ad6967e,2233469437,0x50e3),a end elseif A>0b1101110 then A,v=j.Aa[0x77d8]or j:Ea(0x20,4261699675,0x1a4df7,0x77d8),0x81 else A,v=j.Aa[0x77d8]or j:Da(2245871351,0x87a6590,0x2fa5aba6,0x77d8),0x81 end elseif A>=0b1110101 then if A>0b1110101 then v=0x46 A=k>v and(j.Aa[0x77d8]or j:Da(0x5048527f,0x134107b7,0x79cf19ff,0x77d8))or(j.Aa[0x4f42]or j:Ca(0x15347cd,3758922703,0x4f42))else i=i+v A=v>0 and A+0b101001010 or(j.Aa[-0x39b0]or j:Ca(3808237247,0x900498b,-0x39b0))end elseif A<=0b1110001 then A,_=0xf2-A,v else v=0 a,q,y=0b100,v,1 A=a~=a and 0xc06/A or A+0x32e end elseif A>=0b1100001 then if A<=0x64 then if A<=0b1100010 then if A<=0x61 then q=0b101000 A=_>q and(j.Aa[0x3d3f]or j:Da(0x1b27b5e7,0x193736e4,0x2b90d1bd,0x3d3f))or(j.Aa[0x52fe]or j:Ea(0x22,0x77ae768a,0x8400ab3,0x52fe))else q=0x19 A=_>=q and A+-0b1000011 or(j.Aa[0x27bc]or j:Fa(0b10,0x76ee,0x27bc))end else A,L=j.Aa[0x781e]or j:Fa(0b100,0x76ec,0x781e),d end else q=0x30 A=_>q and(j.Aa[-0x208a]or j:Fa(0x10,0x76fc,-0x208a))or(j.Aa[0x4b0b]or j:Fa(0x40,0x7636,0x4b0b))end elseif A>=0x5d then if A<=0b1011101 then d=0 v,_,i=1,0b100,d A=_~=_ and 0b1101000-A or(j.Aa[-0x65aa]or j:Fa(0b1011010,0x746b,-0x65aa))else A,v=j.Aa[0x77d8]or j:Fa(0x26,0x765c,0x77d8),0b10000001 end elseif A>0b1011001 then A,v=A+-0x24,0x19 else q=1 A=_>=q and A+-0b110011 or(j.Aa[-0x1257]or j:Fa(0b10000010,0x76be,-0x1257))end elseif A<0x4b then if A<=0x46 then if A<=0b1000011 then if A>0x42 then a,y,A,z,K=t[0b1001][0b10][t[0b1001][1]],"B",j.Aa[-0x2508]or j:Fa(0x2a0,0x744c,-0x2508),t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]elseif A<=0b1000001 then x,A,k,u=L,j.Aa[0x73bf]or j:Da(0x7184e1ed,0x9d52e98,0x786dd7e3,0x73bf),1,0b11000010 else A,z=j.Aa[0x5954]or j:Fa(0x60,0x7469,0x5954),q end elseif A<=0b1000100 then q=0b1101 A=_>q and(j.Aa[-0x518d]or j:Fa(0,0x76d6,-0x518d))or(j.Aa[-0x43d3]or j:Da(3146997759,0x2d6894ec,0x16c36b8e,-0x43d3))else A,v=0x7c-A,0b10010000 end elseif A>0b1001001 then n,A,d,E,x,g,L=t[0b1001][0b10][t[0b1001][1]],j.Aa[0x38d]or j:Ca(0x1c93cfdb,2718704473,0x38d),t[0b110][0b10][t[0b110][1]],0xf6,"B",0b1001101,t[0b11][0b10][t[0b11][1]]elseif A<=0x48 then if A<=0b1000111 then A,_,k=j.Aa[-0x2f2d]or j:Ca(2998633919,0x490438e7,-0x2f2d),v,0b10010100 else x=0 d,L,i=0b100,x,1 A=d~=d and A+-0b1000000 or(j.Aa[-0x5f09]or j:Ea(0x30,0x4754df73,2552463707,-0x5f09))end else a,v,_,A,q=t[0b110][0b10][t[0b110][1]],"B",t[0b1001][0b10][t[0b1001][1]],j.Aa[-0x191d]or j:Ea(0x84,0x6a0d17fb,2227308787,-0x191d),t[0b11][0b10][t[0b11][1]]end elseif A<0b1010000 then if A<=0b1001101 then if A<0x4c then q=0b10 A=_<=q and 0x1a13/A or(j.Aa[0x625a]or j:Fa(0xc6,0x76a9,0x625a))elseif A>0x4c then d=d+_ A=_>0 and A+0b101100000 or A+0x295 else q=0x37 A=_<q and(j.Aa[-0x641b]or j:Ea(0b11,0x2f406f52,0x109d2237,-0x641b))or A+-0b10000 end else q=a A=I>H and A+0x67 or A+0b100100 end elseif A<=0b1010010 then if A<0x51 then A,v=j.Aa[0x77d8]or j:Ea(0x36,0x6afe9f17,0x1013,0x77d8),0x2b elseif A>0b1010001 then q=0b1000 A=_>=q and 0x13b-A or A+-0b101101 else A=j.Aa[-0x756d]or j:Ca(0x7dd6b6f6,0x10b9d,-0x756d)end elseif A>0x54 then L=L+i A=i>0 and 0x33f-A or(j.Aa[-0x22fc]or j:Da(3960958719,0xc2298ea,0x73d77e5,-0x22fc))else q=0b100010 A=_>q and 0xfe-A or A+0x153 end elseif A<=0x23 then if A<=0x14 then if A<=0b1100 then if A>0b1010 then if A<=0b1011 then L,A,k=d,0x48-A,0xc4 else A,v=j.Aa[0x77d8]or j:Fa(0b100100,0x765a,0x77d8),0b111 end elseif A>=0b1000 then if A<=0b1000 then n=x A=k<=u and 0x1c98/A or 0b10001111-A else k,L,u=0b11000111,0,0x94 _,d,i=1,L,0b100 A=i~=i and 0x28a/A or(j.Aa[0x72ae]or j:Ca(3185045485,0x420802f3,0x72ae))end elseif A<=1 then A,v=j.Aa[0x77d8]or j:Da(4031611390,0x65f6792,0x2429ca5,0x77d8),0x90 else A,v=j.Aa[0x77d8]or j:Ea(0b10,0x38f7e7d1,0x4508e03c,0x77d8),0b1000110 end elseif A>0x13 then A,n=j.Aa[0x3c42]or j:Ea(0b10,2183858590,0x65d400e5,0x3c42),""elseif A>=0b10001 then if A<=0b10001 then q=0b100100 A=_<=q and(j.Aa[-0x5285]or j:Ea(0x10,0x7534a291,2290822476,-0x5285))or 0xa29/A else A,v=A+0x23,0b1000110 end else A,v=0x46-A,0b10010000 end elseif A>0x1d then if A<0x1f then q=0b1111 A=_<=q and(j.Aa[-0x2e9a]or j:Ca(0x10c028ff,3357790911,-0x2e9a))or(j.Aa[0x4459]or j:Ca(0x4cf6aff6,2164789301,0x4459))elseif A>0x1f then q=0b1001 A=_<=q and(j.Aa[-0x18ff]or j:Ca(3458172404,0x160280e,-0x18ff))or(j.Aa[0x4ca5]or j:Ca(0x5259d0ff,0x250200df,0x4ca5))else q=0b11001 A=_<=q and(j.Aa[0x39b]or j:Da(2296516523,0x53709405,0x139fbfce,0x39b))or(j.Aa[-0x296c]or j:Ca(0x3a8f535f,0x4030add8,-0x296c))end elseif A>=0x17 then if A<=0x1b then if A>0x17 then k,A,_=0b110001,0x19f2/A,v else q=0b1111 A=_<q and(j.Aa[0xad6]or j:Ea(0,3485496465,0x3d1847,0xad6))or(j.Aa[-0x3914]or j:Ea(0b100,0x62ee6f1f,2617319451,-0x3914))end else q=0b110 A=_<=q and(j.Aa[0x78ca]or j:Ea(0b1010000,2579999901,0x4618a124,0x78ca))or(j.Aa[0x438d]or j:Ea(0b11001000,0x661a579a,0x190502f8,0x438d))end elseif A<=0x15 then q=0b10100 A=_>q and(j.Aa[-0x1369]or j:Ea(0x18,2904230846,0x6400e8,-0x1369))or(j.Aa[-0x7ebf]or j:Da(3701263103,0xc4b5acf,0x14b4da66,-0x7ebf))else g,i,h=0b1101000,_,0b10100010 A=u>I and 0x88-A or(j.Aa[-0x677c]or j:Da(0x793e8efb,0x954c6c,0x1abd747,-0x677c))end elseif A>=0x35 then if A<=0b111011 then if A>=0x37 then if A>=0b111000 then if A<=0x38 then q=0x33 A=_>q and(j.Aa[-0x2b80]or j:Ea(0b100,2775134377,0x286253c,-0x2b80))or 0x1180/A else A,v=j.Aa[0x77d8]or j:Da(2894578806,0x2aeb972d,0x1574a109,0x77d8),0b111 end else q=0b110011 A=_>=q and(j.Aa[0x7b6]or j:Da(0x71ff253b,0xb21d8dd,0xdeb9df,0x7b6))or 0x15b3/A end elseif A<=0b110101 then v=0x80 A=H<v and A+1 or 0x21f4/A else a,y={},0 a[0b10000]=y a[0b11111]=y a[0b10]=y a[0b10011]=y a[0x1e]=y a[0x1c]=y A,a[0b10001]=j.Aa[-0x4346]or j:Ea(0b1011,3934646530,0x140860b9,-0x4346),y end elseif A>0b111101 then y,a,z,A,K="B",t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],0x257-A,t[0b110][0b10][t[0b110][1]]elseif A<=0x3c then q=0x3b A=_>=q and(j.Aa[0x290b]or j:Ca(0xea04ff1,0x71182037,0x290b))or A+0xb9 else v,i,A,q,_,H=t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],j.Aa[0x2f1]or j:Da(0x4d1bb35f,0x88636d7,0x29bdcabd,0x2f1),t[0b110][0b10][t[0b110][1]],"B",0b1001001 end elseif A>0x2b then if A<0b110001 then d[0b11000]=x _={}i=_ d[0x1b]=i _={}i=_ d[0b1000]=i d[0b1101]=n L=d return L elseif A>0x31 then A,v=A+0b10,0xcb else q=0b1000011 A=_>q and(j.Aa[-0x73c0]or j:Fa(0b1101001,0x76a9,-0x73c0))or 0x80a/A end elseif A>=0b100111 then if A>0x2a then a[1],h,H,k=y,0xa5,0xbe,0x63 a[0b111]=y A,a[0b10010]=j.Aa[-0x23ec]or j:Ea(0b1000010,0x241d8118,3363964098,-0x23ec),y a[0b1111]=_ a[0b1010]=y a[0b1001]=y a,q,y=t[0b100][0b10][t[0b100][1]],a,x elseif A<=0b100111 then A,v=0b1011101-A,0b11001 else q=0b111011 A=_<=q and 0b11110000-A or(j.Aa[-0x2dc1]or j:Ca(2786587859,0x40c00117,-0x2dc1))end elseif A<=0x25 then q=0b110 A=_<q and(j.Aa[0x218c]or j:Ea(0b1000,2444945182,0xe41203f,0x218c))or(j.Aa[-0x333b]or j:Ca(0xb1dd25d,2147485087,-0x333b))else q=1 A=_>q and(j.Aa[0x39d0]or j:Ea(0b10011100,2965294586,0x4600006c,0x39d0))or 0xf4-A end elseif A<=0b10101010 then if A>0b10010001 then if A<0b10011101 then if A>0x98 then if A<=0x9b then if A>0x99 then A=i>_ and 0xff-A or 0x420-A else A,v=0x2046/A,0x1a end else A,v=j.Aa[0x77d8]or j:Fa(0b110,0x765c,0x77d8),0b101001 end elseif A<0b10010101 then if A<=0x92 then G={}G[0b1011]=z J=0 A,G[0b11000]=0x347-A,J G[0x14]=d G[0b1100]=L G[0x1b]=x G[0b11010]=i G[0b1000]=v else A=i<=0 and 0x17a18/A or 0x53d4/A end elseif A<0b10010110 then i=i+v A=v>0 and(j.Aa[-0x6697]or j:Ca(2796008414,0x59484e6a,-0x6697))or(j.Aa[-0x4595]or j:Fa(0b110,0x7561,-0x4595))elseif A>0b10010110 then I,A,H,m=0x91,j.Aa[0x3ba3]or j:Da(3323034591,0x94946d,0x177091,0x3ba3),0b111111,n else _=_(v,q,a)q,v=1,a v=v+q t[0b110][0b10][t[0b110][1]]=v A=k>q and A+-0x80 or 0x1b7-A end elseif A>=0xa4 then if A>0b10101000 then if A>0xa9 then A,v=j.Aa[0x77d8]or j:Da(3100902582,0x19f3b0f,0x46c9770,0x77d8),0x46 else q,A,k=a,0x2864b/A,0b1011111 end elseif A>0b10100111 then A,i=A+0x57,i(_,v,q)_=q _=_+L elseif A<=0b10100100 then k,q=0x1b,0x15 A=_>q and A+0x3d or(j.Aa[-0x6013]or j:Ea(0b10000010,2255201562,0x589400e5,-0x6013))else q=0x18 A=_<q and 0x7b4b/A or A+0x12 end elseif A<0xa1 then if A<=0b10011101 then A,q[0b1001]=0b111110001-A,a z,y,G,K="B",t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]else K=K+J A=J>0 and A+0x9be or(j.Aa[-0x73b2]or j:Fa(0x60,0x7d10,-0x73b2))end elseif A<=0b10100001 then A,v=0x21f6/A,0b10010000 else q=0x26 A=_>q and(j.Aa[-0x67d4]or j:Fa(0x202,0x7778,-0x67d4))or(j.Aa[0x30e]or j:Ca(3778569215,0x4468b2f,0x30e))end elseif A<0b10000111 then if A>0x81 then if A<0b10000100 then if A<=0b10000010 then v=0b11010 A=k>=v and(j.Aa[0x77d8]or j:Ca(3173323894,0x2d2a9be,0x77d8))or(j.Aa[-0x565e]or j:Da(0x7008a3ff,0x54e77272,0x379b918d,-0x565e))else z,G,A,a,q,K,y=t[0b1100][0b10][t[0b1100][1]],0x7f,j.Aa[-0x2355]or j:Fa(0x310,0x746c,-0x2355),L,t[0b111][0b10][t[0b111][1]],v,t[0b1011][0b10][t[0b1011][1]]end elseif A<=0x84 then d=0 A=L==d and 0x14c-A or(j.Aa[-0xbfa]or j:Ea(0b10000,4047735953,0x8a480f3,-0xbfa))else a=y A=k>=H and 0x219-A or(j.Aa[0xfc7]or j:Ea(0b1011000,0x450221be,2856058972,0xfc7))end elseif A>0b1111111 then if A<=0b10000000 then D=D(f,j.i(F))f,M,A,F,G=t[1][0b10][t[1][1]],0x80,0x11200/A,o,D else A,z,y,q,K,v,a=A+0x379,_,t[0b1100][0b10][t[0b1100][1]],x,0x7f,t[0b111][0b10][t[0b111][1]],t[0b1011][0b10][t[0b1011][1]]end elseif A>0x7e then A=0x354-A elseif A<=0x7c then a,y,J,A,K,z,G=t[0b111][0b10][t[0b111][1]],d,0b1111111,j.Aa[0x5a5b]or j:Ea(0x121,0x4e9159c8,0x114c1705,0x5a5b),t[0b1100][0b10][t[0b1100][1]],t[0b1011][0b10][t[0b1011][1]],q else q=0x25 A=_<=q and(j.Aa[-0x5b88]or j:Fa(0x2a,0x7684,-0x5b88))or A+0b1011011 end elseif A>0b10001100 then if A>0x90 then y,q,a,A,v=t[0b110][0b10][t[0b110][1]],"B",t[0b11][0b10][t[0b11][1]],0x14005/A,t[0b1001][0b10][t[0b1001][1]]elseif A<0x8e then J,A,p,G,K=t[0b11][0b10][t[0b11][1]],A+0b111100111,t[0b110][0b10][t[0b110][1]],"B",t[0b1001][0b10][t[0b1001][1]]elseif A<=0b10001110 then A,a[y]=A+0x2d7,J else A,v=j.Aa[0x77d8]or j:Ea(0b110100,0x23dca45b,0x58222106,0x77d8),0xac end elseif A<0b10001010 then if A<=0x87 then I,u,A,L,x=0x2c,0b10110100,j.Aa[0x677b]or j:Fa(0x100,0x7566,0x677b),n,t[0b101][0b10][t[0b101][1]]else A=_<=0 and(j.Aa[0x3569]or j:Fa(0x214,0x766d,0x3569))or 0x5cf8/A end elseif A>0b10001011 then v,a,q,A,y=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],"B",j.Aa[-0x29f7]or j:Ca(3719592815,0x220a85af,-0x29f7),t[0b110][0b10][t[0b110][1]]elseif A<=0b10001010 then a=0xcb A=v>a and(j.Aa[0x6dee]or j:Da(2280192919,0x1f40802c,0x48c28674,0x6dee))or(j.Aa[-0x36fb]or j:Ca(3801991167,0xd023b1f,-0x36fb))else A=v<=0 and A+0b110111110 or(j.Aa[-0x47]or j:Ea(0x330,3043066846,0x89201e5,-0b1000111))end elseif A<0xc4 then if A>0b10110110 then if A<=0b10111110 then if A>0b10111100 then if A<=0xbd then q,k,H=0b1011,0b11101001,0x64 A=_<=q and(j.Aa[0x732]or j:Fa(0b11000000,0x76fc,0x732))or 0x9759/A else A,v=j.Aa[0x77d8]or j:Fa(0b10100,0x765e,0x77d8),0b11110001 end elseif A<0b10111010 then q=0b101111 A=_>q and(j.Aa[0x2313]or j:Ea(0b1001000,3992916075,0x1000152d,0x2313))or(j.Aa[0xfd6]or j:Da(4192546814,0x1a5372d,0x6b8952,0xfd6))elseif A>0b10111010 then A=j.Aa[-0x3a61]or j:Ea(0,2257518970,0x78200f77,-0x3a61)else A,v=j.Aa[0x77d8]or j:Ca(0x1a19faf7,0x64e4003e,0x77d8),0b100 end elseif A>=0xc1 then if A>0xc1 then A=y<=0 and A+0x206 or A+0x59 else A,y=0x3ea-A,y(z,K,G)z,K=G,1 z=z+K end else A,v=0x284a/A,0b11110001 end elseif A>0xaf then if A<=0b10110101 then if A<0xb2 then A=j.Aa[-0x1b15]or j:Ca(2284116927,0x161302ff,-0x1b15)elseif A<=0b10110010 then A=y>z and 0x15b-A or 0x432-A else a,y,J,A,G,K,z=t[0b111][0b10][t[0b111][1]],d,0x7f,j.Aa[-0x12fa]or j:Ea(0x224,2601194971,0x209002e4,-0x12fa),q,t[0b1100][0b10][t[0b1100][1]],t[0b1011][0b10][t[0b1011][1]]end else A,v=A+-0x80,0b11010011 end elseif A>=0xad then if A>0b10101110 then a,A,z,y,q="B",0x2bb-A,t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]elseif A<=0xad then v=q A=k<=u and(j.Aa[-0x2f00]or j:Da(2710670895,0x29fca9b4,0x244fb89f,-0x2f00))or(j.Aa[-0x7c27]or j:Ea(0,0x17852aea,0x203a3,-0x7c27))else n,A,t[0b110][0b10][t[0b110][1]]=d,j.Aa[0x3c42]or j:Ca(0x5e809ee7,2708234739,0x3c42),i end elseif A<=0xab then q[0b10010]=a A=k>=H and(j.Aa[0x7063]or j:Da(4216240119,0x13166,0x9f1157,0x7063))or A+0x26e else q=q(a,y)v=not q A=v and(j.Aa[-0x5fc]or j:Ca(0x7283495b,2371362988,-0x5fc))or(j.Aa[0xfc7]or j:Fa(0x48,0x7674,0xfc7))end elseif A>0xce then if A<0xd4 then if A<0xd2 then if A>0xcf then q=0b101 A=_>=q and 0x42a0/A or 0x11b-A else A=i<=0 and 0b111110011-A or 0x232c8/A end elseif A<=0xd2 then A,v=0x2c4c/A,0x46 else A,J=j.Aa[-0x4be8]or j:Fa(0,0x7764,-0x4be8),J(p,C,o)p=o p=p+K end elseif A>=0xd8 then if A>0b11011000 then q=0x29 A=_<=q and 0x13a-A or A+0x20 else v=0b1000110 A=k<=v and 0b100001110-A or 0x113-A end elseif A>0b11010100 then A,z=j.Aa[-0x396b]or j:Fa(0b1001,0x77a8,-0x396b),K else q[0x1c]=a y,G,A,K,z=t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]],0xf4a-A,t[0b11][0b10][t[0b11][1]],"B"end elseif A>0b11001000 then if A<0xcd then if A<=0b11001001 then A,y=j.Aa[0x1e8b]or j:Ca(0x63de7fb,2156005867,0x1e8b),y(z,K,G)z,K=G,1 z=z+K t[0b110][0b10][t[0b110][1]]=z else A=J<=0 and 0x12540/A or 0x3a3-A end elseif A<=0xcd then q=0b10011 A=_<q and(j.Aa[-0x504e]or j:Fa(1,0x767b,-0x504e))or 0x8354/A else A,v=j.Aa[0x77d8]or j:Ea(0b100000,3221806290,0x1321517e,0x77d8),0b11110001 end elseif A<0b11000110 then if A<=0b11000100 then J=0/0 A=h<=g and 0x102-A or(j.Aa[-0x38af]or j:Fa(0b1100,0x76e2,-0x38af))else A,J=0x21c36/A,0 end elseif A<0b11000111 then A,v=j.Aa[0x77d8]or j:Ea(0b10010,0x17d1cdc3,3356246140,0x77d8),0b10010000 elseif A<=0xc7 then q=0b11 A=_>q and(j.Aa[-0x5379]or j:Da(2739212543,0x1c4cc584,0x23ed823a,-0x5379))or(j.Aa[-0x7c25]or j:Ca(3628444159,0x2620406e,-0x7c25))else A,x=j.Aa[-0x996]or j:Ea(0b1000110,2686956178,0x46988eb3,-0x996),""end elseif A>=0b101101110 then if A>0b111000110 then if A<0b111110001 then if A>=0b111010101 then if A>=0x1de then if A<0b111101000 then if A>0b111011110 then A=i>_ and A+-0x1dc or(j.Aa[0x2775]or j:Fa(0x106,0x7661,0x2775))else A,K=0x5bc-A,G end elseif A>=0x1eb then if A<=0x1eb then A,a=j.Aa[0x269f]or j:Ea(0b1000010,4290178463,0x48c192,0x269f),y else v=v(q,j.i(a))A,x,y,q,a=j.Aa[0x4783]or j:Da(3205610732,0x1669522f,0x2a78af7e,0x4783),v,0x80,t[1][0b10][t[1][1]],_ end else A=q<a and(j.Aa[0xd9a]or j:Ea(0x10,0x5be9f45a,2751605083,0xd9a))or 0x593c8/A end elseif A<0x1d8 then if A>0b111010101 then A,p=A+0x1cb,C else A=y>z and(j.Aa[-0xdf8]or j:Fa(0b110100000,0x764d,-0xdf8))or A+-0b100100 end elseif A<=0x1d8 then A,q[0b1010]=0x1894b8/A,a y,K,G,z=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],"B"else q[0b1001]=a A=k>=H and(j.Aa[0x3cca]or j:Fa(0b100010001,0x75fe,0x3cca))or(j.Aa[0x50a9]or j:Fa(0b100000000,0x7475,0x50a9))end elseif A>=0b111001110 then if A>0b111010011 then A,o=j.Aa[0xb7e]or j:Da(3842511217,0x513fd,0xb5191,0xb7e),o(D,f)D=0b111 D=y*D elseif A>=0x1d2 then if A>0b111010010 then J=J(p,j.i(C))p,C,A,a,o=t[1][0b10][t[1][1]],G,j.Aa[-0x6471]or j:Ca(0xc91b7f3,0x64424e,-0x6471),J,0b10000000 else q[0b10]=a K,A,y,z,G=t[0b11][0b10][t[0b11][1]],j.Aa[0x5ede]or j:Ea(0b1000,0x3ca36c9a,0x414c23c7,0x5ede),t[0b1001][0b10][t[0b1001][1]],"B",t[0b110][0b10][t[0b110][1]]end else G[0b11100]=J C,p=0,G[0x1e]J=p~=C A=J and(j.Aa[0x693b]or j:Da(0x4c581f5d,0x423b893,0x1c042af4,0x693b))or(j.Aa[-0x1e4d]or j:Fa(0x210,0x762d,-0x1e4d))end elseif A<0b111001001 then if A>0b111000111 then A=L>d and A+-0x16b or(j.Aa[-0x31b4]or j:Ca(2351466379,0x431751fa,-0x31b4))else q=q+y A=y>0 and(j.Aa[0x7a6a]or j:Ca(0xb6f35f,0x230805c3,0x7a6a))or A+-0b1110101 end elseif A>0b111001001 then K,C,G,p,J,A,o=t[0b111][0b10][t[0b111][1]],z,v,t[0b1100][0b10][t[0b1100][1]],t[0b1011][0b10][t[0b1011][1]],0x465-A,0x7f else h,w,H,a=0xaf,0xfd,0x97,0xd3 A=v<=a and(j.Aa[-0x1c47]or j:Fa(0b1010,0x76e6,-0x1c47))or 0x6c8f5/A end elseif A>=0x202 then if A<=0x20a then if A<0x208 then if A<=0x202 then A,D=j.Aa[0x561e]or j:Da(0x5962eff,0x162c975b,2983987042,0x561e),j.h(D(f,F))else A,q[0b11111]=0x51c-A,a end elseif A>=0x209 then if A>0x209 then z,K,y,A,G="B",t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],0x425-A,t[0b110][0b10][t[0b110][1]]else A,a=j.Aa[-0x691]or j:Fa(0x244,0x7439,-0x691),y end else K=K+J A=J>0 and(j.Aa[0x7993]or j:Fa(0x804,0x75d5,0x7993))or(j.Aa[0x7d6a]or j:Fa(0x4da,0x7df6,0x7d6a))end elseif A<0x20f then if A>0x20c then A,G=0x41c00/A,J else q=q(a,y,z)a,y=z,1 A,a=j.Aa[-0x5de9]or j:Da(0x1f23aaaf,0x13843f49,0xccfd5a4,-0x5de9),a+y t[0b110][0b10][t[0b110][1]]=a end elseif A>0x20f then A=d<i and A+-0x1d4 or(j.Aa[-0x2643]or j:Da(3504862383,0xebb076,0x271c5079,-0x2643))else G,y,A,K,z=t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]],0x2eb45/A,t[0b11][0b10][t[0b11][1]],j.Aa[-0xd0c]or j:Ba(j.q"D|{y",j.q"6#",-0xd0c)end elseif A>0x1fb then if A<0x200 then K=K(G,j.i(J))A,v,J,G,p=0x565-A,K,z,t[1][0b10][t[1][1]],0x80 elseif A<=0x200 then J,p=nil,0b11 A=G==p and 0x52000/A or(j.Aa[0x422c]or j:Da(3317720045,0x17124d6f,0x313bdbe,0x422c))else A,M=0x537-A,c end elseif A>0x1f4 then if A>0b111110110 then y,A,z,K,G=t[0b1001][0b10][t[0b1001][1]],0x42c-A,"b",t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]else q[1]=a A=k<=H and(j.Aa[0x50a9]or j:Ea(0x19,4207742428,0x20317,0x50a9))or(j.Aa[-0x38af]or j:Ca(3529715966,0x18c78f,-0x38af))end elseif A<0b111110010 then A=y>z and(j.Aa[0x3043]or j:Da(4010641258,0xb0cff,0x66f5ca,0x3043))or 0x463-A elseif A>0b111110010 then A=J and A+-0b100110 or(j.Aa[0x1cda]or j:Ea(0b100001000,0x52ec81be,2349957242,0x1cda))else a,A,t[0b110][0b10][t[0b110][1]]=y,j.Aa[0b11100110]or j:Fa(0x82,0x7645,0b11100110),z end elseif A>0x197 then if A<0b110101101 then if A<=0b110100001 then if A>=0x19f then if A>0b110100000 then z=0 J,K,G=1,z,0b100 A=G~=G and A+0x21b or 0x529-A elseif A>0b110011111 then A,q[0b1001]=0x508a0/A,a else C,A,p,o,D=j.Aa[0x1db3]or j:Ba(j.q"oyP",j.q"qW",0x1db3),j.Aa[0x698]or j:Da(0x521673ff,0x7448d840,0x1437aef8,0x698),t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]end elseif A>0b110011000 then y=y(z,K,G)z,K=G,1 z=z+K A=h<K and 0x1c3-A or 0x5f028/A else q[0x10]=a K,z,y,A,G=t[0b11][0b10][t[0b11][1]],"b",t[0b1001][0b10][t[0b1001][1]],j.Aa[0x4c04]or j:Ca(2509791211,0x222622b3,0x4c04),t[0b110][0b10][t[0b110][1]]end elseif A>0b110100111 then A,J=0x35654/A,j.h(J(p,C))elseif A<=0x1a6 then y=y(z,K,G)K,z=1,G z=z+K t[0b110][0b10][t[0b110][1]]=z A=k>=K and 0x57b-A or 0x54c-A else v=0x1a A=H<=v and(j.Aa[-0x5fc]or j:Ca(0x2ec2dbbd,0x1130044a,-0x5fc))or A+-0x171 end elseif A>=0b110111101 then if A>0b111000000 then if A<=0b111000011 then A,a=j.Aa[-0x7b84]or j:Ca(3380297693,0x3280009f,-0x7b84),y else A,a=A+0b111101,y end elseif A>0x1bf then A,J=j.Aa[-0x38af]or j:Ca(2942397599,0x86128e,-0x38af),1/-0 elseif A<=0x1bd then A=y<z and A+-0b100010100 or(j.Aa[-0x53dd]or j:Ca(3347339255,0x2878a27b,-0x53dd))else A=i>_ and(j.Aa[-0x5ad8]or j:Ea(0b1001,0x62a805ea,0x19110073,-0x5ad8))or 0x24a-A end elseif A>0x1b1 then A=i~=i and 0x459d8/A or(j.Aa[-0x2baf]or j:Fa(0b10000100,0x7678,-0x2baf))elseif A>=0x1af then if A<=0x1af then A,q[0b1001]=j.Aa[-0x5040]or j:Ca(0x5463691f,0x8849c9f,-0x5040),a y,K,G,z=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],"B"else A=K~=K and(j.Aa[0x7d06]or j:Ca(3026099839,0xb8102f6,0x7d06))or(j.Aa[0x2e19]or j:Ea(0x226,2510325770,0x685e0362,0x2e19))end else A=d>i and 0x1ee-A or(j.Aa[-0x32a5]or j:Fa(0b1000010,0x748c,-0x32a5))end elseif A>0x188 then if A<0x193 then if A>=0x18f then if A<=0b110001111 then q=q+y A=y>0 and(j.Aa[0x3f77]or j:Ca(0x73a11bf9,2286420817,0x3f77))or 0x1b2d9/A else y=y(z,K,G)K,z=1,G A,z=0x18bb8/A,z+K t[0b110][0b10][t[0b110][1]]=z end elseif A>0b110001001 then A=i~=i and A+0x23b or A+-0b111010 else K,z,A,G,y=t[0b11][0b10][t[0b11][1]],"B",A+-0xc0,t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]]end elseif A<=0b110010101 then if A>=0b110010100 then if A>0b110010100 then A,a=j.Aa[-0x380f]or j:Ea(0x300,0x854b13a,3844750035,-0x380f),y else y=y(z,K,G)A,z,K=A+0x1a3,G,1 z=z+K end else q[0b111]=a G,K,y,A,z=t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],0x5240c/A,j.Aa[-0x5fc8]or j:Ba(j.q")q>a",j.q">i",-0x5fc8)end else A=q<a and(j.Aa[0x76fb]or j:Ca(0x36b84fef,0x48041377,0x76fb))or A+0x91 end elseif A<=0x181 then if A>0b101111000 then if A>0b101111100 then A=y<=0 and(j.Aa[0x747b]or j:Ca(0x463f2b8d,0x18c08399,0x747b))or A+-0b11110100 else A=C<=0 and 0x5d840/A or 0x4b3d4/A end elseif A>=0b101110011 then if A<=0b101110011 then q[0b1010]=a K,A,z,G,y=t[0b11][0b10][t[0b11][1]],j.Aa[-0x5801]or j:Da(0xb74f7fe,0x2ea29d01,0x55656c9d,-0x5801),"B",t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]]else a,A,t[0b110][0b10][t[0b110][1]]=y,0x13760/A,z end elseif A>0b101101110 then A=K<G and A+0x24c or 0x41510/A else q[0b1001],H,k=a,0xec,0b10100111 z,K,y,A,G="B",t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],j.Aa[0x3e9c]or j:Fa(0x617,0x726c,0x3e9c),t[0b110][0b10][t[0b110][1]]end elseif A>=0b110000111 then if A>0x187 then y=y(z,K,G)K,z=1,G A,z=j.Aa[0x643c]or j:Ea(0x68,0x1bf7a1bf,2148050630,0x643c),z+K else A=K>0 and(j.Aa[0x2af6]or j:Da(2696610813,0xd5c1b91,0x46a49646,0x2af6))or(j.Aa[-0x2ab3]or j:Ea(0x110,0x2c22e1da,3280325041,-0x2ab3))end elseif A<=0b110000011 then A,q[0b1010],H,k=j.Aa[-0x3a2d]or j:Ea(0x40,0x5dbf11f2,2181045946,-0x3a2d),a,0x8f,0b1001 y,K,z,G=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],"B",t[0b110][0b10][t[0b110][1]]else A=K>G and 0x5acac/A or 0x3c976/A end elseif A>=0x121 then if A>=0b101001110 then if A<0b101011101 then if A>0x154 then if A>=0x15a then if A<=0x15a then J=0 A=H>=J and 0x2706c/A or 0x23bb6/A else y=y(z,K,G)K,z=1,G z=z+K t[0b110][0b10][t[0b110][1]]=z A=H<=K and(j.Aa[-0x4539]or j:Fa(0x10a,0x7548,-0x4539))or 0x16014/A end elseif A<=0x158 then A,v=j.Aa[0x77d8]or j:Ca(0x240072be,2550497398,0x77d8),0b111 else A,a=A+0x291,y end elseif A>=0x151 then if A>0x152 then A,y=j.Aa[0x3dac]or j:Fa(0x2c2,0x76ec,0x3dac),y(z,K,G)K,z=1,G z=z+K elseif A<=0b101010001 then q[0b10001]=a A=k<H and(j.Aa[0x50a9]or j:Fa(0x110,0x7465,0x50a9))or 0x84f5/A else A=y<=0 and(j.Aa[-0x52d0]or j:Fa(0x14,0x77ef,-0x52d0))or 0x2d8d0/A end elseif A>0x14e then A=i<=0 and 0x515-A or A+-0xc4 else y,K,A,z,G=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],0x39b-A,"B",t[0b110][0b10][t[0b110][1]]end elseif A<=0x166 then if A<=0b101100011 then if A<0x15e then q[0b1001]=a z,y,K,A,G=j.Aa[-0x5fc8]or j:Ba(j.q"YdmH",j.q"RR",-0x5fc8),t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],0x36df4/A,t[0b110][0b10][t[0b110][1]]elseif A<=0b101011110 then A=C>0 and 0x3eb-A or A+0b11011100 else a,A,t[0b110][0b10][t[0b110][1]]=y,j.Aa[0x5a13]or j:Fa(0x48,0x7440,0x5a13),z end elseif A>0b101100100 then y=y(z,K)a=not y A=a and(j.Aa[0xc40]or j:Ca(4113617660,0xa472865,0xc40))or A+-0xd1 else A,t[0b110][0b10][t[0b110][1]],a=0x304-A,z,y end elseif A<=0b101101100 then if A<=0x16b then if A<=0b101101000 then A,q[0x13]=j.Aa[-0x2b40]or j:Ea(0b1000000,0x8f3955b,0x4000224,-0x2b40),a z,G,K,y="B",t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]else y=y(z,K,G)z,K=G,0b10 z=z+K A,t[0b110][0b10][t[0b110][1]]=j.Aa[-0x3708]or j:Fa(0,0x76ea,-0x3708),z end else A,z,K=A+0x20b,t[0b101][0b10][t[0b101][1]],y end else A,y=0x1b9fe/A,y(z,K,G)z,K=G,1 z=z+K end elseif A<0x134 then if A<0b100101111 then if A>=0x124 then if A<=0x124 then A=L<d and 0x12c-A or(j.Aa[0x12be]or j:Da(2967051964,0x6d1d5bc,0x392e6dfe,0x12be))else a,t[0b110][0b10][t[0b110][1]]=y,z A=h>w and A+0b101000 or A+-0x85 end elseif A<=0b100100001 then A,q[0b1001]=0x37f39/A,a else A=C~=C and 0x301-A or(j.Aa[-0x7f58]or j:Da(3530781611,0x153336f,0x30cfcc,-0x7f58))end elseif A>=0x132 then if A>0b100110010 then a,t[0b110][0b10][t[0b110][1]]=y,z A=H>=w and A+0b1101110 or(j.Aa[0x7126]or j:Fa(0b100100000,0x764d,0x7126))else A=i>0 and(j.Aa[-0x755b]or j:Fa(0x180,0x7575,-0x755b))or(j.Aa[0x74f6]or j:Ca(3775342519,0x1030d9b4,0x74f6))end elseif A>0x12f then A,p=j.Aa[0x6b1]or j:Ca(0x8ad6bde,0x2750925d,0x6b1),C else v=v(q,a,y)a,A,q=1,j.Aa[-0x6461]or j:Da(3264022247,0xb03153,0x1761ef04,-0x6461),y q=q+a t[0b110][0b10][t[0b110][1]]=q end elseif A<0b101000000 then if A<0b100111100 then if A<=0x134 then y=y(z,K,G)z,K=G,1 A,z=0x2ac-A,z+K else a,t[0b110][0b10][t[0b110][1]]=y,z A=H>=h and 0x39f-A or(j.Aa[0x7ccf]or j:Ca(4280242159,0x6011b0,0x7ccf))end elseif A>0b100111100 then t[0b110][0b10][t[0b110][1]],a=z,y A=h<w and(j.Aa[-0x581]or j:Ca(0x45fdc2ff,0x380005fd,-0x581))or A+-0x93 else A=K<=0 and 0x2f9-A or A+0x137 end elseif A<0x143 then if A>0b101000000 then q[0b1010]=a G,K,A,y,z=t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],0x6d3-A,t[0b1001][0b10][t[0b1001][1]],"B"else A=y~=y and 0x4c9-A or 0x2c1-A end elseif A<=0b101000101 then if A>0b101000011 then A=i<_ and(j.Aa[0xc40]or j:Ca(0x68ce13f6,0x10116064,0xc40))or(j.Aa[0x1b03]or j:Ea(0b11,3890488659,0x1009027b,0x1b03))else A=q>a and A+0x224 or(j.Aa[-0x74f0]or j:Ca(2333822930,0x10a43177,-0x74f0))end else q[0b1001]=a A=k>H and 0x466-A or A+-0b10100110 end elseif A<0b11110111 then if A<=0b11101000 then if A>0b11100011 then if A<0xe7 then if A<=0xe5 then A,d=A+-0b10011100,i else A,q[1],k,H=j.Aa[0xe9a]or j:Ca(0xd514bff,2458521429,0xe9a),a,0b1100101,0b1001001 K,z,G,y=t[0b11][0b10][t[0b11][1]],"B",t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]]end elseif A>0xe7 then A,v=j.Aa[0x77d8]or j:Fa(0b10010,0x764a,0x77d8),0x1a else q=0b10100 A=_>=q and A+-0xd2 or(j.Aa[0xb01]or j:Da(0x5c9ceb6b,0x10f9ccdf,0x10093789,0xb01))end elseif A>0b11011111 then if A>0b11100001 then k,d=0b110,0 v,i,_=1,d,0b100 A=_~=_ and 0x147-A or 0x2c560/A else q=0b10110 A=_<=q and 0xe1/A or(j.Aa[-0x607e]or j:Ca(0x1351c3df,3894550654,-0x607e))end elseif A>=0xde then if A<=0b11011110 then k,n,u=0xbd,0b10111110,0b10011100 A=m~=n and 0x8ac/A or(j.Aa[0x4f37]or j:Ca(3323656651,0x2084064c,0x4f37))else A,v=0x2f0a/A,0b1000110 end else A,d=A+0x27e,"c"d,L=t[0b1001][0b10][t[0b1001][1]],d..x v,i,_=t[0b110][0b10][t[0b110][1]],L,t[0b11][0b10][t[0b11][1]]end elseif A<0xf0 then if A>0xec then A,v=0x123-A,0b1000110 elseif A>0xea then A=0x269a8/A elseif A<=0b11101001 then q=0b1001 A=_<q and 0b110011111-A or(j.Aa[0x952]or j:Fa(0b100001,0x764f,0x952))else H,q=0x81,0b100010 A=_>=q and(j.Aa[0x3bd]or j:Da(3676631895,0xdf665d2,0x129ba6bf,0x3bd))or 0x5994/A end elseif A>0xf5 then A,q,v=A+0x1db,_,t[0b101][0b10][t[0b101][1]]elseif A<=0xf1 then if A>0xf0 then A,a=j.Aa[0x1c36]or j:Fa(0x110,0x76f4,0x1c36),y else i="c"d,i=i..L,t[0b1001][0b10][t[0b1001][1]]A,q,_,v=A+-0b1001000,t[0b110][0b10][t[0b110][1]],d,t[0b11][0b10][t[0b11][1]]end else q=0x37 A=_>q and(j.Aa[-0xde9]or j:Ea(0x10,3174443829,0x40c9002c,-0xde9))or(j.Aa[-0x55a7]or j:Ea(0x24,0x2a39669a,0x41866827,-0x55a7))end elseif A<=0b100000001 then if A>0b11111100 then if A>0x100 then a,k=0x29,0x27 A=v>=a and 0x4cb-A or 0x461-A elseif A>=0b11111111 then if A<=0xff then t[0b110][0b10][t[0b110][1]],A,x=_,A+-0b1000,i else A=A+0b111110000 end else A,q[1]=j.Aa[-0x1a1f]or j:Fa(0xc1,0x762c,-0x1a1f),a K,y,z,G=t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],"B",t[0b110][0b10][t[0b110][1]]end elseif A<0xf9 then if A<=0xf7 then d,i={},0 d[0x1a]=i _={}A,i=j.Aa[0x7518]or j:Ea(0x28,0x2bfce38a,0x44018a34,0x7518),_ d[0b1011]=i i=0 d[0x14]=i d[0b1100]=i else A,v=A+-0b11000010,0x90 end elseif A>=0xfa then if A<=0b11111010 then A,J=A+-0b1101100,p[C]else a=y A=k<=H and A+0b1110111 or 0x1c8c/A end else q=0b101100 A=_<=q and 0b111100001-A or(j.Aa[0x5080]or j:Fa(0b110,0x762a,0x5080))end elseif A>=0b100010100 then if A>=0b100011011 then if A>0x11b then z,A,G,K,y="b",A+0b111100001,t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]else G=0 C,p,J=1,0b100,G A=p~=p and(j.Aa[0x27a3]or j:Fa(0b100001100,0x76ba,0x27a3))or A+0x43 end elseif A>0x114 then A=y<=0 and 0x213d8/A or A+0x1d6 else i=i(_,v,q)_,v=q,1 _=_+v A,t[0b110][0b10][t[0b110][1]]=0xf6e4/A,_ end elseif A<=0b100001000 then if A>0x107 then A,t[0b110][0b10][t[0b110][1]],z=j.Aa[-0xbbe]or j:Fa(0b11100,0x75f7,-0xbbe),p,J elseif A<=0x103 then a=y A=k>=h and 0x260-A or A+0x27e else l,c,e,A,r=t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],"B",0x3956b/A,t[0b110][0b10][t[0b110][1]]end else A=v~=v and A+0b100001000 or(j.Aa[0x10c9]or j:Fa(0b1110111,0x74f4,0x10c9))end elseif A>0x32d then if A<0x3ca then if A<0x381 then if A<0x359 then if A<=0x33f then if A>=0x336 then if A<=0x338 then if A<0x337 then r,b,e,l,A,s,c=t[0b1100][0b10][t[0b1100][1]],M,o,t[0b1011][0b10][t[0b1011][1]],0x2ea244/A,0b1111111,t[0b111][0b10][t[0b111][1]]elseif A>0x337 then p=p(C,o,D)A,o,C=A+-0b100010010,0b1000,D C=C+o t[0b110][0b10][t[0b110][1]]=C else A,t[0b110][0b10][t[0b110][1]],a=A+0x5c,z,y end elseif A>0x33e then w,h,a=0x68,0b11100111,y A=k<H and 0x9e0b5/A or 0x422-A else D=D(f,F,M)F,f=1,M f=f+F t[0b110][0b10][t[0b110][1]]=f A=k>=F and 0x5c6-A or(j.Aa[-0x4e25]or j:Ca(0xdf802f7,3758210302,-0x4e25))end elseif A<0x334 then if A>0x32e then A,v=A+-0x2f9,0xf1 else a=0b111 A=v<=a and 0x6d4-A or(j.Aa[0x40bc]or j:Da(0x241363f7,0x56e49b,3519917875,0x40bc))end elseif A<=0x334 then A,z,G,K,y=0xcbffc/A,"B",t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]else w,a,H,k=0x9e,0b10000001,0b10100,0x68 A=v<=a and(j.Aa[0x6a5e]or j:Da(0x7d52cf6f,0x1c43bf0,0xdcd55e,0x6a5e))or(j.Aa[0x3d6c]or j:Ea(0x109,0x75e713ba,0xa101da9,0x3d6c))end elseif A<0x34d then if A>0x344 then A,y,z,G,K=j.Aa[0x1f9c]or j:Fa(0x342,0x74ad,0x1f9c),t[0b1001][0b10][t[0b1001][1]],"B",t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]elseif A>0x342 then A,y=0x481-A,y(z,K,G)K,z=0b11,G z=z+K elseif A<=0x341 then A,q[0x11]=0x6f4-A,a y,K,G,z=t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],j.Aa[-0x5fc8]or j:Ba(j.q"a3_5",j.q"P5",-0x5fc8)else a=a(y,z)q=not a A=q and 0x383-A or 0x38f-A end elseif A>=0x353 then if A<=0x353 then A,q[0b1010]=j.Aa[-0x3cc1]or j:Da(0x7e95b62f,0x32588e82,0x4db1753b,-0x3cc1),a y,z,G,K=t[0b1001][0b10][t[0b1001][1]],"b",t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]else A,y=j.Aa[0x4c1c]or j:Fa(0x80,0x757d,0x4c1c),y(z,K,G)z,K=G,1 z=z+K t[0b110][0b10][t[0b110][1]]=z end elseif A<=0x34d then A=q>a and(j.Aa[0xd9a]or j:Ca(0x29eae6db,0x5204001b,0xd9a))or(j.Aa[0x241d]or j:Ca(0x533b1144,2697259377,0x241d))else A=q>a and(j.Aa[0xd9a]or j:Ca(0x5aea4eff,2684686619,0xd9a))or 0x468-A end elseif A>=0x367 then if A>0x377 then if A>=0x37d then if A>0x37d then A=K~=K and 0x6a6-A or A+-0x112 else c=c(e,l,r)l,e=1,r e=e+l t[0b110][0b10][t[0b110][1]]=e A=k<l and A+-0x2ec or 0x6fd7d/A end elseif A<=0x37b then D=D+F A=F>0 and 0xd25-A or(j.Aa[0x2806]or j:Da(0x4b12bdeb,0x3ee41c66,0x5148f285,0x2806))else A,t[0b110][0b10][t[0b110][1]],a=j.Aa[0x6f7d]or j:Fa(0x140,0x766e,0x6f7d),z,y end elseif A<0x371 then if A<=0x367 then a=0 z,y,K=0b100,a,1 A=z~=z and A+-0x2be or(j.Aa[0x5682]or j:Fa(0b10001,0x7408,0x5682))else t[0b110][0b10][t[0b110][1]],h,k,A,H,a=z,0xc8,0x33,j.Aa[0x590f]or j:Fa(0b101100000,0x7624,0x590f),0x70,y end elseif A<=0x373 then if A<=0x371 then A=0x573-A else A,a=j.Aa[0x2804]or j:Fa(0b1100010,0x776a,0x2804),a(y,j.i(z))d,K,z,y=a,0b10000000,q,t[1][0b10][t[1][1]]end else z=z(K)K,G=1,y J=K A=G~=G and(j.Aa[0x3bbf]or j:Da(0x7387b6de,0x44d62b,0x41b3287,0x3bbf))or(j.Aa[-0x74ef]or j:Fa(0b1011001,0x7598,-0x74ef))end elseif A<0x360 then if A>=0x35d then if A<=0x35d then a=a(y)z,y=q,1 K=y A=z~=z and 0x5a5-A or(j.Aa[-0x66f4]or j:Da(3167886079,0x5504f0,0x1b842b6,-0x66f4))else A=0xb675e/A end elseif A<=0x359 then n=n(x,L,d)x,L=d,1 A,x=A+-0x2c1,x+L t[0b110][0b10][t[0b110][1]]=x else d=d(i,_,v)i=v i=i+x A=k<u and(j.Aa[-0x3417]or j:Da(0x2ff07cff,0x2b76,0x15838,-0x3417))or 0x724-A end elseif A<0x365 then if A<=0x360 then H,y,z,A,h,K,G=0b11101001,t[0b1001][0b10][t[0b1001][1]],"B",A+-0b10000010,0xae,t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]else A,l=A+0x7d3,j.h(l(r,b))end elseif A>0x365 then G=G(J,p)K=not G A=K and A+-0x34b or(j.Aa[-0x5f34]or j:Ea(0b10000010,3187798440,0x9a95af,-0x5f34))else y=y+K A=K>0 and 0x9c7-A or 0x81c-A end elseif A>=0x3a6 then if A<0x3b9 then if A<0x3ae then if A>0x3ab then t[0b110][0b10][t[0b110][1]],a,H,A,k=z,y,0b101001,A+-0b1101011,0x2a elseif A>=0x3aa then if A<=0x3aa then y=y(z,K,G)A,K,z=j.Aa[0x887]or j:Ca(0x2304ebf7,2483098619,0x887),1,G z=z+K else A,q[0b11110]=A+0x6cb,a G,z,K,y=t[0b110][0b10][t[0b110][1]],"B",t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]end else a,k=0b100,0b1000111 A=v<=a and(j.Aa[0x4182]or j:Fa(0,0x7771,0x4182))or(j.Aa[0x7d18]or j:Fa(0x240,0x760e,0x7d18))end elseif A<0x3b3 then if A>0x3ae then A=v~=v and(j.Aa[-0x5ad8]or j:Da(0x29afb17b,0x72887b28,0x4d77d363,-0x5ad8))or 0xf753/A else J,A,f,C,o,p,D=t[0b111][0b10][t[0b111][1]],A+-0b111011010,0x7f,t[0b1011][0b10][t[0b1011][1]],t[0b1100][0b10][t[0b1100][1]],a,G end elseif A>0x3b3 then y=y+K A=K>0 and 0xacf-A or A+0xa99 else y=y(z,K,G)z,K=G,0b11 z=z+K A=w>=K and(j.Aa[0x73c7]or j:Ea(0x214,3939210462,0x4308873,0x73c7))or A+-0x2ef end elseif A<=0x3c2 then if A>0x3bd then if A>0x3c1 then y=y+K A=K>0 and(j.Aa[-0x1164]or j:Da(2493063163,0x6e79031,0x193f32c2,-0x1164))or A+-0x286 else A,q[0b1001]=0xa12ef/A,a G,y,K,z=t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],"B"end elseif A<=0x3bc then if A>0x3b9 then A,y=j.Aa[-0x41a1]or j:Ea(0x2c,3458283402,0x163164,-0x41a1),z else a,k,t[0b110][0b10][t[0b110][1]],A,H=y,0b10011011,z,0x74cc6/A,0b11001011 end else J=J(p,C,o)p,C=o,1 A,p=j.Aa[0x344]or j:Da(0x38feb9f,0xcf264f1,0x6b7dad3d,0x344),p+C t[0b110][0b10][t[0b110][1]]=p end elseif A<0x3c6 then if A<=0x3c3 then A,y=j.Aa[0x66b]or j:Ca(4191215607,0xa01c3,0x66b),y(z,K,G)z,K=G,1 z=z+K t[0b110][0b10][t[0b110][1]]=z else A=L<d and A+-0x368 or(j.Aa[-0x71df]or j:Ca(0x602bfd8c,0x78402cf,-0x71df))end elseif A>0x3c6 then G=x[y]C,p=0,G[0b11100]J=p~=C A=J and(j.Aa[-0x537b]or j:Ca(3387752095,0x16100382,-0x537b))or 0x762a0/A else G,w,h,K,y,A,z=t[0b110][0b10][t[0b110][1]],0b11000000,0x88,t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],j.Aa[-0x5699]or j:Da(0x25ed99a,0x25c26b08,0x3b5dbccb,-0x5699),"B"end elseif A<=0x391 then if A>0x388 then if A<0x38f then if A>0x389 then J=J+C A=C>0 and(j.Aa[0x13f6]or j:Fa(0x260,0x74e4,0x13f6))or(j.Aa[-0x54d0]or j:Da(0x67e7c7b9,0x2887c6bb,0x6f78643a,-0x54d0))else A=q<a and 0x5f73/A or(j.Aa[0x47ca]or j:Da(0x41015bed,0x88d9fca,0xa6ce4c5,0x47ca))end elseif A<=0x38f then q[0x13]=a K,A,y,z,G=t[0b11][0b10][t[0b11][1]],A+-0b111111011,t[0b1001][0b10][t[0b1001][1]],"B",t[0b110][0b10][t[0b110][1]]else A,a=j.Aa[0x4e81]or j:Da(2749213694,0x409642d0,0x1b6bd527,0x4e81),y end elseif A>=0x384 then if A>0x385 then A=J>0 and(j.Aa[-0x27d3]or j:Ea(0b101,0x2837d3b0,0x4600c1a1,-0x27d3))or 0x606-A elseif A<=0x384 then M=M(c,e)A,c=0x33db0/A,0b111 c=J*c else A=v~=v and(j.Aa[-0x781d]or j:Fa(0x300,0x756d,-0x781d))or A+-0b101101111 end elseif A>0x381 then A,v=j.Aa[0x77d8]or j:Da(3265337014,0x4152799,0xc06e09e,0x77d8),0b11010 else A,a,t[0b110][0b10][t[0b110][1]]=j.Aa[-0x25e0]or j:Ca(0x7e00d37e,0x6b2d6f,-0x25e0),y,z end elseif A<=0x39b then if A<0x397 then if A<=0x393 then A,q[0b1001]=0x6ac-A,a else A,J=j.Aa[-0x79f4]or j:Ca(3528706811,0x24040356,-0x79f4),J(p,C,o)C,p=1,o p=p+C t[0b110][0b10][t[0b110][1]]=p end elseif A>=0x399 then if A>0x399 then A=K>G and(j.Aa[0x3bbf]or j:Ea(0b10,2150979039,0x654a0091,0x3bbf))or(j.Aa[-0x2dbe]or j:Ca(0x55a8439b,2186675851,-0x2dbe))else A=L>d and A+-0x391 or(j.Aa[0x74f6]or j:Ca(0x8fb05f7,4110453692,0x74f6))end else A=F>0 and(j.Aa[-0x3858]or j:Ea(0x470,0x1b28813,3259304336,-0x3858))or(j.Aa[0x4943]or j:Ea(0x208,2574760662,0x460025db,0x4943))end elseif A<0x3a0 then G=t[0b1010][0b10][t[0b1010][1]]K=G[z]A,v[q]=0x66f99/A,K elseif A<=0x3a0 then A=y>0 and(j.Aa[-0x49b7]or j:Da(3291117567,0xc6daa04,0x1766e149,-0x49b7))or 0x4e0-A else o,A,D,F,C,M,f=z,j.Aa[0x76e5]or j:Da(0x106d5f7f,0x582d48c7,0x106340b8,0x76e5),t[0b1011][0b10][t[0b1011][1]],p,t[0b111][0b10][t[0b111][1]],0x7f,t[0b1100][0b10][t[0b1100][1]]end elseif A>=0x81f then if A<=0xc04 then if A<=0xb0f then if A>=0x9aa then if A>0xa5c then if A<=0xa76 then A,y=0x1d2d1c/A,y(z,K,G)K,z=1,G z=z+K else A=F<=0 and(j.Aa[0xd7]or j:Fa(0x56a,0x7344,0b11010111))or A+-0xa08 end elseif A<0x9f3 then A=D>f and(j.Aa[0x5083]or j:Ca(0x29ada73f,3225553885,0x5083))or 0x1695-A elseif A<=0x9f3 then A=F~=F and 0x1ef987/A or(j.Aa[0x79ea]or j:Ea(0x104,4209576010,0x5000557,0x79ea))else A=K>G and(j.Aa[0x3bbf]or j:Ea(0b10000010,3355377820,0x10000916,0x3bbf))or(j.Aa[-0x73b2]or j:Fa(0x304,0x7c14,-0x73b2))end elseif A<=0x928 then if A>=0x8b9 then if A<=0x8b9 then A=D<f and 0x1b27f5/A or 0x12ac-A else A=i<=0 and(j.Aa[-0x759c]or j:Ea(0b100110,2344139208,0x64419db3,-0x759c))or(j.Aa[-0x367]or j:Ea(0x440,3671158687,0x10a2ead,-0x367))end else y=y(z,K,G)A,K,z=A+-0x50d,1,G z=z+K end elseif A>0x97f then A=L<d and(j.Aa[0x3990]or j:Fa(0x18,0x7629,0x3990))or(j.Aa[-0x367]or j:Ca(0x2281dceb,2353794808,-0x367))else f=f(F,M)F=0b111 F=K*F A=k>M and A+-0x666 or 0x20ae0f/A end elseif A<=0xbbc then if A>0xb7c then if A>0xba7 then A=K<G and(j.Aa[-0x4935]or j:Fa(0b110110100,0x75d4,-0x4935))or A+-0x69a else A=y<z and(j.Aa[0x3043]or j:Da(2170720232,0xca10242,0x45fc500b,0x3043))or 0x17c6-A end elseif A<=0xb55 then if A<=0xb35 then c=c(e,j.i(l))r,A,o,l,e=0x80,0x192c0b/A,c,M,t[1][0b10][t[1][1]]else y=y(z,K,G)A,z,K=j.Aa[-0x3981]or j:Ea(0x155,0x48fd993,0x7b50d2ce,-0x3981),G,1 z=z+K end else A=J<=0 and 0x1aa9-A or 0x1924-A end elseif A<=0xbcd then if A<=0xbbd then A=K>G and(j.Aa[-0x4935]or j:Ea(0b1100,0x2777a9df,0x408823bc,-0x4935))or(j.Aa[0x7d6a]or j:Ea(0xa18,0x3b6595b3,0x449807fb,0x7d6a))else A=K~=K and(j.Aa[-0xdf8]or j:Ea(0b100000000,0x12be3796,0x90123ad,-0xdf8))or 0x2c9f28/A end else A=y<z and 0xda5-A or 0x17d1-A end elseif A<0xe76 then if A<0xd13 then if A>=0xce8 then if A>0xce8 then A=F<=0 and(j.Aa[-0x319a]or j:Da(0x7acd28b9,0x63be5fa9,0x1d53aa10,-0x319a))or(j.Aa[-0xa09]or j:Fa(0x971,0x7f8f,-0xa09))else A=i~=i and A+-0xc8b or(j.Aa[-0x71df]or j:Ca(2705513949,0xca902ae,-0x71df))end elseif A>0xc1f then A=D>f and 0x26b8b0/A or(j.Aa[0x4943]or j:Ea(0x201,3497411006,0x2209469e,0x4943))else A=K~=K and A+-0x9d7 or(j.Aa[0x5069]or j:Fa(0x200,0x7795,0x5069))end elseif A<0xda8 then if A>0xd13 then y=y(z,K,G)K,A,z=1,j.Aa[0x7405]or j:Ea(0x29,4230214472,0x1cce36b,0x7405),G z=z+K else A=K<G and A+-0xc81 or 0x21c20f/A end elseif A<=0xda8 then A=J~=J and 0xe3a-A or(j.Aa[0x50eb]or j:Ea(0x204,0xb4c7cf2,0x14133195,0x50eb))else A=K<=0 and A+-0x24d or A+-0x284 end elseif A>=0xf2d then if A>0xfd2 then A=J<=0 and(j.Aa[-0x1442]or j:Da(0x64c7ffbd,0x262d99d,0xb53221,-0x1442))or(j.Aa[0x1c95]or j:Da(3260747179,0x6d80ca7,0x22c7f8cb,0x1c95))elseif A>0xfb7 then y=y(z,K,G)A,z,K=j.Aa[0x5515]or j:Fa(0x220,0x76a2,0x5515),G,1 z=z+K elseif A<=0xf2d then A=K<G and(j.Aa[0x3bbf]or j:Da(0x24b39092,0x53649ca,0x53cdc5f5,0x3bbf))or 0xcf3e88/A else o=o(D,f,F)A,D=0x2c90fa/A,F D=D+p end elseif A<0xebd then if A>0xe76 then r=r(b,s)A,b=j.Aa[0xc3d]or j:Ca(0x34443fdf,0xaaa035f,0xc3d),0b111 b=D*b else y=y(z,K,G)z,A,K=G,0xfa9-A,1 z=z+K end elseif A<=0xebd then A,C=A+-0x999,C(o,j.i(D))f,o,D,z=0x80,t[1][0b10][t[1][1]],p,C else A=L>d and(j.Aa[0x3990]or j:Ea(0x48,0x4ea250b0,2165660029,0x3990))or(j.Aa[-0x1686]or j:Fa(0x908,0x7744,-0x1686))end elseif A<=0x3fb then if A<=0x3ea then if A>0x3d7 then if A<=0x3e3 then if A>=0x3de then if A<=0x3de then G=0 A=K==G and(j.Aa[-0x1411]or j:Da(3140153334,0x199487,0x366e62,-0x1411))or 0x5f8-A else p=0b10 A=G==p and 0x64cfd/A or(j.Aa[-0x38af]or j:Fa(0b10001110,0x7668,-0x38af))end else A=d>i and(j.Aa[-0xc75]or j:Ea(0b1000000,4274909184,0x1041c1,-0xc75))or 0x60f-A end else q[0b1010]=a z,y,G,A,K="B",t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]],0x51e-A,t[0b11][0b10][t[0b11][1]]end elseif A>0x3d3 then if A<=0x3d5 then A,a=j.Aa[0x162f]or j:Da(0x5fd567fb,0x320c6de2,0x4dfe2de3,0x162f),y else t[0b110][0b10][t[0b110][1]],A,a=z,0x4feab/A,y end elseif A<0x3d1 then if A>0x3ca then A,G,K,y,z=0x643ee/A,t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],"B"else a,H,k=0x29,0x25,0xa7 A=v>a and(j.Aa[-0x37be]or j:Da(0x6b9e860f,0x7b5b7d9e,0x8a48db1,-0x37be))or(j.Aa[0x3790]or j:Ea(0x34,0x40a1e5b8,0x3124326,0x3790))end elseif A<=0x3d1 then y=y(z,K,G)K,z=1,G A,z=0x710-A,z+K t[0b110][0b10][t[0b110][1]]=z else y,A,a=q,j.Aa[0x3a77]or j:Ea(0x314,2908963242,0x2084b69,0x3a77),t[0b101][0b10][t[0b101][1]]end elseif A<=0x3f6 then if A>=0x3f4 then if A>0x3f5 then A,q[0b1010]=j.Aa[-0x50ab]or j:Fa(0b110001010,0x744e,-0x50ab),a z,K,G,y="B",t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]]elseif A>0x3f4 then p=0b101 A=G==p and A+-0x118 or(j.Aa[-0x52b9]or j:Ea(0,0x2d2e958a,0x200023f,-0x52b9))else t[0b110][0b10][t[0b110][1]],A,a=z,j.Aa[-0x35dd]or j:Ea(0x1da,0x32eee3bb,3305162120,-0x35dd),y end elseif A>0x3f0 then a,A,t[0b110][0b10][t[0b110][1]]=y,A+-0b1001000,z else A=J<p and(j.Aa[0x27a3]or j:Ca(2744224222,0x84441fe,0x27a3))or(j.Aa[-0x7f58]or j:Ca(0xf20ff6b,0x70dd032f,-0x7f58))end elseif A<=0x3fa then if A<=0x3f9 then C,o,J,A,p=t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]],j.Aa[0x3b24]or j:Fa(0x28c,0x75d9,0x3b24),"B"else y=y(z,K)A,z=A+-0x33e,0b111 z=L*z end else y=y(z,K,G)K,z=1,G z=z+K A,t[0b110][0b10][t[0b110][1]]=j.Aa[-0x5e1]or j:Ca(2770090987,0x50c2467c,-0x5e1),z end elseif A>=0x591 then if A>0x691 then if A<0x758 then A=y>z and(j.Aa[-0xdf8]or j:Ca(0x1f1fcffb,3221234081,-0xdf8))or(j.Aa[0x5f7e]or j:Ea(0x410,0x6aa8bd92,2483292761,0x5f7e))elseif A>0x758 then p=p()A,z[K]=j.Aa[0x2eb9]or j:Fa(0b10000010,0x76f2,0x2eb9),p else y=y(z,K,G)z,A,K=G,0x1996a0/A,1 z=z+K end elseif A>=0x662 then if A<0x671 then A=y>z and A+-0x41a or 0xb19-A elseif A>0x671 then y=y(z,K,G)K,z=1,G A,z=0x91b13/A,z+K else y=y(z,K,G)K,A,z=1,j.Aa[0x75f5]or j:Fa(0x20,0x7708,0x75f5),G z=z+K end elseif A<=0x591 then A,y=0x783-A,y(z,K,G)K,z=1,G z=z+K else A,y=0x10949f/A,y(z,K,G)z,K=G,1 z=z+K end elseif A>0x4e0 then if A<=0x524 then if A<=0x522 then A=J~=J and(j.Aa[-0x4935]or j:Fa(0x308,0x77d8,-0x4935))or 0xe938e/A else o=o(D,f)C=not o A=C and 0x133270/A or A+-0x31c end else A=D<f and 0x10db02/A or 0x58fe6/A end elseif A>0x480 then if A<=0x4b7 then A=K<=0 and(j.Aa[0x4af9]or j:Ea(0x324,3497430506,0xf808bc7,0x4af9))or 0x10d6-A else A=J<=0 and A+0x833 or 0x775-A end elseif A<=0x3ff then if A<=0x3fd then A=J>0 and(j.Aa[0x4d7a]or j:Ca(4218894303,0x8843bb,0x4d7a))or A+-0x172 else p=0b100 A=G==p and 0x30f3c/A or(j.Aa[-0x7f30]or j:Da(0x11c233ef,0x1f28fad8,0x6f7550b,-0x7f30))end else C=C(o,D,f)A,D,o=A+-0x34f,1,f o=o+D t[0b110][0b10][t[0b110][1]]=o end elseif A<0x2a1 then if A<0x262 then if A<=0x236 then if A>0x226 then if A>=0x232 then if A>=0x235 then if A<=0x235 then v=v(q,a,y)q,a=y,1 A,q=j.Aa[-0x620d]or j:Ea(0x31,3297761432,0x3820c052,-0x620d),q+a t[0b110][0b10][t[0b110][1]]=q else z,K,A,y,G="B",t[0b11][0b10][t[0b11][1]],j.Aa[0x5d16]or j:Ca(3706155006,0x21081359,0x5d16),t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]]end elseif A<=0x232 then A=_~=_ and A+-0x1d or(j.Aa[0x6832]or j:Ea(0,3977072328,0x105200d8,0x6832))else A=v~=v and(j.Aa[0xc40]or j:Ea(0x20,0x4c646a93,2686017892,0xc40))or 0x271-A end elseif A>0x22f then y=y(z,K,G)A,K,z=j.Aa[-0x4ad7]or j:Fa(0xe1,0x76bd,-0x4ad7),1,G z=z+K t[0b110][0b10][t[0b110][1]]=z elseif A>0x22d then p=1 A=G==p and(j.Aa[-0x4119]or j:Ca(4208261079,0x10001c0,-0x4119))or(j.Aa[-0x565e]or j:Ea(0x363,0x73ca7499,0x101afd,-0x565e))elseif A<=0x228 then A=y~=y and A+0x13f or(j.Aa[-0x7688]or j:Ca(0x1b37755f,0x24c8013b,-0x7688))else A,y=0x59a-A,y(z,K,G)z,K=G,1 z=z+K end elseif A<=0x21b then if A>0x219 then if A<=0x21a then A,J=0x1bb6e/A,"c"G,J=J..K,t[0b1001][0b10][t[0b1001][1]]o,p,C=t[0b110][0b10][t[0b110][1]],G,t[0b11][0b10][t[0b11][1]]else y=y(z,K,G)z,K=G,1 A,z=A+-0x86,z+K t[0b110][0b10][t[0b110][1]]=z end elseif A<0x218 then if A<=0x216 then A=v<=0 and(j.Aa[-0x781d]or j:Ea(0,4090826192,0xc280309,-0x781d))or(j.Aa[-0x6437]or j:Ea(0,0x222ab21b,0x4455063f,-0x6437))else A=i<_ and A+-0x20c or 0x25a-A end elseif A<=0x218 then A,q[0b10001]=j.Aa[-0x6de]or j:Da(0x1abc9ffa,0x47f2b822,2567786294,-0x6de),a G,K,y,z=t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],"B"else a=a(y,z,K)z,y=1,K y=y+z t[0b110][0b10][t[0b110][1]]=y A=k>z and(j.Aa[0x39c6]or j:Ca(3677095903,0x24c3906e,0x39c6))or(j.Aa[-0x641b]or j:Ea(0b10000,2827244570,0x43141a7,-0x641b))end elseif A>=0x224 then if A>0x224 then A,J=j.Aa[-0x38af]or j:Ea(0b1010,2581160915,0x46060ac7,-0x38af),p else f=f(F,M)D=not f A=D and(j.Aa[0x27a3]or j:Ea(0b10000110,0x2a37099f,0x44c805d9,0x27a3))or 0x797b0/A end elseif A<=0x21e then A,q[0b1001]=0x11f0-A,a K,G,z,y=t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],"B",t[0b1001][0b10][t[0b1001][1]]else A,q[0b1001]=0x69b52/A,a end elseif A<=0x24a then if A<0x242 then if A<=0x23f then if A>=0x23a then if A<=0x23a then A=C~=C and(j.Aa[0x1a36]or j:Ca(3972654077,0x12121bf2,0x1a36))or A+-0b10111110 else e=e(l,r)c=not e A=c and A+0b11011110 or(j.Aa[0x4141]or j:Ca(0x7578437f,0xa001b7b,0x4141))end else a,t[0b110][0b10][t[0b110][1]]=y,z A=k<H and(j.Aa[0x79ea]or j:Fa(0b111,0x776a,0x79ea))or A+-0x151 end else A,q[0b11100]=0x6fb59/A,a end elseif A<=0x248 then if A<0x246 then p=p(C,o)J=not p A=J and 0x2eb-A or(j.Aa[-0x6b8a]or j:Da(0x1a3a7fea,0x2aa30fe1,0x1a20f3f6,-0x6b8a))elseif A<=0x246 then C=C(o,D,f)D,A,o=1,0x42eca/A,f o=o+D t[0b110][0b10][t[0b110][1]]=o else z,k,y=n,0b1110101,1 K=y A=z~=z and 0x3b748/A or A+-0xc1 end elseif A>0x249 then A=i>_ and A+-0b111100110 or 0x559-A else A=i<_ and 0x1923/A or A+0x168 end elseif A<=0x255 then if A<0x252 then if A<=0x24d then y=y(z,K,G)K,z=1,G z=z+K t[0b110][0b10][t[0b110][1]]=z A=h<=K and(j.Aa[0x4459]or j:Fa(0x30,0x7668,0x4459))or 0x319c5/A else A=J and(j.Aa[-0xcb2]or j:Fa(0x226,0x76d2,-0xcb2))or 0x1c855/A end elseif A<=0x252 then A,G=j.Aa[-0x1675]or j:Ca(0x4560dbaf,0x1a9007ee,-0x1675),J else A,q[0x11]=j.Aa[0x16e0]or j:Fa(0x24,0x7721,0x16e0),a K,z,y,G=t[0b11][0b10][t[0b11][1]],"B",t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]]end elseif A>=0x25c then if A>0x25c then A=v>0 and(j.Aa[0x6e4b]or j:Ea(0b11100000,2817294618,0x48000927,0x6e4b))or(j.Aa[0x2775]or j:Da(3655829391,0x43511e,0x1cd0011,0x2775))else A,o=0x2513c4/A,j.Aa[0x865]or j:Ba(j.q"sr~",j.q"mj",0x865)o,C=t[0b1001][0b10][t[0b1001][1]],o..p D,f,F=C,t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]end else A=d<i and 0x299-A or(j.Aa[0x4a48]or j:Fa(0x224,0x749b,0x4a48))end elseif A<0x27e then if A>=0x26d then if A<=0x273 then if A>=0x270 then if A>=0x272 then if A<=0x272 then A=K~=K and 0x4f7-A or(j.Aa[0x4337]or j:Ea(0x290,0x1e42e88e,0x6018c172,0x4337))else A=K~=K and 0x19deb/A or 0x6e370/A end else A=i>0 and(j.Aa[0x137c]or j:Fa(0x80,0x7724,0x137c))or 0x3c060/A end elseif A<=0x26d then A,a,t[0b110][0b10][t[0b110][1]]=0x601f2/A,y,z else A=K<=0 and 0x7a654/A or(j.Aa[-0x5586]or j:Ca(3987352570,0x244d6d0,-0x5586))end elseif A<0x276 then if A<=0x274 then K=K(G,J,p)J,G=1,p G=G+J A,t[0b110][0b10][t[0b110][1]]=j.Aa[0x70cd]or j:Ea(0x11,2276859522,0x500900d6,0x70cd),G else A=K>0 and 0x1b55a/A or(j.Aa[0x1ce9]or j:Ea(0x380,0x49951c4,3506589576,0x1ce9))end elseif A>0x276 then A,q[0b1001]=0x10431a/A,a z,y,K,G="b",t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]]else A=y<z and 0x40236/A or(j.Aa[0x52a1]or j:Ca(0x8cd03cf,0x721017e8,0x52a1))end elseif A>0x267 then if A>0x269 then q[0b10000]=a A=H>h and(j.Aa[-0x36b3]or j:Ca(0x70df95fc,2283817705,-0x36b3))or 0x585-A elseif A<=0x268 then A,a=A+-0x46,y else A,q[0b1010]=A+0x408,a K,G,y,z=t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]],"B"end elseif A<0x265 then if A<=0x262 then z,y,G,H,A,K,k="B",t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]],0b10000001,0x91802/A,t[0b11][0b10][t[0b11][1]],0b1010011 else y=y(z,K,G)K,z=1,G z=z+K A=k<K and A+-0x239 or 0x5cc94/A end elseif A<=0x266 then if A>0x265 then A=K<=0 and(j.Aa[0x7d06]or j:Fa(0b1010110,0x744c,0x7d06))or A+0x162 else a(y,z)a=0x80 A=v>=a and A+0b1011011 or 0x66377/A end else A,a=0x54a-A,a(y,j.i(z))z,K,d,y=q,0x80,a,t[1][0b10][t[1][1]]end elseif A>0x28d then if A<=0x298 then if A<0x294 then if A>0x28e then A,J=0x16be0/A,1/0 else A=L<d and(j.Aa[-0x5fc]or j:Da(0x53215d9c,0x25698757,0x72afaf1,-0x5fc))or(j.Aa[0x2d7]or j:Ca(0x1f243eb3,3771859157,0x2d7))end elseif A<0x295 then A,z=j.Aa[0x499a]or j:Fa(0x373,0x761f,0x499a),j.h(z(K,G))elseif A<=0x295 then A,p=j.Aa[-0x4790]or j:Da(4281875198,0x61b116,0x225700,-0x4790),t[0b10][0b10][t[0b10][1]]else p=p(C,o)C=0b111 A,C=A+0b11011,q*C end elseif A>0x29e then a=a(y,z,K)z,y=1,K y=y+z A,t[0b110][0b10][t[0b110][1]]=0x11e20/A,y elseif A<=0x29b then A=F~=F and A+0x2cf or(j.Aa[0x390c]or j:Ca(0x11f9cf3f,3255188431,0x390c))else A,F=0x31e-A,j.h(F(M,c))end elseif A<=0x285 then if A<=0x282 then if A>0x280 then p=G[0b11100]A,J=0x4e5e8/A,a[p]elseif A<=0x27f then if A<=0x27e then A=J~=J and A+-0b100001110 or(j.Aa[-0x3d44]or j:Ca(0x475654ff,2426407372,-0x3d44))else A=y~=y and(j.Aa[-0x3db4]or j:Ea(0x280,0x6679493b,0x11844448,-0x3db4))or(j.Aa[0x2771]or j:Da(0x1d8c7ef3,0x24d82,0x200334c,0x2771))end else K,A,G,k,z,y,h=t[0b11][0b10][t[0b11][1]],j.Aa[0x4e0f]or j:Ca(0x372ae1df,2281966972,0x4e0f),t[0b110][0b10][t[0b110][1]],0x96,"B",t[0b1001][0b10][t[0b1001][1]],0b10000100 end elseif A<=0x284 then A,y=A+0x135,y(z,K,G)K,z=0b11,G z=z+K else A=y<z and(j.Aa[0x3043]or j:Fa(0b1000,0x7424,0x3043))or A+0x174 end elseif A<0x28b then if A>0x288 then a=0b101011 A=v>a and(j.Aa[0x2b9c]or j:Fa(0x41,0x7564,0x2b9c))or A+-0b110001000 else A,o=j.Aa[-0x3c8d]or j:Fa(0b10001010,0x74bc,-0x3c8d),D end elseif A<=0x28b then A=J~=J and 0x213f51/A or 0x76b-A else A=J>p and A+-0xaf or(j.Aa[0x34ab]or j:Ca(3647902266,0x2680027b,0x34ab))end elseif A>=0x2e2 then if A>0x30a then if A>=0x31d then if A<0x326 then if A>=0x320 then if A>0x320 then K=K(G,J)A,G=j.Aa[-0x656d]or j:Ea(0,0x5366019b,0x28110cb1,-0x656d),0b111 G=i*G else A=v>0 and 0x3bb-A or(j.Aa[0x39e6]or j:Ca(0x516923fd,0x416c387,0x39e6))end elseif A>0x31d then a=0b10101100 A=v<=a and 0x6e68a/A or(j.Aa[0x1ea1]or j:Da(0x2e2397ff,0x484cc,0x7b852f,0x1ea1))else A,C=A+-0x223,o end elseif A<0x32a then if A>0x326 then A,a,t[0b110][0b10][t[0b110][1]]=0x4c6fb/A,y,z else A=y<z and(j.Aa[0x5342]or j:Fa(0xa9,0x76ec,0x5342))or 0x8dae0/A end elseif A<0x32b then A=q>a and(j.Aa[0x76fb]or j:Da(0x1c523fe7,0x608c7625,0x211d4d52,0x76fb))or(j.Aa[-0x25e1]or j:Fa(0x15,0x7407,-0x25e1))elseif A<=0x32b then F,D,A,f,M=t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]],0x669-A,"B",t[0b110][0b10][t[0b110][1]]else p=0b110 A=G==p and 0x87c3c/A or(j.Aa[-0x3cb9]or j:Da(2482155517,0x60551851,0xbb33ba4,-0x3cb9))end elseif A<0x312 then if A>0x30f then z=z(K,G)K=0b111 A,K=A+-0x291,d*K elseif A<0x30d then q[0b10],k,A,H=a,0xab,0x493-A,0xf4 K,z,G,y=t[0b11][0b10][t[0b11][1]],"B",t[0b110][0b10][t[0b110][1]],t[0b1001][0b10][t[0b1001][1]]elseif A<=0x30d then A=y>0 and 0x9a722/A or(j.Aa[-0x25e1]or j:Ea(0x40,0x4324dc9a,0x2c58c27f,-0x25e1))else A=v<=0 and 0x454-A or 0x542-A end elseif A<0x317 then if A>0x312 then A,v=j.Aa[0x77d8]or j:Ea(0b10010,3257269707,0x29c8f025,0x77d8),0x1a else t[0b110][0b10][t[0b110][1]],A,a=z,0x4ea-A,y end elseif A>0x317 then L=L+i A=i>0 and(j.Aa[-0x6ff]or j:Ea(0x4c5,3971153282,0x11402eed,-0x6ff))or(j.Aa[-0x1686]or j:Fa(0b101000,0x7f64,-0x1686))else A,a=j.Aa[0x6811]or j:Ca(0x651c49f7,0xa42a7f8,0x6811),j.h(a(y,z))end elseif A>=0x2f3 then if A>=0x2fe then if A<0x301 then if A>0x2fe then A=v<=0 and 0x642e9/A or(j.Aa[-0x36d7]or j:Da(0x5ee247f3,0xfe3b4be,2417875849,-0x36d7))else y=y(z,K,G)z,K=G,1 z=z+K t[0b110][0b10][t[0b110][1]]=z A=k>=K and(j.Aa[0x6b03]or j:Da(0x704221f7,0x32f768e,0x75d0b40,0x6b03))or 0x5ec-A end elseif A<0x305 then A=i<_ and(j.Aa[0xc40]or j:Fa(0b100,0x7608,0xc40))or(j.Aa[-0x6437]or j:Fa(0x18,0x7652,-0x6437))elseif A>0x305 then x=x(L)L,d=1,n i=L A=d~=d and(j.Aa[0x3990]or j:Ca(4009442525,0x4c05d,0x3990))or 0x57a-A else A,p=A+-0b10110100,G[0x1e]J=a[p]end elseif A<0x2f8 then if A>0x2f3 then A=_~=_ and 0xc0b7/A or 0x3a6-A else A=y>z and A+-0x24a or(j.Aa[-0x576b]or j:Ea(0x114,3932810139,0x2813d,-0x576b))end elseif A<=0x2f8 then a=0x81 A=v<a and(j.Aa[0x4a3c]or j:Ea(0b10,0x30d3ec7a,0xf00a2e8,0x4a3c))or(j.Aa[-0x6e49]or j:Ea(0x335,2841586641,0x52002114,-0x6e49))else A=J<p and 0x590aa/A or(j.Aa[0x11df]or j:Ca(2747965755,0x4c2419a3,0x11df))end elseif A>0x2ea then if A>=0x2f0 then if A<=0x2f0 then A,C=j.Aa[-0x1f3d]or j:Ca(2727580671,0x546441d3,-0x1f3d),j.h(C(o,D))else A=K<=0 and 0x76bba/A or(j.Aa[0x5069]or j:Ea(0x221,4196923324,0x4d8a9fb,0x5069))end elseif A<=0x2ed then A=y~=y and 0x308-A or 0x37a-A else A,a,t[0b110][0b10][t[0b110][1]]=j.Aa[0x15e0]or j:Fa(0,0x742d,0x15e0),y,z end elseif A<0x2e7 then if A>0x2e2 then y=y(z,K)a=not y A=a and A+-0x2d8 or 0x151bf/A else A=_<=0 and 0x53a-A or(j.Aa[0x4a48]or j:Da(3492429823,0x20e6d1dc,0x619f11b,0x4a48))end elseif A<=0x2e8 then if A<=0x2e7 then A=L>d and 0x2ef-A or(j.Aa[-0x22fc]or j:Da(3724180431,0x6787bc5,0x1b88893a,-0x22fc))else A=J>p and(j.Aa[0x27a3]or j:Fa(0x1dc,0x767a,0x27a3))or 0x7d268/A end else t[0b110][0b10][t[0b110][1]],a=z,y A=g<E and 0x4e7f6/A or(j.Aa[0x7b6]or j:Fa(0b100000,0x7654,0x7b6))end elseif A<0x2c2 then if A<0x2b1 then if A<=0x2a8 then if A<0x2a4 then if A<=0x2a1 then q[0b11100]=a A=h<w and(j.Aa[0x50a9]or j:Fa(0x210,0x7775,0x50a9))or A+-0b110101010 else y=y(z,K,G)z,A,K=G,0x56f-A,1 z=z+K end elseif A>=0x2a6 then if A<=0x2a6 then A=K>0 and(j.Aa[0x78c9]or j:Ca(2580320245,0x61361fb,0x78c9))or(j.Aa[-0x2ea3]or j:Fa(0b1110000,0x745e,-0x2ea3))else q=q(a,j.i(y))z,A,y,a,L=0x80,j.Aa[-0x16b]or j:Ea(0x200,4016368954,0x2e3c2,-0b101101011),v,t[1][0b10][t[1][1]],q end else A,K=A+-0x253,K(G,J)G=0b111 G=i*G end elseif A>=0x2ac then if A>0x2ac then A,y=j.Aa[-0x2bf2]or j:Fa(0x2ca,0x76e7,-0x2bf2),y(z,K,G)K,z=1,G z=z+K else o,p=0,t[0b1000][0b10][t[0b1000][1]]f,F,D=0b100,1,o A=f~=f and A+0x71 or 0x643-A end else h,a,w=0b101100,0b11010,0xe2 A=v<a and 0x5d9-A or(j.Aa[-0x55d4]or j:Ca(0x4a5cc2a9,0x35a20bd9,-0x55d4))end elseif A>0x2b8 then if A>=0x2bf then if A<=0x2bf then A,z=A+-0x58,j.h(z(K,G))else k,a=0b10000,0xac A=v>=a and(j.Aa[0x2f77]or j:Ca(2693050319,0x4c6041f9,0x2f77))or(j.Aa[-0x45cf]or j:Ca(0xda0cbff,3254784760,-0x45cf))end elseif A<=0x2b9 then A,t[0b110][0b10][t[0b110][1]],a=j.Aa[-0x66c3]or j:Da(0x536b9e7c,0x4770c12,0x191787,-0x66c3),z,y else A,G[0b11110]=0xa3290/A,J end elseif A<=0x2b3 then if A>0x2b2 then A=j.Aa[0x600e]or j:Fa(0x12c,0x76e0,0x600e)elseif A>0x2b1 then A,q[0b1010]=0x5cb-A,a else A=C<=0 and(j.Aa[-0x5162]or j:Ea(0b11001011,0x5e06c89c,0xf9c3f3,-0x5162))or A+-0b110001110 end elseif A>0x2b5 then A=i~=i and 0x2c0-A or 0x349-A else G[0b1101]=J K=G return K end elseif A>=0x2d2 then if A<=0x2da then if A<0x2d6 then if A>0x2d2 then A,y=j.Aa[0x3192]or j:Ca(0x5d0c47ba,2153822956,0x3192),j.h(y(z,K))else A,y=A+0b100100010,y(z,K,G)z,K=G,1 z=z+K end elseif A<0x2d7 then J,A,t[0b110][0b10][t[0b110][1]]=o,A+-0x248,D elseif A>0x2d7 then f,M,A,e,c,F,D=G,t[0b1100][0b10][t[0b1100][1]],0x65e-A,0b1111111,o,t[0b1011][0b10][t[0b1011][1]],t[0b111][0b10][t[0b111][1]]else o,f,A,D,C="B",t[0b110][0b10][t[0b110][1]],0x674ca/A,t[0b11][0b10][t[0b11][1]],t[0b1001][0b10][t[0b1001][1]]end elseif A>=0x2e0 then if A<=0x2e0 then A,z=0xa6920/A,""else A=_>0 and(j.Aa[0x332e]or j:Da(3356286941,0x24f2fd8f,0x300264e,0x332e))or 0x513-A end elseif A>0x2dd then y=y(z,K,G)z,K=G,1 z=z+K t[0b110][0b10][t[0b110][1]]=z A=k<=K and 0x4f6-A or(j.Aa[-0x72fa]or j:Da(0x2d52aaff,0x19fbb5,0x125754,-0x72fa))else C,o,f,A,D=t[0b1001][0b10][t[0b1001][1]],"B",t[0b110][0b10][t[0b110][1]],0xce280/A,t[0b11][0b10][t[0b11][1]]end elseif A>0x2cc then if A>0x2d0 then v=v(q)q,a=1,_ y=q A=a~=a and 0x638-A or A+0b111100 elseif A>0x2cf then A,p,J,o,C=j.Aa[-0x5a68]or j:Ca(2437158836,0x6889abde,-0x5a68),"B",t[0b1001][0b10][t[0b1001][1]],t[0b110][0b10][t[0b110][1]],t[0b11][0b10][t[0b11][1]]else y=y(z,K,G)z,K=G,1 z=z+K A=k>=K and 0x650-A or(j.Aa[-0x44f7]or j:Ca(0x5077e5cf,2835874279,-0x44f7))end elseif A<0x2ca then if A>0x2c2 then A=q<a and(j.Aa[0x76fb]or j:Da(2746704743,0x15d7236f,0x2e28ec78,0x76fb))or(j.Aa[-0x7688]or j:Ca(0x54c7d5db,0x2820091f,-0x7688))else a,A,t[0b110][0b10][t[0b110][1]]=y,0x574-A,z end elseif A<=0x2cb then if A>0x2ca then A,a,t[0b110][0b10][t[0b110][1]]=j.Aa[-0x701c]or j:Da(0x3a0fffa3,0x2370850d,0x20af7de4,-0x701c),y,z else a,A,t[0b110][0b10][t[0b110][1]]=y,A+-0xac,z end else t[0b110][0b10][t[0b110][1]],A,a=z,0x65b-A,y end end end end,i=(function()local function m(i,j,k)if j>k then return end return i[j],m(i,j+1,k)end return function(o)return m(o[1],1,o[0b10])end end)(),function(j)return function(m,n,r,s,d,i,_)local q,c,k,a,g,e,f,p,l,h l=j.Aa[-0x1c47]or j:Ca(4294231275,0xb328a,-0x1c47)while true do if l>=0b10001010 then a,q=0b110,_[0b1001]c,f,a=0b100100,q-a,_[0b1010]q,a=a-c,_[0b11100]k,l,c=1,j.Aa[0x2ada]or j:Ca(2470425278,0x64800d6e,0x2ada),r[q]else e=f+k r[e]=c e=c[a]r[f]=e k,g,p,h,e=nil,nil,i,nil,n return e,k,h,g,p end end end end,function(j)local e,d,f,l,i,c,_,h,b l=0b1011110 while true do if l<=0x5e then if l>0b1001000 then l,f=0xd8,string f,h,c,e=bit32,f.byte,f.unpack,f.sub d,f,b=f.band,table,f.rshift else i={[1]=0b11,[0b11]=i}i[0b10]=i _={[1]=0b11,[0b11]=_}_[0b10]=_ f=j:u{i,b,h,_,c,d,e}return f end else f,i={},f.concat _=f c={[1]=0b11,[0b11]=c}c[0b10]=c l,e=0x3cc0/l,{[1]=0b11,[0b11]=e}e[0b10]=e h={[1]=0b11,[0b11]=h}h[0b10]=h b={[1]=0b11,[0b11]=b}b[0b10]=b d={[1]=0b11,[0b11]=d}d[0b10]=d end end end,function(j)return function(m,n,r,s,d,i,_)local l,f,h,c,b,k,q,e,a,g l=j.Aa[0x1200]or j:Da(0x57f299fb,0x545681ea,0x2bb6e314,0x1200)repeat if l>=0b11010001 then if l<=0xd1 then g=0x27 k=h-g e=r[k]a=c..e r[q]=a a,q,e,c=nil,n,nil,nil l=b>g and(j.Aa[-0xfc5]or j:Ca(2342397231,0x506188ef,-0xfc5))or(j.Aa[0x1200]or j:Ca(0x6f490bfb,0x26e4fe,0x1200))else e,b,q,c=0x11,0xfe,s[0x19],_[0b1010]l,a=j.Aa[0x448c]or j:Fa(0x40,0x76ec,0x448c),c-e c,a,f=0x37,_[0b1001],q[a]c,q=f[0b10],a-c end elseif l<=0b101111 then k=i return q,a,c,e,k else e=f[1]a=c[e]r[q]=a k,q,h=_[0b10],_[0b10001],0b1010 e=k-h l,h,c=j.Aa[-0x7cef]or j:Da(2633566167,0x257e97d5,0x1d819904,-0x7cef),_[0x12],r[e]end until false end end,function(j)return function(m,n,p,b,d,i,_)local q,l,c,e,f,h,a l=j.Aa[-0x3914]or j:Fa(0,0x7672,-0x3914)while true do if l>0x1e then e,c=i,nil return f,q,a,c,e elseif l<=0b1111 then a=0x32 c,a,f=0b11100,_[1],q-a q=a-c p[f]=q f,q,a=n,nil,nil l=h>c and(j.Aa[-0x2d43]or j:Da(0x4f6480fd,0x7c855346,0x3fcff9d,-0x2d43))or l+0b1111 else h,q,a=0xf3,_[0b1001],0b1011 c,f,e=_[0b1010],q-a,0x12 a=c-e l,q=j.Aa[-0x687d]or j:Fa(0b10,0x7663,-0x687d),p[a]p[f]=q q=_[0b10001]end end end end,function(a,...)a.v,a.q,a.t,a.y,a.m=a:v(),a:q(),a:t(),a:y(),a:m()a.F=a:F()return a:k()(...)end,function(a,b,c,d)a.Aa[d]=-b+(a.b(a.a(a.c(c,0x766c),a.c(c,0x766c)),a.c(b,b))+(a.b(b,a.c(4294967295,4294967295))+(a.b(a.a(a.c(c,0x766c),0xffff),a.a(b,0xffff))*a.a(a.a(b,0xffff),a.a(a.c(c,0x766c),0xffff))+a.a(a.d(a.a(b,0xffff)),a.a(a.c(c,0x766c),0xffff))*a.a(a.a(b,0xffff),a.d(a.a(a.c(c,0x766c),0xffff)))-a.a(0xffff,b)*a.a(0xffff,a.c(c,0x766c))+(-a.c(c,0x766c)+a.b(a.c(a.c(c,0x766c),b),b)))))return a.Aa[d]end,{},function(j,t)return function(m)local z,s,D,h,q,v,e,x,k,n,a,b,g,w,o,i,F,E,B,p,A,C,_,y,c,r,l,d,f A=j.Aa[-0x2682]or j:Ea(0x64,0xf249914,2160297146,-0x2682)repeat if A<0b10001010 then if A>0x4d then if A<=0b1110100 then if A<0x62 then if A>0x5d then A=g>0 and(j.Aa[-0x4a2f]or j:Fa(0b110000,0x76c8,-0x4a2f))or(j.Aa[-0x1c47]or j:Fa(0x80,0x76e6,-0x1c47))elseif A<0x5c then A=q<=0 and(j.Aa[0x3ba3]or j:Ca(0x1255aaff,0x20a854de,0x3ba3))or(j.Aa[0b100101110]or j:Fa(0,0x767e,0b100101110))elseif A<=0b1011100 then f=f(F,B)F=0b111 F=E*F A=l<B and A+0x9e or(j.Aa[-0x635c]or j:Fa(0b11001,0x76f4,-0x635c))else z=z(E,h)y=not z A=y and 0x62-A or(j.Aa[-0x635c]or j:Fa(0b10000000,0x76f5,-0x635c))end elseif A<=0x70 then if A<0x64 then A=E>h and 0x3fee/A or(j.Aa[0x6800]or j:Ea(0,0x461e2db8,2684428523,0x6800))elseif A>0x64 then A=q~=q and 0b101001110-A or A+-0b11011 else A,i[_]=j.Aa[-0x7b84]or j:Da(0x75e88ddd,0x5a3fc658,0x27d43a47,-0x7b84),a end else e,c,n=0b10000,0x20,m n={[1]=0b11,[0b11]=n}n[0b10]=n x=1 x={[1]=0b11,[0b11]=x}x[0b10]=x i=0 _,q,v=i,1,0b100 A=v~=v and(j.Aa[0x449d]or j:Ca(3292102279,0x1a440155,0x449d))or(j.Aa[0x6cf9]or j:Da(3048631279,0x6470b6e,0x1ba08ab,0x6cf9))end elseif A>=0x83 then if A>0x87 then i=i()return i elseif A<=0x83 then A,C=j.Aa[-0x23ec]or j:Ca(0x5c96aff7,0x2161404a,-0x23ec),C(o,D,f)o=1 x[0b10][x[1]],p=x[0b10][x[1]]+o,C else E=E+g A=g>0 and(j.Aa[0x7ee]or j:Ca(0x109fc567,0x436028fa,0x7ee))or A+0b1000010 end elseif A<=0b10000000 then if A>0x75 then A,D=0x128-A,j.h(D(f,F))else A=q~=q and 0x13b-A or(j.Aa[0x5fe3]or j:Ea(0x8a,2404497821,0x6000841a,0x5fe3))end else A=E<h and(j.Aa[-0x2f2d]or j:Fa(0x24,0x76eb,-0x2f2d))or 0x4b96/A end elseif A>=0b110000 then if A>0x35 then if A>=0b1000010 then if A>0x42 then A=q<=0 and(j.Aa[0x18f0]or j:Da(4016607933,0x9ba4237,0x64b23c2,0x18f0))or(j.Aa[0x153e]or j:Fa(0b1100100,0x761d,0x153e))else f,A,B,F,C,D,o=t[0b111][0b10][t[0b111][1]],j.Aa[0x5535]or j:Ea(0b11000,0x5c658e90,0x230a025c,0x5535),0x7f,p,t[0b11][0b10][t[0b11][1]],t[0b110][0b10][t[0b110][1]],z end else A=_>v and(j.Aa[0x449d]or j:Ca(3386200253,0x2082645,0x449d))or(j.Aa[0x78ca]or j:Ea(0b110000,0x4457cb1c,0x9a882f0,0x78ca))end elseif A>=0b110011 then if A<0b110100 then E=E(h,g,p)x[0b10][x[1]],a=x[0b10][x[1]]+y,E A=s<=k and 0x97-A or(j.Aa[-0x635c]or j:Da(2873546425,0x24a71dae,0x2c01042d,-0x635c))elseif A<=0x34 then o=o(D,f)C=not o A=C and 0x21ec/A or(j.Aa[0x2833]or j:Ea(0b10000100,0x7c96deb6,0x49500f,0x2833))else A=q~=q and(j.Aa[0x449d]or j:Ca(3126742149,0x400916f,0x449d))or 0x47-A end elseif A<=0x30 then h=h(g,p)A,g=0xd4-A,0b111 g=_*g else y=y(z,E,h)A,z=0x25b5/A,1 a,x[0b10][x[1]]=y,x[0b10][x[1]]+z end elseif A>=0b100001 then if A<=0b101001 then if A>0b101000 then A=q<=0 and(j.Aa[-0x59b]or j:Ea(0x13,0x2d1d53f2,3223324410,-0x59b))or 0x5e-A elseif A<=0x21 then A=E<h and(j.Aa[-0x2f2d]or j:Fa(0x26,0x76cb,-0x2f2d))or A+0xb8 else A=q~=q and 0x17c0/A or(j.Aa[-0x656d]or j:Ca(3755397560,0x200126f3,-0x656d))end else A=g<=0 and A+-0b1001 or(j.Aa[-0x1ba7]or j:Fa(0,0x76b5,-0x1ba7))end elseif A<0b1001 then if A<=0 then A=q>0 and(j.Aa[-0x36b3]or j:Da(3479666941,0x55fa89,0x3a4b61,-0x36b3))or A+0x28 else d=i A=c>e and 0x9c-A or 0b100000010-A end elseif A<=0b1001 then A=q>0 and 0b1000000-A or(j.Aa[0x78ca]or j:Fa(0x10,0x761c,0x78ca))else h,A,y,E,z=x[0b10][x[1]],0x43-A,t[0b100][0b10][t[0b100][1]],n[0b10][n[1]],"B"end elseif A<0xc6 then if A<=0x9d then if A>0x98 then if A>=0x9a then if A<=0x9a then k,s,z,l=0b10001110,0b110,0,0b101001 E,g,h=z,1,0b100 A=h~=h and(j.Aa[-0x2f2d]or j:Ca(0x793024ef,2223133607,-0x2f2d))or 0b11111011-A else _=_+q A=q>0 and A+0x5b or(j.Aa[-0xbb0]or j:Fa(0,0x7621,-0xbb0))end else _=_+q A=q>0 and(j.Aa[0x3c42]or j:Ca(0x494004ef,0x300bebf3,0x3c42))or 0x1881/A end elseif A<=0b10010110 then if A<=0x93 then if A>0b10001010 then A=_<v and(j.Aa[0x449d]or j:Fa(0b101,0x766c,0x449d))or 0x1e6f/A else A=g~=g and(j.Aa[0x2f82]or j:Da(0x276c4935,0x4ba3c555,0x3c6d4f94,0x2f82))or 0b10110100-A end else A=g~=g and(j.Aa[-0x2f2d]or j:Ca(0x2a4433b7,0x1590cce7,-0x2f2d))or(j.Aa[-0x1ba7]or j:Ca(0x4fd745d9,0x1000a2ff,-0x1ba7))end elseif A<=0x97 then r,c,e,_,A,i,b=0b100,0x42,0b10011111,d,j.Aa[-0x1369]or j:Ca(3429402334,0x28461d8,-0x1369),t[0b10][0b10][t[0b10][1]],0b10010000 else A=_<v and A+0b101110 or A+0b10 end elseif A<=0b10110000 then if A>=0xa8 then if A>0b10101000 then A=q<=0 and 0b101001000-A or A+-0x16 else A,C=0xdc-A,C(o,j.i(D))D,o,f,z=p,t[0b1000][0b10][t[0b1000][1]],0b10000000,C end elseif A>0xa4 then A,y=0x1a4-A,z else A=0x16b-A end elseif A>=0b10111001 then if A<=0b10111001 then A=_<v and(j.Aa[-0x43d0]or j:Da(2686526423,0x62fe20,0x29d2c6,-0x43d0))or(j.Aa[0x153e]or j:Ea(0x60,3711231802,0x20092035,0x153e))else z,A,E,h,y,p,g=i,j.Aa[-0x3e66]or j:Ca(0x7ddf77b7,2183135288,-0x3e66),t[0b110][0b10][t[0b110][1]],t[0b111][0b10][t[0b111][1]],t[0b11][0b10][t[0b11][1]],0b1111111,a end else A=E>h and(j.Aa[-0x2f2d]or j:Fa(0b10,0x76c9,-0x2f2d))or A+-0x2a end elseif A>=0xe3 then if A>0b11110010 then if A>=0b11111010 then if A<=0b11111010 then A=j.Aa[0x4bbb]or j:Ca(2367446987,0x2a0a094,0x4bbb)else z=0 A=y==z and(j.Aa[-0x5a7e]or j:Fa(0b10000001,0x7685,-0x5a7e))or(j.Aa[-0x6d78]or j:Ca(0x2c7e9afb,2189508850,-0x6d78))end else A=_>v and 0xbfd0/A or(j.Aa[-0xbb0]or j:Fa(0b1000001,0x7620,-0xbb0))end elseif A>=0b11101000 then if A<0xe9 then A=_>v and(j.Aa[-0x43d0]or j:Ea(0x84,2161898546,0x1020784a,-0x43d0))or(j.Aa[0x5b0f]or j:Fa(0b1000,0x764c,0x5b0f))elseif A<=0b11101001 then a=""A=r>=b and A+0b1001 or(j.Aa[0xc40]or j:Ea(0,0x6077cb88,0x14008266,0xc40))else E="c"z,E=E..y,t[0b100][0b10][t[0b100][1]]A,g,h,p=j.Aa[0x464d]or j:Ea(0x31,3483041082,0x20204082,0x464d),n[0b10][n[1]],z,x[0b10][x[1]]end elseif A>0b11100011 then w={[1]=0b11,[0b11]=w}w[0b10]=w d=nil d={[1]=0b11,[0b11]=d}d[0b10]=d d[0b10][d[1]]=j:za{t[0b1000],d,n,t[1],t[0b10],x,t[0b11],w,t[0b100],t[0b101],t[0b110],t[0b111]}A,i=j.Aa[0x6832]or j:Fa(0b10000000,0x7664,0x6832),d[0b10][d[1]]else A=_>v and(j.Aa[0x449d]or j:Ca(3690581293,0x240030d7,0x449d))or 0x245b/A end elseif A<0b11011000 then if A<=0xc7 then if A<=0xc6 then w=i A=c>=e and(j.Aa[0x12e]or j:Ea(0b10,0x6290a7f6,2218950710,0x12e))or(j.Aa[-0x15c8]or j:Da(0x58f0ecef,0x4e4f37dc,0x37b7cb19,-0x15c8))else A,E=j.Aa[-0x7d76]or j:Fa(0x52,0x76a6,-0x7d76),j.h(E(h,g))end else A=g<=0 and 0x6549/A or(j.Aa[-0x191d]or j:Fa(0x10,0x76ea,-0x191d))end elseif A<0xda then if A>0xd8 then A,o,D,f,C=A+-0b1010110,"B",n[0b10][n[1]],x[0b10][x[1]],t[0b100][0b10][t[0b100][1]]else i=i(_)v,_=d,1 q=_ A=v~=v and 0xa710/A or 0b11011000-A end elseif A<=0b11011010 then y=y(z,j.i(E))A,z,E,i,h=0x4f32/A,t[0b1000][0b10][t[0b1000][1]],a,y,0x80 else A=_<v and A+-0b11011001 or 0b11110000-A end until false end end,function(j)return function(m,n,p,b,d,i,_)local g,f,a,e,c,l l=j.Aa[-0x3e66]or j:Fa(0,0x765c,-0x3e66)while true do if l<=0x64 then if l<=0x30 then a,g=0b111001,_[0b1001]a,l,f,c=_[1],j.Aa[0x2eb9]or j:Ca(0x4dbdd1de,0x30002cbf,0x2eb9),g-a,0b11 g=a-c p[f]=g a,g=0b100110,_[0b1010]else c,e=nil,i return f,g,a,c,e end else f,e,c=g-a,0b1010,_[0x11]a=c-e l,g=j.Aa[0xc40]or j:Da(0x27320b7e,0x338198ab,0x253ec839,0xc40),p[a]p[f]=g f,g,a=n,nil,nil end end end end,function(j,t)return function(m)local a,q,n,i,b,d,k,p,r,g,u,e,c,l,o,v,_,h l=0b1111011 repeat if l<0x89 then if l>=0x2d then if l>0x7a then r=t[0b100][0b10][t[0b100][1]]n=r[m]l=n and 0xcd or 0b11 elseif l<=0b1000110 then if l<=0x2d then _,v,i=m,r,t[0b11][0b10][t[0b11][1]]i=i(_,v)_=1 r,q,v=r+_,_,0b1000 l=(v~=v or(q>0 and _>v or(q<=0 or q~=q)and _<v))and 0x18 or 0b11010001 else c=#m l=r<=c and 0x71-l or 0b11010010 end else _=_+q l=(q>0 and _>v or q<=0 and _<v or q~=q)and 0xb70/l or 0x639a/l end elseif l>0x18 then e,l,h,c,k=m,0b11010010,r,t[0b111][0b10][t[0b111][1]],r c=c(e,k,h)a,c=c,1 r=r+c elseif l<=0b11 then l,d,r=0b11000,{},1 d,u="",d else i=#m l=r<=i and 0b101101 or 0b10101110-l end elseif l<0xcd then if l>0b10001111 then _,i=u,t[1][0b10][t[1][1]]i=i(_)_=t[0b100][0b10][t[0b100][1]]_[m]=i return i elseif l>0b10001001 then e=1 c,e=r+e,#m l=c<=e and 0x4c87/l or 0xd2 else h,e,c,k=r,">I2",t[0b101][0b10][t[0b101][1]],m c=c(e,k,h)e=0b10 g,h,r,p,k=c,t[0b10][0b10][t[0b10][1]],r+e,0b101,#d h=h(g,p)h,e,p,g=t[0b110][0b10][t[0b110][1]],k-h,0x1f,c h=h(g,p)g=0b11 k,p,g,h=h+g,e,d,t[0b111][0b10][t[0b111][1]]o,b=1,e+k b=b-o h=h(g,p,b)l,a=0b11010010,h end elseif l<=0xd2 then if l<0b11010001 then return n elseif l<=0xd1 then k,e,c,a=1,i,t[0b110][0b10][t[0b110][1]],nil c=c(e,k)e=0 l=c~=e and 0b1000110 or l+-0x42 else c,k,e=t[0b10][0b10][t[0b10][1]],1,i c=c(e,k)i=c l=a and 0b11110011 or 0x7a end else l,k,e=0x7a,1,#u c=e+k u[c]=a e,k,c=d..a,-0x800,t[0b111][0b10][t[0b111][1]]c=c(e,k)d=c end until false end end,function(j)return function(m,n,x,w,d,i,_)local y,p,b,f,k,r,l,g,e,h,a,o,s,v,q l=j.Aa[-0x768a]or j:Da(0x4a31a47f,0x97158e0,0x1b56b96f,-0x768a)repeat if l<=0b10000000 then if l<0b1001111 then if l<0x2b then if l<=0b10 then g=1 h=a-g l=r>=g and(j.Aa[-0x2d43]or j:Fa(0x20,0x768d,-0x2d43))or 0b10001101-l else l,g=0x800/l,j.h(g(p,b,o))end elseif l<=0b101011 then g(p,b,o,s,f)l,o,p=j.Aa[0x237f]or j:Ea(0b101,0x4057d01a,0x1b0809de,0x237f),_[0b10010],w[0x19]else k=k(j.i(h))h,g=k.n,0 l=a==g and 0x2e95/l or l+-0x49 end elseif l<=0b1100111 then if l>0x5f then l,h=j.Aa[-0x43b4]or j:Ca(2907173323,0x218005b,-0x43b4),j.h(h(j.i(g)))elseif l>0b1001111 then s=0b111010 b=o-s b,l,g,o=_[0b10],0xea-l,p[b],0x27 s,o,p=g[1],g[0b10],b-o b=o[s]else e,y=0x1b,_[0b1001]e,y,v=0x34,_[0b1010],y-e e,y,q=0x3e,_[0b10001],y-e l,a=j.Aa[-0x7b84]or j:Fa(0x90,0x7671,-0x7b84),y-e end elseif l<=0x76 then l,y=j.Aa[-0x71df]or j:Ca(0x32f3d59d,0xc0820ac,-0x71df),n-v else l,r=0b11100111-l,0b10011110 end elseif l<0b10011111 then if l>0x8c then e=0 y=q==e l=y and(j.Aa[-0xe69]or j:Ca(3672831351,0x20140876,-0xe69))or(j.Aa[-0x71df]or j:Fa(0b100,0x76e0,-0x71df))elseif l>0b10001011 then l=y and(j.Aa[-0x1369]or j:Fa(0x40,0x76b4,-0x1369))or 0x7f6c/l else x[p]=b b,o,s,p,f=nil,nil,nil,n,i return p,b,o,s,f end elseif l<=0xe1 then if l>0b11011000 then g,l,s,p,b,o,f=w[0b11101],0b100001100-l,v,k,1,h,x elseif l>0x9f then e,k=x[v],w[0b11]p,h,o,g=x,e,1,w[0b10101]l,b,o=j.Aa[-0xde9]or j:Ca(3418484690,0x4280014,-0xde9),v+o,v+y else g,l,p=v+h,j.Aa[-0x2d43]or j:Ea(1,2454449293,0x49420e1,-0x2d43),1 n=g-p end else l,e=0x1c1-l,1 y=q-e end until false end end,function(j)return function(m,n,r,s,d,i,_)local q,l,c,g,e,p,a,k,f,h l=j.Aa[0x144f]or j:Ea(0xc3,0x1b681e4f,0x249502db,0x144f)while true do if l<0b10000001 then if l>0x3b then e=-1 l=a==e and l+0x38 or(j.Aa[0x218c]or j:Ca(0x53184ebf,2825363835,0x218c))else l,e=0b10111100-l,1 c=q-e end elseif l>0x93 then l,a,q=j.Aa[0x4371]or j:Ea(0b10000,0x18cd2cbe,0x402216f,0x4371),0x14,_[0b1001]c,a,f=0b10001,_[0b1010],q-a q,c=a-c,1 a,c=q-c,nil elseif l<=0b10000001 then h,g,k,p,e=f,true,c,i,n return e,k,h,g,p else l,e,k=j.Aa[0x1d62]or j:Fa(0x80,0x766d,0x1d62),n-f,1 c=e+k end end end end,function(j)return function(m,n,x,w,d,i,_)local v,c,h,f,q,g,p,l,k,s,a,u,o,e l=j.Aa[-0x2682]or j:Fa(0b10100,0x760c,-0x2682)repeat if l<0x65 then if l>0x19 then p,g,h,e,k=i,nil,nil,n,nil return e,k,h,g,p else i=i+c l=f>u and(j.Aa[0x7f31]or j:Ea(0x24,0x4e8ce898,2168636775,0x7f31))or 0x8fc/l end elseif l<0x74 then i=i+a l=o<=s and 0b11000001-l or(j.Aa[-0x2682]or j:Ea(0x20,0x39278b31,0x444880ff,-0x2682))elseif l>0b1110100 then s,u,k,o,e,f=0xea,0x98,0x31,0xa9,_[0b10011],0x14 c,e,k=e-k,x[v],x[q]l=e==k and 0x3bf8/l or 0b10110001-l else q,a=_[0b1001],0b1000 a,c,v=_[0b1010],0x23,q-a e,l,c,q=0b110000,j.Aa[-0x5608]or j:Da(0x5789149d,0x408619ff,0x47e066d9,-0x5608),_[0b10000],a-c a=c-e end until false end end,function(a,b)return a.F(a.t(a.q"|Nj92T?^{q7yk(N{}v1X{Sf~MU`JYANJmQlOc1)=j+M26|4X{*Au<4ArvDE<2mdu6gGv8<eFNH}I}pJCR?V=q$av#K|JSKB;GQ)@1^=`!)hmwzJ3RjdQ$RvbPXed^o&i__!ubl_|JGfr^ukoN-v7`9Lsmpw46pw{ErUxlqf9sdh*3QZ8Hyo^|KvHH7=Yn2oBt3kb}aB9W8wdSS+SrKlsxDEXAm{|`%?k||I}=xB^r^n+5c+F0%=DC@ofL3=>t$d*AUtNji0v>C)>Bh|HfiJwIJ(k1OM4Q01$|q^Z)-`o0uH|;9>j!#&1Mi2e1v&|2i=Y3<E9|zyApQo9MsaxXS;g2iN@d`t$Ms@EDqe0Dkg7|Nf={I?5pA<^SliOYNQzT_pdEND8&Mwr`35<1_x{bOu6b|J2ymyaeg8V*m66!|Lnt2dV$=6qC$c_6*(sa3;Z9#So_G|LnDZ5}!ZQxc`@Txlu-QqeA}-WOKqJ-2uV>2k6=fu|+eu{{gT9o2CUP#Q$LUy%4hu#ex5l8_k=S0qu?dkq+3^5WzQd|B=OejWPoc2mdMzGt-0+`85B$&djp+yms*aQjmU&wyy|0{|`7YA1wqW0spK5&a4Oh$ISo2$H2)5ag1^Qgj=fdoD!}9|Mh*$i13g*|Nm^&h}D`1?|1(UhSR^uyZ)#D+@ad4*$^nz|J22VVW5~ij{ozo$RS+A1~>o6Uf1*10V5Fqx1k`R5pGmV|8ATi<^^`EKK})$g(Ha%2ZsMR*&}<2NC!0k6;f2}G~*Ci|Ko*`Au0N|kN?sN&^Et(bOHYs3=wYHmjkx{*56A=YKZ}q{}0h`;biu5!2fCKWy5LfW&i&Xy-C!8#D<0cQq`T$^|MOI|B=c9IqD86{QutD85BNT`$hk3S}aHf540iwr)>f<;RJ|||ALAG>f!SW@Bh+;dURiG@(BNw0a*~ttDfoqfFm#$$%ip*|DBC;odJaqg8w_oaTka_rj`HwJy%;{z(xfB)7MT40Z9-){~4t+H@xwK#Qy;vn6$a@?FIiz%w$1y5PZD<Mh1`Ywz&M<|5pQ-EBX8az5mYvm=J>pMjQWcZ}%)K>q)o&K*d*J2kH^U{}RX<+YqOKoc~!nJ>uD^(M$grYGxGK1;z0H;O*i8oe-Xn|MWlBP9dQfbN}7yG$lDt41fO^Y1}H;89gBXL0+;1sJWDo{{%&TZg2w%2mcWR_21SIZ>s->+8f`|TLi!VX>GikUi}dD|6R0uIzuanq5sC-1iU3rR|5Ye)(S%)r>1`Y46?LqAOm4G|M3Z*7oZ-b75}ITunf+$EhYao<vr(n?<?&83S+oZy+OWU|Gq%G5QTb!+5gDNn=VFnrsn@ZuLghtzYx#=8Ji+s3$(f;|J-KuPF|2A9se{Iw$}@>2W0=h;~nNW0X)tB!7bF{W2f;(|9hyT(Mks4aQ|bf9;pE!5V!w{#3YGx0aefcR-}5M9%!in|0WQejY5n9J^$r$2@94Q12_MgItBQ+&sBc^116q&4kcm-|283JA0;0^3I8(#V-WY_L4W^_Ntg2+cY}xju&4ux1r4Wr|JpPVx6?{|PXDHWB_&~s&`19lA5R637TPoa3k|ZLg_W6v|B|$Wf`XZt1ph^hdf*I6X<`3oW@cVteQJ3BX%IVp5r9P||NB;D>(V5INdJf)1j+g5>IeUQ6i=BqYq$mfYinU`auBN${}v(bn+FKSod4spoNxO;5ZeEQ8NZ=)&vVTGQDt%D)Hf*y|6bi~)n3DL3I93=2@ne%D;WO^2%4q2qrRj6rKAD<0sxZ%|H=k$3q%}29sdX4!s^lO%;f(8f&!_31sfs%EFw7s-S+ME{}A<)d7UEXRsa3kj+r7TGFks44z7uuinfsdjfsb$g^`1k{{>y*Q2LAx>;Kxv%jf>n*4Y2i(%R9>3?cOYZlrcR|4y-E{{;UBM|yN^cK={v4Ags6Q^Nm7i}oG_i4F|^huYh+LG%*_|D}ZI_5}aiu>XhzWOR?71p@!U9g%YZHw>5mb)~LP8PcSt|Mk4c2J~&`VE^V}1L!VW1myo-#G(vf3<od&4q%ctNT}yI{{@O@NOpYzwf_TSbY=m|44eP><Gb48xZLRftp4W#`vI#E|Ck%C?o3sh5C7!}A>+@7`bGZ+#G&$`Ch!6O?-2gIqd@io|MtQ;^&oKy5dU^k1(>O*q^kc3jF+vEx|*2(fwm2lQ+KIc|46V*ZM{-uq5lekv#z3*xw`+kq~!t#lLW^9GNii<=&Lu1|AK%wm%*znfd3GNbB17wV2A%Fk8saLhHjt#ZV8CErmK{=|G2)m4ObbeS^rM}yIOuWzEl5e5N2KFb{M$-eB`DfS-47}|Fnn<cFnIy$N!j4)~-~{>jM8~JqpX1b~5Szk8}v{m<6-q|DBjQ5UP;6hyU?=?R|<k!9V}929;g~2pBg1GiwNzow$yb|CPR*19w711OLpJh!6~qU;+ONp?$hA3a)qm<*nKY3vmfv{|8YvQ3pf=PyY;7QfUD_f5iWo_qBm00oDQk(E-p9ki;-I{|9>#g1@|z4gWycyb%n;m@oe@dFaI<MUpcATmm3$1%}W>|L9NwDGYbJ7ynRkok!TL6S@B?5UCg)ndn^qbu{cF>B)M*|0lZ!{IA}t!vDGlV|Qq3Q%3(m0tEyD%YFg>+y|%WxE`8M|M3G854QuSo&Q7(k=>tv(|7;K(&dl;9|89N2ZhYRhB7V7{{uAC6%es6Q2$Mz&7?<9Lu3D*%jt<C0T2%V&>$oc9QQ0L{}vVY3M&Z$^#9)l?ZCjo*a8285WagE%PCL)X1DCZDa($4{|4Ft7Z9nd(f_{J`(iK}n=$`MUp?n#0#SPZ5RaO|!=7L5|Gm<wPhIn?@&B~}Y7lLL8T0>^19$yyJd!~FQelQa0S^{+{}h#CryXiS8~>7BvJPuR1(*MOr2%G65G6PNQ+c$UPxgT6{}(9Y)A(}@@c;cX!Rsu*=qLZ}_C3!Ksz-SL@&p$PjY&o9|1bs_l3xNHv;PSG`g+9v1qlB#1OjW#C<*lcV|vGJeAaz;{{-U9!^#6d3I7!YVFLY(2BH75m7ku20j>uB=)}jw*_Z{^|LynT>JNMy=l?5vALBGy2-yE4T@CF7V+w2kQ36CE1f8_E|D^({(*dXksQ+=l&?{ODvZVjDqOGX0qpqO;v!x8g=6HrO{|>{F*o-gU2mb|czzOzsHv#{I0_6Y%J#Uf!M-ci8ICbG@|23f$UL)>Vw*O{0zNZ8M4g&usMgar}1SUoQ0|W>LCPM`T{|E>sLI(s03jZcR2>}iaCO`iR1PBf$Jq-l^2oNSb4+IDj|0X&S1PBx+IsX#@4i+Xi6#@Sa7$!Cs1PB`cCNvoY2plFe{~G}g9wspz1pf#iCNLiX4kG^#Ga&>BBqkmIBLNO37bPVJuP7ie0Rq7^0>CJDCLSjO!6qdL0>J+Q0S+n#B`F&J0S+t=HY*SY`xY|+BPbv)1P=cM5C$YOBnv111PCrBF)aiL|1c&rF98lRCVw|E1PC-HIt4)gHYPna1PC}L|3Ehc2s$Q1IsXI*JSIjv5Dx1hG!UUS5THILAl*F;!6+pP5TFDO|LOq_Ko2)R82=6y7ytnT00F-PC?78c4kCa;|0W?p1PDYIDEmVT6~F}n4n`*bFhv9iNG3B!{{#q1CN@a~2>(nbIZFfxPA306O#u#2CO=RA1PD?lLQw<=?^Gs5Qx`xq1PEVN7b#T?3LpjwA^%tpIadJ=AO`;{SseimTP7j@S|}hd1}s5Z|2;B8T`61y2>)LLMP4LBDLelG4q*dDU?d3t4G%(91PEgT|3zXX0S;vkJAY&Z2xkT@W-0*R4hAe}9s!^OMg3+2KtK;UKNt(278(En1{gpW;0NCU4p<L54Pq==o&?}(CL(DKU^*ad_a-814FN`8B?SKnZVx+c0S<8g1}$$NGXQA-?*Qg67%(6R1PJeP14eNJ<{$<w|5+a<BXctVEC2uhoG=*(5&-`ICMX~>2mucNbpu9pB>@h1{|`HM1PFNsE&X^1;5z^S87~<B2oV4PDkvZ^{t1A414eo!2oC=M02TobeFH}Md;wq@-~kSQ14g}m2Y`VCM1TljSo04%BVr9;EIwB{pE5v$D}p1y41k6A4?Kh>p)Oe<Gk*Xx000Uw8ARa!2?Pj-14o7?zX1+`14V!Uz*zGSJS&0(z$`mdH=i;+i7bdK;8);x`wu-6!Y_CsGXVcl001p98VD2D002f4zzSO614zG$CkPM#09W9Q#{)=<QD6!o0Kixe?L7)2FIiWBY9=NAC_xG=I8ih*I(LpOjVPf>UMMJ`{XQt5AO<j5A~XL08vp<cG8;3S04)^YG#w<MXCQL-14(fN=5PiuZ+-;eD*ylzG8<jsT?;6oNpvVEp*|GC>o9l&;LRN1G8+ib6aWDgD4+;{djn@ldMGNPD56Px0bn-|LRKiDNqz@_7D3Jcz*rAHAc7HK1PJetCMJ(QpbIQDe@-znH<B)qKLOWDUMW8TKNdnUS$!iGLo*yR06z{uYc(DgKny?uN^u0{|8NE|ZzDG}7wj8ACSWiO79mP>DgHp=7Xc2G14@(qDO15fWC0GA2LCdZBm@YU1~I*teL$82N|gwpn*SyynFI)&14`YS1mJfMKOCYlc>g0a0UiJV`ZGTq2o(SU5FDTj0PmgyN}US=BLoQVpaV*u3kISFGQFW)AfyH{qYD6{X9G&11i&B!N`3^u95!JPz*rAIK%yHUAOU$NAORKtKqe=pHUZa5UMgO}KsEw0S??q>0E#sNFd#$M001m8;4++Gas%5-aRki&#5&+K9k(+8H3h&nA3ER-&LE*nbSg<9Afii?wJIQ?K_H?tm1n@G_XaYibD)+3OO^jBEHX<jGBl~%FQ_2_OPd8icMt7AQlc_=5TLUF0RN0M9S9Zx0I@tF01IHA152F?Vy58lpaV;v3udAQGrge;V5<f)sv+Q_X9G*25I{jBOMVbQoL7MnAXpDTVZt1MEdMV^D>5;yFs!_QKnp;xCMd2~flTXOD_4O*SAsKHCB8u;H6AknK_Xx`wIEl34nZMIaRlaYmj*L$1mH_ofJGrNT@E0DOmr)NK|vX!^D}q|;3;4rH694^MgTNAzzBeQ15A3^D_MYmLri=I0A&x|LPg><l_o{uGnf8|;FbeSl`AYPe?=%VF0nAMMnQv2n+t7Y0SjVd0uTV6=L1Zg3t}ZAOrI<NLoho82(trB8L|!_WJFAU4j_7=6(HwW4?%?D9v}n=wdW=&v?8Dgz=aP&evG0tStc_8Fg&DvFx_B>15Ji3jG;SAfB?W)4?>Kh1i-%p2)8CGwklu``k*00If6BKCo=&3PM<(GAP5-%0ChuJpb(5fPKqr%fzFIVPKzxG!vMg!2LCa*Cm0VEBmn&Z>wvo#G`bcke@8|i91BHF=s^Fy1}nTO7z`NyCjbEl009yJ`vDPU00aoT7dPL!87Lnx?|{DsA11yk7!3p=1Hc4;{sbsBF*z<H2^IYkkw5^y0S0vj|MUR{R0aqJr~d&4Dh6`~3kLs829yB?Ee1RP2D||V?*RsS{|4d#2H^n)p8o*`Z3aXJ83zAs27U&324@EUAqE5n8wOwo|854z0S5d52LDC|rU3?#0S5ov0S2`J2JHd=2Ic_<1qQtV{|2-H2AKf{tp5Q9Rt6RZI0pY~2LAyD!2t&UUk20x2Gs!u|3U`e0R|cd2mc1P0R~D2CkFq30S4y*1_}oMHwH5X&H)B;{|55`20R8i2LHkV25|;&2F3pY2HgP$paBN|vH=D~23ZCP{|4Iu26P4&2LB@lhXDpD1_S>F#sLOL2B`u62G{`xB?dkQ|LXw;F9whS2LF};1`!610S5nz0R~eB*8v9qodE_h23H2!{{aT&0S3?k2LHGL1_1^R2Ce@A23!U`0zcsQ00000Kn8*V2LFWt2Jis}qXGX0$^iz;0R}7o1{DTC2800y|Ly?>q5%fU0sjUt1~LZG0S5nD27>_xc?Mno2Iv6>S_atx{|00R%mD@;2LF=*2CxAJ%>n-ga0ZwG2IB$$2Kxa9A_hwa|7HeZ2Co4I{r>?5dj?nrs{#E6G2poY1`P&}{{aSQ2K503!2baTx&a0d2Acl?215oU28sdy22KV@2Ezdc|91w`0S1x*2LHza2J!(0{sI3690v9Q1}+Bw6b3;Cr2z(2{|1Qx24V(H2LCh$QU$&Q1vURJH#Pwd0s}z%0Utjg0{{X50`?Zd0KROX0tO`k{~7@f1P?d^1pf#E1}Xs@0S^BL1}Oy_87nLQ8xRH)F%S?ec`*Ya1kVTtDF+0?{|@;R9S0Xa0sjsP1|<m@92EB%LO}sxCkYt~{UHG$3<f0&85sWy78U>j0RRBK1nZy|CJhKxU;_UR1SLHO1P1~C1ON^Ou>l6@{xih00R{#J@d0-RhygF;9R@!dqTd0&4GksyfC2{BCIJ{0fi@O`C;|T(1PBHOCj}Y*6eTkWFcTXFuNFNH1YDp69bg9Y28}fWKLTC`C;<PyHw`5W5C$B`8nOuCABsC4pC02H2mdezFBB#XCJNsK2n-K5_&^Q@|0xX{4Jru+EB_B21PBoZDiHr16&@c3Ee{|61PBubED|0D|0WL~B1ao22Ky}(0zeT4ED#=l6(1o6E)*aH0sk!$9|k5AAR^aD94hbN1S_BeLaPZO8sZBkAQUDks;2=47$z!N!bfuf4EqMCW&(x*2E+k>21x+E2n{3@K>q?J9RUam0093R1PBBdB?AY)77r!^HVh_U1pY(d1O|Zt2H*kz2B854y8!^c-A6+pCMW>~ASNgM14F<jB?SZs2>&J|2LuQTCL-=J;0z`q9pMi%4gU}Z888735GMU1q<|78B@qD*e-tJt6A%d;0-*mE4>J`G`T-927$zZ}U>YVQ8UFze9403l5DEP*1E3xcGaV2l{|GQIC<78FGXF9qASE9=DINbmHajdGHW@PaA0j2WKqLb}BflU44kiya-JmG{1}G;QGXWa_{{UJl69^0d0C}S1pcB9<13@VSfcGp9HQ7Ke1}82583+jg02mkx^%dzL0ZzgWIutqo3=%RjA}}Q{`veFIq7DfG4j%gtG&KM+1|~5W`wrJfzz+Zc05bmuPX;yye+J(F0S4p&2KNC5|4{~f1``JO0sjWK0S0yk`2qh1CI)E+V+M@>0R|ujqyYxg{{aR929*H@HU9?e0R}7vItKp|22cj-0S3?i0S0OY`T+)<#{mYuej|#Bf1?iu@0S4veXb!M24(*Sp8*Ee0Rg^u4-F&}KmsNlFX3+kKm#9h;14x00lx+(2N^Q}-(e}Q5(o<b-(mtp!9ev1eE|g*pb7@A0SgA34fFs"),b)end,function(j)return function(m,n,p,b,d,i,_)local e,a,q,l,k,c,f l=j.Aa[-0x635c]or j:Ea(0x18,0x371affa,0x4c0c02b9,-0x635c)while true do if l>=0b10011001 then a,c=_[0b1001],0x1e q=a-c e,f,q,k=_[0b1010],p[q],_[0x1c],0b111110 l,c=j.Aa[0x5b0f]or j:Ea(0x28,0x253d564b,2457862473,0x5b0f),e-k a=p[c]else f[q]=a c,f,a,q,e=nil,n,nil,nil,i return f,q,a,c,e end end end end,function(j)return function(m,n,r,s,d,i,_)local f,k,q,e,h,c,g,a,l l=j.Aa[0x2313]or j:Da(2661513340,0x2fe09e,0x1282630,0x2313)while true do if l<0b1011100 then if l<=0b11 then e=f[1]a=c[e]r[q]=a l,c,a=0x264/l,0b101101,_[0b10001]h,q,k=c,a-c,_[0b10]e=k-h else q,e,c=s[0x19],0x11,_[0b1010]a=c-e c,f,a=0b10,q[a],_[0b1001]q,l,c=a-c,j.Aa[0xc5f]or j:Ea(0b10,3725892998,0x1e09017,0xc5f),f[0b10]end elseif l>0b1011100 then h,c,g=_[0b10010],r[e],0x22 k=h-g e=r[k]a=c-e r[q]=a a,l,q=nil,j.Aa[0x5535]or j:Ea(0x10,2201479977,0x18c8465c,0x5535),n else k,c,e=i,nil,nil return q,a,c,e,k end end end end,bit32.bxor,function(j)return function(m,n,x,w,d,i,_)local k,C,a,h,o,q,y,c,v,l,p,B,A,f,z,u,r,g,s A=j.Aa[-0x2d43]or j:Da(3182961401,0x6d7f65,0x3f94967c,-0x2d43)while true do if A>=0xa0 then if A<0xe0 then if A<=0b10110111 then if A>=0b10110101 then if A>0b10110101 then l=0b110 A=y and(j.Aa[-0x607e]or j:Ca(3722744447,0x2013095e,-0x607e))or 0x140-A else A,g=j.Aa[-0xe69]or j:Fa(0b10100,0x760e,-0xe69),1 h=a-g end else A=A+-0x9d end elseif A>0b11011011 then s,f=p(C,o)o=s A=o==nil and A+1 or(j.Aa[0x4294]or j:Fa(0b11000010,0x768a,0x4294))else y=n-v A=l>=r and(j.Aa[-0x618b]or j:Ea(0xb3,0xa407a1b,2434815926,-0x618b))or A+-0b10000000 end elseif A<0xe6 then if A<=0xe0 then f,p,C,o,s=i,n,nil,nil,nil return p,C,o,s,f else z,y=0b100110,_[0b1001]z,y,A,v=0x2b,_[0b1010],j.Aa[-0x7c27]or j:Da(0x514e7da3,0x11b49d80,0xe6ce557,-0x7c27),y-z q,z,y=y-z,0x22,_[0x11]a=y-z end elseif A<=0xf0 then if A<=0xe6 then u=f[1]A=u>=g and(j.Aa[-0xbfa]or j:Ca(2883585278,0x540612f1,-0xbfa))or A+-0b111 else A,B,c=0xd110/A,f[0b10],f[1]u=B[c]f[0b11]=u f[0b10]=f u=0b11 f[1]=u u=nil m[s]=u end else k=k(j.i(h))g,h=0,k.n A=a==g and 0x13c5/A or 0xaa65/A end elseif A<0b1011110 then if A>0x20 then g,C,p,o=p-C,nil,m,nil p,C,o=j.g(p,C,o)s,f=p(C,o)o=s A=o==nil and 0x13b-A or(j.Aa[0x4294]or j:Da(2274997246,0x6066d5ee,0xff976f9,0x4294))elseif A<=0b10101 then if A<=0b11 then A,h=0x2d3/A,j.h(h(j.i(g)))else g,p=v+h,1 A,n=0x8b-A,g-p end else A,g=j.Aa[0x4139]or j:Da(3288784827,0x24b13c96,0x1477e40e,0x4139),j.h(g(p,C,o))end elseif A>=0b1111011 then if A>=0b10000011 then if A>0b10000011 then z=1 y=q-z A=l>=z and(j.Aa[-0x607e]or j:Da(0x330128fe,0x4b32057e,0x35960be1,-0x607e))or(j.Aa[0x4ca5]or j:Fa(0x11,0x76a2,0x4ca5))else z,r,l=0,0b110,0b10010001 y=q==z A=y and 0x7011/A or(j.Aa[-0x618b]or j:Fa(0xb1,0x765a,-0x618b))end else g(p,C,o,s,f)C,A,p=0b101110,j.Aa[0x4371]or j:Fa(0b1010011,0x7635,0x4371),_[0b10]end elseif A>0b1011110 then p,A,g,o,C,f,s=k,j.Aa[-0x6eb6]or j:Fa(0b1010010,0x7607,-0x6eb6),w[0b11101],h,1,x,v else k,A,z=w[0b11],A+-0b111110,x[v]h,o,g,p=z,1,w[0b10101],x C,o=v+o,v+y end end end end,function(f)local h,e,b,c b=string c,b,e=b.char,bit32,b.byte h=b.bxor c={[1]=0b11,[0b11]=c}c[0b10]=c e={[1]=0b11,[0b11]=e}e[0b10]=e h={[1]=0b11,[0b11]=h}h[0b10]=h b=f:n{c,e,h}return b end,function(a,b,c,d,e)a.Aa[e]=a.b(d,d)+(-a.c(c,0xf265)+(-d+(a.a(a.d(a.a(0xffff,b)),a.a(d,0xffff))*a.a(a.a(b,0xffff),a.d(a.a(0xffff,d)))+a.b(a.a(0xffff,b),a.a(d,0xffff))*a.a(a.a(d,0xffff),a.a(b,0xffff))-a.a(0xffff,b)*a.a(0xffff,d)+a.c(d,a.c(d,a.c(c,0xf265)))))+a.d(a.a(a.d(b),a.d(a.a(a.c(c,0xf265),d)))))return a.Aa[e]end,function(j)local e,p,c,l,g,f,a,b,n,m,_,d,i l=0b10110100 while true do if l>=0x98 then if l>0b10011000 then _=bit32 p,d,n,m,b,i=_.rshift,_.band,_.bxor,_.bnot,_.lshift,_.bor m={[1]=0b11,[0b11]=m}l,m[0b10]=0b100,m n={[1]=0b11,[0b11]=n}n[0b10]=n p={[1]=0b11,[0b11]=p}p[0b10]=p b={[1]=0b11,[0b11]=b}b[0b10]=b else g={[1]=0b11,[0b11]=g}g[0b10]=g a={[1]=0b11,[0b11]=a}a[0b10]=a c={[1]=0b11,[0b11]=c}c[0b10]=c l,e=0x80,j:z{f,c,d,g,a,b,p,_,i,n,m}end elseif l<=0b100 then d={[1]=0b11,[0b11]=d}l,d[0b10]=l+0x94,d i={[1]=0b11,[0b11]=i}i[0b10]=i g=table _,f=g.insert,g.unpack _={[1]=0b11,[0b11]=_}_[0b10]=_ f={[1]=0b11,[0b11]=f}f[0b10]=f e=string a,c,g=e.char,e.byte,e.rep else e=e()return e end end end,function(j)return function(m,n,r,u,d,i,_)local q,o,e,b,k,h,a,g,l,f,c l=j.Aa[0x5535]or j:Ca(2252117503,0x50c22a5c,0x5535)repeat if l>=0b1011100 then if l<=0x70 then if l>0x5c then e,h,k,g,c=nil,nil,nil,i,n return c,e,k,h,g else b,a,o,q=0b1111110,0x2f,0xa5,_[0b1001]a,c,f=_[0x10],0b110,q-a c,l,e,q=_[0b10011],j.Aa[-0x7c27]or j:Da(2805997263,0x1a7247f,0x67c1d14,-0x7c27),0b10010,a-c a=c-e end else c=r[f]l=c and(j.Aa[0xad6]or j:Da(0x4419f665,0x2e030d89,0x647cf34b,0xad6))or(j.Aa[-0x938]or j:Da(0xbb77b5b,0x12866a7a,0x31ba19f8,-0x938))end elseif l<=0b1000100 then i=i+q l=b<=o and l+0b101100 or l+0b11000 else l,i=j.Aa[0x78ca]or j:Da(4143830014,0x8ba8505,0x459b6b,0x78ca),i+a end until false end end,function(j)return function(m,n,p,b,d,i,_)local e,g,l,c,f,a l=j.Aa[-0x2727]or j:Ca(0x537b8f5,4073210084,-0x2727)while true do if l<0b11100100 then c,e,a=nil,i,nil return f,g,a,c,e else a,g=0b110010,_[0b1001]c,a,l,f=_[0x1c],b[0b10111],j.Aa[0x70cd]or j:Da(0xe3930df,0x74572ac0,0x1cef1e37,0x70cd),g-a g=a[c]p[f]=g f,g=n,nil end end end end,function(j,t)return function(m,n,x)local a,u,l,w,k,A,d,r,y,_,z,o,B,c,h,D,p,g,e,f,q,v,C,b,i A=0xd6 repeat if A<0b10000100 then if A<0x3e then if A>=0b100001 then if A>0x2f then if A>0b110011 then if A>0b110101 then A=u>0 and A+0b111 or 0b11000100 elseif A<=0x34 then l,e,B=o[D],C[D],t[0b101][0b10][t[0b101][1]]e,A,c=4294967295,0b1100,e+l else A=D<f and 0x324f/A or 0b11101111 end elseif A>0x32 then A=u<=0 and 0x40-A or 0b11011111 elseif A>0b110001 then A=D<f and 0b10010011 or 0b10101101 elseif A<=0x30 then A=D<f and 0x29 or 0b10101011 else A,z,k,y=0x3a3,v,a,t[0b10][0b10][t[0b10][1]]end elseif A<=0x29 then if A>0b100100 then if A>0x28 then f,D=0b10000,1 u=D A=f~=f and 0b11110011 or A+0b11 else A=u~=u and 0x780/A or 0xfa-A end elseif A>=0x23 then if A<=0b100011 then A,f=0b100011111-A,f(u,B)g[C]=f else A,o,p,C,g,D=0b100011110-A,z,t[0b11][0b10][t[0b11][1]],"<I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4",t[0b1001][0b10][t[0b1001][1]],k end else A=D>0 and 0b1101000-A or 0b10001111 end elseif A>=0x2e then if A>0b101110 then A=D>f and 0x8d-A or 0x8e else A=y>z and A+-0b100011 or 0b10000010-A end elseif A<=0x2c then A=u>0 and 0x7a-A or A+0b11000 else A=k>0 and 0x2e or 0b1010100 end elseif A>=0b1101 then if A<0x15 then if A>=0b10011 then if A<=0b10011 then D=D+u A=u>0 and 0x2f or 0b10001110 else A=y>z and 0b1011 or 0b10101110 end elseif A<=0b1101 then A=D<f and 0x4c6/A or 0xdf else A,_=0b10101010,_(j.i(v))q={}q,v=1,q end elseif A>=0x1b then if A>0b11011 then A=k<=0 and 0b10110110 or A+0xb8 else A,u,D,f,o=A+0b110011100,h,C,1,t[0b110][0b10][t[0b110][1]]end elseif A>0x15 then y=y+k A=k>0 and 0x14 or 0b10101110 else A=D>f and 0x29 or 0x762/A end elseif A>=0b1001 then if A>=0b1011 then if A>0b1011 then A,B=0x7c8/A,B(c,e)C[D]=B else A,w=A+0xe7,a end elseif A<=0b1001 then D=D+u A=u>0 and 0x98 or A+0b10100011 else A=D>f and 0x3ac/A or 0x6ea/A end elseif A>0b101 then A,g=A+0xe6,g(p,C)o,C,p=0b1000000,"\0",t[0b111][0b10][t[0b111][1]]o=o-h elseif A>0b10 then A=u>0 and 0x6d or 0b101000 else f,u,A,B=t[0b100][0b10][t[0b100][1]],g[C],0x25-A,p[C]end elseif A>=0x5c then if A>=0x66 then if A<=0x7d then if A>0x71 then if A>0x78 then A=D<f and 0x93 or A+-0b1001001 else A=u<=0 and 0b110101 or A+0b1110111 end elseif A<=0x6d then if A<=0x66 then A=0xa4-A else A=D>f and 0b101001 or 0b101000 end else e,A,r,b,l=0b100,0x5f,0b1100,0x10,0b1000 end elseif A>=0b1111111 then if A<=0x7f then A=D>f and 0b11011010 or 0b10101000 else A=D<f and 0xda or 0b11000010 end else A,g=0x63ea/A,g(j.i(p))D,C,o=2911858879,t[0b1011][0b10][t[0b1011][1]],t[0b1100][0b10][t[0b1100][1]]end elseif A<=0x61 then if A<0x5e then if A<=0x5c then A=u~=u and 0x85-A or 0xab else A=u<=0 and 0x2d69/A or 0b110100 end elseif A>0b1011111 then A=D<=0 and 0xe5-A or 0b1100011-A elseif A<=0b1011110 then f,D=0b10000,1 u=D A=f~=f and A+0x35 or 0x1608/A else A=0x66 B(c,e,l,r,b)e,c,r,b,l=1,o,0b1011,0x10,0b110 end elseif A<=0x63 then if A>0x62 then A,k=0b100100,1 else A=u>0 and A+-0b1011000 or 0x43c2/A end else A=u~=u and 0b101010111-A or 0x5d5c/A end elseif A>=0b1010001 then if A<0x56 then if A>=0x54 then if A>0b1010100 then D=D+u A=u>0 and 0x56 or 0x52 else A=k~=k and 0x10a-A or 0b11101 end elseif A>0b1010001 then A=u<=0 and 0xf9 or 0x2008/A else A=D<f and 0x5e or 0xbf end elseif A>0b1011001 then A=u<=0 and 0x10e-A or 0xb6-A elseif A>0x58 then A=u<=0 and 0xe3-A or 0b10111001 elseif A>0x56 then A=k~=k and 0b1011 or 0x12d-A else A=D>f and 0b101001001-A or 0b10101000-A end elseif A<0x47 then if A>=0x43 then if A<=0x43 then A=D>f and A+0x50 or 0b11000100 else A=u~=u and 0xe14/A or 0x1fe0/A end else A=0x3c10/A B(c,e,l,r,b)b,l,c,e,r=0b1101,0b111,o,0b10,0b1100 end elseif A<=0b1001110 then if A<=0x48 then if A>0x47 then A=0x3c78/A B(c,e,l,r,b)l,e,b,c,r=0b101,0b100,0b1111,o,0b1010 else A=C>o and 0x132-A or A+0x48 end else A=D>f and 0x4a0a/A or 0b10010010-A end else C,g,A,p=k,t[0b110][0b10][t[0b110][1]],0x56-A,z end elseif A>0xcf then if A<=0xf3 then if A<0b11100010 then if A<0b11010111 then if A<=0xd5 then if A<0b11010100 then A=u<=0 and A+-0b10100010 or 0x8c46/A elseif A<=0b11010100 then A=0b1110001 B(c,e,l,r,b)c=o else h=v[y]A,a=0x16,a..h end else q,v,i,_,A,d=x,"<I4I4I4I4I4I4I4I4",t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]],0b10111000,0 end elseif A<0b11011101 then if A<=0b11010111 then A=0b10011 B(c,e,l,r,b)else C[0b1101]=y D,f=1,0b11 u=D A=f~=f and 0x22ea/A or 0b101 end elseif A>0xdd then A,c,b,r,B,l,e=0b10100101,o,0b1101,0b1001,t[1][0b10][t[1][1]],0b101,1 else A,v=0b10001,j.h(v(q,a))end elseif A>0b11101100 then if A>0xf2 then f,D=0b1010,1 u=D A=f~=f and 0b1011110 or 0b1100010 elseif A>0b11101111 then return w else B=C[D]A,o[D]=0b1010101,B end elseif A<0xea then if A>0xe2 then A,b,r=A+-0x24,0b1110,0b1010 else a,y,z="",1,#v k=y A=z~=z and 0b1011 or 0x2d end elseif A>0xeb then p=p(C,o)A,z=0x5b44/A,g..p elseif A>0xea then A,f,D,o,C=0x4d2-A,g,t[0b1000][0b10][t[0b1000][1]],"<I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4",t[0b1010][0b10][t[0b1010][1]]else b,A,r=0b1110,A+-0xa2,0b1001 end elseif A>0x1de then if A>=0x37a then if A>=0x3a3 then if A<=0x3a3 then y(z,k)y=0x40 q,A,y=q+y,0b10101010,1 d=d+y else A,D=A+-0x6d,j.h(D(f))end else C=C(o,j.i(D))o=0b1000000 A=h<o and 0x395-A or 0x28a1e/A end elseif A<=0x27f then if A>0b111100110 then A=C>o and A+-0x194 or 0x336 else A=C<o and 0x2d1-A or 0x1de end else A=D<=0 and 0b111100110 or 0x514-A end elseif A<=0b11111100 then if A>=0b11111010 then if A<0xfb then A,p=0x7e,j.h(p(C,o,D))elseif A>0b11111011 then C=C+D A=D>0 and 0x37b-A or A+0x23a else A=D>f and 0x93 or 0x88 end elseif A>0xf8 then A=D<f and 0xf3 or 0b101011101-A else A=0xe2b0/A B(c,e,l,r,b)l,c,e=0b1000,o,0b11 end elseif A>=0b110110111 then if A>0b110110111 then A=D~=D and 0b11101011 or 0b10 else o=o(D,f,u)A,C=0xbb,o end else A,i=0b11001111,i(j.i(_))q,_,v="<I4I4I4",t[0b1001][0b10][t[0b1001][1]],t[0b11][0b10][t[0b11][1]]end elseif A>=0xac then if A>=0xbb then if A<0xc5 then if A>=0b11000010 then if A<=0xc2 then A=u~=u and 0b110011100-A or 0x17b-A else A=u~=u and 0x7d or 0x5d end elseif A>0xbb then A=u~=u and 0b1011110 or 0xdf else A,a=0x23cb/A,C end elseif A>0xcb then A,a=A+0b1110,n elseif A>0xc8 then C[1],u,B,f=D,3883703626,2619586929,3235114199 C[0b10]=f C[0b11]=u C[0b100]=B D,f=1,0b1000 u=D A=f~=f and A+0b1111 or A+-0x28 elseif A>0b11000101 then k,y,z=q,d,m p=#z g,p=p-k,1 g,h=0b1000000,g+p A=h<g and 0x50 or 0b100100 else A=0b110011001-A B(c,e,l,r,b)l,r,e,b,c=0b111,0b1011,0b11,0b1111,o end elseif A>=0b10110100 then if A<=0xb8 then if A<=0b10110110 then if A<=0b10110100 then A=D<f and 0b101001 or 0b1011100 else A=y<z and A+-0b10101011 or 0b11010101 end else A,_=0xb748/A,j.h(_(v,q))end else c=0b100 B,A,c=D+c,0b1001,i[D]C[B]=c end elseif A>=0b10101110 then if A<=0b10101110 then A=k<=0 and A+-0b100101 or 0x3bd0/A else A=u~=u and 0x8fd/A or 0b110011 end elseif A>0xac then A=u~=u and 0x140-A or 0x34 else A=u<=0 and 0x82 or A+0b10110 end elseif A<0b10011000 then if A<0b10001010 then if A>0b10001000 then A=y<z and 0b1011 or 0b1011000 elseif A<0b10000101 then A=C<o and A+0x67 or 0b10 elseif A<=0b10000101 then D=D+u A=u>0 and 0x9a-A or A+-0x2b else A=u<=0 and 0b110010 or 0xad end elseif A<0x8f then if A<=0b10001010 then A=D<f and 0xda or 0xb9 else A=u<=0 and 0x51 or 0b10111111 end elseif A<=0x8f then A=D~=D and 0x84 or 0b1100001 else A,p=0xa7,C end elseif A<=0xa7 then if A>0b10100101 then if A<=0xa6 then D=D+u A=u>0 and 0x1a1-A or 0x88 else C,o=1,0b10000 D=C A=o~=o and 0xeb or 0x1587/A end elseif A<=0b10100011 then if A<=0x98 then A=D>f and 0b101110010-A or 0x6620/A else A=u>0 and A+-0b100100 or 0x6af8/A end else A=0x18e-A B(c,e,l,r,b)l,e,c=0b110,0b10,o end elseif A>=0xaa then if A>0b10101010 then c=0b1101 c,B=_[D],D+c A,C[B]=0x58d7/A,c else a=#m A=q<=a and 0b11001000 or A+0b111000 end else A=u~=u and A+-0x1e or 0b1011001 end until false end end,function(j,o)return function(m)local f,k,l,b,p,_,d,n,c,g,a,e,i l=0b1000 repeat if l>=0xb9 then if l<=0xb9 then f=0b1010101 c,a,e,_,f,k=m,m.sub,p,n*f,"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~",p a=a(c,e,k)c,g,e,f=1,f,true,f.find l,f=l+0b100110,f(g,a,c,e)_,i=1,_+f n=i-_ else p=p+d l=(d>0 and p>b or d<=0 and p<b or d~=d)and 0b100100010-l or 0b110011000-l end elseif l>0b1000 then p,b,d,i=o[1][0b10][o[1][1]],o[0b11][0b10][o[0b11][1]],n,0x18 b=b(d,i)d,i,f,_=o[0b10][0b10][o[0b10][1]],o[0b11][0b10][o[0b11][1]],0b10000,n i=i(_,f)_=0b11111111 d=d(i,_)g,i,_,f=0b1000,o[0b10][0b10][o[0b10][1]],o[0b11][0b10][o[0b11][1]],n _=_(f,g)f=0b11111111 i=i(_,f)f,g,_=n,0b11111111,o[0b10][0b10][o[0b10][1]]_=j.h(_(f,g))p=j.h(p(b,d,i,j.i(_)))return j.i(p)else n,b,p=0,0b101,1 d=p l=(b~=b or(d>0 and p>b or(d<=0 or d~=d)and p<b))and 0b1000011 or 0xb9 end until false end end,function(j)return function(m,n,r,u,d,i,_)local k,h,b,e,f,q,g,p,l,a,c l=j.Aa[-0x15c8]or j:Ea(0b10000101,3868226304,0x8217aef,-0x15c8)repeat if l<=0b10100011 then if l>0x30 then if l<=0b1000001 then h=k[1]l=h>=f and 0x110-l or(j.Aa[0x7518]or j:Fa(0b1100,0x7644,0x7518))else k=-1 l=c==k and(j.Aa[-0x4905]or j:Ea(0x20,0x1a8d645a,3308415200,-0x4905))or(j.Aa[-0x2e9a]or j:Ea(0x97,0x1136c01f,2726415419,-0x2e9a))end elseif l>=0x2c then if l>0b101100 then k,b,h,p,g=n,i,e,true,q return k,h,g,p,b else e,k=q(a,c)c=e l=c==nil and l+0x9f or 0x6d-l end else l,k,h=0x600/l,n-q,1 e=k+h end elseif l<=0xcf then if l<0b11001011 then k=1 l,e=j.Aa[-0x3e66]or j:Da(0x1930ebf7,0x21dbaba,0x1e6c4976,-0x3e66),a-k elseif l<=0b11001011 then l,a,c=0x16e-l,_[0b1010],0b110 e,c,q=0x3c,_[0b10001],a-c a,e=c-e,1 c,e=a-e,nil else g,p=k[0b10],k[1]h=g[p]l,k[0b11]=0x2394/l,h k[0b10]=k h=0b11 k[1]=h h=nil m[e]=h end else a,q=0b11,_[0b1001]f,c,q,a=q-a,nil,m,nil q,a,c=j.g(q,a,c)e,k=q(a,c)c=e l=c==nil and(j.Aa[0x144f]or j:Ea(0x81,3163169166,0x111205f,0x144f))or(j.Aa[-0xc75]or j:Fa(0x41,0x762c,-0xc75))end until false end end,function(j)return function(m,n,r,s,d,i,_)local c,p,k,a,h,l,q,e,f l=j.Aa[-0x6f68]or j:Ca(4005165298,0x100207ba,-0x6f68)repeat if l>0xac then q,p,a=_[0b1001],0b100101,1 f,l,c,e=q-a,j.Aa[0x218c]or j:Ca(0x6970bff,2154328123,0x218c),_[0b1010],0x26 a=c-e q=r[a]r[f]=q q=_[0x11]elseif l<=0b111011 then a=0b11 e,f,k=_[0b10],q-a,0b11011 c=e-k h,k,a=0x24,_[0b10010],r[c]e=k-h l=p<=h and 0xed-l or(j.Aa[0x4783]or j:Ca(0x2799d5bd,2552365292,0x4783))else c=r[e]q=a..c r[f]=q q,a,f,c,e=nil,nil,n,nil,i return f,q,a,c,e end until false end end,function(j,o)return function(m)local g,c,b,a,e,r,i,d,_,k,q,f,n,h,l l=0xdf while true do if l<0b1101010 then if l<=0b100100 then if l>=0b1010 then if l<=0b11101 then if l>=0b1110 then if l<=0b1110 then d=f l=b~=d and 0b11010001 or 0b111000/l else l=0b110011 end else _=_(f,q)f,a,l,q,c=o[0b10][0b10][o[0b10][1]],r,0x6f-l,o[1][0b10][o[1][1]],0b101000 end else l,d=0b1011101,d(i,_,f,q,a,c,e,j.i(k))end elseif l<=0b101 then if l>0b100 then f=f(q,a)l,q=0b1111-l,0xff else d,q,i,f,l,_=o[0b11][0b10][o[0b11][1]],0b111000,o[0b10][0b10][o[0b10][1]],r,0b1011111,o[1][0b10][o[1][1]]end else a=a(c,e)e,l,k,h,c=o[1][0b10][o[1][1]],l+0x61,r,0x10,o[0b10][0b10][o[0b10][1]]end elseif l<0b1011101 then if l>=0b111010 then if l<=0b111010 then l,a=0b101,0x30 else a=a(c,e)l,c=0x3b6a/l,0b11111111 end else l,c=0b1001,c(e,k)e=0xff end elseif l>=0b1011111 then if l>0x5f then l,q=0x4769/l,q(a,c)a=0xff else _=_(f,q)l,f=0b10101011,0b11111111 end else m=m..d return m end elseif l>=0xa9 then if l>0b11010001 then if l<=0b11011111 then if l>0xd5 then l,b,n=0b1110,0b1000,#m b,r="\128",n*b f,d,m=0b1001,0x40,m..b _,f=n+f,d i=_%f b=d-i else c,a,l,q,e=r,o[1][0b10][o[1][1]],0x5a,o[0b10][0b10][o[0b10][1]],0x20 end else l,k=l+-0b11010001,j.h(k(h,g))end elseif l>=0b10110101 then if l<=0b10110101 then l,f=0x18a-l,f(q,a)else i,_,l,d="\0",b,0b101000101-l,o[0b100][0b10][o[0b100][1]]end elseif l>0xa9 then l,i=0x3a,i(_,f)f,_,q=o[1][0b10][o[1][1]],o[0b10][0b10][o[0b10][1]],r else q=q(a,c)a,k,c,l,e=o[0b10][0b10][o[0b10][1]],0b11000,o[1][0b10][o[1][1]],0x1325/l,r end elseif l<0b1110100 then if l>=0b1110001 then if l>0b1110001 then g,h,l,k=0b1000,r,0x77,o[1][0b10][o[1][1]]else c=c(e,k)l,e=0x3252/l,o[0b10][0b10][o[0b10][1]]end else e=e(k,h)l,k=0x2eca/l,0xff end elseif l>0x77 then l,e=0b11110101,e(k,h)h,k,g=r,o[0b10][0b10][o[0b10][1]],0xff elseif l<=0b1110100 then d=d(i,_)l,m=l+-0b1110000,m..d else k=k(h,g)l,h=0x79,0xff end end end end,function(j)return function(m,n,p,b,d,i,_)local l,k,c,q,e,a,f l=j.Aa[-0x191d]or j:Fa(0b10010100,0x767e,-0x191d)repeat if l>=0x96 then a,q=0b10111,_[0b1001]e,f,k=_[0b1010],q-a,0x24 c=e-k a,l,c=p[c],j.Aa[-0x3d2]or j:Ca(0x4d65566e,0x29aa16b,-0x3d2),_[0x1c]q=a[c]else p[f]=q f,c,e,a,q=n,nil,i,nil,nil return f,q,a,c,e end until false end end,function(a,b,c,d)a.Aa[d]=a.m(b,c)return a.Aa[d]end,function(j)return function(m,n,r,b,d,i,_)local e,h,c,l,f,q,k,a l=j.Aa[-0x6eb6]or j:Fa(0x23,0x7614,-0x6eb6)repeat if l>0xd9 then l,e=j.Aa[-0x1ba7]or j:Ca(2983460057,0x422401f9,-0x1ba7),0x34 k,a,e=q[1],c-e,q[0b10]c=e[k]r[a]=c e,a,c=nil,n,nil elseif l>0xcf then h,k=i,nil return a,c,e,k,h elseif l>0b1111011 then e=f[1]a=c[e]r[q]=a a,e,k=b[0x19],_[0b10],0x33 c=e-k c,l,q=_[0x11],0b110110000-l,a[c]else q,c,e=b[0x19],_[0b1010],0x36 a=c-e f,c,l,a=q[a],0b101101,j.Aa[-0x22fc]or j:Da(4194180559,0x2b8c3f6,0x148bed9,-0x22fc),_[0b1001]q,c=a-c,f[0b10]end until false end end,function(_,a)return function()local c c=function(ra,ga,ia,ka,ma)local na,oa,pa,qa=ra[ga],ra[ia],ra[ka],ra[ma]local ea na=a[1][0b10][a[1][1]](na+oa,4294967295)ea=a[0b10][0b10][a[0b10][1]](qa,na)qa=a[1][0b10][a[1][1]](a[0b11][0b10][a[0b11][1]](a[0b100][0b10][a[0b100][1]](ea,0x10),a[0b101][0b10][a[0b101][1]](ea,0b10000)),4294967295)pa=a[1][0b10][a[1][1]](pa+qa,4294967295)ea=a[0b10][0b10][a[0b10][1]](oa,pa)oa=a[1][0b10][a[1][1]](a[0b11][0b10][a[0b11][1]](a[0b100][0b10][a[0b100][1]](ea,0b1100),a[0b101][0b10][a[0b101][1]](ea,0b10100)),4294967295)na=a[1][0b10][a[1][1]](na+oa,4294967295)ea=a[0b10][0b10][a[0b10][1]](qa,na)qa=a[1][0b10][a[1][1]](a[0b11][0b10][a[0b11][1]](a[0b100][0b10][a[0b100][1]](ea,0b1000),a[0b101][0b10][a[0b101][1]](ea,0x18)),4294967295)pa=a[1][0b10][a[1][1]](pa+qa,4294967295)ea=a[0b10][0b10][a[0b10][1]](oa,pa)oa=a[1][0b10][a[1][1]](a[0b11][0b10][a[0b11][1]](a[0b100][0b10][a[0b100][1]](ea,0b111),a[0b101][0b10][a[0b101][1]](ea,0b11001)),4294967295)ra[ga],ra[ia],ra[ka],ra[ma]=na,oa,pa,qa return ra end do c={[1]=0b11,[0b11]=c}c[0b10]=c end local sa={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}do sa={[1]=0b11,[0b11]=sa}sa[0b10]=sa end local ta={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}do ta={[1]=0b11,[0b11]=ta}ta[0b10]=ta end return _:x{c,a[0b1100],a[0b1001],a[0b10],a[1],a[0b110],a[0b111],a[0b1011],a[0b1000],a[0b1010],sa,ta}end end}):l({"da","P","ha","r","pa","aa","V","D","z","za","ra","Aa","ea","k","q","y","Q","C","E","g","B","Ca","Fa","xa","I","sa","Ea","ta","L","ka","j","N","_a","Ga","ya","qa","b","m","Y","K","d","G","ga","a","ca","W","J","S","X","_","s","Da","w","la","M","R","T","u","F","c","A","x","O","U","ua","fa","t","H","ma","oa","na","ba","ja","ia","Ba","va","n","wa","v"},"Ga",...)
end)
