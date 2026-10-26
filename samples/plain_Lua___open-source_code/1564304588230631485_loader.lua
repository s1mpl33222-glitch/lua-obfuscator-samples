_G.leakedbySticky_Executed = true  
  
local Players = game:GetService("Players")  
local Workspace = game:GetService("Workspace")  
local RunService = game:GetService("RunService")  
local TweenService = game:GetService("TweenService")  
local CoreGui = game:GetService("CoreGui")  
local UserInputService = game:GetService("UserInputService")  
local HttpService = game:GetService("HttpService")  
local GuiService = game:GetService("GuiService")  
local ReplicatedStorage = game:GetService("ReplicatedStorage")  
  
local LocalPlayer = Players.LocalPlayer  
if not LocalPlayer then  
    repeat task.wait() until Players.LocalPlayer  
    LocalPlayer = Players.LocalPlayer  
end  
local player = LocalPlayer  
  
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled  
  
local safeGuiTarget = nil  
local successCore, _ = pcall(function()  
    local test = Instance.new("Folder")  
    test.Parent = CoreGui  
    test:Destroy()  
end)  
safeGuiTarget = successCore and CoreGui or (player:WaitForChild("PlayerGui", 5) or player.PlayerGui)  
  
local function getGuiParent()  
    if gethui then return gethui() end  
    return safeGuiTarget  
end  
  
pcall(function()  
    for _, name in ipairs({"leakedbySticky_Remake", "leakedbySticky_ProgressBar", "leakedbySticky_Speed_Only", "leakedbyStickyAPSpamGui", "AllowDisallow"}) do  
        if getGuiParent():FindFirstChild(name) then  
            getGuiParent()[name]:Destroy()  
        end  
    end  
end)  
  
local MAIN_FONT = Enum.Font.FredokaOne  
local COLOR_BG_DARK = Color3.fromRGB(0, 0, 0)  
local COLOR_CARD_BG = Color3.fromRGB(4, 18, 8)  
local COLOR_BORDER = Color3.fromRGB(57, 255, 20)  
local COLOR_ACCENT = Color3.fromRGB(57, 255, 20)  
local COLOR_TEXT_LIGHT = Color3.fromRGB(255, 255, 255)  
local COLOR_TEXT_DARK = Color3.fromRGB(57, 255, 20)  
  
local HEX_TEXT_PATTERN = ColorSequence.new({  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(57, 255, 20)),  
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 120, 35)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))  
})  
  
local function applyTextGradient(textObject)  
    if not textObject then return end  
    local stroke = textObject:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")  
    stroke.Thickness = 1.2  
    stroke.Color = Color3.fromRGB(0, 0, 0)  
    stroke.Transparency = 0.2  
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual  
    stroke.Parent = textObject  
  
    local grad = textObject:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")  
    grad.Color = HEX_TEXT_PATTERN  
    grad.Rotation = 45  
    grad.Parent = textObject  
  
    RunService.RenderStepped:Connect(function(deltaTime)  
        if grad and grad.Parent then  
            grad.Rotation = (grad.Rotation + 35 * deltaTime) % 360  
        end  
    end)  
    return grad  
end  
  
local function createUICorner(parent, radius)  
    local corner = Instance.new("UICorner")  
    corner.CornerRadius = UDim.new(0, radius)  
    corner.Parent = parent  
end  
  
local function addHoverAnimation(btn, normalColor, hoverColor)  
    btn.MouseEnter:Connect(function()  
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = hoverColor}):Play()  
    end)  
    btn.MouseLeave:Connect(function()  
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = normalColor}):Play()  
    end)  
end  
  
local configFile = "leakedbyStickyHUB_FlashTP_Config.json"  
local HubConfig = {  
    speedBoostEnabled = false,  
    speedValue = 25,  
    hexSpeedVisible = false,  
    speedPos = {ScaleX = 0.98, OffsetX = 0, ScaleY = 0.02, OffsetY = 0},  
    stealKeybind = "E",  
    potionEnabled = true,  
    autoWalkEnabled = false,  
    apOnStealEnabled = false,  
    autoTPOnAllowEnabled = false,  
    autoActivateEnabled = false,  
    kickAfterStealEnabled = false,  
    selectedSlot = 1,  
    selectedGear = "Auto"  
}  
  
if isfile and isfile(configFile) then  
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)  
    if success and decoded then  
        for k, v in pairs(decoded) do  
            if k ~= "selectedSlot" then HubConfig[k] = v end  
        end  
    end  
end  
HubConfig.selectedSlot = 1  
  
local function saveHubConfig()  
    if writefile then pcall(function() writefile(configFile, HttpService:JSONEncode(HubConfig)) end) end  
end  
  
_G.speedBoostEnabled = HubConfig.speedBoostEnabled  
local currentSpeed = HubConfig.speedValue or 25  
local currentStealKey = Enum.KeyCode[HubConfig.stealKeybind or "E"]  
local PotionEnabled = HubConfig.potionEnabled  
local AutoWalkEnabled = HubConfig.autoWalkEnabled  
local APOnStealEnabled = HubConfig.apOnStealEnabled  
local AutoTPOnAllowEnabled = HubConfig.autoTPOnAllowEnabled or false  
local AutoActivateEnabled = HubConfig.autoActivateEnabled or false  
local KickAfterStealEnabled = HubConfig.kickAfterStealEnabled or false  
local selectedSlot = 1  
  
local ALL_CMDS = {"rocket", "tiny", "jumpscare", "morph", "inverse"}  
local selectedCmds = {}  
for _, cmd in ipairs(ALL_CMDS) do selectedCmds[cmd] = true end  
  
local function getAdminPanelButtons()  
    local ap = LocalPlayer.PlayerGui:FindFirstChild("AdminPanel")  
    if not ap then return nil, nil end  
    local inner = ap:FindFirstChild("AdminPanel")  
    if not inner then return nil, nil end  
    local content, profiles = inner:FindFirstChild("Content"), inner:FindFirstChild("Profiles")  
    if not content or not profiles then return nil, nil end  
    return content:FindFirstChild("ScrollingFrame"), profiles:FindFirstChild("ScrollingFrame")  
end  
  
local fireCmd = function(targetPlayer, cmd)  
    local csf, psf = getAdminPanelButtons()  
    if not csf or not psf then return end  
    local pb, cb = psf:FindFirstChild(targetPlayer.Name), csf:FindFirstChild(cmd)  
    if not pb or not cb then return end  
  
    if firesignal then  
        firesignal(cb.Activated)  
        firesignal(pb.Activated)  
    elseif getconnections then  
        for _, c in ipairs(getconnections(cb.Activated)) do if c.Function then task.spawn(c.Function) end end  
        for _, c in ipairs(getconnections(pb.Activated)) do if c.Function then task.spawn(c.Function) end end  
    end  
end  
  
local lastSpam, COOLDOWN = 0, 0.15  
local doSpam = function()  
    if tick() - lastSpam < COOLDOWN then return end  
    lastSpam = tick()  
    local toFire = {}  
    for _, cmd in ipairs(ALL_CMDS) do if selectedCmds[cmd] then table.insert(toFire, cmd) end end  
    if #toFire == 0 then return end  
    for _, p in ipairs(Players:GetPlayers()) do  
        if p ~= LocalPlayer then  
            for _, cmd in ipairs(toFire) do fireCmd(p, cmd) end  
        end  
    end  
end  
  
local activeSpeedConnections = {}  
local function clearSpeedConnections()  
    for _, conn in ipairs(activeSpeedConnections) do if conn then conn:Disconnect() end end  
    activeSpeedConnections = {}  
end  
  
local function initSpeedFeatures(char)  
    clearSpeedConnections()  
    local hum = char:WaitForChild("Humanoid", 5)  
    local hrp = char:WaitForChild("HumanoidRootPart", 5)  
    if not (hum and hrp) then return end  
  
    local wasSpeedEnabled = false  
    local speedConn = RunService.Heartbeat:Connect(function()  
        if not char or not char.Parent or not hum or not hrp then return end  
        if _G.speedBoostEnabled then  
            wasSpeedEnabled = true  
            hum.UseJumpPower = true  
            hum.JumpPower = 40  
            if hum.MoveDirection.Magnitude > 0 then  
                local flat = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit  
                hrp.Velocity = Vector3.new(flat.X * currentSpeed, hrp.Velocity.Y, flat.Z * currentSpeed)  
            end  
        elseif wasSpeedEnabled then  
            wasSpeedEnabled = false  
            hum.JumpPower = 50  
        end  
    end)  
    table.insert(activeSpeedConnections, speedConn)  
end  
  
if player.Character then task.spawn(initSpeedFeatures, player.Character) end  
player.CharacterAdded:Connect(function(char) task.wait(0.2); initSpeedFeatures(char) end)  
  
local STEAL_DURATION = 1.3  
local progressFill, percentLabel = nil, nil  
  
local function updateProgressBar(p)  
    if progressFill then  
        TweenService:Create(progressFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
            Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0)  
        }):Play()  
    end  
    if percentLabel then percentLabel.Text = math.floor(math.clamp(p, 0, 1) * 100) .. "%" end  
end  
  
local function detectStealAndWait()  
    local startTime = tick()  
    while player:GetAttribute("Stealing") == nil do  
        if tick() - startTime >= 3 then break end  
        task.wait(0.1)  
    end  
    if player:GetAttribute("Stealing") ~= nil then task.wait(0.5) end  
end  
  
local function findMyBase()  
    local plots = Workspace:FindFirstChild("Plots")  
    if not plots then return nil end  
    for _, base in pairs(plots:GetChildren()) do  
        if base:IsA("Model") then  
            for _, d in pairs(base:GetDescendants()) do  
                if d:IsA("TextLabel") and (string.find(d.Text, player.Name) or string.find(d.Text, player.DisplayName)) then  
                    return base  
                end  
            end  
        end  
    end  
    return nil  
end  
  
local function isEnemyPlot(plot)  
    if not plot or not plot:IsA("Model") then return false end  
    local sign = plot:FindFirstChild("PlotSign")  
    local sg = sign and sign:FindFirstChild("SurfaceGui")  
    local frame = sg and sg:FindFirstChild("Frame")  
    local label = frame and frame:FindFirstChild("TextLabel")  
    if not label or label.Text == "Empty Base" then return false end  
    local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")  
    return owner ~= player.Name and owner ~= player.DisplayName  
end  
  
local darkBlueHighlight = Instance.new("Highlight")  
darkBlueHighlight.Name = "leakedbySticky_DarkBlue_Podium_Highlight"  
darkBlueHighlight.FillColor = Color3.fromRGB(90, 0, 0)  
darkBlueHighlight.OutlineColor = Color3.fromRGB(57, 255, 20)  
darkBlueHighlight.FillTransparency = 0.35  
darkBlueHighlight.OutlineTransparency = 0  
  
local function getTargetPodiumForSlot(slot)  
    local plots = Workspace:FindFirstChild("Plots")  
    if not plots then return nil end  
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
  
    local slotMap = {  
        [1] = {"1", "10"},  
        [2] = {"2", "9"},  
        [3] = {"3", "8"},  
        [4] = {"4", "7"},  
        [5] = {"5", "6"}  
    }  
    local searchSlots = slotMap[slot] or {"1", "10"}  
    local bestPodium = nil  
    local minDist = math.huge  
  
    for _, plot in ipairs(plots:GetChildren()) do  
        local isEnemy = false  
        if slot == 1 then  
            local myName = player.DisplayName  
            local sign = plot:FindFirstChild("PlotSign")  
            local label = sign and sign:FindFirstChild("SurfaceGui")  
                and sign.SurfaceGui:FindFirstChild("Frame")  
                and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")  
            if label and label.Text ~= "Empty Base" then  
                local owner = label.Text:gsub("'s Base$",""):gsub("'s base$",""):gsub("%s+$","")  
                if owner ~= myName and owner ~= player.Name then isEnemy = true end  
            end  
        else  
            isEnemy = isEnemyPlot(plot)  
        end  
  
        if isEnemy then  
            local podiums = plot:FindFirstChild("AnimalPodiums")  
            if podiums then  
                for _, pname in ipairs(searchSlots) do  
                    local podium = podiums:FindFirstChild(pname)  
                    if podium then  
                        local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main")  
                        if cm then  
                            local dist = hrp and (hrp.Position - cm.Position).Magnitude or 0  
                            if dist < minDist then  
                                minDist = dist  
                                bestPodium = podium  
                            end  
                        end  
                    end  
                end  
            end  
        end  
    end  
    return bestPodium  
