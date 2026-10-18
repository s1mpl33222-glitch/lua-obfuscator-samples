--  AVARICE SCYTHE  --
-- Credits: DYTON_txt
-- Fix: bug dikit dah gw perbaiki, jika di sebar lansung di blacklist dan tidak bisa beli lagi untuk sc kedepan nya

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local OwnerName = LP.Name
local petMode, isAttacking, skill2Active, soulSlashActive, deathSpinActive = false, false, false, false, false
local isMinimized = false
local comboStep = 1
local wingRemoteCache, currentCFrames = {}, {}
local lastUpdate, colorTimer = 0, 0

-- ini atur warna di sini
local COLORS = {
    Abyss = Color3.fromRGB(30, 0, 60),   
    Toxic = Color3.fromRGB(150, 0, 255), 
    Deep  = Color3.fromRGB(10, 0, 30)   
}

local function getAbyssColor(t, offset)
    local cycle = (t * 0.3 + (offset * 0.1)) % 1
    if cycle < 0.5 then
        return COLORS.Abyss:Lerp(COLORS.Toxic, cycle * 2)
    else
        return COLORS.Toxic:Lerp(COLORS.Deep, (cycle - 0.5) * 2)
    end
end

-- data lokasi nya gw buat 5 jam
local function getOff(base, target) return base:ToObjectSpace(target) end
local baseRef = CFrame.new(-236.747, 9.506, -60.077)
local baseBilah = CFrame.new(-79.3105, 7.1770, -66.5960)

local ScytheParts = {
    getOff(baseRef, CFrame.new(-236.747, 9.506, -60.077, -0.008, -0.264, 0.964, -0.999, 0.017, -0.003, -0.016, -0.964, -0.264)),
    getOff(baseRef, CFrame.new(-236.716, 14.642, -60.083, 0.008, 0.279, 0.960, 0.999, 0.014, -0.012, -0.017, 0.960, -0.279)),
    getOff(baseRef, CFrame.new(-236.093, 24.774, -59.104, 0.058, -0.242, -0.968, 0.974, 0.224, 0.002, 0.216, -0.943, 0.249)),
    getOff(baseRef, CFrame.new(-235.961, 28.168, -60.399, 0.333, 0.712, -0.617, 0.168, 0.599, 0.782, 0.927, -0.365, 0.080)),
    getOff(baseRef, CFrame.new(-237.159, 28.203, -60.040, 0.210, 0.733, 0.646, 0.137, -0.676, 0.723, 0.967, -0.063, -0.243)),
    getOff(baseRef, CFrame.new(-237.521, 29.332, -63.855, 0.258, -0.030, -0.965, 0.231, 0.972, 0.030, 0.938, -0.231, 0.258)),
    getOff(baseRef, CFrame.new(-237.705, 26.742, -64.716, 0.272, 0, -0.962, 0, 1, 0, 0.962, 0, 0.272)),
    getOff(baseRef, CFrame.new(-240.150, 26.147, -72.897, -0.233, 0.134, -0.962, -0.552, -0.833, 0.018, -0.799, 0.536, 0.269)),
    getOff(baseRef, CFrame.new(-239.586, 26.803, -69.858, 0.251, 0.135, 0.958, 0.413, -0.910, 0.019, 0.875, 0.391, -0.285)),
    getOff(baseRef, CFrame.new(-241.325, 22.019, -75.758, 0.118, 0.253, 0.960, 0.927, -0.374, -0.015, 0.355, 0.892, -0.279))
}

