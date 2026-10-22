-- 99% fixed, this scrip is rlly good for hvh if u have a good config.
-- Fixed by the autistic of V.Roy, i am so fucking tired i wanna kill my shelf.
-- BRO IF DONT WORK FOR U SUCK MY DICK FUCKING BITCH, BTW BTW DO U KNOW WHAT I MEAN RIGHT. 

--local runUnlockAllCosmetics

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

-- Screenshot Ragebot Methods
flags.ragebot                   = false
flags.ragebot_enabled           = false
flags.ragebot_auto_cycle        = false
flags.ragebot_cycle_state       = false
flags.ragebot_cycle_interval    = 0.001
flags.ragebot_void_spam         = false
flags.voidspam_enabled          = false
flags.voidspam                  = false
flags.teleport_v2_origin        = false
flags.wallbang_method           = "Teleport V2"
flags.silent_wallbang           = false
flags.ragebot_void_spam_method  = "Aggressive"
flags.ragebot_void_spam_hide    = 0.25
flags.ragebot_shoot_attempts    = 2
flags.ragebot_void_spam_attack  = 0.05
flags.ragebot_shooting_method   = "Teleport V2"
flags.ragebot_shoot_method      = "Teleport V2"
flags.ragebot_attack_mode       = "gun"
flags.ragebot_preferred_weapon  = "primary"
flags.ragebot_voidspam_settings = "hide when shooting"
flags.target_priority           = "Closest"
flags.ragebot_tp_x              = 0
flags.ragebot_tp_y              = -7
flags.ragebot_tp_z              = -5
flags.block_rage                 = false
flags.block_fake_position       = true

-- Screenshot Anti-Aim Methods
flags.antiaim_client_wont_see   = false
flags.antiaim_enabled           = false
flags.antiaim_hidehead          = false
flags.antiaim_rapid_body        = false
flags.pitch_type                = "Up & Down"
flags.antiaim_preset            = "None"
flags.yaw_type                  = "None"
flags.yaw_speed                 = 100
flags.antiaim_custom_yaw        = 0
flags.antiaim_custom_pitch      = 0
flags.antiaim_spinbot           = false
flags.antiaim_spinbot_speed     = 15
flags.staff_detector            = false
flags.mod_detector              = false
flags.mod_detector_leave        = false
flags.mod_detector_evade        = false
flags.staff_action              = "Notify"


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
    WalkMode          = false,
    SurfaceCamera     = false,
    AutoNoclip        = false,
    AutoHandoff       = false,
    VisualizerEnabled = false,
    VisualizerColor   = Color3.fromRGB(0, 162, 255),
    Panic             = false,
    PanicMinX         = -5,
    PanicMaxX         = 5,
    PanicZ            = false,
    HideMeshes        = false,
    AnimationDesync   = false,
    ZeroVelocity      = false,
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
    Enabled           = false,
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

    pcall(function()
        if fakePos.AnimTrack and fakePos.AnimTrack.IsPlaying then
            fakePos.AnimTrack.TimePosition = 1.48
            fakePos.AnimTrack:AdjustSpeed(0)
            return
        end

        if fakePos.AnimTrack then
            pcall(function()
                fakePos.AnimTrack:Stop()
                fakePos.AnimTrack:Destroy()
            end)
            fakePos.AnimTrack = nil
        end

        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://10714003221"
        local track = hum:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0, 1, 0)
        track.TimePosition = 1.48
        track:AdjustSpeed(0)
        fakePos.AnimTrack = track
    end)
end

