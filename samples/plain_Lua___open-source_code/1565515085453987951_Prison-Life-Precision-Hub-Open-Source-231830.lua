-- Main Script Kayen Hub | Prison Life

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local defaultCameraFOV = camera.FieldOfView
local mouse = player:GetMouse()

-- ============ SETTINGS ============
getgenv().SilentAimSettings = {
    Enabled = true,
    ForceFieldCheck = true,
    TargetPart = "HumanoidRootPart",
    Method = "Raycast",
    VisibleCheck = true,
    TeamCheck = true,
    Smoothing = 0,
    HitChance = 100,
    FOVEnabled = true,
    FOVRadius = 100,
    FOVColor = Color3.fromRGB(255, 255, 255),
    FOVThickness = 1,
    FriendCheck = true,
    SpinbotSpeed = 0,
    ESPEnabled = false,
    ESPNamesEnabled = true,
    ESPTargetColor = Color3.fromRGB(255, 182, 255),
    TargetTeams = { Inmates = true, Guards = true, Criminals = true },
    HostileCheck = false,
    TrespassCheck = false,
    TracerColor = Color3.fromRGB(255, 182, 255),
    TracerThickness = 0.1,
    TracerESPEnabled = false,
    TracerTargetOnly = false,
    Autoshoot = false,
    SilentAimRange = 500,
    CameraFOVEnabled = false, 
    CameraFOV = 70,
    NoclipEnabled = false,
    InfiniteJumpEnabled = false,
    InvisibleEnabled = false,
    AntiInvisibleEnabled = false,
    TargetOnPlayer = {},
    IgnoreTargets = {},
    AimMode = "FOV",
    GunModEnabled = false,
    AutoFire = false,
    FastFirerateEnabled = false,
    FireRateValue = 0.01,
    AutoReloadEnabled = false,
    KillEffectEnabled = false,
    KillEffectColor = Color3.fromRGB(255, 255, 255),
    KillEffectFadeDuration = 0.25,
    KillLogsEnabled = false,
    HitLogsEnabled = false,
    HitboxExpanderEnabled = false,
    HitboxTeamCheck = true,
    GetWeaponsList = {},
    AutoGetWeapons = false,
    InfiniteStamina = false,
    HitboxSize = 1,
    HitboxTransparency = 0.5,
    HitboxShape = "Box",
    GunSwitchList = {},
    GunSwitchDelay = 0.01,
    GunSwitchEnabled = false,
    GunSwitchCycleAll = false,
    AntiSitEnabled = false,
    ESPTextColor = Color3.fromRGB(255, 255, 255),
    ESPTargetTextColor = Color3.fromRGB(255, 182, 255),
    ESPTargetNameEnabled = false,
    TargetCustomText = "Target",
    ESPNameTextSize = 12,
    ESPTargetNameTextSize = 12,
}

local Settings = getgenv().SilentAimSettings
local currentSkybox = nil
local smoothedTargetPosition = nil
local currentTarget = nil
local lastTargetPlayer = nil
local shootRemote = nil

-- ============ FOV ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FOVGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", fovCircle).Color = Settings.FOVColor
fovCircle.UIStroke.Thickness = Settings.FOVThickness
fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled

function toggleFOVCircle(hide)
    local stroke = fovCircle:FindFirstChild("UIStroke")
    if stroke then
        stroke.Enabled = not hide
    end
end

-- ============ FORCEFIELD CHECK ============
function toggleForceFieldCheck(enabled)
    Settings.ForceFieldCheck = enabled
end

-- ============ TRACER BEAM SYSTEM ============
local tracerBeams = {}

local function removeTracerBeam(plr)
    local data = tracerBeams[plr]
    if data then
        if data.Beam then data.Beam:Destroy() end
        if data.Start then data.Start:Destroy() end
        if data.End then data.End:Destroy() end
        tracerBeams[plr] = nil
    end
end

local function removeAllTracerBeams()
    for plr, _ in pairs(tracerBeams) do
        removeTracerBeam(plr)
    end
end

local function getPlayerTracerColor(plr)
    if currentTarget and currentTarget.Parent and plr.Character and currentTarget.Parent == plr.Character then
        return Settings.TracerColor
    end
    if plr.TeamColor then
        return plr.TeamColor.Color
    elseif plr.Team and plr.Team.TeamColor then
        return plr.Team.TeamColor.Color
    end
    return Settings.TracerColor
end

local function updateTracerBeam(plr)
    local char = plr.Character
    local localChar = player.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not localHRP or not targetHRP then
        removeTracerBeam(plr)
        return
    end

    local data = tracerBeams[plr]
    if data then
        if data.Start.Parent ~= localHRP or data.End.Parent ~= targetHRP then
            removeTracerBeam(plr)
            data = nil
        end
    end

    if not data then
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = localHRP

        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = targetHRP

        local beam = Instance.new("Beam")
        beam.Name = "TracerBeam"
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.FaceCamera = true
        beam.Parent = targetHRP

        data = {
            Beam = beam,
            Start = attachment0,
            End = attachment1
        }
        tracerBeams[plr] = data
    end

    local color = getPlayerTracerColor(plr)
    data.Beam.Color = ColorSequence.new(color)
    data.Beam.Width0 = Settings.TracerThickness
    data.Beam.Width1 = Settings.TracerThickness
    data.Beam.Enabled = true
end

local function getCurrentTargetPlayer()
    if Settings.Enabled and currentTarget and currentTarget.Parent then
        local targetChar = currentTarget.Parent
        if targetChar:IsA("Model") then
            return Players:GetPlayerFromCharacter(targetChar)
        end
    end
    return nil
end

local function updateAllTracerBeams()
    if not Settings.ESPEnabled or not Settings.TracerESPEnabled then
        removeAllTracerBeams()
        return
    end

    if Settings.TracerTargetOnly then
        local targetPlayer = getCurrentTargetPlayer()

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                if plr == targetPlayer then
                    local char = plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if char and hum and hum.Health > 0 then
                        updateTracerBeam(plr)
                    else
                        removeTracerBeam(plr)
                    end
                else
                    removeTracerBeam(plr)
                end
            end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then
                updateTracerBeam(plr)
            else
                removeTracerBeam(plr)
            end
        end
    end

    for plr, _ in pairs(tracerBeams) do
        if not plr.Parent or plr == player then
            removeTracerBeam(plr)
        end
    end
end

-- ============ FOV POSITION ============
local GuiService = game:GetService("GuiService")

local function getAdjustedMousePosition()
    local mousePos = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()
    return Vector2.new(mousePos.X - inset.X, mousePos.Y - inset.Y)
end

local function updateFOVPosition()
    if not fovCircle then return end
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)

    local usingTouch = UserInputService:GetLastInputType() == Enum.UserInputType.Touch

    if usingTouch then
        fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        local adjustedMousePos = getAdjustedMousePosition()
        fovCircle.Position = UDim2.new(0, adjustedMousePos.X, 0, adjustedMousePos.Y)
    end
end

-- ============ MAIN FUNCTIONS ============
local function isVisible(targetCharacter)
    if not targetCharacter then return false end
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end

    local localChar = player.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return false end

    local origin = targetHRP.Position
    local direction = localHRP.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {player.Character, targetCharacter}

    local result = workspace:Raycast(origin, direction, params)
    return result == nil
end

local function isValidTarget(plr)
    if not plr or plr == player then return false end
    if not plr.Character then return false end
    
    if Settings.IgnoreTargets and #Settings.IgnoreTargets > 0 then
        for _, name in ipairs(Settings.IgnoreTargets) do
            if plr.Name == name then
                return false
            end
        end
    end
    
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return false end
    
    if Settings.FriendCheck and player:IsFriendsWith(plr.UserId) then return false end
    
    if Settings.TeamCheck then
        if player.Team and plr.Team == player.Team then return false end
    end
    
    if plr.Team and Settings.TargetTeams and not Settings.TargetTeams[plr.Team.Name] then
        return false
    end
    
    if Settings.SilentAimRange then
        local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if localRoot then
            local dist = (hrp.Position - localRoot.Position).Magnitude
            if dist > Settings.SilentAimRange then return false end
        end
    end

    if Settings.VisibleCheck then
        if not isVisible(plr.Character) then return false end
    end

    if Settings.ForceFieldCheck then
        if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    end
    
    if Settings.HostileCheck or Settings.TrespassCheck then
        local localTeam = player.Team and player.Team.Name
        local targetTeam = plr.Team and plr.Team.Name
        
        local isGuardOrCriminal = (localTeam == "Guards" or localTeam == "Criminals")
        local isInmate = (targetTeam == "Inmates")
        
        if isGuardOrCriminal and isInmate then
            local hostile = plr.Character:GetAttribute("Hostile")
            local trespass = plr.Character:GetAttribute("Trespassing")
            
            if Settings.HostileCheck and Settings.TrespassCheck then
                if not hostile and not trespass then return false end
            elseif Settings.HostileCheck then
                if not hostile then return false end
            elseif Settings.TrespassCheck then
                if not trespass then return false end
            end
        end
    end
    
    return true
end

-- ============ RANDOM TARGET PART ============
local RandomPartNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
local CurrentRandomPart = "HumanoidRootPart"

