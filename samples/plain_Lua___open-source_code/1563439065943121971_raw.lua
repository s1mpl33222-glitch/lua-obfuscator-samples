task.spawn(function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local AntiRagdollConns = {}

local function reEnableControls()
    pcall(function()
        require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable()
    end)
end

local function cleanConstraints(char, animator)
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint") then
            obj:Destroy()
        elseif obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B") then
            obj:Destroy()
        elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
            obj:Destroy()
        elseif obj:IsA("Motor6D") then
            obj.Enabled = true
        end
    end
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local name = (track.Animation and track.Animation.Name or ""):lower()
            if name:find("rag") or name:find("fall") or name:find("hurt") or name:find("down") then
                track:Stop(0)
            end
        end
    end
end

local function enableAntiRagdoll()
    for _, c in pairs(AntiRagdollConns) do pcall(function() c:Disconnect() end) end
    AntiRagdollConns = {}

    local char = LP.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then humanoid = char:WaitForChild("Humanoid", 5) end
    if not humanoid then return end

    local root     = char:FindFirstChild("HumanoidRootPart")
    local animator = humanoid:FindFirstChildOfClass("Animator")

    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,    false) end)
    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,   false) end)

    local BAD_STATES = {
        [Enum.HumanoidStateType.Physics]     = true,
        [Enum.HumanoidStateType.Ragdoll]     = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.GettingUp]   = true,
    }

    local recovering   = false
    local lastVelocity = Vector3.zero

    local function isRagdollState() return BAD_STATES[humanoid:GetState()] == true end

    local function startRecovery()
        if recovering then return end
        recovering = true
        task.spawn(function()
            local endTime = tick() + 0.5
            while tick() < endTime do
                if isRagdollState() then
                    cleanConstraints(char, animator)
                    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
                    if root then
                        local vel = root.Velocity
                        if vel.Magnitude > 30 then
                            root.Velocity = Vector3.new(0, math.min(vel.Y, 5), 0)
                        end
                    end
                    workspace.CurrentCamera.CameraSubject = humanoid
                    reEnableControls()
                end
                pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,    false) end)
                pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
                task.wait(0.02)
            end
            recovering = false
        end)
    end

    table.insert(AntiRagdollConns, humanoid.StateChanged:Connect(function(_, newState)
        if BAD_STATES[newState] then startRecovery() end
    end))

    table.insert(AntiRagdollConns, RunService.Heartbeat:Connect(function()
        if not char or not char.Parent then return end
        local curHum = char:FindFirstChildOfClass("Humanoid")
        if curHum and curHum ~= humanoid then enableAntiRagdoll() return end
        if isRagdollState() then
            startRecovery()
            if root then
                local vel    = root.Velocity
                local velDif = (vel - lastVelocity).Magnitude
                if velDif > 50 and vel.Magnitude > 20 then
                    root.Velocity = Vector3.new(0, math.min(vel.Y, 5), 0)
                end
            end
        end
        if root then lastVelocity = root.Velocity end
    end))

    table.insert(AntiRagdollConns, char.DescendantAdded:Connect(function(obj)
        if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint")
        or obj:IsA("HingeConstraint") or obj:IsA("BodyVelocity")
        or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
            task.defer(function() if obj and obj.Parent then obj:Destroy() end end)
        elseif obj:IsA("Motor6D") then
            task.defer(function() if obj and obj.Parent then obj.Enabled = true end end)
        elseif obj:IsA("Humanoid") then
            task.wait(0.1)
            enableAntiRagdoll()
        end
    end))

    reEnableControls()
    cleanConstraints(char, animator)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    enableAntiRagdoll()
end)

enableAntiRagdoll()

end)