local BilahParts = {
    getOff(baseBilah, CFrame.new(-79.310, 7.177, -66.596, 0.349, -0.933, -0.079, 0.544, 0.133, 0.828, -0.762, -0.332, 0.554)),
    getOff(baseBilah, CFrame.new(-79.501, 7.447, -58.620, -0.307, -0.946, 0.102, -0.564, 0.267, 0.780, -0.766, 0.182, -0.616)),
    getOff(baseBilah, CFrame.new(-79.270, 2.109, -66.560, 0.362, 0.927, -0.086, -0.524, 0.126, -0.841, -0.770, 0.350, 0.532)),
    getOff(baseBilah, CFrame.new(-80.585, 2.192, -58.490, -0.126, 0.990, 0.056, 0.507, 0.113, -0.854, -0.852, -0.079, -0.516)),
    getOff(baseBilah, CFrame.new(-73.709, 12.594, -72.803, -0.749, -0.660, 0.046, -0.450, 0.456, -0.767, 0.485, -0.596, -0.639)),
    getOff(baseBilah, CFrame.new(-74.909, 12.409, -51.954, -0.628, -0.777, -0.001, -0.449, 0.361, 0.817, -0.634, 0.514, -0.576)),
    getOff(baseBilah, CFrame.new(-75.560, 4.468, -59.149, 0.952, 0.304, -0.012, 0.001, 0.034, 0.999, 0.304, -0.951, 0.032)),
    getOff(baseBilah, CFrame.new(-75.388, 4.516, -65.490, 0.957, -0.288, -0.005, 0.022, 0.057, 0.998, -0.287, -0.955, 0.061)),
    getOff(baseBilah, CFrame.new(-66.368, 4.602, -56.958, 0.982, -0.158, -0.097, 0.000, 0.523, -0.852, 0.186, 0.837, 0.514)),
    getOff(baseBilah, CFrame.new(-66.245, 4.977, -68.235, -0.977, -0.172, -0.119, -0.012, 0.616, -0.787, 0.209, -0.768, -0.604))
}

-- core nya ini hati² kalo edit 
local function moveProp(index, targetCF)
    local prop = wingRemoteCache[index]
    if not prop or not prop.Parent then return end 
    currentCFrames[index] = (currentCFrames[index] or targetCF):Lerp(targetCF, 0.55) 
    
    task.spawn(function()
        local cfR = prop:FindFirstChild("SetCurrentCFrame")
        if cfR then cfR:InvokeServer(currentCFrames[index]) end
        
        if tick() - colorTimer > 0.25 then
            local cr = prop:FindFirstChild("ChangePropColor")
            if cr then cr:InvokeServer(getAbyssColor(tick(), index)) end
            if index == #wingRemoteCache then colorTimer = tick() end
        end
    end)
end

local function GetBall()
    local b = LP.Backpack:FindFirstChild("SoccerBall") or (LP.Character and LP.Character:FindFirstChild("SoccerBall"))
    if not b then game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall") end
    local ball = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_SoccerBalls"):WaitForChild("Soccer" .. LP.Name, 5)
    if ball then ball.CanCollide = false end
    return ball
end

-- ini logic skill nya
local SoulCombo = {
    [1] = {Rot = CFrame.Angles(0, 0, math.rad(-45)), Speed = 1.1},
    [2] = {Rot = CFrame.Angles(0, 0, math.rad(45)),  Speed = 1.1},
    [3] = {Rot = CFrame.Angles(0, math.rad(90), 0),  Speed = 1.4}
}

local function ExecuteSoulSlash()
    if soulSlashActive or #wingRemoteCache < 1 then return end
    soulSlashActive = true
    local Ball = GetBall()
    local root = LP.Character.HumanoidRootPart
    local config = SoulCombo[comboStep]

    task.spawn(function()
        local spin, startTime, duration = 0, tick(), 0.38
        while tick() - startTime < duration do
            spin = spin + config.Speed
            local motionCF = root.CFrame * CFrame.new(0, 0, -7) * config.Rot * CFrame.Angles(spin, 0, 0)
            for i, partOff in ipairs(ScytheParts) do moveProp(i, motionCF * partOff) end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pRoot = p.Character.HumanoidRootPart
                    if (pRoot.Position - (root.CFrame * CFrame.new(0,0,-5)).Position).Magnitude < 16 then
                        Ball.CFrame = pRoot.CFrame
                        Ball.Velocity = Vector3.new(0, 9e10, 0)
                    end
                end
            end
            RS.Heartbeat:Wait()
        end
        comboStep = (comboStep % 3) + 1
        soulSlashActive = false
    end)
end

