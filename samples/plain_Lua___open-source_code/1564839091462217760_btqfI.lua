--[[
    
    ZUUAHUB  Private Gym  (keyless, ofx)
    
    Green math extracted from the target's decompiled client:

      green threshold = 100 - greenFactor * ShotContestConfig.BaseGreenWindow
      green check     = Timing >= threshold
                                 (Timing = MeterController.Release()/GetValue())

    The shared required-module table is wrapped in place so reads return
    100. Instant greens.
]]

-- 
--   1. SERVICES & CLIENT CONTEXT                                     
-- 
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- 
--   2. TARGET SIGNATURES  (decompiled remote & config bindings)      
-- 
local Events = ReplicatedStorage:WaitForChild("Events")
local StealEvent      = Events:WaitForChild("StealEvent")
local BlockEvent      = Events:WaitForChild("BlockEvent")
local BlockAttempt    = Events:WaitForChild("BlockAttemptEvent")
local ReboundAttempt  = Events:WaitForChild("ReboundAttemptEvent")
local ShotContestConfig = require(ReplicatedStorage.Shared.ShotContestConfig)
local Met = require(ReplicatedStorage.Client.Handlers.GamePlay.Player.MeterController)
local OnBallMovement = require(ReplicatedStorage.Client.Handlers.GamePlay.Player.OnBallMovement)
assert(Met, "MeterController require failed")
assert(OnBallMovement and OnBallMovement.IsDribbling, "OnBallMovement.IsDribbling missing")

-- 
--   3. FEATURE STATE TABLE                                           
-- 
local S = {
    AutoGreen       = true,
    ShotGlide       = false,
    DribbleGlide    = false,
    DribbleGlidePow = 22, -- glide velocity magnitude while dribbling
    AutoGuard       = false,
    AutoContest     = false,
    AutoBlock       = false,
    AutoBlockAll    = false,
    AutoSteal       = false,
    AntiSteal       = false,
    AutoRebound     = false,
    BallMag         = false,
    UnlimStam       = false,
    AutoShot        = false,
    AntiKnockback   = false,
    NoFallDamage    = false,
    AutoStrafe      = false,
    AutoDunk        = false,
    FastPass        = false,
    AutoRelease     = false,
    ShotPower       = 100,
    AutoBank        = false,
    AimAssist       = false,
    WalkSpeed       = 16,
    ClutchFreeze    = false,
    AntiAnkle       = false,
    AntiBump        = false,
    JumpPower       = 50,
    InfJump         = false,
    ClickTP         = false,
    Noclip          = false,
    FpsBoost        = false,
    Fullbright      = false,
    AntiAFK         = false,
    BallESP         = false,
    Fov             = 70,
    NetHud          = false,
    GuardRange      = 25,
    StealRange      = 4.5,
    BlockRange      = 6,
    PlayerESP       = false,
    AutoSprint      = false,
    SprintMult      = 1.75,
    Gravity         = 196.2,
    HumanFire       = true,
    MagnetRadius    = 40,
    Fly             = false,
    FlySpeed        = 45,
    GreenWindow     = 55,
    RimESP          = false,
    BallScale       = 1.0,
    Ghost           = false,
    GhostAlpha      = 0.35,
    VoidSave        = false,
    BunnyHop        = false,
    AntiRagdoll     = false,
    BallTracer      = false,
    CameraZoom      = 70,
    ShotGlidePow    = 16,
    RimAim          = false,
    MeterHud        = false,
}
S.WalkSpeedDefault = 16

-- 
--   4. GREEN HOOK  (MeterController method wrapping)                 
--   Shooting.lua reads MeterController.Release()/GetValue() for the  
--   Timing sent to the server. Wrapping the shared module table so   
--   those reads come back 100. Server math: Timing >= 100 - gf * w.  
-- 
local hooksOn = true
-- originals kept for read-only consumers (meter HUD)  read path only, never
-- used to bypass the wrapped methods
local rawGetValue = Met.GetValue
local rawGWF = Met.GetGreenWindowFactor
if Met.Release then
    local oldRelease = Met.Release
    Met.Release = function(...)
        if hooksOn and S.AutoGreen then
            if Met.StopMoving then pcall(Met.StopMoving) end
            return 100
        end
        return oldRelease(...)
    end
end
if Met.GetValue then
    local oldGetValue = Met.GetValue
    Met.GetValue = function(...)
        if hooksOn and S.AutoGreen then
            return 100
        end
        return oldGetValue(...)
    end
end
if Met.GetGreenWindowFactor then
    local oldGWF = Met.GetGreenWindowFactor
    Met.GetGreenWindowFactor = function(...)
        if hooksOn and S.AutoGreen then
            return 1
        end
        return oldGWF(...)
    end
end

-- widen the client-side green band visual  and respect the toggle:
-- flipping Auto Green OFF restores the stock 15 so your shots play fair-line;
-- flipping it ON widens back to 55.
_shotGreenStock = ShotContestConfig.BaseGreenWindow
S.AutoGreenCallback = function(on)
    if ShotContestConfig then
        pcall(function()
            ShotContestConfig.BaseGreenWindow = on and S.GreenWindow or _shotGreenStock
        end)
    end
end
if S.AutoGreen then S.AutoGreenCallback(true) end -- honor the default-on state

-- adjustable green window  live rewrites the same config field the
-- Auto Green hook uses; gated on AutoGreen so stock play stays stock
S.GreenWindowCallback = function(v)
    if S.AutoGreen and ShotContestConfig then
        pcall(function() ShotContestConfig.BaseGreenWindow = v end)
    end
    S.GreenWindow = v
end

-- rim ESP  Highlight every workspace part with "rim" in the name
local rimHighlights = {}
local function clearRimESP()
    for inst, hl in pairs(rimHighlights) do
        pcall(function() if hl then hl:Destroy() end end)
        rimHighlights[inst] = nil
    end
end

-- ball scale  cache original sizes, resize by factor, restore on kill
local ballSizeCache = {}
local function applyBallScale()
    if S.BallScale == 1.0 then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower() == "ball" then
            if not ballSizeCache[obj] then ballSizeCache[obj] = obj.Size end
            pcall(function() obj.Size = ballSizeCache[obj] * S.BallScale end)
        end
    end
end
local function restoreBallScale()
    for inst, size in pairs(ballSizeCache) do
        if inst and inst.Parent then
            pcall(function() inst.Size = size end)
        end
        ballSizeCache[inst] = nil
    end
end


-- 
--   4b. DETECTION-SURFACE AVOIDANCE                                  
--   The game's client ships an anti-tamper watchdog  decompiled      
--   trip points (exact strings from the obfuscated [Client] module): 
--                                                                    
--     Anti.Detected("kick", "Proxy methamethod 0x215F") (--newproxy  
--     traps on __index)                                              
--                                                                    
--     It also caches globals at load:                                
--         local v24 = newproxy                                       
--         local v23 = Color3                                         
--         local u43 = tostring                                       
--     then swaps references back in at runtime  env tamper detect.  
--                                                                    
--   The suite avoids every one of these surfaces by design:          
--      no getrawmetatable / setrawmetatable calls                   
--      no setmetatable on game-instances or required-module tables  
--      no newproxy-proxied wrappers                                 
--      no hacked hook-function/globals  newproxy/tamper from       
--       hookfunction wrappers is the exact pattern 0x215F detects    
--      we do pure function-table replacement on Met methods,        
--       called as standard module-function calls by Shooting.lua     
--      Config writes (ShotContestConfig.BaseGreenWindow) are plain  
--       table field writes on a replicated table  read but not      
--       hooked-watch                                                
--      OnBallMovement.IsDribbling() is a straight module call,      
--       no closure capture                                          
--      RenderStepped/Heartbeat velocity writes don't hit            
--       FireServer so no remote-arg tamper detection is triggered    
--      we subscribe to ini  no pending CPU checks, no idle spikes  
--                                                                    
--   Known server-side constraints we are NOT touching (honest):      
--      server-authoritative Kick remote fires pre-frame from server 
--      client SpeedOfStamina/SpeedOfBuild values map from server    
--      LandingReport/OnPhysics register server-side, not via        
--       this script                                                 
-- 

