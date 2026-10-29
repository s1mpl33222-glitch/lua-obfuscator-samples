local function showError(msg)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.ResetOnSpawn = false
        g.DisplayOrder = 9999
        g.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.9, 0, 0.6, 0)
        l.Position = UDim2.new(0.05, 0, 0.1, 0)
        l.BackgroundColor3 = Color3.new(0, 0, 0)
        l.TextColor3 = Color3.fromRGB(255, 120, 120)
        l.TextWrapped = true
        l.TextSize = 14
        l.TextYAlignment = Enum.TextYAlignment.Top
        l.Text = "ERRO:\n" .. tostring(msg)
        l.Parent = g
    end)
end

local ranOk, ranErr = xpcall(function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local autoDive, autoCatch = false, false
local lastDive, lastCatch, lastButton, lastTime = 0, 0, nil, 0
local kickEnd = 0
local gkButtons = {}
local tenhobola = false

local COOLDOWN, KICK_COOLDOWN = 0.35, 2.0
local MIN_VELOCITY, MAX_VELOCITY = 12, 120
local CONTROL_DISTANCE, CONTROL_VELOCITY = 8, 25
local LOOKAHEAD = 0.35
local MAX_DIVE_DISTANCE, MIN_DIVE_DISTANCE = 18, 1
local SIDE_MIN, HIGH_HEIGHT = 1.8, 2.0

-- AUTO CATCH
local CATCH_DISTANCE = 10
local CATCH_MIN_VELOCITY = 6
local CATCH_COOLDOWN = 0.4

local GK_NAMES = {
    "High Dive Left", "High Dive Right", "Dive Left", "Dive Right",
    "High Catch", "Low Catch", "Front Dive", "Reflex",
}

local function getChar()
    local c = Player.Character
    if not c then return nil, nil, nil end
    return c, c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end

-- BOLA (renova sozinha) ----------------------------------------
local ball, lastFind = nil, 0

local function isBall(o)
    if not o or not o:IsA("BasePart") or o.Anchored then return false end
    local c = Player.Character
    if c and o:IsDescendantOf(c) then return false end
    local m = o:FindFirstAncestorOfClass("Model")
    if m and m:FindFirstChildOfClass("Humanoid") then return false end
    local n = string.lower(o.Name)
    if n == "tps" or n == "ball" or n == "bola" then
        return o.Size.X >= 0.5 and o.Size.X <= 8
    end
    return false
end

local function findBall()
    local _, _, root = getChar()
    local best, bestD = nil, math.huge
    for _, o in ipairs(Workspace:GetDescendants()) do
        if isBall(o) then
            local d = root and (o.Position - root.Position).Magnitude or 0
            if d < bestD then best, bestD = o, d end
        end
    end
    return best
end

local function getBall()
    local valid = ball and ball:IsDescendantOf(Workspace) and not ball.Anchored
    if valid and tick() - lastFind < 2 then
        return ball
    end
    if tick() - lastFind < 0.5 then
        return valid and ball or nil
    end
    lastFind = tick()
    ball = findBall()
    return ball
end

-- CHUTE ---------------------------------------------------------
local function markKick() kickEnd = tick() + KICK_COOLDOWN end

local function hookTool(tool)
    if not (tool and tool:IsA("Tool")) then return end
    local n = string.lower(tool.Name)
    if n:find("kick") or n:find("shoot") or n:find("ball")
        or n:find("glove") or n:find("chute") or n:find("luva") then
        pcall(function() tool.Activated:Connect(markKick) end)
        pcall(function() tool.Unequipped:Connect(markKick) end)
        pcall(function() tool.Equipped:Connect(markKick) end)
    end
end

local function hookAll(container)
    if not container then return end
    for _, o in ipairs(container:GetChildren()) do hookTool(o) end
    container.ChildAdded:Connect(function(child)
        task.wait(0.1)
        hookTool(child)
    end)
end

local function hookRemote(r)
    if r:IsA("RemoteEvent") then
        local n = string.lower(r.Name)
        if n:find("kick") or n:find("shoot") or n:find("chute") or n:find("chutar") then
            pcall(function() r.OnClientEvent:Connect(markKick) end)
        end
    end
end

pcall(function()
    for _, o in ipairs(ReplicatedStorage:GetDescendants()) do hookRemote(o) end
    ReplicatedStorage.DescendantAdded:Connect(hookRemote)
end)

-- BOTOES DO GOLEIRO (renovam sozinhos) -------------------------
local function scanButtons()
    local found = {}
    local pg = Player:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextButton") then
            local t = string.lower(o.Text)
            for _, n in ipairs(GK_NAMES) do
                if t == string.lower(n) then
                    local key = string.lower(n)
                    local old = found[key]
                    if not old or (o.Visible and not old.Visible) then
                        found[key] = o
                    end
                    break
                end
            end
        end
    end
    gkButtons = found
end

local lastScan = 0
local function findButton(name)
    if tick() - lastScan > 1 then
        lastScan = tick()
        scanButtons()
    end
    local key = string.lower(name)
    local b = gkButtons[key]
    if b and not b:IsDescendantOf(Player) then
        scanButtons()
        b = gkButtons[key]
    end
    return b
end

local function clickButton(b)
    if not b then return end
    for _, sig in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down", "MouseButton1Up", "TouchTap" }) do
        pcall(function() firesignal(b[sig]) end)
    end
end

local function jump()
    local _, hum = getChar()
    if hum then
        pcall(function() hum.Jump = true end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end

local function checkBallControl()
    local b = getBall()
    local _, _, root = getChar()
    if not b or not root then
        tenhobola = false
        return
    end
    local d = (b.Position - root.Position).Magnitude
    tenhobola = d < CONTROL_DISTANCE and b.AssemblyLinearVelocity.Magnitude < CONTROL_VELOCITY
end

-- AUTO DIVE ----------------------------------------------------
local function analyze()
    local b = getBall()
    local _, _, root = getChar()
    local cam = Workspace.CurrentCamera
    if not (b and root and cam) then return nil end

    local vel = b.AssemblyLinearVelocity
    local speed = vel.Magnitude
    local distance = (b.Position - root.Position).Magnitude

    if distance > MAX_DIVE_DISTANCE or distance < MIN_DIVE_DISTANCE then return nil end
    if speed < MIN_VELOCITY or speed > MAX_VELOCITY then return nil end

    local hv = Vector3.new(vel.X, 0, vel.Z)
    if hv.Magnitude < 5 then return nil end

    local r = cam.CFrame.RightVector
    local right = Vector3.new(r.X, 0, r.Z)
    if right.Magnitude < 0.1 then right = Vector3.new(1, 0, 0) end
    right = right.Unit

    local l = cam.CFrame.LookVector
    local forward = Vector3.new(l.X, 0, l.Z)
    if forward.Magnitude < 0.1 then forward = Vector3.new(0, 0, -1) end
    forward = forward.Unit

    local toGk = Vector3.new(root.Position.X - b.Position.X, 0, root.Position.Z - b.Position.Z)
    if toGk.Magnitude < 0.1 then return nil end
    if hv.Unit:Dot(toGk.Unit) < 0.3 then return nil end

    local t = math.min(distance / speed, LOOKAHEAD)
    local future = b.Position + vel * t

    local refH = math.max(b.Position.Y - root.Position.Y, future.Y - root.Position.Y)
    local isHigh = refH > HIGH_HEIGHT or vel.Y > 3

    local delta = future - root.Position
    local hd = Vector3.new(delta.X, 0, delta.Z)
    local side = hd:Dot(right)
    local fwd = hd:Dot(forward)
    local sideName = side < 0 and "Left" or "Right"

    local name, needsJump = nil, false
    if distance < 5 and speed > 40 then
        name, needsJump = "Reflex", true
    elseif math.abs(side) < SIDE_MIN then
        if isHigh then
            if distance > 10 then return nil end
            name, needsJump = "High Catch", true
        elseif fwd < 3 and distance < 5 then
            name, needsJump = "Front Dive", true
        else
            name = "Low Catch"
        end
    elseif isHigh then
        name, needsJump = "High Dive " .. sideName, true
    else
        name = "Dive " .. sideName
    end

    return { name = name, side = side, height = refH, distance = distance, velocity = speed, jump = needsJump }
end

local FALLBACK = {
    ["High Dive Left"] = "High Dive Right",
    ["High Dive Right"] = "High Dive Left",
    ["Dive Left"] = "Dive Right",
    ["Dive Right"] = "Dive Left",
    ["High Catch"] = "High Dive Left",
    ["Low Catch"] = "Dive Left",
    ["Front Dive"] = "Reflex",
    ["Reflex"] = "Front Dive",
}

local function executeDive()
    local info = analyze()
    if not (info and info.name) then return end

    local button = findButton(info.name)
    if not button and FALLBACK[info.name] then
        button = findButton(FALLBACK[info.name])
    end
    if not button then return end
    if button == lastButton and tick() - lastTime < 0.3 then return end

    if info.jump then
        jump()
        task.wait(0.03)
    end

    clickButton(button)
    lastButton, lastTime = button, tick()

    print(string.format("[GK] %s%s | side=%.1f h=%.1f dist=%.1f vel=%.1f",
        info.name, info.jump and " +JUMP" or "", info.side, info.height, info.distance, info.velocity))
end

-- AUTO CATCH ---------------------------------------------------
local function analyzeCatch()
    local b = getBall()
    local _, _, root = getChar()
    if not (b and root) then return nil end

    local vel = b.AssemblyLinearVelocity
    local speed = vel.Magnitude
    local distance = (b.Position - root.Position).Magnitude

    if distance > CATCH_DISTANCE then return nil end
    if speed < CATCH_MIN_VELOCITY or speed > MAX_VELOCITY then return nil end

    local hv = Vector3.new(vel.X, 0, vel.Z)
    local toGk = Vector3.new(root.Position.X - b.Position.X, 0, root.Position.Z - b.Position.Z)
    if hv.Magnitude > 3 and toGk.Magnitude > 0.1 then
        if hv.Unit:Dot(toGk.Unit) < 0.3 then return nil end
    end

    local t = math.min(distance / math.max(speed, 1), LOOKAHEAD)
    local future = b.Position + vel * t
    local refH = math.max(b.Position.Y - root.Position.Y, future.Y - root.Position.Y)
    local isHigh = refH > HIGH_HEIGHT or vel.Y > 3

    return {
        name = isHigh and "High Catch" or "Low Catch",
        jump = isHigh,
        height = refH,
        distance = distance,
        velocity = speed,
    }
end

local function executeCatch(info)
    if not (info and info.name) then return end

    local button = findButton(info.name)
    if not button then
        button = findButton(info.name == "High Catch" and "Low Catch" or "High Catch")
    end
    if not button then return end
    if button == lastButton and tick() - lastTime < 0.25 then return end

    if info.jump then
        jump()
        task.wait(0.03)
    end

    clickButton(button)
    lastButton, lastTime = button, tick()

    print(string.format("[GK] AUTO CATCH %s%s | h=%.1f dist=%.1f vel=%.1f",
        info.name, info.jump and " +JUMP" or "", info.height, info.distance, info.velocity))
end

-- RENASCER / NOVA PARTIDA --------------------------------------
local function refreshAll()
    ball = nil
    lastFind = 0
    lastScan = 0
    kickEnd = 0
    lastButton = nil
    scanButtons()
end

pcall(function()
    hookAll(Player:FindFirstChild("Backpack"))
    if Player.Character then hookAll(Player.Character) end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    pcall(function()
        hookAll(Player:FindFirstChild("Backpack"))
        hookAll(char)
    end)
    refreshAll()
end)

-- se o jogo recriar a tela de botoes, escaneia de novo
pcall(function()
    local pg = Player:WaitForChild("PlayerGui")
    pg.DescendantAdded:Connect(function(o)
        if o:IsA("TextButton") then
            task.defer(function()
                lastScan = 0
            end)
        end
    end)
end)

scanButtons()

-- INTERFACE ----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "unknow v0.1"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999

local parented = pcall(function()
    gui.Parent = Player:WaitForChild("PlayerGui", 5)
end)
if not parented or not gui.Parent then
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 190)
main.Position = UDim2.new(0.5, -110, 0.5, -95)
main.BackgroundColor3 = Color3.fromRGB(22, 12, 14)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 35, 45)
mainStroke.Thickness = 2

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(150, 15, 25)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

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
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