local function ExecuteHollowSlash(targetPlr)
    if isAttacking then return end
    isAttacking = true
    local Ball = GetBall()
    task.spawn(function()
        local spin = 0
        while isAttacking and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") do
            local root = targetPlr.Character.HumanoidRootPart
            -- ADJUSTED: Ball now targets the center of the body (no Y offset)
            local predPos = root.Position + (root.Velocity * 0.18) 
            Ball.CFrame = CFrame.new(predPos) 
            Ball.Velocity = Vector3.new(0, 9e10, 0) 
            
            spin = spin + 0.75
            local scytheCF = CFrame.new(predPos + Vector3.new(0, 1.5, 0)) * root.CFrame.Rotation * CFrame.Angles(spin, 0, 0)
            for i, offset in ipairs(ScytheParts) do moveProp(i, scytheCF * offset) end
            RS.Heartbeat:Wait()
        end
        isAttacking = false
    end)
end

local function ExecutePhantomRush()
    if skill2Active then return end
    skill2Active = true
    local Ball = GetBall()
    local root = LP.Character.HumanoidRootPart
    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
    local oldSpeed = hum.WalkSpeed
    hum.WalkSpeed = 80
    task.spawn(function()
        local start = tick()
        while tick() - start < 0.5 and skill2Active do
            local baseCF = root.CFrame * CFrame.new(4, 2.3, -17.9) * CFrame.Angles(0, math.rad(-90), 0)
            for i, offset in ipairs(BilahParts) do moveProp(i, baseCF * offset) end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - root.Position).Magnitude < 20 then
                        Ball.CFrame = p.Character.HumanoidRootPart.CFrame
                        Ball.Velocity = Vector3.new(0, 9e10, 0) 
                    end
                end
            end
            RS.Heartbeat:Wait()
        end
        hum.WalkSpeed = oldSpeed
        skill2Active = false
    end)
end

local function ExecuteDeathSpin()
    if deathSpinActive or #wingRemoteCache < 1 then return end
    deathSpinActive = true
    local Ball = GetBall()
    local root = LP.Character.HumanoidRootPart
    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
    local oldSpeed = hum.WalkSpeed
    hum.WalkSpeed = 50 
    task.spawn(function()
        local start, spin = tick(), 0
        while tick() - start < 8 and deathSpinActive do
            spin = spin + 0.9
            local side = (math.sin(tick() * 5) > 0) and -85 or 85
            local motionCF = root.CFrame * CFrame.new(0, 0, -8) * CFrame.Angles(0, 0, math.rad(side)) * CFrame.Angles(spin, 0, 0)
            for i, partOff in ipairs(ScytheParts) do moveProp(i, motionCF * partOff) end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pRoot = p.Character.HumanoidRootPart
                    if (pRoot.Position - (root.CFrame * CFrame.new(0,0,-6)).Position).Magnitude < 22 then
                        Ball.CFrame = pRoot.CFrame
                        Ball.Velocity = Vector3.new(0, 9e10, 0)
                    end
                end
            end
            RS.Heartbeat:Wait()
        end
        hum.WalkSpeed = oldSpeed
        deathSpinActive = false
    end)
end

-- atur gui nya di sini
local Gui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", Gui)
Main.Size, Main.Position = UDim2.new(0, 200, 0, 360), UDim2.new(0.5, -100, 0.4, 0)
Main.BackgroundColor3, Main.BorderSizePixel = Color3.fromRGB(255, 255, 255), 0
Main.Active, Main.Draggable, Main.ClipsDescendants = true, true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.Abyss), ColorSequenceKeypoint.new(0.4, COLORS.Toxic),  
    ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)), ColorSequenceKeypoint.new(0.6, COLORS.Toxic),  
    ColorSequenceKeypoint.new(1, COLORS.Abyss)      
})