end  
  
task.spawn(function()  
    while task.wait(0.25) do  
        local targetPodium = getTargetPodiumForSlot(selectedSlot)  
        if targetPodium then  
            if darkBlueHighlight.Adornee ~= targetPodium or darkBlueHighlight.Parent ~= targetPodium then  
                darkBlueHighlight.Adornee = targetPodium  
                darkBlueHighlight.Parent = targetPodium  
            end  
        else  
            darkBlueHighlight.Adornee = nil  
            darkBlueHighlight.Parent = nil  
        end  
    end  
end)  
  
local function getNearestDeliveryHitbox()  
    local myBase = findMyBase()  
    if not myBase then return nil end  
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
    local refPos = hrp and hrp.Position or myBase:GetPivot().Position  
  
    local nearestPos = nil  
    local minDist = math.huge  
    for _, d in pairs(myBase:GetDescendants()) do  
        if d.Name == "DeliveryHitbox" then  
            local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)  
            if pos then  
                local dist = (pos - refPos).Magnitude  
                if dist < minDist then  
                    minDist = dist  
                    nearestPos = pos  
                end  
            end  
        end  
    end  
  
    if not nearestPos then  
        for _, d in pairs(Workspace:GetDescendants()) do  
            if d.Name == "DeliveryHitbox" then  
                local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)  
                if pos then  
                    local dist = (pos - refPos).Magnitude  
                    if dist < minDist then  
                        minDist = dist  
                        nearestPos = pos  
                    end  
                end  
            end  
        end  
    end  
  
    return nearestPos  
end  
  
local function isInsideHitbox(part, pos)  
    if not part or not pos then return false end  
    local rel = part.CFrame:PointToObjectSpace(pos)  
    local s = part.Size  
    return math.abs(rel.X) <= s.X/2  
        and math.abs(rel.Y) <= s.Y/2  
        and math.abs(rel.Z) <= s.Z/2  
end  
  
RunService.Heartbeat:Connect(function()  
    if not KickAfterStealEnabled then return end  
    if not player:GetAttribute("Stealing") then return end  
  
    local myPlot = findMyBase()  
    local hitbox = myPlot and myPlot:FindFirstChild("DeliveryHitbox", true)  
    if not hitbox then return end  
  
    local char = player.Character  
    local hrp = char and char:FindFirstChild("HumanoidRootPart")  
    if hrp and isInsideHitbox(hitbox, hrp.Position) then  
        task.wait(0.2)  
        LocalPlayer:Destroy()  
    end  
end)  
  
local FFlags = {  
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000, LargeReplicatorWrite5 = true,  
    LargeReplicatorEnabled9 = true, AngularVelociryLimit = 360,  
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646, S2PhysicsSenderRate = 15000,  
    DisableDPIScale = true, MaxDataPacketPerSend = 2147483647, PhysicsSenderMaxBandwidthBps = 20000,  
    TimestepArbiterHumanoidLinearVelThreshold = 21, MaxMissedWorldStepsRemembered = -2147483648,  
    PlayerHumanoidPropertyUpdateRestrict = true, SimDefaultHumanoidTimestepMultiplier = 0,  
    StreamJobNOUVolumeLengthCap = 2147483647, DebugSendDistInSteps = -2147483648,  
    GameNetDontSendRedundantNumTimes = 1, CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,  
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,  
    LargeReplicatorSerializeRead3 = true, ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,  
    CheckPVCachedVelThresholdPercent = 10, CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,  
    GameNetDontSendRedundantDeltaPositionMillionth = 1, InterpolationFrameVelocityThresholdMillionth = 5,  
    StreamJobNOUVolumeCap = 2147483647, InterpolationFrameRotVelocityThresholdMillionth = 5,  
    CheckPVCachedRotVelThresholdPercent = 10, WorldStepMax = 30,  
    InterpolationFramePositionThresholdMillionth = 5, TimestepArbiterHumanoidTurningVelThreshold = 1,  
    SimOwnedNOUCountThresholdMillionth = 2147483647, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,  
    NextGenReplicatorEnabledWrite4 = true, TimestepArbiterOmegaThou = 1073741823, MaxAcceptableUpdateDelay = 1,  
    LargeReplicatorSerializeWrite4 = true  
}  
  
local setFFlags = function()  
    if type(setfflag) ~= "function" then return end  
    for name, value in pairs(FFlags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end  
end  
  
local ALLOWED_GEARS = {"FlyingCarpet", "Witch'sBroom", "Cupid'sWings", "Santa'sSleigh", "Waverider"}  
local MOUNT_PRIORITY = {"Flying Carpet", "FlyingCarpet", "Witch's Broom", "Witch'sBroom", "WitchBroom", "Cupid's Wings", "Cupid'sWings", "CupidWings", "Santa's Sleigh", "Santa'sSleigh", "SantaSleigh", "Waverider"}  
  
local function isAllowedGear(gearName)  
    local cleanName = gearName:lower():gsub("[%s'%_%-]", "")  
    for _, allowed in ipairs(ALLOWED_GEARS) do  
        if cleanName == allowed:lower():gsub("[%s'%_%-]", "") then return true end  
    end  
    return false  
end  
  
local function getPriorityIndex(gearName)  
    local cleanName = gearName:lower():gsub("[%s'%_%-]", "")  
    for index, priorityName in ipairs(MOUNT_PRIORITY) do  
        if cleanName == priorityName:lower():gsub("[%s'%_%-]", "") then return index end  
    end  
    return 9999  
end  
  
local function getInventoryGears()  
    local gears, added = {}, {}  
    local function scan(container)  
        if not container then return end  
        for _, item in ipairs(container:GetChildren()) do  
            if item:IsA("Tool") and isAllowedGear(item.Name) and not added[item.Name] then  
                added[item.Name] = true  
                table.insert(gears, item.Name)  
            end  
        end  
    end  
    scan(LocalPlayer:FindFirstChild("Backpack"))  
    scan(LocalPlayer.Character)  
    table.sort(gears, function(a, b)  
        local pA, pB = getPriorityIndex(a), getPriorityIndex(b)  
        return pA ~= pB and pA < pB or a < b  
    end)  
    return gears  
end  
  
local function getDefaultGearFromInventory()  
    local inventory = getInventoryGears()  
    return #inventory > 0 and inventory[1] or "Sin Gear"  
end  
  
local function findToolFlexible(container, toolName)  
    if not container or not toolName then return nil end  
    local exact = container:FindFirstChild(toolName)  
    if exact and exact:IsA("Tool") then return exact end  
    local cleanTarget = toolName:lower():gsub("[%s'%_%-]", "")  
    for _, child in ipairs(container:GetChildren()) do  
        if child:IsA("Tool") and child.Name:lower():gsub("[%s'%_%-]", "") == cleanTarget then return child end  
    end  
    return nil  
end  
  
local function EquipTargetTool(toolName)  
    local character = LocalPlayer.Character  
    if not character or not toolName then return nil end  
    local equipped = findToolFlexible(character, toolName)  
    if equipped then return equipped end  
    local toolInBackpack = findToolFlexible(LocalPlayer:FindFirstChild("Backpack"), toolName)  
    if toolInBackpack then  
        local hum = character:FindFirstChildOfClass("Humanoid")  
        if hum then hum:EquipTool(toolInBackpack) end  
        return toolInBackpack  
    end  
    return nil  
end  
  
local function EquipBestMount()  
    local chosenGear = HubConfig.selectedGear  
    if not chosenGear or chosenGear == "Auto" or chosenGear == "" then  
        chosenGear = getDefaultGearFromInventory()  
    end  
    if chosenGear and chosenGear ~= "Sin Gear" and chosenGear ~= "Auto" then  
        local equipped = EquipTargetTool(chosenGear)  
        if equipped then return equipped end  
    end  
    for _, mountName in ipairs(MOUNT_PRIORITY) do  
        local equipped = EquipTargetTool(mountName)  
        if equipped then return equipped end  
    end  
    return nil  
end  
  
local function SSEquipGrapple() EquipBestMount() end  
  
local walkTo = function(hrp, targetCords, desiredSpeed, precisionThreshold, noGear)  
    if not hrp or not hrp.Parent or not targetCords then return end  
    desiredSpeed = desiredSpeed or 180  
    local running = true  
    local connection  
    local threshold = precisionThreshold or 3  
  
    local _ctrls  
    pcall(function() _ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)  
    if _ctrls then pcall(function() _ctrls:Disable() end) end  
  
    connection = RunService.Heartbeat:Connect(function()  
        if not hrp or not hrp.Parent or not running then  
            if connection then connection:Disconnect() end  
            return  
        end  
        local currentPos  = hrp.Position  
        local flatCurrent = Vector3.new(currentPos.X, targetCords.Y, currentPos.Z)  
        local direction   = targetCords - flatCurrent  
        local distance    = direction.Magnitude  
        if distance <= threshold then  
            running = false  
            connection:Disconnect()  
            hrp.Velocity = Vector3.zero  
            return  
        end  
        if not noGear then EquipBestMount() end  
        local vel = direction.Unit * desiredSpeed  
        hrp.Velocity = Vector3.new(vel.X, hrp.Velocity.Y, vel.Z)  
    end)  
  
    local startT = tick()  
    while running do  
        if tick() - startT > 6 then break end  
        task.wait()  
    end  
  
    if _ctrls then pcall(function() _ctrls:Enable() end) end  
end  
  
local canDirectTp = function(HRP, targetPos)  
    if not HRP or not targetPos then return false end  
    local origin = HRP.Position  
    local ignored = { player.Character }  
    for _ = 1, 12 do  
        local direction = targetPos - origin  
        if direction.Magnitude <= 0.05 then return true end  
        local params = RaycastParams.new()  
        params.FilterType = Enum.RaycastFilterType.Blacklist  
        params.FilterDescendantsInstances = ignored  
        params.IgnoreWater = true  
        local result = Workspace:Raycast(origin, direction, params)  
        if not result then return true end  
        local hit = result.Instance  
        if not hit then return true end  
        if hit:IsA("BasePart") and not hit.CanCollide then  
            table.insert(ignored, hit)  
            origin = result.Position + direction.Unit * 0.1  
        else  
            return (result.Position - targetPos).Magnitude <= 3  
        end  
    end  
    return false  
end  
  
local function ExecuteAutoPotion()  
    if PotionEnabled or APOnStealEnabled then  
        local potion = player.Backpack:FindFirstChild("Giant Potion") or player.Character:FindFirstChild("Giant Potion")  
        if potion then  
            player.Character.Humanoid:EquipTool(potion)  
            potion:Activate()  
        end  
    end  
    if APOnStealEnabled then task.spawn(doSpam) end  
end  
  
local __stealCbCache_v2 = setmetatable({}, { __mode = "k" })  
local __buildStealCallbacks_v2 = function(prompt)  
    if type(getconnections) ~= "function" then return nil end  
    if __stealCbCache_v2[prompt] then return __stealCbCache_v2[prompt] end  
    local data = { hold = {}, trigger = {} }  
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)  
    if ok1 then for _, c in ipairs(c1) do if type(c.Function) == "function" then table.insert(data.hold, c.Function) end end end  
    local ok2, c2 = pcall(getconnections, prompt.Triggered)  
    if ok2 then for _, c in ipairs(c2) do if type(c.Function) == "function" then table.insert(data.trigger, c.Function) end end end  
    if #data.hold == 0 and #data.trigger == 0 then return nil end  
    __stealCbCache_v2[prompt] = data  
    return data  
end  
  
local __FH_v2 = {}  
function __FH_v2.startStealHold(prompt)  
    if not prompt or not prompt.Parent then return nil end  
    local cb = __buildStealCallbacks_v2(prompt)  
    if not cb then return nil end  
    for _, fn in ipairs(cb.hold) do task.spawn(fn) end  
    local now = tick()  
    return { prompt = prompt, cb = cb, ragdollFireTime = now, startedAt = now, holdBeganAt = now, holdDone = true }  
end  
  
