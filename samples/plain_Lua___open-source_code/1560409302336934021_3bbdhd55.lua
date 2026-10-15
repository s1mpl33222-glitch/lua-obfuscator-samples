-- rivals silent aim leaked by big dick certz
-- edited: toggle GUI + name inside box + ESP (SAFE ESP) toggle

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =====================
-- SILENT AIM
-- =====================
local silentAimEnabled = false
local silentAimTarget = nil
local silentAimTargetPlayer = nil

local function isValidSilentAimTarget(targetPlayer)
    if targetPlayer == LocalPlayer then return false end
    local character = targetPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetBone = character:FindFirstChild("Head")
    if not (humanoid and targetBone and humanoid.Health > 0) then return false end
    local distance = (targetBone.Position - Camera.CFrame.Position).Magnitude
    if distance > 1000 then return false end
    if targetPlayer.Team and LocalPlayer.Team then
        if targetPlayer.Team == LocalPlayer.Team then return false end
    end
    local myTeam = LocalPlayer:GetAttribute("TeamID")
    local theirTeam = targetPlayer:GetAttribute("TeamID")
    if myTeam and theirTeam and myTeam == theirTeam then return false end
    return true
end

local function findBestSilentAimTarget()
    local viewportCenter = Camera.ViewportSize / 2
    local bestPlayer = nil
    local bestDistance = math.huge
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if isValidSilentAimTarget(otherPlayer) then
            local character = otherPlayer.Character
            local targetBone = character:FindFirstChild("Head")
            if targetBone then
                local screenPos, isOnScreen = Camera:WorldToViewportPoint(targetBone.Position)
                if isOnScreen then
                    local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if distanceFromCenter < bestDistance then
                        bestDistance = distanceFromCenter
                        bestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    return bestPlayer
end

local silentAimOriginalIndex = nil
local silentAimHookActive = false

local function setupSilentAimHook()
    if silentAimHookActive then return end
    if not hookmetamethod then return end
    local isCaller = checkcaller or function() return false end
    silentAimOriginalIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if silentAimEnabled and not isCaller() and index == "ViewportSize" and self == Camera and silentAimTarget then
            local screenPos, isOnScreen = Camera:WorldToViewportPoint(silentAimTarget)
            if isOnScreen then
                return Vector2.new(screenPos.X * 2, screenPos.Y * 2)
            end
        end
        return silentAimOriginalIndex(self, index)
    end))
    silentAimHookActive = true
end

spawn(function()
    while true do
        if silentAimEnabled then
            local bestPlayer = findBestSilentAimTarget()
            if bestPlayer then
                local character = bestPlayer.Character
                local targetBone = character and character:FindFirstChild("Head")
                if targetBone then
                    silentAimTarget = targetBone.Position
                    silentAimTargetPlayer = bestPlayer
                else
                    silentAimTarget = nil
                    silentAimTargetPlayer = nil
                end
            else
                silentAimTarget = nil
                silentAimTargetPlayer = nil
            end
        else
            silentAimTarget = nil
            silentAimTargetPlayer = nil
        end
        RunService.Heartbeat:Wait()
    end
end)

setupSilentAimHook()

-- =====================
-- SAFE ESP
-- =====================
local ESP_ENABLED = true
local MAX_DISTANCE = 1000
local NEAR_DISTANCE = 15

local esp = {}

local function removeESP(player)
    local data = esp[player]
    if not data then return end
    for _, object in pairs(data) do
        if typeof(object) == "Instance" then
            pcall(function() object:Destroy() end)
        end
    end
    esp[player] = nil
end

