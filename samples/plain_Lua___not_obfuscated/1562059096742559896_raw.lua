if not game:IsLoaded() then game.Loaded:Wait() end    
local Players = game:GetService("Players")    
local RunService = game:GetService("RunService")    
local UIS = game:GetService("UserInputService")    
local Lighting = game:GetService("Lighting")    
local HS = game:GetService("HttpService")    
local TweenService = game:GetService("TweenService")    
local LP = Players.LocalPlayer    
    
local galaxyOn = false    
local defBrightness, defClock, defAmbient = Lighting.Brightness, Lighting.ClockTime, Lighting.OutdoorAmbient    

-- =========================== INSTA RESET ===========================
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local instaResetFloatingPos = nil
local aimbotBypassFloatingPos = nil

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end
task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

local function cursedInstaReset()
    if not cursedResetRemote then
        findCursedResetRemote()
        if not cursedResetRemote then return end
    end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
        return
    end
    local resetDetected = false
    local conns = {}
    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end
    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
            task.wait()
        end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end
-- =========================== FIN INSTA RESET ===========================

    
-- =========================== BAT AIMBOT (Cursed Hub) ===========================
local autoBatEnabled = false
local autoBatSetVisual = nil
local autoSwingEnabled = true
local setAutoSwingVisual = nil

local AUTO_BAT_SPEED = 58
local AUTO_BAT_VERT_SPEED = 52
local AUTO_BAT_DIST = -2.8
local AUTO_BAT_HEIGHT = 4.75
local AUTO_BAT_V_OFF = 1
local AUTO_BAT_TURN_SPEED = 285
local AUTO_BAT_MAX_TURN_RATE = 28

local autoBatConnection = nil
local autoBatEquipped = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local batTool = nil

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("bat") or name:find("slap") then return tool end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then return tool end
            end
        end
    end
    return nil
end

local function getAutoBatTarget()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return _autoBatTarget end
    end
    _autoBatLastScan = now
    _autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    _autoBatTarget = closest
    return _autoBatTarget
end

local function ensureBatEquipped()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    if not char:FindFirstChildOfClass("Tool") then
        local bat = findBat()
        if bat then pcall(function() hum:EquipTool(bat) end); batTool = bat end
    else
        batTool = char:FindFirstChildOfClass("Tool")
    end
end

local function resetAutoBatMotion()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end

local function startBatAimbot()
    if autoBatConnection then return end
    autoBatConnection = RunService.Heartbeat:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then return end

        if not autoBatEquipped then
            autoBatEquipped = true
            ensureBatEquipped()
        end

        local target = getAutoBatTarget()
        if target then
            local targetVel = target.AssemblyLinearVelocity
            local aimTargetPos = target.Position + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15)) + Vector3.new(0, AUTO_BAT_V_OFF, 0)

            hum.AutoRotate = false

            local look = aimTargetPos - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)

            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
                local yawRate = math.clamp(math.rad(yawDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
                local pitchRate = math.clamp(math.rad(pitchDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
                local yawRad = math.rad(root.Orientation.Y)
                local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
            else
                root.AssemblyAngularVelocity = Vector3.zero
            end

            local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
            local standPos = aimTargetPos - (dir * AUTO_BAT_DIST) + Vector3.new(0, AUTO_BAT_HEIGHT, 0)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * AUTO_BAT_SPEED or Vector3.zero
            local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_VERT_SPEED, 0) or Vector3.new(0, -2, 0)
            root.AssemblyLinearVelocity = hVel + vVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end

            if autoSwingEnabled and (root.Position - target.Position).Magnitude < 6 then
                local bat = findBat() or batTool
                if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
            end
        else
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

local function stopBatAimbot()
    if autoBatConnection then autoBatConnection:Disconnect(); autoBatConnection = nil end
    resetAutoBatMotion()
    autoBatEquipped = false
    _autoBatTarget = nil
end

local function enableAutoBat()
    if autoBatEnabled then return end
    autoBatEnabled = true
    if S and S.autoLeftEnabled then
        S.autoLeftEnabled = false
        if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
        if stopAutoLeft then stopAutoLeft() end
    end
    if S and S.autoRightEnabled then
        S.autoRightEnabled = false
        if S.autoRightSetVisual then S.autoRightSetVisual(false) end
        if stopAutoRight then stopAutoRight() end
    end
    startBatAimbot()
    if autoBatSetVisual then autoBatSetVisual(true) end
    if S and S._setPButtonActive and S._btnBAT then
        S._setPButtonActive(S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT, true)
    end
end

local function disableAutoBat()
    if not autoBatEnabled then return end
    autoBatEnabled = false
    stopBatAimbot()
    if autoBatSetVisual then autoBatSetVisual(false) end
    if S and S._setPButtonActive and S._btnBAT then
        S._setPButtonActive(S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT, false)
    end
end
-- =========================== FIN BAT AIMBOT ===========================    
    
-- ==================== RESTO DEL SCRIPT (VELOCIDAD, STEAL, ETC) ====================    
local removedAccessories = {}    
local function removeCharacterAccessories()    
    local char = LP.Character    
    if not char then return end    
    for _, child in ipairs(char:GetChildren()) do    
        if (child:IsA("Accessory") or child:IsA("Hat")) and not child:IsA("Tool") then    
            table.insert(removedAccessories, {parent = child.Parent, acc = child})    
            child.Parent = nil    
        end    
    end    
end    
    
local function restoreAccessories()    
    for _, item in ipairs(removedAccessories) do    
        if item.acc and not item.acc.Parent then    
            item.acc.Parent = item.parent    
        end    
    end    
    removedAccessories = {}    
end    
    
local function updateGalaxy()    
    if galaxyOn then    
        local sky = Lighting:FindFirstChild("NewEraGalaxySky") or Instance.new("Sky")    
        sky.Name = "NewEraGalaxySky"    
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp =    
            "rbxassetid://159454299","rbxassetid://159454296","rbxassetid://159454293",    
            "rbxassetid://159454286","rbxassetid://159454289","rbxassetid://159454291"    
        sky.Parent = Lighting    
        Lighting.Brightness, Lighting.ClockTime, Lighting.ExposureCompensation = 0, 0, -2    
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)    
    else    
        if Lighting:FindFirstChild("NewEraGalaxySky") then Lighting.NewEraGalaxySky:Destroy() end    
        Lighting.Brightness, Lighting.ClockTime, Lighting.ExposureCompensation = defBrightness, defClock, 0    
        Lighting.OutdoorAmbient = defAmbient    
    end    
end    
    
local function toggleGalaxyMode()    
    galaxyOn = not galaxyOn    
    updateGalaxy()    
end    
    
local function safeWritefile(path, data) if type(writefile) == "function" then pcall(writefile, path, data) end end    
local function safeReadfile(path) if type(readfile) == "function" then local ok, data = pcall(readfile, path) return ok and data or nil end return nil end    
local function safeIsfile(path) if type(isfile) == "function" then local ok, res = pcall(isfile, path) return ok and res end return false end    
    
local antiLagEnabled = false    
local removeAccessoriesEnabled = false    
local antiLagDescConn = nil    
local defLightBrightness, defLightClock, defLightAmbient    
    
local function applyAntiLagDerender(obj)    
    pcall(function()    
        if obj:IsA("Accessory") or obj:IsA("Hat") then    
            obj:Destroy()    
        elseif obj:IsA("BasePart") then    
            obj.Material = Enum.Material.Plastic    
            obj.Reflectance = 0    
            obj.CastShadow = false    
        elseif obj:IsA("Decal") or obj:IsA("Texture") then    
            obj.Transparency = 1    
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then    
            obj.Enabled = false    
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then    
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end    
        end    
    end)    
end    
    
local function enableAntiLag()    
    if antiLagEnabled then return end    
    removeAccessoriesEnabled = true    
    antiLagEnabled = true    
    defLightBrightness = defLightBrightness or Lighting.Brightness    
    defLightClock = defLightClock or Lighting.ClockTime    
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient    
    Lighting.GlobalShadows = false    
    Lighting.FogEnd = 1e10    
    Lighting.Brightness = 1    
    Lighting.EnvironmentDiffuseScale = 0    
    Lighting.EnvironmentSpecularScale = 0    
    for _, e in pairs(Lighting:GetChildren()) do    
        pcall(function()    
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then    
                e.Enabled = false    
            end    
        end)    
    end    
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end    
    if antiLagDescConn then antiLagDescConn:Disconnect() end    
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)    
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end    
    end)    
end    
    
local function disableAntiLag()    
    if not antiLagEnabled then return end    
    removeAccessoriesEnabled = false    
    antiLagEnabled = false    
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end    
    pcall(function()    
        if defLightBrightness then Lighting.Brightness = defLightBrightness end    
        if defLightClock then Lighting.ClockTime = defLightClock end    
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end    
    end)    
end    
    
local speedLabel = nil    
    
local function setupCursedSpeedBillboard(char)    
    local head = char:WaitForChild("Head", 5)    
    if not head then return end    
    local oldBB = head:FindFirstChild("NewEraSpeedBB")    
    if oldBB then oldBB:Destroy() end    
    local bb = Instance.new("BillboardGui", head)    
    bb.Name = "NewEraSpeedBB"    
    bb.Size = UDim2.new(0, 120, 0, 40)    
    bb.StudsOffset = Vector3.new(0, 3, 0)    
    bb.AlwaysOnTop = true    
    speedLabel = Instance.new("TextLabel", bb)    
    speedLabel.Size = UDim2.new(1, 0, 1, 0)    
    speedLabel.BackgroundTransparency = 1    
    speedLabel.Text = "Speed: 0.0"    
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)    
    speedLabel.Font = Enum.Font.GothamBold    
    speedLabel.TextScaled = true    
    speedLabel.TextStrokeTransparency = 0.3    
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)    
end    
    
-- ==================== ESTRUCTURA PRINCIPAL S ====================    
local S = {    
    NS1 = 60, CS1 = 30,    
    NS2 = 80, CS2 = 50,    
    NS3 = 100, CS3 = 70,    
    normalPreset = 1,    
    LS1 = 15,    
    LS2 = 10,    
    laggerMode = 0,    
    speedMode = false,    
    antiRagdollEnabled = false, infJumpEnabled = false, medusaCounterEnabled = false,    
    medusaDebounce = false, medusaLastUsed = 0, medusaConns = {}, MEDUSA_COOLDOWN = 25,    
    medusaAutoResetEnabled = false, medusaAutoResetConns = {},    
    unwalkEnabled = false,    
    autoLeftEnabled = false, autoRightEnabled = false,    
    autoLeftSetVisual = nil, autoRightSetVisual = nil,    
    _btnAAL = nil, _bsAAL = nil, _l1AAL = nil, _l2AAL = nil,    
    _btnAAR = nil, _bsAAR = nil, _l1AAR = nil, _l2AAR = nil,    
    _btnBAT = nil, _bsBAT = nil, _l1BAT = nil, _l2BAT = nil,    
    _setPButtonActive = nil, speedCounterLabel = nil,    
    batCounterEnabled = false, batCounterConn = nil, batCounterDebounce = false,    
    setBatCounterVisual = nil,    
    lockUIEnabled = false,    
    mainMenuFrame = nil, miniToggleButton = nil, floatingPanelFrame = nil, floatingPanelGui = nil,    
    _noclipTimer = 0, _fpsCount = 0, _lastFpsTime = tick(), currentFPS = 0,    
    alConn = nil, arConn = nil, alPhase = 1, arPhase = 1,    
    progressFill = nil, progressPct = nil, progressBarFrame = nil, topBarHUD = nil,    
    stealActive = false,    
    setLaggerVisual = nil, speedClk = nil, setInfJumpVisual = nil,    
    setAntiRagVisual = nil, setMedusaVisual = nil,    
    setUnwalkVisual = nil, setDarkVisual = nil, setInstaGrab = nil,    
    normalBox1 = nil, carryBox1 = nil,    
    normalBox2 = nil, carryBox2 = nil,    
    normalBox3 = nil, carryBox3 = nil,    
    laggerBox1 = nil, laggerBox2 = nil,    
    radInput = nil, setLockUI_Visual = nil, setHideOpiumButtons = nil,    
    holdJumpEnabled = false, holdJumpConn = nil, setHoldJumpVisual = nil,    
    autoTPDownEnabled = false, autoTPDownThreshold = 20, autoTPDownConn = nil,    
    autoTPDownSetVisual = nil, autoTPDownFloatVisual = nil,    
    autoTPDownThresholdBox = nil,    
    stealDurationBox = nil,    
    dropBrainrotActive = false, dropBrainrotVersion = 1, tpDownVersion = 1, floatingButtonsLayout = "grid",    
    autoStealRadius = 60.0,    
    autoStealDuration = 1.4,    
    KB = {    
        DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},    
        AutoLeft = {kb = Enum.KeyCode.Z, gp = nil},    
        AutoRight = {kb = Enum.KeyCode.C, gp = nil},    
        AutoBat = {kb = Enum.KeyCode.E, gp = nil},    
        TPFlor = {kb = Enum.KeyCode.F, gp = nil},    
        GuiHide = {kb = Enum.KeyCode.H, gp = nil},    
        SpeedToggle = {kb = Enum.KeyCode.Q, gp = nil},    
        LaggerToggle = {kb = Enum.KeyCode.R, gp = nil},    
        AutoTPDown = {kb = Enum.KeyCode.T, gp = nil},    
        SpeedMode1 = {kb = Enum.KeyCode.A, gp = nil},    
        SpeedMode2 = {kb = Enum.KeyCode.O, gp = nil},    
        SpeedMode3 = {kb = Enum.KeyCode.W, gp = nil},    
        LaggerMode1 = {kb = Enum.KeyCode.L, gp = nil},    
        LaggerMode2 = {kb = Enum.KeyCode.Y, gp = nil},    
    },    
    AP = {    
        L1 = Vector3.new(-476.48, -6.28, 92.73), L2 = Vector3.new(-483.12, -4.95, 94.80),    
        R1 = Vector3.new(-476.16, -6.52, 25.62), R2 = Vector3.new(-483.04, -5.09, 23.14),    
    },    
    Conns = {antiRag = nil, anchor = {}, progress = nil},    
    moveConn = nil, speedEnabled = true, h = nil, hrp = nil,    
    lastMoveDir = Vector3.new(0,0,0),    
    MOVE_KEYS = {    
        [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,    
        [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,    
        [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,    
        [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,    
    },    
    IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled,    
    CONFIG_FILE = "NewEraHubPC.json",    
    _floatingButtons = {},    
    BAT_HIT_RANGE = 24,    
    autoTPDownCooldownUntil = 0,    
    _holdJumpCooldownUntil = 0,    
    speedPanelFrame = nil,    
    speedPanelActive = nil,    
    _configLoaded = false,    
    _keyButtons = {},    
    leanEnabled = false,    
    leanConn = nil,    
    LEAN_INTENSITY = 0.08,    
    LEAN_SMOOTH = 0.25,    
}    
    
S.getCurrentSpeed = function()    
    if S.laggerMode ~= 0 then    
        if S.speedMode then    
            if S.laggerMode == 1 then return S.CS1 * (S.LS1 / S.NS1)    
            else return S.CS2 * (S.LS2 / S.NS2) end    
        else    
            if S.laggerMode == 1 then return S.LS1    
            else return S.LS2 end    
        end    
    end    
    if S.speedMode then    
        if S.normalPreset == 1 then return S.CS1    
        elseif S.normalPreset == 2 then return S.CS2    
        else return S.CS3 end    
    else    
        if S.normalPreset == 1 then return S.NS1    
        elseif S.normalPreset == 2 then return S.NS2    
        else return S.NS3 end    
    end    
end    
    
S.getAutoMoveSpeed = function()    
    if S.normalPreset == 1 then return S.NS1    
    elseif S.normalPreset == 2 then return S.NS2    
    else return S.NS3 end    
end    
    
S.startMovement = function()    
    if S.moveConn then S.moveConn:Disconnect() end    
    S.moveConn = RunService.RenderStepped:Connect(function()    
        local char = LP.Character    
        if not char then return end    
        local h = char:FindFirstChildOfClass("Humanoid")    
        local hrp = char:FindFirstChild("HumanoidRootPart")    
        if not (h and hrp) then return end    

        if S.speedEnabled and not (autoBatEnabled or S.autoLeftEnabled or S.autoRightEnabled) then    
            local md = h.MoveDirection    
            local spd = S.getCurrentSpeed()    
            if md.Magnitude > 0 then    
                S.lastMoveDir = md    
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)    
            elseif S.antiRagdollEnabled and S.lastMoveDir.Magnitude > 0 then    
                local anyHeld = false    
                for key in pairs(S.MOVE_KEYS) do    
                    if UIS:IsKeyDown(key) then anyHeld = true; break end    
                end    
                if anyHeld then    
                    hrp.Velocity = Vector3.new(S.lastMoveDir.X * spd, hrp.Velocity.Y, S.lastMoveDir.Z * spd)    
                end    
            end    
        end    

        if speedLabel then    
            speedLabel.Text = string.format("Speed: %.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)    
        end    
    end)    
end    
    
S.stopMovement = function()    
    if S.moveConn then S.moveConn:Disconnect(); S.moveConn = nil end    
end    
    
S.restartMovement = function() S.stopMovement(); S.startMovement() end    
S.speedEnabled = true    
S.startMovement()    
    
-- ==================== RESTO DE FUNCIONES (AUTO LEFT, RIGHT, STEAL, ETC) ====================    
-- ================= TP DOWN MEJORADO =================
local function applyTPDown(sinkAmount, forwardForce)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local oldHealth = hum.Health

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
    if not ray then return end

    local groundY = ray.Position.Y
    local offset = (hum.HipHeight or 2) + (hrp.Size.Y / 2) - sinkAmount
    local targetY = groundY + offset

    hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, targetY, hrp.Position.Z))
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    hrp.AssemblyLinearVelocity = Vector3.new(0, 20, 0)
    task.wait(0.05)

    local forwardDir = hrp.CFrame.LookVector
    hrp.AssemblyLinearVelocity = Vector3.new(forwardDir.X * forwardForce, hrp.AssemblyLinearVelocity.Y, forwardDir.Z * forwardForce)

    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    task.wait(0.05)
    if hum and hum.Health < oldHealth then
        hum.Health = oldHealth
    end
end

local function startAutoTPDown()
    if S.autoTPDownConn then S.autoTPDownConn:Disconnect() end
    S.autoTPDownConn = RunService.RenderStepped:Connect(function()
        if not S.autoTPDownEnabled then return end
        if autoLeftEnabled or autoRightEnabled or autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if hrp.Position.Y >= S.autoTPDownThreshold then
            applyTPDown(0.8, S.tpDownVersion == 2 and 0 or 45)
        end
    end)
end

local function stopAutoTPDown()
    if S.autoTPDownConn then S.autoTPDownConn:Disconnect(); S.autoTPDownConn = nil end
end
-- =====================================================
    
local saveConfiEnabled = true -- Controlado por el toggle "Save Config" en la pestaña Config

local function saveConfig()    
    if not saveConfiEnabled then return end
    if not S._configLoaded then return end
    pcall(function()    
        local function ks(e)    
            return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}    
        end    
        local cfg = {    
            normalSpeed1 = S.NS1, carrySpeed1 = S.CS1,    
            normalSpeed2 = S.NS2, carrySpeed2 = S.CS2,    
            normalSpeed3 = S.NS3, carrySpeed3 = S.CS3,    
            normalPreset = S.normalPreset,    
            laggerSpeed1 = S.LS1, laggerSpeed2 = S.LS2,    
            laggerMode = S.speedMode and 0 or S.laggerMode,    
            dropBrainrotKey = ks(S.KB.DropBrainrot), autoLeftKey = ks(S.KB.AutoLeft),    
            autoRightKey = ks(S.KB.AutoRight), autoBatKey = ks(S.KB.AutoBat),    
            tpFloorKey = ks(S.KB.TPFlor), guiHideKey = ks(S.KB.GuiHide),    
            speedToggleKey = ks(S.KB.SpeedToggle), laggerToggleKey = ks(S.KB.LaggerToggle),    
            grabRadius = S.autoStealRadius, antiRagdoll = S.antiRagdollEnabled,    
            autoStealEnabled = S.stealActive, infiniteJump = S.infJumpEnabled,    
            medusaCounter = S.medusaCounterEnabled, carryMode = S.speedMode,    
            autoBat = autoBatEnabled, autoSwing = autoSwingEnabled,    
            unwalkEnabled = S.unwalkEnabled,    
            lockUI = S.lockUIEnabled,    
            hideOpiumButtons = S.hideOpiumButtonsEnabled or false,    
            holdJumpEnabled = S.holdJumpEnabled,    
            autoTPDownEnabled = S.autoTPDownEnabled, autoTPDownThreshold = S.autoTPDownThreshold,    
            autoTPDownKey = ks(S.KB.AutoTPDown),    
            batCounter = S.batCounterEnabled,    
            stealDuration = S.autoStealDuration,    
            galaxyMode = galaxyOn,    
            speedMode1Key = ks(S.KB.SpeedMode1),    
            speedMode2Key = ks(S.KB.SpeedMode2),    
            speedMode3Key = ks(S.KB.SpeedMode3),    
            laggerMode1Key = ks(S.KB.LaggerMode1),    
            laggerMode2Key = ks(S.KB.LaggerMode2),    
            antiLag = antiLagEnabled,
            medusaAutoResetEnabled = S.medusaAutoResetEnabled,    
        }    
        if S.floatingPanelFrame then
            cfg.floatingPanelPos = {
                XScale  = S.floatingPanelFrame.Position.X.Scale,
                XOffset = S.floatingPanelFrame.Position.X.Offset,
                YScale  = S.floatingPanelFrame.Position.Y.Scale,
                YOffset = S.floatingPanelFrame.Position.Y.Offset,
            }
        end
        if S.speedPanelFrames then
            cfg.speedPanelPositions = {}
            for i = 1, 3 do
                local f = S.speedPanelFrames[i]
                if f then
                    cfg.speedPanelPositions[i] = {
                        XScale  = f.Position.X.Scale,
                        XOffset = f.Position.X.Offset,
                        YScale  = f.Position.Y.Scale,
                        YOffset = f.Position.Y.Offset,
                    }
                end
            end
        end
        if instaResetFloatingPos then
            cfg.instaResetFloatingPos = instaResetFloatingPos
        end
        if aimbotBypassFloatingPos then
            cfg.aimbotBypassFloatingPos = aimbotBypassFloatingPos
        end    
        local data = HS:JSONEncode(cfg)    
        safeWritefile(S.CONFIG_FILE, data)    
    end)    
