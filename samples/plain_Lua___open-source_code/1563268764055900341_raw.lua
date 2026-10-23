local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local autoDive = false
local lastDive = 0
local lastButton = nil
local lastTime = 0
local kickCooldownEnd = 0
local gkButtons = {}
local tenhobola = false

local COOLDOWN = 0.35
local KICK_COOLDOWN = 2.0
local MIN_VELOCITY = 12
local MAX_VELOCITY = 120
local CONTROL_DISTANCE = 8
local CONTROL_VELOCITY = 25
local LOOKAHEAD = 0.35
local MAX_DIVE_DISTANCE = 18
local MIN_DIVE_DISTANCE = 1

local SIDE_MIN = 1.8
local HIGH_HEIGHT = 2.0

local GK_NAMES = {
    "High Dive Left",
    "High Dive Right",
    "Dive Left",
    "Dive Right",
    "High Catch",
    "Low Catch",
    "Front Dive",
    "Reflex",
}

local function getCharacter()
    local character = Player.Character

    if not character then
        return nil, nil, nil
    end

    return character,
        character:FindFirstChildOfClass("Humanoid"),
        character:FindFirstChild("HumanoidRootPart")
end

local function isBall(object)
    if not object or not object:IsA("BasePart") then
        return false
    end

    if object.Anchored then
        return false
    end

    local character = Player.Character

    if character and object:IsDescendantOf(character) then
        return false
    end

    local model = object:FindFirstAncestorOfClass("Model")

    if model and model:FindFirstChildOfClass("Humanoid") then
        return false
    end

    local name = object.Name:lower()

    if name == "tps" or name == "ball" or name == "bola" then
        local size = object.Size

        if size.X >= 0.5 and size.X <= 8 then
            return true
        end
    end

    return false
end

local function getBall()
    local _, _, root = getCharacter()

    if not root then
        return nil
    end

    local closestBall = nil
    local closestDistance = math.huge

    for _, object in ipairs(Workspace:GetDescendants()) do
        if isBall(object) then
            local distance = (object.Position - root.Position).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestBall = object
            end
        end
    end

    return closestBall
end

local function markKick()
    kickCooldownEnd = tick() + KICK_COOLDOWN
end

local function hookTool(tool)
    if not tool or not tool:IsA("Tool") then
        return
    end

    local name = tool.Name:lower()

    if name:find("kick")
        or name:find("shoot")
        or name:find("ball")
        or name:find("glove")
        or name:find("chute")
        or name:find("luva") then

        pcall(function()
            tool.Activated:Connect(markKick)
        end)

        pcall(function()
            tool.Unequipped:Connect(markKick)
        end)

        pcall(function()
            tool.Equipped:Connect(markKick)
        end)
    end
end

local function hookAllTools(container)
    if not container then
        return
    end

    for _, object in ipairs(container:GetChildren()) do
        hookTool(object)
    end

    container.ChildAdded:Connect(function(child)
        task.wait(0.1)
        hookTool(child)
    end)
end

hookAllTools(Player:FindFirstChild("Backpack"))

Player.CharacterAdded:Connect(function(character)
    task.wait(1)

    hookAllTools(Player:FindFirstChild("Backpack"))

    if character then
        for _, object in ipairs(character:GetChildren()) do
            hookTool(object)
        end

        character.ChildAdded:Connect(function(child)
            task.wait(0.1)
            hookTool(child)
        end)
    end
end)

local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        local name = remote.Name:lower()

        if name:find("kick")
            or name:find("shoot")
            or name:find("chute")
            or name:find("chutar") then

            pcall(function()
                remote.OnClientEvent:Connect(markKick)
            end)
        end
    end
end

for _, object in ipairs(ReplicatedStorage:GetDescendants()) do
    hookRemote(object)
end

ReplicatedStorage.DescendantAdded:Connect(hookRemote)