function __FH_v2.doHoldAndWait(ctx)  
    if ctx.holdDone then return end  
    for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end  
    ctx.holdBeganAt = tick()  
    task.wait(1.3)  
    ctx.holdDone = true  
end  
  
function __FH_v2.waitForStealTime(ctx, sec)  
    if not ctx or sec >= 1.0 then return end  
    local elapsed = tick() - ctx.ragdollFireTime  
    if elapsed < sec then task.wait(sec - elapsed) end  
end  
  
function __FH_v2.finishStealHold(ctx)  
    if not ctx then return false end  
    if not ctx.holdBeganAt then __FH_v2.doHoldAndWait(ctx) end  
    local heldFor = tick() - (ctx.holdBeganAt or tick())  
    if heldFor < 1.3 then task.wait(1.3 - heldFor) end  
    task.wait(0.02)  
    for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end  
    return true  
end  
  
local BASES = {  
    b1 = { refVec = Vector3.new(-337, -5, 100), finalPos = Vector3.new(-337, -5, 103) },  
    b2 = { refVec = Vector3.new(-335, -5, 20),  finalPos = Vector3.new(-334.80, -5.04, 18.90) },  
}  
  
local SLOT2_CONFIG = {  
    podSlots = {"2", "9"},  
    b1 = {  
        waypoints = {  
            Vector3.new(-352.91488647460938, -6.43282604217529, 6.73166227340698),  
            Vector3.new(-352.96304321289062, -6.43282604217529, 113.64471435546875),  
            Vector3.new(-326.07409667968750, -4.37325382232666, 101.64852142333984)  
        },  
        greenPos = Vector3.new(-352.76815795898438, -6.52218532562256, 91.01644897460938)  
    },  
    b2 = {  
        waypoints = {  
            Vector3.new(-352.76190185546875, -6.38282585144043, 114.06043243408203),  
            Vector3.new(-351.15, -7.03, 28.59),  
            Vector3.new(-323.26, -4.82, 19.17),  
        },  
        greenPos = Vector3.new(-352.15, -7.03, 28.59)  
    }  
}  
  
local SLOT3_CONFIG = {  
    podSlots = {"3", "8"},  
    b1 = {  
        waypoints = {  
            Vector3.new(-352.56066894531250, -6.35303878784180, 6.43713855743408),  
            Vector3.new(-352.50909423828125, -6.35303878784180, 113.92613220214844),  
            Vector3.new(-319.34481811523438, -4.62325286865234, 99.20803833007812)  
        },  
        greenPos = Vector3.new(-345.00000000000000, -6.52218532562256, 92.00000000000000)  
    },  
    b2 = {  
        waypoints = {  
            Vector3.new(-352.76190185546875, -6.38282585144043, 114.06043243408203),  
            Vector3.new(-352.72647094726562, -6.38282585144043, 6.30276632308960),  
            Vector3.new(-319.81491088867188, -4.62326812744141, 20.98493385314941)  
        },  
        greenPos = Vector3.new(-344.00000000000000, -6.52218532562256, 28.99999809265137)  
    }  
}  
  
local SLOT4_CONFIG = {  
    podSlots = {"4", "7"},  
    b1 = {  
        waypoints = {  
            Vector3.new(-352.70251464843750, -6.38282585144043, 6.47146701812744),  
            Vector3.new(-352.59869384765625, -6.35303878784180, 113.35536193847656),  
            Vector3.new(-311.25457763671875, -4.57325363159180, 98.98431396484375)  
        },  
        greenPos = Vector3.new(-337.58319091796875, -4.42325305938721, 91.88890838623047)  
    },  
    b2 = {  
        waypoints = {  
            Vector3.new(-352.76190185546875, -6.38282585144043, 114.06043243408203),  
            Vector3.new(-352.75134277343750, -6.38282585144043, 6.15367889404297),  
            Vector3.new(-312.58615112304688, -4.62325191497803, 20.83353233337402)  
        },  
        greenPos = Vector3.new(-336.70001220703125, -4.62325286865234, 28.20000076293945)  
    }  
}  
  
local SLOT5_CONFIG = {  
    podSlots = {"5", "6"},  
    b1 = {  
        waypoints = {  
            Vector3.new(-352.76190185546875, -6.74361085891724, 7.06043243408203),  
            Vector3.new(-352.76318359375000, -6.74361085891724, 114.06423950195312),  
            Vector3.new(-303.58605957031250, -4.78403806686401, 102.00155639648438)  
        },  
        greenPos = Vector3.new(-331.29998779296875, -4.58403825759888, 93.19999694824219)  
    },  
    b2 = {  
        waypoints = {  
            Vector3.new(-352.76181030273438, -6.74361085891724, 114.06042480468750),  
            Vector3.new(-352.76318359375000, -6.74361085891724, 7.06260776519775),  
            Vector3.new(-303.48703002929688, -4.83403825759888, 17.91749191284180)  
        },  
        greenPos = Vector3.new(-330.39999389648438, -4.53403806686401, 26.60000038146973)  
    }  
}  
  
local HalfwaySteal = { debounce = false, _semiStealCtx = nil }  
  
function HalfwaySteal.setSlot(slot)  
    if slot >= 1 and slot <= 5 then  
        selectedSlot = slot  
        HubConfig.selectedSlot = slot  
        saveHubConfig()  
    end  
end  
  