end    
    
task.spawn(function()
    repeat task.wait(0.5) until S._configLoaded
    while task.wait(5) do    
        saveConfig()    
    end    
end)    
    
local function startLeaning()    
    if S.leanConn then return end    
    S.leanEnabled = true    
    S.leanConn = RunService.RenderStepped:Connect(function()    
        if not S.leanEnabled or autoBatEnabled then return end    
        local char = LP.Character    
        if not char then return end    
        local hrp = char:FindFirstChild("HumanoidRootPart")    
        local hum = char:FindFirstChildOfClass("Humanoid")    
        if not hrp or not hum then return end    
        local vel = hrp.AssemblyLinearVelocity    
        local rightVel = hrp.CFrame:VectorToObjectSpace(vel).X    
        local forwardVel = hrp.CFrame:VectorToObjectSpace(vel).Z    
        local leanAngle = math.clamp(rightVel / 35, -0.45, 0.45)    
        local forwardLean = math.clamp(forwardVel / 50, 0, 0.2)    
        local rootJoint = hrp:FindFirstChild("RootJoint")    
        if not rootJoint then    
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")    
            if torso then rootJoint = torso:FindFirstChild("Root") end    
        end    
        if rootJoint then    
            if not rootJoint:GetAttribute("OriginalC0") then    
                rootJoint:SetAttribute("OriginalC0", rootJoint.C0)    
            end    
            local originalC0 = rootJoint:GetAttribute("OriginalC0")    
            local newC0 = originalC0 * CFrame.Angles(forwardLean, 0, leanAngle)    
            rootJoint.C0 = rootJoint.C0:Lerp(newC0, S.LEAN_SMOOTH)    
        end    
    end)    
end    
    
local function stopLeaning()    
    S.leanEnabled = false    
    if S.leanConn then    
        S.leanConn:Disconnect()    
        S.leanConn = nil    
    end    
    local char = LP.Character    
    if char then    
        local hrp = char:FindFirstChild("HumanoidRootPart")    
        if hrp then    
            local rootJoint = hrp:FindFirstChild("RootJoint")    
            if not rootJoint then    
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")    
                if torso then rootJoint = torso:FindFirstChild("Root") end    
            end    
            if rootJoint and rootJoint:GetAttribute("OriginalC0") then    
                rootJoint.C0 = rootJoint:GetAttribute("OriginalC0")    
            end    
        end    
    end    
end    
    
local function updateLaggerButtonVisual()    
    local fb = S._floatingButtons    
    if not fb or not fb.lagger then return end    
    local active = S.laggerMode == 1 and not S.speedMode    
    fb.l2Lagger.Text = "1"    
    S._setPButtonActive(fb.lagger, fb.strokeLagger, fb.l1Lagger, fb.l2Lagger, active)    
    if fb.laggerSpeed2 then    
        S._setPButtonActive(fb.laggerSpeed2, fb.strokeLaggerSpeed2, fb.l1LaggerSpeed2, fb.l2LaggerSpeed2, S.laggerMode == 2 and not S.speedMode)    
    end    
end    
    
local DROP_ASCEND_DURATION = 0.2    
local DROP_ASCEND_SPEED = 150    
    
local function runDropBrainrot()    
    if S.dropBrainrotActive then return end    
    local char = LP.Character    
    if not char then return end    
    local root = char:FindFirstChild("HumanoidRootPart")    
    if not root then return end    
    S.dropBrainrotActive = true    
    local startTime = tick()    
    local conn    
    conn = RunService.Heartbeat:Connect(function()    
        local r = char and char:FindFirstChild("HumanoidRootPart")    
        if not r then conn:Disconnect(); S.dropBrainrotActive = false; return end    
        if tick() - startTime >= DROP_ASCEND_DURATION then    
            conn:Disconnect()    
            local raycastParams = RaycastParams.new()    
            raycastParams.FilterDescendantsInstances = {char}    
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude    
            local rayResult = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), raycastParams)    
            if rayResult then    
                local hum = char:FindFirstChildOfClass("Humanoid")    
                local offset = (hum and hum.HipHeight or 2) + (r.Size.Y / 2)    
                r.CFrame = CFrame.new(r.Position.X, rayResult.Position.Y + offset, r.Position.Z)    
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)    
            end    
            S.dropBrainrotActive = false    
            return    
        end    
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)    
    end)    
end    
    
local function runDropBrainrotV2()    
    if S.dropBrainrotActive then return end    
    local char = LP.Character    
    local root = char and char:FindFirstChild("HumanoidRootPart")    
    if not char or not root then return end    
    local hum = char:FindFirstChildOfClass("Humanoid")    
    if hum then    
        pcall(function() root.Anchored = false end)    
        pcall(function() hum.PlatformStand = false end)    
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)    
    end    
    S.dropBrainrotActive = true    
    local changedCollisions = {}    
    local _conns = {}    
    local function cleanup()    
        S.dropBrainrotActive = false    
        for _, c in ipairs(_conns) do    
            if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end)    
            elseif type(c) == "thread" then pcall(coroutine.close, c) end    
        end    
        _conns = {}    
        for part, wasCollide in pairs(changedCollisions) do    
            if typeof(part) == "Instance" and part.Parent then    
                pcall(function() part.CanCollide = wasCollide end)    
            end    
        end    
    end    
    local colConn = RunService.Stepped:Connect(function()    
        if not S.dropBrainrotActive then return end    
        for _, p in ipairs(Players:GetPlayers()) do    
            if p ~= LP and p.Character then    
                for _, part in ipairs(p.Character:GetDescendants()) do    
                    if part:IsA("BasePart") then    
                        if changedCollisions[part] == nil then changedCollisions[part] = part.CanCollide end    
                        pcall(function() part.CanCollide = false end)    
                    end    
                end    
            end    
        end    
    end)    
    table.insert(_conns, colConn)    
    local flingThread = coroutine.create(function()    
        while S.dropBrainrotActive do    
            RunService.Heartbeat:Wait()    
            local c = LP.Character    
            local r = c and c:FindFirstChild("HumanoidRootPart")    
            if not r then break end    
            pcall(function() r.Anchored = false end)    
            local vel = r.Velocity    
            pcall(function() r.Velocity = vel * 10000 + Vector3.new(0, 10000, 0) end)    
            RunService.RenderStepped:Wait()    
            if r and r.Parent then pcall(function() r.Velocity = vel end) end    
            RunService.Stepped:Wait()    
            if r and r.Parent then pcall(function() r.Velocity = vel + Vector3.new(0, 0.1, 0) end) end    
        end    
    end)    
    table.insert(_conns, flingThread)    
    local ok = coroutine.resume(flingThread)    
    if not ok then cleanup(); return end    
    task.delay(0.25, cleanup)    
end    
    
local function runDrop()    
    if S.dropBrainrotVersion == 2 then runDropBrainrotV2() else runDropBrainrot() end    
end    
    
local function startHoldJump()    
    if S.holdJumpConn then S.holdJumpConn:Disconnect() end    
    S.holdJumpConn = RunService.Heartbeat:Connect(function()    
        if not S.holdJumpEnabled then return end    
        if tick() < S._holdJumpCooldownUntil then return end    
        local char = LP.Character    
        if not char then return end    
        local hum = char:FindFirstChildOfClass("Humanoid")    
        local root = char:FindFirstChild("HumanoidRootPart")    
        if hum and root and hum.Health > 0 then    
            local isJumping = false    
            pcall(function() isJumping = UIS:IsKeyDown(Enum.KeyCode.Space) or hum.Jump end)    
            if isJumping then    
                root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)    
            end    
        end    
    end)    
end    
    
local function stopHoldJump()    
    if S.holdJumpConn then S.holdJumpConn:Disconnect(); S.holdJumpConn = nil end    
end    
    
local startInfiniteJump    
local stopInfiniteJump    
    
local function resetFloatingPanel()    
    if S.floatingPanelFrame then    
        S.floatingPanelFrame.Position = UDim2.new(1, -158, 0.5, -130)    
        saveConfig()    
    end    
    if S.speedPanelFrames then    
        local defaults = {{x=10,y=-60},{x=10,y=-18},{x=10,y=24}}    
        for i = 1, 3 do    
            if S.speedPanelFrames[i] then    
                S.speedPanelFrames[i].Position = UDim2.new(0, defaults[i].x, 0.5, defaults[i].y)    
            end    
        end    
        saveConfig()    
    end    
    if S.instaResetBtnFrame then    
        S.instaResetBtnFrame.Position = UDim2.new(1, -80, 0.85, 0)    
        instaResetFloatingPos = nil    
        saveConfig()    
    end    
    if S.aimbotBypassBtnFrame then    
        S.aimbotBypassBtnFrame.Position = UDim2.new(1, -150, 0.85, 0)    
        aimbotBypassFloatingPos = nil    
        saveConfig()    
    end    
end    
    
local function resetProgressBar()    
    if S.progressPct then S.progressPct.Text = "IDLE" end    
    -- if S.progressFill then S.progressFill.Size = UDim2.new(0,0,1,0) end    
end    
    
-- ==========================================
-- ANTI-RAGDOLL SYSTEM (OPTIMIZED)
-- ==========================================
local function isCharacterRagdolled(hum)    
    if not hum then return false end    
    local st = hum:GetState()    
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then    
        return true    
    end    
    local endTime = LP:GetAttribute("RagdollEndTime")    
    if endTime then    
        local now = workspace:GetServerTimeNow()    
        if (endTime - now) > 0 then return true end    
    end    
    return false    
end    
    
local function removeRagdollConstraints(char)    
    if not char then return end    
    for _, descendant in ipairs(char:GetDescendants()) do    
        if descendant:IsA("BallSocketConstraint") or (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then    
            pcall(function() descendant:Destroy() end)    
        end    
    end    
end    
    
local function startAntiRagdoll()    
    if S.Conns.antiRag then return end    
    S.Conns.antiRag = RunService.Heartbeat:Connect(function()    
        if not S.antiRagdollEnabled then return end    
        local char = LP.Character    
        if not char then return end    
        local root = char:FindFirstChild("HumanoidRootPart")    
        local hum = char:FindFirstChildOfClass("Humanoid")    
        if not hum or not root then return end    
    
        if isCharacterRagdolled(hum) then    
            pcall(function()    
                local now = workspace:GetServerTimeNow()    
                LP:SetAttribute("RagdollEndTime", now)    
            end)    
            removeRagdollConstraints(char)    
            if hum.Health > 0 then    
                hum:ChangeState(Enum.HumanoidStateType.Running)    
            end    
            root.Velocity = Vector3.new(0,0,0)    
            root.RotVelocity = Vector3.new(0,0,0)    
            pcall(function()    
                local pm = LP.PlayerScripts:FindFirstChild("PlayerModule")    
                if pm then require(pm:FindFirstChild("ControlModule")):Enable() end    
            end)    
        end    
    
        if workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject ~= hum then    
            workspace.CurrentCamera.CameraSubject = hum    
        end    
    
        for _, obj in ipairs(char:GetDescendants()) do    
            if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled = true end    
        end    
    end)    
end    
    
local function stopAntiRagdoll()    
    if S.Conns.antiRag then S.Conns.antiRag:Disconnect(); S.Conns.antiRag = nil end    
end    
    
local function toggleAntiRag(on)    
    S.antiRagdollEnabled = on    
    if on then startAntiRagdoll() else stopAntiRagdoll() end    
end    
    
startInfiniteJump = function()    
    if S.IJ_JumpConn then S.IJ_JumpConn:Disconnect() end    
    if S.IJ_HeartbeatConn then S.IJ_HeartbeatConn:Disconnect() end    
    S.IJ_JumpConn = UIS.JumpRequest:Connect(function()    
        if not S.infJumpEnabled then return end    
        local char = LP.Character    
        local hrp = char and char:FindFirstChild("HumanoidRootPart")    
        if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z) end    
    end)    
    S.IJ_HeartbeatConn = RunService.Heartbeat:Connect(function()    
        if not S.infJumpEnabled then return end    
        local char = LP.Character    
        if not char then return end    
        local hrp = char:FindFirstChild("HumanoidRootPart")    
        if not hrp then return end    
        if hrp.Velocity.Y < -80 then    
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -80, hrp.Velocity.Z)    
        end    
    end)    
end    
    
stopInfiniteJump = function()    
    if S.IJ_JumpConn then S.IJ_JumpConn:Disconnect(); S.IJ_JumpConn = nil end    
    if S.IJ_HeartbeatConn then S.IJ_HeartbeatConn:Disconnect(); S.IJ_HeartbeatConn = nil end    
end    
    
local savedAnimate = nil    
local defaultAnimateCopy = nil    
    
local function startUnwalk()    
    local c = LP.Character    
    if not c then return end    
    local hum = c:FindFirstChildOfClass("Humanoid")    
    if hum then    
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end    
    end    
    local anim = c:FindFirstChild("Animate")    
    if anim then    
        if not savedAnimate then savedAnimate = anim:Clone() end    
        anim:Destroy()    
    end    
    S.unwalkEnabled = true    
    startLeaning()    
end    
    
local function stopUnwalk()    
    if not S.unwalkEnabled then return end    
    S.unwalkEnabled = false    
    local c = LP.Character    
    if c and savedAnimate then    
        local existing = c:FindFirstChild("Animate")    
        if existing and existing ~= savedAnimate then existing:Destroy() end    
        savedAnimate.Parent = c    
        savedAnimate.Disabled = false    
        savedAnimate = nil    
    end    
    stopLeaning()    
end    
    
local POS = S.AP    
    
function startAutoLeft()    
    if S.alConn then S.alConn:Disconnect() end    
    S.alPhase = 1    
    S.alConn = RunService.Heartbeat:Connect(function()    
        if not S.autoLeftEnabled then return end    
        local c = LP.Character; if not c then return end    
        local root = c:FindFirstChild("HumanoidRootPart")    
        local hum = c:FindFirstChildOfClass("Humanoid")    
        if not root or not hum then return end    
        local spd = S.getAutoMoveSpeed()    
        if S.alPhase == 1 then    
            local tgt = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)    
            if (tgt - root.Position).Magnitude < 1 then S.alPhase = 2; return end    
            local d = (POS.L1 - root.Position)    
            local mv = Vector3.new(d.X, 0, d.Z).Unit    
            hum:Move(mv, false)    
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)    
        elseif S.alPhase == 2 then    
            local tgt = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)    
            if (tgt - root.Position).Magnitude < 1 then    
                hum:Move(Vector3.zero, false)    
                root.Velocity = Vector3.new(0, root.Velocity.Y, 0)    
                S.autoLeftEnabled = false    
                if S.alConn then S.alConn:Disconnect(); S.alConn = nil end    
                S.alPhase = 1    
                if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end    
                if S._setPButtonActive and S._btnAAL then    
                    S._setPButtonActive(S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL, false)    
                end    
                task.defer(S.startMovement)    
                return    
            end    
            local d = (POS.L2 - root.Position)    
            local mv = Vector3.new(d.X, 0, d.Z).Unit    
            hum:Move(mv, false)    
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)    
        end    
    end)    
end    
    
function stopAutoLeft()    
    if S.alConn then S.alConn:Disconnect(); S.alConn = nil end    
    S.alPhase = 1    
    local c = LP.Character    
    if c then    
        local hum = c:FindFirstChildOfClass("Humanoid")    
        if hum then hum:Move(Vector3.zero, false) end    
        local root = c:FindFirstChild("HumanoidRootPart")    
        if root then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end    
    end    
    S.autoLeftEnabled = false    
    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end    
end    
    
function startAutoRight()    
    if S.arConn then S.arConn:Disconnect() end    
    S.arPhase = 1    
    S.arConn = RunService.Heartbeat:Connect(function()    
        if not S.autoRightEnabled then return end    
        local c = LP.Character; if not c then return end    
        local root = c:FindFirstChild("HumanoidRootPart")    
        local hum = c:FindFirstChildOfClass("Humanoid")    
        if not root or not hum then return end    
        local spd = S.getAutoMoveSpeed()    
        if S.arPhase == 1 then    
            local tgt = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)    
            if (tgt - root.Position).Magnitude < 1 then S.arPhase = 2; return end    
            local d = (POS.R1 - root.Position)    
            local mv = Vector3.new(d.X, 0, d.Z).Unit    
            hum:Move(mv, false)    
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)    
        elseif S.arPhase == 2 then    
            local tgt = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)    
            if (tgt - root.Position).Magnitude < 1 then    
                hum:Move(Vector3.zero, false)    
                root.Velocity = Vector3.new(0, root.Velocity.Y, 0)    
                S.autoRightEnabled = false    
                if S.arConn then S.arConn:Disconnect(); S.arConn = nil end    
                S.arPhase = 1    
                if S.autoRightSetVisual then S.autoRightSetVisual(false) end    
                if S._setPButtonActive and S._btnAAR then    
                    S._setPButtonActive(S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR, false)    
                end    
                task.defer(S.startMovement)    
                return    
            end    
            local d = (POS.R2 - root.Position)    
            local mv = Vector3.new(d.X, 0, d.Z).Unit    
            hum:Move(mv, false)    
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)    
        end    
    end)    
end    
    
function stopAutoRight()    
    if S.arConn then S.arConn:Disconnect(); S.arConn = nil end    
    S.arPhase = 1    
    local c = LP.Character    
    if c then    
        local hum = c:FindFirstChildOfClass("Humanoid")    
        if hum then hum:Move(Vector3.zero, false) end    
        local root = c:FindFirstChild("HumanoidRootPart")    
        if root then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end    
    end    
    S.autoRightEnabled = false    
    if S.autoRightSetVisual then S.autoRightSetVisual(false) end    
end    
    
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}    
    
local function findBatForCounter()    
    local c = LP.Character; if not c then return nil end    
    local bp = LP:FindFirstChildOfClass("Backpack")    
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do    
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))    
        if t then return t end    
    end    
    for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end    
    if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end    
    return nil    
end    
    
local function swingBatForCounter(bat, char)    
    local hum2 = char:FindFirstChildOfClass("Humanoid")    
    if bat.Parent ~= char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.03) end    
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")    
    if remote and remote:IsA("RemoteEvent") then    
        pcall(function() remote:FireServer() end); task.wait(0.05); pcall(function() remote:FireServer() end)    
    else pcall(function() bat:Activate() end); task.wait(0.05); pcall(function() bat:Activate() end) end    
end    
    
local function startBatCounter()    
    if S.batCounterConn then S.batCounterConn:Disconnect() end    
    S.batCounterConn = RunService.Heartbeat:Connect(function()    
        if not S.batCounterEnabled then return end    
        if S.batCounterDebounce then return end    
        local char = LP.Character; if not char then return end    
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end    
        local st = hum:GetState()    
        local isRagged = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown    
        if isRagged then    
            S.batCounterDebounce = true    
            task.spawn(function()    
                local bat = findBatForCounter()    
                if bat then swingBatForCounter(bat, char) end    
                task.wait(0.1)    
                S.batCounterDebounce = false    
            end)    
        end    
    end)    
end    
    
local function stopBatCounter()    
    if S.batCounterConn then S.batCounterConn:Disconnect(); S.batCounterConn = nil end    
    S.batCounterDebounce = false    
end    
    
local function isHoldingAnimalOrBrainrot()    
    local char = LP.Character    
    if not char then return false end    
    local tool = char:FindFirstChildOfClass("Tool")    
    if tool then    
        local name = tool.Name:lower()    
        if name:find("animal") or name:find("brainrot") or name:find("egg")    
           or name:find("chicken") or name:find("cow") or name:find("pig") then    
            return true    
        end    
    end    
    local hum = char:FindFirstChildOfClass("Humanoid")    
    if hum and hum.WalkSpeed < 25 then return true end    
    return false    
end    
    
local function autoActivateCarryIfHoldingAnimal()    
    if S.laggerMode ~= 0 then return end    
    if isHoldingAnimalOrBrainrot() and not S.speedMode then    
        S.speedMode = true    
        if S.speedClk then S.speedClk(true) end    
        refreshFloatingButtonsVisual()    
    end    
end    
    
local function findMedusa()    
    local char = LP.Character    
    if not char then return nil end    
    for _, tool in ipairs(char:GetChildren()) do    
        if tool:IsA("Tool") then    
            local name = tool.Name:lower()    
            if name:find("medusa") or name:find("head") or name:find("stone") then return tool end    
        end    
    end    
    local bp = LP:FindFirstChildOfClass("Backpack")    
    if bp then    
        for _, tool in ipairs(bp:GetChildren()) do    
            if tool:IsA("Tool") then    
                local name = tool.Name:lower()    
                if name:find("medusa") or name:find("head") or name:find("stone") then return tool end    
            end    
        end    
    end    
    return nil    
end    
    
local function useMedusaCounter()    
    if S.medusaDebounce then return end    
    if tick() - S.medusaLastUsed < S.MEDUSA_COOLDOWN then return end    
    local char = LP.Character    
    if not char then return end    
    S.medusaDebounce = true    
    local med = findMedusa()    
    if not med then S.medusaDebounce = false; return end    
    if med.Parent ~= char then    
        local hum = char:FindFirstChildOfClass("Humanoid")    
        if hum then hum:EquipTool(med) end    
    end    
    pcall(function() med:Activate() end)    
    S.medusaLastUsed = tick()    
    S.medusaDebounce = false    
end    
    
local function onAnchorChanged(part)    
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()    
        if part.Anchored and part.Transparency == 1 and S.medusaCounterEnabled then    
            useMedusaCounter()    
        end    
    end)    
end    
    