local function scanButtons()
    gkButtons = {}

    local playerGui = Player:FindFirstChild("PlayerGui")

    if not playerGui then
        return
    end

    for _, object in ipairs(playerGui:GetDescendants()) do
        if object:IsA("TextButton") or object:IsA("ImageButton") then

            local text = ""

            pcall(function()
                text = object.Text
            end)

            for _, buttonName in ipairs(GK_NAMES) do
                if text:lower() == buttonName:lower() then

                    table.insert(gkButtons, {
                        Button = object,
                        Text = text,
                        Name = object.Name
                    })

                    break
                end
            end
        end
    end

    print("[unknow v0.1] GK Buttons: " .. #gkButtons)
end

local function findButton(text)
    for _, info in ipairs(gkButtons) do
        if info.Text:lower() == text:lower() then
            return info.Button
        end
    end

    return nil
end

local function clickButton(button)
    if not button then
        return false
    end

    pcall(function()
        firesignal(button.Activated)
    end)

    pcall(function()
        firesignal(button.MouseButton1Click)
    end)

    pcall(function()
        firesignal(button.MouseButton1Down)
    end)

    pcall(function()
        firesignal(button.MouseButton1Up)
    end)

    pcall(function()
        firesignal(button.TouchTap)
    end)

    return true
end

local function jump()
    local _, humanoid = getCharacter()

    if humanoid then

        pcall(function()
            humanoid.Jump = true
        end)

        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end

local function checkBallControl()
    local ball = getBall()
    local _, _, root = getCharacter()

    if not ball or not root then
        tenhobola = false
        return
    end

    local distance = (ball.Position - root.Position).Magnitude
    local velocity = ball.AssemblyLinearVelocity.Magnitude

    if distance < CONTROL_DISTANCE and velocity < CONTROL_VELOCITY then
        tenhobola = true
    else
        tenhobola = false
    end
end

local function analyze()
    if hasBall then
        return nil
    end

    local ball = getBall()
    local _, _, root = getCharacter()

    if not ball or not root then
        return nil
    end

    local velocity = ball.AssemblyLinearVelocity
    local velocityMagnitude = velocity.Magnitude
    local distance = (ball.Position - root.Position).Magnitude

    if distance > MAX_DIVE_DISTANCE then
        return nil
    end

    if distance < MIN_DIVE_DISTANCE then
        return nil
    end

    if velocityMagnitude < MIN_VELOCITY then
        return nil
    end

    if velocityMagnitude > MAX_VELOCITY then
        return nil
    end

    local horizontalVelocity =
        Vector3.new(velocity.X, 0, velocity.Z)

    if horizontalVelocity.Magnitude < 5 then
        return nil
    end

    local cameraRight = Camera.CFrame.RightVector

    local right =
        Vector3.new(
            cameraRight.X,
            0,
            cameraRight.Z
        )

    if right.Magnitude < 0.1 then
        right = Vector3.new(1, 0, 0)
    end

    right = right.Unit

    local cameraLook = Camera.CFrame.LookVector

    local forward =
        Vector3.new(
            cameraLook.X,
            0,
            cameraLook.Z
        )

    if forward.Magnitude < 0.1 then
        forward = Vector3.new(0, 0, -1)
    end

    forward = forward.Unit

    local directionToGoalkeeper =
        Vector3.new(
            root.Position.X - ball.Position.X,
            0,
            root.Position.Z - ball.Position.Z
        )

    if directionToGoalkeeper.Magnitude < 0.1 then
        return nil
    end

    directionToGoalkeeper = directionToGoalkeeper.Unit

    local dot =
        horizontalVelocity.Unit:Dot(directionToGoalkeeper)

    if dot < 0.3 then
        return nil
    end

    local time = 0

    if velocityMagnitude > 3 then
        time = distance / velocityMagnitude

        if time > LOOKAHEAD then
            time = LOOKAHEAD
        end
    end

    local futurePosition =
        ball.Position + (velocity * time)

    local currentHeight =
        ball.Position.Y - root.Position.Y

    local futureHeight =
        futurePosition.Y - root.Position.Y

    local rising = velocity.Y > 3

    local referenceHeight =
        math.max(currentHeight, futureHeight)

    local isHigh =
        referenceHeight > HIGH_HEIGHT or rising

    local delta =
        futurePosition - root.Position

    local horizontalDelta =
        Vector3.new(delta.X, 0, delta.Z)

    local side =
        horizontalDelta:Dot(right)

    local forwardDistance =
        horizontalDelta:Dot(forward)

    local absoluteSide =
        math.abs(side)

    local sideName =
        side < 0 and "Left" or "Right"

    local diveName = nil
    local needsJump = false

    if distance < 5 and velocityMagnitude > 40 then

        diveName = "Reflex"
        needsJump = true

    elseif absoluteSide < SIDE_MIN then

        if isHigh then

            if distance > 10 then
                return nil
            end

            diveName = "High Catch"
            needsJump = true

        else

            if forwardDistance < 3 and distance < 5 then
                diveName = "Front Dive"
                needsJump = true
            else
                diveName = "Low Catch"
            end
        end

    else

        if isHigh then
            diveName = "High Dive " .. sideName
            needsJump = true
        else
            diveName = "Dive " .. sideName
        end
    end

    return {
        name = diveName,
        side = side,
        height = referenceHeight,
        distance = distance,
        velocity = velocityMagnitude,
        jump = needsJump,
        isHigh = isHigh
    }
end

local function executeDive()
    local info = analyze()

    if not info or not info.name then
        return
    end

    local button = findButton(info.name)

    if not button then

        if info.name == "High Dive Left" then
            button = findButton("High Dive Right")

        elseif info.name == "High Dive Right" then
            button = findButton("High Dive Left")

        elseif info.name == "Dive Left" then
            button = findButton("Dive Right")

        elseif info.name == "Dive Right" then
            button = findButton("Dive Left")

        elseif info.name == "High Catch" then
            button = findButton("High Dive Left")

        elseif info.name == "Low Catch" then
            button = findButton("Dive Left")

        elseif info.name == "Front Dive" then
            button = findButton("Reflex")

        elseif info.name == "Reflex" then
            button = findButton("Front Dive")
        end
    end

    if not button then
        return
    end

    if button == lastButton and tick() - lastTime < 0.3 then
        return
    end

    if info.jump then
        jump()
        task.wait(0.03)
    end

    clickButton(button)

    lastButton = button
    lastTime = tick()

    print(
        string.format(
            "[unknow v0.1] %s%s | side=%.1f height=%.1f distance=%.1f velocity=%.1f",
            info.name,
            info.jump and " + JUMP" or "",
            info.side,
            info.height,
            info.distance,
            info.velocity
        )
    )
end

scanButtons()

Player.CharacterAdded:Connect(function()
    task.wait(2)
    scanButtons()
end)

--========================================================
-- RED INTERFACE
--========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "unknow v0.1"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 125)
main.Position = UDim2.new(0.5, -110, 0.5, -62)
main.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 35, 45)
mainStroke.Thickness = 2
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(150, 15, 25)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 15)
headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = Color3.fromRGB(150, 15, 25)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "unknow v0.1"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -37, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 8, 12)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 220, 220)
closeButton.Font = Enum.Font.GothamBlack
closeButton.TextScaled = true
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, -24, 0, 55)
autoButton.Position = UDim2.new(0, 12, 0, 53)
autoButton.BackgroundColor3 = Color3.fromRGB(45, 25, 28)
autoButton.Text = "AUTO DIVE: OFF"
autoButton.TextColor3 = Color3.fromRGB(255, 210, 210)
autoButton.Font = Enum.Font.GothamBlack
autoButton.TextScaled = true
autoButton.Parent = main

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 11)
autoCorner.Parent = autoButton