local function stopAnimDesync()
    if fakePos.AnimTrack then
        pcall(function()
            fakePos.AnimTrack:Stop(0.1)
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
    pcall(function() meowState.ManipulatedActive = true end)
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
    pcall(function() meowState.ManipulatedActive = false end)
end

getgenv().set_position_desync = set_position_desync
getgenv().clear_position_desync = clear_position_desync

local function setFakePosition(state)
    if state and flags.block_fake_position then return end
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
    if not flags.staff_detector and not flags.mod_detector then return end
    if not staffDetectorState.Enabled or not player or player == LocalPlayer then return end
    task.spawn(function()
        pcall(function()
            local nameLower = player.Name:lower()
            local dispLower = (player.DisplayName or ""):lower()
            local isStaff = false

            for _, kw in ipairs(MOD_KEYWORDS) do
                if nameLower == kw or dispLower == kw or nameLower:find("^" .. kw .. "[_%d]") or dispLower:find("^" .. kw .. "[_%d]") then
                    isStaff = true
                    break
                end
            end

            if isStaff and not staffDetectorState.DetectedStaff[player.UserId] then
                staffDetectorState.DetectedStaff[player.UserId] = true
                local msg = "[Sleepy Hub] Staff / Mod detected: " .. player.Name .. " (" .. player.DisplayName .. ")"
                warn(msg)
                if Library and Library.notifications then
                    pcall(function()
                        Library.notifications:create_notification({
                            name = "Staff Alert",
                            info = "Staff member detected: " .. player.Name,
                            lifetime = 8
                        })
                    end)
                end
                if not match_in_round() then
                    if staffDetectorState.AutoHop then
                        pcall(function()
                            local ts = game:GetService("TeleportService")
                            ts:Teleport(game.PlaceId, LocalPlayer)
                        end)
                    elseif staffDetectorState.AutoKick then
                        pcall(function()
                            LocalPlayer:Kick("Preventive disconnect: Staff member joined")
                        end)
                    end
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

local function resolveColor3(val, fallback)
    if typeof(val) == "Color3" then
        return val
    elseif type(val) == "table" then
        if typeof(val.Color) == "Color3" then
            return val.Color
        elseif type(val.Color) == "table" and val.Color.r and val.Color.g and val.Color.b then
            return Color3.new(val.Color.r, val.Color.g, val.Color.b)
        elseif type(val.Color) == "string" then
            local ok, c = pcall(Color3.fromHex, val.Color)
            if ok and c then return c end
        elseif val.r and val.g and val.b then
            return Color3.new(val.r, val.g, val.b)
        elseif val.hex and type(val.hex) == "string" then
            local ok, c = pcall(Color3.fromHex, val.hex)
            if ok and c then return c end
        end
    end
    return fallback or Color3.new(1, 1, 1)
end

local function resolveTransparency(val, fallback)
    if type(val) == "number" then
        return val
    elseif type(val) == "table" and type(val.Transparency) == "number" then
        return val.Transparency
    end
    return fallback or 0
end

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

                        local isRageActive = flags.ragebot_cycle_state
                        if isRageActive or (onScreen and (not flags.silent_aim_enabled or fovDist <= fovRadius)) then
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
    mode = mode or flags.yaw_type or flags.antiaim_yaw or "None"
    if mode == "None" then return 0 end
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
    return 0
end

-- set_position_desync handled by real desync engine above

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
        statsLbl.Font = Enum.Font.GothamSemibold
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

local targetVisThrottle = 0
local function updateTargetVisuals()
    local now = os.clock()
    if now - targetVisThrottle < 0.05 then return end
    targetVisThrottle = now

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

    if flags.target_highlight and target and target.Character and target.Character.Parent then
        local char = target.Character
        local hl = meowState.TargetHighlight
        if not hl or not hl.Parent then
            pcall(function()
                if hl then hl:Destroy() end
                hl = Instance.new("Highlight")
                hl.Name = "_MeowTargetHighlight"
                hl.Parent = char
                meowState.TargetHighlight = hl
            end)
        elseif hl.Parent ~= char then
            pcall(function()
                hl.Parent = char
            end)
        end
        hl = meowState.TargetHighlight
        if hl and hl.Parent == char then
            pcall(function()
                hl.Adornee = char
                hl.OutlineColor = resolveColor3(flags.target_highlight_outline, Color3.fromRGB(255, 60, 60))
                hl.FillColor = resolveColor3(flags.target_highlight_fill, Color3.fromRGB(180, 30, 30))
                hl.OutlineTransparency = resolveTransparency(flags.target_highlight_outline, 0)
                hl.FillTransparency = resolveTransparency(flags.target_highlight_fill, 0.5)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Enabled = true
            end)
        end
    elseif meowState.TargetHighlight then
        pcall(function()
            meowState.TargetHighlight.Enabled = false
            meowState.TargetHighlight.Adornee = nil
        end)
    end

    if flags.target_snapline and target and target.HitPart then
        local cam = Workspace.CurrentCamera or Camera
        local scrPos, onScreen = cam:WorldToViewportPoint(target.HitPart.Position)
        if onScreen then
            if not meowState.TargetSnapline then
                pcall(function()
                    meowState.TargetSnapline = Drawing.new("Line")
                end)
            end
            local line = meowState.TargetSnapline
            if line then
                line.From = cam.ViewportSize / 2
                line.To = Vector2.new(scrPos.X, scrPos.Y)
                line.Color = resolveColor3(flags.target_snapline_color, Color3.fromRGB(255, 80, 80))
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
            color = resolveColor3(flags.tracer_color, Color3.fromRGB(120, 180, 255)),
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

local weaponVisThrottle = 0
local function updateWeaponVisuals()
    local now = os.clock()
    if now - weaponVisThrottle < 0.05 then return end
    weaponVisThrottle = now

    local wfCol1 = resolveColor3(flags.wireframe_color, Color3.fromRGB(255, 255, 255))
    local wfCol2 = resolveColor3(flags.wireframe_color2, Color3.fromRGB(0, 162, 255))
    MeowWireframe.Enabled      = flags.item_wireframe or false
    MeowWireframe.ArmEnabled   = flags.arm_appearance or false
    MeowWireframe.Color        = wfCol1
    MeowWireframe.Color2       = wfCol2
    MeowWireframe.ColorMiddle  = wfCol1:Lerp(wfCol2, 0.5)
    MeowWireframe.Transparency = resolveTransparency(flags.item_chams_transparency, 0)

    MeowWireframe:Update()

    local itemVisual = MeowWireframe:GetGunModel()
    if not itemVisual then return end

    local chamsEnabled = flags.item_chams
    local chamsMat = flags.item_chams_material or "ForceField"
    local chamsColor = resolveColor3(flags.item_chams_color, Color3.fromRGB(0, 162, 255))
    local chamsTrans = resolveTransparency(flags.item_chams_transparency, 0.2)

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
    local col = resolveColor3(flags.crosshair_color, Color3.fromRGB(0, 162, 255))

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
        local dotColor = resolveColor3(flags.crosshair_dot_color, col)

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
            circ.Color = resolveColor3(flags.fov_color, Color3.fromRGB(0, 162, 255))
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
            aCirc.Color = resolveColor3(flags.aimbot_fov_color, Color3.fromRGB(120, 180, 255))
            aCirc.Visible = true
        else
            aCirc.Visible = false
        end
    end
end

local function safeDestroyDrawing(d)
    if not d then return end
    pcall(function()
        if type(d.Remove) == "function" then
            d:Remove()
        elseif type(d.Destroy) == "function" then
            d:Destroy()
        end
    end)
end

local function safeNewDrawing(dtype)
    local ok, d = pcall(Drawing.new, dtype)
    if ok and d then
        return d
    end
    return nil
end

local function cleanEspEntry(entry)
    if not entry then return end
    safeDestroyDrawing(entry.Box)
    safeDestroyDrawing(entry.BoxOutline)
    safeDestroyDrawing(entry.BoxFill)
    if entry.BoxCorners then
        for _, l in ipairs(entry.BoxCorners) do
            safeDestroyDrawing(l)
        end
    end
    safeDestroyDrawing(entry.HealthBar)
    safeDestroyDrawing(entry.HealthBarOutline)
    safeDestroyDrawing(entry.HealthNumber)
    safeDestroyDrawing(entry.AmmoBar)
    safeDestroyDrawing(entry.AmmoBarOutline)
    safeDestroyDrawing(entry.Name)
    safeDestroyDrawing(entry.Weapon)
    safeDestroyDrawing(entry.Distance)
    safeDestroyDrawing(entry.Rank)
    safeDestroyDrawing(entry.Streak)
    safeDestroyDrawing(entry.Deflecting)
    safeDestroyDrawing(entry.HeadMarker)
    safeDestroyDrawing(entry.Tracer)
    safeDestroyDrawing(entry.TracerOutline)
end

local function createEspEntry(player)
    local entry = { Player = player, BoxCorners = {} }
    local ok = pcall(function()
        for i = 1, 8 do
            local l = safeNewDrawing("Line")
            if l then
                l.Visible = false
                entry.BoxCorners[i] = l
            end
        end
        entry.Box = safeNewDrawing("Square")
        entry.BoxOutline = safeNewDrawing("Square")
        entry.BoxFill = safeNewDrawing("Square")
        entry.HealthBar = safeNewDrawing("Square")
        entry.HealthBarOutline = safeNewDrawing("Square")
        entry.HealthNumber = safeNewDrawing("Text")
        entry.AmmoBar = safeNewDrawing("Square")
        entry.AmmoBarOutline = safeNewDrawing("Square")
        entry.Name = safeNewDrawing("Text")
        entry.Weapon = safeNewDrawing("Text")
        entry.Distance = safeNewDrawing("Text")
        entry.Rank = safeNewDrawing("Text")
        entry.Streak = safeNewDrawing("Text")
        entry.Deflecting = safeNewDrawing("Text")
        entry.HeadMarker = safeNewDrawing("Circle")
        entry.Tracer = safeNewDrawing("Line")
        entry.TracerOutline = safeNewDrawing("Line")
    end)

    if not ok or not entry.Box then
        cleanEspEntry(entry)
        return nil
    end
    return entry
end

local function hideEspEntry(entry)
    if not entry then return end
    pcall(function()
        if entry.Box then entry.Box.Visible = false end
        if entry.BoxOutline then entry.BoxOutline.Visible = false end
        if entry.BoxFill then entry.BoxFill.Visible = false end
        if entry.BoxCorners then
            for _, l in ipairs(entry.BoxCorners) do l.Visible = false end
        end
        if entry.HealthBar then entry.HealthBar.Visible = false end
        if entry.HealthBarOutline then entry.HealthBarOutline.Visible = false end
        if entry.HealthNumber then entry.HealthNumber.Visible = false end
        if entry.AmmoBar then entry.AmmoBar.Visible = false end
        if entry.AmmoBarOutline then entry.AmmoBarOutline.Visible = false end
        if entry.Name then entry.Name.Visible = false end
        if entry.Weapon then entry.Weapon.Visible = false end
        if entry.Distance then entry.Distance.Visible = false end
        if entry.Rank then entry.Rank.Visible = false end
        if entry.Streak then entry.Streak.Visible = false end
        if entry.Deflecting then entry.Deflecting.Visible = false end
        if entry.HeadMarker then entry.HeadMarker.Visible = false end
        if entry.Tracer then entry.Tracer.Visible = false end
        if entry.TracerOutline then entry.TracerOutline.Visible = false end
    end)
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

local espThrottle = 0
local function updateEsp()
    local now = os.clock()
    if now - espThrottle < 0.1 then return end
    espThrottle = now

    local isEspEnabled = flags.esp_enabled or flags.esp_box or flags.esp_boxes or flags.esp_name or flags.esp_names or flags.esp_team_enabled
    if not isEspEnabled then
        for _, entry in pairs(meowState.EspBoxes) do
            hideEspEntry(entry)
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
                if e then hideEspEntry(e) end
                continue
            end

            local entry = meowState.EspBoxes[pl]
            if not entry then
                entry = createEspEntry(pl)
                if not entry then continue end
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
                        local rawBoxCol = isTeammate and (flags.esp_team_box_color or Color3.fromRGB(80, 180, 255))
                            or (flags.esp_box_color or flags.esp_box_color1 or Color3.fromRGB(255, 255, 255))
                        local boxColor = resolveColor3(rawBoxCol, Color3.fromRGB(255, 255, 255))
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
                            entry.BoxFill.Color = resolveColor3(flags.esp_fill_color or flags.esp_fill_color1, Color3.fromRGB(0, 162, 255))
                            entry.BoxFill.Filled = true
                            entry.BoxFill.Transparency = 0.25
                            entry.BoxFill.Visible = true
                        else
                            entry.BoxFill.Visible = false
                        end

                        local showHp = isTeammate and flags.esp_team_health or (flags.esp_health_bars ~= false and flags.esp_health_bar ~= false and flags.esp_healthbar ~= false)
                        local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        if showHp then
                            local barWidth = 3
                            local fillH = boxHeight * hpPct
                            local hpColor = resolveColor3(flags.esp_health_color or flags.esp_healthbar_color_start, Color3.fromRGB(0, 255, 120))
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
                            entry.HealthNumber.Color = resolveColor3(flags.esp_hp_num_color, Color3.fromRGB(255, 255, 255))
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
                            entry.AmmoBar.Color = resolveColor3(flags.esp_ammo_color, Color3.fromRGB(0, 162, 255))
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
                            local rawNameCol = isTeammate and (flags.esp_team_name_color or Color3.fromRGB(80, 180, 255))
                                or (flags.esp_name_color or flags.esp_world_name_color or Color3.fromRGB(240, 240, 240))
                            entry.Name.Color = resolveColor3(rawNameCol, Color3.fromRGB(240, 240, 240))
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
                            entry.Weapon.Color = resolveColor3(flags.esp_weapon_color or flags.esp_weapon_color2, Color3.fromRGB(220, 220, 220))
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
                            entry.Distance.Color = resolveColor3(flags.esp_dist_color or flags.esp_distance_color1, Color3.fromRGB(180, 180, 180))
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
                            entry.Rank.Color = resolveColor3(flags.esp_rank_color, Color3.fromRGB(255, 215, 0))
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
                            entry.Streak.Color = resolveColor3(flags.esp_streak_color, Color3.fromRGB(255, 100, 50))
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
                                entry.Deflecting.Color = resolveColor3(flags.esp_deflect_color, Color3.fromRGB(255, 0, 150))
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
                            entry.HeadMarker.Color = resolveColor3(flags.head_marker_color, Color3.fromRGB(255, 50, 50))
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
                                entry.TracerOutline.Color = resolveColor3(flags.esp_tracer_outline_color, Color3.fromRGB(0, 0, 0))
                                entry.TracerOutline.Thickness = (flags.esp_tracer_thickness or 1) + 2
                                entry.TracerOutline.Visible = true
                            else
                                entry.TracerOutline.Visible = false
                            end

                            entry.Tracer.From = origin
                            entry.Tracer.To = targetPos
                            entry.Tracer.Color = resolveColor3(flags.esp_tracer_color, Color3.fromRGB(0, 162, 255))
                            entry.Tracer.Thickness = flags.esp_tracer_thickness or 1
                            entry.Tracer.Visible = true
                        else
                            entry.Tracer.Visible = false
                            entry.TracerOutline.Visible = false
                        end
                    else
                        hideEspEntry(entry)
                    end
                else
                    hideEspEntry(entry)
                end
            else
                hideEspEntry(entry)
            end
        end
    end
end

local function updateChams()
    local isChams = flags.chams_enabled or flags.esp_chams
    if not isChams then
        for _, hl in pairs(meowState.ChamsHighlights) do
            if hl and hl.Parent then hl.Enabled = false end
        end
        return
    end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character.Parent then
            local char = pl.Character
            local hl = meowState.ChamsHighlights[pl]
            if not hl or not hl.Parent then
                pcall(function()
                    if hl then hl:Destroy() end
                    hl = Instance.new("Highlight")
                    hl.Name = "_MeowChams"
                    hl.Parent = char
                    meowState.ChamsHighlights[pl] = hl
                end)
            elseif hl.Parent ~= char then
                pcall(function()
                    hl.Parent = char
                end)
            end

            hl = meowState.ChamsHighlights[pl]
            if hl and hl.Parent == char then
                pcall(function()
                    hl.Adornee = char
                    hl.FillColor = resolveColor3(flags.chams_color, Color3.fromRGB(0, 162, 255))
                    hl.OutlineColor = resolveColor3(flags.chams_outline_color or flags.chams_color, Color3.fromRGB(255, 255, 255))
                    hl.FillTransparency = resolveTransparency(flags.chams_fill_transparency, 0.4)
                    hl.OutlineTransparency = resolveTransparency(flags.chams_outline_transparency, 0)
                    hl.DepthMode = (flags.chams_depth_mode == "Occluded") and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                end)
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(pl)
    pcall(function()
        local entry = meowState.EspBoxes[pl]
        if entry then
            cleanEspEntry(entry)
            meowState.EspBoxes[pl] = nil
        end
        local hl = meowState.ChamsHighlights[pl]
        if hl then
            pcall(function() hl:Destroy() end)
            meowState.ChamsHighlights[pl] = nil
        end
    end)
end)

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

local aimbotMouseDown = false

local function runCombatAimbot()
    if not flags.aimbot_enabled then return end

    local mode = flags.aimbot_mode or "Toggle"

    if mode == "Always" then
        flags.aimbot_active = true
    elseif mode == "Hold" then
        flags.aimbot_active = aimbotMouseDown
    elseif mode == "Toggle" and not flags.aimbot_active then
        return
    end

    if not flags.aimbot_active then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local target = get_target()
    if not (target and target.HitPart and target.HitPart.Parent) then return end

    local current = cam.CFrame
    local goal = CFrame.new(current.Position, target.HitPart.Position)
    local smooth = flags.aimbot_smooth_step or 6
    local dt = 1 / 60
    local speed = 6 / smooth
    local alpha = math.clamp(speed * dt, 0.05, 1)
    Camera.CFrame = current:Lerp(goal, alpha)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        aimbotMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        aimbotMouseDown = false
    end
end)

local rageCycleConnection = nil
local function startRageCycle()
    if rageCycleConnection then return end
    local accumulator = 0
    rageCycleConnection = RunService.Heartbeat:Connect(function(dt)
        if not flags.ragebot_auto_cycle then return end
        accumulator = accumulator + dt
        if accumulator >= (flags.ragebot_cycle_interval or 0.001) then
            accumulator = 0
            flags.ragebot_cycle_state = not flags.ragebot_cycle_state
            flags.ragebot_enabled = flags.ragebot_cycle_state
            flags.ragebot = flags.ragebot_cycle_state
        end
    end)
end

local function stopRageCycle()
    if rageCycleConnection then
        rageCycleConnection:Disconnect()
        rageCycleConnection = nil
    end
    flags.ragebot_enabled = false
    flags.ragebot = false
end

startRageCycle()

flags.aimbot_auto_cycle     = false
flags.aimbot_cycle_state    = false
flags.antiaim_auto_cycle    = false
flags.antiaim_cycle_state   = false

local aimbotCycleConnection = nil
local antiaimCycleConnection = nil

local function startAimbotCycle()
    if aimbotCycleConnection then return end
    local accumulator = 0
    aimbotCycleConnection = RunService.Heartbeat:Connect(function(dt)
        if not flags.aimbot_auto_cycle then return end
        accumulator = accumulator + dt
        if accumulator >= (flags.ragebot_cycle_interval or 0.001) then
            accumulator = 0
            flags.aimbot_cycle_state = not flags.aimbot_cycle_state
            flags.aimbot_enabled = flags.aimbot_cycle_state
            flags.aimbot_active = flags.aimbot_cycle_state
        end
    end)
end

local function startAntiaimCycle()
    if antiaimCycleConnection then return end
    local accumulator = 0
    antiaimCycleConnection = RunService.Heartbeat:Connect(function(dt)
        if not flags.antiaim_auto_cycle then return end
        accumulator = accumulator + dt
        if accumulator >= (flags.ragebot_cycle_interval or 0.001) then
            accumulator = 0
            flags.antiaim_cycle_state = not flags.antiaim_cycle_state
            flags.antiaim_enabled = flags.antiaim_cycle_state
        end
    end)
end

startAimbotCycle()
startAntiaimCycle()

local runRagebotCombat

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

local voidSpamState = {
    InVoid = false,
    LastToggle = 0,
    OriginalCF = nil,
    BurstRemaining = 0,
    LastShotTime = 0
}

local function equipPreferredWeapon(pref)
    pcall(function()
        local lps = PlayerScripts
        local fctrl = lps and lps:FindFirstChild("Controllers") and lps.Controllers:FindFirstChild("FighterController")
        local fighter = fctrl and fctrl:GetFighter(LocalPlayer)
        if not fighter or not fighter.Items then return end
        
        pref = pref or flags.ragebot_preferred_weapon or "primary"
        
        for idx, item in ipairs(fighter.Items) do
            if (pref == "melee" and (item.ItemType == "Melee" or (item.Name and (item.Name:lower():find("knife") or item.Name:lower():find("katana") or item.Name:lower():find("bat"))))) or
               (pref == "secondary" and (item.ItemType == "Secondary" or item.ItemType == "Pistol" or (item.Name and (item.Name:lower():find("pistol") or item.Name:lower():find("daggers"))))) or
               (pref == "primary" and (item.ItemType == "Primary" or idx == 1)) then
                if fighter.EquippedItem ~= item and fighter.EquipItem then
                    fighter:EquipItem(item)
                    break
                end
            end
        end
    end)
end

local function computeV2CF(targetRoot, isMelee)
    if not targetRoot then return nil end
    local targetCF = targetRoot.CFrame
    if isMelee then
        -- Behind rival for instant backstab: 2.5 studs behind facing rival's back
        local behindPos = (targetCF * CFrame.new(0, 0, 2.5)).Position
        return CFrame.new(behindPos, targetCF.Position)
    else
        -- Config offsets: ragebot_tp_x (0), ragebot_tp_y (-7), ragebot_tp_z (-5)
        local ox = tonumber(flags.ragebot_tp_x) or 0
        local oy = tonumber(flags.ragebot_tp_y) or -7
        local oz = tonumber(flags.ragebot_tp_z) or -5
        local tpPos = (targetCF * CFrame.new(ox, oy, oz)).Position
        return CFrame.new(tpPos, targetCF.Position)
    end
end

local function dispatchRageShot(target)
    if not target or not target.HitPart then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local atkMode = flags.ragebot_attack_mode or flags.ragebot_mode or "gun"
    equipPreferredWeapon(flags.ragebot_preferred_weapon or flags.ragebot_weapon)
    
    meowState.CurrentTarget = target

    -- 1. Melee strike
    if atkMode == "melee" or atkMode == "all" or (target.HitPart.Position - root.Position).Magnitude <= (flags.melee_reach or 18) then
        pcall(function()
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    end
    
    -- 2. Tool & Mouse firing
    pcall(function()
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end

        if mouse1click then
            mouse1click()
        elseif mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        else
            local vim = game:GetService("VirtualInputManager")
            if vim then
                local center = Camera.ViewportSize / 2
                vim:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
                task.wait(0.01)
                vim:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
            end
        end
    end)

    -- 3. In Rivals, FighterController & Item Use
    pcall(function()
        local lps = PlayerScripts
        local fctrl = lps and lps:FindFirstChild("Controllers") and lps.Controllers:FindFirstChild("FighterController")
        local fighter = fctrl and fctrl:GetFighter(LocalPlayer)
        local eqItem = fighter and fighter.EquippedItem
        if eqItem then
            if eqItem.Input then
                if atkMode == "melee" or (eqItem.Info and eqItem.Info.Class == "Melee") then
                    eqItem:Input("StartAiming")
                end
                eqItem:Input("StartShooting")
            end
            if eqItem.Use then
                eqItem:Use()
            end
        end
    end)
end

local function runRagebotCombat(dt)
    flags.ragebot_enabled = false
    flags.ragebot = false

    local isRage = flags.ragebot_cycle_state
    if not isRage or not match_in_round() then
        if voidSpamState.InVoid or voidSpamState.OriginalCF then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and voidSpamState.OriginalCF then
                    root.CFrame = voidSpamState.OriginalCF
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                voidSpamState.OriginalCF = nil
                clear_position_desync()
            end)
            voidSpamState.InVoid = false
        end
        return
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local target = meowState.CurrentTarget
    if not (target and target.HitPart and target.Humanoid and target.Humanoid.Health > 0) then
        target = get_target()
    end

    -- If no target alive: restore original position and desync cleanly
    if not (target and target.HitPart and target.Humanoid and target.Humanoid.Health > 0 and target.RootPart) then
        if voidSpamState.InVoid or voidSpamState.OriginalCF then
            pcall(function()
                if voidSpamState.OriginalCF then
                    root.CFrame = voidSpamState.OriginalCF
                    root.AssemblyLinearVelocity = Vector3.zero
                    voidSpamState.OriginalCF = nil
                elseif fakePos.VirtualCF then
                    root.CFrame = fakePos.VirtualCF
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                clear_position_desync()
            end)
            voidSpamState.InVoid = false
        end
        return
    end

    local now = os.clock()
    local isVoidSpam = flags.ragebot_void_spam or flags.voidspam_enabled or flags.voidspam
    local method = flags.ragebot_void_spam_method or flags.voidspam_method or "Aggressive"
    local hideTime = flags.ragebot_void_spam_hide or flags.voidspam_hide_time or 0.25
    local attackTime = flags.ragebot_void_spam_attack or flags.voidspam_shoot_time or 0.05
    local attempts = flags.ragebot_shoot_attempts or flags.voidspam_shoot_attempts or 2
    local depth = (method == "Aggressive" and 85) or (method == "Subterranean" and 15) or 50

    local atkMode = flags.ragebot_attack_mode or flags.ragebot_mode or "gun"
    local isMelee = (atkMode == "melee")
    if not isMelee and (atkMode == "all" or atkMode == "knife") then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("katana") or tool.Name:lower():find("bat")) then
            isMelee = true
        end
    end

    -- Save starting original CF before any teleport or void movement
    if not voidSpamState.OriginalCF then
        voidSpamState.OriginalCF = root.CFrame
    end

    local strikeCF = computeV2CF(target.RootPart or target.HitPart, isMelee) or root.CFrame
    local voidCF = voidSpamState.OriginalCF - Vector3.new(0, depth, 0)

    if isVoidSpam then
        if not voidSpamState.InVoid then
            if voidSpamState.LastToggle == 0 then voidSpamState.LastToggle = now end

            -- Teleport directly to rival during attack burst window
            pcall(function()
                root.CFrame = strikeCF
                root.AssemblyLinearVelocity = Vector3.zero
                set_position_desync("v2", voidSpamState.OriginalCF, strikeCF)
            end)

            for i = 1, attempts do
                dispatchRageShot(target)
            end

            -- Switch to void after attack burst
            if now - voidSpamState.LastToggle >= attackTime then
                voidSpamState.InVoid = true
                voidSpamState.LastToggle = now
                pcall(function()
                    root.CFrame = voidCF
                    root.AssemblyLinearVelocity = Vector3.zero
                    set_position_desync("void", voidSpamState.OriginalCF, voidCF)
                end)
            end
        else
            -- While in void, remain safely underground and wait out hideTime
            pcall(function()
                root.CFrame = voidCF
                root.AssemblyLinearVelocity = Vector3.zero
            end)

            if now - voidSpamState.LastToggle >= hideTime then
                voidSpamState.InVoid = false
                voidSpamState.LastToggle = now
            end
        end
    else
        -- Standard Ragebot with Teleport V2 (snaps directly to rival and shoots)
        pcall(function()
            root.CFrame = strikeCF
            root.AssemblyLinearVelocity = Vector3.zero
            set_position_desync("v2", voidSpamState.OriginalCF, strikeCF)
        end)

        if now - voidSpamState.LastShotTime >= attackTime then
            voidSpamState.LastShotTime = now
            for i = 1, attempts do
                dispatchRageShot(target)
            end
        end
    end