function HalfwaySteal.SSDoTeleport()  
    local char = player.Character  
    local hum = char and char:FindFirstChild("Humanoid")  
    local hrp = char and char:FindFirstChild("HumanoidRootPart")  
    if not hum or not hrp then return end  
  
    setFFlags()  
    SSEquipGrapple()  
  
    local plots = Workspace:FindFirstChild("Plots")  
    if not plots then return end  
  
    if selectedSlot == 1 then  
        local myName = player.DisplayName  
        local enemyPlots = {}  
        for _, plot in ipairs(plots:GetChildren()) do  
            local sign = plot:FindFirstChild("PlotSign")  
            local label = sign and sign:FindFirstChild("SurfaceGui")  
                and sign.SurfaceGui:FindFirstChild("Frame")  
                and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")  
            if label and label.Text ~= "Empty Base" then  
                local owner = label.Text:gsub("'s Base$",""):gsub("'s base$",""):gsub("%s+$","")  
                if owner ~= myName then table.insert(enemyPlots, plot) end  
            end  
        end  
  
        local function getClosestPodium()  
            if #enemyPlots == 0 then return nil end  
            local best, bestDist = nil, math.huge  
            for _, plot in ipairs(enemyPlots) do  
                local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end  
                local plotPos  
                pcall(function()  
                    if plot.PrimaryPart then plotPos = plot.PrimaryPart.Position  
                    else plotPos = plot:GetPivot().Position end  
                end)  
                if not plotPos then  
                    local part = plot:FindFirstChildWhichIsA("BasePart", true)  
                    if part then plotPos = part.Position end  
                end  
                local plotIsBase1 = true  
                if plotPos then  
                    local d1 = (plotPos - BASES.b1.refVec).Magnitude  
                    local d2 = (plotPos - BASES.b2.refVec).Magnitude  
                    plotIsBase1 = d1 < d2  
                end  
                for _, pname in ipairs({ "1", "10" }) do  
                    local podium = podiums:FindFirstChild(pname); if not podium then continue end  
                    local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main"); if not cm then continue end  
                    local d = (hrp.Position - cm.Position).Magnitude  
                    if d < bestDist then  
                        bestDist = d  
                        local spawn = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")  
                        local pa = spawn and spawn:FindFirstChild("PromptAttachment")  
                        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")  
                        if prompt then  
                            best = { plot = plot, podiumName = pname, position = cm.Position, prompt = prompt,  
                                promptPos = pa.WorldPosition, distance = d, isEnemyBase1 = plotIsBase1 }  
                        end  
                    end  
                end  
            end  
            return best  
        end  
  
        local podium = getClosestPodium()  
        if not podium then return end  
  
        local function doTpSequence(HRP, pod)  
            local isAtBase1  
            do  
                local dB1 = (pod.position - BASES.b1.refVec).Magnitude  
                local dB2 = (pod.position - BASES.b2.refVec).Magnitude  
                isAtBase1 = dB1 < dB2  
            end  
  
            local approachWaypoints = isAtBase1 and  
                {  
                    Vector3.new(-352.51531982421875, -6.35303878784180, 6.89183282852173),  
                    Vector3.new(-353.11746215820312, -6.46261215209961, 113.28694152832031),  
                    Vector3.new(-333.95788574218750, -4.62324523925781, 100.70635986328125)  
                } or  
                {  
                    Vector3.new(-352.7619, -6.3828, 114.0604),  
                    Vector3.new(-351.49, -6.38, 7.00),  
                    Vector3.new(-334.80, -5.04, 18.90)  
                }  
  
            local function doApproachPath(HRP_)  
                local startIndex = 1  
                for i = #approachWaypoints, 1, -1 do  
                    if canDirectTp(HRP_, approachWaypoints[i]) then startIndex = i; break end  
                end  
                for i = startIndex, #approachWaypoints do  
                    walkTo(HRP_, approachWaypoints[i], 180)  
                end  
            end  
  
            local ctx = nil  
            if pod and pod.prompt and pod.prompt.Parent then  
                pod.prompt.RequiresLineOfSight = false  
                pod.prompt.MaxActivationDistance = math.huge  
                if type(getconnections) == "function" then  
                    ctx = __FH_v2.startStealHold(pod.prompt)  
                else  
                    task.spawn(function()  
                        if fireproximityprompt then fireproximityprompt(pod.prompt) end  
                    end)  
                end  
            end  
  
            if ctx then __FH_v2.waitForStealTime(ctx, 0.8) end  
            doApproachPath(HRP)  
            task.wait(0.25)  
  
            ExecuteAutoPotion()  
            SSEquipGrapple()  
  
            if pod and pod.prompt and pod.prompt.Parent then  
                local greenPos = isAtBase1 and Vector3.new(-349.87167358398438, -6.52218532562256, 82.97105407714844) or Vector3.new(-349.42999267578125, -6.52218627929688, 37.47000122070312)  
                if greenPos then  
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end  
                    HRP.CFrame = CFrame.new(greenPos)  
                end  
                if ctx then __FH_v2.finishStealHold(ctx) end  
            end  
  
            if AutoWalkEnabled then  
                detectStealAndWait()  
                local targetHitbox = getNearestDeliveryHitbox()  
                if targetHitbox then  
                    local prevSpeedState = _G.speedBoostEnabled  
                    _G.speedBoostEnabled = false  
                    local speedVal = PotionEnabled and 33.5 or 28  
                    pcall(function()  
                        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")  
                        if h then h:UnequipTools() end  
                    end)  
                    walkTo(HRP, targetHitbox, speedVal, 3, true)  
                    _G.speedBoostEnabled = prevSpeedState  
                end  
            end  
        end  
  
        task.spawn(function()  
            pcall(function() doTpSequence(hrp, podium) end)  
        end)  
        return  
    end  
  
    if selectedSlot == 2 then  
        local enemyPlots = {}  
        for _, plot in ipairs(plots:GetChildren()) do  
            if isEnemyPlot(plot) then table.insert(enemyPlots, plot) end  
        end  
        if #enemyPlots == 0 then return end  
  
        local function getClosestPodium()  
            local best, bestDist = nil, math.huge  
            for _, plot in ipairs(enemyPlots) do  
                local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end  
                local plotPos = nil  
                pcall(function()  
                    if plot.PrimaryPart then plotPos = plot.PrimaryPart.Position  
                    else plotPos = plot:GetPivot().Position end  
                end)  
                if not plotPos then  
                    local part = plot:FindFirstChildWhichIsA("BasePart", true)  
                    if part then plotPos = part.Position end  
                end  
  
                local plotIsBase1 = true  
                if plotPos then  
                    local d1 = (plotPos - BASES.b1.refVec).Magnitude  
                    local d2 = (plotPos - BASES.b2.refVec).Magnitude  
                    plotIsBase1 = d1 < d2  
                end  
  
                for _, pname in ipairs(SLOT2_CONFIG.podSlots) do  
                    local podium = podiums:FindFirstChild(pname); if not podium then continue end  
                    local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main"); if not cm then continue end  
                    local d = (hrp.Position - cm.Position).Magnitude  
                    if d < bestDist then  
                        bestDist = d  
                        local spawn = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")  
                        local pa = spawn and spawn:FindFirstChild("PromptAttachment")  
                        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")  
                        if prompt then  
                            best = { plot = plot, podiumName = pname, position = cm.Position, prompt = prompt, distance = d, isEnemyBase1 = plotIsBase1 }  
                        end  
                    end  
                end  
            end  
            return best  
        end  
  
        local podium = getClosestPodium()  
        if not podium then return end  
  
        local function doTpSequence(HRP, pod)  
            local config = pod.isEnemyBase1 and SLOT2_CONFIG.b1 or SLOT2_CONFIG.b2  
            local greenPos = config.greenPos  
            local waypoints = config.waypoints  
  
            local function doApproachPath(HRP_)  
                local startIndex = 1  
                for i = #waypoints, 1, -1 do  
                    if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end  
                end  
                for i = startIndex, #waypoints do  
                    walkTo(HRP_, waypoints[i], 180)  
                end  
            end  
  
            local ctx = nil  
            if pod and pod.prompt and pod.prompt.Parent then  
                pod.prompt.RequiresLineOfSight = false  
                pod.prompt.MaxActivationDistance = math.huge  
                if type(getconnections) == "function" then  
                    ctx = __FH_v2.startStealHold(pod.prompt)  
                else  
                    task.spawn(function()  
                        if fireproximityprompt then fireproximityprompt(pod.prompt) end  
                    end)  
                end  
            end  
  
            if ctx then __FH_v2.waitForStealTime(ctx, 0.8) end  
            doApproachPath(HRP)  
            task.wait(0.25)  
  
            ExecuteAutoPotion()  
            SSEquipGrapple()  
  
            if pod and pod.prompt and pod.prompt.Parent then  
                if greenPos then  
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end  
                    HRP.CFrame = CFrame.new(greenPos)  
                end  
                if ctx then __FH_v2.finishStealHold(ctx) end  
            end  
  
            if AutoWalkEnabled then  
                detectStealAndWait()  
                local targetHitbox = getNearestDeliveryHitbox()  
                if targetHitbox then  
                    local prevSpeedState = _G.speedBoostEnabled  
                    _G.speedBoostEnabled = false  
                    local speedVal = PotionEnabled and 33.5 or 28  
                    pcall(function()  
                        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")  
                        if h then h:UnequipTools() end  
                    end)  
                    walkTo(HRP, targetHitbox, speedVal, 3, true)  
                    _G.speedBoostEnabled = prevSpeedState  
                end  
            end  
        end  
  
        task.spawn(function()  
            pcall(function() doTpSequence(hrp, podium) end)  
        end)  
        return  
    end  
  
    if selectedSlot == 3 then  
        local enemyPlots = {}  
        for _, plot in ipairs(plots:GetChildren()) do  
            if isEnemyPlot(plot) then table.insert(enemyPlots, plot) end  
        end  
        if #enemyPlots == 0 then return end  
  
        local function getClosestPodium()  
            local best, bestDist = nil, math.huge  
            for _, plot in ipairs(enemyPlots) do  
                local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end  
                local plotPos = nil  
                pcall(function()  
                    if plot.PrimaryPart then plotPos = plot.PrimaryPart.Position  
                    else plotPos = plot:GetPivot().Position end  
                end)  
                if not plotPos then  
                    local part = plot:FindFirstChildWhichIsA("BasePart", true)  
                    if part then plotPos = part.Position end  
                end  
  
                local plotIsBase1 = true  
                if plotPos then  
                    local d1 = (plotPos - BASES.b1.refVec).Magnitude  
                    local d2 = (plotPos - BASES.b2.refVec).Magnitude  
                    plotIsBase1 = d1 < d2  
                end  
  
                for _, pname in ipairs(SLOT3_CONFIG.podSlots) do  
                    local podium = podiums:FindFirstChild(pname); if not podium then continue end  
                    local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main"); if not cm then continue end  
                    local d = (hrp.Position - cm.Position).Magnitude  
                    if d < bestDist then  
                        bestDist = d  
                        local spawn = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")  
                        local pa = spawn and spawn:FindFirstChild("PromptAttachment")  
                        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")  
                        if prompt then  
                            best = { plot = plot, podiumName = pname, position = cm.Position, prompt = prompt, distance = d, isEnemyBase1 = plotIsBase1 }  
                        end  
                    end  
                end  
            end  
            return best  
        end  
  
        local podium = getClosestPodium()  
        if not podium then return end  
  
        local function doTpSequence(HRP, pod)  
            local config = pod.isEnemyBase1 and SLOT3_CONFIG.b1 or SLOT3_CONFIG.b2  
            local greenPos = config.greenPos  
            local waypoints = config.waypoints  
  
            local function doApproachPath(HRP_)  
                local startIndex = 1  
                for i = #waypoints, 1, -1 do  
                    if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end  
                end  
                for i = startIndex, #waypoints do  
                    walkTo(HRP_, waypoints[i], 180)  
                end  
            end  
  
            local ctx = nil  
            if pod and pod.prompt and pod.prompt.Parent then  
                pod.prompt.RequiresLineOfSight = false  
                pod.prompt.MaxActivationDistance = math.huge  
                if type(getconnections) == "function" then  
                    ctx = __FH_v2.startStealHold(pod.prompt)  
                else  
                    task.spawn(function()  
                        if fireproximityprompt then fireproximityprompt(pod.prompt) end  
                    end)  
                end  
            end  
  
            if ctx then __FH_v2.waitForStealTime(ctx, 0.8) end  
            doApproachPath(HRP)  
            task.wait(0.25)  
  
            ExecuteAutoPotion()  
            SSEquipGrapple()  
  
            if pod and pod.prompt and pod.prompt.Parent then  
                if greenPos then  
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end  
                    HRP.CFrame = CFrame.new(greenPos)  
                end  
                if ctx then __FH_v2.finishStealHold(ctx) end  
            end  
  
            if AutoWalkEnabled then  
                detectStealAndWait()  
                local targetHitbox = getNearestDeliveryHitbox()  
                if targetHitbox then  
                    local prevSpeedState = _G.speedBoostEnabled  
                    _G.speedBoostEnabled = false  
                    local speedVal = PotionEnabled and 33.5 or 28  
                    pcall(function()  
                        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")  
                        if h then h:UnequipTools() end  
                    end)  
                    walkTo(HRP, targetHitbox, speedVal, 3, true)  
                    _G.speedBoostEnabled = prevSpeedState  
                end  
            end  
        end  
  
        task.spawn(function()  
            pcall(function() doTpSequence(hrp, podium) end)  
        end)  
        return  
    end  
  
    if selectedSlot == 4 then  
        local enemyPlots = {}  
        for _, plot in ipairs(plots:GetChildren()) do  
            if isEnemyPlot(plot) then table.insert(enemyPlots, plot) end  
        end  
        if #enemyPlots == 0 then return end  
  
        local function getClosestPodium()  
            local best, bestDist = nil, math.huge  
            for _, plot in ipairs(enemyPlots) do  
                local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end  
                local plotPos = nil  
                pcall(function()  
                    if plot.PrimaryPart then plotPos = plot.PrimaryPart.Position  
                    else plotPos = plot:GetPivot().Position end  
                end)  
                if not plotPos then  
                    local part = plot:FindFirstChildWhichIsA("BasePart", true)  
                    if part then plotPos = part.Position end  
                end  
  
                local plotIsBase1 = true  
                if plotPos then  
                    local d1 = (plotPos - BASES.b1.refVec).Magnitude  
                    local d2 = (plotPos - BASES.b2.refVec).Magnitude  
                    plotIsBase1 = d1 < d2  
                end  
  
                for _, pname in ipairs(SLOT4_CONFIG.podSlots) do  
                    local podium = podiums:FindFirstChild(pname); if not podium then continue end  
                    local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main"); if not cm then continue end  
                    local d = (hrp.Position - cm.Position).Magnitude  
                    if d < bestDist then  
                        bestDist = d  
                        local spawn = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")  
                        local pa = spawn and spawn:FindFirstChild("PromptAttachment")  
                        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")  
                        if prompt then  
                            best = { plot = plot, podiumName = pname, position = cm.Position, prompt = prompt, distance = d, isEnemyBase1 = plotIsBase1 }  
                        end  
                    end  
                end  
            end  
            return best  
        end  
  
        local podium = getClosestPodium()  
        if not podium then return end  
  
        local function doTpSequence(HRP, pod)  
            local config = pod.isEnemyBase1 and SLOT4_CONFIG.b1 or SLOT4_CONFIG.b2  
            local greenPos = config.greenPos  
            local waypoints = config.waypoints  
  
            local function doApproachPath(HRP_)  
                local startIndex = 1  
                for i = #waypoints, 1, -1 do  
                    if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end  
                end  
                for i = startIndex, #waypoints do  
                    walkTo(HRP_, waypoints[i], 180)  
                end  
            end  
  
            local ctx = nil  
            if pod and pod.prompt and pod.prompt.Parent then  
                pod.prompt.RequiresLineOfSight = false  
                pod.prompt.MaxActivationDistance = math.huge  
                if type(getconnections) == "function" then  
                    ctx = __FH_v2.startStealHold(pod.prompt)  
                else  
                    task.spawn(function()  
                        if fireproximityprompt then fireproximityprompt(pod.prompt) end  
                    end)  
                end  
            end  
  
            if ctx then __FH_v2.waitForStealTime(ctx, 0.8) end  
            doApproachPath(HRP)  
            task.wait(0.25)  
  
            ExecuteAutoPotion()  
            SSEquipGrapple()  
  
            if pod and pod.prompt and pod.prompt.Parent then  
                if greenPos then  
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end  
                    HRP.CFrame = CFrame.new(greenPos)  
                end  
                if ctx then __FH_v2.finishStealHold(ctx) end  
            end  
  
            if AutoWalkEnabled then  
                detectStealAndWait()  
                local targetHitbox = getNearestDeliveryHitbox()  
                if targetHitbox then  
                    local prevSpeedState = _G.speedBoostEnabled  
                    _G.speedBoostEnabled = false  
                    local speedVal = PotionEnabled and 33.5 or 28  
                    pcall(function()  
                        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")  
                        if h then h:UnequipTools() end  
                    end)  
                    local midPos = pod.isEnemyBase1  
                        and Vector3.new(-346.51281738281250, -6.52218532562256, 94.05587768554688)  
                        or Vector3.new(-345.94778442382812, -6.52218532562256, 26.71775436401367)  
                    walkTo(HRP, midPos, speedVal, 3, true)  
                    walkTo(HRP, targetHitbox, speedVal, 3, true)  
                    _G.speedBoostEnabled = prevSpeedState  
                end  
            end  
        end  
  
        task.spawn(function()  
            pcall(function() doTpSequence(hrp, podium) end)  
        end)  
        return  
    end  
  
    if selectedSlot == 5 then  
        local enemyPlots = {}  
        for _, plot in ipairs(plots:GetChildren()) do  
            if isEnemyPlot(plot) then table.insert(enemyPlots, plot) end  
        end  
        if #enemyPlots == 0 then return end  
  
        local function getClosestPodium()  
            local best, bestDist = nil, math.huge  
            for _, plot in ipairs(enemyPlots) do  
                local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end  
                local plotPos = nil  
                pcall(function()  
                    if plot.PrimaryPart then plotPos = plot.PrimaryPart.Position  
                    else plotPos = plot:GetPivot().Position end  
                end)  
                if not plotPos then  
                    local part = plot:FindFirstChildWhichIsA("BasePart", true)  
                    if part then plotPos = part.Position end  
                end  
  
                local plotIsBase1 = true  
                if plotPos then  
                    local d1 = (plotPos - BASES.b1.refVec).Magnitude  
                    local d2 = (plotPos - BASES.b2.refVec).Magnitude  
                    plotIsBase1 = d1 < d2  
                end  
  
                for _, pname in ipairs(SLOT5_CONFIG.podSlots) do  
                    local podium = podiums:FindFirstChild(pname); if not podium then continue end  
                    local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main"); if not cm then continue end  
                    local d = (hrp.Position - cm.Position).Magnitude  
                    if d < bestDist then  
                        bestDist = d  
                        local spawn = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")  
                        local pa = spawn and spawn:FindFirstChild("PromptAttachment")  
                        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")  
                        if prompt then  
                            best = { plot = plot, podiumName = pname, position = cm.Position, prompt = prompt, distance = d, isEnemyBase1 = plotIsBase1 }  
                        end  
                    end  
                end  
            end  
            return best  
        end  
  
        local podium = getClosestPodium()  
        if not podium then return end  
  
        local function doTpSequence(HRP, pod)  
            local config = pod.isEnemyBase1 and SLOT5_CONFIG.b1 or SLOT5_CONFIG.b2  
            local greenPos = config.greenPos  
            local waypoints = config.waypoints  
  
            local function doApproachPath(HRP_)  
                local startIndex = 1  
                for i = #waypoints, 1, -1 do  
                    if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end  
                end  
                for i = startIndex, #waypoints do  
                    walkTo(HRP_, waypoints[i], 180)  
                end  
            end  
  
            local ctx = nil  
            if pod and pod.prompt and pod.prompt.Parent then  
                pod.prompt.RequiresLineOfSight = false  
                pod.prompt.MaxActivationDistance = math.huge  
                if type(getconnections) == "function" then  
                    ctx = __FH_v2.startStealHold(pod.prompt)  
                else  
                    task.spawn(function()  
                        if fireproximityprompt then fireproximityprompt(pod.prompt) end  
                    end)  
                end  
            end  
  
            if ctx then __FH_v2.waitForStealTime(ctx, 0.8) end  
            doApproachPath(HRP)  
            task.wait(0.25)  
  
            ExecuteAutoPotion()  
            SSEquipGrapple()  
  
            if pod and pod.prompt and pod.prompt.Parent then  
                if greenPos then  
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end  
                    HRP.CFrame = CFrame.new(greenPos)  
                end  
                if ctx then __FH_v2.finishStealHold(ctx) end  
            end  
  
            if AutoWalkEnabled then  
                detectStealAndWait()  
                local targetHitbox = getNearestDeliveryHitbox()  
                if targetHitbox then  
                    local prevSpeedState = _G.speedBoostEnabled  
                    _G.speedBoostEnabled = false  
                    local speedVal = PotionEnabled and 33.5 or 28  
                    pcall(function()  
                        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")  
                        if h then h:UnequipTools() end  
                    end)  
                    local midPos = pod.isEnemyBase1  
                        and Vector3.new(-346.51281738281250, -6.52218532562256, 94.05587768554688)  
                        or Vector3.new(-345.94778442382812, -6.52218532562256, 26.71775436401367)  
                    walkTo(HRP, midPos, speedVal, 3, true)  
                    walkTo(HRP, targetHitbox, speedVal, 3, true)  
                    _G.speedBoostEnabled = prevSpeedState  
                end  
            end  
        end  
  
        task.spawn(function()  
            pcall(function() doTpSequence(hrp, podium) end)  
        end)  
    end  
