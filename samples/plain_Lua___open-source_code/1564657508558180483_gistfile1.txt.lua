--=====================================================================================
-- [ MOROZ ULTIMATE HUB - FINAL SMOOTH EDITION ]
-- by @o6numumenya
--=====================================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. ОЧИСТКА СТАРОГО МУСОРА
pcall(function()
    local oldGui = CoreGui:FindFirstChild("Rayfield")
    if oldGui then oldGui:Destroy() end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "MorozTimer" or v.Name == "MorozESP" then v:Destroy() end
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. СОСТОЯНИЯ
local State = {
    Fly = false,
    FlySpeed = 60,
    ESP = true,
    ESPDist = 500,
    Hunt = false,
    Escaping = false,
    AntiAFK = true,
    Uptime = tick()
}

local Cache = {
    Doors = {},
    FlyVel = nil,
    FlyGyro = nil
}

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

-- 3. ИНТЕРФЕЙС RAYFIELD
local Window = Rayfield:CreateWindow({
    Name = "Moroz Hub | JJS",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by @o6numumenya",
    ConfigurationSaving = { Enabled = true, FolderName = "MorozHub", FileName = "Config" },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", "home")
local ESPTab = Window:CreateTab("ESP & Timers", "eye")
local HuntTab = Window:CreateTab("Pumpkin Hunt", "target")
local InfoTab = Window:CreateTab("Info", "info")

--=====================================================================================
-- 4. MAIN TAB (FLY)
--=====================================================================================
local FlyToggle
FlyToggle = MainTab:CreateToggle({
    Name = "Enable Fly (Bind: X)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        State.Fly = Value
        if not Value then
            if Cache.FlyVel then Cache.FlyVel:Destroy() Cache.FlyVel = nil end
            if Cache.FlyGyro then Cache.FlyGyro:Destroy() Cache.FlyGyro = nil end
        end
    end,
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 300},
    Increment = 5,
    Suffix = " studs/s",
    CurrentValue = 60,
    Flag = "FlySpeed",
    Callback = function(Value) State.FlySpeed = Value end,
})

--=====================================================================================
-- 5. ESP TAB (DOORS)
--=====================================================================================
ESPTab:CreateToggle({
    Name = "Show Doors ESP",
    CurrentValue = true,
    Flag = "DoorESP",
    Callback = function(Value)
        State.ESP = Value
        for target, data in pairs(Cache.Doors) do
            if data.hl then data.hl.Enabled = Value end
            if data.billboard then data.billboard.Enabled = Value end
        end
    end,
})

ESPTab:CreateSlider({
    Name = "ESP Distance",
    Range = {50, 1000},
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 500,
    Flag = "ESPDist",
    Callback = function(Value)
        State.ESPDist = Value
        for _, data in pairs(Cache.Doors) do
            if data.billboard then data.billboard.MaxDistance = Value end
        end
    end,
})

--=====================================================================================
-- 6. HUNT TAB (PUMPKIN EVENT)
--=====================================================================================
local HuntToggle
HuntToggle = HuntTab:CreateToggle({
    Name = "Auto Hunt (Bind: C)",
    CurrentValue = false,
    Flag = "PumpkinHunt",
    Callback = function(Value)
        State.Hunt = Value
        if not Value then
            State.Escaping = false
        end
    end,
})

HuntTab:CreateButton({
    Name = "Reset Hunt Position (Fall Down)",
    Callback = function()
        State.Escaping = false
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
            bv.Velocity = Vector3.new(0, -50, 0)
            task.wait(0.5)
            if bv then bv:Destroy() end
        end
    end,
})

--=====================================================================================
-- 7. FLY LOGIC
--=====================================================================================
RunService.RenderStepped:Connect(function()
    if not State.Fly then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not Cache.FlyVel or not Cache.FlyVel.Parent then
        Cache.FlyVel = Instance.new("BodyVelocity"); Cache.FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9); Cache.FlyVel.Parent = hrp
        Cache.FlyGyro = Instance.new("BodyGyro"); Cache.FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); Cache.FlyGyro.P = 1000; Cache.FlyGyro.D = 50; Cache.FlyGyro.Parent = hrp
    end

    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
    
    if dir.Magnitude > 0 then dir = dir.Unit end
    Cache.FlyVel.Velocity = dir * State.FlySpeed
    Cache.FlyGyro.CFrame = Camera.CFrame
end)