local autoStroke = Instance.new("UIStroke")
autoStroke.Color = Color3.fromRGB(180, 50, 60)
autoStroke.Thickness = 1.5
autoStroke.Parent = autoButton

autoButton.MouseButton1Click:Connect(function()

    autoDive = not autoDive

    if autoDive then

        autoButton.Text = "AUTO DIVE: ON"
        autoButton.BackgroundColor3 = Color3.fromRGB(190, 25, 35)
        autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoStroke.Color = Color3.fromRGB(255, 90, 100)

    else

        autoButton.Text = "AUTO DIVE: OFF"
        autoButton.BackgroundColor3 = Color3.fromRGB(45, 25, 28)
        autoButton.TextColor3 = Color3.fromRGB(255, 210, 210)
        autoStroke.Color = Color3.fromRGB(180, 50, 60)

    end
end)

--========================================================
-- FLOATING OPEN BUTTON
--========================================================

local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.new(0, 58, 0, 58)
floatingButton.Position = UDim2.new(0, 18, 0.5, -29)
floatingButton.BackgroundColor3 = Color3.fromRGB(170, 20, 30)
floatingButton.Text = "GK"
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.TextScaled = true
floatingButton.Font = Enum.Font.GothamBlack
floatingButton.Visible = false
floatingButton.Parent = gui

local floatingCorner = Instance.new("UICorner")
floatingCorner.CornerRadius = UDim.new(1, 0)
floatingCorner.Parent = floatingButton

local floatingStroke = Instance.new("UIStroke")
floatingStroke.Color = Color3.fromRGB(255, 60, 70)
floatingStroke.Thickness = 2.5
floatingStroke.Parent = floatingButton

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
    floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
    main.Visible = true
    floatingButton.Visible = false
end)

--========================================================
-- RIGHT SHIFT TO OPEN/CLOSE
--========================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then

        main.Visible = not main.Visible
        floatingButton.Visible = not main.Visible

    end
end)

--========================================================
-- AUTO DIVE
--========================================================

RunService.RenderStepped:Connect(function()

    checkBallControl()

    if not autoDive then
        return
    end

    if tenhobola then
        return
    end

    if tick() < kickCooldownEnd then
        return
    end

    if tick() - lastDive < COOLDOWN then
        return
    end

    local info = analyze()

    if not info then
        return
    end

    lastDive = tick()

    task.spawn(executeDive)
end)

task.spawn(function()

    while task.wait(3) do

        if #gkButtons == 0 then
            scanButtons()
        end

    end

end)

print("[unknow v0.1] Red interface loaded successfully!")