end

pcall(function()
    LocalPlayer.CharacterAdded:Connect(function()
        voidSpamState.InVoid = false
        voidSpamState.OriginalCF = nil
        clear_position_desync()
    end)
end)

local aaRapidFlip = false
local aaSpinAngle = 0
local aaSwayAngle = 0
local aaSwayDir = 1
local aaJitterFlip = false

local function runAntiAim()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local upper = char and char:FindFirstChild("UpperTorso")
    local waist = upper and upper:FindFirstChild("Waist")
    local head = char and char:FindFirstChild("Head")
    local neck = head and head:FindFirstChild("Neck")

    if not flags.antiaim_enabled then
        -- Restore default character posture and AutoRotate when disabled
        pcall(function()
            if hum and not hum.AutoRotate then
                hum.AutoRotate = true
            end
            if waist and waist:IsA("Motor6D") and waist:GetAttribute("AA_Modified") then
                waist.C0 = CFrame.new(0, 0.2, 0)
                waist:SetAttribute("AA_Modified", nil)
            end
            if neck and neck:IsA("Motor6D") and neck:GetAttribute("AA_Modified") then
                neck.C0 = CFrame.new(0, 0.8, 0)
                neck:SetAttribute("AA_Modified", nil)
            end
        end)
        return
    end

    if not root then return end

    local dt = 1/60
    local speedMult = (flags.yaw_speed or 100) / 100

    -- 1. Calculate Pitch (Applied to Waist/Neck Motor6D, NEVER HumanoidRootPart to prevent physics tumbling)
    local pitchVal = 0
    if flags.antiaim_hidehead then
        pitchVal = -89
    else
        local pMode = flags.pitch_type or "Up & Down"
        if pMode == "Down" then pitchVal = -89
        elseif pMode == "Up" then pitchVal = 89
        elseif pMode == "Up & Down" then
            aaJitterFlip = not aaJitterFlip
            pitchVal = aaJitterFlip and 89 or -89
        elseif pMode == "Random" then pitchVal = math.random(-89, 89)
        elseif pMode == "Custom" then pitchVal = flags.antiaim_custom_pitch or 0
        elseif pMode == "Zero" then pitchVal = 0
        end
    end

    -- 2. Calculate Yaw
    local yawVal = 0
    local yMode = flags.yaw_type or "None"

    -- Spinbot only spins when spinbot toggle is true OR preset is Spinbot OR yaw mode is Spin
    if flags.antiaim_spinbot or flags.antiaim_preset == "Spinbot" or yMode == "Spin" then
        local spd = (flags.antiaim_spinbot_speed or 15) * speedMult
        aaSpinAngle = (aaSpinAngle + (spd * 3 * dt)) % 360
        yawVal = aaSpinAngle
    elseif yMode == "None" then
        yawVal = 0
    elseif yMode == "Backwards" then
        yawVal = 180
    elseif yMode == "Left" then
        yawVal = 90
    elseif yMode == "Right" then
        yawVal = -90
    elseif yMode == "Sway" then
        aaSwayAngle = aaSwayAngle + (10 * speedMult * 3 * dt * aaSwayDir)
        if math.abs(aaSwayAngle) > 60 then aaSwayDir = -aaSwayDir end
        yawVal = 180 + aaSwayAngle
    elseif yMode == "Jitter" then
        aaJitterFlip = not aaJitterFlip
        local rng = (flags.jitter_range or 45) * speedMult
        yawVal = aaJitterFlip and (180 + rng) or (180 - rng)
    elseif yMode == "Random" then
        yawVal = math.random(-180, 180)
    elseif yMode == "Custom" then
        yawVal = flags.antiaim_custom_yaw or 0
    end

    -- 3. Rapid Body Jitter
    if flags.antiaim_rapid_body then
        aaRapidFlip = not aaRapidFlip
        yawVal = (yawVal + (aaRapidFlip and 45 or -45)) % 360
    end

    -- 4. Apply Pitch to Neck / Waist Motor6D (Hides head cleanly with 0 physics fling)
    pcall(function()
        if waist and waist:IsA("Motor6D") then
            waist:SetAttribute("AA_Modified", true)
            waist.C0 = CFrame.new(0, 0.2, 0) * CFrame.Angles(math.rad(pitchVal), 0, 0)
        elseif neck and neck:IsA("Motor6D") then
            neck:SetAttribute("AA_Modified", true)
            neck.C0 = CFrame.new(0, 0.8, 0) * CFrame.Angles(math.rad(pitchVal), 0, 0)
        end
    end)

    -- 5. Apply Yaw to RootPart upright (Pitch = 0 on RootPart so character NEVER tips or dies)
    pcall(function()
        local cam = Workspace.CurrentCamera
        local baseLook = (cam and cam.CFrame.LookVector) or root.CFrame.LookVector
        local baseAngle = math.atan2(-baseLook.X, -baseLook.Z)
        
        -- Prevent camera drag when client wont see changes is active
        if flags.antiaim_client_wont_see ~= false then
            if hum and hum.AutoRotate then
                hum.AutoRotate = false
            end
            local origCamCF = cam and cam.CFrame
            -- Upright Y-axis rotation ONLY (no X pitch or Z roll)
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, baseAngle + math.rad(yawVal), 0)
            if cam and origCamCF then
                cam.CFrame = origCamCF
            end
        else
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, baseAngle + math.rad(yawVal), 0)
        end
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