local function setupMedusaCounter(char)    
    for _, c in pairs(S.medusaConns) do pcall(function() c:Disconnect() end) end    
    S.medusaConns = {}    
    if not char then return end    
    for _, part in ipairs(char:GetDescendants()) do    
        if part:IsA("BasePart") then table.insert(S.medusaConns, onAnchorChanged(part)) end    
    end    
    table.insert(S.medusaConns, char.DescendantAdded:Connect(function(part)    
        if part:IsA("BasePart") then table.insert(S.medusaConns, onAnchorChanged(part)) end    
    end))    
end    
    
local function stopMedusaCounter()    
    for _, c in pairs(S.medusaConns) do pcall(function() c:Disconnect() end) end    
    S.medusaConns = {}    
end    

-- Medusa Auto-Reset
local function onMedusaAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if S.medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            cursedInstaReset()
        end
    end)
end

local function setupMedusaAutoReset(char)
    for _, c in pairs(S.medusaAutoResetConns) do pcall(function() c:Disconnect() end) end
    S.medusaAutoResetConns = {}
    if not char or not S.medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(S.medusaAutoResetConns, onMedusaAnchorChanged(part))
        end
    end
    table.insert(S.medusaAutoResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(S.medusaAutoResetConns, onMedusaAnchorChanged(part))
        end
    end))
end

local function stopMedusaAutoReset()
    for _, c in pairs(S.medusaAutoResetConns) do pcall(function() c:Disconnect() end) end
    S.medusaAutoResetConns = {}
end    
    
local function runTPFloor()
    applyTPDown(0.8, S.tpDownVersion == 2 and 0 or 45)
end
    
    
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)    
    
-- ==================== AUTO STEAL (Candy Hub) ====================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plots = workspace:WaitForChild("Plots")
local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = {caches={}, connections={}}
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil
local StealState = {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0
}
local STEAL_CFG = {
    HOLD_MIN = 1.3,
    HOLD_MAX = 2.6,
    ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05,
    STEAL_RANGE = 9,
    PRIME_RANGE = 80
}
local progressLastFill = 0

local function initializeAutoStealSync()
    local ok = pcall(function()
        local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
        local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
        if not Packages or not Datas then return end
        AnimalsData = require(Datas:WaitForChild("Animals"))
        local folder = Packages:WaitForChild("Synchronizer")
        syncRemotes = {
            channelFolder = folder:WaitForChild("Channel"),
            routeRemote = folder:WaitForChild("CommunicationRoute"),
            requestData = folder:FindFirstChild("RequestData")
        }
    end)
    return ok and syncRemotes ~= nil
end

local function splitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
    return out
end

local function resolveSyncPath(path, root)
    local current = root
    local parent, key = nil, nil
    for _, part in ipairs(splitSyncPath(path)) do
        parent = current; key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function applyPlotSyncDiff(channelName, packet)
    local cache = plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolveSyncPath(path, cache)
    if action == "Changed" then
        if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
        if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
        if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
        if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
        if current ~= nil then current[b] = nil end
    end
end

local function attachPlotChannel(remote)
    if not syncRemotes or plotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif plotAnimalSync.caches[channelName] == nil then
        plotAnimalSync.caches[channelName] = {}
    end
    plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
    end)
end

local function detachPlotChannel(channelName)
    for remote, conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote] = nil
            plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

local function startAutoStealSync()
    if not initializeAutoStealSync() then return false end
    for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(channelName)
            end
        end
    end)
    return true
end

local function getPlotChannelData(plotName)
    return plotAnimalSync.caches[plotName]
end

local function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return getPlotOwner(plot) == LP.DisplayName
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function getAnimalPosition(animalData)
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function distToAnimal(animalData)
    local character = LP.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function pickClosest()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > STEAL_CFG.PRIME_RANGE then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = {holdCallbacks={}, triggerCallbacks={}, ready=true}
    if getconnections then
        local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok1 and type(conns1) == "table" then
            for _, conn in ipairs(conns1) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local ok2, conns2 = pcall(getconnections, prompt.Triggered)
        if ok2 and type(conns2) == "table" then
            for _, conn in ipairs(conns2) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then InternalStealCache[prompt] = data end
end

local function executeStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = label
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(STEAL_CFG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= STEAL_CFG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > STEAL_CFG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= STEAL_CFG.STEAL_RANGE then
                if not alreadyInRange then task.wait(STEAL_CFG.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. label
            StealState.phase = "success"
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed: " .. label
            StealState.phase = "failed"
        end
        StealState.active = false
        StealState.lastResultTime = tick()
        task.wait(STEAL_CFG.COOLDOWN)
        data.ready = true
    end)
    return true
end

local function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end

local function scanAllPlots()
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        local cache = getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot)
                })
            end
        end
    end
    allAnimalsCache = newCache
    return #allAnimalsCache
end

local function startAutoSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if not S.stealActive then return end
        if StealState.active then return end
        local target = pickClosest()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then prompt = findProximityPromptForAnimal(target) end
        if prompt then attemptSteal(prompt, target) end
    end)
end

local function stopAutoSteal()
    if not stealConnection then return end
    stealConnection:Disconnect()
    stealConnection = nil
    StealState.active = false
    StealState.phase = "idle"
    resetProgressBar()
end

local function resetAutoStealFull()
    StealState.active = false
    StealState.phase = "idle"
    InternalStealCache = {}
    PromptMemoryCache = {}
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    resetProgressBar()
end

RunService.RenderStepped:Connect(function(dt)
    -- if not S.progressFill or not S.progressPct then return end
    local recent = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4
    local targetPct = 0
    local targetColor = Color3.fromRGB(170,0,255)
    local status = S.stealActive and "READY" or "IDLE"
    local handledByIdle = false
    if StealState.active then
        targetPct = math.clamp((tick() - StealState.startTime) / STEAL_CFG.HOLD_MAX, 0, 1)
        if StealState.phase == "waitingRange" then
            status = "WAITING RANGE"
            targetColor = Color3.fromRGB(0, 180, 255)
        else
            status = "STEALING"
            targetColor = Color3.fromRGB(170,0,255)
        end
    elseif recent then
        local success = StealState.phase == "success" or string.find(StealState.lastResult, "Stole") ~= nil
        targetPct = 1
        status = success and "SUCCESS" or "FAILED"
        targetColor = success and Color3.fromRGB(120, 255, 190) or Color3.fromRGB(255, 90, 120)
    elseif S.stealActive then
        handledByIdle = true
    elseif StealState.phase ~= "idle" then
        StealState.phase = "idle"
    end
    if not handledByIdle then
        progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min(dt * 14, 1)
        S.progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
        S.progressFill.BackgroundColor3 = S.progressFill.BackgroundColor3:Lerp(targetColor, math.min(dt * 8, 1))
        S.progressPct.Text = status
        S.progressPct.TextColor3 = targetColor
    end
end)

task.spawn(function()
    if startAutoStealSync() then
        scanAllPlots()
        while task.wait(5) do scanAllPlots() end
    end
end)    
    
RunService.Stepped:Connect(function(_, dt)    
    S._noclipTimer = S._noclipTimer + dt    
    if S._noclipTimer < 0.15 then return end    
    S._noclipTimer = 0    
    for _, p in ipairs(Players:GetPlayers()) do    
        if p ~= LP and p.Character then    
            for _, part in ipairs(p.Character:GetDescendants()) do    
                if part:IsA("BasePart") then part.CanCollide = false end    
            end    
        end    
    end    
end)    
    
RunService.RenderStepped:Connect(function()    
    S._fpsCount = S._fpsCount + 1    
    local now = tick()    
    if now - S._lastFpsTime >= 1 then    
        S.currentFPS = math.floor(S._fpsCount/(now - S._lastFpsTime))    
        S._fpsCount = 0    
        S._lastFpsTime = now    
    end    
end)    
    
local function refreshFloatingButtonsVisual()    
    if not S._setPButtonActive then return end    
    local fb = S._floatingButtons    
    if fb.lagger then updateLaggerButtonVisual() end    
    if fb.carry then S._setPButtonActive(fb.carry, fb.strokeCarry, fb.l1Carry, fb.l2Carry, S.speedMode) end    
    if fb.autoLeft then S._setPButtonActive(fb.autoLeft, fb.strokeAutoLeft, fb.l1AutoLeft, fb.l2AutoLeft, S.autoLeftEnabled) end    
    if fb.autoRight then S._setPButtonActive(fb.autoRight, fb.strokeAutoRight, fb.l1AutoRight, fb.l2AutoRight, S.autoRightEnabled) end    
    if fb.bat then S._setPButtonActive(fb.bat, fb.strokeBat, fb.l1Bat, fb.l2Bat, autoBatEnabled) end    
    if fb.autoTPDown then S._setPButtonActive(fb.autoTPDown, fb.strokeAutoTPDown, fb.l1AutoTPDown, fb.l2AutoTPDown, S.autoTPDownEnabled) end    
end    
    
local function setUILock(enabled)    
    S.lockUIEnabled = enabled    
    if S.mainMenuFrame then S.mainMenuFrame.Active = not enabled end    
    if S.miniToggleButton then S.miniToggleButton.Active = not enabled end    
end    
    
local function makeDraggable(frame, isFloatingPanel)    
    local dragging, dragStart, startPos = false, nil, nil    
    frame.InputBegan:Connect(function(inp)    
        if S.lockUIEnabled then return end    
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then    
            dragging = true    
            dragStart = inp.Position    
            startPos = frame.Position    
            inp.Changed:Connect(function()    
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end    
            end)    
        end    
    end)    
    UIS.InputChanged:Connect(function(inp)    
        if S.lockUIEnabled or not dragging then return end    
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then    
            local delta = inp.Position - dragStart    
            if delta.Magnitude > 2 then    
                local newX = startPos.X.Offset + delta.X    
                local newY = startPos.Y.Offset + delta.Y    
                frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)    
                if isFloatingPanel then saveConfig() end    
            end    
        end    
    end)    
end    
    
local function applyShimmerToText(obj, speed)    
    speed = speed or 0.8    
    local grad = Instance.new("UIGradient", obj)    
    grad.Color = ColorSequence.new({    
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),    
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),    
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),    
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),    
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))    
    })    
    grad.Rotation = 45    
    grad.Offset = Vector2.new(0,0)    
    task.spawn(function()    
        local t = 0    
        while grad and grad.Parent do    
            t = t + 0.02    
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)    
            task.wait(0.04)    
        end    
    end)    
    return grad    
end    
    
