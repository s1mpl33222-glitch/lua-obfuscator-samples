-- [[OPEN SOURCE SCRIPT]] --
-- [[original library repo:https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua]] --
-- [[script version 1.2]] --
-- [[update log]] --
-- 1.2 added more esp, more aimbot,info detail, added a new font...
-- 1.1 added esp, settings, team check
-- 1.0 added aimbot
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/linhmcfake/LuaLibrary/refs/heads/main/RayField.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local math_sin = math.sin
local math_huge = math.huge
local tick = tick
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_fromRGB = Color3.fromRGB
local hitboxSize = 10
local hitboxEnabled = false
local teamCheck = false
local ogSIZES = {}
local hbCON = {}
local infoToggleEnabled = false
local ignoreThroughParts = false
local FOV_RGB_Enabled = false
local FOV_RGB_Speed = 2

local pressedKeys = {}
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
        pressedKeys[input.KeyCode.Name] = true
    end
end)
UserInputService.InputEnded:Connect(function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
        pressedKeys[input.KeyCode.Name] = nil
    end
end)

local ESP_Name_Enabled = false

local AimAssistSettings = {
    Enabled = false,
    AimPart = "Nearest",
    FOV = 100,
    Sensitivity = 0.08,
    WallCheck = true,
    TeamCheck = true,
    OutfitCheck = false,
    ESP_Enabled = true,
    ESP_LineMode = "Top",
    ESP_Skeleton = true,
    ESP_RGB_NoTeam = false, 
    BulletPrediction = false,
    SkipDeadPlayers = true,
    SmoothAiming = true,
    ESP_Box = false,
    ESP_AimPart = false,
    ESP_SkipTeam = false
}

local Circle = Drawing.new("Circle")
Circle.Color = Color3_fromRGB(255, 0, 0)
Circle.Thickness = 1
Circle.Filled = false
Circle.Radius = AimAssistSettings.FOV
Circle.Position = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
Circle.Visible = false

local InfoText = Drawing.new("Text")
InfoText.Visible = false
InfoText.Color = Color3_fromRGB(255,255,255)
InfoText.Size = 18
InfoText.Outline = true
InfoText.Center = false
InfoText.Font = 2

local ESP_Lines = {}
local ESP_Skeletons = {}
local ESP_Pool = {lines = {}, skeletons = {}, names = {}}
local ESP_Boxes = {}
local ESP_PartMarkers = {}
local ESP_BoxPool = {}
local ESP_PartMarkerPool = {}
local ESP_NameTexts = {}
local ESP_NamePool = {}
local screenCenter = Vector2_new(0, 0)
local lastScreenUpdate = 0
local SCREEN_UPDATE_INTERVAL = 1/15
local lastRGBTime = 0
local cachedRGBColor = Color3_fromRGB(255, 255, 255)
local RGB_UPDATE_INTERVAL = 1/15

local FOV_RGB_Tick = 0

local function GetRGBColor(speed)
    local currentTime = tick()
    local time = currentTime * (speed or 2)
    local r = math_sin(time) * 127 + 128
    local g = math_sin(time + 2) * 127 + 128
    local b = math_sin(time + 4) * 127 + 128
    return Color3_fromRGB(r, g, b)
end

local outfitCache = {}
local outfitCacheTime = {}
local OUTFIT_CACHE_DURATION = 5
local function GetPlayerOutfit(player)
    if not player or not player.Character then
        return nil
    end
    local currentTime = tick()
    local playerId = player.UserId
    if outfitCache[playerId] and outfitCacheTime[playerId] and 
       (currentTime - outfitCacheTime[playerId]) < OUTFIT_CACHE_DURATION then
        return outfitCache[playerId]
    end
    local outfitData = {}
    local shirt = player.Character:FindFirstChildOfClass("Shirt")
    local pants = player.Character:FindFirstChildOfClass("Pants")
    outfitData.shirt = shirt and shirt.ShirtTemplate or ""
    outfitData.pants = pants and pants.PantsTemplate or ""
    outfitCache[playerId] = outfitData
    outfitCacheTime[playerId] = currentTime
    return outfitData
