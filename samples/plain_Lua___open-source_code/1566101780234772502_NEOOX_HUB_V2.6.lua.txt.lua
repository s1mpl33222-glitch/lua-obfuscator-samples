-- NEOOX HUB
-- Client-side Roblox Lua script

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GUI_NAME = "NEOOXHubGui"
local TRACK_INTERVAL = 0.5
local KEEP_DISTANCE = 2.5
local MAX_TARGET_DISTANCE = 50

if CoreGui:FindFirstChild(GUI_NAME) then
    CoreGui[GUI_NAME]:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- NEOOX HUB | redesigned interface
local UserInputService = game:GetService("UserInputService")

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function addStroke(object, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = object
    return stroke
end

local ACCENT = Color3.fromRGB(0, 220, 190)
local PANEL = Color3.fromRGB(13, 18, 24)
local PANEL2 = Color3.fromRGB(21, 29, 37)
local MUTED = Color3.fromRGB(145, 160, 170)

-- Access screen
local keyFrame = Instance.new("Frame")
keyFrame.Name = "AccessCode"
keyFrame.Size = UDim2.new(0, 290, 0, 220)
keyFrame.Position = UDim2.new(0.5, -145, 0.5, -110)
keyFrame.BackgroundColor3 = PANEL
keyFrame.BorderSizePixel = 0
keyFrame.Parent = gui
addCorner(keyFrame, 18)
addStroke(keyFrame, ACCENT, 1.5, 0.15)

local keyTop = Instance.new("Frame")
keyTop.Size = UDim2.new(1, 0, 0, 7)
keyTop.BackgroundColor3 = ACCENT
keyTop.BorderSizePixel = 0
keyTop.Parent = keyFrame
addCorner(keyTop, 8)

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -28, 0, 42)
keyTitle.Position = UDim2.new(0, 14, 0, 23)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "NEOOX  /  ACCESS"
keyTitle.TextColor3 = Color3.new(1, 1, 1)
keyTitle.TextSize = 20
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.Parent = keyFrame

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(1, -28, 0, 22)
keyHint.Position = UDim2.new(0, 14, 0, 64)
keyHint.BackgroundTransparency = 1
keyHint.Text = "Enter your access key to continue"
keyHint.TextColor3 = MUTED
keyHint.TextSize = 12
keyHint.Font = Enum.Font.Gotham
keyHint.TextXAlignment = Enum.TextXAlignment.Left
keyHint.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Name = "CodeInput"
keyBox.Size = UDim2.new(1, -28, 0, 42)
keyBox.Position = UDim2.new(0, 14, 0, 99)
keyBox.BackgroundColor3 = PANEL2
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "ACCESS KEY"
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.PlaceholderColor3 = MUTED
keyBox.TextSize = 14
keyBox.Font = Enum.Font.GothamMedium
keyBox.Parent = keyFrame
addCorner(keyBox, 10)
addStroke(keyBox, Color3.fromRGB(55, 75, 85), 1, 0.2)

local keyButton = Instance.new("TextButton")
keyButton.Name = "UnlockButton"
keyButton.Size = UDim2.new(1, -28, 0, 38)
keyButton.Position = UDim2.new(0, 14, 0, 158)
keyButton.BackgroundColor3 = ACCENT
keyButton.BorderSizePixel = 0
keyButton.Text = "ENTER HUB  →"
keyButton.TextColor3 = Color3.fromRGB(5, 18, 20)
keyButton.TextSize = 14
keyButton.Font = Enum.Font.GothamBlack
keyButton.Parent = keyFrame
addCorner(keyButton, 10)