-- ==================== GUI ====================    
local function buildGui()    
    local C_BG_OUTER  = Color3.fromRGB(10,10,10)    
    local C_BG_INNER  = Color3.fromRGB(8,8,8)    
    local C_WHITE     = Color3.fromRGB(255,255,255)    
    local C_DIM       = Color3.fromRGB(140,140,140)    
    local C_BORDER    = Color3.fromRGB(40,40,40)    
    local C_CARD_BG   = Color3.fromRGB(12,12,12)    
    local C_ACTIVE_BG = Color3.fromRGB(25,25,25)    
    local C_ACCENT    = Color3.fromRGB(192,192,192)    
    local TOTAL_W = 480; local TOTAL_H = 680; local SIDEBAR_W = 175    
    
    pcall(function() local old = game:GetService("CoreGui"):FindFirstChild("NewEraHub"); if old then old:Destroy() end end)    
    pcall(function() local old = LP:WaitForChild("PlayerGui"):FindFirstChild("NewEraHub"); if old then old:Destroy() end end)    
    
    local gui = Instance.new("ScreenGui")    
    gui.Name = "NewEraHub"    
    gui.ResetOnSpawn = false    
    gui.DisplayOrder = 999999    
    gui.IgnoreGuiInset = true    
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then    
        gui.Parent = LP:WaitForChild("PlayerGui")    
    end    
    
    local main = Instance.new("Frame", gui)    
    main.Name = "Main"; main.Size = UDim2.new(0, TOTAL_W, 0, TOTAL_H)    
    main.Position = UDim2.new(0, 40, 0, 0); main.BackgroundColor3 = Color3.fromRGB(5,2,12)    
    main.BorderSizePixel = 0; main.ClipsDescendants = true; main.Visible = false    
    main.ZIndex = 999
    -- Add semi-transparent overlay for better readability
    main.BackgroundTransparency = 0.15
    
    -- Add subtle dark overlay inside main for depth
    local mainOverlay = Instance.new("Frame", main)
    mainOverlay.Size = UDim2.new(1,0,1,0)
    mainOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    mainOverlay.BackgroundTransparency = 0.3
    mainOverlay.BorderSizePixel = 0
    mainOverlay.ZIndex = 997
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)    
    local mainStroke = Instance.new("UIStroke", main); mainStroke.Color = C_BORDER; mainStroke.Thickness = 1.5    
    S.mainMenuFrame = main    
    makeDraggable(main, false)    
    
    local sidebar = Instance.new("Frame", main)    
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(8,3,18)    
    sidebar.BorderSizePixel = 0; sidebar.ClipsDescendants = true    
    sidebar.ZIndex = 999    
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)    
    
    local divider = Instance.new("Frame", main)    
    divider.Size = UDim2.new(0,2,1,-24); divider.Position = UDim2.new(0,SIDEBAR_W-1,0,12)    
    divider.BackgroundColor3 = Color3.fromRGB(170,0,255); divider.BorderSizePixel = 0    
    divider.ZIndex = 999
    divider.BackgroundTransparency = 0.4
    -- Add glow effect to divider
    local dividerGradient = Instance.new("UIGradient", divider)
    dividerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170,0,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170,0,255))
    })
    dividerGradient.Rotation = 90
    
    local headerFrame = Instance.new("Frame", sidebar)    
    headerFrame.Size = UDim2.new(1,0,1,0); headerFrame.BackgroundTransparency = 1; headerFrame.ClipsDescendants = true    
    headerFrame.ZIndex = 999    
    
    local logoImage = Instance.new("ImageLabel", headerFrame)    
    logoImage.Size = UDim2.new(1,0,1,0); logoImage.BackgroundTransparency = 1    
    logoImage.Image = "rbxassetid://117085976067902"; logoImage.ScaleType = Enum.ScaleType.Crop    
    logoImage.ImageTransparency = 0.02; logoImage.ZIndex = 999    
    local fadeGradient = Instance.new("UIGradient", logoImage)    
    fadeGradient.Rotation = 90    
    fadeGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.02), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(1, 0.4)})    
    
    local overlay = Instance.new("Frame", headerFrame)    
    overlay.Size = UDim2.new(1,0,1,0); overlay.BackgroundColor3 = Color3.fromRGB(20,10,40); overlay.BorderSizePixel = 0; overlay.ZIndex = 998    
    local gradientOverlay = Instance.new("UIGradient", overlay)
    gradientOverlay.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170,0,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100,20,150))
    })
    gradientOverlay.Rotation = 45
    overlay.BackgroundTransparency = 0; overlay.ZIndex = 998    
    
    local titleLabel = Instance.new("TextLabel", headerFrame)    
    titleLabel.Size = UDim2.new(1,-16,0,32); titleLabel.Position = UDim2.new(0,8,0,10)    
    titleLabel.BackgroundTransparency = 1; titleLabel.Text = "New Era Hub"    
    titleLabel.TextColor3 = Color3.fromRGB(200,100,255); titleLabel.Font = Enum.Font.GothamBlack    
    titleLabel.TextSize = 28; titleLabel.TextXAlignment = Enum.TextXAlignment.Center; titleLabel.ZIndex = 999
    -- Add glow effect to title
    titleLabel.TextStrokeTransparency = 0.7
    titleLabel.TextStrokeColor3 = Color3.fromRGB(170,0,255)
    
    
    local accentLine = Instance.new("Frame", headerFrame)    
    accentLine.Size = UDim2.new(0,60,0,2); accentLine.Position = UDim2.new(0.5,-30,0,52)    
    accentLine.BackgroundColor3 = Color3.fromRGB(170,0,255); accentLine.BackgroundTransparency = 0    
    accentLine.BorderSizePixel = 0; accentLine.ZIndex = 999
    -- Add gradient glow to accent line
    local accentGradient = Instance.new("UIGradient", accentLine)
    accentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100,20,150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,100,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100,20,150))
    })
    accentGradient.Rotation = 0
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1,0)    
    
    local TAB_NAMES = {"Speed", "Main", "Move", "Config", "Keybinds"}    
    local tabBtns = {}    
    local tabListFrame = Instance.new("Frame", sidebar)    
    tabListFrame.Size = UDim2.new(1,0,1,0); tabListFrame.Position = UDim2.new(0,0,0,110)    
    tabListFrame.BackgroundTransparency = 1; tabListFrame.ZIndex = 999    
    local tabLL = Instance.new("UIListLayout", tabListFrame)    
    tabLL.SortOrder = Enum.SortOrder.LayoutOrder    
    tabLL.Padding = UDim.new(0, 8)    
    tabLL.HorizontalAlignment = Enum.HorizontalAlignment.Center    
    local tabPad = Instance.new("UIPadding", tabListFrame)    
    tabPad.PaddingLeft = UDim.new(0,16); tabPad.PaddingRight = UDim.new(0,16); tabPad.PaddingTop = UDim.new(0,8)    
    
    local switchTab    
    for i, name in ipairs(TAB_NAMES) do    
        local btn = Instance.new("TextButton", tabListFrame)    
        btn.Size = UDim2.new(1,0,0,40)    
        btn.BackgroundColor3 = C_CARD_BG    
        btn.BackgroundTransparency = 0.7    
        btn.BorderSizePixel = 0    
        btn.Text = ""    
        btn.LayoutOrder = i    
        btn.AutoButtonColor = false    
        btn.ZIndex = 999    
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)    
        local stroke = Instance.new("UIStroke", btn)    
        stroke.Color = C_BORDER    
        stroke.Thickness = 1    
        stroke.Transparency = 0.4    
        local lbl = Instance.new("TextLabel", btn)    
        lbl.Size = UDim2.new(1,0,1,0)    
        lbl.BackgroundTransparency = 1    
        lbl.Text = name    
        lbl.TextColor3 = C_DIM    
        lbl.Font = Enum.Font.GothamBold    
        lbl.TextSize = 13    
        lbl.TextXAlignment = Enum.TextXAlignment.Center    
        lbl.ZIndex = 999    
        applyShimmerToText(lbl, 0.6)    
        local activeIndicator = Instance.new("Frame", btn)    
        activeIndicator.Size = UDim2.new(0.8,0,0,2)    
        activeIndicator.Position = UDim2.new(0.1,0,1,-2)    
        activeIndicator.BackgroundColor3 = Color3.fromRGB(170,0,255)    
        activeIndicator.BorderSizePixel = 0    
        activeIndicator.Visible = (name == "Speed")    
        activeIndicator.ZIndex = 999    
        Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(1,0)    
        tabBtns[name] = {bg = btn, lbl = lbl, ind = activeIndicator, stroke = stroke}    
        btn.MouseButton1Click:Connect(function() if switchTab then switchTab(name) end end)    
    end    
    
    
    local rightPanel = Instance.new("Frame", main)    
    rightPanel.Size = UDim2.new(0, TOTAL_W - SIDEBAR_W - 1, 1, 0)    
    rightPanel.Position = UDim2.new(0, SIDEBAR_W+1, 0, 0)    
    rightPanel.BackgroundColor3 = C_BG_INNER; rightPanel.BorderSizePixel = 0; rightPanel.ClipsDescendants = true    
    rightPanel.ZIndex = 999    
    Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0,12)    
    
    local topBar = Instance.new("Frame", rightPanel)    
    topBar.Size = UDim2.new(1,0,0,44); topBar.BackgroundColor3 = C_BG_INNER; topBar.BorderSizePixel = 0    
    topBar.ZIndex = 999    
    local topBarDiv = Instance.new("Frame", rightPanel)    
    topBarDiv.Size = UDim2.new(1,-20,0,1); topBarDiv.Position = UDim2.new(10,0,0,44)    
    topBarDiv.BackgroundColor3 = C_BORDER; topBarDiv.BorderSizePixel = 0    
    topBarDiv.ZIndex = 999    
    
    local panelTitle = Instance.new("TextLabel", topBar)    
    panelTitle.Size = UDim2.new(1,-50,1,0); panelTitle.Position = UDim2.new(0,16,0,0)    
    panelTitle.BackgroundTransparency = 1; panelTitle.Text = "Speed"    
    panelTitle.TextColor3 = C_WHITE; panelTitle.Font = Enum.Font.GothamBlack; panelTitle.TextSize = 16    
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left    
    panelTitle.ZIndex = 999    
    
    local closeBtn = Instance.new("TextButton", topBar)    
    closeBtn.Size = UDim2.new(0,28,0,28); closeBtn.Position = UDim2.new(1,-34,0.5,-14)    
    closeBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); closeBtn.BorderSizePixel = 0    
    closeBtn.Text = "■"; closeBtn.TextColor3 = C_WHITE; closeBtn.Font = Enum.Font.GothamBlack    
    closeBtn.TextSize = 20; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 999    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)    
    closeBtn.MouseButton1Click:Connect(function()    
        main.Visible = false    
        if S.miniToggleButton then S.miniToggleButton.Visible = true end    
    end)    
    
    local contentArea = Instance.new("Frame", rightPanel)    
    contentArea.Size = UDim2.new(1,0,1,-45); contentArea.Position = UDim2.new(0,0,0,45)    
    contentArea.BackgroundTransparency = 1; contentArea.ClipsDescendants = true    
    contentArea.ZIndex = 999    
    
    local function buildGui_createScrollingPages(parent)    
        local pages = {}    
        for _, n in ipairs({"Speed", "Main", "Move", "Config", "Keybinds"}) do    
            local sf = Instance.new("ScrollingFrame", parent)    
            sf.Size = UDim2.new(1,0,1,0)    
            sf.BackgroundTransparency = 1    
            sf.BorderSizePixel = 0    
            sf.ScrollBarThickness = 6    
            sf.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)    
            sf.ScrollingEnabled = true    
            sf.Visible = false    
            sf.AutomaticCanvasSize = Enum.AutomaticSize.Y    
            sf.CanvasSize = UDim2.new(0,0,0,0)    
            sf.ZIndex = 999    
            local ll = Instance.new("UIListLayout", sf)    
            ll.SortOrder = Enum.SortOrder.LayoutOrder    
            ll.Padding = UDim.new(0, 8)    
            ll.FillDirection = Enum.FillDirection.Vertical    
            local pp = Instance.new("UIPadding", sf)    
            pp.PaddingLeft = UDim.new(0, 12)    
            pp.PaddingRight = UDim.new(0, 12)    
            pp.PaddingTop = UDim.new(0, 12)    
            pp.PaddingBottom = UDim.new(0, 60)    
            pages[n] = sf    
        end    
        return pages    
    end    
    
    local pages = buildGui_createScrollingPages(contentArea)    
    local activePage = pages["Speed"]    
    activePage.Visible = true    
    
    local rowCounts = {Speed = 0, Main = 0, Move = 0, Config = 0, Keybinds = 0}    
    
    local function mkCard(pg, h)    
        rowCounts[pg] = rowCounts[pg] + 1    
        local f = Instance.new("Frame", pages[pg])    
        f.Size = UDim2.new(1,0,0,h or 38)    
        f.BackgroundColor3 = Color3.fromRGB(15,8,30)    
        f.BorderSizePixel = 0    
        f.LayoutOrder = rowCounts[pg]    
        f.ZIndex = 999    
        
        -- Add subtle gradient to card
        local cardGradient = Instance.new("UIGradient", f)
        cardGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20,12,40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15,8,30))
        })
        cardGradient.Rotation = 90
        
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)    
        local stroke = Instance.new("UIStroke", f)    
        stroke.Color = Color3.fromRGB(170,0,255)    
        stroke.Thickness = 1
        stroke.Transparency = 0.4    
        return f    
    end    
    
    local function mkToggle(pg, label, defOn, onToggle)    
        local card = mkCard(pg, 38)    
        local lbl = Instance.new("TextLabel", card)    
        lbl.Size = UDim2.new(0,140,1,0)    
        lbl.Position = UDim2.new(0,12,0,0)    
        lbl.BackgroundTransparency = 1    
        lbl.Text = label    
        lbl.TextColor3 = Color3.fromRGB(255,255,255)    
        lbl.Font = Enum.Font.GothamBold    
        lbl.TextSize = 11    
        lbl.TextXAlignment = Enum.TextXAlignment.Left    
        lbl.ZIndex = 999    
        applyShimmerToText(lbl, 0.6)    
        local pillBg = Instance.new("Frame", card)    
        pillBg.Size = UDim2.new(0,28,0,16)    
        pillBg.Position = UDim2.new(1,-36,0.5,-8)    
        pillBg.BackgroundColor3 = defOn and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
        pillBg.BorderSizePixel = 0    
        pillBg.ZIndex = 999    
        Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)    
        local dot = Instance.new("Frame", pillBg)    
        dot.Size = UDim2.new(0,12,0,12)    
        dot.Position = defOn and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)    
        dot.BackgroundColor3 = defOn and Color3.fromRGB(12,12,12) or Color3.fromRGB(255,255,255)    
        dot.BorderSizePixel = 0    
        dot.ZIndex = 999    
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)    
        local cardStroke = card:FindFirstChildOfClass("UIStroke")    
        if cardStroke and defOn then    
            cardStroke.Color = Color3.fromRGB(170,0,255)    
            cardStroke.Thickness = 1.5    
        end    
        local isOn = defOn or false    
        local function setV(on)    
            isOn = on    
            pillBg.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
            dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)    
            dot.BackgroundColor3 = on and Color3.fromRGB(12,12,12) or Color3.fromRGB(255,255,255)    
            if cardStroke then    
                cardStroke.Color = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
                cardStroke.Thickness = on and 1.5 or 0.5    
            end
            -- Add pulse animation effect
            local originalSize = card.Size
            card.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 2)
            task.wait(0.05)
            card.Size = originalSize
        end    
        local clickArea = Instance.new("TextButton", card)    
        clickArea.Size = UDim2.new(1,0,1,0)    
        clickArea.BackgroundTransparency = 1    
        clickArea.Text = ""    
        clickArea.ZIndex = 999    
        
        -- Add hover effect
        clickArea.MouseEnter:Connect(function()
            card.BackgroundColor3 = Color3.fromRGB(25,15,50)
        end)
        
        clickArea.MouseLeave:Connect(function()
            card.BackgroundColor3 = Color3.fromRGB(15,8,30)
        end)
        
        clickArea.MouseButton1Click:Connect(function()    
            isOn = not isOn    
            setV(isOn)    
            if onToggle then onToggle(isOn) end    
        end)    
        return setV    
    end    
    
    local function mkInput(pg, label, default, onChange)    
        local card = mkCard(pg, 38)    
        local lbl = Instance.new("TextLabel", card)    
        lbl.Size = UDim2.new(0,140,1,0)    
        lbl.Position = UDim2.new(0,12,0,0)    
        lbl.BackgroundTransparency = 1    
        lbl.Text = label    
        lbl.TextColor3 = Color3.fromRGB(255,255,255)    
        lbl.Font = Enum.Font.GothamBold    
        lbl.TextSize = 11    
        lbl.TextXAlignment = Enum.TextXAlignment.Left    
        lbl.ZIndex = 999    
        applyShimmerToText(lbl, 0.6)    
        local box = Instance.new("TextBox", card)    
        box.Size = UDim2.new(0,70,0,28)    
        box.Position = UDim2.new(1,-78,0.5,-14)    
        box.BackgroundColor3 = Color3.fromRGB(20,10,35)    
        box.BorderSizePixel = 0    
        box.Text = tostring(default)    
        box.TextColor3 = C_ACCENT    
        box.Font = Enum.Font.GothamBold    
        box.TextSize = 11    
        box.ClearTextOnFocus = false    
        box.MultiLine = false    
        box.ZIndex = 1000    
        applyShimmerToText(box, 0.7)    
        pcall(function() box.ReturnKeyType = Enum.ReturnKeyType.Done end)    
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)    
        local lastVal = tostring(default)    
        local isFocused = false    
        local function applyValue()    
            if not isFocused then return end    
            isFocused = false    
            local n = tonumber(box.Text)    
            if n and n > 0 and n <= 500 then    
                lastVal = tostring(n)    
                box.Text = lastVal    
                onChange(n)    
                saveConfig()    
            else    
                box.Text = lastVal    
            end    
            pcall(function() box:ReleaseFocus(false) end)    
        end    
        box.Focused:Connect(function() isFocused = true end)    
        box.FocusLost:Connect(function()    
            if isFocused then    
                isFocused = false    
                local n = tonumber(box.Text)    
                if n and n > 0 and n <= 500 then    
                    lastVal = tostring(n)    
                    box.Text = lastVal    
                    onChange(n)    
                    saveConfig()    
                else    
                    box.Text = lastVal    
                end    
            end    
        end)    
        pcall(function() box.ReturnPressedFromOnScreenKeyboard:Connect(applyValue) end)    
        UIS.TouchTap:Connect(function(positions)    
            if not isFocused then return end    
            pcall(function()    
                local abs = box.AbsolutePosition    
                local sz  = box.AbsoluteSize    
                local tp  = positions[1]    
                if tp then    
                    local inside = tp.X >= abs.X and tp.X <= abs.X + sz.X and tp.Y >= abs.Y and tp.Y <= abs.Y + sz.Y    
                    if not inside then applyValue() end    
                end    
            end)    
        end)    
        return box    
    end    
    
    local function buildKeybindsTab()    
        local pg = "Keybinds"    
        local scroll = pages[pg]    
        local actions = {    
            {name = "Auto Left",      key = "AutoLeft"},    
            {name = "Auto Right",     key = "AutoRight"},    
            {name = "Auto Bat",       key = "AutoBat"},    
            {name = "TP Floor",       key = "TPFlor"},    
            {name = "Auto TP Down",   key = "AutoTPDown"},    
            {name = "Speed Toggle",   key = "SpeedToggle"},    
            {name = "Lagger Toggle",  key = "LaggerToggle"},    
            {name = "Speed Mode 1",   key = "SpeedMode1"},    
            {name = "Speed Mode 2",   key = "SpeedMode2"},    
            {name = "Speed Mode 3",   key = "SpeedMode3"},    
            {name = "Lagger Mode 1",  key = "LaggerMode1"},    
            {name = "Lagger Mode 2",  key = "LaggerMode2"},    
            {name = "Drop Brainrot",  key = "DropBrainrot"},    
            {name = "Hide GUI",       key = "GuiHide"},    
        }    
        for _, action in ipairs(actions) do    
            local entry = S.KB[action.key]    
            if entry then    
                local card = Instance.new("Frame", scroll)    
                card.Size = UDim2.new(1, 0, 0, 42)    
                card.BackgroundColor3 = Color3.fromRGB(15,8,30)    
                card.BorderSizePixel = 0    
                card.LayoutOrder = rowCounts[pg] + 1    
                rowCounts[pg] = rowCounts[pg] + 1    
                card.ZIndex = 999    
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)    
                local stroke = Instance.new("UIStroke", card)    
                stroke.Color = Color3.fromRGB(40,40,40)    
                stroke.Thickness = 0.5    
                local lbl = Instance.new("TextLabel", card)    
                lbl.Size = UDim2.new(0, 140, 1, 0)    
                lbl.Position = UDim2.new(0, 12, 0, 0)    
                lbl.BackgroundTransparency = 1    
                lbl.Text = action.name    
                lbl.TextColor3 = Color3.fromRGB(255,255,255)    
                lbl.Font = Enum.Font.GothamBold    
                lbl.TextSize = 12    
                lbl.TextXAlignment = Enum.TextXAlignment.Left    
                lbl.ZIndex = 999    
                applyShimmerToText(lbl, 0.6)    
                local keyBtn = Instance.new("TextButton", card)    
                keyBtn.Size = UDim2.new(0, 70, 0, 28)    
                keyBtn.Position = UDim2.new(1, -80, 0.5, -14)    
                keyBtn.BackgroundColor3 = Color3.fromRGB(20,10,35)    
                keyBtn.BorderSizePixel = 0    
                keyBtn.Text = entry.kb and entry.kb.Name or (entry.gp and entry.gp.Name) or "None"    
                keyBtn.TextColor3 = C_ACCENT    
                keyBtn.Font = Enum.Font.GothamBold    
                keyBtn.TextSize = 10    
                keyBtn.ZIndex = 999    
                Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)    
                applyShimmerToText(keyBtn, 0.7)    
                local listening = false    
                keyBtn.MouseButton1Click:Connect(function()    
                    if listening then return end    
                    listening = true    
                    local prev = keyBtn.Text    
                    keyBtn.Text = "..."    
                    local conn    
                    conn = UIS.InputBegan:Connect(function(inp)    
                        if inp.UserInputType == Enum.UserInputType.Keyboard or inp.UserInputType == Enum.UserInputType.Gamepad1 then    
                            if inp.KeyCode ~= Enum.KeyCode.Escape then    
                                if inp.UserInputType == Enum.UserInputType.Keyboard then    
                                    entry.kb = inp.KeyCode; entry.gp = nil    
                                else    
                                    entry.gp = inp.KeyCode; entry.kb = nil    
                                end    
                                keyBtn.Text = entry.kb and entry.kb.Name or (entry.gp and entry.gp.Name) or "None"    
                                saveConfig()    
                            else    
                                keyBtn.Text = prev    
                            end    
                            conn:Disconnect()    
                            listening = false    
                        end    
                    end)    
                end)    
                table.insert(S._keyButtons, {btn = keyBtn, entry = entry})    
            end    
        end    
    end    
    
    local function buildSpeedTab()    
        local C_BORDER_INACTIVE = Color3.fromRGB(50,50,50)    
        local C_BORDER_ACTIVE   = Color3.fromRGB(170,0,255)    
        local C_WHITE = Color3.fromRGB(255,255,255)    
        local C_INPUT = Color3.fromRGB(30,30,30)    
        local C_DIM   = Color3.fromRGB(150,150,150)    
        local setActive1, setActive2, setActive3    
        local setActiveL1, setActiveL2    
    
        local function makeSpeedCard(title, isActive, valNormal, valCarry, onActivate, onNormalChange, onCarryChange)    
            rowCounts["Speed"] = rowCounts["Speed"] + 1    
            local card = Instance.new("Frame", pages["Speed"])    
            card.Size = UDim2.new(1, 0, 0, 38)    
            card.BackgroundColor3 = Color3.fromRGB(15,8,30)    
            card.BorderSizePixel = 0    
            card.LayoutOrder = rowCounts["Speed"]    
            card.ZIndex = 999    
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)    
            local stroke = Instance.new("UIStroke", card)    
            stroke.Color = isActive and C_BORDER_ACTIVE or C_BORDER_INACTIVE    
            stroke.Thickness = isActive and 1.5 or 0.5    
            local titleLbl = Instance.new("TextLabel", card)    
            titleLbl.Size = UDim2.new(0, 100, 1, 0)    
            titleLbl.Position = UDim2.new(0, 12, 0, 0)    
            titleLbl.BackgroundTransparency = 1    
            titleLbl.Text = title    
            titleLbl.TextColor3 = C_WHITE    
            titleLbl.Font = Enum.Font.GothamBold    
            titleLbl.TextSize = 12    
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left    
            titleLbl.ZIndex = 999    
            applyShimmerToText(titleLbl, 0.6)    
    
            local boxNormal = Instance.new("TextBox", card)    
            boxNormal.Size = UDim2.new(0, 70, 0, 28)    
            boxNormal.Position = UDim2.new(1, -78, 0.5, -14)    
            boxNormal.BackgroundColor3 = C_INPUT    
            boxNormal.BorderSizePixel = 0    
            boxNormal.Text = tostring(valNormal)    
            boxNormal.TextColor3 = C_ACCENT    
            boxNormal.Font = Enum.Font.GothamBold    
            boxNormal.TextSize = 11    
            boxNormal.ClearTextOnFocus = false    
            boxNormal.ZIndex = 1000    
            Instance.new("UICorner", boxNormal).CornerRadius = UDim.new(0, 6)    
            local strokeN = Instance.new("UIStroke", boxNormal)    
            strokeN.Color = C_BORDER_INACTIVE; strokeN.Thickness = 1    
            applyShimmerToText(boxNormal, 0.7)    
    
            local boxCarry = Instance.new("TextBox", card)    
            boxCarry.Size = UDim2.new(0, 70, 0, 28)    
            boxCarry.Position = UDim2.new(1, -156, 0.5, -14)    
            boxCarry.BackgroundColor3 = C_INPUT    
            boxCarry.BorderSizePixel = 0    
            boxCarry.Text = tostring(valCarry)    
            boxCarry.TextColor3 = C_ACCENT    
            boxCarry.Font = Enum.Font.GothamBold    
            boxCarry.TextSize = 11    
            boxCarry.ClearTextOnFocus = false    
            boxCarry.ZIndex = 1000    
            Instance.new("UICorner", boxCarry).CornerRadius = UDim.new(0, 6)    
            local strokeC = Instance.new("UIStroke", boxCarry)    
            strokeC.Color = C_BORDER_INACTIVE; strokeC.Thickness = 1    
            applyShimmerToText(boxCarry, 0.7)    
    
            local lblCarry = Instance.new("TextLabel", card)    
            lblCarry.Size = UDim2.new(0, 70, 0, 14); lblCarry.Position = UDim2.new(1, -156, 0, 2)    
            lblCarry.BackgroundTransparency = 1; lblCarry.Text = "steal spd"    
            lblCarry.TextColor3 = C_DIM; lblCarry.Font = Enum.Font.GothamBold; lblCarry.TextSize = 8    
            lblCarry.TextXAlignment = Enum.TextXAlignment.Center    
            lblCarry.ZIndex = 999    
    
            local lblNormal = Instance.new("TextLabel", card)    
            lblNormal.Size = UDim2.new(0, 70, 0, 14); lblNormal.Position = UDim2.new(1, -78, 0, 2)    
            lblNormal.BackgroundTransparency = 1; lblNormal.Text = "norm spd"    
            lblNormal.TextColor3 = C_DIM; lblNormal.Font = Enum.Font.GothamBold; lblNormal.TextSize = 8    
            lblNormal.TextXAlignment = Enum.TextXAlignment.Center    
            lblNormal.ZIndex = 999    
    
            local lastNV = valNormal; local isFN = false    
            local lastCV = valCarry;  local isFC = false    
    
            local function applyN()    
                if not isFN then return end; isFN = false    
                local n = tonumber(boxNormal.Text)    
                if n and n > 0 and n <= 500 then lastNV = n; boxNormal.Text = tostring(n); onNormalChange(n); saveConfig()    
                else boxNormal.Text = tostring(lastNV) end    
                pcall(function() boxNormal:ReleaseFocus(false) end)    
            end    
            local function applyC()    
                if not isFC then return end; isFC = false    
                local n = tonumber(boxCarry.Text)    
                if n and n > 0 and n <= 500 then lastCV = n; boxCarry.Text = tostring(n); onCarryChange(n); saveConfig()    
                else boxCarry.Text = tostring(lastCV) end    
                pcall(function() boxCarry:ReleaseFocus(false) end)    
            end    
    
            boxNormal.Focused:Connect(function() isFN = true end)    
            boxNormal.FocusLost:Connect(applyN)    
            pcall(function() boxNormal.ReturnPressedFromOnScreenKeyboard:Connect(applyN) end)    
            boxCarry.Focused:Connect(function() isFC = true end)    
            boxCarry.FocusLost:Connect(applyC)    
            pcall(function() boxCarry.ReturnPressedFromOnScreenKeyboard:Connect(applyC) end)    
    
            local clickArea = Instance.new("TextButton", card)    
            clickArea.Size = UDim2.new(1,0,1,0); clickArea.BackgroundTransparency = 1    
            clickArea.Text = ""; clickArea.ZIndex = 999    
            clickArea.MouseButton1Click:Connect(function() onActivate(); autoActivateCarryIfHoldingAnimal(); saveConfig() end)    
    
            local function setActive(active)    
                stroke.Color = active and C_BORDER_ACTIVE or C_BORDER_INACTIVE    
                stroke.Thickness = active and 1.5 or 0.5    
            end    
            return setActive, boxNormal, boxCarry    
        end    
    
        local function makeLaggerCard(title, isActive, val, onActivate, onChange)    
            rowCounts["Speed"] = rowCounts["Speed"] + 1    
            local card = Instance.new("Frame", pages["Speed"])    
            card.Size = UDim2.new(1, 0, 0, 38)    
            card.BackgroundColor3 = Color3.fromRGB(15,8,30)    
            card.BorderSizePixel = 0    
            card.LayoutOrder = rowCounts["Speed"]    
            card.ZIndex = 999    
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)    
            local stroke = Instance.new("UIStroke", card)    
            stroke.Color = isActive and C_BORDER_ACTIVE or C_BORDER_INACTIVE    
            stroke.Thickness = isActive and 1.5 or 0.5    
            local titleLbl = Instance.new("TextLabel", card)    
            titleLbl.Size = UDim2.new(0,100,1,0); titleLbl.Position = UDim2.new(0,12,0,0)    
            titleLbl.BackgroundTransparency = 1; titleLbl.Text = title    
            titleLbl.TextColor3 = C_WHITE; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 12    
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left    
            titleLbl.ZIndex = 999    
            applyShimmerToText(titleLbl, 0.6)    
            local box = Instance.new("TextBox", card)    
            box.Size = UDim2.new(0,70,0,28); box.Position = UDim2.new(1,-78,0.5,-14)    
            box.BackgroundColor3 = C_INPUT; box.BorderSizePixel = 0; box.Text = tostring(val)    
            box.TextColor3 = C_ACCENT; box.Font = Enum.Font.GothamBold; box.TextSize = 11    
            box.ClearTextOnFocus = false; box.ZIndex = 1000    
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)    
            local strokeBox = Instance.new("UIStroke", box); strokeBox.Color = C_BORDER_INACTIVE; strokeBox.Thickness = 1    
            applyShimmerToText(box, 0.7)    
            local lastVal = val; local isFocused = false    
            local function applyChange()    
                if not isFocused then return end; isFocused = false    
                local n = tonumber(box.Text)    
                if n and n > 0 and n <= 500 then lastVal = n; box.Text = tostring(n); onChange(n); saveConfig()    
                else box.Text = tostring(lastVal) end    
                pcall(function() box:ReleaseFocus(false) end)    
            end    
            box.Focused:Connect(function() isFocused = true end)    
            box.FocusLost:Connect(applyChange)    
            pcall(function() box.ReturnPressedFromOnScreenKeyboard:Connect(applyChange) end)    
            local clickArea = Instance.new("TextButton", card)    
            clickArea.Size = UDim2.new(1,0,1,0); clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 999    
            clickArea.MouseButton1Click:Connect(function() onActivate(); saveConfig() end)    
            local function setActive(active)    
                stroke.Color = active and C_BORDER_ACTIVE or C_BORDER_INACTIVE    
                stroke.Thickness = active and 1.5 or 0.5    
            end    
            return setActive, box    
        end    
    
        local s1, normBox1, carryBox1 = makeSpeedCard("Speed mode 1", S.normalPreset == 1, S.NS1, S.CS1,    
            function()    
                if S.laggerMode ~= 0 then S.laggerMode = 0; if setActiveL1 then setActiveL1(false) end; if setActiveL2 then setActiveL2(false) end; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
                if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
                S.normalPreset = 1    
                setActive1(true); if setActive2 then setActive2(false) end; if setActive3 then setActive3(false) end    
                if S.speedPanelActive then S.speedPanelActive(1) end    
            end, function(v) S.NS1 = v end, function(v) S.CS1 = v end)    
        setActive1 = s1; S._menuSetActive1 = s1; S.normalBox1 = normBox1; S.carryBox1 = carryBox1    
    
        local s2, normBox2, carryBox2 = makeSpeedCard("Speed mode 2", S.normalPreset == 2, S.NS2, S.CS2,    
            function()    
                if S.laggerMode ~= 0 then S.laggerMode = 0; if setActiveL1 then setActiveL1(false) end; if setActiveL2 then setActiveL2(false) end; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
                if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
                S.normalPreset = 2    
                setActive2(true); if setActive1 then setActive1(false) end; if setActive3 then setActive3(false) end    
                if S.speedPanelActive then S.speedPanelActive(2) end    
            end, function(v) S.NS2 = v end, function(v) S.CS2 = v end)    
        setActive2 = s2; S._menuSetActive2 = s2; S.normalBox2 = normBox2; S.carryBox2 = carryBox2    
    
        local s3, normBox3, carryBox3 = makeSpeedCard("Speed mode 3", S.normalPreset == 3, S.NS3, S.CS3,    
            function()    
                if S.laggerMode ~= 0 then S.laggerMode = 0; if setActiveL1 then setActiveL1(false) end; if setActiveL2 then setActiveL2(false) end; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
                if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
                S.normalPreset = 3    
                setActive3(true); if setActive1 then setActive1(false) end; if setActive2 then setActive2(false) end    
                if S.speedPanelActive then S.speedPanelActive(3) end    
            end, function(v) S.NS3 = v end, function(v) S.CS3 = v end)    
        setActive3 = s3; S._menuSetActive3 = s3; S.normalBox3 = normBox3; S.carryBox3 = carryBox3    
    
        local l1, laggerBox1 = makeLaggerCard("Lagger Speed 1", S.laggerMode == 1, S.LS1,    
            function()    
                if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
                if S.normalPreset ~= 0 then if setActive1 then setActive1(false) end; if setActive2 then setActive2(false) end; if setActive3 then setActive3(false) end; S.normalPreset = 0; if S.speedPanelActive then S.speedPanelActive(0) end end    
                S.laggerMode = 1; setActiveL1(true); if setActiveL2 then setActiveL2(false) end    
                if S.setLaggerVisual then S.setLaggerVisual(true) end; updateLaggerButtonVisual()    
            end, function(v) S.LS1 = v end)    
        setActiveL1 = l1; S._menuSetActiveL1 = l1; S.laggerBox1 = laggerBox1    
    
        local l2, laggerBox2 = makeLaggerCard("Lagger Speed 2", S.laggerMode == 2, S.LS2,    
            function()    
                if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
                if S.normalPreset ~= 0 then if setActive1 then setActive1(false) end; if setActive2 then setActive2(false) end; if setActive3 then setActive3(false) end; S.normalPreset = 0; if S.speedPanelActive then S.speedPanelActive(0) end end    
                S.laggerMode = 2; setActiveL2(true); if setActiveL1 then setActiveL1(false) end    
                if S.setLaggerVisual then S.setLaggerVisual(true) end; updateLaggerButtonVisual()    
            end, function(v) S.LS2 = v end)    
        setActiveL2 = l2; S._menuSetActiveL2 = l2; S.laggerBox2 = laggerBox2    
    
        S.setLaggerVisual = function(on)    
            if not on then    
                if setActiveL1 then setActiveL1(false) end; if setActiveL2 then setActiveL2(false) end    
                if S.laggerMode ~= 0 then S.laggerMode = 0 end    
            else    
                if S.laggerMode == 1 then if setActiveL1 then setActiveL1(true); setActiveL2(false) end    
                elseif S.laggerMode == 2 then if setActiveL2 then setActiveL2(true); setActiveL1(false) end end    
            end    
        end    
    
        S.speedClk = function(on)    
            S.speedMode = on    
            if on then    
                if S.laggerMode ~= 0 then S.laggerMode = 0; if setActiveL1 then setActiveL1(false); setActiveL2(false) end; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            end    
            refreshFloatingButtonsVisual(); saveConfig()    
        end    
    
        if S.normalPreset == 1 then setActive1(true); setActive2(false); setActive3(false)    
        elseif S.normalPreset == 2 then setActive2(true); setActive1(false); setActive3(false)    
        elseif S.normalPreset == 3 then setActive3(true); setActive1(false); setActive2(false)    
        else setActive1(false); setActive2(false); setActive3(false) end    
        if S.laggerMode == 1 then setActiveL1(true); setActiveL2(false)    
        elseif S.laggerMode == 2 then setActiveL2(true); setActiveL1(false)    
        else setActiveL1(false); setActiveL2(false) end    
    end    
    
    local function buildMainTab()
        -- Auto Bat
        local autoBatToggle = mkToggle("Main", "Auto Bat", false, function(on)
            if on then
                if S.autoLeftEnabled then S.autoLeftEnabled = false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; stopAutoLeft() end
                if S.autoRightEnabled then S.autoRightEnabled = false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; stopAutoRight() end
                enableAutoBat()
            else
                disableAutoBat()
            end
            if S._setPButtonActive and S._btnBAT then S._setPButtonActive(S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT, on) end
            refreshFloatingButtonsVisual()
            saveConfig()
        end)
        autoBatSetVisual = autoBatToggle

        -- Bat Counter
        S.setBatCounterVisual = mkToggle("Main", "Bat Counter", false, function(on)
            S.batCounterEnabled = on
            if on then startBatCounter() else stopBatCounter() end
            saveConfig()
        end)

        -- Medusa Counter
        S.setMedusaVisual = mkToggle("Main", "Medusa Counter", false, function(on)
            S.medusaCounterEnabled = on
            if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
            saveConfig()
        end)

        -- Anti Ragdoll
        S.setAntiRagVisual = mkToggle("Main", "Anti Ragdoll", false, function(on) toggleAntiRag(on); saveConfig() end)

        -- Jump Mode (toggle + selector Hold/Infinite)
        do
            local card = mkCard("Main", 38)
            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0,100,1,0); lbl.Position = UDim2.new(0,12,0,0)
            lbl.BackgroundTransparency = 1; lbl.Text = "Jump Mode"
            lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 999
            applyShimmerToText(lbl, 0.6)

            local modeLabel = Instance.new("TextButton", card)
            modeLabel.Size = UDim2.new(0,60,0,24); modeLabel.Position = UDim2.new(0.5,-30,0.5,-12)
            modeLabel.BackgroundColor3 = Color3.fromRGB(20,10,35); modeLabel.BorderSizePixel = 0
            modeLabel.Text = "Hold"; modeLabel.TextColor3 = Color3.fromRGB(240,240,255)
            modeLabel.Font = Enum.Font.GothamBold; modeLabel.TextSize = 10; modeLabel.ZIndex = 999
            Instance.new("UICorner", modeLabel).CornerRadius = UDim.new(0,6)

            local pillBg = Instance.new("Frame", card)
            pillBg.Size = UDim2.new(0,28,0,16); pillBg.Position = UDim2.new(1,-36,0.5,-8)
            pillBg.BackgroundColor3 = Color3.fromRGB(40,40,40); pillBg.BorderSizePixel = 0; pillBg.ZIndex = 999
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", pillBg)
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0; dot.ZIndex = 999
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

            local jumpIsOn = false
            local useHold = true
            local jumpCardStroke = card:FindFirstChildOfClass("UIStroke")

            local function setJumpVisual(on)
                jumpIsOn = on
                pillBg.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)
                dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
                dot.BackgroundColor3 = on and Color3.fromRGB(12,12,12) or Color3.fromRGB(255,255,255)
                if jumpCardStroke then
                    jumpCardStroke.Color = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)
                    jumpCardStroke.Thickness = on and 1.5 or 0.5
                end
            end

            local function applyJump(on)
                if on then
                    if useHold then
                        S.infJumpEnabled = false; stopInfiniteJump()
                        if S.setInfJumpVisual then S.setInfJumpVisual(false) end
                        S.holdJumpEnabled = true; startHoldJump()
                        if S.setHoldJumpVisual then S.setHoldJumpVisual(true) end
                    else
                        S.holdJumpEnabled = false; stopHoldJump()
                        if S.setHoldJumpVisual then S.setHoldJumpVisual(false) end
                        S.infJumpEnabled = true; startInfiniteJump()
                        if S.setInfJumpVisual then S.setInfJumpVisual(true) end
                    end
                else
                    if useHold then S.holdJumpEnabled = false; stopHoldJump(); if S.setHoldJumpVisual then S.setHoldJumpVisual(false) end
                    else S.infJumpEnabled = false; stopInfiniteJump(); if S.setInfJumpVisual then S.setInfJumpVisual(false) end end
                end
                saveConfig()
            end

            modeLabel.MouseButton1Click:Connect(function()
                if jumpIsOn then
                    if useHold then S.holdJumpEnabled = false; stopHoldJump(); if S.setHoldJumpVisual then S.setHoldJumpVisual(false) end
                    else S.infJumpEnabled = false; stopInfiniteJump(); if S.setInfJumpVisual then S.setInfJumpVisual(false) end end
                end
                useHold = not useHold
                modeLabel.Text = useHold and "Hold" or "Infinite"
                if jumpIsOn then applyJump(true) end
            end)

            local clickArea = Instance.new("TextButton", card)
            clickArea.Size = UDim2.new(0,36,1,0); clickArea.Position = UDim2.new(1,-42,0,0)
            clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 999
            clickArea.MouseButton1Click:Connect(function()
                jumpIsOn = not jumpIsOn
                setJumpVisual(jumpIsOn)
                applyJump(jumpIsOn)
            end)

            S.setInfJumpVisual = function(on)
                if not useHold then setJumpVisual(on) end
            end
            S.setHoldJumpVisual = function(on)
                if useHold then setJumpVisual(on) end
            end
        end

        -- Unwalk
        S.setUnwalkVisual = mkToggle("Main", "Unwalk", false, function(on) if on then startUnwalk() else stopUnwalk() end; saveConfig() end)

        -- Drop Brainrot
        do
            local card = mkCard("Main", 38)
            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0,100,1,0); lbl.Position = UDim2.new(0,12,0,0)
            lbl.BackgroundTransparency = 1; lbl.Text = "Drop Brainrot"
            lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 999
            applyShimmerToText(lbl, 0.6)

            local modeLabel = Instance.new("TextButton", card)
            modeLabel.Size = UDim2.new(0,60,0,24); modeLabel.Position = UDim2.new(0.5,-30,0.5,-12)
            modeLabel.BackgroundColor3 = Color3.fromRGB(255,255,255); modeLabel.BorderSizePixel = 0
            modeLabel.Text = "V1"; modeLabel.TextColor3 = Color3.fromRGB(0,0,0)
            modeLabel.Font = Enum.Font.GothamBold; modeLabel.TextSize = 10; modeLabel.ZIndex = 999
            Instance.new("UICorner", modeLabel).CornerRadius = UDim.new(0,6)

            local pillBg = Instance.new("Frame", card)
            pillBg.Size = UDim2.new(0,28,0,16); pillBg.Position = UDim2.new(1,-36,0.5,-8)
            pillBg.BackgroundColor3 = Color3.fromRGB(255,255,255); pillBg.BorderSizePixel = 0; pillBg.ZIndex = 999
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", pillBg)
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)
            dot.BackgroundColor3 = Color3.fromRGB(15,8,30); dot.BorderSizePixel = 0; dot.ZIndex = 999
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

            modeLabel.MouseButton1Click:Connect(function()
                S.dropBrainrotVersion = (S.dropBrainrotVersion == 1) and 2 or 1
                local isV2 = S.dropBrainrotVersion == 2
                -- V1: white button + white pill, V2: purple button + purple pill
                modeLabel.BackgroundColor3 = isV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
                modeLabel.TextColor3 = isV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
                modeLabel.Text = isV2 and "V2" or "V1"
                pillBg.BackgroundColor3 = isV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
                dot.BackgroundColor3 = Color3.fromRGB(15,8,30)
            end)

            -- Initialize visual based on current version
            local initIsV2 = S.dropBrainrotVersion == 2
            modeLabel.BackgroundColor3 = initIsV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
            modeLabel.TextColor3 = initIsV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
            modeLabel.Text = initIsV2 and "V2" or "V1"
            pillBg.BackgroundColor3 = initIsV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)

            local clickArea = Instance.new("TextButton", card)
            clickArea.Size = UDim2.new(0,36,1,0); clickArea.Position = UDim2.new(1,-42,0,0)
            clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 999
            clickArea.MouseButton1Click:Connect(function()
                task.spawn(runDrop)
            end)
        end

        -- Galaxy Mode
        S.setDarkVisual = mkToggle("Config", "Galaxy Mode", false, function(on) toggleGalaxyMode(); saveConfig() end)

        -- Anti Lag
        mkToggle("Main", "Anti Lag", false, function(on) if on then enableAntiLag() else disableAntiLag() end; saveConfig() end)
    end    
    
    local function buildMoveTab()    
        -- Auto Left
        local setALVis = mkToggle("Move", "Auto Left", false, function(on)    
            S.autoLeftEnabled = on    
            if on then    
                if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end    
                if autoBatEnabled then disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end    
                startAutoLeft()    
            else stopAutoLeft() end    
            if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end    
            S.restartMovement(); refreshFloatingButtonsVisual(); saveConfig()    
        end)    
        S.autoLeftSetVisual = setALVis    
    
        -- Auto Right
        local setARVis = mkToggle("Move", "Auto Right", false, function(on)    
            S.autoRightEnabled = on    
            if on then    
                if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end    
                if autoBatEnabled then disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end    
                startAutoRight()    
            else stopAutoRight() end    
            if S.autoRightSetVisual then S.autoRightSetVisual(on) end    
            S.restartMovement(); refreshFloatingButtonsVisual(); saveConfig()    
        end)    
        S.autoRightSetVisual = setARVis

        -- TP Down (manual)
        do
            local card = mkCard("Move", 38)
            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0,100,1,0); lbl.Position = UDim2.new(0,12,0,0)
            lbl.BackgroundTransparency = 1; lbl.Text = "TP Down"
            lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 999
            applyShimmerToText(lbl, 0.6)

            local modeLabel = Instance.new("TextButton", card)
            modeLabel.Size = UDim2.new(0,60,0,24); modeLabel.Position = UDim2.new(0.5,-30,0.5,-12)
            modeLabel.BackgroundColor3 = Color3.fromRGB(255,255,255); modeLabel.BorderSizePixel = 0
            modeLabel.Text = "V1"; modeLabel.TextColor3 = Color3.fromRGB(0,0,0)
            modeLabel.Font = Enum.Font.GothamBold; modeLabel.TextSize = 10; modeLabel.ZIndex = 999
            Instance.new("UICorner", modeLabel).CornerRadius = UDim.new(0,6)

            local pillBg = Instance.new("Frame", card)
            pillBg.Size = UDim2.new(0,28,0,16); pillBg.Position = UDim2.new(1,-36,0.5,-8)
            pillBg.BackgroundColor3 = Color3.fromRGB(255,255,255); pillBg.BorderSizePixel = 0; pillBg.ZIndex = 999
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", pillBg)
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)
            dot.BackgroundColor3 = Color3.fromRGB(15,8,30); dot.BorderSizePixel = 0; dot.ZIndex = 999
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

            modeLabel.MouseButton1Click:Connect(function()
                S.tpDownVersion = (S.tpDownVersion == 1) and 2 or 1
                local isV2 = S.tpDownVersion == 2
                -- V1: empuja (blanco), V2: no empuja (morado)
                modeLabel.BackgroundColor3 = isV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
                modeLabel.TextColor3 = isV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
                modeLabel.Text = isV2 and "V2" or "V1"
                pillBg.BackgroundColor3 = isV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
                dot.BackgroundColor3 = Color3.fromRGB(15,8,30)
            end)

            -- Initialize visual based on current version
            local initIsV2 = S.tpDownVersion == 2
            modeLabel.BackgroundColor3 = initIsV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)
            modeLabel.TextColor3 = initIsV2 and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
            modeLabel.Text = initIsV2 and "V2" or "V1"
            pillBg.BackgroundColor3 = initIsV2 and Color3.fromRGB(170,0,255) or Color3.fromRGB(255,255,255)

            local clickArea = Instance.new("TextButton", card)
            clickArea.Size = UDim2.new(0,36,1,0); clickArea.Position = UDim2.new(1,-42,0,0)
            clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 999
            clickArea.MouseButton1Click:Connect(function()
                runTPFloor()
            end)
        end

        -- Auto TP Down
        S.autoTPDownSetVisual = mkToggle("Move", "Auto TP Down", false, function(on)    
            S.autoTPDownEnabled = on    
            if on then startAutoTPDown() else stopAutoTPDown() end    
            if S.autoTPDownFloatVisual then S.autoTPDownFloatVisual(on) end    
            saveConfig()    
        end)    

        -- Height Y (threshold input)
        do
            local inp = mkInput("Move", "Height Y", S.autoTPDownThreshold, function(v)
                local n = tonumber(v); if n and n >= 1 and n <= 500 then S.autoTPDownThreshold = n; saveConfig() end
            end)
            S.autoTPDownThresholdBox = inp
        end

        -- Insta Reset
        do
            local card = mkCard("Move", 38)
            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0,140,1,0); lbl.Position = UDim2.new(0,12,0,0)
            lbl.BackgroundTransparency = 1; lbl.Text = "Insta Reset"
            lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 999
            applyShimmerToText(lbl, 0.6)
            local pillBg = Instance.new("Frame", card)
            pillBg.Size = UDim2.new(0,28,0,16); pillBg.Position = UDim2.new(1,-36,0.5,-8)
            pillBg.BackgroundColor3 = Color3.fromRGB(40,40,40); pillBg.BorderSizePixel = 0; pillBg.ZIndex = 999
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", pillBg)
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0; dot.ZIndex = 999
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
            local isOn = false
            local clickArea = Instance.new("TextButton", card)
            clickArea.Size = UDim2.new(1,0,1,0); clickArea.BackgroundTransparency = 1
            clickArea.Text = ""; clickArea.ZIndex = 999
            clickArea.MouseButton1Click:Connect(function()
                isOn = not isOn
                pillBg.BackgroundColor3 = isOn and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)
                dot.Position = isOn and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
                dot.BackgroundColor3 = isOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,255,255)
                if isOn then cursedInstaReset() end
            end)
        end

        -- Medusa Auto-Reset
        S.setMedusaAutoResetVisual = mkToggle("Move", "Medusa Auto-Reset", false, function(on)
            S.medusaAutoResetEnabled = on
            if on then
                if LP.Character then setupMedusaAutoReset(LP.Character) end
            else
                stopMedusaAutoReset()
            end
            saveConfig()
        end)

    end    
    
        local function buildConfigTab()    
        do    
            local card = mkCard("Config", 38)    
            local lbl = Instance.new("TextLabel", card)    
            lbl.Size = UDim2.new(0,140,1,0)    
            lbl.Position = UDim2.new(0,12,0,0)    
            lbl.BackgroundTransparency = 1    
            lbl.Text = "Auto Steal"    
            lbl.TextColor3 = Color3.fromRGB(255,255,255)    
            lbl.Font = Enum.Font.GothamBold    
            lbl.TextSize = 11    
            lbl.TextXAlignment = Enum.TextXAlignment.Left    
            lbl.ZIndex = 999    
            applyShimmerToText(lbl, 0.6)    
            local pill = Instance.new("Frame", card)    
            pill.Size = UDim2.new(0,28,0,16); pill.Position = UDim2.new(1,-36,0.5,-8)    
            pill.BackgroundColor3 = Color3.fromRGB(40,40,40); pill.BorderSizePixel = 0    
            pill.ZIndex = 999    
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)    
            local dot = Instance.new("Frame", pill)    
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)    
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0    
            dot.ZIndex = 999    
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)    
            local stealOn = false    
            local function setStealVis(on)    
                stealOn = on    
                pill.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
                dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)    
                dot.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,255,255)    
            end    
            S.setInstaGrab = setStealVis    
            local click = Instance.new("TextButton", card)    
            click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""; click.ZIndex = 999    
            click.MouseButton1Click:Connect(function()    
                stealOn = not stealOn; setStealVis(stealOn); S.stealActive = stealOn    
                if stealOn then startAutoSteal() else stopAutoSteal() end    
                saveConfig()    
            end)    
        end    
    
    
        S.stealDurationBox = mkInput("Config", "Steal Duration", S.autoStealDuration, function(v)    
            if v >= 0.05 and v <= 2 then S.autoStealDuration = v; saveConfig() end    
        end)    
    
    
        do    
            local card = mkCard("Config", 38)    
            local lbl = Instance.new("TextLabel", card)    
            lbl.Size = UDim2.new(0,140,1,0)    
            lbl.Position = UDim2.new(0,12,0,0)    
            lbl.BackgroundTransparency = 1    
            lbl.Text = "Lock UI"    
            lbl.TextColor3 = Color3.fromRGB(255,255,255)    
            lbl.Font = Enum.Font.GothamBold    
            lbl.TextSize = 11    
            lbl.TextXAlignment = Enum.TextXAlignment.Left    
            lbl.ZIndex = 999    
            applyShimmerToText(lbl, 0.6)    
            local pill = Instance.new("Frame", card)    
            pill.Size = UDim2.new(0,28,0,16); pill.Position = UDim2.new(1,-36,0.5,-8)    
            pill.BackgroundColor3 = Color3.fromRGB(40,40,40); pill.BorderSizePixel = 0    
            pill.ZIndex = 999    
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)    
            local dot = Instance.new("Frame", pill)    
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)    
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0    
            dot.ZIndex = 999    
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)    
            local lockOn = false    
            local function setLockVis(on)    
                lockOn = on    
                pill.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
                dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)    
                dot.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,255,255)    
            end    
            S.setLockUI_Visual = setLockVis    
            local click = Instance.new("TextButton", card)    
            click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""; click.ZIndex = 999    
            click.MouseButton1Click:Connect(function() lockOn = not lockOn; setLockVis(lockOn); setUILock(lockOn); saveConfig() end)    
        end    
    
        do    
            local card = mkCard("Config", 38)    
            local lbl = Instance.new("TextLabel", card)    
            lbl.Size = UDim2.new(0,140,1,0)    
            lbl.Position = UDim2.new(0,12,0,0)    
            lbl.BackgroundTransparency = 1    
            lbl.Text = "Hide Buttons"    
            lbl.TextColor3 = Color3.fromRGB(255,255,255)    
            lbl.Font = Enum.Font.GothamBold    
            lbl.TextSize = 11    
            lbl.TextXAlignment = Enum.TextXAlignment.Left    
            lbl.ZIndex = 999    
            applyShimmerToText(lbl, 0.6)    
            local pill = Instance.new("Frame", card)    
            pill.Size = UDim2.new(0,28,0,16); pill.Position = UDim2.new(1,-36,0.5,-8)    
            pill.BackgroundColor3 = Color3.fromRGB(40,40,40); pill.BorderSizePixel = 0    
            pill.ZIndex = 999    
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)    
            local dot = Instance.new("Frame", pill)    
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)    
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0    
            dot.ZIndex = 999    
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)    
            local hideOn = false    
            local function setHideVis(on)    
                hideOn = on    
                pill.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)    
                dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)    
                dot.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(255,255,255)    
            end    
            S.setHideOpiumButtons = setHideVis    
            local click2 = Instance.new("TextButton", card)    
            click2.Size = UDim2.new(1,0,1,0); click2.BackgroundTransparency = 1; click2.Text = ""; click2.ZIndex = 999    
            click2.MouseButton1Click:Connect(function()    
                hideOn = not hideOn; setHideVis(hideOn)    
                if S.floatingPanelGui then S.floatingPanelGui.Enabled = not hideOn end    
                if S.instaResetPanelGui then S.instaResetPanelGui.Enabled = not hideOn end    
                if S.aimbotBypassPanelGui then S.aimbotBypassPanelGui.Enabled = not hideOn end    
                pcall(function()    
                    local pg = LP:FindFirstChild("PlayerGui")    
                    if pg then local og = pg:FindFirstChild("OpiumGGV5_2"); if og then og.Enabled = not hideOn end end    
                end)    
                S.hideOpiumButtonsEnabled = hideOn; saveConfig()    
            end)    
        end    
    
        do
            local card = mkCard("Config", 38)
            local lbl = Instance.new("TextLabel", card)
            lbl.Size = UDim2.new(0,140,1,0)
            lbl.Position = UDim2.new(0,12,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Save Config"
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 999
            applyShimmerToText(lbl, 0.6)
            local pill = Instance.new("Frame", card)
            pill.Size = UDim2.new(0,28,0,16); pill.Position = UDim2.new(1,-36,0.5,-8)
            pill.BackgroundColor3 = Color3.fromRGB(40,40,40); pill.BorderSizePixel = 0
            pill.ZIndex = 999
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", pill)
            dot.Size = UDim2.new(0,12,0,12); dot.Position = UDim2.new(0,2,0.5,-6)
            dot.BackgroundColor3 = Color3.fromRGB(255,255,255); dot.BorderSizePixel = 0
            dot.ZIndex = 999
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
            -- Leer el estado guardado del archivo de config
            local saveConfiOn = safeIsfile(S.CONFIG_FILE)
            saveConfiEnabled = saveConfiOn
            local function setSaveConfiVis(on)
                saveConfiOn = on
                pill.BackgroundColor3 = on and Color3.fromRGB(170,0,255) or Color3.fromRGB(40,40,40)
                dot.Position = on and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
            end
            setSaveConfiVis(saveConfiOn)
            local click = Instance.new("TextButton", card)
            click.Size = UDim2.new(1,0,1,0); click.BackgroundTransparency = 1; click.Text = ""; click.ZIndex = 999
            click.MouseButton1Click:Connect(function()
                saveConfiOn = not saveConfiOn
                setSaveConfiVis(saveConfiOn)
                saveConfiEnabled = saveConfiOn
                if saveConfiOn then
                    -- Guardar inmediatamente al activar
                    saveConfiEnabled = true
                    saveConfig()
                else
                    -- Desactivado: borrar el archivo de configuración guardado
                    pcall(function()
                        if type(delfile) == "function" then
                            pcall(delfile, S.CONFIG_FILE)
                        elseif type(writefile) == "function" then
                            writefile(S.CONFIG_FILE, "")
                        end
                    end)
                end
            end)
        end

        do    
            local card = mkCard("Config", 38)    
            local lbl = Instance.new("TextLabel", card)    
            lbl.Size = UDim2.new(0,140,1,0)    
            lbl.Position = UDim2.new(0,12,0,0)    
            lbl.BackgroundTransparency = 1    
            lbl.Text = "Reset Panel"    
            lbl.TextColor3 = Color3.fromRGB(255,255,255)    
            lbl.Font = Enum.Font.GothamBold    
            lbl.TextSize = 11    
            lbl.TextXAlignment = Enum.TextXAlignment.Left    
            lbl.ZIndex = 999    
            applyShimmerToText(lbl, 0.6)    
            local resetBtn = Instance.new("TextButton", card)    
            resetBtn.Size = UDim2.new(0,80,0,28); resetBtn.Position = UDim2.new(1,-90,0.5,-14)    
            resetBtn.BackgroundColor3 = Color3.fromRGB(20,10,35); resetBtn.BorderSizePixel = 0    
            resetBtn.Text = "Reset"; resetBtn.TextColor3 = C_ACCENT    
            resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 11    
            resetBtn.ZIndex = 999    
            Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 30)
            
            -- Add morado stroke to reset button
            local resetStroke = Instance.new("UIStroke", resetBtn)
            resetStroke.Color = Color3.fromRGB(170,0,255)
            resetStroke.Thickness = 1
            resetStroke.Transparency = 0.3    
            applyShimmerToText(resetBtn, 0.7)    
            resetBtn.MouseButton1Click:Connect(function()    
                local orig = resetBtn.Text; resetBtn.Text = "..."    
                task.spawn(function() resetFloatingPanel(); task.wait(0.2); resetBtn.Text = orig end)    
            end)    
        end    
    end    
    
    buildSpeedTab()    
    buildMainTab()    
    buildMoveTab()    
    buildConfigTab()    
    buildKeybindsTab()    
    
    switchTab = function(name)    
        if activePage then activePage.Visible = false end    
        activePage = pages[name]; activePage.Visible = true; panelTitle.Text = name    
        for tName, tData in pairs(tabBtns) do    
            local isActive = (tName == name)    
            tData.lbl.TextColor3 = isActive and C_WHITE or C_DIM    
            tData.ind.Visible = isActive    
            tData.bg.BackgroundColor3 = isActive and C_ACTIVE_BG or C_CARD_BG    
            tData.bg.BackgroundTransparency = isActive and 0.7 or 0.7    
            tData.stroke.Transparency = isActive and 0 or 0.4    
        end    
    end    
    
    local function showGui()    
        main.Visible = true    
        if S.miniToggleButton then S.miniToggleButton.Visible = false end    
    end    
    
    local function buildGui_createMiniToggle(guiParent, showFn)    
        local miniToggleBtn = Instance.new("TextButton", guiParent)    
        miniToggleBtn.Name = "MiniToggle"    
        miniToggleBtn.Size = UDim2.new(0,160,0,36)    
        miniToggleBtn.Position = UDim2.new(0,38,0,60)    
        miniToggleBtn.BackgroundColor3 = Color3.fromRGB(10,10,10)    
        miniToggleBtn.BorderSizePixel = 0    
        miniToggleBtn.Text = ""    
        miniToggleBtn.ZIndex = 999    
        miniToggleBtn.Visible = true    
        Instance.new("UICorner", miniToggleBtn).CornerRadius = UDim.new(0,8)    
        local miniStroke = Instance.new("UIStroke", miniToggleBtn)    
        miniStroke.Color = Color3.fromRGB(255,255,255)    
        miniStroke.Thickness = 1    
        miniStroke.Transparency = 0.92    
        local miniMainText = Instance.new("TextLabel", miniToggleBtn)    
        miniMainText.Size = UDim2.new(1,-38,1,0)    
        miniMainText.Position = UDim2.new(0,32,0,0)    
        miniMainText.BackgroundTransparency = 1    
        miniMainText.Text = "New Era Hub"    
        miniMainText.TextColor3 = Color3.fromRGB(170,0,255)    
        miniMainText.Font = Enum.Font.GothamBlack    
        miniMainText.TextSize = 14    
        miniMainText.TextXAlignment = Enum.TextXAlignment.Left    
        miniMainText.ZIndex = 999    
        applyShimmerToText(miniMainText, 0.6)    
        makeDraggable(miniToggleBtn, false)    
        miniToggleBtn.MouseButton1Click:Connect(showFn)    
        return miniToggleBtn    
    end    
    S.miniToggleButton = buildGui_createMiniToggle(gui, showGui)    
    S.miniToggleButton.Visible = true    
    
    UIS.InputBegan:Connect(function(input, gpe)    
        if input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType ~= Enum.UserInputType.Gamepad1 then return end    
        local kc = input.KeyCode    
        local function match(entry) return entry and (kc == entry.kb or (entry.gp and kc == entry.gp)) end    
        if gpe and input.UserInputType == Enum.UserInputType.Keyboard then    
            if match(S.KB.GuiHide) then    
                if main.Visible then main.Visible = false; if S.miniToggleButton then S.miniToggleButton.Visible = true end    
                else showGui() end    
            end    
            return    
        end    
        if match(S.KB.DropBrainrot) then task.spawn(runDrop)    
        elseif match(S.KB.TPFlor) then runTPFloor()    
        elseif match(S.KB.AutoLeft) then    
            S.autoLeftEnabled = not S.autoLeftEnabled    
            if S.autoLeftEnabled then    
                if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end    
                if autoBatEnabled then disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end    
                startAutoLeft()    
            else stopAutoLeft() end    
            if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end    
            S.restartMovement(); refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.AutoRight) then    
            S.autoRightEnabled = not S.autoRightEnabled    
            if S.autoRightEnabled then    
                if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end    
                if autoBatEnabled then disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end end    
                startAutoRight()    
            else stopAutoRight() end    
            if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end    
            S.restartMovement(); refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.AutoBat) then    
            local newState = not autoBatEnabled    
            if newState then    
                if S.autoLeftEnabled then S.autoLeftEnabled = false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; stopAutoLeft() end    
                if S.autoRightEnabled then S.autoRightEnabled = false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; stopAutoRight() end    
                enableAutoBat()    
            else    
                disableAutoBat()    
            end    
            if autoBatSetVisual then autoBatSetVisual(newState) end    
            refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.GuiHide) then    
            if main.Visible then main.Visible = false; if S.miniToggleButton then S.miniToggleButton.Visible = true end    
            else showGui() end    
        elseif match(S.KB.SpeedToggle) then    
            if S.laggerMode ~= 0 then S.laggerMode = 0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            S.speedMode = not S.speedMode    
            if S.speedClk then S.speedClk(S.speedMode) end    
            refreshFloatingButtonsVisual(); saveConfig(); autoActivateCarryIfHoldingAnimal()    
        elseif match(S.KB.LaggerToggle) then    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end end    
            S.laggerMode = S.laggerMode == 1 and 2 or 1    
            updateLaggerButtonVisual(); if S.setLaggerVisual then S.setLaggerVisual(true) end    
            refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.AutoTPDown) then    
            S.autoTPDownEnabled = not S.autoTPDownEnabled    
            if S.autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end    
            if S.autoTPDownSetVisual then S.autoTPDownSetVisual(S.autoTPDownEnabled) end    
            if S.autoTPDownFloatVisual then S.autoTPDownFloatVisual(S.autoTPDownEnabled) end    
            refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.SpeedMode1) then    
            if S.laggerMode ~= 0 then S.laggerMode = 0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            S.normalPreset = 1    
            if S._menuSetActive1 then S._menuSetActive1(true); S._menuSetActive2(false); S._menuSetActive3(false) end    
            if S.speedPanelActive then S.speedPanelActive(1) end; saveConfig()    
        elseif match(S.KB.SpeedMode2) then    
            if S.laggerMode ~= 0 then S.laggerMode = 0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            S.normalPreset = 2    
            if S._menuSetActive1 then S._menuSetActive1(false); S._menuSetActive2(true); S._menuSetActive3(false) end    
            if S.speedPanelActive then S.speedPanelActive(2) end; saveConfig()    
        elseif match(S.KB.SpeedMode3) then    
            if S.laggerMode ~= 0 then S.laggerMode = 0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            S.normalPreset = 3    
            if S._menuSetActive1 then S._menuSetActive1(false); S._menuSetActive2(false); S._menuSetActive3(true) end    
            if S.speedPanelActive then S.speedPanelActive(3) end; saveConfig()    
        elseif match(S.KB.LaggerMode1) then    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            if S.normalPreset ~= 0 then    
                if S._menuSetActive1 then S._menuSetActive1(false) end    
                if S._menuSetActive2 then S._menuSetActive2(false) end    
                if S._menuSetActive3 then S._menuSetActive3(false) end    
                S.normalPreset = 0; if S.speedPanelActive then S.speedPanelActive(0) end    
            end    
            S.laggerMode = 1    
            if S._menuSetActiveL1 then S._menuSetActiveL1(true); S._menuSetActiveL2(false) end    
            if S.setLaggerVisual then S.setLaggerVisual(true) end; updateLaggerButtonVisual(); refreshFloatingButtonsVisual(); saveConfig()    
        elseif match(S.KB.LaggerMode2) then    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            if S.normalPreset ~= 0 then    
                if S._menuSetActive1 then S._menuSetActive1(false) end    
                if S._menuSetActive2 then S._menuSetActive2(false) end    
                if S._menuSetActive3 then S._menuSetActive3(false) end    
                S.normalPreset = 0; if S.speedPanelActive then S.speedPanelActive(0) end    
            end    
            S.laggerMode = 2    
            if S._menuSetActiveL1 then S._menuSetActiveL1(false); S._menuSetActiveL2(true) end    
            if S.setLaggerVisual then S.setLaggerVisual(true) end; updateLaggerButtonVisual(); refreshFloatingButtonsVisual(); saveConfig()    
        end    
    end)    