end
local function CompareOutfits(outfit1, outfit2)
    if not outfit1 or not outfit2 then
        return false
    end
    return outfit1.shirt ~= "" and outfit1.pants ~= "" and 
           outfit1.shirt == outfit2.shirt and outfit1.pants == outfit2.pants
end

local hasTeamSystem = nil
local lastTeamCheck = 0
local TEAM_CHECK_INTERVAL = 2
local function HasTeamSystem()
    local currentTime = tick()
    if hasTeamSystem == nil or (currentTime - lastTeamCheck) >= TEAM_CHECK_INTERVAL then
        lastTeamCheck = currentTime
        hasTeamSystem = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Team ~= nil then
                hasTeamSystem = true
                break
            end
        end
    end
    return hasTeamSystem
end
local function HasSameOutfit(player)
    if not AimAssistSettings.OutfitCheck then
        return false
    end
    local localOutfit = GetPlayerOutfit(LocalPlayer)
    local targetOutfit = GetPlayerOutfit(player)
    return CompareOutfits(localOutfit, targetOutfit)
end
local function IsPlayerAlive(player)
    if not player or not player.Character then
        return false
    end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end
function IsVisibleCustom(part, origin)
    local direction = (part.Position - origin)
    local distance = direction.Magnitude
    if distance < 1 then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local filterList = {LocalPlayer.Character, Camera}
    rayParams.FilterDescendantsInstances = filterList
    rayParams.IgnoreWater = true
    local rayDirection = direction.Unit * (distance - 0.1)
    local result = workspace:Raycast(origin, rayDirection, rayParams)
    if not result then
        return true
    end
    local hitPart = result.Instance
    if hitPart and hitPart.Parent then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team and plr.Character and hitPart:IsDescendantOf(plr.Character) then
                return false
            end
        end
        if ignoreThroughParts and (
            hitPart.CanCollide == false or
            hitPart.Transparency > 0.9 or
            (hitPart.Name == "Glass" or hitPart.Name == "Water" or hitPart.Name == "Air" or hitPart.Name == "PartCanShootThrough")
        ) then
            local newOrigin = result.Position + direction.Unit * 0.01
            local newDirection = (part.Position - newOrigin)
            if newDirection.Magnitude > 1 then
                return IsVisibleCustom(part, newOrigin)
            end
        end
        return hitPart:IsDescendantOf(part.Parent) or hitPart.Parent == part.Parent
    end
    return false
end
local function IsVisible(part)
    return IsVisibleCustom(part, Camera.CFrame.Position)
