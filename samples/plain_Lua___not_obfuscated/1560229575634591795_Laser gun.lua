repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ============================================
-- ИНСТРУМЕНТ
-- ============================================
local Tool = Instance.new("Tool")
Tool.Name = "Laser gun Rick c-137"
Tool.RequiresHandle = true
Tool.CanBeDropped = false

local Handle = Instance.new("Part")
Handle.Name = "Handle"
Handle.Size = Vector3.new(1.2, 1.2, 2.5)
Handle.Transparency = 0
Handle.CanCollide = false
Handle.Massless = true
Handle.Parent = Tool

local Mesh = Instance.new("SpecialMesh")
Mesh.MeshType = Enum.MeshType.FileMesh
Mesh.MeshId = "rbxassetid://14368645362"
Mesh.TextureId = "rbxassetid://14368645474"
Mesh.Scale = Vector3.new(0.85, 0.85, 0.85)
Mesh.Parent = Handle

local FireSound = Instance.new("Sound")
FireSound.SoundId = "rbxassetid://130113322"
FireSound.Volume = 2
FireSound.Parent = Handle

-- ХВАТ С ФОТО
Tool.Grip = CFrame.new(0, -0.5, 0.39) * CFrame.Angles(math.rad(21.43), 0, 0)

Tool.Parent = LocalPlayer.Backpack

-- ============================================
-- ЭФФЕКТ HYPERLASER (зелёный)
-- ============================================
local function hyperlaserEffect(char)
    if not char or not char.Parent then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = true
        hum.WalkSpeed = 0
        hum.JumpPower = 0
    end

    local bodyParts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(bodyParts, part)
        end
    end

    local selectionBoxes = {}
    for _, part in pairs(bodyParts) do
        local box = Instance.new("SelectionBox")
        box.Adornee = part
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.LineThickness = 0.15
        box.SurfaceTransparency = 1
        box.Transparency = 0
        box.Parent = part
        table.insert(selectionBoxes, box)
    end

    for _, part in pairs(bodyParts) do
        part.Transparency = 1
        part.CanCollide = false
    end

    task.wait(1.5)

    for _, box in pairs(selectionBoxes) do
        if box and box.Parent then
            TweenService:Create(box, TweenInfo.new(0.5), {Transparency = 1}):Play()
        end
    end

    task.wait(0.5)

    if char and char.Parent then
        char:Destroy()
    end
end

-- ============================================
-- ПУЛЯ (ЗЕЛЁНАЯ)
-- ============================================
local function fireBullet(startPos, direction)
    local bullet = Instance.new("Part")
    bullet.Anchored = true
    bullet.CanCollide = false
    bullet.CanQuery = false
    bullet.Material = Enum.Material.Neon
    bullet.Color = Color3.fromRGB(0, 255, 0)
    bullet.Shape = Enum.PartType.Cylinder
    bullet.Size = Vector3.new(1.5, 0.5, 0.5)
    bullet.CFrame = CFrame.new(startPos, startPos + direction) * CFrame.Angles(0, math.rad(90), 0)
    bullet.Parent = workspace

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(startPos, direction * 300, rayParams)
    local hitPos = startPos + direction * 300
    local hitChar = nil

    if result then
        hitPos = result.Position
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") and model ~= Character then
            hitChar = model
        end
    end

    local dist = (hitPos - startPos).Magnitude
    local flightTime = math.max(dist / 80, 0.15)
    local tween = TweenService:Create(bullet, TweenInfo.new(flightTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(hitPos, hitPos + direction) * CFrame.Angles(0, math.rad(90), 0)})
    tween:Play()

    tween.Completed:Connect(function()
        if hitChar then
            bullet:Destroy()

            local flash = Instance.new("Part")
            flash.Anchored = true
            flash.CanCollide = false
            flash.CanQuery = false
            flash.Material = Enum.Material.Neon
            flash.Color = Color3.fromRGB(0, 255, 0)
            flash.Shape = Enum.PartType.Ball
            flash.Size = Vector3.new(1, 1, 1)
            flash.Position = hitPos
            flash.Parent = workspace
            TweenService:Create(flash, TweenInfo.new(0.3), {Size = Vector3.new(4,4,4), Transparency = 1}):Play()

            hyperlaserEffect(hitChar)

            task.wait(0.3)
            flash:Destroy()
            return
        end

        local flash = Instance.new("Part")
        flash.Anchored = true
        flash.CanCollide = false
        flash.CanQuery = false
        flash.Material = Enum.Material.Neon
        flash.Color = Color3.fromRGB(0, 255, 0)
        flash.Shape = Enum.PartType.Ball
        flash.Size = Vector3.new(1, 1, 1)
        flash.Position = hitPos
        flash.Parent = workspace
        TweenService:Create(flash, TweenInfo.new(0.3), {Size = Vector3.new(4,4,4), Transparency = 1}):Play()

        task.wait(0.3)
        flash:Destroy()
        bullet:Destroy()
    end)
end

-- ============================================
-- ВЫСТРЕЛ
-- ============================================
Tool.Activated:Connect(function()
    FireSound:Play()
    task.delay(1, function() if FireSound.IsPlaying then FireSound:Stop() end end)
    local camera = workspace.CurrentCamera
    local mouse = LocalPlayer:GetMouse()
    local startPos = Handle.Position + camera.CFrame.LookVector * 2
    local direction = (mouse.Hit.Position - startPos).Unit
    fireBullet(startPos, direction)
end)

print("[Laser gun Rick c-137] Загружен!")