end    
    
-- ==================== FLOATING BUTTON PANEL ====================    
local function switchFloatingButtonsLayout(isIndividual)
    local panelGui = S.floatingPanelGui
    local panelFrame = S.floatingPanelFrame
    local btnGrid = S._floatingButtons and S._floatingButtons._btnGrid
    if not panelGui or not panelFrame or not btnGrid then return end
    
    if isIndividual then
        -- Store original parent and positions
        local btnBackup = {}
        for _, btn in ipairs(btnGrid:GetChildren()) do
            if btn:IsA("TextButton") then
                table.insert(btnBackup, {btn = btn, origParent = btn.Parent, origPos = btn.Position, origSize = btn.Size})
            end
        end
        S._btnBackup = btnBackup
        
        -- Remove grid layout
        local gridLayout = btnGrid:FindFirstChildOfClass("UIGridLayout")
        if gridLayout then gridLayout:Destroy() end
        
        -- Move buttons to panelGui and position them in screen space
        for _, backup in ipairs(btnBackup) do
            local btn = backup.btn
            local absPos = btn.AbsolutePosition
            local newX = absPos.X
            local newY = absPos.Y
            
            btn.Parent = panelGui
            btn.Position = UDim2.new(0, newX, 0, newY)
            btn.Size = UDim2.new(0, 65, 0, 62)
        end
        
        -- Add drag support
        local UIS = game:GetService("UserInputService")
        local draggingBtn = nil
        local dragStart = nil
        local startPos = nil
        
        for _, btn in ipairs(panelGui:GetChildren()) do
            if btn:IsA("TextButton") and btn.Size.X.Offset == 65 then
                btn.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        draggingBtn = btn
                        dragStart = inp.Position
                        startPos = btn.AbsolutePosition
                        inp.Changed:Connect(function()
                            if inp.UserInputState == Enum.UserInputState.End then
                                draggingBtn = nil
                            end
                        end)
                    end
                end)
            end
        end
        
        -- Global input changed handler
        S._dragConnection = UIS.InputChanged:Connect(function(inp)
            if draggingBtn and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local dx = inp.Position.X - dragStart.X
                local dy = inp.Position.Y - dragStart.Y
                
                local sw = workspace.CurrentCamera.ViewportSize.X
                local sh = workspace.CurrentCamera.ViewportSize.Y
                
                local newX = math.clamp(startPos.X + dx, 0, sw - 65)
                local newY = math.clamp(startPos.Y + dy, 0, sh - 62)
                
                draggingBtn.Position = UDim2.new(0, newX, 0, newY)
            end
        end)
    else
        -- Disconnect drag handler
        if S._dragConnection then S._dragConnection:Disconnect() end
        
        -- Move buttons back to grid
        if S._btnBackup then
            local gridLayout = Instance.new("UIGridLayout", btnGrid)
            gridLayout.CellSize = UDim2.new(0, 65, 0, 62)
            gridLayout.CellPadding = UDim2.new(0, 8, 0, 10)
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gridLayout.FillDirectionMaxCells = 2
            
            for _, backup in ipairs(S._btnBackup) do
                backup.btn.Parent = btnGrid
                backup.btn.Position = UDim2.new(0, 0, 0, 0)
                backup.btn.Size = UDim2.new(1, 0, 1, 0)
            end
        end
    end