end
local function GetNearestPart(character)
    local parts = {"Head", "Torso", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
    local nearestPart, nearestDistance = nil, math_huge
    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen and screenPoint.Z > 0 then
                local dist = (Vector2_new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                if dist < nearestDistance then
                    nearestDistance = dist
                    nearestPart = part
                end
            end
        end
    end
    return nearestPart
end
local function GetClosestEnemyAbsolute()
    local closestPlayer, closestDistance = nil, math_huge
    local hasTeam = HasTeamSystem()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if AimAssistSettings.SkipDeadPlayers and not IsPlayerAlive(player) then
                continue
            end
            if AimAssistSettings.TeamCheck and hasTeam and player.Team == LocalPlayer.Team then
                continue
            end
            if HasSameOutfit(player) then
                continue
            end
            local dist = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            if dist < closestDistance then
                closestDistance = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end
local function GetClosestPlayer()
    local closestPlayer, closestDistance = nil, math_huge
    local hasTeam = HasTeamSystem()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if AimAssistSettings.SkipDeadPlayers and not IsPlayerAlive(player) then
                continue
            end
            if AimAssistSettings.TeamCheck and hasTeam and player.Team == LocalPlayer.Team then 
                continue 
            end
            if HasSameOutfit(player) then
                continue
            end
            local targetPart
            if AimAssistSettings.AimPart == "Nearest" then
                targetPart = GetNearestPart(player.Character)
            else
                targetPart = player.Character:FindFirstChild(AimAssistSettings.AimPart)
                if not targetPart then
                    local fallbackMap = {
                        ["Torso"] = {"Torso", "UpperTorso", "LowerTorso"},
                        ["UpperTorso"] = {"UpperTorso", "Torso"},
                        ["LowerTorso"] = {"LowerTorso", "Torso"},
                        ["HumanoidRootPart"] = {"HumanoidRootPart"},
                        ["Head"] = {"Head"}
                    }
                    local fallbacks = fallbackMap[AimAssistSettings.AimPart] or {AimAssistSettings.AimPart}
                    for _, fallback in ipairs(fallbacks) do
                        targetPart = player.Character:FindFirstChild(fallback)
                        if targetPart then break end
                    end
                    if not targetPart then
                        local lastResort = {"HumanoidRootPart", "Torso", "UpperTorso", "Head"}
                        for _, fallback in ipairs(lastResort) do
                            targetPart = player.Character:FindFirstChild(fallback)
                            if targetPart then break end
                        end
                    end
                end
            end
            if targetPart then
                if AimAssistSettings.WallCheck and not IsVisible(targetPart) then 
                    continue 
                end
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPoint.Z > 0 then
                    local dist = (Vector2_new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                    if dist < AimAssistSettings.FOV and dist < closestDistance then
                        closestDistance = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end
local function GetTargetPart(player)
    if not player or not player.Character then return nil end
    if AimAssistSettings.AimPart == "Nearest" then
        return GetNearestPart(player.Character)
    else
        local part = player.Character:FindFirstChild(AimAssistSettings.AimPart)
        if part then
            return part
        end
        local fallbackMap = {
            ["Torso"] = {"Torso", "UpperTorso", "LowerTorso"},
            ["UpperTorso"] = {"UpperTorso", "Torso"},
            ["LowerTorso"] = {"LowerTorso", "Torso"},
            ["HumanoidRootPart"] = {"HumanoidRootPart"},
            ["Head"] = {"Head"}
        }
        local fallbacks = fallbackMap[AimAssistSettings.AimPart] or {AimAssistSettings.AimPart}
        for _, fallback in ipairs(fallbacks) do
            part = player.Character:FindFirstChild(fallback)
            if part then
                return part
            end
        end
        local lastResort = {"HumanoidRootPart", "Torso", "UpperTorso", "Head"}
        for _, fallback in ipairs(lastResort) do
            part = player.Character:FindFirstChild(fallback)
            if part then
                return part
            end
        end
    end
    return nil
end
local function applyHitbox(plr)
    if plr == LocalPlayer or not hitboxEnabled then return end
    if teamCheck and plr.Team ~= nil and LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team then return end
    local function updateHitbox()
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health > 0 and root then
            if not ogSIZES[plr] then
                ogSIZES[plr] = root.Size
            end
            root.Size = Vector3_new(hitboxSize, hitboxSize, hitboxSize)
            root.Transparency = 0.9
            root.BrickColor = BrickColor.new("Really black")
            root.Material = Enum.Material.Neon
            root.CanCollide = false
        end
    end
    updateHitbox()
    if hbCON[plr] then hbCON[plr]:Disconnect() end
    hbCON[plr] = RunService.Heartbeat:Connect(function()
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health > 0 and root then
            root.Size = Vector3_new(hitboxSize, hitboxSize, hitboxSize)
            root.Transparency = 0.9
            root.BrickColor = BrickColor.new("Really black")
            root.Material = Enum.Material.Neon
            root.CanCollide = false
        end
    end)
end
local function removeHitbox(plr)
    if hbCON[plr] then
        hbCON[plr]:Disconnect()
        hbCON[plr] = nil
    end
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and ogSIZES[plr] then
        root.Size = ogSIZES[plr]
        root.Transparency = 1
        root.BrickColor = BrickColor.new("Really black")
        root.Material = Enum.Material.Neon
        root.CanCollide = true
    end
    ogSIZES[plr] = nil
end
local function GetPlayerColor(player)
    if AimAssistSettings.ESP_RGB_NoTeam and (not player.Team or player.Team == nil) then
        return GetRGBColor()
    end
    if player.Team and player.TeamColor then
        return player.TeamColor.Color
    else
        return Color3_fromRGB(255, 255, 255)
    end
end
local function GetESPLine()
    local line = table.remove(ESP_Pool.lines)
    if line then
        line.Visible = true
        return line
    else
        local newLine = Drawing.new("Line")
        newLine.Visible = true
        return newLine
    end
end
local function ReturnESPLine(line)
    if line then
        line.Visible = false
        table.insert(ESP_Pool.lines, line)
    end
end
local function ReturnESPSkeleton(skeleton)
    if skeleton then
        for _, line in ipairs(skeleton) do
            ReturnESPLine(line)
        end
    end
end
local function GetESPBox()
    local box = table.remove(ESP_BoxPool)
    if box then
        box.Visible = true
        return box
    else
        local newBox = Drawing.new("Quad")
        newBox.Visible = true
        newBox.Thickness = 1.5
        newBox.Transparency = 1
        return newBox
    end
end
local function ReturnESPBox(box)
    if box then
        box.Visible = false
        table.insert(ESP_BoxPool, box)
    end
end
local function GetESPCircle()
    local circle = table.remove(ESP_PartMarkerPool)
    if circle then
        circle.Visible = true
        return circle
    else
        local newCircle = Drawing.new("Circle")
        newCircle.Visible = true
        newCircle.Radius = 8
        newCircle.Thickness = 2
        newCircle.Filled = false
        return newCircle
    end
end
local function ReturnESPCircle(circle)
    if circle then
        circle.Visible = false
        table.insert(ESP_PartMarkerPool, circle)
    end
end

local function GetESPNameText()
    local t = table.remove(ESP_NamePool)
    if t then
        t.Visible = true
        return t
    else
        local text = Drawing.new("Text")
        text.Visible = true
        text.Size = 16
        text.Outline = true
        text.Center = true
        text.Font = 2
        text.Color = Color3_fromRGB(255,255,255)
        return text
    end
end
local function ReturnESPNameText(t)
    if t then
        t.Visible = false
        table.insert(ESP_NamePool, t)
    end
end

local lastFrameTime = 0
local FRAME_LIMIT = 1/60
local lastESPUpdate = 0
local ESP_UPDATE_INTERVAL = 1/20
local function UpdateESP()
    local currentTime = tick()
    if currentTime - lastESPUpdate < ESP_UPDATE_INTERVAL then return end
    lastESPUpdate = currentTime
    for _, line in ipairs(ESP_Lines) do ReturnESPLine(line) end
    ESP_Lines = {}
    for _, skeleton in ipairs(ESP_Skeletons) do ReturnESPSkeleton(skeleton) end
    ESP_Skeletons = {}
    for _, box in ipairs(ESP_Boxes) do ReturnESPBox(box) end
    ESP_Boxes = {}
    for _, circ in ipairs(ESP_PartMarkers) do ReturnESPCircle(circ) end
    ESP_PartMarkers = {}
    for _, t in ipairs(ESP_NameTexts) do ReturnESPNameText(t) end
    ESP_NameTexts = {}
    local hasTeam = HasTeamSystem()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if AimAssistSettings.SkipDeadPlayers and not IsPlayerAlive(player) then continue end
            if AimAssistSettings.ESP_SkipTeam and hasTeam and player.Team == LocalPlayer.Team then continue end
            local humanoidRootPart = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            if onScreen and pos.Z > 0 then
                local color = GetPlayerColor(player)
                if AimAssistSettings.ESP_Enabled then
                    local line = GetESPLine()
                    local fromY = AimAssistSettings.ESP_LineMode == "Top" and 0 or Camera.ViewportSize.Y
                    line.From = Vector2_new(Camera.ViewportSize.X / 2, fromY)
                    line.To = Vector2_new(pos.X, pos.Y)
                    line.Thickness = 1
                    line.Transparency = 1
                    line.Color = color
                    table.insert(ESP_Lines, line)
                end
                if AimAssistSettings.ESP_Skeleton then
                    local skeleton = {}
                    local character = player.Character
                    local skeletonColor = color
                    local function connectParts(partA, partB)
                        local p1, v1 = character:FindFirstChild(partA), character:FindFirstChild(partB)
                        if p1 and v1 then
                            local pos1, os1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2, os2 = Camera:WorldToViewportPoint(v1.Position)
                            if os1 and os2 and pos1.Z > 0 and pos2.Z > 0 then
                                local line = GetESPLine()
                                line.From = Vector2_new(pos1.X, pos1.Y)
                                line.To = Vector2_new(pos2.X, pos2.Y)
                                line.Color = skeletonColor
                                line.Thickness = 1.5
                                line.Transparency = 0.8
                                table.insert(skeleton, line)
                            end
                        end
                    end
                    if character:FindFirstChild("UpperTorso") then
                        connectParts("Head", "UpperTorso")
                        connectParts("UpperTorso", "LowerTorso")
                        connectParts("UpperTorso", "LeftUpperArm")
                        connectParts("LeftUpperArm", "LeftLowerArm")
                        connectParts("LeftLowerArm", "LeftHand")
                        connectParts("UpperTorso", "RightUpperArm")
                        connectParts("RightUpperArm", "RightLowerArm")
                        connectParts("RightLowerArm", "RightHand")
                        connectParts("LowerTorso", "LeftUpperLeg")
                        connectParts("LeftUpperLeg", "LeftLowerLeg")
                        connectParts("LeftLowerLeg", "LeftFoot")
                        connectParts("LowerTorso", "RightUpperLeg")
                        connectParts("RightUpperLeg", "RightLowerLeg")
                        connectParts("RightLowerLeg", "RightFoot")
                    else
                        connectParts("Head", "Torso")
                        connectParts("Torso", "Left Arm")
                        connectParts("Torso", "Right Arm")
                        connectParts("Torso", "Left Leg")
                        connectParts("Torso", "Right Leg")
                    end
                    table.insert(ESP_Skeletons, skeleton)
                end
                if AimAssistSettings.ESP_Box then
                    local min, max = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            min = Vector3.new(
                                math.min(min.X, part.Position.X - part.Size.X/2),
                                math.min(min.Y, part.Position.Y - part.Size.Y/2),
                                math.min(min.Z, part.Position.Z - part.Size.Z/2)
                            )
                            max = Vector3.new(
                                math.max(max.X, part.Position.X + part.Size.X/2),
                                math.max(max.Y, part.Position.Y + part.Size.Y/2),
                                math.max(max.Z, part.Position.Z + part.Size.Z/2)
                            )
                        end
                    end
                    local corners = {
                        Vector3.new(min.X, min.Y, min.Z),
                        Vector3.new(max.X, min.Y, min.Z),
                        Vector3.new(max.X, max.Y, min.Z),
                        Vector3.new(min.X, max.Y, min.Z),
                        Vector3.new(min.X, min.Y, max.Z),
                        Vector3.new(max.X, min.Y, max.Z),
                        Vector3.new(max.X, max.Y, max.Z),
                        Vector3.new(min.X, max.Y, max.Z),
                    }
                    local screenPoints = {}
                    local anyVisible = false
                    for _, v in ipairs(corners) do
                        local p, vis = Camera:WorldToViewportPoint(v)
                        if vis and p.Z > 0 then
                            anyVisible = true
                        end
                        table.insert(screenPoints, Vector2_new(p.X, p.Y))
                    end
                    if anyVisible then
                        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                        for _, v in ipairs(screenPoints) do
                            minX = math.min(minX, v.X)
                            minY = math.min(minY, v.Y)
                            maxX = math.max(maxX, v.X)
                            maxY = math.max(maxY, v.Y)
                        end
                        local box = GetESPBox()
                        box.Color = color
                        box.PointA = Vector2_new(minX, minY)
                        box.PointB = Vector2_new(maxX, minY)
                        box.PointC = Vector2_new(maxX, maxY)
                        box.PointD = Vector2_new(minX, maxY)
                        table.insert(ESP_Boxes, box)
                    end
                end
                if ESP_Name_Enabled then
                    local nameText = GetESPNameText()
                    nameText.Text = player.DisplayName or player.Name
                    nameText.Color = color
                    nameText.Size = 17
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3_new(0, 0.8, 0))
                        if headOnScreen and headPos.Z > 0 then
                            nameText.Position = Vector2_new(headPos.X, headPos.Y - 16)
                        else
                            nameText.Visible = false
                        end
                    else
                        nameText.Position = Vector2_new(pos.X, pos.Y - 16)
                    end
                    nameText.Visible = true
                    table.insert(ESP_NameTexts, nameText)
                end
            end
        end
    end
    if AimAssistSettings.ESP_AimPart and AimAssistSettings.Enabled then
        local target = GetClosestPlayer()
        if target then
            local part = GetTargetPart(target)
            if part then
                local p, vis = Camera:WorldToViewportPoint(part.Position)
                if vis and p.Z > 0 then
                    local circ = GetESPCircle()
                    circ.Position = Vector2_new(p.X, p.Y)
                    circ.Color = Color3_fromRGB(255, 0, 0)
                    circ.Visible = true
                    table.insert(ESP_PartMarkers, circ)
                end
            end
        end
    end
end
local lastTarget = nil
local targetLockTime = 0
local LOCK_DURATION = 0.3
RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    if currentTime - lastFrameTime < FRAME_LIMIT then return end
    lastFrameTime = currentTime
    if currentTime - lastScreenUpdate >= SCREEN_UPDATE_INTERVAL then
        screenCenter = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        lastScreenUpdate = currentTime
    end

    if FOV_RGB_Enabled then
        Circle.Color = GetRGBColor(FOV_RGB_Speed)
    end

    Circle.Radius = AimAssistSettings.FOV
    Circle.Position = screenCenter
    Circle.Visible = AimAssistSettings.Enabled

    local currentTarget = nil
    if AimAssistSettings.Enabled then
        local target = GetClosestPlayer()
        if target and target == lastTarget then
            targetLockTime = currentTime
        elseif target and not lastTarget then
            lastTarget = target
            targetLockTime = currentTime
        elseif not target and lastTarget and (currentTime - targetLockTime) < LOCK_DURATION then
            target = lastTarget
        else
            lastTarget = target
            targetLockTime = currentTime
        end
        if target then
            local targetPart = GetTargetPart(target)
            if targetPart then
                local isValid = true
                if AimAssistSettings.SkipDeadPlayers and not IsPlayerAlive(target) then
                    isValid = false
                end
                if AimAssistSettings.TeamCheck and HasTeamSystem() and target.Team == LocalPlayer.Team then
                    isValid = false
                end
                if HasSameOutfit(target) then
                    isValid = false
                end
                if AimAssistSettings.WallCheck and not IsVisible(targetPart) then
                    isValid = false
                end
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPoint.Z > 0 then
                    local dist = (Vector2_new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                    if dist > AimAssistSettings.FOV then
                        isValid = false
                    end
                else
                    isValid = false
                end
                if isValid then
                    local aimPos = targetPart.Position
                    if AimAssistSettings.BulletPrediction and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetVelocity = target.Character.HumanoidRootPart.Velocity
                        local distance = (aimPos - Camera.CFrame.Position).Magnitude
                        local timeToTarget = distance / 1000
                        aimPos = aimPos + (targetVelocity * timeToTarget * 0.1)
                    end
                    local dir = (aimPos - Camera.CFrame.Position).Unit
                    local goal = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)
                    local smoothness = AimAssistSettings.Sensitivity
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local moveVector = LocalPlayer.Character.Humanoid.MoveDirection
                        if moveVector.Magnitude > 0.1 then
                            smoothness = smoothness * 0.7
                        end
                    end
                    if AimAssistSettings.SmoothAiming then
                        Camera.CFrame = Camera.CFrame:Lerp(goal, smoothness)
                    else
                        Camera.CFrame = goal
                    end
                    currentTarget = target
                else
                    lastTarget = nil
                end
            end
        else
            lastTarget = nil
        end
    else
        lastTarget = nil
    end
    if infoToggleEnabled then
        InfoText.Visible = true
        local str = ""
        local closest = GetClosestEnemyAbsolute()
        local closestName = "none"
        if closest then
            local dn = closest.DisplayName or closest.Name
            local un = closest.Name
            closestName = dn .. " (@" .. un .. ")"
        end
        local isStunned = false
        if closest and closest.Character then
            local stunVal = closest.Character:FindFirstChild("Stunned")
            if stunVal and stunVal:IsA("BoolValue") then
                isStunned = stunVal.Value
            elseif closest.Character:FindFirstChildOfClass("Humanoid") and closest.Character.Humanoid:FindFirstChild("Stunned") then
                local stunH = closest.Character.Humanoid.Stunned
                if type(stunH) == "boolean" then
                    isStunned = stunH
                elseif type(stunH) == "number" then
                    isStunned = stunH > 0
                elseif typeof(stunH) == "Instance" and stunH:IsA("BoolValue") then
                    isStunned = stunH.Value
                end
            end
        end
        local stunText = isStunned and "     [STUNNED]" or ""
        local myTeam = (LocalPlayer.Team and LocalPlayer.Team.Name) or "none"
        local aimTargetName = lastTarget and (lastTarget.DisplayName or lastTarget.Name) or "none"
        local aimAssistState = AimAssistSettings.Enabled and "ENABLED" or "DISABLED"
        local aimingPart = lastTarget and GetTargetPart(lastTarget) and GetTargetPart(lastTarget).Name or "none"
        str = str .. ("[AimAssist: %s]\nTeam: %s\nClosest Enemy: %s%s\nAiming Target: %s\nAiming Part: %s"):format(
            aimAssistState, myTeam, closestName, stunText, aimTargetName, aimingPart
        )
        local keysText = ""
        for k in pairs(pressedKeys) do
            keysText = keysText .. k .. " "
        end
        if keysText == "" then keysText = "none" end
        str = str .. ("\nKeys Held: %s"):format(keysText)
        InfoText.Text = str
        InfoText.Position = Vector2_new(10, 100)
    else
        InfoText.Visible = false
    end
end)
RunService.RenderStepped:Connect(UpdateESP)
local Window = Rayfield:CreateWindow({
    Name = "Linhmc's Universal AimAssist",
    LoadingTitle = "Universal AimAssist",
    LoadingSubtitle = "by linhmc_new",
    ConfigurationSaving = {Enabled = false}
})
local AimAssistTab = Window:CreateTab("AimAssist", "crosshair")
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)
local VisualTab = Window:CreateTab("Visual", "eye")
local SettingsTab = Window:CreateTab("Settings", "settings")
AimAssistTab:CreateToggle({
    Name = "Show Info Overlay",
    CurrentValue = false,
    Callback = function(state)
        infoToggleEnabled = state
    end
})
HitboxTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 50},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 10,
    Callback = function(value)
        hitboxSize = value
    end
})
HitboxTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(state)
        hitboxEnabled = state
        for _, plr in pairs(Players:GetPlayers()) do
            if state then
                applyHitbox(plr)
            else
                removeHitbox(plr)
            end
        end
    end
})
HitboxTab:CreateToggle({
    Name = "Hitbox Team Check",
    CurrentValue = false,
    Callback = function(state)
        teamCheck = state
        if hitboxEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                removeHitbox(plr)
                applyHitbox(plr)
            end
        end
    end
})
AimAssistTab:CreateToggle({
    Name = "Enable AimAssist", 
    CurrentValue = false, 
    Callback = function(value) 
        AimAssistSettings.Enabled = value 
    end
})
AimAssistTab:CreateDropdown({
    Name = "Aim Part", 
    Options = {"Head", "Torso", "UpperTorso (R15)", "LowerTorso (R15)", "HumanoidRootPart", "Nearest"}, 
    CurrentOption = "Nearest",
    Callback = function(value) 
        if type(value) == "table" then
            value = value[1]
        end
        if value == "UpperTorso (R15)" then value = "UpperTorso" end
        if value == "LowerTorso (R15)" then value = "LowerTorso" end
        AimAssistSettings.AimPart = value 
    end
})
AimAssistTab:CreateSlider({
    Name = "FOV Radius", 
    Range = {30, 300}, 
    Increment = 5, 
    CurrentValue = 100,
    Callback = function(value) 
        AimAssistSettings.FOV = value 
    end
})
AimAssistTab:CreateSlider({
    Name = "Smooth Aiming Sensitivity", 
    Range = {0.01, 1}, 
    Increment = 0.01, 
    CurrentValue = 0.75,
    Callback = function(value) 
        AimAssistSettings.Sensitivity = value 
    end
})
AimAssistTab:CreateToggle({
    Name = "Bullet Prediction (JUSTFORFUN)", 
    CurrentValue = false,
    Callback = function(value) 
        AimAssistSettings.BulletPrediction = value 
    end
})
AimAssistTab:CreateToggle({
    Name = "Smooth Aiming", 
    CurrentValue = true,
    Callback = function(value) 
        AimAssistSettings.SmoothAiming = value 
    end
})
AimAssistTab:CreateColorPicker({
    Name = "FOV Circle Color", 
    Color = Color3_fromRGB(255,0,0),
    Callback = function(color) 
        if not FOV_RGB_Enabled then
            Circle.Color = color 
        end
    end
})
AimAssistTab:CreateToggle({
    Name = "FOV RGB (Rainbow Circle)",
    CurrentValue = false,
    Callback = function(state)
        FOV_RGB_Enabled = state
    end
})
AimAssistTab:CreateSlider({
    Name = "FOV RGB Speed",
    Range = {0.5, 10},
    Increment = 0.1,
    CurrentValue = 2,
    Callback = function(val)
        FOV_RGB_Speed = val
    end
})
local Paragraph = VisualTab:CreateParagraph({
   Title = "ESP",
   Content = "for a better EYE"
})