-- 
--   5. RENDER LOOP  (stamina / contest / walkspeed / ball mag)       
-- 
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    -- unlimited stamina  game reads GameplayStamina off LocalPlayer attrs
    if S.UnlimStam and LocalPlayer:GetAttribute("GameplayStamina") then
        LocalPlayer:SetAttribute("GameplayStamina", 100)
    end
    -- anti-contest  zero the contest score the meter math reads
    if S.AutoContest and char and char:GetAttribute("ContestScore") then
        char:SetAttribute("ContestScore", 0)
    end

    if hum and S.WalkSpeed ~= hum.WalkSpeed and not S.AutoSprint then
        hum.WalkSpeed = S.WalkSpeed
    end
    if S.JumpPower and hum.UseJumpPower then
        hum.JumpPower = S.JumpPower
    end

    -- anti ankle / anti bump  the game's own handlers slam WalkSpeed to 0,
    -- flip AutoRotate off, and stamp AnkleLocked / BumpSlowed attrs.
    -- decompile refs: AnkleBreakerClient L108, GuardingClient L459,
    --                 OffBallMovement L773-786, BumpClient BumpSlowed gate
    if (S.AntiAnkle or S.AntiBump) and char and hum then
        local locked = char:GetAttribute("AnkleLocked")
        local bumped = char:GetAttribute("BumpSlowed")
        if S.AntiAnkle and locked then
            char:SetAttribute("AnkleLocked", false)
            hum.AutoRotate = true
            hum.WalkSpeed = S.WalkSpeed
        end
        if S.AntiBump and bumped then
            char:SetAttribute("BumpSlowed", false)
            hum.WalkSpeed = S.WalkSpeed
        end
    end

    -- anti knockback
    if S.AntiKnockback and root then
        local v = root.AssemblyLinearVelocity
        if v.Magnitude > 80 then
            root.AssemblyLinearVelocity = Vector3.new(v.X, v.Y, v.Z)
            root.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
        end
    end

    -- no fall damage
    if S.NoFallDamage and hum then
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum:SetAttribute("PrevHealth", hum.Health)
        elseif hum:GetState() == Enum.HumanoidStateType.Running and hum.FloorMaterial ~= Enum.Material.Air then
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end

    -- auto strafe
    if S.AutoStrafe and hum and root then
        if hum.MoveDirection.Magnitude > 0.1 then
            root.CFrame = root.CFrame * CFrame.new(math.sin(tick()*3)*0.3,0,0)
        end
    end

    -- shot / dribble glide
    -- dribble state truth: OnBallMovement.IsDribbling() only, no fallback 
    -- this fires strictly while the player is mid-dribble, never while
    -- holding/shooting/passing. HasBall fallback removed so gate stays pure.
    if root and hum then
        local isShooting  = char and char:GetAttribute("IsShooting")
        local isDribbling = OnBallMovement.IsDribbling()
        if S.DribbleGlide and isDribbling and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * S.DribbleGlidePow,
                root.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Z * S.DribbleGlidePow)
        elseif S.ShotGlide and isShooting and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * S.ShotGlidePow,
                root.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Z * S.ShotGlidePow)
        end
    end

    -- ball mag
    if S.BallMag and root then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "ball"
               and (obj.Position - root.Position).Magnitude < S.MagnetRadius then
                obj.CFrame = root.CFrame * CFrame.new(0, 0, -1.5)
            end
        end
    end
end)

-- 
--   5b. DRIBBLE GLIDE  (BodyVelocity driver, mirrors the game's own  
--   gather-glide mechanic at OnBallMovement L3762 / L1542:           
--   the game glides by parenting a BodyVelocity on HRP with          
--   MaxForce = mass * 240 horizontal and P = 9e9, and gliding the    
--   ballhandler at carried velocity  so we drive the same object    
--   during dribble moves rather than fighting it with raw ALV)       
--                                                                    
--   Bind at RenderPriority.Last so our write lands AFTER the game's  
--   OnBallMovement RenderStepped loop  wins the frame before        
--   Stepped physics reads velocity.                                  
-- 
local GLIDE_BIND_NAME = "SynthSuite_Glide"
local glideBV = nil

local function killGlideBV()
    if glideBV then
        glideBV:Destroy()
        glideBV = nil
    end
end

RunService:BindToRenderStep(GLIDE_BIND_NAME, Enum.RenderPriority.Last.Value, function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        killGlideBV()
        return
    end

    if S.DribbleGlide and OnBallMovement.IsDribbling() then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local moveDir = hum and hum.MoveDirection
        if moveDir and moveDir.Magnitude > 0 then
            -- re-use the game's own BodyVelocity if they spawned one (gather glide)
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            if not bv then
                -- spawn ours, matching the game's own glide stop formation
                bv = Instance.new("BodyVelocity")
                bv.Name = "SynthGlideBV"
                bv.MaxForce = Vector3.new(1 / 0, 0, 1 / 0) -- horizontal lock, gravity untouched
                bv.P = 9000000000 -- same P the game's glide uses (L3772)
                bv.Velocity = Vector3.zero
                bv.Parent = root
                glideBV = bv
            else
                glideBV = bv -- adopt theirs for this frame
            end
            if bv then
                bv.Velocity = Vector3.new(moveDir.X * S.DribbleGlidePow, 0, moveDir.Z * S.DribbleGlidePow)
                -- hold the horizontal lock while moving  vertical untouched
                bv.MaxForce = Vector3.new(1 / 0, 0, 1 / 0)
                -- keep ALV y so jumps / hops still feel native
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * S.DribbleGlidePow, root.AssemblyLinearVelocity.Y, moveDir.Z * S.DribbleGlidePow)
                return
            end
        end
    end

    -- not dribbling or not enabled  release the body so physics owns us again
    killGlideBV()
end)

-- 
--   5c. CLUTCH FREEZE + INFINITE JUMP + CLICK TP                     
-- 
-- clutch freeze uses the game's own MeterController API (L741: SetClutchFrozen)
task.spawn(function()
    while true do
        task.wait(0.25)
        if Met.SetClutchFrozen then
            pcall(Met.SetClutchFrozen, S.ClutchFreeze)
        end
    end
end)

-- infinite jump  JumpRequest fires every frame the key is held;
-- re-jump any time you're not standing on the ground
local unloader = {} -- connections owned by the suite, torn down on unload
unloader.JumpRequest = UIS.JumpRequest:Connect(function()
    if not S.InfJump then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Landed then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- click teleport  F while toggle is on: ray from camera through cursor
unloader.InputBegan = UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode ~= Enum.KeyCode.F or not S.ClickTP then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not workspace.CurrentCamera then return end
    local mouse = LocalPlayer:GetMouse()
    local ray = workspace.CurrentCamera:ViewportPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { char }
    params.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(ray.Origin, ray.Direction * 5000, params)
    if hit then
        root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
    end
end)

-- 
--   5d. EXTRAS  (noclip / fps boost / fullbright / anti-afk /        
--               ball ESP / FOV / net HUD)                            
-- 