task.spawn(function()
    while true do
        if Settings.TargetPart == "Random" then
            CurrentRandomPart = RandomPartNames[math.random(1, #RandomPartNames)]
        end
        task.wait(0.5)
    end
end)

local function getEffectiveTargetPart()
    if Settings.TargetPart == "Random" then
        return CurrentRandomPart
    end
    return Settings.TargetPart
end

local function getClosestTarget()
    if Settings.TargetOnPlayer and #Settings.TargetOnPlayer > 0 then
        local closestTargetPart = nil
        local closestTargetDist = math.huge
        
        for _, targetName in ipairs(Settings.TargetOnPlayer) do
            local targetPlr = Players:FindFirstChild(targetName)
            if targetPlr and isValidTarget(targetPlr) then
                local part = targetPlr.Character:FindFirstChild(getEffectiveTargetPart()) or targetPlr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                        local mousePos = getAdjustedMousePosition()
                        local useMouse = not UserInputService.TouchEnabled
                        local screenDist
                        if useMouse then
                            screenDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        else
                            screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        end
                        
                        if screenDist < closestTargetDist then
                            closestTargetPart = part
                            closestTargetDist = screenDist
                        end
                    end
                end
            end
        end
        
        if closestTargetPart then
            return closestTargetPart
        end
        return nil
    end
    
    local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local mousePos = getAdjustedMousePosition()
    local useMouse = not UserInputService.TouchEnabled
    
    local closest = nil
    local shortestDistance = math.huge
    
    if Settings.AimMode == "Distance" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if isValidTarget(plr) then
                local part = plr.Character:FindFirstChild(getEffectiveTargetPart()) or plr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local worldDist = (part.Position - localRoot.Position).Magnitude
                    if worldDist < shortestDistance then
                        closest = part
                        shortestDistance = worldDist
                    end
                end
            end
        end
        return closest
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidTarget(plr) then
            local part = plr.Character:FindFirstChild(getEffectiveTargetPart()) or plr.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local screenDist
                    if useMouse then
                        screenDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    else
                        screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    end
                    
                    if screenDist <= Settings.FOVRadius then
                        local worldDist = (part.Position - localRoot.Position).Magnitude
                        if worldDist < shortestDistance then
                            closest = part
                            shortestDistance = worldDist
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ============ SILENT AIM HOOK ============
-- Silent Aim Method by 7zz
local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = {
        ArgCountRequired = 3,
        Args = { "Instance", "Ray", "table", "boolean", "boolean" }
    },
    FindPartOnRayWithWhitelist = {
        ArgCountRequired = 3,
        Args = { "Instance", "Ray", "table", "boolean" }
    },
    FindPartOnRay = {
        ArgCountRequired = 2,
        Args = { "Instance", "Ray", "Instance", "boolean", "boolean" }
    },
    Raycast = {
        ArgCountRequired = 3,
        Args = { "Instance", "Vector3", "Vector3", "RaycastParams" }
    }
}

local function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then return false end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function getSpreadDirection(Origin, OriginalDirection, HitPart)
    if typeof(HitPart) ~= "Instance" or not HitPart.Parent then 
        return OriginalDirection 
    end
    
    local OriginalDistance = OriginalDirection.Magnitude
    if OriginalDistance == 0 then OriginalDistance = 1000 end
    
    local PartSize = HitPart.Size
    local SpreadX = (math.random() - 0.5) * (PartSize.X + 2) * 0.2
    local SpreadY = (math.random() - 0.5) * (PartSize.Y + 2) * 0.2
    local SpreadZ = (math.random() - 0.5) * (PartSize.Z + 2) * 0.2
    
    local RandomOffset = Vector3.new(SpreadX, SpreadY, SpreadZ)
    if RandomOffset.Magnitude == 0 then
        RandomOffset = Vector3.new(0.1, 0.1, 0.1)
    end
    
    local BasePosition = smoothedTargetPosition or HitPart.Position
    local TargetPosition = BasePosition + RandomOffset
    
    local NewDirection = (TargetPosition - Origin)
    local NewDistance = NewDirection.Magnitude
    
    if NewDistance == 0 then
        return OriginalDirection
    end
    
    local FinalDistance = math.max(OriginalDistance, NewDistance)
    return NewDirection.Unit * FinalDistance
end

local function getRedirectedDirection(Origin, OriginalDirection)
    if currentTarget and currentTarget.Parent then
        return getSpreadDirection(Origin, OriginalDirection, currentTarget)
    end
    return nil
end

-- ============ HIT LOGS ============
local function registerHit(result)
    if not result then return end

    local hitPart
    if typeof(result) == "Instance" then
        hitPart = result
    elseif typeof(result) == "table" and result.Instance then
        hitPart = result.Instance
    end

    if not hitPart or not hitPart:IsA("BasePart") then return end

local char = hitPart:FindFirstAncestorOfClass("Model")
if not char then return end

local hitPlayer = Players:GetPlayerFromCharacter(char)
    if not hitPlayer or hitPlayer == player then return end

    if Settings.HitLogsEnabled then
        Library:Notify({
            Title = "Hit Logs",
            Description = "You hit " .. hitPlayer.Name,
            Time = 3,
        })
    end

    playHitSound()
end

local function isLocalPlayerShooting(Arguments, Method, Origin, OriginalDirection)
    local LocalChar = player.Character
    if not LocalChar then return false end

    local rayLength = OriginalDirection and OriginalDirection.Magnitude or 0

    if Origin and (Origin - camera.CFrame.Position).Magnitude <= 2 then
        if rayLength < 30 then
            return false
        end
    end

    local ignoreList = nil
    if Method == "Raycast" then
        local params = Arguments[4]
        if typeof(params) == "RaycastParams" then
            ignoreList = params.FilterDescendantsInstances
        end
    elseif Method == "FindPartOnRayWithIgnoreList" then
        if typeof(Arguments[3]) == "table" then
            ignoreList = Arguments[3]
        end
    elseif Method == "FindPartOnRay" or Method == "findPartOnRay" then
        if typeof(Arguments[3]) == "table" then
            ignoreList = Arguments[3]
        elseif typeof(Arguments[4]) == "table" then
            ignoreList = Arguments[4]
        end
    end

    if ignoreList then
        for _, inst in next, ignoreList do
            if inst == LocalChar then
                return true
            end
        end
    end

    if Origin and (Origin - camera.CFrame.Position).Magnitude <= 2 then
        return true
    end

    return false
end

local function tryGetOriginDirection(Method, Arguments)
    if Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRayWithWhitelist"
        or Method == "FindPartOnRay" or Method == "findPartOnRay" then
        local A_Ray = Arguments[2]
        if typeof(A_Ray) == "Ray" then
            return A_Ray.Origin, A_Ray.Direction
        end
    elseif Method == "Raycast" then
        local A_Origin = Arguments[2]
        local A_Direction = Arguments[3]
        if typeof(A_Origin) == "Vector3" and typeof(A_Direction) == "Vector3" then
            return A_Origin, A_Direction
        end
    end
    return nil, nil
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]

    if Method == "Play" and self.ClassName == "Sound" and not checkcaller() then
        local tool = self.Parent and self.Parent.Parent
        local localChar = player.Character
        if localChar and tool and tool.Parent == localChar and tool.ClassName == "Tool" and tool:GetAttribute("ToolType") == "Gun" then
            local soundClone = self:Clone()
            soundClone.Parent = camera
            soundClone.Playing = true
            task.delay(5, soundClone.Destroy, soundClone)
            return
        end
    end

    if shootRemote and self == shootRemote and Method == "FireServer" then
        local bulletData = Arguments[2]
        local firstPellet = type(bulletData) == "table" and bulletData[1] or nil
        local hitInstance = firstPellet and firstPellet[3] or nil

        task.defer(function()
            local success, validInstance = pcall(function()
                return hitInstance and typeof(hitInstance) == "Instance" and hitInstance.Parent and hitInstance.Name ~= "" and hitInstance
            end)

            if success and validInstance then
                registerHit(validInstance)
            end
        end)
    end

    if self == workspace and not checkcaller() then
        local Origin, Direction = tryGetOriginDirection(Method, Arguments)

        if Origin and Direction and isLocalPlayerShooting(Arguments, Method, Origin, Direction) then
            if Settings.Enabled and Settings.Method:lower() == Method:lower() and not AutoShootRaycastInProgress then
                local chance = CalculateChance(Settings.HitChance)
                if chance == true then
                    if Method == "FindPartOnRayWithIgnoreList" and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif Method == "FindPartOnRayWithWhitelist" and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRay) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif Method == "Raycast" and ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[3] = NewDir end
                    end
                end
            end

            local rets = table.pack(oldNamecall(unpack(Arguments)))
            return table.unpack(rets, 1, rets.n)
        end
    end
    return oldNamecall(...)
end))

-- ============ MAIN LOOP ============
task.spawn(function()
    while task.wait(0.1) do
        if Settings.Enabled then
            currentTarget = getClosestTarget()
        else
            currentTarget = nil
        end
    end
end)

local MaxSmoothTime = 1.5

RunService.RenderStepped:Connect(function(deltaTime)
    if workspace.CurrentCamera then
        if Settings.CameraFOVEnabled and Settings.CameraFOV then
            workspace.CurrentCamera.FieldOfView = Settings.CameraFOV
        else
            workspace.CurrentCamera.FieldOfView = defaultCameraFOV
        end
    end

    updateFOVPosition()
    
    if fovCircle then
        fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled
        fovCircle.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
        if fovCircle:FindFirstChild("UIStroke") then
            fovCircle.UIStroke.Thickness = Settings.FOVThickness
        end
    end
    
    if Settings.Enabled and currentTarget and currentTarget.Parent then
        if not smoothedTargetPosition then
            smoothedTargetPosition = currentTarget.Position
        else
            local tau = Settings.Smoothing * MaxSmoothTime
            local alpha = 1
            if tau > 0.0001 then
                alpha = 1 - math.exp(-deltaTime / tau)
            end
            smoothedTargetPosition = smoothedTargetPosition:Lerp(currentTarget.Position, alpha)
        end
    else
        smoothedTargetPosition = nil
    end
    
    updateAllTracerBeams()
end)

local function resetAllHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = plr.Character:FindFirstChild("ESPHighlight")
            if highlight and highlight:IsA("Highlight") then
                local teamColor = Color3.fromRGB(255, 0, 0)
                if plr.TeamColor then teamColor = plr.TeamColor.Color
                elseif plr.Team and plr.Team.TeamColor then teamColor = plr.Team.TeamColor.Color end
                
                highlight.FillColor = teamColor
                highlight.OutlineColor = teamColor
                highlight.FillTransparency = 0.85
                highlight.OutlineTransparency = 0
            end
            
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPNameTag")
                if billboard then
                    local label = billboard:FindFirstChild("NameLabel") or billboard:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.TextColor3 = Settings.ESPTextColor or Color3.fromRGB(255, 255, 255)
                        label.TextSize = Settings.ESPNameTextSize or 12
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    end
                end
            end
        end
    end
end

local function highlightTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetColor = Settings.ESPTargetColor or Color3.fromRGB(255, 182, 255)
    
    local highlight = targetPlayer.Character:FindFirstChild("ESPHighlight")
    if highlight and highlight:IsA("Highlight") then
        highlight.FillColor = targetColor
        highlight.OutlineColor = targetColor
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
    end
end

local function ensureTargetNameTag(head)
    local billboard = head:FindFirstChild("ESPTargetNameTag")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPTargetNameTag"
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Name = "TargetLabel"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = Settings.TargetCustomText or "Target"
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = billboard
    end
    return billboard
end

local function updateTargetNameTag(targetPlayer)
    if lastTargetPlayer and lastTargetPlayer ~= targetPlayer and lastTargetPlayer.Character then
        local oldHead = lastTargetPlayer.Character:FindFirstChild("Head")
        if oldHead then
            local oldBillboard = oldHead:FindFirstChild("ESPTargetNameTag")
            if oldBillboard then oldBillboard:Destroy() end
        end
    end

    if not targetPlayer or not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end

    if Settings.ESPTargetNameEnabled then
        local billboard = ensureTargetNameTag(head)
        local label = billboard:FindFirstChild("TargetLabel")
        if label then
            label.TextColor3 = Settings.ESPTargetTextColor or Color3.fromRGB(255, 182, 255)
            label.TextSize = Settings.ESPTargetNameTextSize or 12
            label.Text = Settings.TargetCustomText or "Target"
        end
    else
        local billboard = head:FindFirstChild("ESPTargetNameTag")
        if billboard then billboard:Destroy() end
    end
end

getgenv().SetTargetCustomText = function(text)
    if not text or text == "" then
        text = "Target"
    end
    Settings.TargetCustomText = text

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPTargetNameTag")
                if billboard then
                    local label = billboard:FindFirstChild("TargetLabel")
                    if label then
                        label.Text = text
                    end
                end
            end
        end
    end
end

local function updateESPSync()
    if not Settings.ESPEnabled then
        return
    end
    
    resetAllHighlights()
    
    local targetPlayer = getCurrentTargetPlayer()
    
    if targetPlayer and targetPlayer.Character then
        highlightTarget(targetPlayer)
    end
    
    updateTargetNameTag(targetPlayer)
    
    lastTargetPlayer = targetPlayer
end

RunService.RenderStepped:Connect(function()
    if Settings.ESPEnabled then
        updateESPSync()
    end
end)

-- ============ ESP AUTO REFRESH ============
task.spawn(function()
    while task.wait(0.5) do
        if Settings.ESPEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        applyESP(plr)
                    else
                        removeESP(plr)
                    end
                end
            end
        end
    end
end)