VisualTab:CreateToggle({
    Name = "ESP Lines", 
    CurrentValue = true, 
    Callback = function(value) 
        AimAssistSettings.ESP_Enabled = value 
    end
})
VisualTab:CreateToggle({
    Name = "ESP Skeleton", 
    CurrentValue = true,
    Callback = function(value) 
        AimAssistSettings.ESP_Skeleton = value 
    end
})
VisualTab:CreateToggle({
    Name = "RGB player who have no team", 
    CurrentValue = false, 
    Callback = function(value) 
        AimAssistSettings.ESP_RGB_NoTeam = value 
    end
})
VisualTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Callback = function(value)
        AimAssistSettings.ESP_Box = value
    end
})
VisualTab:CreateToggle({
    Name = "ESP Aim Part",
    CurrentValue = false,
    Callback = function(value)
        AimAssistSettings.ESP_AimPart = value
    end
})
VisualTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Callback = function(value)
        ESP_Name_Enabled = value
    end
})
VisualTab:CreateToggle({
    Name = "Skip ESP Team",
    CurrentValue = false,
    Callback = function(value)
        AimAssistSettings.ESP_SkipTeam = value
    end
})
SettingsTab:CreateToggle({
    Name = "Wall Check", 
    CurrentValue = true,
    Callback = function(value) 
        AimAssistSettings.WallCheck = value 
    end
})
SettingsTab:CreateToggle({
    Name = "AimAssist Team Check", 
    CurrentValue = true, 
    Callback = function(value) 
        AimAssistSettings.TeamCheck = value 
    end
})
SettingsTab:CreateToggle({
    Name = "Outfit Check (skip player who have same shirt and pants)", 
    CurrentValue = false, 
    Callback = function(value) 
        AimAssistSettings.OutfitCheck = value 
    end
})
SettingsTab:CreateToggle({
    Name = "Skip Dead Players", 
    CurrentValue = true, 
    Callback = function(value) 
        AimAssistSettings.SkipDeadPlayers = value 
    end
})
SettingsTab:CreateToggle({
    Name = "Ignore Parts Can Walk Through",
    CurrentValue = false,
    Callback = function(value)
        ignoreThroughParts = value
    end
})
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if hitboxEnabled then
            applyHitbox(plr)
        end
    end)
end)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            if hitboxEnabled then
                applyHitbox(plr)
            end
        end)
    end
end
Rayfield:Notify({
    Title = "Linhmc's AimAssist Loaded",
    Content = "script loaded successfully",
    Duration = 3,
    Image = "check-circle"
})