-- anti-afk  plug the game's own idle kick at the source
local Vu = game:GetService("VirtualUser")
unloader.AntiAFK = LocalPlayer.Idled:Connect(function()
    if S.AntiAFK then
        pcall(function()
            Vu:CaptureController()
            Vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- ball ESP  Highlight the ball through geometry, one instance reused
local ballHighlight = nil
local function killBallESP()
    if ballHighlight then
        ballHighlight:Destroy()
        ballHighlight = nil
    end
end

-- player ESP  Highlight + name-tag cache, torn down on toggle/kill
local espMarks = {}
local flyGyro, flyVel = nil, nil

-- virtual sprint key  the game's movement handler reads LeftShift for its own
-- sprint state; holding it with VirtualInputManager makes the game sprint for
-- real instead of us racing its per-frame WalkSpeed re-stamp
local VIM = game:GetService("VirtualInputManager")
local sprintKeyHeld = false
local function setSprintKey(on)
    if sprintKeyHeld == on then return end
    sprintKeyHeld = on
    pcall(function()
        VIM:SendKeyEvent(on, Enum.KeyCode.LeftShift, false, game)
    end)
end
local function clearESP()
    for plr, data in pairs(espMarks) do
        pcall(function()
            if data.hl then data.hl:Destroy() end
            if data.bb then data.bb:Destroy() end
        end)
        espMarks[plr] = nil
    end
end
Players.PlayerAdded:Connect(function(plr)
    if not S.PlayerESP then return end
    plr.CharacterAdded:Connect(function()
        espMarks[plr] = nil -- respawn re-marks on next frame
    end)
end)

-- noclip  collision off without touching Humanoid (no physics conflicts
-- with the game's BodyVelocity glide mechanics)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if S.Noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- fullbright + fps boost  Lighting writes are plain instance props
local LightingCache = nil
local function applyLighting()
    local Lighting = game:GetService("Lighting")
    if not LightingCache then
        LightingCache = {
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd,
        }
    end
    Lighting.Brightness = 2.5
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
end
local function restoreLighting()
    local Lighting = game:GetService("Lighting")
    if LightingCache then
        Lighting.Brightness = LightingCache.Brightness
        Lighting.Ambient = LightingCache.Ambient
        Lighting.OutdoorAmbient = LightingCache.OutdoorAmbient
        Lighting.GlobalShadows = LightingCache.GlobalShadows
        Lighting.FogEnd = LightingCache.FogEnd
    end
end
local function applyFpsBoost()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
    local settings = UserSettings()
    pcall(function()
        if settings.PerfModernService then
            settings.PerfModernService.LightQuality = 1
        end
    end)
end

-- net HUD  small label with networking + fps up in the corner
local netHud = nil
local function ensureNetHud()
    if netHud then return end
    local sg = game:GetService("CoreGui"):FindFirstChild("CoreHudOverlay")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "CoreHudOverlay"
        sg.ResetOnSpawn = false
        sg.Parent = game:GetService("CoreGui")
    end
    netHud = sg:FindFirstChild("NetHudText")
    if not netHud then
        netHud = Instance.new("TextLabel")
        netHud.Name = "NetHudText"
        netHud.AnchorPoint = Vector2.new(1, 0)
        netHud.Position = UDim2.new(1, -10, 0, 10)
        netHud.Size = UDim2.new(0, 180, 0, 22)
        netHud.BackgroundTransparency = 0.4
        netHud.BackgroundColor3 = Color3.new(0, 0, 0)
        netHud.TextColor3 = Color3.new(0, 1, 0.4)
        netHud.Font = Enum.Font.Code
        netHud.TextSize = 14
        netHud.Text = "ms --  fps --"
        netHud.Parent = sg
    end
end
local function killNetHud()
    if netHud then
        netHud:Destroy()
        netHud = nil
    end
end

-- shot meter HUD  read-only timing + green threshold readout
local meterHud = nil
local function ensureMeterHud()
    if meterHud then return end
    local sg = game:GetService("CoreGui"):FindFirstChild("CoreMeterOverlay")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "CoreMeterOverlay"
        sg.ResetOnSpawn = false
        sg.Parent = game:GetService("CoreGui")
    end
    meterHud = sg:FindFirstChild("MeterReadout")
    if not meterHud then
        meterHud = Instance.new("TextLabel")
        meterHud.Name = "MeterReadout"
        meterHud.AnchorPoint = Vector2.new(0.5, 1)
        meterHud.Position = UDim2.new(0.5, 0, 1, -90)
        meterHud.Size = UDim2.new(0, 260, 0, 24)
        meterHud.BackgroundTransparency = 0.45
        meterHud.BackgroundColor3 = Color3.new(0, 0, 0)
        meterHud.Font = Enum.Font.Code
        meterHud.TextSize = 14
        meterHud.TextColor3 = Color3.new(1, 1, 1)
        meterHud.Text = "timing --  green --"
        meterHud.Parent = sg
    end
end
local function killMeterHud()
    if meterHud then
        meterHud:Destroy()
        meterHud = nil
    end
end

-- drivers for the toggles  plain property writes, no metamethod surface
RunService.RenderStepped:Connect(function()
    -- ball ESP
    if S.BallESP then
        if not ballHighlight then
            ballHighlight = Instance.new("Highlight")
            ballHighlight.Name = "VfxBallGlow"
            ballHighlight.FillColor = Color3.new(1, 0.6, 0)
            ballHighlight.OutlineColor = Color3.new(1, 1, 1)
            ballHighlight.FillTransparency = 0.6
            ballHighlight.Parent = workspace
        end
        local ball = nil
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "ball" then
                ball = obj
                break
            end
        end
        ballHighlight.Adornee = ball
    elseif ballHighlight then
        killBallESP()
    end

    -- net HUD refresh
    local cam = workspace.CurrentCamera
    if S.Fov and cam and cam.FieldOfView ~= S.Fov then
        cam.FieldOfView = S.Fov
    end

    -- rim ESP  mark every rim part found this frame, unmark gone ones
    if S.RimESP then
        local seen = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("rim") then
                seen[obj] = true
                if not rimHighlights[obj] then
                    pcall(function()
                        local hl = Instance.new("Highlight")
                        hl.Name = "VfxRimGlow"
                        hl.FillColor = Color3.new(0.2, 0.9, 1)
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.FillTransparency = 0.65
                        hl.DepthMode = Enum.HighlightDepthMode.Occluded
                        hl.Adornee = obj
                        hl.Parent = obj
                        rimHighlights[obj] = hl
                    end)
                end
            end
        end
        for inst in pairs(rimHighlights) do
            if not seen[inst] or not inst.Parent then
                pcall(function() rimHighlights[inst]:Destroy() end)
                rimHighlights[inst] = nil
            end
        end
    elseif next(rimHighlights) then
        clearRimESP()
    end

    -- ball scale  re-apply cheaply (descendants scan doubles as respawn catch)
    if S.BallScale ~= 1.0 then
        applyBallScale()
    elseif next(ballSizeCache) then
        restoreBallScale()
    end

    -- shot meter HUD  raw timing value + computed green threshold
    if S.MeterHud then
        ensureMeterHud()
        if meterHud then
            local val, factor = 0, 1
            if rawGetValue then pcall(function() val = rawGetValue() end) end
            if rawGWF then pcall(function() factor = rawGWF() end) end
            local win = (ShotContestConfig and ShotContestConfig.BaseGreenWindow) or 15
            local threshold = 100 - factor * win
            meterHud.Text = ("timing %.1f  green %.0f+  window %d"):format(val, threshold, math.floor(win + 0.5))
            meterHud.TextColor3 = (val >= threshold) and Color3.new(0.3, 1, 0.4) or Color3.new(1, 1, 1)
        end
    elseif meterHud then
        killMeterHud()
    end

    -- rim aim  camera lock onto the nearest rim while the toggle's on
    if S.RimAim then
        local charA = LocalPlayer.Character
        local rootA = charA and charA:FindFirstChild("HumanoidRootPart")
        local camA = workspace.CurrentCamera
        if rootA and camA then
            local nearest, nd = nil, math.huge
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("rim") then
                    local d = (obj.Position - rootA.Position).Magnitude
                    if d < nd then nearest, nd = obj, d end
                end
            end
            if nearest then
                camA.CFrame = CFrame.lookAt(camA.CFrame.Position, nearest.Position)
            end
        end
    end

    -- auto sprint  game's own sprint state is keyed off LeftShift, so we hold
    -- the key virtually instead of only writing WalkSpeed (the game's movement
    -- controller re-stamps WalkSpeed every frame from its sprint state, which
    -- is why the raw write looked dead). Virtual key = real sprint, real speed.
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if S.AutoSprint and hum then
        setSprintKey(true)
        local base = S.WalkSpeed or S.WalkSpeedDefault
        local target = base * S.SprintMult
        if hum.WalkSpeed ~= target then hum.WalkSpeed = target end
    else
        setSprintKey(false)
    end

    -- fly  camera-relative WASD + Space/C vertical, BodyVelocity drive
    -- (same pure instance-write path as the dribble glide, watchdog-safe)
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if S.Fly and root and hum then
        if not (flyGyro and flyGyro.Parent) then
            flyGyro = Instance.new("BodyGyro")
            flyGyro.MaxTorque = Vector3.new(1 / 0, 1 / 0, 1 / 0)
            flyGyro.P = 1e5
            flyGyro.D = 500
            flyGyro.Parent = root
        end
        if not (flyVel and flyVel.Parent) then
            flyVel = Instance.new("BodyVelocity")
            flyVel.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
            flyVel.P = 9e9
            flyVel.Parent = root
        end
        local cam = workspace.CurrentCamera
        local move = hum.MoveDirection
        local dir = Vector3.zero
        if move.Magnitude > 0 then dir = dir + move end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        local vel = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
        flyVel.Velocity = vel
        if cam then flyGyro.CFrame = CFrame.new(Vector3.zero, cam.CFrame.LookVector) end
        -- keep gravity from dragging the flyer down
        hum.PlatformStand = false
    elseif (flyGyro or flyVel) then
        pcall(function() if flyGyro then flyGyro:Destroy() end if flyVel then flyVel:Destroy() end end)
        flyGyro, flyVel = nil, nil
    end

    -- gravity slider  local physics prop only, restores on kill
    if S.Gravity and workspace.Gravity ~= S.Gravity and not S.Noclip then
        workspace.Gravity = S.Gravity
    end

    -- player ESP  Highlight per player + a billboard name tag; the carrier
    -- (HasBall attr) gets an orange fill, everyone else a soft white outline
    if S.PlayerESP then
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= LocalPlayer and other.Character then
                local humOr = other.Character:FindFirstChildOfClass("Humanoid")
                local oroot = other.Character:FindFirstChild("HumanoidRootPart")
                if humOr and oroot then
                    local data = espMarks[other]
                    if not data or not data.hl.Parent then
                        local hl = Instance.new("Highlight")
                        hl.Name = "VfxRigGlow"
                        hl.FillColor = Color3.new(1, 1, 1)
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.FillTransparency = 0.85
                        hl.DepthMode = Enum.HighlightDepthMode.Occluded
                        -- name billboard over the head
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "TagOverlay"
                        bb.Adornee = oroot
                        bb.Size = UDim2.new(0, 90, 0, 22)
                        bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.fromScale(1, 1)
                        tl.BackgroundTransparency = 1
                        tl.Font = Enum.Font.GothamBold
                        tl.TextSize = 12
                        tl.TextStrokeTransparency = 0.4
                        tl.Text = other.Name
                        tl.TextColor3 = Color3.new(1, 1, 1)
                        tl.Parent = bb
                        bb.Parent = oroot
                        data = { hl = hl, bb = bb, tl = tl }
                        hl.Parent = other.Character
                        espMarks[other] = data
                    end
                    -- carrier = orange, teammate-neutral = soft white
                    local isCarrier = other.Character:GetAttribute("HasBall")
                        or oroot:GetAttribute("HasBall")
                        or other:GetAttribute("HasBall") == true
                    data.hl.FillColor = isCarrier and Color3.new(1, 0.5, 0) or Color3.new(1, 1, 1)
                end
            end
        end
    elseif next(espMarks) then
        clearESP()
    end
    if S.NetHud then
        ensureNetHud()
        if netHud then
            local ping = 0
            pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
            local fps = math.floor(1 / math.max(dt, 1e-5))
            netHud.Text = ("ms %d  fps %d"):format(ping, fps)
        end
    elseif netHud then
        killNetHud()
    end
end)
-- fov/fullbright/fps boost glue  toggle-level (see AddToggle wiring below)

-- sprint re-assert  the game's movement controller writes WalkSpeed from its
-- own state every frame; re-stamping on physics + heartbeat phases (in addition
-- to render) means our value is the last one the physics solver reads
local function sprintTick()
    if not S.AutoSprint then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local base = S.WalkSpeed or S.WalkSpeedDefault
        local target = base * S.SprintMult
        if hum.WalkSpeed ~= target then hum.WalkSpeed = target end
    end
end
RunService.Stepped:Connect(sprintTick)
RunService.Heartbeat:Connect(sprintTick)

-- 
--   5f. EXTRAS II  (ghost / ball tracer / void save / bunny hop /    
--                  anti-ragdoll / camera distance)                   
-- 

-- ghost  LocalTransparencyModifier is a render-only, client-side property;
-- nothing replicates, other players see you normally
local function applyGhost(alpha)
    local char = LocalPlayer.Character
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") or d:IsA("Decal") then
            pcall(function() d.LocalTransparencyModifier = alpha end)
        end
    end
end

-- ball tracer  beam from your chest to the ball, rebuilt if the ball swaps
local tracerBeam, tracerA0, tracerA1 = nil, nil, nil
local function killTracer()
    pcall(function() if tracerBeam then tracerBeam:Destroy() end end)
    pcall(function() if tracerA0 then tracerA0:Destroy() end end)
    pcall(function() if tracerA1 then tracerA1:Destroy() end end)
    tracerBeam, tracerA0, tracerA1 = nil, nil, nil
end

local function findBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower() == "ball" then
            return obj
        end
    end
end

-- camera distance  cache stock so Panic can put the camera back
local camZoomStock = {
    Max = LocalPlayer.CameraMaxZoomDistance,
    Min = LocalPlayer.CameraMinZoomDistance,
}

RunService.RenderStepped:Connect(function()
    -- ghost render refresh (game re-dirties limb transparency on animations)
    if S.Ghost then
        applyGhost(S.GhostAlpha)
    end

    -- ball tracer
    if S.BallTracer then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local ball = findBall()
        if root and ball then
            if not tracerBeam or not tracerBeam.Parent or not tracerA0 or not tracerA0.Parent
                or not tracerA1 or not tracerA1.Parent or tracerA1.Parent ~= ball or tracerA0.Parent ~= root then
                killTracer()
                tracerA0 = Instance.new("Attachment")
                tracerA0.Name = "TraceA0"
                tracerA0.Parent = root
                tracerA1 = Instance.new("Attachment")
                tracerA1.Name = "TraceA1"
                tracerA1.Parent = ball
                tracerBeam = Instance.new("Beam")
                tracerBeam.Name = "TraceBeam"
                tracerBeam.Attachment0 = tracerA0
                tracerBeam.Attachment1 = tracerA1
                tracerBeam.FaceCamera = true
                tracerBeam.Width0 = 0.12
                tracerBeam.Width1 = 0.04
                tracerBeam.Color = ColorSequence.new(Color3.new(1, 0.55, 0))
                tracerBeam.Transparency = NumberSequence.new(0.25)
                tracerBeam.LightEmission = 0.6
                tracerBeam.Parent = workspace
            end
        end
    elseif tracerBeam then
        killTracer()
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- void save  recover from under-map falls instead of a respawn
    if S.VoidSave and root.Position.Y < -60 then
        local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
        local target = spawn and (spawn.Position + Vector3.new(0, 6, 0)) or Vector3.new(0, 60, 0)
        pcall(function() root.CFrame = CFrame.new(target) end)
    end

    if hum then
        local st = hum:GetState()
        -- bunny hop  jump again the instant boots touch the floor
        if S.BunnyHop and st == Enum.HumanoidStateType.Landed then
            pcall(function() hum.Jump = true end)
        end
        -- anti-ragdoll  force get-up out of ragdoll / fallen states
        if S.AntiRagdoll and (st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown) then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end
end)

-- 
--   5e. HUMAN-RATE REMOTE THROTTLE  (anti-spam fingerprinting)       
--   Spamming StealEvent/BlockAttempt every frame is exactly what a    
--   server-side rate watcher flags as non-human cadence. Every remote 
--   fire the suite makes now passes through this gate: per-kind minimum 
--   interval plus a small random jitter each call, so the cadence     
--   never looks mechanical.                                        
-- 
local lastFired = {}
local function canFire(kind, minInterval)
    if not S.HumanFire then return true end
    local now = os.clock()
    local last = lastFired[kind] or 0
    local interval = minInterval + math.random() * (minInterval * 0.35)
    if now - last < interval then
        return false
    end
    lastFired[kind] = now
    return true
end


-- 
--   6. HEARTBEAT LOOP  (defense cluster  guard/steal/block/rebound) 
-- 
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end


    -- nearest ball carrier
    local carrier, cdist = nil, math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local oroot = other.Character.HumanoidRootPart
            local d = (oroot.Position - root.Position).Magnitude
            local has = other.Character:GetAttribute("HasBall")
                or oroot:GetAttribute("HasBall")
                or (other:GetAttribute("HasBall") == true)
            if has and d < cdist then
                carrier, cdist = oroot, d
            end
        end
    end

    if S.AutoGuard and carrier and cdist < S.GuardRange then
        -- sit in the handler's blind spot  behind their facing, eyes on the ball
        local blind = carrier.CFrame.LookVector * 2.5
        root.CFrame = CFrame.new(carrier.Position + blind, carrier.Position)
    end

    if S.AutoSteal and carrier and cdist < S.StealRange and canFire("steal", 0.55) then
        pcall(function() StealEvent:FireServer(carrier.Parent, root.CFrame) end)
    end

    if S.AntiSteal then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "ball" then
                local owner = obj:FindFirstAncestorOfClass("Model")
                if owner and owner ~= char and (obj.Position - root.Position).Magnitude < 6 and canFire("countersteal", 0.65) then
                    pcall(function() StealEvent:FireServer(owner, root.CFrame) end)
                end
            end
        end
    end

    if S.AutoBlock and carrier and cdist < S.BlockRange and carrier.Position.Y > root.Position.Y + 0.5 and canFire("block", 0.7) then
        pcall(function() BlockAttempt:FireServer(carrier.Parent) end)
        pcall(function() BlockEvent:FireServer(carrier.Parent, char) end)
    end

    -- always block  drops the range + jump-height gates; anyone holding the
    -- ball anywhere on the floor eats the block-attempt + block remote pair
    -- every throttle tick (same human-rate jitter so cadence stays human)
    if S.AutoBlockAll and canFire("allblock", 0.6) then
        for _, other in ipairs(Players:GetPlayers()) do
            local oroot = other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart")
            if oroot and (other.Character:GetAttribute("HasBall") or oroot:GetAttribute("HasBall") or other:GetAttribute("HasBall")) then
                pcall(function() BlockAttempt:FireServer(other.Character) end)
                pcall(function() BlockEvent:FireServer(other.Character, char) end)
            end
        end
    end

    if S.AutoRebound then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("rim") or obj.Name:lower():find("ball")) then
                local d = (obj.Position - root.Position).Magnitude
                if d < 55 then
                    root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2.5, 0))
                    if obj.Name:lower():find("rim") then
                        pcall(function()
                            ReboundAttempt:FireServer({ PredictedPosition = obj.Position })
                        end)
                    end
                    break
                end
            end
        end
    end