local function getSilentAimTarget()
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local cam = Workspace.CurrentCamera
    if not cam then return nil end

    local camPos = cam.CFrame.Position
    local lookVec = cam.CFrame.LookVector
    local best = nil
    local bestDist = math.huge

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local char = pl.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local offset = head.Position - camPos
                if lookVec:Dot(offset.Unit) > 0.85 then
                    local dist = offset.Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = { Player = pl, HitPart = head }
                    end
                end
            end
        end
    end
    return best
end

getgenv().SilentAimStart = function() flags.silent_aim_enabled = true end
getgenv().SilentAimStop = function() flags.silent_aim_enabled = false end

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

    local fonts = {}
    pcall(function()
        fonts.small = Font.fromEnum(Enum.Font.Gotham)
        fonts.font = Font.fromEnum(Enum.Font.GothamBold)
    end)
    if not (fonts.small and fonts.font) then
        pcall(function()
            fonts.small = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            fonts.font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        end)
    end
    if not (fonts.small and fonts.font) then
        pcall(function()
            fonts.small = Font.fromEnum(Enum.Font.SourceSans)
            fonts.font = Font.fromEnum(Enum.Font.SourceSansBold)
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
    size        = UDim2.fromOffset(840, 650)
})
Library:update_theme("accent", Color3.fromRGB(0, 162, 255))

