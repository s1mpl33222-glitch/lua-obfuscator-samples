local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local character
local rootPart
local humanoid
local dashVelocity = nil

local featureEnabled = true
local pullConnection = nil
local animConnection = nil
local childAddedConnection = nil

local npcList = {}
local lastNpcUpdate = 0
local TP_DELAY = 0.24 -- default 0.24

local function updateNpcCache()
    npcList = {}
    if not rootPart then return end
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local root = model.HumanoidRootPart
            if root ~= rootPart then
                table.insert(npcList, root)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if tick() - lastNpcUpdate > 0.5 then
        lastNpcUpdate = tick()
        updateNpcCache()
    end
end)

local function getClosestTarget()
    if not rootPart then return nil end
    local closestRoot = nil
    local shortestDistance = math.huge
    local myPos = rootPart.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (myPos - root.Position).Magnitude
                if dist < shortestDistance and dist > 0.1 then
                    shortestDistance = dist
                    closestRoot = root
                end
            end
        end
    end
    for _, npcRoot in ipairs(npcList) do
        if npcRoot and npcRoot.Parent then
            local dist = (myPos - npcRoot.Position).Magnitude
            if dist < shortestDistance and dist > 0.1 then
                shortestDistance = dist
                closestRoot = npcRoot
            end
        end
    end
    return closestRoot
end

local function startMagnetPull()
    if pullConnection then pullConnection:Disconnect() end
    local startTime = tick()
    local pullDuration = 0.200
    local pullStrength = 50
    local smoothness = 0.65
    pullConnection = RunService.Heartbeat:Connect(function()
        if not rootPart or not rootPart.Parent then
            pullConnection:Disconnect()
            pullConnection = nil
            return
        end
        local elapsed = tick() - startTime
        if elapsed >= pullDuration then
            pullConnection:Disconnect()
            pullConnection = nil
            return
        end
        local targetRoot = getClosestTarget()
        if not targetRoot then return end
        local currentPos = rootPart.Position
        local targetHorizontal = Vector3.new(targetRoot.Position.X, currentPos.Y, targetRoot.Position.Z)
        local direction = (targetHorizontal - currentPos)
        local distance = direction.Magnitude
        if distance > 1 then
            direction = direction.Unit
            local desiredVel = direction * pullStrength
            local currentVel = rootPart.AssemblyLinearVelocity
            local newVel = currentVel:Lerp(desiredVel, smoothness)
            rootPart.AssemblyLinearVelocity = Vector3.new(newVel.X * 0.85, currentVel.Y, newVel.Z * 0.85)
        end
    end)
end

local function doTPAndStick()
    if not featureEnabled then return end
    if not rootPart or not character then return end
    local targetRoot = getClosestTarget()
    if not targetRoot then return end
    local distance = (rootPart.Position - targetRoot.Position).Magnitude
    if distance > 6 then return end
    task.wait(TP_DELAY)
    if not rootPart or not rootPart.Parent then return end
    local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
    rootPart.CFrame = CFrame.new(targetPos)
    if dashVelocity and dashVelocity.Parent then
        dashVelocity:Destroy()
        dashVelocity = nil
    end
    if rootPart then
        local vel = rootPart.AssemblyLinearVelocity
        rootPart.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
    end
    startMagnetPull()
end

local function setupCharacter(newChar)
    character = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart", 10)
    humanoid = newChar:WaitForChild("Humanoid", 10)
    dashVelocity = nil
    if animConnection then animConnection:Disconnect() animConnection = nil end
    if childAddedConnection then childAddedConnection:Disconnect() childAddedConnection = nil end
    if pullConnection then pullConnection:Disconnect() pullConnection = nil end
    if not rootPart or not humanoid then return end
    childAddedConnection = rootPart.ChildAdded:Connect(function(child)
        if child:IsA("BodyVelocity") or child:IsA("LinearVelocity") then
            dashVelocity = child
        end
    end)
    animConnection = humanoid.AnimationPlayed:Connect(function(animTrack)
        local id = animTrack.Animation.AnimationId
        if id:find("10479335397") or id:find("13380255751") then
            task.wait(0.05)
            doTPAndStick()
        end
    end)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

if game:GetService("CoreGui"):FindFirstChild("SolitudeUI") then
    game:GetService("CoreGui").SolitudeUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolitudeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 110)
Main.Position = UDim2.new(0.5, -90, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Solitude"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.45, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Text = "ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Main
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(0.45, 0, 0, 30)
DelayBox.Position = UDim2.new(0.5, 0, 0.32, 0)
DelayBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DelayBox.Text = "0.24"
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.TextScaled = true
DelayBox.Font = Enum.Font.GothamBold
DelayBox.PlaceholderText = "Delay (0-1)"
DelayBox.Parent = Main
Instance.new("UICorner", DelayBox).CornerRadius = UDim.new(0, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    featureEnabled = not featureEnabled
    ToggleBtn.Text = featureEnabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = featureEnabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(100, 100, 100)
end)

DelayBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(DelayBox.Text)
        if num then
            TP_DELAY = math.clamp(num, 0, 1)
            DelayBox.Text = string.format("%.2f", TP_DELAY)
        else
            DelayBox.Text = string.format("%.2f", TP_DELAY)
        end
    end
end)

print("Solitude Loaded - 0.24 Delay - Fixed respawn")