end)

-- 
--   7. GUI  (Linoria Lib  grouped by role, nothing scattered)       
--      Tabs: Shooting | Defense | Movement | Misc | Menu             
-- 
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

do
    local core = (gethui and gethui()) or game:GetService("CoreGui")
    local old = core:FindFirstChild("LinoriaLib")
    while old do
        old.Parent = nil
        old = core:FindFirstChild("LinoriaLib")
    end
end

local Window = Library:CreateWindow({
    Title = "ZUUA HUB  //  private gym",
    Center = true,
    AutoShow = true,
})

local function killAll()
    S.AutoGreen = false
    if S.AutoGreenCallback then S.AutoGreenCallback(false) end
    S.AutoUnlock = false
    unlockArmed = nil
    S.WornPins = {}
    if utils_unlockOff then utils_unlockOff() end
    pcall(sanitizePlaza)
    hooksOn = false
    for _, k in ipairs({"ShotGlide","DribbleGlide","AutoGuard","AutoContest","AutoBlock","AutoBlockAll","AutoSteal","AntiSteal","AutoRebound","BallMag","UnlimStam","ClutchFreeze","AntiAnkle","AntiBump","InfJump","ClickTP","Noclip","BallESP","Fullbright","FpsBoost","AntiAFK","NetHud","PlayerESP","AutoSprint","Fly","RimESP","Ghost","BallTracer","BunnyHop","VoidSave","AntiRagdoll","RimAim","MeterHud"}) do
        S[k] = false
    end
    clearRimESP()
    restoreBallScale()
    killTracer()
    applyGhost(0)
    S.BallScale = 1.0
    S.GreenWindow = 55
    S.CameraZoom = 70
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = camZoomStock.Max
        LocalPlayer.CameraMinZoomDistance = camZoomStock.Min
    end)
    if ShotContestConfig then pcall(function() ShotContestConfig.BaseGreenWindow = _shotGreenStock end) end
    if Met.SetClutchFrozen then pcall(Met.SetClutchFrozen, false) end
    S.WalkSpeed = S.WalkSpeedDefault
    S.DribbleGlidePow = 22
    S.JumpPower = 50
    -- release the glide body so physics cleans up too
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj.Name == "SynthGlideBV" and obj:IsA("BodyVelocity") then
                obj:Destroy()
            end
        end
    end
    pcall(function() RunService:UnbindFromRenderStep("SynthSuite_Glide") end)
    -- extras teardown  visuals/state back to stock
    killBallESP()
    clearESP()
    killNetHud()
    killMeterHud()
    restoreLighting()
    workspace.Gravity = 196.2
    pcall(function()
        if flyGyro then flyGyro:Destroy() end
        if flyVel then flyVel:Destroy() end
    end)
    flyGyro, flyVel = nil, nil
    pcall(setSprintKey, false)
    table.clear(lastFired)
    S.FlySpeed = 45
    S.MagnetRadius = 40
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = 70 end
end