window:seperator({ name = "game" })

local mainRageTab, mainNotTab, mainVoidspamTab, mainLegitTab, mainAATab = window:tab({
    name = "main",
    icon = "rbxassetid://10723415766",
    tabs = { "rage", "not legit", "voidspam", "Silent", "anti-aim" }
})

do
    local col1 = mainRageTab:column({})
    local secRageMain = col1:section({ name = "ragebot", default = true, icon = "rbxassetid://10723415766" })

    local rageToggle = secRageMain:toggle({
        name      = "enable",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.ragebot_enabled = v end end
    })
    rageToggle:keybind({
        name     = "Keybind",
        mode     = "Toggle",
        default  = Enum.KeyCode.Unknown,
        callback = function(v) if v ~= nil then flags.ragebot_enabled = v end end
    })

    secRageMain:toggle({
        name      = "auto cycle (ms)",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.ragebot_auto_cycle = v end end
    })

    secRageMain:slider({
        name      = "cycle interval",
        min       = 0.001,
        max       = 0.1,
        interval  = 0.001,
        default   = 0.001,
        suffix    = "s",
        seperator = true,
        callback  = function(v) flags.ragebot_cycle_interval = v end
    })

    secRageMain:toggle({
        name      = "void spam",
        default   = false,
        seperator = true,
        callback  = function(v) flags.ragebot_void_spam = v end
    })

    secRageMain:dropdown({
        name      = "void spam method",
        items     = { "Aggressive", "Subterranean", "Adaptive", "Legit" },
        default   = "Aggressive",
        seperator = true,
        callback  = function(v) flags.ragebot_void_spam_method = v end
    })

    secRageMain:slider({
        name      = "hide: 0.25s",
        min       = 0.01,
        max       = 1.00,
        interval  = 0.01,
        default   = 0.25,
        suffix    = "s",
        seperator = true,
        callback  = function(v) flags.ragebot_void_spam_hide = v end
    })

    secRageMain:slider({
        name      = "shoot attempts: 2x",
        min       = 1,
        max       = 10,
        interval  = 1,
        default   = 2,
        suffix    = "x",
        seperator = true,
        callback  = function(v) flags.ragebot_shoot_attempts = v end
    })

    secRageMain:slider({
        name      = "attack: 0.01s",
        min       = 0.01,
        max       = 0.50,
        interval  = 0.01,
        default   = 0.01,
        suffix    = "s",
        seperator = true,
        callback  = function(v) flags.ragebot_void_spam_attack = v end
    })

    secRageMain:dropdown({
        name      = "shooting method",
        items     = { "Remote", "Mouse / CFrame", "Silent Hook" },
        default   = "Remote",
        seperator = true,
        callback  = function(v) flags.ragebot_shooting_method = v end
    })

    secRageMain:dropdown({
        name      = "attack mode",
        items     = { "gun", "melee", "all" },
        default   = "gun",
        seperator = true,
        callback  = function(v) flags.ragebot_attack_mode = v end
    })

    secRageMain:dropdown({
        name      = "preferred weapon",
        items     = { "primary", "secondary", "melee" },
        default   = "primary",
        seperator = true,
        callback  = function(v) flags.ragebot_preferred_weapon = v end
    })

    secRageMain:dropdown({
        name      = "voidspam settings",
        items     = { "hide when shooting", "hide when low hp", "hide on reload", "hide between targets" },
        default   = "hide when shooting",
        seperator = true,
        callback  = function(v) flags.ragebot_voidspam_settings = v end
    })

    secRageMain:dropdown({
        name      = "target method",
        items     = { "Closest", "Lowest HP", "FOV", "Crosshair" },
        default   = "Closest",
        seperator = true,
        callback  = function(v)
            flags.target_priority = (v == "Lowest HP" and "Lowest Health") or (v == "Closest" and "Distance") or v
        end
    })

    local col2 = mainRageTab:column({})
    local secRageTarget = col2:section({ name = "Targeting & Priority", default = true, icon = "rbxassetid://6031075931" })

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

    secRageTarget:toggle({
        name      = "Knife / Melee Rage",
        default   = false,
        seperator = true,
        callback  = function(v) flags.melee_aura = v end
    })

    secRageTarget:slider({
        name      = "Melee Safe Reach",
        min       = 5,
        max       = 25,
        interval  = 1,
        default   = 16,
        suffix    = " studs",
        seperator = true,
        callback  = function(v) flags.melee_reach = v end
    })

    secRageTarget:toggle({
        name      = "Auto Face Back (Silent Backstab)",
        default   = false,
        seperator = true,
        callback  = function(v) flags.auto_face_back = v end
    })