end

local function createFloatingButtonPanel()    
    local panelGui = Instance.new("ScreenGui")    
    panelGui.Name = "NewEraHub_FloatingPanel"    
    panelGui.ResetOnSpawn = false    
    panelGui.IgnoreGuiInset = true    
    panelGui.DisplayOrder = 999998    
    if not pcall(function() panelGui.Parent = game:GetService("CoreGui") end) then    
        panelGui.Parent = LP:WaitForChild("PlayerGui")    
    end    
    S.floatingPanelGui = panelGui    
    
    local panelFrame = Instance.new("Frame", panelGui)    
    panelFrame.Size = UDim2.new(0, 150, 0, 0)    
    panelFrame.Position = UDim2.new(1, -158, 0.5, -130)    
    panelFrame.BackgroundColor3 = Color3.fromRGB(4, 4, 6)    
    panelFrame.BackgroundTransparency = 1; panelFrame.BorderSizePixel = 0    
    panelFrame.Active = false; panelFrame.ZIndex = 998    
    panelFrame.AutomaticSize = Enum.AutomaticSize.Y; panelFrame.ClipsDescendants = false    
    Instance.new("UICorner", panelFrame).CornerRadius = UDim.new(0, 20)    
    S.floatingPanelFrame = panelFrame    
    makeDraggable(panelFrame, true)    
    
    local lastSaveTime = 0    
    panelFrame:GetPropertyChangedSignal("Position"):Connect(function()    
        if tick() - lastSaveTime > 0.5 then lastSaveTime = tick(); saveConfig() end    
    end)    
    
    local btnGrid = Instance.new("Frame", panelFrame)    
    btnGrid.Size = UDim2.new(1, -8, 0, 0); btnGrid.Position = UDim2.new(0, 4, 0, 20)    
    btnGrid.BackgroundTransparency = 1; btnGrid.ZIndex = 998; btnGrid.AutomaticSize = Enum.AutomaticSize.Y    
    local gridLayout = Instance.new("UIGridLayout", btnGrid)    
    gridLayout.CellSize = UDim2.new(0, 65, 0, 62)    
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 10)    
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder    
    gridLayout.FillDirectionMaxCells = 2    
    local pad = Instance.new("UIPadding", btnGrid)    
    pad.PaddingLeft = UDim.new(0,2); pad.PaddingRight = UDim.new(0,2)    
    pad.PaddingTop = UDim.new(0,2); pad.PaddingBottom = UDim.new(0,2)    
    
    local BLACK_OFF = Color3.fromRGB(0,0,0)    
    local WHITE_ON  = Color3.fromRGB(170,0,255)    
    local STROKE_OFF = Color3.fromRGB(100,100,100)    
    local STROKE_ON  = Color3.fromRGB(170,0,255)    
    
    local function makePButton(label1, label2, order)    
        local btn = Instance.new("TextButton", btnGrid)    
        btn.LayoutOrder = order; btn.BackgroundColor3 = BLACK_OFF; btn.BorderSizePixel = 0    
        btn.Text = ""; btn.ZIndex = 998    
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)    
        
        -- Add drop shadow effect
        local shadowStroke = Instance.new("UIStroke", btn)
        shadowStroke.Color = Color3.fromRGB(0,0,0)
        shadowStroke.Thickness = 2
        shadowStroke.Transparency = 0.7
        
        local stroke = Instance.new("UIStroke", btn)    
        stroke.Color = STROKE_OFF; stroke.Thickness = 1; stroke.Transparency = 0.15
        -- Add morado glow effect
        local glowStroke = Instance.new("UIStroke", btn)
        glowStroke.Color = Color3.fromRGB(170,0,255)
        glowStroke.Thickness = 0.5
        glowStroke.Transparency = 0.6
        local t1 = Instance.new("TextLabel", btn)    
        t1.Size = UDim2.new(1,0,0.55,0); t1.Position = UDim2.new(0,0,0.06,0)    
        t1.BackgroundTransparency = 1; t1.Text = label1; t1.TextColor3 = WHITE_ON    
        t1.Font = Enum.Font.GothamBlack; t1.TextSize = 10; t1.TextXAlignment = Enum.TextXAlignment.Center; t1.ZIndex = 998    
        applyShimmerToText(t1, 0.6)    
        local t2 = Instance.new("TextLabel", btn)    
        t2.Size = UDim2.new(1,0,0.4,0); t2.Position = UDim2.new(0,0,0.55,0)    
        t2.BackgroundTransparency = 1; t2.Text = label2; t2.TextColor3 = WHITE_ON    
        t2.Font = Enum.Font.GothamBlack; t2.TextSize = 8; t2.TextXAlignment = Enum.TextXAlignment.Center; t2.ZIndex = 998    
        applyShimmerToText(t2, 0.6)    
        if label1 == "DROP" then    
            t2.Visible = false; t1.Size = UDim2.new(1,0,1,0); t1.Position = UDim2.new(0,0,0,0)    
            t1.TextScaled = false; t1.TextSize = 11    
        end    
        return btn, stroke, t1, t2    
    end    
    
    local function setButtonActive(btn, stroke, label1, label2, active)    
        -- Use vibrant morado when active, black when inactive
        btn.BackgroundColor3 = active and Color3.fromRGB(170,0,255) or BLACK_OFF    
        stroke.Color = active and Color3.fromRGB(200,100,255) or STROKE_OFF    
        stroke.Transparency = active and 0 or 0.2
        -- Text color: white when active, normal when inactive
        local textColor = active and Color3.fromRGB(255,255,255) or WHITE_ON    
        if label1 then label1.TextColor3 = textColor end    
        if label2 then label2.TextColor3 = textColor end    
    end    
    S._setPButtonActive = setButtonActive    
    
    local btnDROP, bsDROP, l1DROP, l2DROP = makePButton("DROP", "BRAINROT", 1)    
    local btnAL, bsAL, l1AL, l2AL = makePButton("AUTO", "LEFT", 2)    
    local btnBAT, bsBAT, l1BAT, l2BAT = makePButton("BAT", "AIMBOT", 3)    
    local btnAR, bsAR, l1AR, l2AR = makePButton("AUTO", "RIGHT", 4)    
    local btnTP, bsTP, l1TP, l2TP = makePButton("TP", "DOWN", 5)    
    local btnCS, bsCS, l1CS, l2CS = makePButton("CARRY", "SPD", 6)    
    local btnLAG, bsLAG, l1LAG, l2LAG = makePButton("LAGGER", "MODE", 7)    
    local btnLS2, bsLS2, l1LS2, l2LS2 = makePButton("LAGGER", "SPD 2", 8)    
    local spacerAB = Instance.new("Frame", btnGrid)    
    spacerAB.LayoutOrder = 9; spacerAB.BackgroundTransparency = 1; spacerAB.BorderSizePixel = 0    
    spacerAB.Visible = false    
    
    S._btnAAL = btnAL; S._bsAAL = bsAL; S._l1AAL = l1AL; S._l2AAL = l2AL    
    S._btnAAR = btnAR; S._bsAAR = bsAR; S._l1AAR = l1AR; S._l2AAR = l2AR    
    S._btnBAT = btnBAT; S._bsBAT = bsBAT; S._l1BAT = l1BAT; S._l2BAT = l2BAT    
    
    S._floatingButtons = {    
        _btnGrid = btnGrid,
        lagger = btnLAG, strokeLagger = bsLAG, l1Lagger = l1LAG, l2Lagger = l2LAG,    
        carry = btnCS, strokeCarry = bsCS, l1Carry = l1CS, l2Carry = l2CS,    
        autoLeft = btnAL, strokeAutoLeft = bsAL, l1AutoLeft = l1AL, l2AutoLeft = l2AL,    
        autoRight = btnAR, strokeAutoRight = bsAR, l1AutoRight = l1AR, l2AutoRight = l2AR,    
        bat = btnBAT, strokeBat = bsBAT, l1Bat = l1BAT, l2Bat = l2BAT,    
        laggerSpeed2 = btnLS2, strokeLaggerSpeed2 = bsLS2, l1LaggerSpeed2 = l1LS2, l2LaggerSpeed2 = l2LS2,    
    }    
    
    l1LAG.Text = "LAGGER"; l2LAG.Text = "1"    
    setButtonActive(btnLAG, bsLAG, l1LAG, l2LAG, true)    
    setButtonActive(btnCS, bsCS, l1CS, l2CS, S.speedMode)    
    setButtonActive(btnAL, bsAL, l1AL, l2AL, S.autoLeftEnabled)    
    setButtonActive(btnAR, bsAR, l1AR, l2AR, S.autoRightEnabled)    
    setButtonActive(btnBAT, bsBAT, l1BAT, l2BAT, autoBatEnabled)    
    setButtonActive(btnLS2, bsLS2, l1LS2, l2LS2, S.laggerMode == 2)    
    
    
    btnDROP.MouseButton1Click:Connect(function()    
        setButtonActive(btnDROP, bsDROP, l1DROP, l2DROP, true)    
        task.delay(0.5, function() setButtonActive(btnDROP, bsDROP, l1DROP, l2DROP, false) end)    
        task.spawn(runDrop)    
    end)    
    btnTP.MouseButton1Click:Connect(function()    
        setButtonActive(btnTP, bsTP, l1TP, l2TP, true)    
        task.delay(0.35, function() setButtonActive(btnTP, bsTP, l1TP, l2TP, false) end)    
        runTPFloor()    
    end)    
        
    -- BotÃ³n Auto Left    
    btnAL.MouseButton1Click:Connect(function()    
        local newState = not S.autoLeftEnabled    
        if newState then    
            if S.autoRightEnabled then    
                S.autoRightEnabled = false    
                stopAutoRight()    
                if S.autoRightSetVisual then S.autoRightSetVisual(false) end    
                setButtonActive(btnAR, bsAR, l1AR, l2AR, false)    
            end    
            if autoBatEnabled then    
                disableAutoBat()    
                if autoBatSetVisual then autoBatSetVisual(false) end    
                setButtonActive(btnBAT, bsBAT, l1BAT, l2BAT, false)    
            end    
            S.autoLeftEnabled = true    
            startAutoLeft()    
        else    
            S.autoLeftEnabled = false    
            stopAutoLeft()    
        end    
        if S.autoLeftSetVisual then S.autoLeftSetVisual(newState) end    
        setButtonActive(btnAL, bsAL, l1AL, l2AL, newState)    
        S.restartMovement()    
        refreshFloatingButtonsVisual()    
        saveConfig()    
    end)    
        
    -- BotÃ³n Auto Right    
    btnAR.MouseButton1Click:Connect(function()    
        local newState = not S.autoRightEnabled    
        if newState then    
            if S.autoLeftEnabled then    
                S.autoLeftEnabled = false    
                stopAutoLeft()    
                if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end    
                setButtonActive(btnAL, bsAL, l1AL, l2AL, false)    
            end    
            if autoBatEnabled then    
                disableAutoBat()    
                if autoBatSetVisual then autoBatSetVisual(false) end    
                setButtonActive(btnBAT, bsBAT, l1BAT, l2BAT, false)    
            end    
            S.autoRightEnabled = true    
            startAutoRight()    
        else    
            S.autoRightEnabled = false    
            stopAutoRight()    
        end    
        if S.autoRightSetVisual then S.autoRightSetVisual(newState) end    
        setButtonActive(btnAR, bsAR, l1AR, l2AR, newState)    
        S.restartMovement()    
        refreshFloatingButtonsVisual()    
        saveConfig()    
    end)    
        
    -- BotÃ³n Auto Bat (nuevo aimbot)    
    btnBAT.MouseButton1Click:Connect(function()    
        local newState = not autoBatEnabled    
        if newState then    
            if S.autoLeftEnabled then    
                S.autoLeftEnabled = false    
                stopAutoLeft()    
                if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end    
                setButtonActive(btnAL, bsAL, l1AL, l2AL, false)    
            end    
            if S.autoRightEnabled then    
                S.autoRightEnabled = false    
                stopAutoRight()    
                if S.autoRightSetVisual then S.autoRightSetVisual(false) end    
                setButtonActive(btnAR, bsAR, l1AR, l2AR, false)    
            end    
            enableAutoBat()    
        else    
            disableAutoBat()    
        end    
        setButtonActive(btnBAT, bsBAT, l1BAT, l2BAT, autoBatEnabled)    
        if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end    
        refreshFloatingButtonsVisual()    
        saveConfig()    
    end)    
        
    btnLAG.MouseButton1Click:Connect(function()    
        S.laggerMode = (S.laggerMode == 1) and 0 or 1    
        local isOn = S.laggerMode == 1    
        if isOn then    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; setButtonActive(btnCS, bsCS, l1CS, l2CS, false) end    
            if S._menuSetActive1 then S._menuSetActive1(false) end    
            if S._menuSetActive2 then S._menuSetActive2(false) end    
            if S._menuSetActive3 then S._menuSetActive3(false) end    
        end    
        if S._menuSetActiveL1 then S._menuSetActiveL1(isOn) end    
        if S._menuSetActiveL2 then S._menuSetActiveL2(false) end    
        setButtonActive(btnLS2, bsLS2, l1LS2, l2LS2, false)    
        updateLaggerButtonVisual(); if S.setLaggerVisual then S.setLaggerVisual(isOn) end    
        refreshFloatingButtonsVisual(); saveConfig()    
    end)    
    btnCS.MouseButton1Click:Connect(function()    
        local newState = not S.speedMode    
        if newState and S.laggerMode ~= 0 then    
            S.laggerMode = 0    
            if S._menuSetActiveL1 then S._menuSetActiveL1(false) end    
            if S._menuSetActiveL2 then S._menuSetActiveL2(false) end    
            if S.setLaggerVisual then S.setLaggerVisual(false) end    
            updateLaggerButtonVisual()    
        end    
        S.speedMode = newState    
        if S.speedClk then S.speedClk(newState) end    
        setButtonActive(btnCS, bsCS, l1CS, l2CS, newState)    
        refreshFloatingButtonsVisual(); saveConfig()    
    end)    
    btnLS2.MouseButton1Click:Connect(function()    
        S.laggerMode = (S.laggerMode == 2) and 0 or 2    
        local isOn = S.laggerMode == 2    
        if isOn then    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; setButtonActive(btnCS, bsCS, l1CS, l2CS, false) end    
        end    
        if S._menuSetActiveL1 then S._menuSetActiveL1(S.laggerMode == 1) end    
        if S._menuSetActiveL2 then S._menuSetActiveL2(S.laggerMode == 2) end    
        if S.setLaggerVisual then S.setLaggerVisual(isOn) end    
        updateLaggerButtonVisual()    
        setButtonActive(btnLS2, bsLS2, l1LS2, l2LS2, isOn)    
        refreshFloatingButtonsVisual(); saveConfig()    
    end)    