end  
  
local TeleportBtn = nil  
  
function HalfwaySteal.execute()  
    if player:GetAttribute("Stealing") or HalfwaySteal.debounce then return end  
    HalfwaySteal.debounce = true  
  
    task.spawn(function()  
        local startT = tick()  
        while tick() - startT < STEAL_DURATION do  
            local p = math.clamp((tick() - startT) / STEAL_DURATION, 0, 1)  
            updateProgressBar(p); task.wait()  
        end  
        updateProgressBar(1); task.wait(0.3); updateProgressBar(0)  
    end)  
  
    task.spawn(function()  
        setFFlags()  
        HalfwaySteal.SSDoTeleport()  
        task.wait(0.1)  
        HalfwaySteal.debounce = false  
    end)  
end  
  
local function checkEnemyBaseOpen()  
    local plots = Workspace:FindFirstChild("Plots")  
    if not plots then return false end  
  
    for _, desc in ipairs(Workspace:GetDescendants()) do  
        if desc:IsA("ProximityPrompt") and string.find(desc.ObjectText, "Disallow") then  
            local part = desc.Parent:IsA("BasePart") and desc.Parent or desc.Parent:FindFirstChildWhichIsA("BasePart", true)  
            if part then  
                for _, plot in ipairs(plots:GetChildren()) do  
                    if plot:IsA("Model") and part:IsDescendantOf(plot) and isEnemyPlot(plot) then  
                        return true  
                    end  
                end  
            end  
        end  
    end  
    return false  
end  
  
local hasAutoTPTriggered = false  
task.spawn(function()  
    while task.wait(0.5) do  
        local isBaseOpen = checkEnemyBaseOpen()  
        if isBaseOpen then  
            if AutoTPOnAllowEnabled and not hasAutoTPTriggered and not HalfwaySteal.debounce and not player:GetAttribute("Stealing") then  
                hasAutoTPTriggered = true  
                HalfwaySteal.execute()  
            end  
        else  
            hasAutoTPTriggered = false  
        end  
    end  
end)  
  
do  
    local _RunService = RunService  
    local LP          = player  
  
    _G.__fableResetBusy = false  
  
    _G.FableInstaReset = function()  
        local _now = os.clock()  
        if _G.__fableResetBusy  
            and (_now - (tonumber(_G.__fableResetAt) or 0))  
                < (tonumber(_G.FableResetCooldown) or 2.5) then  
            return  
        end  
        _G.__fableResetBusy = true  
        _G.__fableResetAt   = _now  
  
        task.spawn(function()  
            local _prevAntiDie = _G.AntiDieDisabled  
            _G.AntiDieDisabled = true  
            _G.FableStealHold  = false  
  
            local _restored, _holding = false, true  
            local function _restore()  
                if _restored then return end  
                _restored = true  
                _holding  = false  
                _G.AntiDieDisabled  = _prevAntiDie  
                _G.__fableResetBusy = false  
            end  
  
            local _conn  
            _conn = LP.CharacterAdded:Connect(function(newChar)  
                if _conn then _conn:Disconnect(); _conn = nil end  
                task.defer(function()  
                    pcall(function() newChar:WaitForChild("Humanoid", 12) end)  
                    _RunService.Heartbeat:Wait()  
                    _restore()  
                end)  
            end)  
            task.delay(8, function()  
                if _conn then _conn:Disconnect(); _conn = nil end  
                _restore()  
            end)  
  
            pcall(function()  
                local char = LP.Character  
                if not char then return end  
  
                local _origChar = char  
  
                local bp = LP:FindFirstChild("Backpack")  
                if bp then  
                    local hum = char:FindFirstChildOfClass("Humanoid")  
                    if hum then pcall(function() hum:UnequipTools() end) end  
                    for _, ch in ipairs(char:GetChildren()) do  
                        if ch:IsA("Tool") then  
                            pcall(function() ch.Parent = bp end)  
                        end  
                    end  
                end  
  
                local function _flingPart()  
                    local c = LP.Character  
                    if not c then return nil end  
                    return c:FindFirstChild("UpperTorso")  
                        or c:FindFirstChild("Torso")  
                        or c:FindFirstChild("HumanoidRootPart")  
                end  
  
                local _t0 = os.clock()  
                while os.clock() - _t0  
                    < (tonumber(_G.FableResetFlingTime) or 5) do  
                    if LP.Character ~= _origChar then break end  
                    local _h = _origChar:FindFirstChildOfClass("Humanoid")  
                    if not _h or _h.Health <= 0  
                        or _h:GetState() == Enum.HumanoidStateType.Dead then  
                        break  
                    end  
                    local part = _flingPart()  
                    if not part then break end  
  
                    pcall(function()  
                        for _, o in ipairs(part:GetChildren()) do  
                            if o:IsA("BodyPosition") or o:IsA("BodyVelocity")  
                                or o:IsA("BodyGyro") or o:IsA("AlignPosition")  
                                or o:IsA("LinearVelocity") then  
                                o:Destroy()  
                            end  
                        end  
                    end)  
  
                    pcall(function()  
                        part.Velocity = Vector3.new(0, 9999999, 0)  
                    end)  
                    _RunService.Heartbeat:Wait()  
                end  
            end)  
        end)  
    end  
end  
  
function HalfwaySteal.activate()  
    task.spawn(function()  
        setFFlags()  
        _G.FableInstaReset()  
    end)  
end  
  
local AllowDisallowGui = Instance.new("ScreenGui")  
AllowDisallowGui.Name = "AllowDisallow"  
AllowDisallowGui.ResetOnSpawn = false  
AllowDisallowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global  
AllowDisallowGui.Parent = safeGuiTarget  
  
local function ApplyFastEffects(parentFrame)  
    local uiStroke = Instance.new("UIStroke")  
    uiStroke.Thickness = 1.2  
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border  
    uiStroke.Color = COLOR_BORDER  
    uiStroke.Parent = parentFrame  
  
    local grad = Instance.new("UIGradient")  
    grad.Color = ColorSequence.new{  
        ColorSequenceKeypoint.new(0, COLOR_ACCENT),  
        ColorSequenceKeypoint.new(1, COLOR_BORDER)  
    }  
    grad.Parent = uiStroke  
  
    RunService.RenderStepped:Connect(function(deltaTime)  
        if uiStroke and uiStroke.Parent then  
            grad.Rotation = grad.Rotation + (500 * deltaTime)  
        end  
    end)  
end  
  
local MainAllowBtn = Instance.new("TextButton")  
MainAllowBtn.Size = UDim2.new(0, 84, 0, 48)  
MainAllowBtn.Position = UDim2.new(0.65, 36, 0, 15)  
MainAllowBtn.BackgroundColor3 = COLOR_BG_DARK  
MainAllowBtn.BackgroundTransparency = 0.2  
MainAllowBtn.Text = "WAITING"  
MainAllowBtn.TextColor3 = COLOR_TEXT_LIGHT  
MainAllowBtn.Font = Enum.Font.GothamBold  
MainAllowBtn.TextSize = 10  
MainAllowBtn.Parent = AllowDisallowGui  
createUICorner(MainAllowBtn, 8)  
ApplyFastEffects(MainAllowBtn)  
  
local draggingAllow, dragStartAllow, startPosAllow, dragIdAllow  
MainAllowBtn.InputBegan:Connect(function(input)  
    if not draggingAllow and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then  
        draggingAllow = true  
        dragIdAllow = input  
        dragStartAllow = input.Position  
        startPosAllow = MainAllowBtn.Position  
        input.Changed:Connect(function()  
            if input.UserInputState == Enum.UserInputState.End then  
                draggingAllow = false  
                dragIdAllow = nil  
            end  
        end)  
    end  
end)  
  
UserInputService.InputChanged:Connect(function(input)  
    if draggingAllow and input == dragIdAllow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
        local delta = input.Position - dragStartAllow  
        MainAllowBtn.Position = UDim2.new(startPosAllow.X.Scale, startPosAllow.X.Offset + delta.X, startPosAllow.Y.Scale, startPosAllow.Y.Offset + delta.Y)  
    end  
end)  
  
local activeHubs = {}  
local function createFloatingHub(parent, statusText)  
    if activeHubs[parent] then return end  
    local billboard = Instance.new("BillboardGui")  
    billboard.Size = UDim2.new(0, 40, 0, 10)  
    billboard.Adornee = parent  
    billboard.AlwaysOnTop = true  
    billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)  
    billboard.Parent = AllowDisallowGui  
  
    local HubFrame = Instance.new("Frame")  
    HubFrame.Size = UDim2.new(1, 0, 1, 0)  
    HubFrame.BackgroundColor3 = COLOR_BG_DARK  
    HubFrame.BackgroundTransparency = 0.2  
    HubFrame.BorderSizePixel = 0  
    HubFrame.Parent = billboard  
    createUICorner(HubFrame, 6)  
    ApplyFastEffects(HubFrame)  
  
    local statusLabel = Instance.new("TextLabel")  
    statusLabel.Size = UDim2.new(1, 0, 1, 0)  
    statusLabel.BackgroundTransparency = 1  
    statusLabel.Text = statusText  
    statusLabel.TextColor3 = COLOR_TEXT_LIGHT  
    statusLabel.TextSize = 18  
    statusLabel.Font = Enum.Font.GothamBold  
    statusLabel.Parent = HubFrame  
    applyTextGradient(statusLabel)  
  
    activeHubs[parent] = billboard  
end  
  