-- ============ SPINBOT ============
RunService.RenderStepped:Connect(function()
    if Settings.SpinbotSpeed > 0 then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinbotSpeed), 0)
        end
    end
end)

-- ============ NOCLIP ============
pcall(function()
    local hook = newcclosure(function() end)
    for _, obj in next, getgc(false) do
        if typeof(obj) == "function" then
            local ok, source = pcall(debug.info, obj, "s")
            if ok and source and source:find("CharacterCollision") then
                pcall(hookfunction, obj, hook)
            end
        end
    end
end)

local noclipConnection = nil

local function noclipStep()
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(noclipStep)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

getgenv().SetNoclipEnabled = function(v)
    Settings.NoclipEnabled = v == true
    if Settings.NoclipEnabled then
        startNoclip()
    else
        stopNoclip()
    end
end

-- ============ INFINITE JUMP ============
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJumpEnabled then
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

getgenv().SetInfiniteJumpEnabled = function(v)
    Settings.InfiniteJumpEnabled = v == true
end

-- ============ INVISIBLE ============
-- Method by A2Flacko
local InvisibleRealCFrame = nil
local InvisibleAnimationTrack = nil
local InvisibleRenderKey = "PrecisionInvisibleRender"
local InvisibleOriginalTransparency = {}
local InvisibleOriginalCanCollide = {}

local function loadInvisibleAnimation(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return nil end
    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local animation = Instance.new("Animation")
    animation.AnimationId = isR15 and "rbxassetid://18665825805" or "rbxassetid://215384594"
    local track = animator:LoadAnimation(animation)
    track.Priority = Enum.AnimationPriority.Action4
    track:Play(0, 0.001, 0)
    animation:Destroy()
    task.delay(0, function()
        track.TimePosition = isR15 and 1.95 or 0.4
    end)
    return track
end

local function stopInvisible()
    pcall(function()
        RunService:UnbindFromRenderStep(InvisibleRenderKey)
    end)
    if InvisibleAnimationTrack then
        InvisibleAnimationTrack:Stop()
        InvisibleAnimationTrack:Destroy()
        InvisibleAnimationTrack = nil
    end
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart and InvisibleRealCFrame then
        rootPart.CFrame = InvisibleRealCFrame
        local currentVelocity = rootPart.AssemblyLinearVelocity
        rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
    end
    InvisibleRealCFrame = nil

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= rootPart then
                if InvisibleOriginalTransparency[part] ~= nil then
                    part.Transparency = InvisibleOriginalTransparency[part]
                end
                if InvisibleOriginalCanCollide[part] ~= nil then
                    part.CanCollide = InvisibleOriginalCanCollide[part]
                end
            end
        end
        if rootPart then
            rootPart.Transparency = 1
        end
    end
    table.clear(InvisibleOriginalTransparency)
    table.clear(InvisibleOriginalCanCollide)
end

local function startInvisible()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    InvisibleAnimationTrack = loadInvisibleAnimation(character)
    InvisibleRealCFrame = nil

    table.clear(InvisibleOriginalTransparency)
    table.clear(InvisibleOriginalCanCollide)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= rootPart then
            InvisibleOriginalTransparency[part] = part.Transparency
            InvisibleOriginalCanCollide[part] = part.CanCollide
            part.Transparency = 0.5
            part.CanCollide = false
        end
    end
    rootPart.Transparency = 1

    pcall(function()
        RunService:UnbindFromRenderStep(InvisibleRenderKey)
    end)

    RunService:BindToRenderStep(InvisibleRenderKey, Enum.RenderPriority.Camera.Value - 1, function()
        if Settings.InvisibleEnabled and InvisibleRealCFrame and rootPart.Parent then
            rootPart.CFrame = InvisibleRealCFrame
            if InvisibleAnimationTrack then
                InvisibleAnimationTrack:AdjustWeight(0.001)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not Settings.InvisibleEnabled then return end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local dropOffset = humanoid.HipHeight + (rootPart.Size.Y / 2) - 1
    InvisibleRealCFrame = rootPart.CFrame
    rootPart.CFrame = (rootPart.CFrame - Vector3.new(0, dropOffset, 0)) * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)
    local currentVelocity = rootPart.AssemblyLinearVelocity
    rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
    if InvisibleAnimationTrack then
        InvisibleAnimationTrack:AdjustWeight(100)
    end
end)

player.CharacterAdded:Connect(function(character)
    if Settings.InvisibleEnabled then
        task.wait(0.5)
        startInvisible()
    end
end)

getgenv().SetInvisibleEnabled = function(v)
    Settings.InvisibleEnabled = v == true
    if Settings.InvisibleEnabled then
        startInvisible()
    else
        stopInvisible()
    end
end

local AntiInvisibleThreads = {}
local AntiInvisibleConnections = {}
local AntiInvisibleWhitelist = {
    ["http://www.roblox.com/asset/?id=125750702"] = true,
    ["http://www.roblox.com/asset/?id=128777973"] = true,
    ["http://www.roblox.com/asset/?id=128853357"] = true,
    ["http://www.roblox.com/asset/?id=129423030"] = true,
    ["http://www.roblox.com/asset/?id=129423131"] = true,
    ["http://www.roblox.com/asset/?id=129967390"] = true,
    ["http://www.roblox.com/asset/?id=129967478"] = true,
    ["http://www.roblox.com/asset/?id=178130996"] = true,
    ["http://www.roblox.com/asset/?id=180426354"] = true,
    ["http://www.roblox.com/asset/?id=180435571"] = true,
    ["http://www.roblox.com/asset/?id=180435792"] = true,
    ["http://www.roblox.com/asset/?id=180436148"] = true,
    ["http://www.roblox.com/asset/?id=180436334"] = true,
    ["http://www.roblox.com/asset/?id=182393478"] = true,
    ["http://www.roblox.com/asset/?id=182435998"] = true,
    ["http://www.roblox.com/asset/?id=182436842"] = true,
    ["http://www.roblox.com/asset/?id=182436935"] = true,
    ["http://www.roblox.com/asset/?id=182491037"] = true,
    ["http://www.roblox.com/asset/?id=182491065"] = true,
    ["http://www.roblox.com/asset/?id=182491248"] = true,
    ["http://www.roblox.com/asset/?id=182491277"] = true,
    ["http://www.roblox.com/asset/?id=182491368"] = true,
    ["http://www.roblox.com/asset/?id=182491423"] = true,
    ["rbxassetid://279227693"] = true,
    ["rbxassetid://279229192"] = true,
    ["rbxassetid://287112271"] = true,
    ["rbxassetid://388723916"] = true,
    ["rbxassetid://388726667"] = true,
    ["rbxassetid://389472570"] = true,
    ["rbxassetid://405194080"] = true,
    ["rbxassetid://405212265"] = true,
    ["rbxassetid://481088553"] = true,
    ["rbxassetid://481089053"] = true,
    ["rbxassetid://484200742"] = true,
    ["rbxassetid://484926359"] = true,
    ["rbxassetid://83690472549256"] = true,
    ["rbxassetid://107176344504758"] = true,
    ["rbxassetid://111090572475133"] = true,
    ["rbxassetid://113267949064300"] = true,
    ["rbxassetid://131326339350805"] = true,
    ["rbxassetid://18665825805"] = true,
    ["rbxassetid://215384594"] = true,
}

pcall(function()
    for _, animation in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if animation:IsA("Animation") then
            AntiInvisibleWhitelist[animation.AnimationId] = true
        end
    end
end)

local function watchAnimationTrack(track)
    local animationId = track.Animation and track.Animation.AnimationId
    if not animationId or AntiInvisibleWhitelist[animationId] then return end
    if AntiInvisibleThreads[track] then
        task.cancel(AntiInvisibleThreads[track])
    end
    AntiInvisibleThreads[track] = task.spawn(function()
        repeat
            track:AdjustWeight(0, 0)
            task.wait()
        until not (track.IsPlaying and Settings.AntiInvisibleEnabled)
        AntiInvisibleThreads[track] = nil
    end)
end

local function hookCharacterAnimations(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    local animator = humanoid:WaitForChild("Animator", 5)
    if not animator then return end

    local connection = animator.AnimationPlayed:Connect(function(track)
        if Settings.AntiInvisibleEnabled then
            watchAnimationTrack(track)
        end
    end)
    AntiInvisibleConnections[character] = connection

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if Settings.AntiInvisibleEnabled then
            watchAnimationTrack(track)
        end
    end
end

local function hookPlayerAnimations(plr)
    if plr == player then return end
    if plr.Character then
        task.spawn(hookCharacterAnimations, plr.Character)
    end
    plr.CharacterAdded:Connect(function(character)
        task.spawn(hookCharacterAnimations, character)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookPlayerAnimations(plr)
end
Players.PlayerAdded:Connect(hookPlayerAnimations)

getgenv().SetAntiInvisibleEnabled = function(v)
    Settings.AntiInvisibleEnabled = v == true
end

local HeadlessMeshId = "rbxassetid://1095708"
local KorbloxMeshId = "rbxassetid://101851696"
local KorbloxTextureId = "rbxassetid://101851254"

local function applyHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then return end

    head.Transparency = 1
    head.CanCollide = false

    local face = head:FindFirstChildOfClass("Decal")
    if face then face:Destroy() end

    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
            v:Destroy()
        end
    end

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = HeadlessMeshId
    mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
    mesh.Parent = head
end

local function applyKorblox(character)
    local rightLeg = character:FindFirstChild("Right Leg")
    if not rightLeg then return end

    for _, v in ipairs(rightLeg:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
            v:Destroy()
        end
    end

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = KorbloxMeshId
    mesh.TextureId = KorbloxTextureId
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = rightLeg
end

getgenv().SetHeadlessEnabled = function(v)
    Settings.HeadlessEnabled = v == true
    if Settings.HeadlessEnabled and player.Character then
        applyHeadless(player.Character)
    end
end

getgenv().SetKorbloxEnabled = function(v)
    Settings.KorbloxEnabled = v == true
    if Settings.KorbloxEnabled and player.Character then
        applyKorblox(player.Character)
    end
end

player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if Settings.HeadlessEnabled then
        applyHeadless(character)
    end
    if Settings.KorbloxEnabled then
        applyKorblox(character)
    end
end)

-- ============ ANTI SIT ============
local antiSitConnections = {}

local function disconnectAntiSit()
    for _, connection in antiSitConnections do
        connection:Disconnect()
    end
    antiSitConnections = {}
end

local function hookAntiSit(char)
    disconnectAntiSit()

    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    table.insert(antiSitConnections, humanoid.Seated:Connect(function(active, seatPart)
        if not Settings.AntiSitEnabled then return end
        if active and seatPart and not seatPart:IsA("VehicleSeat") then
            humanoid.Jump = true
            humanoid.Sit = false
        end
    end))
end

hookAntiSit(player.Character)
player.CharacterAdded:Connect(hookAntiSit)

getgenv().SetAntiSitEnabled = function(v)
    Settings.AntiSitEnabled = v == true
end

-- ============ ANTI-TASE ============
-- Method by IsaTheNoob
local antiTaseEnabled = false
local antiTaseConnection = nil

local function startAntiTase()
    if antiTaseConnection then
        antiTaseConnection:Disconnect()
        antiTaseConnection = nil
    end

    antiTaseConnection = task.spawn(function()
        local remote = nil
        pcall(function()
            remote = ReplicatedStorage:WaitForChild("GunRemotes", 5):WaitForChild("PlayerTased", 5)
        end)

        while antiTaseEnabled do
            if remote then
                local ok, connections = pcall(getconnections, remote.OnClientEvent)
                if ok then
                    for _, conn in connections do
                        conn:Disable()
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function stopAntiTase()
    antiTaseEnabled = false
    if antiTaseConnection then
        antiTaseConnection:Disconnect()
        antiTaseConnection = nil
    end

    pcall(function()
        local remote = ReplicatedStorage:WaitForChild("GunRemotes", 5):WaitForChild("PlayerTased", 5)
        local ok, connections = pcall(getconnections, remote.OnClientEvent)
        if ok then
            for _, conn in connections do
                conn:Enable()
            end
        end
    end)
end

function setAntiTaseEnabled(enabled)
    antiTaseEnabled = enabled
    if enabled then
        startAntiTase()
    else
        stopAntiTase()
    end
end

-- ============ GUN SWITCHER ============
local gunSwitchConnection = nil
local GunSwitchWeaponNames = {"M9", "Revolver", "MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"}

local cycleAllWeaponList = {}
local cycleAllConnections = {}

local function refreshCycleAllList()
    local newList = {}
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and table.find(GunSwitchWeaponNames, tool.Name) then
                table.insert(newList, tool.Name)
            end
        end
    end

    local char = player.Character
    local equipped = char and char:FindFirstChildOfClass("Tool")
    if equipped and table.find(GunSwitchWeaponNames, equipped.Name) and not table.find(newList, equipped.Name) then
        table.insert(newList, equipped.Name)
    end

    cycleAllWeaponList = newList
end

local function disconnectCycleAllConnections()
    for _, conn in ipairs(cycleAllConnections) do
        conn:Disconnect()
    end
    cycleAllConnections = {}
end

local function hookCycleAllContainers(char)
    disconnectCycleAllConnections()

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        table.insert(cycleAllConnections, backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then refreshCycleAllList() end
        end))
        table.insert(cycleAllConnections, backpack.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then refreshCycleAllList() end
        end))
    end

    if char then
        table.insert(cycleAllConnections, char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then refreshCycleAllList() end
        end))
        table.insert(cycleAllConnections, char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then refreshCycleAllList() end
        end))
    end

    refreshCycleAllList()