end    
    
local function createSpeedPanel()    
    local DEFAULT_POSITIONS = {{x=10,y=-60},{x=10,y=-18},{x=10,y=24}}    
    S.speedPanelFrames = {}    
    local updateFuncs = {}    
    
    local function makeIndependentSpeedButton(presetNum, defaultOffsetX, defaultOffsetY)    
        local g = Instance.new("ScreenGui")    
        g.Name = "NewEraHub_SpeedPanel" .. presetNum    
        g.ResetOnSpawn = false    
        g.IgnoreGuiInset = true    
        g.DisplayOrder = 999997    
        if not pcall(function() g.Parent = game:GetService("CoreGui") end) then    
            g.Parent = LP:WaitForChild("PlayerGui")    
        end    
        g.Enabled = false    
        local frame = Instance.new("Frame", g)    
        frame.Size = UDim2.new(0, 120, 0, 36)    
        frame.Position = UDim2.new(0, defaultOffsetX, 0.5, defaultOffsetY)    
        frame.BackgroundTransparency = 1; frame.BorderSizePixel = 0    
        frame.Active = true; frame.ZIndex = 998; frame.ClipsDescendants = false    
        S.speedPanelFrames[presetNum] = frame    
        local lastSaveTime = 0    
        frame:GetPropertyChangedSignal("Position"):Connect(function()    
            if tick() - lastSaveTime > 0.5 then lastSaveTime = tick(); saveConfig() end    
        end)    
        local btn = Instance.new("TextButton", frame)    
        btn.Size = UDim2.new(1,0,1,0); btn.BackgroundColor3 = Color3.fromRGB(0,0,0)    
        btn.BorderSizePixel = 0; btn.Text = "Speed " .. presetNum    
        btn.TextColor3 = Color3.fromRGB(170,0,255); btn.Font = Enum.Font.GothamBlack    
        btn.TextSize = 13; btn.ZIndex = 998    
        applyShimmerToText(btn, 0.6)    
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)    
        local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(100,100,100); stroke.Thickness = 1; stroke.Transparency = 0.15    
        local dDragging, dDragStart, dStartPos, dMoved = false, nil, nil, false    
        btn.InputBegan:Connect(function(inp)    
            if S.lockUIEnabled then return end    
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then    
                dDragging = true; dMoved = false; dDragStart = inp.Position; dStartPos = frame.Position    
                inp.Changed:Connect(function()    
                    if inp.UserInputState == Enum.UserInputState.End then dDragging = false; if dMoved then saveConfig() end end    
                end)    
            end    
        end)    
        UIS.InputChanged:Connect(function(inp)    
            if not dDragging then return end    
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then    
                local delta = inp.Position - dDragStart    
                if delta.Magnitude > 8 then    
                    dMoved = true    
                    frame.Position = UDim2.new(dStartPos.X.Scale, dStartPos.X.Offset + delta.X, dStartPos.Y.Scale, dStartPos.Y.Offset + delta.Y)    
                end    
            end    
        end)    
        local function updateVisual()    
            local isActive = (presetNum == S.normalPreset)    
            btn.BackgroundColor3 = isActive and Color3.fromRGB(170,0,255) or Color3.fromRGB(0,0,0)    
            btn.TextColor3 = isActive and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,0,255)    
            stroke.Color = isActive and Color3.fromRGB(170,0,255) or Color3.fromRGB(100,100,100)    
            stroke.Transparency = isActive and 0 or 0.2    
        end    
        btn.MouseButton1Click:Connect(function()    
            if dMoved then return end    
            if S.speedMode then S.speedMode = false; if S.speedClk then S.speedClk(false) end; refreshFloatingButtonsVisual() end    
            if S.laggerMode ~= 0 then S.laggerMode = 0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end    
            S.normalPreset = presetNum    
            if S._menuSetActive1 then S._menuSetActive1(presetNum == 1) end    
            if S._menuSetActive2 then S._menuSetActive2(presetNum == 2) end    
            if S._menuSetActive3 then S._menuSetActive3(presetNum == 3) end    
            for _, fn in ipairs(updateFuncs) do fn() end    
            saveConfig(); autoActivateCarryIfHoldingAnimal()    
        end)    
        updateVisual()    
        return frame, updateVisual    
    end    
    
    for i, pos in ipairs(DEFAULT_POSITIONS) do    
        local frame, upd = makeIndependentSpeedButton(i, pos.x, pos.y)    
        table.insert(updateFuncs, upd)    
    end    
    S.speedPanelFrame = S.speedPanelFrames[1]    
    local function refreshAll() for _, fn in ipairs(updateFuncs) do fn() end end    
    S.speedPanelActive = function(_) refreshAll() end    
    refreshAll()    
end    
    