task.spawn(function()
    while true do
        TS:Create(MainGrad, TweenInfo.new(4, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
        task.wait(4)
        MainGrad.Offset = Vector2.new(-1, 0)
    end
end)

local Header = Instance.new("Frame", Main)
Header.Size, Header.BackgroundTransparency = UDim2.new(1, 0, 0, 45), 1

local Title = Instance.new("TextLabel", Header)
Title.Size, Title.Position, Title.Text = UDim2.new(1, -40, 0, 25), UDim2.new(0, 10, 0, 5), "AVARICE SCYTHE"
Title.TextColor3, Title.Font, Title.TextSize, Title.BackgroundTransparency = Color3.new(1, 1, 1), Enum.Font.SourceSansBold, 15, 1

local Credits = Instance.new("TextLabel", Header)
Credits.Size, Credits.Position, Credits.Text = UDim2.new(1, -40, 0, 15), UDim2.new(0, 10, 0, 22), "by DYTON_txt"
Credits.TextColor3, Credits.Font, Credits.TextSize, Credits.BackgroundTransparency = Color3.new(1, 1, 1), Enum.Font.Code, 10, 1

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size, MinBtn.Position = UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 10)
MinBtn.BackgroundColor3, MinBtn.BackgroundTransparency, MinBtn.Text = Color3.new(0,0,0), 0.6, "▲"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local Content = Instance.new("Frame", Main)
Content.Size, Content.Position, Content.BackgroundTransparency = UDim2.new(1, 0, 1, -85), UDim2.new(0, 0, 0, 45), 1

local function createBtn(name, pos, func)
    local b = Instance.new("TextButton", Content)
    b.Size, b.Position = UDim2.new(0.9, 0, 0, 32), pos
    b.BackgroundColor3, b.BackgroundTransparency = Color3.new(0,0,0), 0.4
    b.Text, b.TextColor3, b.Font, b.TextSize = name, Color3.new(1, 1, 1), Enum.Font.SourceSansBold, 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

createBtn("SUMMON SCYTHE", UDim2.new(0.05, 0, 0, 5), function()
    petMode = not petMode
    if petMode then
        local p = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_TrafficCones")
        wingRemoteCache = {}
        for _, v in ipairs(p:GetChildren()) do if v.Name:find("Prop" .. OwnerName) then table.insert(wingRemoteCache, v) end end
    end
end)

createBtn("SOUL SLASH (BASIC)", UDim2.new(0.05, 0, 0, 42), function()
    if LP.Backpack:FindFirstChild("Soul Slash") then return end
    local t = Instance.new("Tool", LP.Backpack)
    t.Name, t.RequiresHandle = "Soul Slash", false
    t.Activated:Connect(ExecuteSoulSlash)
end)

createBtn("HOLLOW SLASH (SK 1)", UDim2.new(0.05, 0, 0, 79), function()
    if LP.Backpack:FindFirstChild("Hollow Slash") then return end
    local t = Instance.new("Tool", LP.Backpack)
    t.Name, t.RequiresHandle = "Hollow Slash", false
    t.Activated:Connect(function()
        local mousePos = LP:GetMouse().Hit.Position
        local target = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and (p.Character.HumanoidRootPart.Position - mousePos).Magnitude < 40 then target = p break end
        end
        if target then ExecuteHollowSlash(target) end
    end)
end)

createBtn("PHANTOM RUSH (SK 2)", UDim2.new(0.05, 0, 0, 116), ExecutePhantomRush)
createBtn("DEATH SPIN (SK 3)", UDim2.new(0.05, 0, 0, 153), ExecuteDeathSpin)

createBtn("Regeneration scythe", UDim2.new(0.05, 0, 0, 190), function()
    isAttacking, skill2Active, soulSlashActive, deathSpinActive = false, false, false, false
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
end)

local Footer = Instance.new("TextLabel", Main)
Footer.Size, Footer.Position, Footer.Text = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 1, -20), "Sin Of Greed stage 1"
Footer.TextColor3, Footer.Font, Footer.TextSize, Footer.BackgroundTransparency, Footer.BackgroundColor3 = Color3.new(1,1,1), Enum.Font.SourceSansItalic, 10, 0.8, Color3.new(0,0,0)

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 200, 0, 45) or UDim2.new(0, 200, 0, 360)
    MinBtn.Text = isMinimized and "▼" or "▲"
    TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    Content.Visible, Footer.Visible = not isMinimized, not isMinimized
end)

RS.Heartbeat:Connect(function()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not petMode or isAttacking or skill2Active or soulSlashActive or deathSpinActive or #wingRemoteCache < 1 then return end
    if tick() - lastUpdate < 0.025 then return end
    lastUpdate = tick()
    local idlePos = root.CFrame * CFrame.new(2.5, -0.5, -0.5) * CFrame.Angles(math.rad(85), math.rad(10), math.rad(33))
    for i, offset in ipairs(ScytheParts) do moveProp(i, idlePos * CFrame.new(0, math.sin(tick()*2)*0.25, 0) * offset) end
end)