local function createESP(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end
    removeESP(player)

    local gui = Instance.new("ScreenGui")
    gui.Name = "SafeESP_" .. player.Name
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = gui
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 2
    boxStroke.Color = Color3.fromRGB(255, 255, 255)
    boxStroke.Parent = box

    local info = Instance.new("TextLabel")
    info.Name = "Info"
    info.AnchorPoint = Vector2.new(0.5, 1)
    info.Size = UDim2.fromOffset(190, 42)
    info.BackgroundColor3 = Color3.fromRGB(10, 11, 17)
    info.BackgroundTransparency = 0.1
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.TextStrokeTransparency = 0.25
    info.Font = Enum.Font.GothamBold
    info.TextSize = 11
    info.Visible = false
    info.Parent = gui
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 7)
    infoCorner.Parent = info
    local infoStroke = Instance.new("UIStroke")
    infoStroke.Thickness = 1
    infoStroke.Color = Color3.fromRGB(130, 140, 180)
    infoStroke.Parent = info

    local tracer = Instance.new("Frame")
    tracer.Name = "Tracer"
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.BackgroundColor3 = Color3.fromRGB(178, 184, 215)
    tracer.BorderSizePixel = 0
    tracer.Visible = false
    tracer.Parent = gui

    local near = Instance.new("TextLabel")
    near.Name = "PlayerNear"
    near.AnchorPoint = Vector2.new(0.5, 0)
    near.Size = UDim2.fromOffset(140, 22)
    near.BackgroundColor3 = Color3.fromRGB(15, 16, 24)
    near.BackgroundTransparency = 0.08
    near.TextColor3 = Color3.fromRGB(255, 255, 255)
    near.TextStrokeTransparency = 0.3
    near.Font = Enum.Font.GothamBlack
    near.TextSize = 10
    near.Visible = false
    near.Parent = gui
    local nearCorner = Instance.new("UICorner")
    nearCorner.CornerRadius = UDim.new(0, 7)
    nearCorner.Parent = near
    local nearStroke = Instance.new("UIStroke")
    nearStroke.Thickness = 1
    nearStroke.Color = Color3.fromRGB(205, 211, 242)
    nearStroke.Parent = near

    esp[player] = { gui = gui, box = box, info = info, tracer = tracer, near = near }
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if ESP_ENABLED then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    if not ESP_ENABLED then return end
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
    for player, data in pairs(esp) do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        if root and head then
            local distance = (root.Position - myRoot.Position).Magnitude
            if distance <= MAX_DISTANCE then
                local cf, size = character:GetBoundingBox()
                local corners = {
                    cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                    cf * Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
                    cf * Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
                    cf * Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
                    cf * Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
                    cf * Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
                    cf * Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
                    cf * Vector3.new( size.X/2,  size.Y/2,  size.Z/2)
                }
                local minX, minY = math.huge, math.huge
                local maxX, maxY = -math.huge, -math.huge
                local visible = false
                for _, corner in ipairs(corners) do
                    local screen, onScreen = camera:WorldToViewportPoint(corner)
                    if onScreen then
                        visible = true
                        minX = math.min(minX, screen.X)
                        minY = math.min(minY, screen.Y)
                        maxX = math.max(maxX, screen.X)
                        maxY = math.max(maxY, screen.Y)
                    end
                end
                if visible then
                    data.box.Position = UDim2.fromOffset((minX + maxX) / 2, (minY + maxY) / 2)
                    data.box.Size = UDim2.fromOffset(maxX - minX, maxY - minY)
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end

                local headScreen, headVisible = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0))
                if headVisible then
                    local velocity = root.AssemblyLinearVelocity
                    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                    data.info.Text = player.DisplayName .. "\n" .. string.format("%.1f SPD  •  %dm", speed, math.floor(distance + 0.5))
                    data.info.Position = UDim2.fromOffset(headScreen.X, headScreen.Y - 8)
                    data.info.Visible = true
                else
                    data.info.Visible = false
                end

                local targetScreen, targetVisible = camera:WorldToViewportPoint(root.Position)
                local myScreen, myVisible = camera:WorldToViewportPoint(myRoot.Position)
                if targetVisible and myVisible then
                    local dx = targetScreen.X - myScreen.X
                    local dy = targetScreen.Y - myScreen.Y
                    local length = math.sqrt(dx * dx + dy * dy)
                    data.tracer.Position = UDim2.fromOffset((targetScreen.X + myScreen.X) / 2, (targetScreen.Y + myScreen.Y) / 2)
                    data.tracer.Size = UDim2.fromOffset(length, distance <= NEAR_DISTANCE and 3 or 2)
                    data.tracer.Rotation = math.deg(math.atan2(dy, dx))
                    data.tracer.Visible = true
                else
                    data.tracer.Visible = false
                end

                if distance <= NEAR_DISTANCE and targetVisible then
                    data.near.Position = UDim2.fromOffset(targetScreen.X, targetScreen.Y + 20)
                    data.near.Text = "PLAYER NEAR • " .. math.floor(distance + 0.5) .. "m"
                    data.near.Visible = true
                else
                    data.near.Visible = false
                end
            else
                data.box.Visible = false
                data.info.Visible = false
                data.tracer.Visible = false
                data.near.Visible = false
            end
        else
            data.box.Visible = false
            data.info.Visible = false
            data.tracer.Visible = false
            data.near.Visible = false
        end
    end
end)

-- =====================
-- GUI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "SilentAimGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 20, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(0, 170, 255)
frameStroke.Thickness = 2
frameStroke.Parent = frame

local nameLabel = Instance.new("TextLabel")
nameLabel.Name = "NameLabel"
nameLabel.Size = UDim2.new(1, -10, 0, 30)
nameLabel.Position = UDim2.new(0, 5, 0, 5)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Made by FRX"
nameLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Parent = frame

-- زر Silent Aim
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 40)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.BorderSizePixel = 0
button.Text = "Silent Aim: OFF"
button.TextColor3 = Color3.fromRGB(255, 60, 60)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 60, 60)
btnStroke.Thickness = 2
btnStroke.Parent = button

-- زر ESP
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(1, -20, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 95)
espButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espButton.BorderSizePixel = 0
espButton.Text = "ESP: ON"
espButton.TextColor3 = Color3.fromRGB(60, 255, 60)
espButton.TextScaled = true
espButton.Font = Enum.Font.GothamBold
espButton.Parent = frame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

local espStroke = Instance.new("UIStroke")
espStroke.Color = Color3.fromRGB(60, 255, 60)
espStroke.Thickness = 2
espStroke.Parent = espButton

-- سحب الفريم
local dragging = false
local dragStart, startPos

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

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- تشغيل / إطفاء Silent Aim
button.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    if silentAimEnabled then
        button.Text = "Silent Aim: ON"
        button.TextColor3 = Color3.fromRGB(60, 255, 60)
        btnStroke.Color = Color3.fromRGB(60, 255, 60)
    else
        button.Text = "Silent Aim: OFF"
        button.TextColor3 = Color3.fromRGB(255, 60, 60)
        btnStroke.Color = Color3.fromRGB(255, 60, 60)
        silentAimTarget = nil
        silentAimTargetPlayer = nil
    end
end)

-- تشغيل / إطفاء ESP
espButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    if ESP_ENABLED then
        espButton.Text = "ESP: ON"
        espButton.TextColor3 = Color3.fromRGB(60, 255, 60)
        espStroke.Color = Color3.fromRGB(60, 255, 60)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        espButton.Text = "ESP: OFF"
        espButton.TextColor3 = Color3.fromRGB(255, 60, 60)
        espStroke.Color = Color3.fromRGB(255, 60, 60)
        for player, _ in pairs(esp) do
            removeESP(player)
        end
    end
end)