local function createHUD()
    local PURPLE = Color3.fromRGB(170,0,255)
    local CYAN   = Color3.fromRGB(0, 180, 255)
    local WHITE  = Color3.fromRGB(255, 255, 255)
    local DIM    = Color3.fromRGB(120, 120, 140)
    local BG     = Color3.fromRGB(8, 8, 12)
    local CARD   = Color3.fromRGB(22, 22, 30)

    local HudGui = Instance.new("ScreenGui")
    HudGui.Name = "NewEraHub_PhazeHUD"
    HudGui.ResetOnSpawn = false
    HudGui.IgnoreGuiInset = true
    HudGui.DisplayOrder = 999996
    if not pcall(function() HudGui.Parent = game:GetService("CoreGui") end) then
        HudGui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- pbFrame: barra principal estilo Candy hub
    local pbFrame = Instance.new("Frame", HudGui)
    pbFrame.Size = UDim2.new(0, 302, 0, 40)
    pbFrame.Position = UDim2.new(0.5, -151, 0, 10)
    pbFrame.BackgroundColor3 = BG
    pbFrame.BorderSizePixel = 0
    pbFrame.ClipsDescendants = false
    pbFrame.Active = true
    pbFrame.Visible = false
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)

    -- Borde con gradiente morado->cyan
    local pbs = Instance.new("UIStroke", pbFrame)
    pbs.Color = PURPLE; pbs.Thickness = 1.5; pbs.Transparency = 0.1
    local pbsGrad = Instance.new("UIGradient", pbs)
    pbsGrad.Color = ColorSequence.new(PURPLE, CYAN)
    pbsGrad.Rotation = 25

    -- Separador vertical helper
    local function mkSep(x)
        local sep = Instance.new("Frame", pbFrame)
        sep.Size = UDim2.new(0, 1, 0, 14)
        sep.Position = UDim2.new(0, x, 0, 5)
        sep.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        sep.BorderSizePixel = 0
        sep.BackgroundTransparency = 0.45
        return sep
    end

    -- STATUS (izquierda)
    S.progressPct = Instance.new("TextLabel", pbFrame)
    S.progressPct.Size = UDim2.new(0, 62, 0, 14)
    S.progressPct.Position = UDim2.new(0, 10, 0, 5)
    S.progressPct.BackgroundTransparency = 1
    S.progressPct.Text = "IDLE"
    S.progressPct.TextColor3 = WHITE
    S.progressPct.Font = Enum.Font.GothamBlack
    S.progressPct.TextSize = 9
    S.progressPct.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(S.progressPct, 0.6)

    mkSep(76)

    -- FPS (morado)
    local fpsLbl = Instance.new("TextLabel", pbFrame)
    fpsLbl.Size = UDim2.new(0, 52, 0, 14)
    fpsLbl.Position = UDim2.new(0, 82, 0, 5)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS:--"
    fpsLbl.TextColor3 = PURPLE
    fpsLbl.Font = Enum.Font.GothamBlack
    fpsLbl.TextSize = 9
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(fpsLbl, 0.6)

    mkSep(138)

    -- PING (cyan)
    local pingLbl = Instance.new("TextLabel", pbFrame)
    pingLbl.Size = UDim2.new(0, 72, 0, 14)
    pingLbl.Position = UDim2.new(0, 144, 0, 5)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "PING:--"
    pingLbl.TextColor3 = CYAN
    pingLbl.Font = Enum.Font.GothamBlack
    pingLbl.TextSize = 9
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(pingLbl, 0.6)

    mkSep(220)

    -- RAD label
    local radTag = Instance.new("TextLabel", pbFrame)
    radTag.Size = UDim2.new(0, 30, 0, 14)
    radTag.Position = UDim2.new(0, 226, 0, 5)
    radTag.BackgroundTransparency = 1
    radTag.Text = "RAD"
    radTag.TextColor3 = DIM
    radTag.Font = Enum.Font.GothamBlack
    radTag.TextSize = 9
    radTag.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(radTag, 0.6)

    -- RAD value box editable
    local progressRadLbl = Instance.new("TextBox", pbFrame)
    progressRadLbl.Size = UDim2.new(0, 42, 0, 18)
    progressRadLbl.Position = UDim2.new(1, -50, 0, 4)
    progressRadLbl.BackgroundColor3 = CARD
    progressRadLbl.BorderSizePixel = 0
    progressRadLbl.Text = tostring(S.autoStealRadius)
    progressRadLbl.TextColor3 = WHITE
    progressRadLbl.Font = Enum.Font.GothamBlack
    progressRadLbl.TextSize = 11
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    applyShimmerToText(progressRadLbl, 0.7)
    progressRadLbl.ClearTextOnFocus = false
    progressRadLbl.ZIndex = 3
    Instance.new("UICorner", progressRadLbl).CornerRadius = UDim.new(0, 6)
    local radStroke = Instance.new("UIStroke", progressRadLbl)
    radStroke.Color = PURPLE; radStroke.Thickness = 1; radStroke.Transparency = 0.35
    local radStrokeGrad = Instance.new("UIGradient", radStroke)
    radStrokeGrad.Color = ColorSequence.new(PURPLE, CYAN)
    radStrokeGrad.Rotation = 0
    local TS2 = game:GetService("TweenService")
    progressRadLbl.Focused:Connect(function()
        TS2:Create(radStroke, TweenInfo.new(0.12), {Transparency=0.02}):Play()
    end)
    progressRadLbl.FocusLost:Connect(function()
        TS2:Create(radStroke, TweenInfo.new(0.12), {Transparency=0.35}):Play()
        local v = tonumber(progressRadLbl.Text)
        if v and v >= 0.5 and v <= 300 then
            S.autoStealRadius = v
            progressRadLbl.Text = tostring(v)
        else
            progressRadLbl.Text = tostring(S.autoStealRadius)
        end
    end)

    -- Barra de progreso abajo
    local pbg = Instance.new("Frame", pbFrame)
    pbg.Size = UDim2.new(1, -20, 0, 6)
    pbg.Position = UDim2.new(0, 10, 1, -11)
    pbg.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    pbg.BorderSizePixel = 0
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
    local pbgStroke = Instance.new("UIStroke", pbg)
    pbgStroke.Color = Color3.fromRGB(50, 50, 65); pbgStroke.Thickness = 1; pbgStroke.Transparency = 0.5

    S.progressFill = Instance.new("Frame", pbg)
    S.progressFill.Size = UDim2.new(0, 0, 1, 0)
    S.progressFill.BackgroundColor3 = PURPLE
    S.progressFill.BorderSizePixel = 0
    Instance.new("UICorner", S.progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", S.progressFill)
    fillGrad.Color = ColorSequence.new(PURPLE, CYAN)

    -- Draggable
    local hudDragging, hudDragStart, hudStartPos, hudMoved = false, nil, nil, false
    pbFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            hudDragging = true; hudMoved = false
            hudDragStart = inp.Position; hudStartPos = pbFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then hudDragging = false end
            end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(inp)
        if not hudDragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - hudDragStart
            if delta.Magnitude > 6 then
                hudMoved = true
                pbFrame.Position = UDim2.new(
                    hudStartPos.X.Scale, hudStartPos.X.Offset + delta.X,
                    hudStartPos.Y.Scale, hudStartPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- FPS counter
    local fpsAccum, fpsFrames, fpsLast = 0, 0, tick()
    RunService.RenderStepped:Connect(function(dt)
        fpsAccum = fpsAccum + dt; fpsFrames = fpsFrames + 1
        if tick() - fpsLast >= 0.4 then
            fpsLbl.Text = string.format("FPS:%d", math.floor(fpsFrames/fpsAccum + 0.5))
            fpsAccum = 0; fpsFrames = 0; fpsLast = tick()
        end
    end)

    -- Ping counter
    task.spawn(function()
        while pbFrame.Parent do
            local ok, ping = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if ok and ping then
                pingLbl.Text = string.format("PING:%dms", math.floor(ping + 0.5))
            else
                local ok2, p2 = pcall(function() return LP:GetNetworkPing() * 1000 end)
                if ok2 and p2 then pingLbl.Text = string.format("PING:%dms", math.floor(p2 + 0.5)) end
            end
            task.wait(0.6)
        end
    end)

    -- Mantener referencia para compatibilidad
    S.topBarHUD = pbFrame
    S.progressBarFrame = pbFrame
end    
    
local function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    S.instaResetPanelGui = panel
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    S.instaResetBtnFrame = btnFrame
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(
            instaResetFloatingPos.XScale, instaResetFloatingPos.XOffset,
            instaResetFloatingPos.YScale, instaResetFloatingPos.YOffset)
    else
        btnFrame.Position = UDim2.new(1, -80, 0.85, 0)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(170,0,255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 21
    applyShimmerToText(label, 0.6)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(170,0,255)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.TextColor3 = Color3.fromRGB(170,0,255)
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(true)
                    cursedInstaReset()
                    task.delay(0.3, function()
                        if btnFrame and btnFrame.Parent then
                            setActive(false)
                        end
                    end)
                elseif not S.lockUIEnabled and hasMoved then
                    instaResetFloatingPos = {
                        XScale  = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale  = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset,
                    }
                    saveConfig()
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputEnded:Connect(onInputEnded)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved then
                if not S.lockUIEnabled then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                else
                    dragging = false
                end
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onInputEnded(input)
        end
    end)

    return panel
end

-- =========================== BAT V2 (,aimbot byppas) ===========================
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_AIMBOT_SPEED = 60
local BAT_V2_SWING_COOLDOWN = 0.08
local BAT_V2_HIT_DIST = 4.5

local batV2Toggled = false
local batV2HittingCooldown = false
local batV2AimbotConn = nil

local function findAnyToolV2()
    local c = LP.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end
    end
    return nil
end

local function getClosestPlayerV2()
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (myRoot.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = p end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if batV2HittingCooldown then return end
    batV2HittingCooldown = true
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local tool = findAnyToolV2()
    if tool then
        if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end
        local remote = tool:FindFirstChildOfClass("RemoteEvent")
        if remote then pcall(function() remote:FireServer() end) else pcall(function() tool:Activate() end) end
    end
    task.delay(BAT_V2_SWING_COOLDOWN, function() batV2HittingCooldown = false end)
end

local function startBatV2()
    if batV2AimbotConn then return end
    batV2AimbotConn = RunService.Heartbeat:Connect(function()
        if not batV2Toggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.Velocity
                local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                local offset = moveDir * BAT_V2_FOLLOW_DIST + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position
                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * BAT_V2_AIMBOT_SPEED
                    root.Velocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.Velocity = root.Velocity * 0.95
                    if root.Velocity.Magnitude < 1 then root.Velocity = Vector3.zero end
                end
                local distToTarget = (root.Position - targetRoot.Position).Magnitude
                if distToTarget <= BAT_V2_HIT_DIST then tryHitBatV2() end
            end
        else
            root.Velocity = root.Velocity * 0.9
            if root.Velocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
        end
    end)
end

local function stopBatV2()
    if batV2AimbotConn then batV2AimbotConn:Disconnect(); batV2AimbotConn = nil end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero end
    batV2HittingCooldown = false
end

local function createAimbotBypassFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "AimbotBypassButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    S.aimbotBypassPanelGui = panel

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    S.aimbotBypassBtnFrame = btnFrame
    -- Restaurar posición guardada o usar la default
    if aimbotBypassFloatingPos then
        btnFrame.Position = UDim2.new(
            aimbotBypassFloatingPos.XScale, aimbotBypassFloatingPos.XOffset,
            aimbotBypassFloatingPos.YScale, aimbotBypassFloatingPos.YOffset)
    else
        btnFrame.Position = UDim2.new(1, -150, 0.85, 0)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    
    -- Add morado glow stroke like main buttons
    local glowStroke = Instance.new("UIStroke", btnFrame)
    glowStroke.Color = Color3.fromRGB(170,0,255)
    glowStroke.Thickness = 0.5
    glowStroke.Transparency = 0.6
    
    -- Add shadow effect
    local shadowStroke = Instance.new("UIStroke", btnFrame)
    shadowStroke.Color = Color3.fromRGB(0,0,0)
    shadowStroke.Thickness = 2
    shadowStroke.Transparency = 0.7

    local label = Instance.new("TextLabel", btnFrame)    
    label.Size = UDim2.new(1, 0, 1, 0)    
    label.BackgroundTransparency = 1    
    label.Text = "Aimbot\nbyppas"    
    label.TextColor3 = Color3.fromRGB(170,0,255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 10
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 21
    applyShimmerToText(label, 0.6)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(170,0,255)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.TextColor3 = Color3.fromRGB(170,0,255)
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    batV2Toggled = not batV2Toggled
                    setActive(batV2Toggled)
                    if batV2Toggled then startBatV2() else stopBatV2() end
                elseif not S.lockUIEnabled and hasMoved then
                    -- Guardar posición al soltar
                    aimbotBypassFloatingPos = {
                        XScale  = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale  = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset,
                    }
                    saveConfig()
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputEnded:Connect(onInputEnded)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved then
                if not S.lockUIEnabled then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                else
                    dragging = false
                end
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onInputEnded(input)
        end
    end)

    return panel
end
-- =========================== FIN BAT V2 (,aimbot byppas) ===========================

buildGui()    
createFloatingButtonPanel()    
createSpeedPanel()    
createHUD()

-- Cargar config ANTES de crear los botones flotantes para que usen la posición guardada
do
    if not S._configLoaded then
        if safeIsfile(S.CONFIG_FILE) then
            local data = safeReadfile(S.CONFIG_FILE)
            if data then
                local ok, cfg = pcall(function() return HS:JSONDecode(data) end)
                if ok and type(cfg) == "table" then
                    if cfg.instaResetFloatingPos then instaResetFloatingPos = cfg.instaResetFloatingPos end
                    if cfg.aimbotBypassFloatingPos then aimbotBypassFloatingPos = cfg.aimbotBypassFloatingPos end
                    if cfg.floatingPanelPos then
                        S._savedFloatingPanelPos = cfg.floatingPanelPos
                        if S.floatingPanelFrame then
                            local p = cfg.floatingPanelPos
                            S.floatingPanelFrame.Position = UDim2.new(p.XScale or 1, p.XOffset or -158, p.YScale or 0.5, p.YOffset or -130)
                        end
                    end
                    if cfg.speedPanelPositions then
                        S._savedSpeedPanelPositions = cfg.speedPanelPositions
                        if S.speedPanelFrames then
                            for i = 1, 3 do
                                local f = S.speedPanelFrames[i]
                                local pos = cfg.speedPanelPositions[i] or cfg.speedPanelPositions[tostring(i)]
                                if f and pos then
                                    f.Position = UDim2.new(pos.XScale or 0, pos.XOffset or 10, pos.YScale or 0.5, pos.YOffset or 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

createInstaResetFloatingButton()
createAimbotBypassFloatingButton()    
    
local function loadConfig()    
    if S._configLoaded then return end    
    if not safeIsfile(S.CONFIG_FILE) then S._configLoaded = true; return end    
    local data = safeReadfile(S.CONFIG_FILE)    
    if not data then S._configLoaded = true; return end    
    local ok, cfg = pcall(function() return HS:JSONDecode(data) end)    
    if not ok or type(cfg) ~= "table" then S._configLoaded = true; return end    
    
    if cfg.normalSpeed1 then S.NS1 = cfg.normalSpeed1; if S.normalBox1 then S.normalBox1.Text = tostring(S.NS1) end end    
    if cfg.carrySpeed1  then S.CS1 = cfg.carrySpeed1;  if S.carryBox1  then S.carryBox1.Text  = tostring(S.CS1) end end    
    if cfg.normalSpeed2 then S.NS2 = cfg.normalSpeed2; if S.normalBox2 then S.normalBox2.Text = tostring(S.NS2) end end    
    if cfg.carrySpeed2  then S.CS2 = cfg.carrySpeed2;  if S.carryBox2  then S.carryBox2.Text  = tostring(S.CS2) end end    
    if cfg.normalSpeed3 then S.NS3 = cfg.normalSpeed3; if S.normalBox3 then S.normalBox3.Text = tostring(S.NS3) end end    
    if cfg.carrySpeed3  then S.CS3 = cfg.carrySpeed3;  if S.carryBox3  then S.carryBox3.Text  = tostring(S.CS3) end end    
    if cfg.laggerSpeed1 then S.LS1 = cfg.laggerSpeed1; if S.laggerBox1 then S.laggerBox1.Text = tostring(S.LS1) end end    
    if cfg.laggerSpeed2 then S.LS2 = cfg.laggerSpeed2; if S.laggerBox2 then S.laggerBox2.Text = tostring(S.LS2) end end    
    if cfg.normalPreset then S.normalPreset = cfg.normalPreset end    
    if cfg.laggerMode   then S.laggerMode   = cfg.laggerMode   end    
    if cfg.floatingButtonsLayout then S.floatingButtonsLayout = cfg.floatingButtonsLayout end    
    if S.normalPreset < 1 then S.normalPreset = 1 end    
    
    local function tryLoadKey(entry, kbName, gpName)    
        if kbName and Enum.KeyCode[kbName] then entry.kb = Enum.KeyCode[kbName]; entry.gp = nil    
        elseif gpName and Enum.KeyCode[gpName] then entry.gp = Enum.KeyCode[gpName]; entry.kb = nil end    
    end    
    if cfg.dropBrainrotKey  then tryLoadKey(S.KB.DropBrainrot,  cfg.dropBrainrotKey.kb,  cfg.dropBrainrotKey.gp)  end    
    if cfg.autoLeftKey       then tryLoadKey(S.KB.AutoLeft,       cfg.autoLeftKey.kb,       cfg.autoLeftKey.gp)       end    
    if cfg.autoRightKey      then tryLoadKey(S.KB.AutoRight,      cfg.autoRightKey.kb,      cfg.autoRightKey.gp)      end    
    if cfg.autoBatKey        then tryLoadKey(S.KB.AutoBat,        cfg.autoBatKey.kb,        cfg.autoBatKey.gp)        end    
    if cfg.tpFloorKey        then tryLoadKey(S.KB.TPFlor,         cfg.tpFloorKey.kb,        cfg.tpFloorKey.gp)        end    
    if cfg.guiHideKey        then tryLoadKey(S.KB.GuiHide,        cfg.guiHideKey.kb,        cfg.guiHideKey.gp)        end    
    if cfg.speedToggleKey    then tryLoadKey(S.KB.SpeedToggle,    cfg.speedToggleKey.kb,    cfg.speedToggleKey.gp)    end    
    if cfg.laggerToggleKey   then tryLoadKey(S.KB.LaggerToggle,   cfg.laggerToggleKey.kb,   cfg.laggerToggleKey.gp)   end    
    if cfg.autoTPDownKey     then tryLoadKey(S.KB.AutoTPDown,     cfg.autoTPDownKey.kb,     cfg.autoTPDownKey.gp)     end    
    if cfg.speedMode1Key     then tryLoadKey(S.KB.SpeedMode1,     cfg.speedMode1Key.kb,     cfg.speedMode1Key.gp)     end    
    if cfg.speedMode2Key     then tryLoadKey(S.KB.SpeedMode2,     cfg.speedMode2Key.kb,     cfg.speedMode2Key.gp)     end    
    if cfg.speedMode3Key     then tryLoadKey(S.KB.SpeedMode3,     cfg.speedMode3Key.kb,     cfg.speedMode3Key.gp)     end    
    if cfg.laggerMode1Key    then tryLoadKey(S.KB.LaggerMode1,    cfg.laggerMode1Key.kb,    cfg.laggerMode1Key.gp)    end    
    if cfg.laggerMode2Key    then tryLoadKey(S.KB.LaggerMode2,    cfg.laggerMode2Key.kb,    cfg.laggerMode2Key.gp)    end    
    
    for _, kbData in ipairs(S._keyButtons) do    
        if kbData.entry then    
            local key = kbData.entry.kb or kbData.entry.gp or Enum.KeyCode.Unknown    
            kbData.btn.Text = key.Name    
        end    
    end    
    
    if cfg.grabRadius then S.autoStealRadius = cfg.grabRadius; if S.radInput then S.radInput.Text = tostring(cfg.grabRadius) end end    
    if cfg.stealDuration then S.autoStealDuration = cfg.stealDuration; if S.stealDurationBox then S.stealDurationBox.Text = tostring(cfg.stealDuration) end end    
    if cfg.autoTPDownThreshold then S.autoTPDownThreshold = cfg.autoTPDownThreshold; if S.autoTPDownThresholdBox then S.autoTPDownThresholdBox.Text = tostring(cfg.autoTPDownThreshold) end end    
    if cfg.antiRagdoll then S.antiRagdollEnabled = true; if S.setAntiRagVisual then S.setAntiRagVisual(true) end; startAntiRagdoll() end    
    if cfg.autoStealEnabled then S.stealActive = true; if S.setInstaGrab then S.setInstaGrab(true) end; startAutoSteal() end    
    if cfg.infiniteJump and not cfg.holdJumpEnabled then S.infJumpEnabled = true; startInfiniteJump(); if S.setInfJumpVisual then S.setInfJumpVisual(true) end end    
    if cfg.holdJumpEnabled then S.infJumpEnabled = false; if S.setInfJumpVisual then S.setInfJumpVisual(false) end; S.holdJumpEnabled = true; startHoldJump(); if S.setHoldJumpVisual then S.setHoldJumpVisual(true) end end    
    if cfg.medusaCounter then S.medusaCounterEnabled = true; setupMedusaCounter(LP.Character); if S.setMedusaVisual then S.setMedusaVisual(true) end end    
    if cfg.medusaAutoResetEnabled then S.medusaAutoResetEnabled = true; setupMedusaAutoReset(LP.Character); if S.setMedusaAutoResetVisual then S.setMedusaAutoResetVisual(true) end end
    if cfg.carryMode then S.speedMode = true; S.laggerMode = 0; if S.speedClk then S.speedClk(true) end end    
    if cfg.laggerMode and cfg.laggerMode > 0 and not cfg.carryMode then    
        S.laggerMode = cfg.laggerMode; if S.setLaggerVisual then S.setLaggerVisual(true) end    
    end    
    if cfg.autoBat then    
        if S.autoLeftEnabled then S.autoLeftEnabled = false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; stopAutoLeft() end    
        if S.autoRightEnabled then S.autoRightEnabled = false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; stopAutoRight() end    
        enableAutoBat()    
        if autoBatSetVisual then autoBatSetVisual(true) end    
        refreshFloatingButtonsVisual()    
    end    
    if cfg.autoSwing ~= nil then autoSwingEnabled = cfg.autoSwing end    
    if cfg.batCounter then S.batCounterEnabled = true; startBatCounter(); if S.setBatCounterVisual then S.setBatCounterVisual(true) end end    
    if cfg.unwalkEnabled then S.unwalkEnabled = true; startUnwalk(); if S.setUnwalkVisual then S.setUnwalkVisual(true) end end    
    if cfg.lockUI then S.lockUIEnabled = true; setUILock(true); if S.setLockUI_Visual then S.setLockUI_Visual(true) end end    
    if cfg.hideOpiumButtons then S.hideOpiumButtonsEnabled = true end    
    if cfg.galaxyMode then galaxyOn = true; updateGalaxy(); if S.setDarkVisual then S.setDarkVisual(true) end end    
    if cfg.autoTPDownEnabled then S.autoTPDownEnabled = true; startAutoTPDown(); if S.autoTPDownSetVisual then S.autoTPDownSetVisual(true) end end    
    if cfg.antiLag then enableAntiLag() else disableAntiLag() end    
    
    if cfg.floatingPanelPos then
        S._savedFloatingPanelPos = cfg.floatingPanelPos
        if S.floatingPanelFrame then
            local p = cfg.floatingPanelPos
            S.floatingPanelFrame.Position = UDim2.new(p.XScale or 1, p.XOffset or -158, p.YScale or 0.5, p.YOffset or -130)
        end
    end
    if cfg.speedPanelPositions then
        S._savedSpeedPanelPositions = cfg.speedPanelPositions
        if S.speedPanelFrames then
            for i = 1, 3 do
                local f = S.speedPanelFrames[i]
                local pos = cfg.speedPanelPositions[i] or cfg.speedPanelPositions[tostring(i)]
                if f and pos then
                    f.Position = UDim2.new(pos.XScale or 0, pos.XOffset or 10, pos.YScale or 0.5, pos.YOffset or 0)
                end
            end
        end
    end
    if cfg.instaResetFloatingPos and not instaResetFloatingPos then
        instaResetFloatingPos = cfg.instaResetFloatingPos
    end
    if cfg.aimbotBypassFloatingPos and not aimbotBypassFloatingPos then
        aimbotBypassFloatingPos = cfg.aimbotBypassFloatingPos
    end    
    
    refreshFloatingButtonsVisual()    
    if S.speedPanelActive then S.speedPanelActive(S.normalPreset) end    
    S._configLoaded = true    
end    
    
saveConfiEnabled = false  -- Bloquear guardado mientras se carga
loadConfig()
saveConfiEnabled = true  -- Restaurar siempre después de cargar

-- Re-aplicar posiciones flotantes después de que todo esté listo
task.spawn(function()
    task.wait(0.35)
    if S._savedFloatingPanelPos and S.floatingPanelFrame then
        local p = S._savedFloatingPanelPos
        S.floatingPanelFrame.Position = UDim2.new(p.XScale or 1, p.XOffset or -158, p.YScale or 0.5, p.YOffset or -130)
    end
    if S._savedSpeedPanelPositions and S.speedPanelFrames then
        for i = 1, 3 do
            local f = S.speedPanelFrames[i]
            local pos = S._savedSpeedPanelPositions[i] or S._savedSpeedPanelPositions[tostring(i)]
            if f and pos then
                f.Position = UDim2.new(pos.XScale or 0, pos.XOffset or 10, pos.YScale or 0.5, pos.YOffset or 0)
            end
        end
    end
end)    
    
task.spawn(function()    
    task.wait(0.2)    
    if S.antiRagdollEnabled then startAntiRagdoll() end    
    if S.unwalkEnabled then startUnwalk() end    
    if S.medusaCounterEnabled and LP.Character then setupMedusaCounter(LP.Character) end    
    if autoBatEnabled then enableAutoBat() end    
    if S.batCounterEnabled then startBatCounter() end    
    if S.infJumpEnabled then startInfiniteJump() end    
    if S.holdJumpEnabled then startHoldJump() end    
    if S.autoTPDownEnabled then startAutoTPDown() end    
    if S.stealActive then startAutoSteal() end    
    if galaxyOn then updateGalaxy() end    
    if antiLagEnabled then enableAntiLag() end    
end)    
    
if LP.Character then    
    setupCursedSpeedBillboard(LP.Character)    
end    
    
LP.CharacterAdded:Connect(function(char)    
    resetAutoStealFull()    
    local _autoLeftWas   = S.autoLeftEnabled    
    local _autoRightWas  = S.autoRightEnabled    
    local _autoBatWas    = autoBatEnabled    
    local _batCounterWas = S.batCounterEnabled    
    local _infJumpWas    = S.infJumpEnabled    
    local _holdJumpWas   = S.holdJumpEnabled    
    local _autoTPDownWas = S.autoTPDownEnabled    
    local _stealActiveWas= S.stealActive    
    local _medusaWas     = S.medusaCounterEnabled    
    local _unwalkWas     = S.unwalkEnabled    
    local _antiRagWas    = S.antiRagdollEnabled    
    local _antiLagWas    = antiLagEnabled    
    
    if S.autoLeftEnabled  then stopAutoLeft()  end    
    if S.autoRightEnabled then stopAutoRight() end    
    if autoBatEnabled     then disableAutoBat() end    
    if S.batCounterEnabled then stopBatCounter() end    
    if S.infJumpEnabled   then stopInfiniteJump() end    
    if S.holdJumpEnabled  then stopHoldJump()  end    
    if S.autoTPDownEnabled then stopAutoTPDown() end    
    if S.medusaCounterEnabled then stopMedusaCounter() end    
    if antiLagEnabled     then disableAntiLag() end    
    
    task.wait(0.5)    
    
    if _antiRagWas  then startAntiRagdoll() end    
    if _unwalkWas   then startUnwalk() end    
    if _medusaWas   then setupMedusaCounter(char) end    
    if S.medusaAutoResetEnabled then setupMedusaAutoReset(char) end    
    if _antiLagWas  then enableAntiLag() end    
    
    S.h   = char:WaitForChild("Humanoid", 5)    
    S.hrp = char:WaitForChild("HumanoidRootPart", 5)    
    if S.h and S.hrp then setupCursedSpeedBillboard(char) end    
    
    if _autoLeftWas   then startAutoLeft()   end    
    if _autoRightWas  then startAutoRight()  end    
    if _autoBatWas    then enableAutoBat()   end    
    if _batCounterWas then startBatCounter() end    
    if _infJumpWas    then startInfiniteJump() end    
    if _holdJumpWas   then startHoldJump()     end    
    if _autoTPDownWas then startAutoTPDown()   end    
    if _stealActiveWas then    
        S.stealActive = true    
        resetAutoStealFull()    
        startAutoSteal()    
    end    
    if galaxyOn then task.wait(0.3); updateGalaxy() end    
    if S.speedPanelActive then S.speedPanelActive(S.normalPreset) end    
end)    
    
if LP.Character then    
    task.spawn(function()    
        local char = LP.Character    
        if S.antiRagdollEnabled then startAntiRagdoll() end    
        if S.unwalkEnabled then startUnwalk() end    
        if S.medusaCounterEnabled then setupMedusaCounter(char) end    
        if antiLagEnabled then enableAntiLag() end    
        S.h   = char:FindFirstChildOfClass("Humanoid")    
        S.hrp = char:FindFirstChild("HumanoidRootPart")    
        if S.h and S.hrp then setupCursedSpeedBillboard(char) end    
        if S.autoLeftEnabled   then startAutoLeft()    end    
        if S.autoRightEnabled  then startAutoRight()   end    
        if autoBatEnabled      then enableAutoBat()    end    
        if S.infJumpEnabled    then startInfiniteJump() end    
        if S.holdJumpEnabled   then startHoldJump()    end    
        if S.batCounterEnabled then startBatCounter()  end    
        if S.autoTPDownEnabled then startAutoTPDown()  end    
        if S.stealActive       then startAutoSteal()   end    
        if galaxyOn            then updateGalaxy()     end    
        if S.speedPanelActive then S.speedPanelActive(S.normalPreset) end    
    end)    
end    
    
print("[New Era Hub] Cargado correctamente. Aimbot de bat listo.")    