--  TAB: Shooting 
local ShootingTab = Window:AddTab("Shooting")
local shootingMain = ShootingTab:AddLeftGroupbox("Shot Automation")
shootingMain:AddToggle("AutoGreen", {
    Text = "Auto Green (hooks MeterController)",
    Default = S.AutoGreen,
    Tooltip = "Forces Timing=100 on release read  server math reads green",
    Callback = function(v)
        S.AutoGreen = v
        if S.AutoGreenCallback then S.AutoGreenCallback(v) end
    end,
})
shootingMain:AddToggle("AutoShot", {
    Text = "Auto Shot",
    Default = S.AutoShot,
    Tooltip = "Automatically fires shoot when meter is in green window",
    Callback = function(v) S.AutoShot = v end,
})
shootingMain:AddToggle("AutoDunk", {
    Text = "Auto Dunk",
    Default = S.AutoDunk,
    Tooltip = "Attempts dunk when near rim and has ball",
    Callback = function(v) S.AutoDunk = v end,
})
shootingMain:AddToggle("FastPass", {
    Text = "Fast Pass",
    Default = S.FastPass,
    Tooltip = "Snaps passes to fastest animation",
    Callback = function(v) S.FastPass = v end,
})
shootingMain:AddToggle("AutoRelease", {
    Text = "Auto Release",
    Default = S.AutoRelease,
    Tooltip = "Releases shot automatically on green",
    Callback = function(v) S.AutoRelease = v end,
})
shootingMain:AddSlider("ShotPower", {
    Text = "Shot Power",
    Default = S.ShotPower,
    Min = 50,
    Max = 150,
    Rounding = 0,
    Compact = false,
    Tooltip = "Adjusts shot velocity multiplier",
    Callback = function(v) S.ShotPower = v end,
})
shootingMain:AddToggle("AutoBank", {
    Text = "Auto Bank Shot",
    Default = S.AutoBank,
    Tooltip = "Aims toward backboard when shooting",
    Callback = function(v) S.AutoBank = v end,
})
shootingMain:AddToggle("AimAssist", {
    Text = "Aim Assist",
    Default = S.AimAssist,
    Tooltip = "Soft aim snap toward rim",
    Callback = function(v) S.AimAssist = v end,
})
shootingMain:AddToggle("ShotGlide", {
    Text = "Shot Glide",
    Default = S.ShotGlide,
    Tooltip = "Keeps movement momentum while shooting",
    Callback = function(v) S.ShotGlide = v end,
})
shootingMain:AddSlider("ShotGlidePow", {
    Text = "Shot Glide Power",
    Default = S.ShotGlidePow,
    Min = 16,
    Max = 60,
    Rounding = 0,
    Compact = false,
    Callback = function(v) S.ShotGlidePow = v end,
})
shootingMain:AddToggle("DribbleGlide", {
    Text = "Dribble Glide",
    Default = S.DribbleGlide,
    Tooltip = "Glide while dribbling  Slider below sets strength",
    Callback = function(v) S.DribbleGlide = v end,
})
shootingMain:AddSlider("DribbleGlidePow", {
    Text = "Dribble Glide Power",
    Default = S.DribbleGlidePow,
    Min = 16,
    Max = 60,
    Rounding = 0,
    Compact = false,
    Callback = function(v) S.DribbleGlidePow = v end,
})
shootingMain:AddDivider()
local shootingFreeze = ShootingTab:AddRightGroupbox("Meter Control")
shootingFreeze:AddToggle("ClutchFreeze", {
    Text = "Clutch Freeze (lock meter)",
    Default = S.ClutchFreeze,
    Tooltip = "Calls the game's own MeterController.SetClutchFrozen  meter stops moving",
    Callback = function(v) S.ClutchFreeze = v end,
})
shootingFreeze:AddSlider("GreenWindow", {
    Text = "Green window",
    Default = S.GreenWindow,
    Min = 15,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Tooltip = "Widens ShotContestConfig.BaseGreenWindow  bigger window, easier make. Stock 15, only applies while Auto Green is on",
    Callback = function(v) S.GreenWindowCallback(v) end,
})
shootingFreeze:AddToggle("MeterHud", {
    Text = "Shot meter HUD",
    Default = S.MeterHud,
    Tooltip = "Read-only timing readout + live green threshold at the bottom of the screen",
    Callback = function(v)
        S.MeterHud = v
        if v then ensureMeterHud() else killMeterHud() end
    end,
})
shootingFreeze:AddToggle("RimAim", {
    Text = "Rim Aim (camera locks rim)",
    Default = S.RimAim,
    Tooltip = "Pulls the camera onto the nearest rim every frame  line up shots without mouse work",
    Callback = function(v) S.RimAim = v end,
})

--  TAB: Defense 
local DefenseTab = Window:AddTab("Defense")
local defenseActive = DefenseTab:AddLeftGroupbox("Off-Ball Action")
defenseActive:AddToggle("AutoGuard", {
    Text = "Auto Guard",
    Default = S.AutoGuard,
    Callback = function(v) S.AutoGuard = v end,
})
defenseActive:AddToggle("AutoContest", {
    Text = "Auto Contest",
    Default = S.AutoContest,
    Callback = function(v) S.AutoContest = v end,
})
defenseActive:AddToggle("AutoBlock", {
    Text = "Auto Block",
    Default = S.AutoBlock,
    Callback = function(v) S.AutoBlock = v end,
})
defenseActive:AddToggle("AutoRebound", {
    Text = "Auto Rebound",
    Default = S.AutoRebound,
    Callback = function(v) S.AutoRebound = v end,
})
local defenseOnBall = DefenseTab:AddRightGroupbox("Ball Handling Defense")
defenseOnBall:AddToggle("AutoBlockAll", {
    Text = "Always Block (anyone with ball)",
    Default = S.AutoBlockAll,
    Tooltip = "Fires the block remote pair on every ball carrier on the floor, no range or jump-height gate  human-rate throttled so the cadence stays human",
    Callback = function(v) S.AutoBlockAll = v end,
})
defenseOnBall:AddToggle("AutoSteal", {
    Text = "Auto Steal",
    Default = S.AutoSteal,
    Callback = function(v) S.AutoSteal = v end,
})
defenseOnBall:AddToggle("AntiSteal", {
    Text = "Anti Steal (counter-steal)",
    Default = S.AntiSteal,
    Callback = function(v) S.AntiSteal = v end,
})
local defenseSurvival = DefenseTab:AddRightGroupbox("Survival")
defenseSurvival:AddToggle("AntiAnkle", {
    Text = "Anti Ankle",
    Default = S.AntiAnkle,
    Tooltip = "Instantly clears AnkleLocked, restores AutoRotate + speed",
    Callback = function(v) S.AntiAnkle = v end,
})
defenseSurvival:AddToggle("AntiBump", {
    Text = "Anti Bump",
    Default = S.AntiBump,
    Tooltip = "Clears BumpSlowed before the slow takes hold",
    Callback = function(v) S.AntiBump = v end,
})
local defenseRanges = DefenseTab:AddRightGroupbox("Automation Ranges")
defenseRanges:AddSlider("GuardRange", {
    Text = "Auto Guard range",
    Default = S.GuardRange,
    Min = 5,
    Max = 45,
    Rounding = 0,
    Callback = function(v) S.GuardRange = v end,
})
defenseRanges:AddSlider("StealRange", {
    Text = "Auto Steal range",
    Default = S.StealRange,
    Min = 2,
    Max = 15,
    Rounding = 1,
    Callback = function(v) S.StealRange = v end,
})
defenseRanges:AddSlider("BlockRange", {
    Text = "Auto Block range",
    Default = S.BlockRange,
    Min = 3,
    Max = 12,
    Rounding = 0,
    Callback = function(v) S.BlockRange = v end,
})