end

hookCycleAllContainers(player.Character)

player.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    hookCycleAllContainers(char)
end)

local function startGunSwitch()
    if gunSwitchConnection then
        pcall(task.cancel, gunSwitchConnection)
        gunSwitchConnection = nil
    end

    gunSwitchConnection = task.spawn(function()
        while Settings.GunSwitchEnabled do
            local char = player.Character
            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                task.wait()
                continue
            end

            local humanoid = char.Humanoid

            local weaponList = Settings.GunSwitchCycleAll and cycleAllWeaponList or Settings.GunSwitchList

            if not weaponList or #weaponList == 0 then
                task.wait()
                continue
            end

            for _, weaponName in ipairs(weaponList) do
                if not Settings.GunSwitchEnabled then break end
                local weapon = player.Backpack:FindFirstChild(weaponName)
                if weapon then
                    pcall(function()
                        humanoid:EquipTool(weapon)
                    end)
                end
                task.wait(Settings.GunSwitchDelay)
            end
        end
    end)
end

getgenv().ToggleGunSwitch = function(enabled)
    Settings.GunSwitchEnabled = enabled == true

    if Settings.GunSwitchEnabled then
        startGunSwitch()
    else
        if gunSwitchConnection then
            pcall(task.cancel, gunSwitchConnection)
            gunSwitchConnection = nil
        end
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end

player.CharacterAdded:Connect(function()
    if Settings.GunSwitchEnabled then
        task.wait(0.1)
        startGunSwitch()
    end
end)

-- ============ HITBOX EXPANDER ============
local hitboxModified = {}

local function resetHitbox(hrp)
    if not hrp or not hrp.Parent then return end
    hrp.Size = Vector3.new(2, 2, 1)
    hrp.Transparency = 1
    hrp.CanCollide = false
    hrp.Material = Enum.Material.Plastic
    hrp.Shape = Enum.PartType.Block
end

local function applyHitbox(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local isSeated = humanoid and (humanoid.Sit or humanoid.SeatPart ~= nil)

    if isSeated then
        if hitboxModified[hrp] then
            resetHitbox(hrp)
            hitboxModified[hrp] = nil
        end
        return
    end

    if Settings.HitboxTeamCheck and player.Team and plr.Team == player.Team then
        if hitboxModified[hrp] then
            resetHitbox(hrp)
            hitboxModified[hrp] = nil
        end
        return
    end

    local size = Settings.HitboxSize or 1
    hrp.Size = Vector3.new(size, size, size)
    hrp.Transparency = Settings.HitboxTransparency or 0.5
    hrp.CanCollide = false
    hrp.Material = Enum.Material.ForceField
    hrp.Shape = (Settings.HitboxShape == "Ball") and Enum.PartType.Ball or Enum.PartType.Block

    hitboxModified[hrp] = true
end

RunService.Heartbeat:Connect(function()
    if not Settings.HitboxExpanderEnabled then
        for hrp in pairs(hitboxModified) do
            resetHitbox(hrp)
        end
        table.clear(hitboxModified)
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            applyHitbox(plr)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hitboxModified[hrp] = nil
        end
    end
end)

local gettingWeapon = false
local OriginalGetWeaponsPosition = nil

local function getWeapon(ToolName)
    if gettingWeapon then return end
    gettingWeapon = true

    local Char = player.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")

    if not (Char and Root) then
        gettingWeapon = false
        return
    end

    if Char:FindFirstChild("ForceField") then
        gettingWeapon = false
        return
    end

    if player.Backpack:FindFirstChild(ToolName) or Char:FindFirstChild(ToolName) then
        gettingWeapon = false
        return
    end

    local Giver
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "TouchGiver" and v:GetAttribute("ToolName") == ToolName then
            Giver = v:FindFirstChildWhichIsA("BasePart")
            break
        end
    end

    if not Giver then
        gettingWeapon = false
        return
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Get Weapons",
        Text = "Trying to get " .. ToolName .. "...",
        Duration = 3,
    })

    local OriginalGiverCFrame = Giver.CFrame
    local UndergroundCFrame = OriginalGiverCFrame - Vector3.new(0, 15.5, 0)

    Giver.CanTouch = true
    Giver.CFrame = UndergroundCFrame
    Root.Anchored = true
    Char:PivotTo(UndergroundCFrame + Vector3.new(0, 5, 0))

    task.wait(0.25)
    firetouchinterest(Giver, Root, 0)
    task.wait(0.3)
    firetouchinterest(Giver, Root, 1)

    if Giver and Giver.Parent then
        Giver.CFrame = OriginalGiverCFrame
    end

    local function HasWeapon()
        Char = player.Character
        return player.Backpack:FindFirstChild(ToolName) ~= nil or (Char and Char:FindFirstChild(ToolName) ~= nil)
    end

    local Obtained = false
    local Elapsed = 0
    while Elapsed < 3 do
        if HasWeapon() then
            Obtained = true
            break
        end
        task.wait(0.1)
        Elapsed = Elapsed + 0.1
    end

    if not Obtained then
        Elapsed = 0
        while Elapsed < 2.5 do
            if HasWeapon() then
                Obtained = true
                break
            end
            task.wait(0.1)
            Elapsed = Elapsed + 0.1
        end
    end

    if Obtained then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Get Weapons",
            Text = "Successfully got " .. ToolName .. "!",
            Duration = 3,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Get Weapons",
            Text = "Failed to get " .. ToolName .. ".",
            Duration = 3,
        })
    end

    Root.Anchored = false
    gettingWeapon = false
end

getgenv().GetWeapons = function()
    task.spawn(function()
        local Char = player.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        if Root then
            OriginalGetWeaponsPosition = Root.CFrame
        end

        for _, ToolName in ipairs(Settings.GetWeaponsList) do
            getWeapon(ToolName)
        end

        Char = player.Character
        if Char and OriginalGetWeaponsPosition then
            Char:PivotTo(OriginalGetWeaponsPosition)
        end
    end)
end

player.CharacterAdded:Connect(function(Character)
    if not Settings.AutoGetWeapons then return end

    task.spawn(function()
        Character:WaitForChild("HumanoidRootPart", 5)

        local StartTime = tick()
        while Character:FindFirstChild("ForceField") and tick() - StartTime < 10 do
            task.wait(0.25)
        end

        task.wait(0.5)

        if player.Character == Character then
            getgenv().GetWeapons()
        end
    end)
end)

-- ============ INFINITE STAMINA ============
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local antiJump = char:FindFirstChild("AntiJump")
    if antiJump then
        antiJump.Disabled = Settings.InfiniteStamina
    end
end)

-- ============ VEHICLE MOD ============
local carContainer = workspace:WaitForChild("CarContainer")
local listcars = {}
local carNameLookup = {}

local function refreshCarList()
    listcars = {}
    carNameLookup = {}
    for _, car in ipairs(carContainer:GetChildren()) do
        local seat = car:FindFirstChild("VehicleSeat", true)
        if seat and car:FindFirstChild("Wheels") and not seat.Occupant then
            table.insert(listcars, car.Name)
            carNameLookup[car.Name] = car
        end
    end
end

local currentCar = nil
local seatConnection = nil

local function getCarFromSeat(seat)
    local model = seat
    local iterations = 0
    while model and model.Parent and model.Parent ~= carContainer do
        model = model.Parent
        iterations += 1
        if iterations > 20 then
            return nil
        end
    end
    if model and model.Parent == carContainer then
        return model
    end
    return nil
end

local function updateCurrentCar(_, seatPart)
    if seatPart and seatPart:IsA("VehicleSeat") then
        currentCar = getCarFromSeat(seatPart)
    else
        currentCar = nil
    end
end

local function hookCharacterSeat(char)
    task.spawn(function()
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid or not char.Parent then return end

        if seatConnection then
            seatConnection:Disconnect()
            seatConnection = nil
        end

        currentCar = nil
        seatConnection = humanoid.Seated:Connect(updateCurrentCar)
    end)
end

if player.Character then
    hookCharacterSeat(player.Character)
end
player.CharacterAdded:Connect(hookCharacterSeat)

local function findLocalCar()
    return currentCar
end

local function flipCarVertical()
    local car = findLocalCar()
    if not car then return end
    local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
    if not main then return end
    car.PrimaryPart = main
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local flipped = CFrame.new(curCF.Position) * CFrame.Angles(x + math.pi, y, z)
    car:PivotTo(flipped)
end