task.spawn(function()  
    while task.wait(0.5) do  
        local currentObjects = {}  
        local myBase = findMyBase()  
        local nearestPrompt = nil  
        local minDist = math.huge  
  
        for _, desc in pairs(Workspace:GetDescendants()) do  
            if desc:IsA("ProximityPrompt") then  
                local isAllow = string.find(desc.ObjectText, "Allow Friends")  
                local isDisallow = string.find(desc.ObjectText, "Disallow Friends")  
                if isAllow or isDisallow then  
                    local part = desc.Parent:IsA("BasePart") and desc.Parent or desc.Parent:FindFirstChildWhichIsA("BasePart", true)  
                    if part then  
                        currentObjects[part] = true  
                        local status = isAllow and "X" or "☑️"  
                        if activeHubs[part] then  
                            local label = activeHubs[part].Frame.TextLabel  
                            if label.Text ~= status then label.Text = status end  
                        else  
                            createFloatingHub(part, status)  
                        end  
  
                        if myBase and part:IsDescendantOf(myBase) then  
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
                            if hrp then  
                                local dist = (hrp.Position - part.Position).Magnitude  
                                if dist < minDist then  
                                    minDist = dist  
                                    nearestPrompt = desc  
                                end  
                            end  
                        end  
                    end  
                end  
            end  
        end  
  
        MainAllowBtn.Text = nearestPrompt and (string.find(nearestPrompt.ObjectText, "Disallow") and "DISALLOW" or "ALLOW") or "NO BASE"  
  
        for part, bbg in pairs(activeHubs) do  
            if not currentObjects[part] then  
                bbg:Destroy()  
                activeHubs[part] = nil  
            end  
        end  
    end  
end)  
  
MainAllowBtn.MouseButton1Click:Connect(function()  
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
    local myBase = findMyBase()  
    local target = nil  
    local minDist = math.huge  
  
    for _, desc in pairs(Workspace:GetDescendants()) do  
        if desc:IsA("ProximityPrompt") and (string.find(desc.ObjectText, "Allow") or string.find(desc.ObjectText, "Disallow")) then  
            local part = desc.Parent:IsA("BasePart") and desc.Parent or desc.Parent:FindFirstChildWhichIsA("BasePart", true)  
            if part and hrp and myBase and part:IsDescendantOf(myBase) then  
                local dist = (hrp.Position - part.Position).Magnitude  
                if dist < minDist then  
                    minDist = dist  
                    target = desc  
                end  
            end  
        end  
    end  
    if target then fireproximityprompt(target) end  
end)  
  
local ProgressGui = Instance.new("ScreenGui")  
ProgressGui.Name = "leakedbySticky_ProgressBar"  
ProgressGui.ResetOnSpawn = false  
ProgressGui.ZIndexBehavior = Enum.ZIndexBehavior.Global  
ProgressGui.Parent = safeGuiTarget  
  
local PBarMain = Instance.new("Frame")  
PBarMain.Size = UDim2.new(0, 240, 0, 18)  
PBarMain.Position = UDim2.new(0.5, -120, 1, -100)  
PBarMain.BackgroundColor3 = COLOR_BG_DARK  
PBarMain.BorderSizePixel = 0  
PBarMain.ClipsDescendants = true  
PBarMain.Parent = ProgressGui  
Instance.new("UICorner", PBarMain).CornerRadius = UDim.new(1, 0)  
  
local PBarStroke = Instance.new("UIStroke", PBarMain)  
PBarStroke.Thickness = 1.5  
PBarStroke.Color = COLOR_BORDER  
  
progressFill = Instance.new("Frame")  
progressFill.Size = UDim2.new(0, 0, 1, 0)  
progressFill.BackgroundColor3 = COLOR_ACCENT  
progressFill.BorderSizePixel = 0  
progressFill.Parent = PBarMain  
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)  
  
percentLabel = Instance.new("TextLabel")  
percentLabel.Size = UDim2.new(1, 0, 1, 0)  
percentLabel.BackgroundTransparency = 1  
percentLabel.Text = "0%"  
percentLabel.TextColor3 = COLOR_TEXT_LIGHT  
percentLabel.Font = MAIN_FONT  
percentLabel.TextSize = 11  
percentLabel.ZIndex = 3  
percentLabel.Parent = PBarMain  
  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Name = "leakedbySticky_Remake"  
ScreenGui.ResetOnSpawn = false  
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global  
ScreenGui.Parent = safeGuiTarget  
  
local panelWidth = IsMobile and 235 or 215  
local mainHeight = IsMobile and 260 or 250  
  
local MainFrame = Instance.new("Frame")  
MainFrame.Size = UDim2.new(0, panelWidth, 0, mainHeight)  
MainFrame.AnchorPoint = Vector2.new(1, 0)  
MainFrame.Position = IsMobile and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.02, 0)  
MainFrame.BackgroundColor3 = COLOR_BG_DARK  
MainFrame.BorderSizePixel = 0  
MainFrame.Active = true  
MainFrame.ClipsDescendants = false  
MainFrame.Parent = ScreenGui  
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)  
  
local MainStroke = Instance.new("UIStroke", MainFrame)  
MainStroke.Thickness = 1.5  
MainStroke.Color = COLOR_BORDER  
  
local HeaderFrame = Instance.new("Frame")  
HeaderFrame.Size = UDim2.new(1, 0, 0, 48)  
HeaderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
HeaderFrame.BorderSizePixel = 0  
HeaderFrame.Parent = MainFrame  
Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 14)  
  
local HeaderCornerFix = Instance.new("Frame")  
HeaderCornerFix.Size = UDim2.new(1, 0, 0, 10)  
HeaderCornerFix.Position = UDim2.new(0, 0, 1, -10)  
HeaderCornerFix.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
HeaderCornerFix.BorderSizePixel = 0  
HeaderCornerFix.Parent = HeaderFrame  
  
local HeaderLine = Instance.new("Frame")  
HeaderLine.Size = UDim2.new(1, 0, 0, 1)  
HeaderLine.Position = UDim2.new(0, 0, 1, 0)  
HeaderLine.BackgroundColor3 = COLOR_BORDER  
HeaderLine.BorderSizePixel = 0  
HeaderLine.Parent = HeaderFrame  
  
local mainDragging, mainDragStart, mainStartPos = false, nil, nil  
HeaderFrame.InputBegan:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
        mainDragging = true  
        mainDragStart = input.Position  
        mainStartPos = MainFrame.Position  
    end  
end)  
UserInputService.InputChanged:Connect(function(input)  
    if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
        local delta = input.Position - mainDragStart  
        MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)  
    end  
end)  
UserInputService.InputEnded:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
        mainDragging = false  
    end  
end)  
  
local TitleText = Instance.new("TextLabel")  
TitleText.Size = UDim2.new(1, 0, 1, 0)  
TitleText.BackgroundTransparency = 1  
TitleText.Text = "L3D Semi TP"  
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)  
TitleText.Font = MAIN_FONT  
TitleText.TextSize = 12  
TitleText.TextWrapped = true  
TitleText.RichText = true  
TitleText.Parent = HeaderFrame  
  
local TabContainer = Instance.new("Frame")  
TabContainer.Size = UDim2.new(1, -20, 0, 26)  
TabContainer.Position = UDim2.new(0, 10, 0, 56)  
TabContainer.BackgroundColor3 = COLOR_CARD_BG  
TabContainer.BorderSizePixel = 0  
TabContainer.Parent = MainFrame  
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 8)  
  
local TabList = Instance.new("UIListLayout", TabContainer)  
TabList.FillDirection = Enum.FillDirection.Horizontal  
TabList.SortOrder = Enum.SortOrder.LayoutOrder  
  
local function createTabButton(text, order)  
    local btn = Instance.new("TextButton")  
    btn.Size = UDim2.new(0.5, 0, 1, 0)  
    btn.BackgroundTransparency = 1  
    btn.Text = text  
    btn.TextColor3 = COLOR_TEXT_DARK  
    btn.Font = MAIN_FONT  
    btn.TextSize = 11  
    btn.LayoutOrder = order  
    btn.Parent = TabContainer  
  
    local indicator = Instance.new("Frame")  
    indicator.Size = UDim2.new(1, -8, 0, 2)  
    indicator.Position = UDim2.new(0, 4, 1, -2)  
    indicator.BackgroundColor3 = COLOR_ACCENT  
    indicator.BackgroundTransparency = 1  
    indicator.BorderSizePixel = 0  
    indicator.Parent = btn  
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)  
    return btn, indicator  
end  
  
local MainTabBtn, MainTabInd = createTabButton("Main", 1)  
local UtilsTabBtn, UtilsTabInd = createTabButton("Utils", 2)  
  
local ContentLayout = Instance.new("ScrollingFrame")  
ContentLayout.Size = UDim2.new(1, -16, 1, -110)  
ContentLayout.Position = UDim2.new(0, 8, 0, 88)  
ContentLayout.BackgroundTransparency = 1  
ContentLayout.BorderSizePixel = 0  
ContentLayout.ScrollBarThickness = 2  
ContentLayout.ScrollBarImageColor3 = COLOR_ACCENT  
ContentLayout.CanvasSize = UDim2.new(0, 0, 0, 0)  
ContentLayout.AutomaticCanvasSize = Enum.AutomaticSize.Y  
ContentLayout.ClipsDescendants = true  
ContentLayout.Parent = MainFrame  
  
local List = Instance.new("UIListLayout", ContentLayout)  
List.SortOrder = Enum.SortOrder.LayoutOrder  
List.Padding = UDim.new(0, 6)  
  
local function createRowFrame(height, order)  
    local card = Instance.new("Frame")  
    card.Size = UDim2.new(1, -4, 0, height)  
    card.BackgroundColor3 = COLOR_CARD_BG  
    card.BorderSizePixel = 0  
    card.LayoutOrder = order or 1  
    card.Parent = ContentLayout  
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)  
    local stroke = Instance.new("UIStroke", card)  
    stroke.Thickness = 1  
    stroke.Color = COLOR_BORDER  
    return card  
end  
  
local function createModernToggle(parentCard, textLabel, initialState, onClick)  
    local lbl = Instance.new("TextLabel")  
    lbl.Size = UDim2.new(0.65, 0, 1, 0)  
    lbl.Position = UDim2.new(0, 10, 0, 0)  
    lbl.BackgroundTransparency = 1  
    lbl.Text = textLabel  
    lbl.TextColor3 = COLOR_TEXT_LIGHT  
    lbl.Font = MAIN_FONT  
    lbl.TextSize = 11  
    lbl.TextXAlignment = Enum.TextXAlignment.Left  
    lbl.Parent = parentCard  
  
    local track = Instance.new("TextButton")  
    track.Size = UDim2.new(0, 36, 0, 18)  
    track.Position = UDim2.new(1, -44, 0.5, -9)  
    track.BackgroundColor3 = initialState and COLOR_ACCENT or Color3.fromRGB(8, 35, 12)  
    track.BorderSizePixel = 0  
    track.Text = ""  
    track.Parent = parentCard  
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)  
  
    local pin = Instance.new("Frame")  
    pin.Size = UDim2.new(0, 14, 0, 14)  
    pin.Position = initialState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)  
    pin.BackgroundColor3 = initialState and COLOR_BG_DARK or Color3.fromRGB(20, 120, 35)  
    pin.BorderSizePixel = 0  
    pin.Parent = track  
    Instance.new("UICorner", pin).CornerRadius = UDim.new(1, 0)  
  
    local state = initialState  
    track.MouseButton1Click:Connect(function()  
        state = not state  
        if state then  
            TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_ACCENT}):Play()  
            TweenService:Create(pin, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = COLOR_BG_DARK}):Play()  
        else  
            TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(8, 35, 12)}):Play()  
            TweenService:Create(pin, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(20, 120, 35)}):Play()  
        end  
        onClick(state)  
    end)  
    return track, pin  
end  
  
local Row1 = createRowFrame(28, 1)  
local Label1 = Instance.new("TextLabel")  
Label1.Size = UDim2.new(0.4, 0, 1, 0)  
Label1.Position = UDim2.new(0, 10, 0, 0)  
Label1.BackgroundTransparency = 1  
Label1.Text = "Select Slot"  
Label1.TextColor3 = COLOR_TEXT_LIGHT  
Label1.Font = MAIN_FONT  
Label1.TextSize = 11  
Label1.TextXAlignment = Enum.TextXAlignment.Left  
Label1.Parent = Row1  
  