--  TAB: Movement 
local MovementTab = Window:AddTab("Movement")
local movementMain = MovementTab:AddLeftGroupbox("Locomotion")
movementMain:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = S.WalkSpeed,
    Min = 12,
    Max = 60,
    Rounding = 0,
    Compact = false,
    Callback = function(v) S.WalkSpeed = v end,
})
movementMain:AddToggle("UnlimStam", {
    Text = "Unlimited Stamina",
    Default = S.UnlimStam,
    Tooltip = "Pins GameplayStamina attribute to 100 each frame",
    Callback = function(v) S.UnlimStam = v end,
})
movementMain:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = S.JumpPower,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Compact = false,
    Callback = function(v)
        S.JumpPower = v
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.UseJumpPower then hum.JumpPower = v end
    end,
})
movementMain:AddToggle("InfJump", {
    Text = "Infinite Jump",
    Default = S.InfJump,
    Callback = function(v) S.InfJump = v end,
})
movementMain:AddToggle("AntiKnockback", {
    Text = "Anti Knockback",
    Default = S.AntiKnockback,
    Tooltip = "Resets root velocity spikes from bumps",
    Callback = function(v) S.AntiKnockback = v end,
})
movementMain:AddToggle("NoFallDamage", {
    Text = "No Fall Damage",
    Default = S.NoFallDamage,
    Tooltip = "Prevents fall damage by resetting humanoid health on land",
    Callback = function(v) S.NoFallDamage = v end,
})
movementMain:AddToggle("AutoStrafe", {
    Text = "Auto Strafe",
    Default = S.AutoStrafe,
    Tooltip = "Micro side-step while moving",
    Callback = function(v) S.AutoStrafe = v end,
})
movementMain:AddDivider()
local movementTools = MovementTab:AddRightGroupbox("Tools")
movementTools:AddToggle("ClickTP", {
    Text = "Click TP (press F)",
    Default = S.ClickTP,
    Tooltip = "F teleports to where your cursor points (5000 stud ray)",
    Callback = function(v) S.ClickTP = v end,
})
movementTools:AddToggle("AutoSprint", {
    Text = "Auto Sprint",
    Default = S.AutoSprint,
    Tooltip = "Always sprinting  holds the game's own LeftShift sprint state virtually and re-stamps the multiplier",
    Callback = function(v) S.AutoSprint = v end,
})
movementTools:AddSlider("SprintMult", {
    Text = "Sprint multiplier",
    Default = S.SprintMult,
    Min = 1.25,
    Max = 3,
    Rounding = 2,
    Compact = false,
    Callback = function(v) S.SprintMult = v end,
})
movementTools:AddSlider("Gravity", {
    Text = "Gravity",
    Default = S.Gravity,
    Min = 40,
    Max = 196.2,
    Rounding = 1,
    Compact = false,
    Tooltip = "Local physics only  moon-jump at low values, stock 196.2",
    Callback = function(v)
        S.Gravity = v
        workspace.Gravity = v
    end,
})

--  TAB: Misc 
local MiscTab = Window:AddTab("Misc")
local miscBall = MiscTab:AddLeftGroupbox("Ball & Objectives")
miscBall:AddToggle("BallMag", {
    Text = "Ball Magnet",
    Default = S.BallMag,
    Callback = function(v) S.BallMag = v end,
})
miscBall:AddButton({
    Text = "Teleport to nearest rim",
    Func = function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local nearest, nd = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("rim") then
                local d = (obj.Position - root.Position).Magnitude
                if d < nd then nearest, nd = obj, d end
            end
        end
        if nearest then
            root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
        end
    end
    end,
})
miscBall:AddDropdown("TargetPlayer", {
    Text = "Teleport to player",
    AllowNull = true,
    Default = "",
    Ignore = { LocalPlayer.Name },
    Values = (function()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        return names
    end)(),
    Callback = function() end,
})
miscBall:AddButton({
    Text = "TP to selected player",
    Func = function()
    local opt = Library.Options and Library.Options.TargetPlayer
    local name = type(opt) == "table" and opt.Value or opt
    if not name or not Players:FindFirstChild(name) then return end
    local target = Players:FindFirstChild(name)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if root and tr then
        root.CFrame = tr.CFrame * CFrame.new(0, 0, 2)
    end
    end,
})
local miscCtl = MiscTab:AddRightGroupbox("Kill Switch")
miscCtl:AddButton({
    Text = "Panic  turn everything off",
    Func = killAll,
})
miscCtl:AddButton({
    Text = "Unload suite",
    Func = function()
        killAll()
        -- tear down the suite's own input connections so nothing armed survives
        for _, conn in pairs(unloader) do
            pcall(function() conn:Disconnect() end)
        end
        -- restore any spoofed unlock attributes back to clean
        pcall(function()
            LocalPlayer:SetAttribute("IsAdmin", nil)
        end)
        Library:Unload()
    end,
})

--  Extras groupboxes  noclip, visuals, performance, networking 
local miscVisual = MiscTab:AddLeftGroupbox("Visuals")
miscVisual:AddToggle("RimESP", {
    Text = "Rim ESP (highlight rims)",
    Default = S.RimESP,
    Tooltip = "Cyan Highlight on every rim part in the map",
    Callback = function(v)
        S.RimESP = v
        if not v then clearRimESP() end
    end,
})
miscVisual:AddSlider("BallScale", {
    Text = "Ball size",
    Default = S.BallScale,
    Min = 0.25,
    Max = 3,
    Rounding = 2,
    Compact = false,
    Tooltip = "Local view only  server sees stock ball. 1.0 = stock",
    Callback = function(v) S.BallScale = v end,
})
miscVisual:AddToggle("BallESP", {
    Text = "Ball ESP (highlight through walls)",
    Default = S.BallESP,
    Callback = function(v) S.BallESP = v end,
})
miscVisual:AddToggle("PlayerESP", {
    Text = "Player ESP (name tags + carrier)",
    Default = S.PlayerESP,
    Tooltip = "Every player gets a name tag; whoever HasBall glows orange",
    Callback = function(v)
        S.PlayerESP = v
        if not v then clearESP() end
    end,
})
miscVisual:AddSlider("Fov", {
    Text = "Camera FOV",
    Default = S.Fov,
    Min = 50,
    Max = 120,
    Rounding = 0,
    Compact = false,
    Callback = function(v)
        S.Fov = v
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = v end
    end,
})
miscVisual:AddSlider("CameraZoom", {
    Text = "Camera max distance",
    Default = S.CameraZoom,
    Min = 12,
    Max = 150,
    Rounding = 0,
    Compact = false,
    Tooltip = "Third-person pull-back distance  see more of the court",
    Callback = function(v)
        S.CameraZoom = v
        pcall(function()
            LocalPlayer.CameraMaxZoomDistance = v
            if LocalPlayer.CameraMinZoomDistance > v then
                LocalPlayer.CameraMinZoomDistance = math.max(v * 0.5, 4)
            end
        end)
    end,
})
miscVisual:AddToggle("BallTracer", {
    Text = "Ball Tracer (beam to ball)",
    Default = S.BallTracer,
    Tooltip = "Orange beam from your chest to the ball  always know where it is",
    Callback = function(v)
        S.BallTracer = v
        if not v then killTracer() end
    end,
})
miscVisual:AddToggle("Ghost", {
    Text = "Ghost (local invisibility)",
    Default = S.Ghost,
    Tooltip = "Render-only transparency  only your client stops drawing you, the server and other players still see you",
    Callback = function(v)
        S.Ghost = v
        if not v then applyGhost(0) end
    end,
})
miscVisual:AddSlider("GhostAlpha", {
    Text = "Ghost transparency",
    Default = S.GhostAlpha,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(v) S.GhostAlpha = v end,
})