local function teleportCarToMe(carName)
    local car = carNameLookup[carName]
    if not car or not car:IsA("Model") then return false end

    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    local body = car:FindFirstChild("Body")
    local main = body and body:FindFirstChild("Main")
    if not main then return false end

    local vehicleSeat = car:FindFirstChild("VehicleSeat", true)
    if not vehicleSeat then return false end

    local targetPos = humanoidRootPart.Position + Vector3.new(0, 3, 0)
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(x, y, z)

    local partData = {}
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(partData, { part = v, wasAnchored = v.Anchored, wasCanCollide = v.CanCollide })
            v.Anchored = true
            v.CanCollide = false
        end
    end

    car.PrimaryPart = main

    local characterParts = {}
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(characterParts, { part = v, wasCanCollide = v.CanCollide })
            v.CanCollide = false
        end
    end

    local success = false
    for attempt = 1, 20 do
        pcall(function() car:PivotTo(targetCFrame) end)
        task.wait()
        local distance = (main.Position - targetPos).Magnitude
        if distance < 5 then
            success = true
            break
        end
        if attempt % 5 == 0 then
            targetCFrame = CFrame.new(targetPos + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))) * CFrame.Angles(x, y, z)
        end
    end

    task.spawn(function()
        for attempt = 1, 20 do
            if not character or not character:FindFirstChild("HumanoidRootPart") then break end
            pcall(function() character:PivotTo(vehicleSeat.CFrame + Vector3.new(0, 1, 0)) end)
            task.wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - vehicleSeat.Position).Magnitude < 3 then
                break
            end
        end
    end)

    task.wait(0.2)

    local restoreConnection
    restoreConnection = RunService.RenderStepped:Connect(function()
        restoreConnection:Disconnect()
        for _, data in ipairs(characterParts) do
            if data.part and data.part.Parent then
                data.part.CanCollide = data.wasCanCollide
            end
        end
        for _, data in ipairs(partData) do
            if data.part and data.part.Parent then
                data.part.Anchored = data.wasAnchored
                data.part.CanCollide = data.wasCanCollide
            end
        end
    end)

    return success
end

getgenv().FlipVehicle = function()
    flipCarVertical()
end

getgenv().RefreshCarList = function()
    refreshCarList()
    return listcars
end

getgenv().BringCar = function(carName)
    if carName then
        teleportCarToMe(carName)
    end
end

getgenv().TeleportToCar = function(carName)
    local car = carNameLookup[carName]
    if car then
        local vehicleseat = car:FindFirstChild("VehicleSeat", true)
        if vehicleseat and player.Character then
            player.Character:MoveTo(vehicleseat.Position)
        end
    end
end

-- ============ VEHICLE FLY ============
task.spawn(function()
    local MOVE_STEP = 1
    local TOL = 0.1
    local baseY, targetY, lastSlider = nil, nil, nil
    while true do
        task.wait()
        if not Settings.VehicleFlyEnabled then
            baseY, targetY, lastSlider = nil, nil, nil
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            continue
        end

        local car = findLocalCar()
        if not car then
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            baseY, targetY, lastSlider = nil, nil, nil
            continue
        end

        local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
        if not main then continue end
        car.PrimaryPart = main
        local curCF = main.CFrame
        local curPos = curCF.Position
        local sliderVal = Settings.VehicleFlyHeight or 0

        if not workspace:FindFirstChild("CarPart") then
            local p = Instance.new("Part")
            p.Size = Vector3.new(100, 1, 100)
            p.Name = "CarPart"
            p.Anchored = true
            p.CanCollide = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = Color3.fromRGB(100, 100, 100)
            p.Transparency = 1
            p.Parent = workspace
        end

        if not baseY then
            baseY = curPos.Y
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        elseif sliderVal ~= lastSlider then
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        end

        if curPos.Y < targetY - TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.min(curPos.Y + MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        elseif curPos.Y > targetY + TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.max(curPos.Y - MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local carPart = workspace:FindFirstChild("CarPart")
        if not carPart then return end
        local car = findLocalCar()
        if not car or not car:FindFirstChild("Wheels") then return end
        local wheel = car.Wheels:FindFirstChildWhichIsA("BasePart")
        if not wheel then return end
        carPart.Position = Vector3.new(wheel.Position.X, wheel.Position.Y - 1.3, wheel.Position.Z)
    end)
end)

-- ============ VEHICLE SPEED ============
local VehicleTorqueDefault = 5
local VehicleTurnSpeedDefault = 5

RunService.RenderStepped:Connect(function()
    local car = findLocalCar()
    if car then
        local rwd = car:FindFirstChild("RWD")
        local lw = car:FindFirstChild("LW") and car.LW:FindFirstChild("VS")
        local rw = car:FindFirstChild("RW") and car.RW:FindFirstChild("VS")
        local vehicleseat = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
        if rwd and lw and rw and vehicleseat then
            if Settings.VehicleMaxSpeedEnabled then
                local maxSpeed = Settings.VehicleMaxSpeed or 110
                rwd.MaxSpeed = maxSpeed
                lw.MaxSpeed = maxSpeed
                rw.MaxSpeed = maxSpeed
                vehicleseat.MaxSpeed = maxSpeed

                rwd.Torque = VehicleTorqueDefault
                lw.Torque = VehicleTorqueDefault
                rw.Torque = VehicleTorqueDefault
                vehicleseat.Torque = VehicleTorqueDefault

                rwd.TurnSpeed = VehicleTurnSpeedDefault
                lw.TurnSpeed = VehicleTurnSpeedDefault
                rw.TurnSpeed = VehicleTurnSpeedDefault
                vehicleseat.TurnSpeed = VehicleTurnSpeedDefault
            else
                rwd.TurnSpeed = 1
                lw.TurnSpeed = 1
                rw.TurnSpeed = 1
                vehicleseat.TurnSpeed = 1
            end
        end
    end
end)

-- ============ AUTOSHOOT ============
local ReplicatedStorage = game:GetService("ReplicatedStorage")
pcall(function()
    local gunRemotes = ReplicatedStorage:WaitForChild("GunRemotes", 5)
    if gunRemotes then
        shootRemote = gunRemotes:WaitForChild("ShootEvent", 5)
    end
end)

local AutoShootGunTracers = nil
pcall(function()
    local sharedModules = ReplicatedStorage:WaitForChild("SharedModules", 5)
    local tracersModule = sharedModules and sharedModules:WaitForChild("GunTracers", 5)
    if tracersModule then
        AutoShootGunTracers = require(tracersModule)
    end
end)

local function getEquippedWeapon()
    local char = player.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end

local autoShootParams = RaycastParams.new()
autoShootParams.FilterType = Enum.RaycastFilterType.Exclude
autoShootParams.CollisionGroup = "ClientBullet"

local lastAutoShotByWeapon = {}
local AutoShootRaycastInProgress = false

local function updateAmmoLabel(weapon, currentAmmo)
    local ok, gunFrame = pcall(function()
        return player.PlayerGui:WaitForChild("Home", 3)
            :WaitForChild("hud", 3)
            :WaitForChild("BottomRightFrame", 3)
            :WaitForChild("GunFrame", 3)
    end)
    if not ok or not gunFrame then return end

    local bulletsLabel = gunFrame:FindFirstChild("BulletsLabel")
    if not bulletsLabel then return end

    local behavior = weapon:GetAttribute("Behavior")
    if behavior == "Sniper" then
        local stored = weapon:GetAttribute("StoredAmmo") or 0
        bulletsLabel.Text = currentAmmo .. " | " .. stored
    else
        local maxAmmo = weapon:GetAttribute("MaxAmmo") or currentAmmo
        bulletsLabel.Text = currentAmmo .. "/" .. maxAmmo
    end
end

local function castPelletRay(weapon, origin, aimPoint, spreadRadius)
    local roll = math.random()
    local behavior = weapon:GetAttribute("Behavior")
    if behavior == "Sniper" or behavior == "Shotgun" then
        roll = math.sqrt(roll)
    end

    local range = weapon:GetAttribute("Range") or 1000
    local lookCFrame = CFrame.new(origin, aimPoint)
    local rollAngle = 360 - 720 * math.random()
    local direction = (lookCFrame * CFrame.Angles(0, 0, math.rad(rollAngle)) * CFrame.Angles(0, roll * spreadRadius, 0)).LookVector * range

    AutoShootRaycastInProgress = true
    local result = workspace:Raycast(origin, direction, autoShootParams)
    AutoShootRaycastInProgress = false

    local hitInstance = result and result.Instance or nil
    local hitPosition = result and result.Position or (origin + direction)
    return hitInstance, hitPosition
end

local function performAutoShot(weapon)
    if not weapon or not shootRemote then return end
    if not currentTarget or not currentTarget.Parent then return end

    local behavior = weapon:GetAttribute("Behavior")
    local reloadSession = weapon:GetAttribute("Local_ReloadSession") or 0
    local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0

    if reloadSession ~= 0 then return end
    if currentAmmo <= 0 then return end

    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end

    local origin = head.Position
    autoShootParams.FilterDescendantsInstances = { char }

    local aimPoint = currentTarget.Position
    local redirected = getRedirectedDirection(origin, aimPoint - origin)
    if redirected then
        aimPoint = origin + redirected
    end

    local projectileCount = weapon:GetAttribute("ProjectileCount") or 1
    local spreadRadius = weapon:GetAttribute("SpreadRadius") or 0

    local muzzle = weapon:FindFirstChild("Muzzle")
    local muzzlePos = muzzle and muzzle.Position or origin

    local bulletData = {}

    for i = 1, projectileCount do
        local hitInstance, hitPosition = castPelletRay(weapon, origin, aimPoint, spreadRadius)
        table.insert(bulletData, { origin, hitPosition, hitInstance })

        if AutoShootGunTracers then
            pcall(function()
                if behavior == "Sniper" then
                    AutoShootGunTracers.createSniper(muzzlePos, hitPosition)
                elseif behavior == "Taser" then
                    AutoShootGunTracers.createTaser(muzzlePos, hitPosition)
                else
                    AutoShootGunTracers.createBullet(muzzlePos, hitPosition)
                end
            end)
        end
    end

    shootRemote:FireServer(bulletData)

    local newAmmo = currentAmmo - 1
    weapon:SetAttribute("Local_CurrentAmmo", newAmmo)
    updateAmmoLabel(weapon, newAmmo)

    pcall(function()
        local handle = weapon:FindFirstChild("Handle")
        if handle then
            local shootSound = handle:FindFirstChild("ShootSound")
            if shootSound then
                local cloned = shootSound:Clone()
                cloned.Parent = handle
                cloned:Play()
                game:GetService("Debris"):AddItem(cloned, 5)
            end

            local flare = handle:FindFirstChild("Flare")
            if flare then
                flare.Enabled = true
                task.delay(0.05, function()
                    if flare then
                        flare.Enabled = false
                    end
                end)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not shootRemote then return end
    if not Settings.Enabled or not Settings.Autoshoot then return end
    if not currentTarget or not currentTarget.Parent then return end

    local char = player.Character
    local myHumanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not myHumanoid or myHumanoid.Health <= 0 then return end

    local weapon = getEquippedWeapon()
    if not weapon then return end

    local fireRate = weapon:GetAttribute("FireRate") or 0.1
    local weaponAutoFireAttr = weapon:GetAttribute("AutoFire")
    if not weaponAutoFireAttr then
        fireRate = fireRate * 1.5
    end

    if weapon.Name == "Remington 870" then
        fireRate = 0.45  
    end

    local lastShotTime = lastAutoShotByWeapon[weapon.Name] or 0
    if (tick() - lastShotTime) < fireRate then return end
    lastAutoShotByWeapon[weapon.Name] = tick()

    performAutoShot(weapon)
end)

-- ============ KEYBINDS ============
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if Settings.FastSwitchKeyCode and input.KeyCode == Settings.FastSwitchKeyCode then
        return
    end
    if Settings.VehicleFlyKeyCode and input.KeyCode == Settings.VehicleFlyKeyCode then
        Settings.VehicleFlyEnabled = not Settings.VehicleFlyEnabled
        return
    end
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.LeftControl then
        Settings.Enabled = not Settings.Enabled
        if fovCircle then fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled end
        if not Settings.Enabled then
            currentTarget = nil
            smoothedTargetPosition = nil
        end
    end
end)