local SelectorFrame = Instance.new("Frame")  
SelectorFrame.Size = UDim2.new(0, 95, 0, 20)  
SelectorFrame.Position = UDim2.new(1, -103, 0.5, -10)  
SelectorFrame.BackgroundTransparency = 1  
SelectorFrame.Parent = Row1  
  
local LeftBtn = Instance.new("TextButton")  
LeftBtn.Size = UDim2.new(0, 20, 1, 0)  
LeftBtn.Position = UDim2.new(0, 0, 0, 0)  
LeftBtn.BackgroundColor3 = Color3.fromRGB(8, 35, 12)  
LeftBtn.Text = "<"  
LeftBtn.TextColor3 = COLOR_TEXT_LIGHT  
LeftBtn.Font = MAIN_FONT  
LeftBtn.TextSize = 12  
LeftBtn.Parent = SelectorFrame  
Instance.new("UICorner", LeftBtn).CornerRadius = UDim.new(0, 6)  
Instance.new("UIStroke", LeftBtn).Color = COLOR_BORDER  
addHoverAnimation(LeftBtn, Color3.fromRGB(8, 35, 12), Color3.fromRGB(120, 0, 0))  
  
local SlotDisplay = Instance.new("TextLabel")  
SlotDisplay.Size = UDim2.new(0, 47, 1, 0)  
SlotDisplay.Position = UDim2.new(0, 24, 0, 0)  
SlotDisplay.BackgroundColor3 = Color3.fromRGB(20, 0, 0)  
SlotDisplay.Text = "Slot " .. tostring(selectedSlot)  
SlotDisplay.TextColor3 = COLOR_TEXT_LIGHT  
SlotDisplay.Font = MAIN_FONT  
SlotDisplay.TextSize = 10  
SlotDisplay.Parent = SelectorFrame  
Instance.new("UICorner", SlotDisplay).CornerRadius = UDim.new(0, 6)  
Instance.new("UIStroke", SlotDisplay).Color = COLOR_BORDER  
  
local RightBtn = Instance.new("TextButton")  
RightBtn.Size = UDim2.new(0, 20, 1, 0)  
RightBtn.Position = UDim2.new(1, -20, 0, 0)  
RightBtn.BackgroundColor3 = Color3.fromRGB(8, 35, 12)  
RightBtn.Text = ">"  
RightBtn.TextColor3 = COLOR_TEXT_LIGHT  
RightBtn.Font = MAIN_FONT  
RightBtn.TextSize = 12  
RightBtn.Parent = SelectorFrame  
Instance.new("UICorner", RightBtn).CornerRadius = UDim.new(0, 6)  
Instance.new("UIStroke", RightBtn).Color = COLOR_BORDER  
addHoverAnimation(RightBtn, Color3.fromRGB(8, 35, 12), Color3.fromRGB(120, 0, 0))  
  
local function updateSlot(newSlot)  
    selectedSlot = newSlot  
    SlotDisplay.Text = "Slot " .. tostring(selectedSlot)  
    HalfwaySteal.setSlot(selectedSlot)  
end  
  
LeftBtn.MouseButton1Click:Connect(function()  
    local nextSlot = selectedSlot - 1  
    if nextSlot < 1 then nextSlot = 5 end  
    updateSlot(nextSlot)  
end)  
  
RightBtn.MouseButton1Click:Connect(function()  
    local nextSlot = selectedSlot + 1  
    if nextSlot > 5 then nextSlot = 1 end  
    updateSlot(nextSlot)  
end)  
  
local Row5 = createRowFrame(30, 2)  
local ActivateBtn = Instance.new("TextButton")  
ActivateBtn.Size = UDim2.new(1, 0, 1, 0)  
ActivateBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)  
ActivateBtn.BorderSizePixel = 0  
ActivateBtn.Text = "Activate (Reset)"  
ActivateBtn.TextColor3 = COLOR_TEXT_LIGHT  
ActivateBtn.Font = MAIN_FONT  
ActivateBtn.TextSize = 11  
ActivateBtn.Parent = Row5  
Instance.new("UICorner", ActivateBtn).CornerRadius = UDim.new(0, 8)  
addHoverAnimation(ActivateBtn, Color3.fromRGB(20, 0, 0), Color3.fromRGB(120, 0, 0))  
ActivateBtn.MouseButton1Click:Connect(function() HalfwaySteal.activate() end)  
  
local Row6 = createRowFrame(32, 3)  
TeleportBtn = Instance.new("TextButton")  
TeleportBtn.Size = UDim2.new(1, 0, 1, 0)  
TeleportBtn.BackgroundColor3 = COLOR_ACCENT  
TeleportBtn.BorderSizePixel = 0  
TeleportBtn.Text = "Steal Now"  
TeleportBtn.TextColor3 = COLOR_BG_DARK  
TeleportBtn.Font = MAIN_FONT  
TeleportBtn.TextSize = 12  
TeleportBtn.Parent = Row6  
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 8)  
addHoverAnimation(TeleportBtn, COLOR_ACCENT, Color3.fromRGB(90, 255, 60))  
TeleportBtn.MouseButton1Click:Connect(function() HalfwaySteal.execute() end)  
  
local RowDiscord = createRowFrame(22, 4)  
local DiscordLabel = Instance.new("TextLabel")  
DiscordLabel.Size = UDim2.new(1, 0, 1, 0)  
DiscordLabel.BackgroundTransparency = 1  
DiscordLabel.Text = "discord.gg/zKUkdEWjP"  
DiscordLabel.TextColor3 = COLOR_ACCENT  
DiscordLabel.Font = MAIN_FONT  
DiscordLabel.TextSize = 10  
DiscordLabel.Parent = RowDiscord  
  
local DiscordCopyBtn = Instance.new("TextButton")  
DiscordCopyBtn.Size = UDim2.new(1, 0, 1, 0)  
DiscordCopyBtn.BackgroundTransparency = 1  
DiscordCopyBtn.Text = ""  
DiscordCopyBtn.Parent = RowDiscord  
DiscordCopyBtn.MouseButton1Click:Connect(function()  
    pcall(function()  
        if setclipboard then setclipboard("https://discord.gg/zKUkdEWjP") end  
    end)  
end)  
  
local RowAutoActivate = createRowFrame(28, 10)  
createModernToggle(RowAutoActivate, "Auto Activate", AutoActivateEnabled, function(newState)  
    AutoActivateEnabled = newState  
    HubConfig.autoActivateEnabled = newState  
    saveHubConfig()  
end)  
  
local Row2 = createRowFrame(28, 11)  
createModernToggle(Row2, "Auto Potion", PotionEnabled, function(newState)  
    PotionEnabled = newState  
    HubConfig.potionEnabled = newState  
    saveHubConfig()  
end)  
  
local RowAutoWalk = createRowFrame(28, 12)  
createModernToggle(RowAutoWalk, "Auto Walk", AutoWalkEnabled, function(newState)  
    AutoWalkEnabled = newState  
    HubConfig.autoWalkEnabled = newState  
    saveHubConfig()  
end)  
  
local RowAutoTPAllow = createRowFrame(28, 13)  
createModernToggle(RowAutoTPAllow, "Auto TP on Allow", AutoTPOnAllowEnabled, function(newState)  
    AutoTPOnAllowEnabled = newState  
    HubConfig.autoTPOnAllowEnabled = newState  
    saveHubConfig()  
end)  
  
local RowAPOnSteal = createRowFrame(28, 14)  
createModernToggle(RowAPOnSteal, "AP on Steal", APOnStealEnabled, function(newState)  
    APOnStealEnabled = newState  
    HubConfig.apOnStealEnabled = newState  
    saveHubConfig()  
end)  
  
local RowKickAfterSteal = createRowFrame(28, 15)  
createModernToggle(RowKickAfterSteal, "Kick After Steal", KickAfterStealEnabled, function(newState)  
    KickAfterStealEnabled = newState  
    HubConfig.kickAfterStealEnabled = newState  
    saveHubConfig()  
end)  
  
local Row3 = createRowFrame(28, 16)  
local isSpeedVisible = HubConfig.hexSpeedVisible or false  
local HexSpeedFrameRef = nil  
  
createModernToggle(Row3, "Speed Panel", isSpeedVisible, function(newState)  
    if HexSpeedFrameRef then  
        HexSpeedFrameRef.Visible = newState  
        HubConfig.hexSpeedVisible = newState  
        saveHubConfig()  
    end  
end)  
  
local RowGear = createRowFrame(28, 17)  
local LabelGear = Instance.new("TextLabel")  
LabelGear.Size = UDim2.new(0.45, 0, 1, 0)  
LabelGear.Position = UDim2.new(0, 10, 0, 0)  
LabelGear.BackgroundTransparency = 1  
LabelGear.Text = "Select Gear"  
LabelGear.TextColor3 = COLOR_TEXT_LIGHT  
LabelGear.Font = MAIN_FONT  
LabelGear.TextSize = 11  
LabelGear.TextXAlignment = Enum.TextXAlignment.Left  
LabelGear.Parent = RowGear  
  
local initialInventoryGears = getInventoryGears()  
if #initialInventoryGears > 0 then  
    local found = false  
    for _, g in ipairs(initialInventoryGears) do  
        if g == HubConfig.selectedGear then found = true; break end  
    end  
    if not found then HubConfig.selectedGear = initialInventoryGears[1]; saveHubConfig() end  
else  
    HubConfig.selectedGear = "Sin Gear"  
end  
  
local GearCycleBtn = Instance.new("TextButton")  
GearCycleBtn.Size = UDim2.new(0, 95, 0, 20)  
GearCycleBtn.Position = UDim2.new(1, -103, 0.5, -10)  
GearCycleBtn.BackgroundColor3 = Color3.fromRGB(8, 35, 12)  
GearCycleBtn.BorderSizePixel = 0  
GearCycleBtn.Text = HubConfig.selectedGear  
GearCycleBtn.TextColor3 = COLOR_TEXT_LIGHT  
GearCycleBtn.Font = MAIN_FONT  
GearCycleBtn.TextSize = 9  
GearCycleBtn.ZIndex = 8  
GearCycleBtn.Parent = RowGear  
Instance.new("UICorner", GearCycleBtn).CornerRadius = UDim.new(0, 6)  
Instance.new("UIStroke", GearCycleBtn).Color = COLOR_BORDER  
addHoverAnimation(GearCycleBtn, Color3.fromRGB(8, 35, 12), Color3.fromRGB(120, 0, 0))  
  