--=====================================================================================
-- 8. ESP DOORS & TIMERS
--=====================================================================================
local function SetupDoor(prompt)
    local parent = prompt.Parent
    if not parent then return end
    local model = parent:IsA("Model") and parent or parent:FindFirstAncestorOfClass("Model")
    local target = model or parent
    
    if target:FindFirstChildWhichIsA("Humanoid") then return end
    local name = string.lower(target.Name)
    if model then name = name .. " " .. string.lower(model.Name) end
    if not (string.find(name, "door") or string.find(name, "trick") or string.find(name, "treat")) then return end
    if Cache.Doors[target] then return end
    
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 50
        prompt.RequiresLineOfSight = false 
    end
    
    local hl = Instance.new("Highlight", target)
    hl.FillColor = Color3.fromRGB(255, 140, 0); hl.FillTransparency = 0.5; hl.OutlineColor = Color3.fromRGB(255, 140, 0)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Enabled = State.ESP
    
    local billboard = Instance.new("BillboardGui", target)
    billboard.Size = UDim2.new(0, 150, 0, 50); billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true; billboard.MaxDistance = State.ESPDist; billboard.Enabled = State.ESP

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 50, 50); label.Font = Enum.Font.GothamBold; label.TextSize = 24; label.TextStrokeTransparency = 0
    
    Cache.Doors[target] = { prompt = prompt, hl = hl, billboard = billboard, label = label, origTimer = nil }
end

Workspace.DescendantAdded:Connect(function(desc) if desc:IsA("ProximityPrompt") then task.defer(SetupDoor, desc) end end)
task.spawn(function() for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then SetupDoor(obj) end end end)

task.spawn(function()
    while task.wait(0.25) do
        if not State.ESP then continue end
        for obj, data in pairs(Cache.Doors) do
            if obj and obj.Parent and data.label then
                if not data.origTimer or not data.origTimer.Parent then
                    data.origTimer = nil
                    for _, d in ipairs(obj:GetDescendants()) do
                        if d:IsA("TextLabel") and string.match(d.Text, "%d+:%d+") then data.origTimer = d break end
                    end
                end
                if data.origTimer and data.origTimer.Parent then
                    local txt = data.origTimer.Text
                    if txt == "0:00" or txt == "0:01" or txt == "0" or string.lower(txt) == "ready" then
                        data.label.Text = "READY"; data.label.TextColor3 = Color3.fromRGB(0, 255, 0)
                    else
                        data.label.Text = txt; data.label.TextColor3 = Color3.fromRGB(255, 50, 50)
                    end
                else data.label.Text = "" end
            end
        end
    end
end)

--=====================================================================================
-- 9. HUNT LOGIC (SPEED 175)
--=====================================================================================
local function HasFlames(char)
    if not char then return false end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Fire") then
            if string.find(string.lower(obj.Name), "flame") then return true end
        end
    end
    return false
end

local function ForceJJS_Attack()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.15)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

local HuntVel = nil
local HuntGyro = nil
local LockedCFrame = nil