player.CharacterAdded:Connect(function()
    camera.CameraType = Enum.CameraType.Custom
    if Settings.ESPEnabled then
        task.wait(0.5)
        updateESP()
    end
end)

-- ============ SKYBOXES ============
local skyboxes = {
    ["Gray Skybox"] = { SkyboxBk = "rbxassetid://154987705", SkyboxDn = "rbxassetid://154987705", SkyboxFt = "rbxassetid://154987705", SkyboxLf = "rbxassetid://154987705", SkyboxRt = "rbxassetid://154987705", SkyboxUp = "rbxassetid://154987705" },
    ["2knw & Donk666 Skybox"] = { SkyboxBk = "rbxassetid://121222457209872", SkyboxDn = "rbxassetid://121222457209872", SkyboxFt = "rbxassetid://121222457209872", SkyboxLf = "rbxassetid://121222457209872", SkyboxRt = "rbxassetid://121222457209872", SkyboxUp = "rbxassetid://121222457209872" },
    ["Snow Skybox"] = { SkyboxBk = "rbxassetid://155657655", SkyboxDn = "rbxassetid://155674246", SkyboxFt = "rbxassetid://155657609", SkyboxLf = "rbxassetid://155657671", SkyboxRt = "rbxassetid://155657619", SkyboxUp = "rbxassetid://155674931" },
    ["Cartoon Skybox"] = { SkyboxBk = "rbxassetid://15114954171", SkyboxDn = "rbxassetid://15114958869", SkyboxFt = "rbxassetid://15114963740", SkyboxLf = "rbxassetid://15114957947", SkyboxRt = "rbxassetid://15114955238", SkyboxUp = "rbxassetid://15114948718" },
    ["Lince Skybox"] = { SkyboxBk = "rbxassetid://102112718813044", SkyboxDn = "rbxassetid://102112718813044", SkyboxFt = "rbxassetid://102112718813044", SkyboxLf = "rbxassetid://102112718813044", SkyboxRt = "rbxassetid://102112718813044", SkyboxUp = "rbxassetid://102112718813044" },
    ["Red Skybox"] = { SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862", SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881", SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936" },
    ["Slam Skybox"] = { SkyboxBk = "rbxassetid://111576755001670", SkyboxDn = "rbxassetid://111576755001670", SkyboxFt = "rbxassetid://111576755001670", SkyboxLf = "rbxassetid://111576755001670", SkyboxRt = "rbxassetid://111576755001670", SkyboxUp = "rbxassetid://111576755001670" },
    ["Green Eyeball Skybox"] = { SkyboxBk = "rbxassetid://113857258921684", SkyboxDn = "rbxassetid://131099902234134", SkyboxFt = "rbxassetid://98342317659302", SkyboxLf = "rbxassetid://130914716725043", SkyboxRt = "rbxassetid://93970360759256", SkyboxUp = "rbxassetid://135000456639127" },
    ["Morioh Skybox"] = { SkyboxBk = "rbxassetid://414118015", SkyboxDn = "rbxassetid://414117901", SkyboxFt = "rbxassetid://414117817", SkyboxLf = "rbxassetid://414118150", SkyboxRt = "rbxassetid://414118255", SkyboxUp = "rbxassetid://414118438" },
    ["Rainy Skybox"] = { SkyboxBk = "rbxassetid://4498828382", SkyboxDn = "rbxassetid://4498828812", SkyboxFt = "rbxassetid://4498829917", SkyboxLf = "rbxassetid://4498830911", SkyboxRt = "rbxassetid://4498830417", SkyboxUp = "rbxassetid://4498831746" },
    ["Rusk1ddski Skybox"] = { SkyboxBk = "rbxassetid://139878758241374", SkyboxDn = "rbxassetid://139878758241374", SkyboxFt = "rbxassetid://139878758241374", SkyboxLf = "rbxassetid://139878758241374", SkyboxRt = "rbxassetid://139878758241374", SkyboxUp = "rbxassetid://139878758241374" }
}

function setSkybox(name)
    if currentSkybox then
        pcall(function()
            if Lighting:FindFirstChild(currentSkybox) then
                Lighting[currentSkybox]:Destroy()
            end
        end)
        currentSkybox = nil
    end
    if name == "None" then return end
    local data = skyboxes[name]
    if not data then return end
    local sky = Instance.new("Sky", Lighting)
    sky.Name = name
    for prop, value in pairs(data) do sky[prop] = value end
    currentSkybox = name
end

-- ============ CUSTOM BULLET COLOR ============
local CustomBulletColorEnabled = false
local CustomBulletColor = Color3.fromRGB(255, 255, 0)

function setCustomBulletColorEnabled(enabled)
    CustomBulletColorEnabled = enabled
end

function setBulletColorRGB(color)
    CustomBulletColor = color
end

local ReplicatedStorage_Tracers = game:GetService("ReplicatedStorage")
local BulletDebris = game:GetService("Debris")
local BulletTweenService = game:GetService("TweenService")
local TaserFadeTween = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local SniperFadeTween = TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

pcall(function()
    local sharedModules = ReplicatedStorage_Tracers:WaitForChild("SharedModules", 5)
    if not sharedModules then return end

    local GunTracersModule = sharedModules:WaitForChild("GunTracers", 5)
    if not GunTracersModule then return end

    local GunTracers = require(GunTracersModule)

    function GunTracers.createTaser(p8, p9)
        local dist = (p8 - p9).magnitude
        local mid = (p8 + p9) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.2, 0.2, dist)
        part.CFrame = CFrame.new(mid, p9)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false

        if CustomBulletColorEnabled then
            part.Color = CustomBulletColor
        else
            part.BrickColor = BrickColor.new("Cyan")
        end

        BulletDebris:AddItem(part, 2)

        local light = Instance.new("SurfaceLight", part)
        light.Color = CustomBulletColorEnabled and CustomBulletColor or Color3.fromRGB(0, 234, 255)
        light.Range = 7
        light.Face = "Bottom"
        light.Brightness = 5
        light.Angle = 180

        BulletTweenService:Create(part, TaserFadeTween, { Transparency = 1 }):Play()
        BulletTweenService:Create(light, TaserFadeTween, { Brightness = 0 }):Play()

        part.Parent = workspace.CurrentCamera
    end

    function GunTracers.createSniper(p16, p17)
        local dist = (p16 - p17).magnitude
        local mid = (p16 + p17) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.17, 0.17, dist)
        part.CFrame = CFrame.new(mid, p17)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false

        if CustomBulletColorEnabled then
            part.Color = CustomBulletColor
        else
            part.BrickColor = BrickColor.new("Medium stone grey")
        end

        BulletDebris:AddItem(part, 4)
        BulletTweenService:Create(part, SniperFadeTween, { Transparency = 1 }):Play()

        part.Parent = workspace.CurrentCamera
    end

    function GunTracers.createBullet(p21, p22)
        local dist = (p21 - p22).magnitude
        local mid = (p21 + p22) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.1, 0.1, dist)
        part.CFrame = CFrame.new(mid, p22)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false

        if CustomBulletColorEnabled then
            part.Color = CustomBulletColor
        else
            part.BrickColor = BrickColor.Yellow()
        end

        BulletDebris:AddItem(part, 0.05)

        part.Parent = workspace.CurrentCamera
    end
end)

-- ============ WEAPON MOD (GUN MOD) ============
local ToolPropertiesFolder = nil
pcall(function()
    ToolPropertiesFolder = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules", 5):WaitForChild("ToolProperties", 5)
end)

local gunModNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}

local function applyGunMod(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(gunModNames, tool.Name) then return end
    if not Settings.GunModEnabled then return end

    tool:SetAttribute("AutoFire", Settings.AutoFire == true)

    if Settings.FastFirerateEnabled then
        local rate = Settings.FireRateValue or 0.01
        tool:SetAttribute("FireRate", rate)

        if ToolPropertiesFolder then
            pcall(function()
                local moduleScript = ToolPropertiesFolder:FindFirstChild(tool.Name)
                if moduleScript then
                    local props = require(moduleScript)
                    props.FireRate = rate
                    props.AutoFire = Settings.AutoFire == true
                end
            end)
        end
    end
end

local function applyGunModToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            applyGunMod(tool)
        end
    end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            applyGunMod(tool)
        end
    end
end

local function hookGunModContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child)
        task.wait(0.05)
        applyGunMod(child)
    end)
end

hookGunModContainer(player:FindFirstChild("Backpack"))
if player.Character then
    hookGunModContainer(player.Character)
end

player.CharacterAdded:Connect(function(char)
    hookGunModContainer(char)
    task.wait(0.3)
    applyGunModToAllTools()
end)

getgenv().SetGunModEnabled = function(v)
    Settings.GunModEnabled = v == true
    applyGunModToAllTools()
end

getgenv().SetGunModAutoFire = function(v)
    Settings.AutoFire = v == true
    applyGunModToAllTools()
end

getgenv().SetGunModFastFirerate = function(v)
    Settings.FastFirerateEnabled = v == true
    applyGunModToAllTools()
end

getgenv().SetGunModFireRate = function(v)
    Settings.FireRateValue = v
    if Settings.FastFirerateEnabled then
        applyGunModToAllTools()
    end
end

-- ============ AUTO RELOAD ============
local FuncReloadRemote = nil
pcall(function()
    local gunRemotes = ReplicatedStorage:WaitForChild("GunRemotes", 5)
    if gunRemotes then
        FuncReloadRemote = gunRemotes:WaitForChild("FuncReload", 5)
    end
end)

local autoReloadInProgress = {}

local function performAutoReload(weapon)
    if not weapon or not FuncReloadRemote then return end
    if autoReloadInProgress[weapon] then return end

    local currentReloadSession = weapon:GetAttribute("Local_ReloadSession") or 0
    if currentReloadSession ~= 0 then return end

    local behavior = weapon:GetAttribute("Behavior")
    local storedAmmo = weapon:GetAttribute("StoredAmmo")

    if behavior == "Sniper" and storedAmmo and storedAmmo <= 0 then
        return
    end

    autoReloadInProgress[weapon] = true

    local reloadTime = weapon:GetAttribute("ReloadTime") or 1
    local session = tick()
    weapon:SetAttribute("Local_ReloadSession", session)

    task.spawn(function()
        FuncReloadRemote:InvokeServer()
    end)

    task.delay(reloadTime, function()
        if weapon:GetAttribute("Local_ReloadSession") == session then
            if behavior == "Sniper" then
                local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0
                local maxAmmo = weapon:GetAttribute("MaxAmmo") or 1
                local stored = weapon:GetAttribute("StoredAmmo") or 0

                if currentAmmo < maxAmmo then
                    weapon:SetAttribute("Local_CurrentAmmo", 1)
                    updateAmmoLabel(weapon, 1)
                end
            else
                local maxAmmo = weapon:GetAttribute("MaxAmmo") or 0
                weapon:SetAttribute("Local_CurrentAmmo", maxAmmo)
                updateAmmoLabel(weapon, maxAmmo)
            end
            weapon:SetAttribute("Local_ReloadSession", 0)
        end
        autoReloadInProgress[weapon] = nil
    end)
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoReloadEnabled then return end

    local weapon = getEquippedWeapon()
    if not weapon then return end
    if not table.find(gunModNames, weapon.Name) then return end

    local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0
    local reloadSession = weapon:GetAttribute("Local_ReloadSession") or 0

    if currentAmmo > 0 or reloadSession ~= 0 then return end

    performAutoReload(weapon)