local function makeToggle(label, y, onChange)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 55)
    button.Position = UDim2.new(0, 12, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(45, 25, 28)
    button.Text = label .. ": OFF"
    button.TextColor3 = Color3.fromRGB(255, 210, 210)
    button.Font = Enum.Font.GothamBlack
    button.TextScaled = true
    button.Parent = main
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(180, 50, 60)
    stroke.Thickness = 1.5

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = label .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(190, 25, 35)
            button.TextColor3 = Color3.new(1, 1, 1)
            stroke.Color = Color3.fromRGB(255, 90, 100)
        else
            button.Text = label .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(45, 25, 28)
            button.TextColor3 = Color3.fromRGB(255, 210, 210)
            stroke.Color = Color3.fromRGB(180, 50, 60)
        end
        onChange(state)
    end)
end

makeToggle("AUTO DIVE", 53, function(v) autoDive = v end)
makeToggle("AUTO CATCH", 118, function(v) autoCatch = v end)

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
Instance.new("UICorner", floatingButton).CornerRadius = UDim.new(1, 0)

local floatingStroke = Instance.new("UIStroke", floatingButton)
floatingStroke.Color = Color3.fromRGB(255, 60, 70)
floatingStroke.Thickness = 2.5

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
    floatingButton.Visible = true
end)

floatingButton.MouseButton1Click:Connect(function()
    main.Visible = true
    floatingButton.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        floatingButton.Visible = not main.Visible
    end
end)

-- LOOP PRINCIPAL -----------------------------------------------
RunService.RenderStepped:Connect(function()
    local ok = pcall(function()
        checkBallControl()

        if tenhobola then return end
        if tick() < kickEnd then return end

        if autoCatch and tick() - lastCatch >= CATCH_COOLDOWN then
            local ci = analyzeCatch()
            if ci then
                lastCatch = tick()
                lastDive = tick()
                task.spawn(executeCatch, ci)
                return
            end
        end

        if not autoDive then return end
        if tick() - lastDive < COOLDOWN then return end
        if not analyze() then return end

        lastDive = tick()
        task.spawn(executeDive)
    end)
end)

-- reescaneia os botoes sempre (nao so quando a lista esta vazia)
task.spawn(function()
    while task.wait(3) do
        pcall(scanButtons)
    end
end)

print("[GK] Carregado!")

end, function(e) return tostring(e) end)

if not ranOk then showError(ranErr) end