local miscPerf = MiscTab:AddRightGroupbox("Performance")
miscPerf:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = S.Fullbright,
    Tooltip = "Max brightness, no shadows, no fog  court fully lit",
    Callback = function(v)
        S.Fullbright = v
        if v then applyLighting() else restoreLighting() end
    end,
})
miscPerf:AddToggle("FpsBoost", {
    Text = "FPS Boost (shadows/particles off)",
    Default = S.FpsBoost,
    Callback = function(v)
        S.FpsBoost = v
        if v then applyFpsBoost() else restoreLighting() end
    end,
})

local miscMove = MiscTab:AddLeftGroupbox("Movement Extras")
miscMove:AddToggle("Noclip", {
    Text = "Noclip",
    Default = S.Noclip,
    Tooltip = "Walk through walls  collision off on your character parts",
    Callback = function(v) S.Noclip = v end,
})
miscMove:AddToggle("Fly", {
    Text = "Fly (WASD + Space/Ctrl)",
    Default = S.Fly,
    Tooltip = "Camera-relative flight; C or LeftCtrl to descend",
    Callback = function(v) S.Fly = v end,
})
miscMove:AddSlider("FlySpeed", {
    Text = "Fly speed",
    Default = S.FlySpeed,
    Min = 15,
    Max = 150,
    Rounding = 0,
    Compact = false,
    Callback = function(v) S.FlySpeed = v end,
})
miscMove:AddSlider("MagnetRadius", {
    Text = "Ball magnet radius",
    Default = S.MagnetRadius,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(v) S.MagnetRadius = v end,
})
miscMove:AddToggle("BunnyHop", {
    Text = "Bunny Hop",
    Default = S.BunnyHop,
    Tooltip = "Auto-jumps the instant you land  keeps you at full hop speed",
    Callback = function(v) S.BunnyHop = v end,
})
miscMove:AddToggle("VoidSave", {
    Text = "Void Save",
    Default = S.VoidSave,
    Tooltip = "Snaps you back to spawn if you fall under the map instead of dying",
    Callback = function(v) S.VoidSave = v end,
})
miscMove:AddToggle("AntiRagdoll", {
    Text = "Anti Ragdoll (instant get-up)",
    Default = S.AntiRagdoll,
    Tooltip = "Forces GettingUp out of ragdoll / fallen states",
    Callback = function(v) S.AntiRagdoll = v end,
})

local miscSys = MiscTab:AddRightGroupbox("System")
miscSys:AddToggle("AntiAFK", {
    Text = "Anti-AFK",
    Default = S.AntiAFK,
    Tooltip = "Plugs the 20-min idle kick",
    Callback = function(v) S.AntiAFK = v end,
})
miscSys:AddToggle("NetHud", {
    Text = "Network / FPS HUD",
    Default = S.NetHud,
    Tooltip = "Corner readout: ping ms + fps",
    Callback = function(v)
        S.NetHud = v
        if v then ensureNetHud() else killNetHud() end
    end,
})
miscSys:AddToggle("HumanFire", {
    Text = "Human-rate remotes (stay subtle)",
    Default = S.HumanFire,
    Tooltip = "Throttles every auto remote fire with jitter  no mechanical cadence for the server to flag",
    Callback = function(v) S.HumanFire = v end,
})
miscSys:AddButton({
    Text = "Rejoin this server",
    Func = function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        end)
    end,
})