end)

getgenv().SetAutoReloadEnabled = function(v)
    Settings.AutoReloadEnabled = v == true
end

-- ============ WEAPON SKIN ============
local SkinSettings = {
    Enabled = false,
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Material = Enum.Material.SmoothPlastic,
    TextureEnabled = false,
    TextureId = "",
}

local originalPartProps = {}
local skinToolNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}
local excludedPartNames = {"Handle", "Muzzle"}

local materialMap = {
    ForceField = Enum.Material.ForceField,
    SmoothPlastic = Enum.Material.SmoothPlastic,
    DiamondPlate = Enum.Material.DiamondPlate,
    Metal = Enum.Material.Metal,
    Marble = Enum.Material.Marble,
    Neon = Enum.Material.Neon,
}

local TextureMap = {
    Matrix = "rbxassetid://108962544192848",
    ["Blue Void"] = "rbxassetid://127882926538331",
    ["Classic blue White"] = "rbxassetid://80810460581216",
    ["Green and Black"] = "rbxassetid://124882447520456",
    White = "rbxassetid://121082905685777",
    ["Blue sky's with White Guns"] = "rbxassetid://84745365197133",
    ["Water Skin"] = "rbxassetid://119639132290940",
    Aurora = "rbxassetid://124100490232201",
    ["Epic White"] = "rbxassetid://100880863815885",
    ["Pink White"] = "rbxassetid://95856803518597",
    ["Blue Stars"] = "rbxassetid://118405531972534",
}

local function storeOriginalProps(tool)
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and not table.find(excludedPartNames, part.Name) and not originalPartProps[part] then
            originalPartProps[part] = {
                Color = part.Color,
                Material = part.Material,
                Transparency = part.Transparency,
                TextureID = part:IsA("MeshPart") and part.TextureID or nil,
            }
        end
    end
end

local function applyWeaponSkin(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(skinToolNames, tool.Name) then return end

    storeOriginalProps(tool)

    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and not table.find(excludedPartNames, part.Name) then
            if SkinSettings.Enabled then
                part.Color = SkinSettings.Color
                part.Material = SkinSettings.Material
                part.Transparency = SkinSettings.Transparency
            else
                local orig = originalPartProps[part]
                if orig then
                    part.Color = orig.Color
                    part.Material = orig.Material
                    part.Transparency = orig.Transparency
                end
            end

            if part:IsA("MeshPart") then
                if SkinSettings.TextureEnabled and SkinSettings.TextureId ~= "" then
                    part.TextureID = SkinSettings.TextureId
                else
                    local orig = originalPartProps[part]
                    if orig and orig.TextureID then
                        part.TextureID = orig.TextureID
                    end
                end
            end
        end
    end
end

local function applyWeaponSkinToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            applyWeaponSkin(tool)
        end
    end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            applyWeaponSkin(tool)
        end
    end
end

local function hookSkinContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child)
        task.wait(0.05)
        applyWeaponSkin(child)
    end)
end

hookSkinContainer(player:FindFirstChild("Backpack"))
if player.Character then
    hookSkinContainer(player.Character)
end

player.CharacterAdded:Connect(function(char)
    hookSkinContainer(char)
    task.wait(0.3)
    applyWeaponSkinToAllTools()
end)

getgenv().SetWeaponColorEnabled = function(v)
    SkinSettings.Enabled = v == true
    applyWeaponSkinToAllTools()
end

getgenv().SetWeaponColorRGB = function(v)
    SkinSettings.Color = v
    if SkinSettings.Enabled then
        applyWeaponSkinToAllTools()
    end
end

getgenv().SetWeaponTransparency = function(v)
    SkinSettings.Transparency = v
    if SkinSettings.Enabled then
        applyWeaponSkinToAllTools()
    end
end

getgenv().SetWeaponMaterial = function(v)
    SkinSettings.Material = materialMap[v] or Enum.Material.SmoothPlastic
    if SkinSettings.Enabled then
        applyWeaponSkinToAllTools()
    end
end

getgenv().SetWeaponTextureEnabled = function(v)
    SkinSettings.TextureEnabled = v == true
    applyWeaponSkinToAllTools()
end

getgenv().SetWeaponTexture = function(v)
    SkinSettings.TextureId = TextureMap[v] or ""
    if SkinSettings.TextureEnabled then
        applyWeaponSkinToAllTools()
    end
end

-- ============ KILL EFFECT FRAME ============
local TweenService = game:GetService("TweenService")

local KillEffectGui = Instance.new("ScreenGui")
KillEffectGui.Name = "KillEffectGui"
KillEffectGui.ResetOnSpawn = false
KillEffectGui.IgnoreGuiInset = true
KillEffectGui.DisplayOrder = 999
KillEffectGui.Parent = player:WaitForChild("PlayerGui")

local KillEffectFrame = Instance.new("Frame")
KillEffectFrame.Name = "KillEffectFrame"
KillEffectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KillEffectFrame.Position = UDim2.fromScale(0.5, 0.5)
KillEffectFrame.Size = UDim2.fromScale(1, 1)
KillEffectFrame.BackgroundColor3 = Settings.KillEffectColor
KillEffectFrame.BackgroundTransparency = 1
KillEffectFrame.BorderSizePixel = 0
KillEffectFrame.ZIndex = 999
KillEffectFrame.Parent = KillEffectGui

local killEffectSizeConnection
local function autoSizeKillEffectFrame()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if viewport then
        KillEffectFrame.Size = UDim2.fromOffset(viewport.X, viewport.Y)
    end
end
autoSizeKillEffectFrame()

if workspace.CurrentCamera then
    killEffectSizeConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoSizeKillEffectFrame)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if killEffectSizeConnection then
        killEffectSizeConnection:Disconnect()
    end
    if workspace.CurrentCamera then
        killEffectSizeConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoSizeKillEffectFrame)
        autoSizeKillEffectFrame()
    end
end)

local killEffectPlaying = false

function playKillEffect()
    if not Settings.KillEffectEnabled then return end
    if killEffectPlaying then return end
    killEffectPlaying = true

    KillEffectFrame.BackgroundColor3 = Settings.KillEffectColor
    KillEffectFrame.BackgroundTransparency = 1

    local fadeDuration = Settings.KillEffectFadeDuration or 0.25

    local fadeIn = TweenService:Create(
        KillEffectFrame,
        TweenInfo.new(fadeDuration / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        { BackgroundTransparency = 0.4 }
    )

    local fadeOut = TweenService:Create(
        KillEffectFrame,
        TweenInfo.new(fadeDuration / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
        { BackgroundTransparency = 1 }
    )

    fadeIn:Play()
    fadeIn.Completed:Wait()
    fadeOut:Play()
    fadeOut.Completed:Wait()

    killEffectPlaying = false
end

getgenv().SetKillEffectEnabled = function(v)
    Settings.KillEffectEnabled = v == true
end

getgenv().SetKillEffectColor = function(v)
    Settings.KillEffectColor = v
end

getgenv().SetKillEffectFadeDuration = function(duration)
    Settings.KillEffectFadeDuration = duration
end

getgenv().SetKillLogsEnabled = function(v)
    Settings.KillLogsEnabled = v == true
end

getgenv().SetHitLogsEnabled = function(v)
    Settings.HitLogsEnabled = v == true
end

-- ============ KILL LOGS ============
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function parseKillFeedEntry(entryName)
    local killerDisplay, killerUser, victimDisplay, weapon =
        entryName:match("^(.-)%s*%(@(.-)%)%s*killed%s+(.-)%s+with%s+(.+)$")
    return killerDisplay, killerUser, victimDisplay, weapon
end

local function onKillFeedEntry(entry)
    if not entry:IsA("IntValue") then return end

    local killerDisplay, killerUser, victimDisplay, weapon = parseKillFeedEntry(entry.Name)
    if not killerDisplay then return end

    if Settings.KillLogsEnabled then
        Library:Notify({
            Title = "Kill Logs",
            Description = killerDisplay .. " killed " .. victimDisplay .. " with " .. weapon,
            Time = 4,
        })
    end

    if killerUser == player.Name then
        task.spawn(playKillEffect)
        playKillSound()
    end
end

local KillFeedFolder = ReplicatedStorage:WaitForChild("Killfeed", 10)
if KillFeedFolder then
    KillFeedFolder.ChildAdded:Connect(onKillFeedEntry)
end

-- ============ ESP ============
function applyESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local teamColor = Color3.fromRGB(255, 0, 0)
    if plr.TeamColor then teamColor = plr.TeamColor.Color
    elseif plr.Team and plr.Team.TeamColor then teamColor = plr.Team.TeamColor.Color end
    
    local highlight = char:FindFirstChild("ESPHighlight")
    if not highlight then
        highlight = Instance.new("Highlight", char)
        highlight.Name = "ESPHighlight"
    end
    highlight.FillColor = teamColor
    highlight.FillTransparency = 0.85
    highlight.OutlineColor = teamColor
    highlight.OutlineTransparency = 0
    
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("ESPNameTag")
        if not Settings.ESPNamesEnabled then
            if billboard then billboard:Destroy() end
        elseif not billboard then
            billboard = Instance.new("BillboardGui", head)
            billboard.Name = "ESPNameTag"
            billboard.Size = UDim2.new(0, 200, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            local label = Instance.new("TextLabel", billboard)
            label.Name = "NameLabel"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            label.TextColor3 = Settings.ESPTextColor or Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = Settings.ESPNameTextSize or 12
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function removeESP(plr)
    if plr.Character then
        local highlight = plr.Character:FindFirstChild("ESPHighlight")
        if highlight then highlight:Destroy() end
        local head = plr.Character:FindFirstChild("Head")
        if head then
            local billboard = head:FindFirstChild("ESPNameTag")
            if billboard then billboard:Destroy() end
            local targetBillboard = head:FindFirstChild("ESPTargetNameTag")
            if targetBillboard then targetBillboard:Destroy() end
        end
    end
end

function updateESP()
    if not Settings.ESPEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then removeESP(plr) end
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then applyESP(plr) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if Settings.ESPEnabled then
            task.wait(0.5)
            applyESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    removeTracerBeam(plr)
end)

-- ============ FOV COLOR SYSTEM ============
local fovRainbowConnection = nil

function setFOVColorRGB(color)
    if fovRainbowConnection then
        fovRainbowConnection:Disconnect()
        fovRainbowConnection = nil
    end
    Settings.FOVColor = color
    if fovCircle and fovCircle:FindFirstChild("UIStroke") then
        fovCircle.UIStroke.Color = color
    end
end

function setFogColorRGB(color)
    Lighting.FogColor = color
end

function setTracerColorRGB(color)
    Settings.TracerColor = color
end

function setESPTargetColorRGB(color)
    Settings.ESPTargetColor = color
end

function setESPTextColor(color)
    Settings.ESPTextColor = color
end

function setESPTargetTextColor(color)
    Settings.ESPTargetTextColor = color
end

-- ============ WEAPON SOUND PACKS ============
local SoundPacks = {
    ["Silenced Shot"] = { ShootSound = 9341262362 },
    ["Bubble Shot"] = { ShootSound = 109244508089412 },
    ["Laser Shot"] = { ShootSound = 109075387966089 },
    ["Dart Gun"] = { ShootSound = 5924183835 },
    ["Energy Shot"] = { ShootSound = 113363294416214 },
    ["Neverlose"] = { ShootSound = 82938206376993 },
}

local CurrentSoundPack = nil
local soundToolNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}

local function applySoundPackToTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(soundToolNames, tool.Name) then return end

    local handle = tool:FindFirstChild("Handle")
    if not handle then return end

    local shootSound = handle:FindFirstChild("ShootSound")
    if not shootSound then return end

    if not CurrentSoundPack then return end

    local packData = SoundPacks[CurrentSoundPack]
    if not packData or not packData.ShootSound then return end

    shootSound.SoundId = "rbxassetid://" .. packData.ShootSound
end

local function applySoundPackToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                applySoundPackToTool(tool)
            end
        end
    end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                applySoundPackToTool(tool)
            end
        end
    end
end

getgenv().SetWeaponSoundPack = function(packName)
    if typeof(packName) == "table" then
        return
    end

    if packName == "None" or not packName then
        CurrentSoundPack = nil
    else
        CurrentSoundPack = packName
    end

    applySoundPackToAllTools()
end

local function hookToolContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait()
            applySoundPackToTool(child)
        end
    end)