task.spawn(function()
    while task.wait(0.05) do
        if not State.Hunt then 
            if HuntVel then HuntVel:Destroy() HuntVel = nil end
            if HuntGyro then HuntGyro:Destroy() HuntGyro = nil end
            LockedCFrame = nil
            continue 
        end
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart
        
        -- Побег
        if State.Escaping then
            if HuntVel then HuntVel:Destroy() HuntVel = nil end
            if HuntGyro then HuntGyro:Destroy() HuntGyro = nil end
            LockedCFrame = nil
            hrp.Velocity = Vector3.new(0, 0, 0)
            continue
        end
        
        if HasFlames(char) then
            State.Escaping = true
            if HuntVel then HuntVel:Destroy() HuntVel = nil end
            if HuntGyro then HuntGyro:Destroy() HuntGyro = nil end
            LockedCFrame = nil
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 600, 0) 
            task.wait(1)
            if bv then bv:Destroy() end
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 600, 0)
            hrp.Velocity = Vector3.zero
            continue
        end
        
        -- Поиск цели
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and HasFlames(p.Character) then 
                target = p.Character 
                break 
            end
        end
        
        if target and target:FindFirstChild("HumanoidRootPart") then
            local targetHrp = target.HumanoidRootPart
            local dist = (hrp.Position - targetHrp.Position).Magnitude
            
            -- УДАР (Когда подлетели ближе - 2.5 стада)
            if dist < 2.5 then
                if HuntVel then HuntVel:Destroy() HuntVel = nil end
                if HuntGyro then HuntGyro:Destroy() HuntGyro = nil end
                hrp.Velocity = Vector3.zero
                
                -- Жесткая фиксация прямо перед лицом
                LockedCFrame = targetHrp.CFrame * CFrame.new(0, 0, 1)
                hrp.CFrame = LockedCFrame
                
                -- 4 удара
                for i = 1, 4 do
                    hrp.CFrame = LockedCFrame 
                    ForceJJS_Attack()
                    task.wait(0.1)
                end
                continue
            end
            
            -- ПЛАВНЫЙ ПОЛЕТ С ОБХОДОМ (Скорость 175)
            if not HuntVel or not HuntVel.Parent then
                HuntVel = Instance.new("BodyVelocity")
                HuntVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                HuntVel.Parent = hrp
                
                HuntGyro = Instance.new("BodyGyro")
                HuntGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                HuntGyro.P = 1000
                HuntGyro.D = 50
                HuntGyro.Parent = hrp
            end
            
            local direction = (targetHrp.Position - hrp.Position).Unit
            
            -- Обход стен (Raycast)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char, target}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local hitCenter = workspace:Raycast(hrp.Position, direction * 15, rayParams)
            local hitRight = workspace:Raycast(hrp.Position, (direction + Vector3.new(0,0,1)).Unit * 15, rayParams)
            local hitLeft = workspace:Raycast(hrp.Position, (direction - Vector3.new(0,0,1)).Unit * 15, rayParams)
            
            local finalDir = direction
            
            if hitCenter then
                if not hitRight then finalDir = (direction + Vector3.new(0, 0, 1.5)).Unit 
                elseif not hitLeft then finalDir = (direction - Vector3.new(0, 0, 1.5)).Unit 
                else finalDir = (direction + Vector3.new(0, 2, 0)).Unit end
            end
            
            -- Компенсация гравитации
            finalDir = (finalDir + Vector3.new(0, 0.15, 0)).Unit
            
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + finalDir)
            HuntGyro.CFrame = hrp.CFrame
            HuntVel.Velocity = finalDir * 175 -- <--- Скорость изменена на 175
            LockedCFrame = nil
        else
            if HuntVel then HuntVel:Destroy() HuntVel = nil end
            if HuntGyro then HuntGyro:Destroy() HuntGyro = nil end
            LockedCFrame = nil
        end
    end
end)

-- Фиксация при ударах
RunService.RenderStepped:Connect(function()
    if LockedCFrame then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = LockedCFrame
        end
    end
end)
--=====================================================================================
-- 10. БИНДЫ (X и C)
--=====================================================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    
    if input.KeyCode == Enum.KeyCode.X then
        local newState = not State.Fly
        State.Fly = newState
        if FlyToggle then FlyToggle:Set(newState) end
        if not newState then
            if Cache.FlyVel then Cache.FlyVel:Destroy() Cache.FlyVel = nil end
            if Cache.FlyGyro then Cache.FlyGyro:Destroy() Cache.FlyGyro = nil end
        end
    elseif input.KeyCode == Enum.KeyCode.C then
        local newState = not State.Hunt
        State.Hunt = newState
        if HuntToggle then HuntToggle:Set(newState) end
        if not newState then
            State.Escaping = false
        end
    end
end)

--=====================================================================================
-- 11. UTILITY & INFO
--=====================================================================================
LocalPlayer.Idled:Connect(function()
    if not State.AntiAFK then return end
    pcall(function() VirtualUser:CaptureController(); VirtualUser:Button2Down(Vector2.new(0,0)); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0)) end)
end)

local UptimeLabel = InfoTab:CreateLabel("UPTIME: 00:00:00")
task.spawn(function()
    while task.wait(1) do
        local elapsed = math.floor(tick() - State.Uptime)
        local h = math.floor(elapsed / 3600); local m = math.floor((elapsed % 3600) / 60); local s = math.floor(elapsed % 60)
        if UptimeLabel then UptimeLabel:Set(string.format("UPTIME: %02d:%02d:%02d", h, m, s)) end
    end
end)
InfoTab:CreateLabel("Author: @o6numumenya")