-- Main dashboard
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 320, 0, 310)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -155)
mainFrame.BackgroundColor3 = PANEL
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
mainFrame.Visible = false
addCorner(mainFrame, 18)
addStroke(mainFrame, ACCENT, 1.4, 0.25)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 72)
topBar.BackgroundColor3 = Color3.fromRGB(18, 28, 35)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
addCorner(topBar, 18)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -70, 0, 30)
titleLabel.Position = UDim2.new(0, 18, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "NEOOX HUB"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -70, 0, 18)
subtitleLabel.Position = UDim2.new(0, 19, 0, 42)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "CONTROL CENTER  •  V2.6"
subtitleLabel.TextColor3 = ACCENT
subtitleLabel.TextSize = 10
subtitleLabel.Font = Enum.Font.GothamBold
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -44, 0, 20)
closeButton.BackgroundColor3 = Color3.fromRGB(38, 49, 57)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 22
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar
addCorner(closeButton, 9)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(1, -32, 0, 22)
sectionLabel.Position = UDim2.new(0, 16, 0, 88)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Text = "MOVEMENT & PLAYER TOOLS"
sectionLabel.TextColor3 = MUTED
sectionLabel.TextSize = 10
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
sectionLabel.Parent = mainFrame

local function makeFeatureButton(name, text, y)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -32, 0, 48)
    button.Position = UDim2.new(0, 16, 0, y)
    button.BackgroundColor3 = PANEL2
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(235, 242, 245)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = mainFrame
    addCorner(button, 11)
    addStroke(button, Color3.fromRGB(55, 75, 85), 1, 0.35)
    return button
end

local assistButton = makeFeatureButton("TrackingButton", "◎   TRACKING  •  OFF", 119)
local wallHopButton = makeFeatureButton("WallHopButton", "↗   WALL HOP  •  OFF", 177)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -32, 0, 34)
statusLabel.Position = UDim2.new(0, 16, 0, 239)
statusLabel.BackgroundColor3 = Color3.fromRGB(18, 28, 35)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "STATUS  /  STANDBY"
statusLabel.TextColor3 = MUTED
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Parent = mainFrame
addCorner(statusLabel, 9)

-- Notification
local notifyFrame = Instance.new("Frame")
notifyFrame.Name = "Notification"
notifyFrame.Size = UDim2.new(0, 250, 0, 48)
notifyFrame.Position = UDim2.new(0.5, -125, 0.78, 0)
notifyFrame.BackgroundColor3 = PANEL
notifyFrame.BackgroundTransparency = 1
notifyFrame.BorderSizePixel = 0
notifyFrame.Visible = false
notifyFrame.Parent = gui
addCorner(notifyFrame, 12)

local notifyStroke = addStroke(notifyFrame, ACCENT, 1.5, 1)

local notifyLabel = Instance.new("TextLabel")
notifyLabel.Size = UDim2.new(1, 0, 1, 0)
notifyLabel.BackgroundTransparency = 1
notifyLabel.Text = "NEOOX HUB  /  TARGET LOCKED"
notifyLabel.TextColor3 = Color3.new(1, 1, 1)
notifyLabel.TextTransparency = 1
notifyLabel.TextSize = 13
notifyLabel.Font = Enum.Font.GothamBold
notifyLabel.Parent = notifyFrame

local trackingEnabled = false
local notificationVisible = false
local currentTargetPlayer = nil
local trackingStartAt = 0
local targetHighlight = nil
local targetBillboard = nil