end

hookToolContainer(player:FindFirstChild("Backpack"))
if player.Character then
    hookToolContainer(player.Character)
end

player.CharacterAdded:Connect(function(char)
    hookToolContainer(char)
    task.wait(0.5)
    applySoundPackToAllTools()
end)

-- ============ HIT & KILL SOUNDS ============
local HitSounds = {
    ["TF2 Hit"] = 137392628136734,
    ["Metal Bat Hit"] = 114303603199822,
    ["Neverlose"] = 82938206376993,
    ["Minecraft Hit 1"] = 135478009117226,
    ["Minecraft Hit 2"] = 4018616850,
    ["MLG Hit"] = 109817519733426,
    ["Fahhh Hit"] = 139259088251978,
    ["Xbox Live Notification"] = 117934611310434,
    ["Rust"] = 1255040462,
    ["Fatality"] = 6534947869,
    ["Skeet"] = 5633695679,
    ["Pick"] = 1347140027,
    ["Creepy Bell"] = 98025615996882,
}

local KillSounds = {
    ["Fahhh"] = 93458245768554,
    ["Epic Kill 1"] = 87039942244697,
    ["Epic Kill 2"] = 75248488088600,
    ["Laugh"] = 87825295777427,
    ["Cat Laughing Meme"] = 133312610824902,
    ["Goofy Laugh"] = 128132519337195,
    ["PVZ Laugh"] = 137716148492089,
    ["CoD Kaboom"] = 7358219350,
    ["You are a Idiot"] = 3200130016,
    ["Creepy Bell"] = 98025615996882,
    ["Vine Boom"] = 140367458608473,
    ["RDR2 Low Honor"] = 126973996863873,
    ["Get Out"] = 138093000712523,
    ["Diahrrea Sound"] = 130990339683290,
    ["Goku Prowler"] = 131169447699141,
    ["iPhone Ding"] = 120612883125769,
    ["Bark Fart"] = 124264573696620,
    ["Enrique"] = 129084748747846,
    ["Fatality 2"] = 97439296876895,
}

local CustomHitSoundEnabled = false
local CustomKillSoundEnabled = false
local CurrentHitSound = nil
local CurrentKillSound = nil

local HitSoundTemplate = Instance.new("Sound")
HitSoundTemplate.Name = "HitSoundTemplate"
HitSoundTemplate.Volume = 1

local KillSoundTemplate = Instance.new("Sound")
KillSoundTemplate.Name = "KillSoundTemplate"
KillSoundTemplate.Volume = 1

local SoundDebris = game:GetService("Debris")

function playHitSound()
    if not CustomHitSoundEnabled or not CurrentHitSound then return end

    local cloned = Instance.new("Sound")
    cloned.Name = "HitSoundClone"
    cloned.SoundId = "rbxassetid://" .. CurrentHitSound
    cloned.Volume = 1
    cloned.Parent = workspace.CurrentCamera
    cloned:Play()

    cloned.Ended:Connect(function()
        cloned:Destroy()
    end)
    SoundDebris:AddItem(cloned, 5)
end

function playKillSound()
    if not CustomKillSoundEnabled or not CurrentKillSound then return end
    KillSoundTemplate.SoundId = "rbxassetid://" .. CurrentKillSound

    local cloned = KillSoundTemplate:Clone()
    cloned.Parent = workspace.CurrentCamera
    cloned:Play()

    cloned.Ended:Connect(function()
        cloned:Destroy()
    end)
    SoundDebris:AddItem(cloned, 5)
end

getgenv().SetCustomHitSoundEnabled = function(v)
    CustomHitSoundEnabled = v == true
end

getgenv().SetCustomKillSoundEnabled = function(v)
    CustomKillSoundEnabled = v == true
end

getgenv().SetHitSound = function(name)
    if typeof(name) == "table" then return end
    CurrentHitSound = HitSounds[name]
end

getgenv().SetKillSound = function(name)
    if typeof(name) == "table" then return end
    CurrentKillSound = KillSounds[name]
end

local function loadUI()
    local uiUrls = {
        "https://raw.githubusercontent.com/ludicious-claw/precisionlol/refs/heads/main/UI%20Test",
        "https://cdn.jsdelivr.net/gh/ludicious-claw/precisionlol@main/UI%20Test",
    }

    local maxAttempts = 3
    local retryDelay = 1.5

    for _, url in ipairs(uiUrls) do
        for attempt = 1, maxAttempts do
            local ok, result = pcall(function()
                local source = game:HttpGet(url)

                if not source or #source < 100 or source:sub(1, 1) == "<" then
                    error("Invalid or empty response from URL")
                end

                local chunk, compileErr = loadstring(source)
                if not chunk then
                    error("Failed to compile UI: " .. tostring(compileErr))
                end

                return chunk()
            end)

            if ok then
                return true
            end

            task.wait(retryDelay)
        end
    end

    return false
end

if not loadUI() then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "UI Failed to Load",
            Text = "Could not load the interface. Please try running the script again.",
            Duration = 8,
        })
    end)
    error("Failed to load the UI after all attempts.")
end

-- ============ DISCORD WEBHOOK ============
local HttpService = game:GetService("HttpService")
local http_request = http_request or request or (syn and syn.request) or (http and http.request)

local function fetchThumbnail(userId, kind, size)
    local ok, res = pcall(http_request, {
        Url = ("https://thumbnails.roblox.com/v1/users/%s?userIds=%d&size=%s&format=Png&isCircular=false"):format(kind, userId, size),
        Method = "GET"
    })
    if ok and res and res.StatusCode == 200 then
        local dok, decoded = pcall(HttpService.JSONDecode, HttpService, res.Body)
        if dok and decoded and decoded.data and decoded.data[1] then
            return decoded.data[1].imageUrl
        end
    end
    return ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png"):format(userId)
end

local lastFeedbackTime = 0
local FeedbackCooldownSeconds = 60

getgenv().SendFeedback = function(feedbackText)
    local now = tick()
    local elapsed = now - lastFeedbackTime

    if elapsed < FeedbackCooldownSeconds then
        local remaining = math.ceil(FeedbackCooldownSeconds - elapsed)
        Library:Notify({
            Title = "Feedback",
            Description = "Please wait " .. remaining .. " more second(s) before sending another feedback.",
            Time = 3,
        })
        return
    end

    if not feedbackText or feedbackText:match("^%s*$") then
        Library:Notify({ Title = "Feedback", Description = "Please write something before sending.", Time = 3 })
        return
    end

    lastFeedbackTime = now

    task.spawn(function()
        local feedbackWebhookUrl = "https://discord.com/api/webhooks/1545483424910020689/vlAjD79BD0b3tS6z-ov8XGeVE3nmhpj7JD-N36PHLjsW8erPE3_WPSKPFM85nLZLRBID"

        local userId = player.UserId
        local head = fetchThumbnail(userId, "avatar-headshot", "150x150")

        local embed = {
            color = 0x00B450,
            author = {
                name = player.DisplayName .. " (@" .. player.Name .. ")",
                icon_url = head,
                url = "https://www.roblox.com/users/" .. userId .. "/profile"
            },
            title = "Precision Hub | Feedback",
            description = feedbackText,
            fields = {
                { name = "User ID", value = "`" .. userId .. "`", inline = true },
                { name = "Time", value = "`" .. os.date("%H:%M:%S") .. "`", inline = true },
            },
            footer = { text = "Precision Hub Feedback" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }

        local ok = pcall(function()
            http_request({
                Url = feedbackWebhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({ embeds = { embed } })
            })
        end)

        if ok then
            Library:Notify({ Title = "Feedback", Description = "Feedback sent successfully! Thank you.", Time = 3 })
            Options.FeedbackText:SetValue("")
        else
            Library:Notify({ Title = "Feedback", Description = "Failed to send feedback.", Time = 3 })
        end
    end)
end

local function getDeviceType()
    local device = "PC"
    if UserInputService.TouchEnabled then
        device = "Mobile"
    end
    if UserInputService.GamepadEnabled then
        device = "Console"
    end
    return device
end

local function sendWebhook()
    local webhookUrl = "https://discord.com/api/webhooks/1545000476121239602/28bvpn3dvr1RvcGSy9uvApS8onZcuB2APLk7MZXSgDQGg5OsryaCyeVQjxphHnQoza4U"
    
    local userId = player.UserId
    local head = fetchThumbnail(userId, "avatar-headshot", "150x150")
    local body = fetchThumbnail(userId, "avatar", "420x420")

    local executorName = "Unknown"
    pcall(function()
        if identifyexecutor then
            executorName = identifyexecutor()
        end
    end)

    local regionCode = "Unknown"
    pcall(function()
        regionCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(player)
    end)
    
local joinScript = "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\", game.Players.LocalPlayer)"

local embed = {
    color = 0x00B450,
    author = { 
        name = player.DisplayName .. " (@" .. player.Name .. ")", 
        icon_url = head, 
        url = "https://www.roblox.com/users/" .. userId .. "/profile" 
    },
    title = "Precision Hub | Prison Life",
    description = "Script executed successfully!",
    thumbnail = { url = body },  
    fields = {
        { name = "User ID", value = "`" .. userId .. "`", inline = true },
        { name = "Time", value = "`" .. os.date("%H:%M:%S") .. "`", inline = true },
        { name = "Executor", value = "`" .. executorName .. "`", inline = true },
        { name = "Country", value = "`" .. regionCode .. "`", inline = true },
        { name = "Device", value = "`" .. getDeviceType() .. "`", inline = false },
        { name = "Join Script", value = "```lua\n" .. joinScript .. "\n```", inline = false },
    },
    footer = { text = "Precision Hub" },
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}
    
    pcall(function()
        http_request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ embeds = { embed } })
        })
    end)
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Precision Hub Executed!",
            Text = "discord.gg/unxmjPC4x7",
            Duration = 5,
        })
    end)
end

if player.UserId ~= 1 then
    task.spawn(sendWebhook)
end