GearCycleBtn.MouseButton1Click:Connect(function()  
    local inventoryGears = getInventoryGears()  
    if #inventoryGears == 0 then  
        GearCycleBtn.Text = "Sin Gear"  
        HubConfig.selectedGear = "Sin Gear"  
        saveHubConfig()  
        return  
    end  
    local currentIndex = 0  
    for i, gearName in ipairs(inventoryGears) do  
        if gearName == HubConfig.selectedGear then currentIndex = i; break end  
    end  
    local nextGear = inventoryGears[(currentIndex % #inventoryGears) + 1]  
    GearCycleBtn.Text = nextGear  
    HubConfig.selectedGear = nextGear  
    saveHubConfig()  
end)  
  
local Row4 = createRowFrame(28, 18)  
if IsMobile then Row4.Visible = false end  
  
local Label4 = Instance.new("TextLabel")  
Label4.Size = UDim2.new(0.5, 0, 1, 0)  
Label4.Position = UDim2.new(0, 10, 0, 0)  
Label4.BackgroundTransparency = 1  
Label4.Text = "Steal Keybind"  
Label4.TextColor3 = COLOR_TEXT_LIGHT  
Label4.Font = MAIN_FONT  
Label4.TextSize = 11  
Label4.TextXAlignment = Enum.TextXAlignment.Left  
Label4.Parent = Row4  
  
local KeybindBtn = Instance.new("TextButton")  
KeybindBtn.Size = UDim2.new(0, 50, 0, 20)  
KeybindBtn.Position = UDim2.new(1, -58, 0.5, -10)  
KeybindBtn.BackgroundColor3 = Color3.fromRGB(8, 35, 12)  
KeybindBtn.Text = currentStealKey.Name  
KeybindBtn.TextColor3 = COLOR_TEXT_LIGHT  
KeybindBtn.Font = MAIN_FONT  
KeybindBtn.TextSize = 10  
KeybindBtn.Parent = Row4  
Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 6)  
Instance.new("UIStroke", KeybindBtn).Color = COLOR_BORDER  
  
local isBinding = false  
KeybindBtn.MouseButton1Click:Connect(function() isBinding = true; KeybindBtn.Text = "..." end)  
  
UserInputService.InputBegan:Connect(function(input, processed)  
    if processed then return end  
    if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then  
        isBinding = false  
        currentStealKey = input.KeyCode  
        KeybindBtn.Text = input.KeyCode.Name  
        HubConfig.stealKeybind = input.KeyCode.Name  
        saveHubConfig()  
    elseif not isBinding and input.KeyCode == currentStealKey then  
        if not HalfwaySteal.debounce and not player:GetAttribute("Stealing") then  
            HalfwaySteal.execute()  
        end  
    end  
end)  
  
local function switchTab(tabName)  
    ContentLayout.CanvasPosition = Vector2.new(0, 0)  
    if tabName == "Main" then  
        MainTabBtn.TextColor3 = COLOR_TEXT_LIGHT  
        UtilsTabBtn.TextColor3 = COLOR_TEXT_DARK  
        TweenService:Create(MainTabInd, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()  
        TweenService:Create(UtilsTabInd, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()  
  
        Row1.Visible, Row5.Visible, Row6.Visible, RowDiscord.Visible = true, true, true, true  
        RowAutoActivate.Visible, Row2.Visible, RowAutoWalk.Visible, RowAutoTPAllow.Visible, RowAPOnSteal.Visible, RowKickAfterSteal.Visible, Row3.Visible, RowGear.Visible, Row4.Visible = false, false, false, false, false, false, false, false, false  
    elseif tabName == "Utils" then  
        UtilsTabBtn.TextColor3 = COLOR_TEXT_LIGHT  
        MainTabBtn.TextColor3 = COLOR_TEXT_DARK  
        TweenService:Create(UtilsTabInd, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()  
        TweenService:Create(MainTabInd, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()  
  
        Row1.Visible, Row5.Visible, Row6.Visible, RowDiscord.Visible = false, false, false, false  
        RowAutoActivate.Visible, Row2.Visible, RowAutoWalk.Visible, RowAutoTPAllow.Visible, RowAPOnSteal.Visible, RowKickAfterSteal.Visible, Row3.Visible, RowGear.Visible = true, true, true, true, true, true, true, true  
        Row4.Visible = not IsMobile  
    end  
end  
  
MainTabBtn.MouseButton1Click:Connect(function() switchTab("Main") end)  
UtilsTabBtn.MouseButton1Click:Connect(function() switchTab("Utils") end)  
switchTab("Main")  
  
local SpeedScreenGui = Instance.new("ScreenGui")  
SpeedScreenGui.Name = "leakedbySticky_Speed_Only"  
SpeedScreenGui.ResetOnSpawn = false  
SpeedScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
SpeedScreenGui.IgnoreGuiInset = true  
SpeedScreenGui.Parent = safeGuiTarget  
  
local HexSpeed = Instance.new("Frame")  
HexSpeed.Name = "leakedbyStickySpeed"  
HexSpeed.Size = UDim2.new(0, 185, 0, 105)  
HexSpeed.BackgroundColor3 = COLOR_BG_DARK  
HexSpeed.BorderSizePixel = 0  
HexSpeed.Visible = isSpeedVisible  
HexSpeed.ZIndex = 5  
HexSpeed.Parent = SpeedScreenGui  
HexSpeedFrameRef = HexSpeed  
  
HexSpeed.AnchorPoint = Vector2.new(1, 0)  
if HubConfig.speedPos and HubConfig.speedPos.ScaleX ~= 0.5 then  
    HexSpeed.Position = UDim2.new(HubConfig.speedPos.ScaleX, HubConfig.speedPos.OffsetX, HubConfig.speedPos.ScaleY, HubConfig.speedPos.OffsetY)  
else  
    HexSpeed.Position = UDim2.new(0.98, 0, 0.02, 0)  
end  
  
Instance.new("UICorner", HexSpeed).CornerRadius = UDim.new(0, 12)  
Instance.new("UIStroke", HexSpeed).Thickness = 1.5  
Instance.new("UIStroke", HexSpeed).Color = COLOR_BORDER  
  
local SpeedTitle = Instance.new("TextLabel")  
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)  
SpeedTitle.BackgroundTransparency = 1  
SpeedTitle.Text = "L3D STEAL PANEL"  
SpeedTitle.TextColor3 = COLOR_TEXT_LIGHT  
SpeedTitle.Font = MAIN_FONT  
SpeedTitle.TextSize = 11  
SpeedTitle.ZIndex = 6  
SpeedTitle.Parent = HexSpeed  
applyTextGradient(SpeedTitle)  
  
local function createSpeedButton(container, yOffset, text, toggleVar, callback)  
    local button = Instance.new("TextButton")  
    button.Size = UDim2.new(1, -12, 0, 28)  
    button.Position = UDim2.new(0, 6, 0, yOffset)  
    button.AutoButtonColor = false  
    button.Text = ""  
    button.BackgroundColor3 = COLOR_CARD_BG  
    button.BorderSizePixel = 0  
    button.ZIndex = 3  
    button.Parent = container  
  
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)  
    Instance.new("UIStroke", button).Color = COLOR_BORDER  
  
    local btnLabel = Instance.new("TextLabel")  
    btnLabel.Size = UDim2.new(1, -30, 1, 0)  
    btnLabel.Position = UDim2.new(0, 8, 0, 0)  
    btnLabel.BackgroundTransparency = 1  
    btnLabel.Text = text  
    btnLabel.TextColor3 = COLOR_TEXT_LIGHT  
    btnLabel.Font = MAIN_FONT  
    btnLabel.TextSize = 10  
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left  
    btnLabel.ZIndex = 4  
    btnLabel.Parent = button  
  
    local LedDot = Instance.new("Frame")  
    LedDot.Size = UDim2.new(0, 8, 0, 8)  
    LedDot.Position = UDim2.new(1, -16, 0.5, -4)  
    LedDot.BorderSizePixel = 0  
    LedDot.ZIndex = 4  
    LedDot.Parent = button  
    Instance.new("UICorner", LedDot).CornerRadius = UDim.new(1, 0)  
  
    local function updateVisuals(anim)  
        local isOn = _G[toggleVar]  
        local targetLed = isOn and COLOR_ACCENT or Color3.fromRGB(10, 50, 15)  
        local targetBg = isOn and Color3.fromRGB(8, 35, 12) or COLOR_CARD_BG  
        if anim then  
            TweenService:Create(LedDot, TweenInfo.new(0.2), {BackgroundColor3 = targetLed}):Play()  
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()  
        else  
            LedDot.BackgroundColor3 = targetLed  
            button.BackgroundColor3 = targetBg  
        end  
    end  
  
    updateVisuals(false)  
    button.MouseButton1Click:Connect(function()  
        _G[toggleVar] = not _G[toggleVar]  
        HubConfig[toggleVar] = _G[toggleVar]  
        saveHubConfig()  
        updateVisuals(true)  
        if callback then callback(_G[toggleVar]) end  
    end)  
    return button  
end  
  
local function createSpeedTextBoxInput(parent, yPos, labelText, min, max, current, callback)  
    local Area = Instance.new("Frame")  
    Area.Size = UDim2.new(1, -12, 0, 28)  
    Area.Position = UDim2.new(0, 6, 0, yPos)  
    Area.BackgroundColor3 = COLOR_CARD_BG  
    Area.Parent = parent  
    Instance.new("UICorner", Area).CornerRadius = UDim.new(0, 6)  
    Instance.new("UIStroke", Area).Color = COLOR_BORDER  
  
    local Label = Instance.new("TextLabel")  
    Label.Size = UDim2.new(0.65, 0, 1, 0)  
    Label.Position = UDim2.new(0, 8, 0, 0)  
    Label.BackgroundTransparency = 1  
    Label.Text = labelText  
    Label.TextColor3 = COLOR_TEXT_LIGHT  
    Label.Font = MAIN_FONT  
    Label.TextSize = 10  
    Label.TextXAlignment = Enum.TextXAlignment.Left  
    Label.Parent = Area  
  
    local InputBox = Instance.new("TextBox")  
    InputBox.Size = UDim2.new(0.25, 0, 0, 18)  
    InputBox.Position = UDim2.new(0.75, -4, 0.5, -9)  
    InputBox.BackgroundColor3 = Color3.fromRGB(10, 0, 0)  
    InputBox.Text = tostring(current)  
    InputBox.TextColor3 = COLOR_TEXT_LIGHT  
    InputBox.Font = MAIN_FONT  
    InputBox.TextSize = 10  
    InputBox.ClearTextOnFocus = false  
    InputBox.Parent = Area  
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)  
    Instance.new("UIStroke", InputBox).Color = COLOR_BORDER  
  
    InputBox.FocusLost:Connect(function()  
        local num = tonumber(InputBox.Text)  
        if num then  
            num = math.clamp(num, min, max)  
            InputBox.Text = tostring(num)  
            callback(num)  
        else  
            InputBox.Text = tostring(current)  
        end  
    end)  
end  
  
createSpeedButton(HexSpeed, 35, "Speed Boost", "speedBoostEnabled")  
createSpeedTextBoxInput(HexSpeed, 69, "Steal Speed", 16, 100, currentSpeed, function(val)  
    currentSpeed = val  
    HubConfig.speedValue = val  
    saveHubConfig()  
end)  
  
local speedDragging, speedDragStart, speedStartPos = false, nil, nil  
SpeedTitle.InputBegan:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
        speedDragging = true; speedDragStart = input.Position; speedStartPos = HexSpeed.Position  
    end  
end)  
UserInputService.InputChanged:Connect(function(input)  
    if speedDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
        local delta = input.Position - speedDragStart  
        HexSpeed.Position = UDim2.new(speedStartPos.X.Scale, speedStartPos.X.Offset + delta.X, speedStartPos.Y.Scale, speedStartPos.Y.Offset + delta.Y)  
    end  
end)  
UserInputService.InputEnded:Connect(function(input)  
    if speedDragging == true then  
        speedDragging = false  
        HubConfig.speedPos = { ScaleX = HexSpeed.Position.X.Scale, OffsetX = HexSpeed.Position.X.Offset, ScaleY = HexSpeed.Position.Y.Scale, OffsetY = HexSpeed.Position.Y.Offset }  
        saveHubConfig()  
    end  
end)  
  
local GUI = Instance.new("ScreenGui")  
GUI.Name = "leakedbyStickyAPSpamGui"  
GUI.ResetOnSpawn = false  
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
GUI.DisplayOrder = 15  
GUI.Enabled = false  
GUI.Parent = getGuiParent()  
  
_G.HalfwaySteal = HalfwaySteal  
_G.SSExecute = function() pcall(HalfwaySteal.execute) end  
_G.SetSlot = function(slot) HalfwaySteal.setSlot(slot) end  
  
HalfwaySteal.debounce = false  
  
if AutoActivateEnabled then  
    task.spawn(function()  
        task.wait(0.5)  
        HalfwaySteal.activate()  
    end)  
end  
  
local Camera = workspace.CurrentCamera  
local scales = {}  
  
local function addUIScale(guiElement)  
    local uiScale = guiElement:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")  
    uiScale.Parent = guiElement  
    table.insert(scales, uiScale)  
end  
  
addUIScale(MainFrame)  
addUIScale(HexSpeed)  
  
local UpdateScale = function()  
    if not Camera then return end  
    local viewportSize = Camera.ViewportSize  
    local baseResolution = Vector2.new(800, 450)  
    local scale = math.min(viewportSize.X / baseResolution.X, viewportSize.Y / baseResolution.Y)  
    local clampedScale = IsMobile and math.clamp(scale * 1.15, 0.95, 1.4) or math.clamp(scale * 0.85, 0.75, 1.2)  
    for _, uiScale in ipairs(scales) do uiScale.Scale = clampedScale end  
end  
  
UpdateScale()  
if Camera then Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale) end  