local function showNotification(show)
    if show and not notificationVisible then
        notificationVisible = true
        notifyFrame.Visible = true
        TweenService:Create(notifyFrame, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.2,
        }):Play()
        TweenService:Create(notifyLabel, TweenInfo.new(0.25), {
            TextTransparency = 0,
        }):Play()
        TweenService:Create(notifyStroke, TweenInfo.new(0.25), {
            Transparency = 0.15,
        }):Play()
    elseif not show and notificationVisible then
        notificationVisible = false
        TweenService:Create(notifyFrame, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(notifyLabel, TweenInfo.new(0.25), {
            TextTransparency = 1,
        }):Play()
        TweenService:Create(notifyStroke, TweenInfo.new(0.25), {
            Transparency = 1,
        }):Play()
        task.delay(0.27, function()
            if not notificationVisible and notifyFrame.Parent then
                notifyFrame.Visible = false
            end
        end)
    end
end

local function clearTargetVisuals()
    if targetHighlight then
        targetHighlight:Destroy()
        targetHighlight = nil
    end
    if targetBillboard then
        targetBillboard:Destroy()
        targetBillboard = nil
    end
end

local function clearTarget()
    currentTargetPlayer = nil
    trackingStartAt = 0
    clearTargetVisuals()
end

local function isGreen(color)
    return color.G >= 0.65 and color.R <= 0.45 and color.B <= 0.45
end

-- Detects a small green BasePart placed near the character's body as the green center dot.
-- If the game draws its dot only on the screen (outside the character model), this marker
-- needs to be identified from that game's own UI instead.
local function hasGreenCenterDot(character, rootPart)
    for _, item in ipairs(character:GetDescendants()) do
        if item:IsA("BasePart") then
            local name = string.lower(item.Name)
            local namedMarker = string.find(name, "greendot", 1, true) ~= nil
                or string.find(name, "green_dot", 1, true) ~= nil
            local isSmall = item.Size.Magnitude <= 1.5
            local isNearCenter = (item.Position - rootPart.Position).Magnitude <= 2.5
            if namedMarker or (isSmall and isNearCenter and isGreen(item.Color)) then
                return true
            end
        end
    end
    return false
end

local function isBombTool(tool)
    if not tool or not tool:IsA("Tool") then
        return false
    end
    if tool:GetAttribute("IsBomb") == true then
        return true
    end
    local toolName = string.lower(tool.Name)
    return string.find(toolName, "bomb", 1, true) ~= nil
        or string.find(toolName, "قنبلة", 1, true) ~= nil
end

-- The bomb must be equipped by the local character; tools merely stored in Backpack do not count.
local function hasBombEquipped()
    local character = LocalPlayer.Character
    if not character then
        return false
    end
    for _, item in ipairs(character:GetChildren()) do
        if isBombTool(item) then
            return true
        end
    end
    return false
end

local function getNearestEligiblePlayer()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return nil
    end

    local nearestPlayer = nil
    local closestDistance = math.huge

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local otherCharacter = otherPlayer.Character
            local otherRoot = otherCharacter:FindFirstChild("HumanoidRootPart")
            local otherHumanoid = otherCharacter:FindFirstChildOfClass("Humanoid")

            if otherRoot and otherHumanoid and otherHumanoid.Health > 0
                and not hasGreenCenterDot(otherCharacter, otherRoot) then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                if distance < closestDistance and distance <= MAX_TARGET_DISTANCE then
                    closestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end

    return nearestPlayer
end

local function showTargetMark(player)
    clearTargetVisuals()
    local character = player and player.Character
    if not character then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NEOOXTargetHighlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 35, 35)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    targetHighlight = highlight

    local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NEOOXTargetLabel"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 110, 0, 32)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundColor3 = Color3.fromRGB(190, 15, 25)
        label.BackgroundTransparency = 0.08
        label.BorderSizePixel = 0
        label.Text = "الهدف"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 17
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = label
        targetBillboard = billboard
    end
end

local function submitAccessCode()
    if keyBox.Text == "." then
        keyFrame.Visible = false
        mainFrame.Visible = true
    else
        keyBox.Text = ""
        keyBox.PlaceholderText = "Incorrect code"
    end
end

keyButton.MouseButton1Click:Connect(submitAccessCode)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitAccessCode()
    end
end)

assistButton.MouseButton1Click:Connect(function()
    trackingEnabled = not trackingEnabled
    showNotification(false)

    if trackingEnabled then
        assistButton.BackgroundColor3 = Color3.fromRGB(0, 105, 95)
        assistButton.Text = "◎   TRACKING  •  ON"
        statusLabel.Text = "STATUS  /  WAITING FOR BOMB"
    else
        assistButton.BackgroundColor3 = PANEL2
        assistButton.Text = "◎   TRACKING  •  OFF"
        statusLabel.Text = "STATUS  /  STANDBY"
        clearTarget()
    end
end)