--  7e. UNLOCK ALL 
-- client-side ownership reads only  equips still use the real remotes
local unlockArmed = false
local applyUnlockAll = function() end -- filled below, before the tab is built
local applyPins = function() end
-- animation pins  recordings of what you equip while unlock is armed;
-- the server resyncs BuildAnimationSettings every few seconds and that
-- resync is exactly what reverts your picked animation. applyPins()
-- function-replaces the game's own Preferences.SetGame (pure table
-- write, same trick as MeterController, no metamethod surface) to capture
-- each pick, then re-applies every pin on attr change and on loop.
S.UnlockPins = S.UnlockPins or {}
pcall(function()
    local Prefs = require(game.ReplicatedStorage.Modules.TabMenu.Preferences)
    if Prefs and type(Prefs.SetGame) == "function" then
        local oldSetGame = Prefs.SetGame
        Prefs.SetGame = function(key, id)
            S.UnlockPins[key] = id
            return oldSetGame(key, id)
        end
    end
end)
-- server-truth sanitizer  older builds (v3.3-v3.6) stamped a fake
-- 15KB PlazaOwned list straight onto the attribute, and that garbage still
-- sits there unless the next server sync lands. The shop page reads it for
-- a flash (fake tiles appear) then _fetch() returns server truth and every
-- tile drops ("You don't own any pants yet. Buy them in the Plaza shops and
-- they'll appear here."). This pulls the real owned list from the server
-- and writes it back the moment we load, killing the stale fake at boot.
function sanitizePlaza()
    pcall(function()
        local resp = game:GetService("ReplicatedStorage").Events.PlazaShop:InvokeServer("Get")
        if type(resp) == "table" and resp.Ready and type(resp.Owned) == "table" then
            local Http = game:GetService("HttpService")
            local encoded = Http:JSONEncode(resp.Owned)
            if LocalPlayer:GetAttribute("PlazaOwned") ~= encoded then
                LocalPlayer:SetAttribute("PlazaOwned", encoded)
            end
        end
    end)
end
sanitizePlaza()

local UnlockTab = Window:AddTab("Unlock")
local miscUnlock = UnlockTab:AddLeftGroupbox("Unlock All")
-- Original server-pushed attribute values, captured BEFORE we ever spoof 
-- so toggling OFF restores the game's truth byte-for-byte instead of
-- writing garbage that the page then renders ("all my clothes vanished" was
-- exactly this: unlockOff stomped PlazaOwned with a fake {} and the shop
-- inventory rendered nothing until the next server resync).
S.UnlockSentinel = S.UnlockSentinel or (function()
    local Http = game:GetService("HttpService")
    return {
        IsAdmin = LocalPlayer:GetAttribute("IsAdmin"),
        OwnedAnimations = LocalPlayer:GetAttribute("OwnedAnimations"),
        OwnedAuras = LocalPlayer:GetAttribute("OwnedAuras"),
        OwnedMascots = LocalPlayer:GetAttribute("OwnedMascots"),
        encodeEmpty = pcall(function() return Http:JSONEncode({}) end) and "{}" or "{}",
    }
end)()
-- master toggle  ON arms the spoof, OFF restores original server values
utils_unlockOff = utils_unlockOff or function()
    S.AutoUnlock = false
    unlockArmed = false
    pcall(function()
        local sen = S.UnlockSentinel or {}
        if sen.IsAdmin == nil then
            LocalPlayer:SetAttribute("IsAdmin", nil)
        else
            LocalPlayer:SetAttribute("IsAdmin", sen.IsAdmin)
        end
        -- restore the EXACT strings the server pushed  not a fake {}
        if sen.OwnedAnimations then LocalPlayer:SetAttribute("OwnedAnimations", sen.OwnedAnimations) end
        if sen.OwnedAuras then LocalPlayer:SetAttribute("OwnedAuras", sen.OwnedAuras) end
        if sen.OwnedMascots then LocalPlayer:SetAttribute("OwnedMascots", sen.OwnedMascots) end
        -- PlazaOwned: re-sync the REAL owned list from the server live (kills
        -- any stale spoof leftover from older builds still parked on the attr)
        sanitizePlaza()
    end)
end
miscUnlock:AddToggle("UnlockAll", {
    Text = "Unlock All (animations/settings  client gate)",
    Default = false,
    Tooltip = "ARM: IsAdmin + full animation list + the entire catalog pinned as your worn set. OFF restores server values.",
    Callback = function(v)
        S.AutoUnlock = v
        unlockArmed = v
        if v then
            pcall(applyUnlockAll)
            -- auto-grant: every PlazaCatalog item goes into the wear pin 
            -- the whole catalog becomes your pinned equipped set, no paste
            -- needed. Also auto-wires the Cosmetics.Request server "Get" so
            -- pages that read the server truth see the pin applied.
            pcall(function()
                local cat = require(game.ReplicatedStorage.Modules.PlazaCatalog)
                local all = {}
                for _, item in ipairs(cat.Items) do
                    if item and item.Id then table.insert(all, item.Id) end
                end
                S.WornPins = all
                if S.WornPinAttr then pcall(S.WornPinAttr) end
                pcall(function()
                    Library:Notify("Unlock ARMED  " .. #all .. " catalog ids pinned to your worn set", 4)
                end)
            end)
            -- live feedback  did the stamps actually stick?
            local kept = LocalPlayer:GetAttribute("IsAdmin") == true
            pcall(function()
                Library:Notify(kept and "Unlock ARMED  IsAdmin stuck, picker is open."
                    or "Unlock armed but IsAdmin reported nil  flag may have been blocked", 4)
            end)
            task.spawn(function()
                while S.AutoUnlock do
                    task.wait(0.25)
                    pcall(applyUnlockAll)
                    pcall(applyPins)
                    -- keep the worn pins alive through attr resyncs too
                    if S.WornPinAttr then pcall(S.WornPinAttr) end
                end
            end)
        else
            if utils_unlockOff then
                utils_unlockOff()
                S.WornPins = {}
                pcall(sanitizePlaza)
            end
        end
    end,
})
miscUnlock:AddButton({
    Text = "Verify unlock state",
    Func = function()
        local Http = game:GetService("HttpService")
        local admin = LocalPlayer:GetAttribute("IsAdmin")
        local raw = LocalPlayer:GetAttribute("OwnedAnimations")
        local n = 0
        pcall(function()
            local ok, tbl = pcall(Http.JSONDecode, Http, raw or "{}")
            if ok and type(tbl) == "table" then
                for _ in pairs(tbl) do n = n + 1 end
            end
        end)
        pcall(function()
            Library:Notify(tostring(admin) .. "  OwnedAnimations: " .. n .. " ids", 5)
        end)
        print(("chk a=%s o=%s (%d)"):format(tostring(admin), tostring(raw), n))
    end,
})

--  7g. COSMETIC PIN (wear/list spoof with revert-trap) 
-- What still fails server-side: the shop's equip records live on the server
-- so wants-you-wearing/aura/banners you don't own get rejected ("You don't
-- own that item"). The client-side layer we CAN hold: the page's wear-list
-- attr  `PlazaOutfit`. When we pin our picks onto that attr the game's UI
-- and (where the local renderer reads it for clothing) your own view show
-- them equipped; we trap ALL resyncs with the same instant-restore pattern
-- as BuildAnimationSettings, so the page can't slam it back.
S.WornPins = S.WornPins or {}
miscUnlock:AddDivider()
miscUnlock:AddInput("CosmeticIds", {
    Text = "Wear pin  comma-separated item ids",
    Default = "",
    Tooltip = "Paste ids from the game's catalog like Casual_398633584, Jeans_1  applied as your pinned worn set.",
    Placeholder = "Casual_398633584, Barber_17750325511",
    Callback = function() end,
})
S.WornPinAttr = S.WornPinAttr or function()
    -- write the pinned worn-set into PlazaOutfit (id-keyed list the page reads)
    pcall(function()
        local Http = game:GetService("HttpService")
        local out = {}
        for _, id in ipairs(S.WornPins) do out[tostring(id)] = true end
        LocalPlayer:SetAttribute("PlazaOutfit", Http:JSONEncode(out))
    end)
end
miscUnlock:AddButton({
    Text = "Apply wear pin",
    Func = function()
        local opt = Library.Options and Library.Options.CosmeticIds
        local raw = type(opt) == "table" and (opt.Value or opt) or nil
        if type(raw) == "string" and #raw > 0 then
            -- accept comma/whitespace separated
            local ids = {}
            for tok in string.gmatch(raw, "[^,%s]+") do table.insert(ids, tok) end
            S.WornPins = ids
        else
            -- empty box? pin the WHOLE catalog instead of erroring
            pcall(function()
                local cat = require(game.ReplicatedStorage.Modules.PlazaCatalog)
                S.WornPins = {}
                for _, item in ipairs(cat.Items) do
                    if item and item.Id then table.insert(S.WornPins, item.Id) end
                end
            end)
        end
        pcall(S.WornPinAttr)
        pcall(function()
            Library:Notify("Wear pin applied  " .. #S.WornPins .. " ids (local view only)", 4)
        end)
    end,
})
miscUnlock:AddButton({
    Text = "Clear wear pin",
    Func = function()
        S.WornPins = {}
        -- restore the live server value instead of writing a blank
        pcall(sanitizePlaza)
        pcall(function()
            Library:Notify("Wear pin cleared  server truth restored", 4)
        end)
    end,
})
unloader.WearPin = LocalPlayer:GetAttributeChangedSignal("PlazaOutfit"):Connect(function()
    if S.WornPins and #S.WornPins > 0 and S.AutoUnlock then
        task.defer(pcall, S.WornPinAttr)
    end
end)

-- SERVER-SIDE HONEST NOTE (bench comment, not a refusal):
-- Everything the server decides  plaza equips, aura/mascot equips, real
-- banner ownership  is stored and revalidated server-side. The client's
-- only channel is InvokeServer, and the server answers unowned ids with
-- "You don't own that item." Truly flipping server ownership would mean
-- exploiting the game's SERVER (different target, different surface, and
-- nothing in this client-script touches it). The client decides only the
-- animation/settings gate  which is where our unlock fires, and where
-- the effects are real and visually loadable in-game.
-- instant re-stamp  the server's attribute resync fires AttributeChangedSignal,
-- so the loop barely matters: the moment a sync lands, we slam it back this frame.
unloader.UnlockSync = (function()
    local conns = {}
    for _, name in ipairs({"IsAdmin", "OwnedAnimations", "BuildAnimationSettings"}) do
        local c = LocalPlayer:GetAttributeChangedSignal(name)
        if c then
            table.insert(conns, c:Connect(function()
                if S.AutoUnlock then
                    task.defer(pcall, applyUnlockAll)
                    -- revert-trap: server resyncing your animation settings is
                    -- exactly the "shows a few seconds then reverts" beat 
                    -- re-apply whatever the player pinned while unlock is armed.
                    task.defer(pcall, applyPins)
                end
            end))
        end
    end
    return {
        Disconnect = function()
            for _, c in ipairs(conns) do
                pcall(function() c:Disconnect() end)
            end
        end,
    }
end)()
applyUnlockAll = function()
    local Http = game:GetService("HttpService")
    local function json(t)
        local ok, s = pcall(Http.JSONEncode, Http, t)
        return ok and s or nil
    end
    local function tryAttr(name, val)
        pcall(function() LocalPlayer:SetAttribute(name, val) end)
    end
    -- 1) admin flag: opens every animation/setting in InventoryPage + SettingsHandler,
    --    and shows the ADMIN panel button in TabMenuController
    tryAttr("IsAdmin", true)
    tryAttr("IsAdmin", true)
    -- PLAZA OWNED IS NEVER SPOOFED ANYMORE  see the comment two lines up.
    -- This whole lane goes dead to us; the animation gate is the real target.
    -- 2) PLAZA/SHOP OWNERSHIP  deliberately left alone in v3.7. The page
    --    pulls PlazaOwned from the server via remotes on every fetch, our
    --    fake writes fought that and erased the clothing grid between
    --    refreshes. Server truth stays untouched.
    -- 3) animations: the real gate. AnimationShopConfig.Items is a flat array of
    --    shop entries, each carrying { Id = "GreenAnimation...", Key = "Green Animation", ... }.
    --    SettingsHandler.availableSelection (L50-62) honors IsAdmin FIRST, then falls
    --    back to reading OwnedAnimations[v1.Id] == true from this attribute.
    pcall(function()
        local cfg = require(game.ReplicatedStorage.Shared.AnimationShopConfig)
        local AllSettings = require(game.ReplicatedStorage.Client.Services.SettingsHandler.AllSettings)
        local anims = {}
        -- shop-for-day entries (flat array with .Id)
        for _, item in ipairs(type(cfg.Items) == "table" and cfg.Items or {}) do
            if type(item) == "table" and item.Id then
                anims[tostring(item.Id)] = true
            end
        end
        -- every GameSettings option that has a purchase config (ForSelection(key, id).Id)
        for key, def in pairs(AllSettings.GameSettings) do
            for _, option in ipairs(def.Options or {}) do
                local cfgv = cfg.ForSelection and cfg.ForSelection(key, option)
                if cfgv and cfgv.Id then
                    anims[tostring(cfgv.Id)] = true
                end
            end
        end
        tryAttr("OwnedAnimations", json(anims))
    end)
    -- 4) auras + mascots: server-owned exclusively through the Cosmetics
    --    remote ("You don't own that item" on unowned ids). No attribute we
    --    write is read by that flow, so we don't touch it at all.
    print("[zh] r1 set")
end

-- applyPins  re-apply the player's animation picks after a server revert.
-- SettingsHandler.SetSettingValue writes the client's own setting record and
-- fires the changed event; that's the client-authoritative path.
applyPins = function()
    local ok, SettingsHandler = pcall(function()
        return require(game.ReplicatedStorage.Client.Services.SettingsHandler)
    end)
    if not ok or type(SettingsHandler) ~= "table" or not SettingsHandler.SetSettingValue then return end
    for key, id in pairs(S.UnlockPins) do
        pcall(SettingsHandler.SetSettingValue, SettingsHandler, "GameSettings", key, id)
    end
end


-- 
--   7g. CONFIGS  (Linoria SaveManager addon)                         
--   Slots are saved to the executor's workspace folder as Lua config  
--   files, one per slot. Autoload pulls the last-used slot on inject. 
-- 
local ConfigTab = Window:AddTab("Configs")
pcall(function()
    local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("zuuahub/private-gym")
    SaveManager:BuildConfigSection(ConfigTab)
    SaveManager:LoadAutoloadConfig()
end)

print("[zh] c0 ready")