end

do
    local col1 = mainNotTab:column({})
    local secSilent = col1:section({ name = "Silent (Dont work)", default = true, icon = "rbxassetid://6031075931" })

    secSilent:toggle({
        name      = "Enable Silent Aim",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.silent_aim_enabled = v end end
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

    local col2 = mainNotTab:column({})
    local secExploits = col2:section({ name = "Wallbang & CFrame Manipulation", default = true, icon = "rbxassetid://6031075931" })

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

    secExploits:slider({
        name      = "Teleport Offset X",
        min       = -25,
        max       = 25,
        interval  = 1,
        default   = 0,
        seperator = true,
        callback  = function(v) flags.ragebot_tp_x = v end
    })

    secExploits:slider({
        name      = "Teleport Offset Y (Depth)",
        min       = -25,
        max       = 25,
        interval  = 1,
        default   = -7,
        seperator = true,
        callback  = function(v) flags.ragebot_tp_y = v end
    })

    secExploits:slider({
        name      = "Teleport Offset Z",
        min       = -25,
        max       = 25,
        interval  = 1,
        default   = -5,
        seperator = true,
        callback  = function(v) flags.ragebot_tp_z = v end
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
    local secAimbot = col1:section({ name = "Ambot", default = true, icon = "rbxassetid://6031075931" })

    secAimbot:toggle({
        name      = "Enable Aimbot",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.aimbot_enabled = v end end
    })

    local aimbotKeybind = secAimbot:keybind({
        name     = "Aimbot Key",
        mode     = "Toggle",
        default  = Enum.KeyCode.Unknown,
        callback = function(v) if v ~= nil then flags.aimbot_active = v end end
    })

    secAimbot:dropdown({
        name      = "Aimbot Mode",
        items     = { "Toggle", "Hold", "Always" },
        default   = "Toggle",
        seperator = true,
        callback  = function(v) if v ~= nil then flags.aimbot_mode = v end end
    })

    secAimbot:toggle({
        name      = "auto cycle (ms)",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.aimbot_auto_cycle = v end end
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
    local secAAMain = col1:section({ name = "antiaim", default = true, icon = "rbxassetid://10747373176" })

    secAAMain:toggle({
        name      = "client wont see changes",
        default   = false,
        seperator = true,
        callback  = function(v) flags.antiaim_client_wont_see = v end
    })

    local aaToggle = secAAMain:toggle({
        name      = "enabled",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.antiaim_enabled = v end end
    })
    aaToggle:keybind({
        name     = "Keybind",
        mode     = "Toggle",
        default  = Enum.KeyCode.Unknown,
        callback = function(v) if v ~= nil then flags.antiaim_enabled = v end end
    })

    secAAMain:toggle({
        name      = "auto cycle (ms)",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.antiaim_auto_cycle = v end end
    })

    secAAMain:toggle({
        name      = "hide head",
        default   = false,
        seperator = true,
        callback  = function(v) if v ~= nil then flags.antiaim_hidehead = v end end
    })

    secAAMain:toggle({
        name      = "rapid body",
        default   = false,
        seperator = true,
        callback  = function(v) flags.antiaim_rapid_body = v end
    })

    secAAMain:dropdown({
        name      = "pitch",
        items     = { "Up & Down", "Down", "Up", "Random", "Custom", "Zero" },
        default   = "Up & Down",
        seperator = true,
        callback  = function(v) flags.pitch_type = v end
    })

    secAAMain:dropdown({
        name      = "preset",
        items     = { "None", "Spinbot", "Jitter Fast", "Jitter Slow", "Sway HvH", "Backward", "Side Angles (Left)", "Side Angles (Right)", "Random HvH", "Block Anti-Aim" },
        default   = "None",
        seperator = true,
        callback  = function(v)
            flags.antiaim_preset = v
            if v == "None" then
                flags.antiaim_spinbot = false
                flags.yaw_type = "None"
            elseif v == "Spinbot" then
                flags.antiaim_spinbot = true
                flags.yaw_type = "Spin"
            elseif v == "Jitter Fast" then
                flags.yaw_type = "Jitter"
                flags.pitch_type = "Up & Down"
            elseif v == "Jitter Slow" then
                flags.yaw_type = "Jitter"
                flags.pitch_type = "Down"
            elseif v == "Backward" then
                flags.yaw_type = "Backwards"
                flags.pitch_type = "Down"
            elseif v == "Random HvH" then
                flags.yaw_type = "Random"
                flags.pitch_type = "Random"
            end
        end
    })

    secAAMain:dropdown({
        name      = "yaw",
        items     = { "None", "Random", "Spin", "Backwards", "Left", "Right", "Jitter", "Sway", "Custom" },
        default   = "None",
        seperator = true,
        callback  = function(v) flags.yaw_type = v end
    })

    secAAMain:slider({
        name      = "yaw speed: 100%",
        min       = 1,
        max       = 200,
        interval  = 1,
        default   = 100,
        suffix    = "%",
        seperator = true,
        callback  = function(v) flags.yaw_speed = v end
    })

    secAAMain:slider({
        name      = "custom yaw...",
        min       = -180,
        max       = 180,
        interval  = 1,
        default   = 0,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) flags.antiaim_custom_yaw = v end
    })

    secAAMain:slider({
        name      = "custom pitch...",
        min       = -89,
        max       = 89,
        interval  = 1,
        default   = 0,
        suffix    = " deg",
        seperator = true,
        callback  = function(v) flags.antiaim_custom_pitch = v end
    })

    secAAMain:toggle({
        name      = "spinbot",
        default   = false,
        seperator = true,
        callback  = function(v) flags.antiaim_spinbot = v end
    })

    secAAMain:slider({
        name      = "spinbot speed: 100",
        min       = 1,
        max       = 100,
        interval  = 1,
        default   = 15,
        seperator = true,
        callback  = function(v) flags.antiaim_spinbot_speed = v end
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

local visVMTab, visFXTab, visHUDTab, visWorldTab, visNotWorldTab = window:tab({
    name = "visuals",
    icon = "rbxassetid://6031075931",
    tabs = { "viewmodel", "effects", "hud", "world", "World Removals & Camera" }
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
        default   = false,
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
        name    = 'override item scaling',
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
end

do
    local col1 = visNotWorldTab:column({})
    local secRemovals = col1:section({ name = "World Removals & Camera", default = true, icon = "rbxassetid://6031075931" })

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
        callback  = function(v)
            flags.staff_detector = v
            flags.mod_detector = v
            staffDetectorState.Enabled = v
        end
    })

    secStaff:dropdown({
        name      = "Staff Detection Action",
        items     = { "Notify", "Server Hop", "Disconnect" },
        default   = "Notify",
        seperator = true,
        callback  = function(v)
            flags.staff_action = v
            staffDetectorState.AutoHop = (v == "Server Hop")
            staffDetectorState.AutoKick = (v == "Disconnect")
        end
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

local charFPTab, charAnglesTab, charDesyncTab = window:tab({
    name = "character",
    icon = "rbxassetid://10747373176",
    tabs = { "Fake Position", "Angles", "Desync" }
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

    secFP:toggle({
        name      = "block fake position",
        default   = true,
        seperator = true,
        callback  = function(v) flags.block_fake_position = v end
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
        name      = "Freeze Desync Animation Pose (Flat Hitbox)",
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
    Camera = Workspace.CurrentCamera or Camera
end)

local renderConn = RunService.RenderStepped:Connect(function(dt)
    if meowState.Destroyed then return end
    Camera = Workspace.CurrentCamera or Camera
    pcall(runAntiAim)
    pcall(updateEsp)
    pcall(updateChams)
    pcall(updateCrosshair)
    pcall(updateFovCircles)
    pcall(updateBulletTracers)
    pcall(function() updateCameraAndWorld(dt) end)
    pcall(function() updateWorldLighting(dt) end)
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
    info     = "Halloween Edition loaded without Music Player & Blue UI!",
    lifetime = 4
})

print("[Sleepy.gg 🎃] Ultimate script loaded without Music Player & Electric Blue UI!")

task.defer(function()
    task.wait(1)
    flags.silent_aim_enabled = false
    flags.aimbot_enabled = false
    flags.aimbot_active = false
    flags.aimbot_cycle_state = false
    flags.ragebot_enabled = false
    flags.ragebot = false
    flags.ragebot_cycle_state = false
    flags.antiaim_enabled = false
    flags.antiaim_cycle_state = false
    flags.block_rage = false
    flags.block_fake_position = true
end)


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
    -- Disabled: Unlock All completely removed
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

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 1)
if not lps then return end

local ctrls = lps:FindFirstChild("Controllers")
local rmods = reps:FindFirstChild("Modules")

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
		for name, cosmetic in pairs(finv) do
			proxy[name] = cosmetic
		end
		return proxy
	end
	if key == "WeaponInventory" then
		return data
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
		-- saferep("WeaponInventory")
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
	if not wname then return nil end
	local data = ogetwep and ogetwep(self, wname)
	if not data then return nil end
	local merged = table.clone(data)
	merged.Name = wname
	local weq = equip and equip[wname]
	if weq then for ct, cd in pairs(weq) do merged[ct] = cd end end
	return merged
end

local function saferep(key)
	pcall(function()
		if not cdata and dctrl.CurrentData then cdata = dctrl.CurrentData end
		if cdata then cdata:Replicate(key) end
	end)
end

local fctrl, wrapController
pcall(function() if ctrls and ctrls:FindFirstChild("FighterController") then fctrl = require(ctrls.FighterController) end end)
pcall(function() if ctrls and ctrls:FindFirstChild("WrapController") then wrapController = require(ctrls.WrapController) end end)
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
	if lps and lps:FindFirstChild("Assets") then
		charmAssets = lps.Assets:FindFirstChild("Charms")
		local misc = lps.Assets:FindFirstChild("Misc")
		wrapPreviewAsset = misc and misc:FindFirstChild("Wrap")
		wrapTextureAssets = lps.Assets:FindFirstChild("WrapTextures")
	end
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
	local version = 3
	if state.Version == version and state.Connection then return end
	if state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	state.Version = version
	if not isRpgRazeEquipped() then return end
	state.Connection = workspace.DescendantAdded:Connect(function(inst)
		if inst:IsA("MeshPart") or inst:IsA("SpecialMesh") or inst:IsA("Model") then
			task.defer(tryApplyRpgProjectileSkin, inst)
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
	local components = lps and lps.Modules and lps.Modules:FindFirstChild("GameComponents")
	if not components then return end

	pcall(function()
		local jpMod = components:FindFirstChild("JumpPads")
		if not jpMod then return end
		local jumpPads = require(jpMod)
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
		local stMod = components:FindFirstChild("SubspaceTripmines")
		if not stMod then return end
		local tripmines = require(stMod)
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
		local fhMod = components:FindFirstChild("FireHitboxes")
		if not fhMod then return end
		local fireHitboxes = require(fhMod)
		local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
		local fireAssets = misc and misc:FindFirstChild("FireHitboxes")
		if not fireAssets then return end
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
	local actualSelf = self
	local actualWData = wdata
	local actualHires = hires
	if type(self) == "table" and (self.Name or self.Class or self.Type) and not self.ViewModels then
		actualSelf = ilib
		actualWData = self
		actualHires = wdata
	end

	if not actualWData then
		if ogvi then
			local ok, res = pcall(ogvi, actualSelf, actualWData, actualHires)
			if ok and res then return res end
		end
		return ""
	end

	local wname = type(actualWData) == "table" and actualWData.Name or (type(actualWData) == "string" and actualWData or nil)
	if not wname then
		if ogvi then
			local ok, res = pcall(ogvi, actualSelf, actualWData, actualHires)
			if ok and res then return res end
		end
		return ""
	end

	local weq = equip and equip[wname]
	if weq and weq.Skin and actualSelf and actualSelf.ViewModels then
		local skinViewModelName = weq.Skin.ViewModelName or weq.Skin.Name
		local skinSourceName = weq.Skin.SourceViewModelName or skinViewModelName
		local sinfo = actualSelf.ViewModels[skinViewModelName] or actualSelf.ViewModels[skinSourceName]
		if sinfo then return sinfo[actualHires and "ImageHighResolution" or "Image"] or sinfo.Image end
		if weq.Skin[actualHires and "ImageHighResolution" or "Image"] or weq.Skin.Image then
			return weq.Skin[actualHires and "ImageHighResolution" or "Image"] or weq.Skin.Image
		end
	end

	if ogvi then
		local ok, res = pcall(ogvi, actualSelf, actualWData, actualHires)
		if ok and res and res ~= "" then return res end
	end

	if actualSelf and actualSelf.Items and actualSelf.Items[wname] then
		local itm = actualSelf.Items[wname]
		return itm[actualHires and "ImageHighResolution" or "Image"] or itm.Image or ""
	end
	return ""
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
		-- saferep("WeaponInventory")

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
		-- saferep("WeaponInventory")
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
			pcall(function() sg.Parent = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 0.5) end)
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
		img.Image = type(entry.Image) == "string" and entry.Image or ""
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
		-- saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
	end)

	reset.MouseButton1Click:Connect(function()
		table.clear(equip)
		table.clear(fcache)
		rebuildinv()
		-- saferep("WeaponInventory")
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
		-- saferep("WeaponInventory")
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