-- Wall hop: jump again while airborne and close to a wall.
local wallHopEnabled = false
local lastWallHop = 0
local WALL_HOP_COOLDOWN = 0.28
local WALL_CHECK_DISTANCE = 3

wallHopButton.MouseButton1Click:Connect(function()
    wallHopEnabled = not wallHopEnabled
    wallHopButton.Text = wallHopEnabled and "↗   WALL HOP  •  ON" or "↗   WALL HOP  •  OFF"
    wallHopButton.BackgroundColor3 = wallHopEnabled and Color3.fromRGB(0, 105, 95) or PANEL2
    statusLabel.Text = wallHopEnabled and "STATUS  /  WALL HOP ENABLED" or "STATUS  /  STANDBY"
end)

UserInputService.JumpRequest:Connect(function()
    if not wallHopEnabled or os.clock() - lastWallHop < WALL_HOP_COOLDOWN then
        return
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart or humanoid.FloorMaterial ~= Enum.Material.Air then
        return
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}

    local right = rootPart.CFrame.RightVector
    local directions = {right, -right}
    for _, direction in ipairs(directions) do
        local hit = workspace:Raycast(rootPart.Position, direction * WALL_CHECK_DISTANCE, params)
        if hit and math.abs(hit.Normal.Y) < 0.25 then
            lastWallHop = os.clock()
            local velocity = rootPart.AssemblyLinearVelocity
            rootPart.AssemblyLinearVelocity = Vector3.new(
                velocity.X + hit.Normal.X * 22,
                42,
                velocity.Z + hit.Normal.Z * 22
            )
            break
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not trackingEnabled then
        return
    end

    -- Select a target only while the bomb tool is equipped.
    if not hasBombEquipped() then
        clearTarget()
        statusLabel.Text = "STATUS  /  WAITING FOR BOMB"
        showNotification(false)
        return
    end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid or humanoid.Health <= 0 then
        clearTarget()
        return
    end

    if currentTargetPlayer then
        local targetCharacter = currentTargetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")

        if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0
            or (rootPart.Position - targetRoot.Position).Magnitude > MAX_TARGET_DISTANCE
            or hasGreenCenterDot(targetCharacter, targetRoot) then
            clearTarget()
        end
    end

    if not currentTargetPlayer then
        local nearestPlayer = getNearestEligiblePlayer()
        if nearestPlayer then
            currentTargetPlayer = nearestPlayer
                    trackingStartAt = os.clock() + TRACK_INTERVAL
            showTargetMark(nearestPlayer)
            statusLabel.Text = "STATUS  /  TARGET ACQUIRED"
            showNotification(true)
            task.delay(1.2, function()
                showNotification(false)
            end)
        else
            statusLabel.Text = "STATUS  /  NO VALID TARGET"
            return
        end
    end

    -- Wait 0.5 seconds once after selecting the target, then track continuously.
    if os.clock() >= trackingStartAt then
        local targetCharacter = currentTargetPlayer and currentTargetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            -- Keep the player's root about 2.5 studs from the target instead of
            -- walking into the target's center. Tracking continues every frame
            -- after the one-time 0.5 second acquisition delay.
            local awayFromTarget = rootPart.Position - targetRoot.Position
            local direction
            if awayFromTarget.Magnitude > 0.001 then
                direction = awayFromTarget.Unit
            else
                direction = Vector3.new(1, 0, 0)
            end
            local desiredPosition = targetRoot.Position + direction * KEEP_DISTANCE
            humanoid:MoveTo(desiredPosition)
        else
            clearTarget()
        end
    end

    -- Deliberately no camera, head, or HumanoidRootPart rotation toward the target.
end)
