-- =========================
-- Services
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
-- =========================
-- Local Player & Character
-- =========================
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
-- =========================
-- Camera & Mouse
-- =========================
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local WindUI = nil
pcall(
    function()
        Version = "1.6.53"
        WindUI =
            loadstring(
            game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua")
        )()
    end
)
local Window
if WindUI then
    Window =
        WindUI:CreateWindow(
        {
            Title = "M O | 0.1 | free ",
            Icon = "cloud-lightning",
            Author = "https://discord.gg/RCgqfsCKB4",
            Folder = "MOKUN NEXUS Now",
            Size = UDim2.fromOffset(400, 200),
            Theme = "Dark",
            Transparent = true,
            Resizable = true,
            KeyCode = Enum.KeyCode.G
        }
    )
else
    Window = {
        Tab = function(_)
            return {
                Section = function()
                end,
                Toggle = function()
                end,
                Slider = function()
                end,
                Button = function()
                end,
                Input = function()
                    return {}
                end,
                Divider = function()
                end
            }
        end
    }
end
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("MokunConfig")
local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local OpenIcon = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local IconImage = Instance.new("ImageLabel")
local IconCorner = Instance.new("UICorner")
ScreenGui.Name = "GAMEDEE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
if not isMobile then -- ซ่อน OpenIcon บนมือถือ
    OpenIcon.Size = UDim2.new(0, 50, 0, 50)
    OpenIcon.Position = UDim2.new(0.5, 0, 0, 40)
    OpenIcon.AnchorPoint = Vector2.new(0.5, 0)
    OpenIcon.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    OpenIcon.Text = ""
    OpenIcon.BackgroundTransparency = 0.2
    OpenIcon.BorderSizePixel = 2
    OpenIcon.Active = true
    OpenIcon.Draggable = true
    OpenIcon.Parent = ScreenGui
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = OpenIcon
    -- รูปภาพเต็มปุ่ม
    IconImage.Size = UDim2.new(1, 0, 1, 0)
    IconImage.Position = UDim2.new(0, 0, 0, 0)
    IconImage.BackgroundTransparency = 1
    IconImage.Image = "rbxassetid://113631682317686"
    IconImage.Parent = OpenIcon
    -- ให้รูปภาพโค้งเหมือนปุ่ม
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = IconImage
    -- Tween ปุ่ม ขยายและคืนขนาด
    local currentTween  -- เก็บ Tween ปัจจุบัน
    local isAnimating = false
    local function animateButton(button)
        if isAnimating then
            return
        end -- ป้องกัน Tween ซ้อน
        isAnimating = true
        local originalSize = button.Size
        local tweenUp =
            TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 55, 0, 55)}
        )
        local tweenDown =
            TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = originalSize}
        )
        if currentTween then
            currentTween:Cancel()
        end
        currentTween = tweenUp
        tweenUp:Play()
        tweenUp.Completed:Connect(
            function()
                wait(0.25)
                currentTween = tweenDown
                tweenDown:Play()
                tweenDown.Completed:Connect(
                    function()
                        isAnimating = false
                    end
                )
            end
        )
    end
    -- แตะปุ่มมือถือสลับ UI + อนิเมชั่น
    OpenIcon.MouseButton1Click:Connect(
        function()
            animateButton(OpenIcon)
            if Window and Window.UI then
                Window.UI.Enabled = not Window.UI.Enabled
            elseif Window and Window.Toggle then
                Window:Toggle()
            end
        end
    )
end
local Remote
pcall(
    function()
        Remote = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Send", 5)
    end
)
local CharModule = require(game.ReplicatedStorage.Modules.Core.Char)
-- == Global Variables (Grouped by Feature) ==
-- Silent Aim
local SilentAimEnabled = false
local SilentAimAttachEnabled = false
local FOVRadius = 120
local CurrentTarget = nil
local SilentFOVCircle = nil
local Tracer = Drawing.new("Line")
Tracer.Thickness = 1
Tracer.Color = Color3.fromRGB(255, 50, 50)
Tracer.Transparency = 1
Tracer.Visible = false
-- ESP
local espPlayers = {}
local boxESPEnabled = false
local nameESPEnabled = false
local distanceESPEnabled = false
local healthESPEnabled = false
local highlightEnabled = false
local highlights = {}
local excludedPlayerNames = {} -- Table for excluded players
-- Movement
local walkSpeedEnabled = false
local speedValue = 0.05
local FlyEnabled = false
local isFlyingUp = false
local floatPower = 40
local teleportActive = false
local featureEnabled = false
local lockedY = nil
local maxHeight = 10
local startY = nil
local moveConnection = nil
local flyJumpConnection = nil -- สำหรับมือถือ
-- Combat/Misc
local fastFinishEnabled = false
local hookEnabled = false
local SelectedPlayer = nil
local Active = false
local BringConnection = nil
local holdTime = 0.85
local scanInterval = 1
local flickering = false
local undergroundBaseCFrame = nil
local getgenv = getgenv or function()
        return _G
    end
getgenv().Sky = false
getgenv().SkyAmount = 1500
local AutoSkipEnabled = false
local sucking = false
local lastPickupTimes = {}
local DROP_DEPTH = -55
local MOVE_RADIUS = 10
local FLICKER_RATE = 0.1
local AutoRespawnEnabled = false
local WallShootEnabled = false
local ShootEnabled = false
local ChckEnabled = false
local scanRadius = 12
local localEventCounter = 0
local localFuncCounter = 0
local AutoSprintEnabled = false
-- Weapon DB for Items ESP
local RARITY_COLORS = {
    ["Common"] = Color3.fromRGB(200, 200, 200),
    ["Uncommon"] = Color3.fromRGB(86, 176, 62),
    ["Rare"] = Color3.fromRGB(0, 162, 255),
    ["Epic"] = Color3.fromRGB(170, 85, 255),
    ["Legendary"] = Color3.fromRGB(255, 170, 0),
    ["Omega"] = Color3.fromRGB(255, 75, 75)
}
local WeaponDB = {}
local BillboardCache = {}
local ESPEnabled = false
local ESPConnection = nil
-- Counter Table for Remotes
local CounterTable
pcall(
    function()
        for _, Obj in ipairs(getgc(true)) do
            if typeof(Obj) == "table" and rawget(Obj, "event") and rawget(Obj, "func") then
                CounterTable = Obj
                break
            end
        end
    end
)
-- == Utility Functions ==
local function getPing()
    local stats = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("NetworkStats")
    if stats then
        local pingText = stats:FindFirstChild("PingLabel")
        if pingText and typeof(pingText.Text) == "string" then
            local ping = tonumber(pingText.Text:match("%d+"))
            return ping and ping / 1000 or 0.2
        end
    end
    return 0.2
end
local function isPlayerExcluded(playerName)
    for _, excludedName in ipairs(excludedPlayerNames) do
        if excludedName ~= "" and string.find(string.lower(playerName), string.lower(excludedName)) then
            return true
        end
    end
    return false
end
local function getClosestTarget()
    local closest = nil
    local shortestDistance = FOVRadius -- ใช้ FOV เป็นขอบเขต
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if head and humanoid and humanoid.Health > 0 and hrp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                    local distanceFromCenter = (screenVector - center).Magnitude
                    -- อยู่ใน FOV และไม่ถูกยกเว้น
                    if distanceFromCenter <= FOVRadius and not isPlayerExcluded(player.Name) then
                        if distanceFromCenter < shortestDistance then
                            shortestDistance = distanceFromCenter
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end
local function predictPosition(head, hrp)
    local ping = getPing()
    local velocity = hrp and hrp.Velocity or Vector3.zero
    return head.Position + (velocity * ping * 1.15)
end
local function isBehindWall(startPos, endPos)
    if not startPos or not endPos then
        return false
    end
    local ray = Ray.new(startPos, endPos - startPos)
    local ignoreList = {}
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    if CurrentTarget and CurrentTarget.Character then
        table.insert(ignoreList, CurrentTarget.Character)
    end
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    return hit ~= nil
end
local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    if moveConnection then
        pcall(
            function()
                moveConnection:Disconnect()
            end
        )
    end
    moveConnection =
        RunService.RenderStepped:Connect(
        function()
            if walkSpeedEnabled and Humanoid and HumanoidRootPart then
                if Humanoid.MoveDirection.Magnitude > 0 then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + (Humanoid.MoveDirection.Unit * speedValue)
                end
            end
        end
    )
end
local function isDowned()
    local hum = CharModule.get_hum()
    return hum and (hum:GetAttribute("HasBeenDowned") or hum:GetAttribute("IsDead") or hum.Health <= 0)
end
local function getHRP()
    local char = CharModule.current_char.get()
    if not char then
        return
    end
    return char:FindFirstChild("HumanoidRootPart")
end
local function teleportUnderground()
    local hrp = getHRP()
    if not hrp then
        return
    end
    local original = hrp.CFrame
    undergroundBaseCFrame = original + Vector3.new(0, DROP_DEPTH, 0)
    hrp.CFrame = undergroundBaseCFrame
end
local function flickerAndMove()
    if flickering then
        return
    end
    flickering = true
    task.spawn(
        function()
            while flickering and enabled and isDowned() do
                local hrp = getHRP()
                if hrp and undergroundBaseCFrame then
                    local angle = math.random() * math.pi * 2
                    local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * MOVE_RADIUS
                    local randomPos = undergroundBaseCFrame.Position + offset
                    hrp.CFrame = CFrame.new(randomPos)
                    task.wait(0.05)
                    hrp.CFrame = undergroundBaseCFrame
                end
                task.wait(FLICKER_RATE)
            end
            flickering = false
        end
    )
end
local function NetGet(...)
    if not CounterTable or not CounterTable.func then
        return
    end
    local args = {...}
    for i, v in ipairs(args) do
        if typeof(v) == "Instance" then
            if v:IsA("Model") and #v:GetChildren() == 0 then
                local fallback = Workspace:FindFirstChild("DroppedItems")
                if fallback then
                    local model = fallback:FindFirstChildWhichIsA("Model")
                    if model then
                        args[i] = model
                    else
                        return
                    end
                else
                    return
                end
            end
        end
    end
    CounterTable.func = (CounterTable.func or 0) + 1
    local success, result =
        pcall(
        function()
            local GetRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
            return GetRemote:InvokeServer(CounterTable.func, unpack(args))
        end
    )
    if not success then
        warn("[NetGet Error]", result)
    end
    return result
end
local function CheckAndPickup()
    if not sucking then
        return
    end
    local dropped = Workspace:FindFirstChild("DroppedItems")
    if not dropped then
        return
    end
    for _, item in ipairs(dropped:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChildWhichIsA("BasePart") then
            local modelCF = item.GetPivot and item:GetPivot() or item:GetModelCFrame()
            local distance = (HumanoidRootPart.Position - modelCF.Position).Magnitude
            if distance <= 15 then
                local now = tick()
                local lastTime = lastPickupTimes[item] or 0
                if now - lastTime >= 1.5 then
                    pcall(
                        function()
                            NetGet("pickup_dropped_item", item)
                        end
                    )
                    lastPickupTimes[item] = now
                end
            end
        end
    end
end
local function SafeCall(f, ...)
    local ok, res = pcall(f, ...)
    return ok, res
end
local tu_unpack = table.unpack or unpack
local function CallRemote(remote, ...)
    if not remote then
        return
    end
    if remote.ClassName == "RemoteEvent" then
        if CounterTable and type(CounterTable.event) == "number" then
            CounterTable.event = CounterTable.event + 1
            SafeCall(
                function(...)
                    remote:FireServer(CounterTable.event, ...)
                end,
                ...
            )
        else
            localEventCounter = localEventCounter + 1
            SafeCall(
                function(...)
                    remote:FireServer(localEventCounter, ...)
                end,
                ...
            )
        end
    elseif remote.ClassName == "RemoteFunction" then
        if CounterTable and type(CounterTable.func) == "number" then
            CounterTable.func = CounterTable.func + 1
            SafeCall(
                function(...)
                    remote:InvokeServer(CounterTable.func, ...)
                end,
                ...
            )
        else
            localFuncCounter = localFuncCounter + 1
            SafeCall(
                function(...)
                    remote:InvokeServer(localFuncCounter, ...)
                end,
                ...
            )
        end
    else
        SafeCall(
            function(...)
                if remote.FireServer then
                    remote:FireServer(...)
                elseif remote.InvokeServer then
                    remote:InvokeServer(...)
                end
            end,
            ...
        )
    end
end

local function getPlayersInRange(radius)
    local inRange = {}
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then
        return inRange
    end
    local pos = char.PrimaryPart.Position
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.PrimaryPart then
            local ok, mag =
                pcall(
                function()
                    return (player.Character.PrimaryPart.Position - pos).Magnitude
                end
            )
            if ok and mag and mag <= radius then
                table.insert(inRange, player)
            end
        end
    end
    return inRange
end

local function getActiveTool()
    local char = LocalPlayer and LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            local ok, isTool =
                pcall(
                function()
                    return item and item:IsA("Tool")
                end
            )
            if ok and isTool then
                return item
            end
        end
    end
    local backpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            local ok, isTool =
                pcall(
                function()
                    return item and item:IsA("Tool")
                end
            )
            if ok and isTool then
                return item
            end
        end
    end
    return nil
end

local function AttackNearby()
    if not Remote then
        return
    end
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then
        return
    end
    local tool = getActiveTool()
    if not tool then
        return
    end
    local okParent, parent =
        pcall(
        function()
            return tool.Parent
        end
    )
    if not okParent or parent ~= LocalPlayer.Character then
        return
    end
    local targets = getPlayersInRange(scanRadius)
    for _, target in pairs(targets) do
        if target and target.Character and target.Character.PrimaryPart then
            local okLocalPos, localPos =
                pcall(
                function()
                    return LocalPlayer.Character.PrimaryPart.Position
                end
            )
            local okEnemyPos, enemyPos =
                pcall(
                function()
                    return target.Character.PrimaryPart.Position
                end
            )
            if okLocalPos and okEnemyPos and localPos and enemyPos then
                local lookAtCFrame = CFrame.lookAt(localPos, enemyPos)
                local args = {
                    "melee_attack",
                    tool,
                    {target},
                    lookAtCFrame,
                    0.75
                }
                pcall(
                    function()
                        CallRemote(Remote, tu_unpack(args))
                    end
                )
            end
        end
    end
end

local running = false
local function StartAutoAttack()
    if running then
        return
    end
    running = true
    task.spawn(
        function()
            while running do
                task.wait(scanInterval)
                if hookEnabled and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                    pcall(AttackNearby)
                end
            end
        end
    )
end
local function createNeonEffectAtPosition(pos, fadeTime)
    if not Character then
        return
    end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            local box = Instance.new("Part")
            box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
            box.CFrame = part.CFrame + Vector3.new(0, pos.Y - HumanoidRootPart.Position.Y, 0)
            box.Anchored = true
            box.CanCollide = false
            box.Material = Enum.Material.Neon
            box.Color = Color3.fromRGB(128, 0, 255)
            box.Transparency = 0.3
            box.Parent = Workspace
            local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Linear)
            TweenService:Create(box, tweenInfo, {Transparency = 1}):Play()
            Debris:AddItem(box, fadeTime)
        end
    end
end
local function performTeleport()
    if not HumanoidRootPart then
        return
    end
    local currentPos = HumanoidRootPart.Position
    local bottomPos = Vector3.new(currentPos.X, currentPos.Y - maxHeight, currentPos.Z)
    HumanoidRootPart.CFrame = CFrame.new(bottomPos)
    lockedY = bottomPos.Y
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://95298029662868"
    sound.Volume = 1
    sound.PlayOnRemove = true
    sound.Parent = HumanoidRootPart
    sound:Destroy()
    createNeonEffectAtPosition(currentPos, 1.5)
    createNeonEffectAtPosition(bottomPos, 2)
end
local function toggleTeleport()
    if not featureEnabled then
        return
    end
    teleportActive = not teleportActive
    if teleportActive then
        performTeleport()
    else
        lockedY = nil
    end
end
local connection
local function lockYPosition()
    if connection then
        pcall(
            function()
                connection:Disconnect()
            end
        )
    end
    connection =
        RunService.Heartbeat:Connect(
        function()
            if teleportActive and lockedY and HumanoidRootPart then
                local currentPos = HumanoidRootPart.Position
                if math.abs(currentPos.Y - lockedY) > 0.1 then
                    HumanoidRootPart.CFrame = CFrame.new(currentPos.X, lockedY, currentPos.Z)
                end
            end
        end
    )
end
local function registerItems(folder)
    for _, tool in ipairs(folder:GetChildren()) do
        local handle = tool:FindFirstChild("Handle")
        local key
        if handle then
            local mesh = handle:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                key = mesh.MeshId .. (mesh.TextureId or "")
            elseif handle:IsA("MeshPart") then
                key = handle.MeshId .. (handle.TextureID or "")
            end
        end
        if key then
            WeaponDB[key] = {
                Name = tool:GetAttribute("DisplayName") or tool.Name,
                Rarity = tool:GetAttribute("RarityName") or "Common",
                ImageId = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
            }
        else
            WeaponDB[tool.Name] = {
                Name = tool:GetAttribute("DisplayName") or tool.Name,
                Rarity = tool:GetAttribute("RarityName") or "Common",
                ImageId = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
            }
        end
    end
end
local function getMeshId(tool)
    local handle = tool:FindFirstChild("Handle")
    if not handle then
        return nil
    end
    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
    if mesh then
        return mesh.MeshId .. (mesh.TextureId or "")
    end
    if handle:IsA("MeshPart") then
        return handle.MeshId .. (handle.TextureID or "")
    end
    return nil
end
local function getWeaponInfo(tool)
    local meshId = getMeshId(tool)
    if meshId and WeaponDB[meshId] then
        return WeaponDB[meshId]
    elseif WeaponDB[tool.Name] then
        return WeaponDB[tool.Name]
    else
        return nil
    end
end
local function createBillboardForPlayer(player)
    if not ESPEnabled or player == LocalPlayer then
        return
    end
    local char = player.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    if BillboardCache[player] then
        BillboardCache[player]:Destroy() -- ลบอันเก่าก่อนสร้างใหม่เพื่อป้องกันค้าง
        BillboardCache[player] = nil
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 90, 0, 20)
    billboard.StudsOffset = Vector3.new(0, -5.0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    billboard:ClearAllChildren()
    local layout = Instance.new("UIListLayout", billboard)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local tools = {}
    for _, container in ipairs({"Backpack", "StarterGear", "StarterPack"}) do
        local obj = player:FindFirstChild(container)
        if obj then
            for _, tool in ipairs(obj:GetChildren()) do
                if tool:IsA("Tool") and tool.Name ~= "Fists" then
                    table.insert(tools, tool)
                end
            end
        end
    end
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Fists" then
                table.insert(tools, tool)
            end
        end
    end
    for _, tool in ipairs(tools) do
        local info = getWeaponInfo(tool)
        if info then
            local img = Instance.new("ImageLabel", billboard)
            img.Size = UDim2.new(0, 20, 0, 20)
            img.BackgroundTransparency = 0.1
            img.Image = info.ImageId
            img.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 10)
            local border = Instance.new("UIStroke", img)
            border.Color = RARITY_COLORS[info.Rarity] or Color3.new(1, 1, 1)
            border.Thickness = 2
        end
    end
    BillboardCache[player] = billboard
end
local function setFinishPrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = holdTime
        prompt.MaxActivationDistance = 20
    end
end
local function tryHoldPrompt(prompt, duration)
    if not prompt or prompt:GetAttribute("__AutoFinishBusy") then
        return
    end
    prompt:SetAttribute("__AutoFinishBusy", true)
    pcall(
        function()
            if prompt.InputHoldBegin then
                prompt:InputHoldBegin()
            end
        end
    )
    pcall(
        function()
            if prompt.HoldBegin then
                prompt:HoldBegin()
            end
        end
    )
    pcall(
        function()
            if prompt.Trigger then
                prompt:Trigger()
            end
        end
    )
    task.wait(duration)
    pcall(
        function()
            if prompt.InputHoldEnd then
                prompt:InputHoldEnd()
            end
        end
    )
    pcall(
        function()
            if prompt.HoldEnd then
                prompt:HoldEnd()
            end
        end
    )
    prompt:SetAttribute("__AutoFinishBusy", nil)
end
local function findFinishPrompts()
    local found = {}
    for _, char in pairs(workspace:GetChildren()) do
        local player = Players:GetPlayerFromCharacter(char)
        if player and not isPlayerExcluded(player.Name) then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local prompt = hrp:FindFirstChild("FinishPrompt")
                if prompt then
                    setFinishPrompt(prompt)
                    table.insert(found, prompt)
                end
            end
        end
    end
    return found
end
local function applyToAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local prompt = hrp:FindFirstChild("FinishPrompt")
                if prompt then
                    setFinishPrompt(prompt)
                end
            end
        end
    end
end
local function setupFastFinishForPlayer(p)
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(
            function(char)
                char.DescendantAdded:Connect(
                    function(desc)
                        if
                            fastFinishEnabled and desc.Name == "FinishPrompt" and desc:IsA("ProximityPrompt") and
                                desc.Parent and
                                desc.Parent.Name == "HumanoidRootPart"
                         then
                            setFinishPrompt(desc)
                        end
                    end
                )
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                if hrp and fastFinishEnabled then
                    local prompt = hrp:FindFirstChild("FinishPrompt")
                    if prompt then
                        setFinishPrompt(prompt)
                    end
                end
            end
        )
        if p.Character then
            local char = p.Character
            char.DescendantAdded:Connect(
                function(desc)
                    if
                        fastFinishEnabled and desc.Name == "FinishPrompt" and desc:IsA("ProximityPrompt") and
                            desc.Parent and
                            desc.Parent.Name == "HumanoidRootPart"
                     then
                        setFinishPrompt(desc)
                    end
                end
            )
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and fastFinishEnabled then
                local prompt = hrp:FindFirstChild("FinishPrompt")
                if prompt then
                    setFinishPrompt(prompt)
                end
            end
        end
    end
end
local function getPlayer(name)
    name = string.lower(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), name) or string.find(string.lower(p.DisplayName), name) then
            return p
        end
    end
end
local function ForcePart(v)
    if
        v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and
            not v.Parent:FindFirstChild("Head") and
            v.Name ~= "Handle"
     then
        for _, obj in ipairs(v:GetChildren()) do
            if obj:IsA("BodyMover") or obj:IsA("RocketPropulsion") then
                obj:Destroy()
            end
        end
        for _, junk in ipairs({"Attachment", "AlignPosition", "Torque"}) do
            local f = v:FindFirstChild(junk)
            if f then
                f:Destroy()
            end
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 9999
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end
local function ToggleBring(name)
    local player = getPlayer(name)
    if not player then
        return
    end
    Active = not Active
    if Active then
        local char = player.Character or player.CharacterAdded:Wait()
        local targetRoot = char:WaitForChild("HumanoidRootPart")
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end
        BringConnection = Workspace.DescendantAdded:Connect(ForcePart)
        task.spawn(
            function()
                while Active do
                    Attachment1.WorldCFrame = targetRoot.CFrame
                    task.wait()
                end
            end
        )
    else
        if BringConnection then
            BringConnection:Disconnect()
        end
    end
end
local function TrySkipCrate()
    local success, CrateController =
        pcall(
        function()
            return require(ReplicatedStorage.Modules.Game.CrateSystem.Crate)
        end
    )
    if success and CrateController and CrateController.spinning and CrateController.spinning.get() then
        CrateController.skip_spin()
    end
end
local function SetupAutoSkip()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        local sendRemote = remotesFolder:FindFirstChild("Send")
        if sendRemote and sendRemote:IsA("RemoteEvent") then
            sendRemote.OnClientEvent:Connect(
                function(...)
                    if AutoSkipEnabled then
                        task.spawn(TrySkipCrate) -- ใช้ task.spawn เพื่อเรียกใช้ทันทีแบบ async
                    end
                end
            )
        end
    end
end
local function createHighlight(character)
    if not character then
        return nil
    end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(200, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    return highlight
end
local function updateHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not highlights[player] or not highlights[player].Parent then
                highlights[player] = createHighlight(player.Character)
            end
        end
    end
    for player, hl in pairs(highlights) do
        if not player or not player.Parent or not player.Character then
            if hl and hl.Destroy then
                pcall(
                    function()
                        hl:Destroy()
                    end
                )
            end
            highlights[player] = nil
        end
    end
end
local function createESP(player)
    if espPlayers[player] then
        return
    end
    local lines = {}
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Color = Color3.new(1, 1, 1)
        line.Thickness = 2
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(0, 0)
        lines[i] = line
    end
    local nameText = Drawing.new("Text")
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.Color = isPlayerExcluded(player.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    nameText.Font = 2
    local distanceText = Drawing.new("Text")
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Color = Color3.fromRGB(255, 255, 255)
    local healthBg = Drawing.new("Square")
    healthBg.Filled = false
    healthBg.Thickness = 1
    healthBg.Color = Color3.fromRGB(0, 0, 0)
    healthBg.Transparency = 1
    healthBg.Visible = false
    local healthFg = Drawing.new("Square")
    healthFg.Filled = true
    healthFg.Transparency = 1
    healthFg.Visible = false
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    pcall(
        function()
            highlight.Parent = player.Character or Workspace
        end
    )
    local drawings = {nameText, distanceText, healthBg, healthFg, highlight}
    for _, line in ipairs(lines) do
        table.insert(drawings, line)
    end
    local conn =
        RunService.RenderStepped:Connect(
        function()
            if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
                nameText.Visible = false
                distanceText.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
                highlight.Enabled = false
                return
            end
            if highlight and highlight.Parent and player.Character then
                highlight.Adornee = player.Character
            end
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local dist = 0
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end
            local thickness = dist > 0 and math.clamp(500 / math.max(dist, 1), 0.5, 2) or 2
            local cf = player.Character:GetPivot()
            local size = Vector3.new(3.5, 7, 2)
            local halfSize = size / 2
            local corners = {
                cf * Vector3.new(-halfSize.X, -halfSize.Y, -halfSize.Z),
                cf * Vector3.new(-halfSize.X, -halfSize.Y, halfSize.Z),
                cf * Vector3.new(-halfSize.X, halfSize.Y, -halfSize.Z),
                cf * Vector3.new(-halfSize.X, halfSize.Y, halfSize.Z),
                cf * Vector3.new(halfSize.X, -halfSize.Y, -halfSize.Z),
                cf * Vector3.new(halfSize.X, -halfSize.Y, halfSize.Z),
                cf * Vector3.new(halfSize.X, halfSize.Y, -halfSize.Z),
                cf * Vector3.new(halfSize.X, halfSize.Y, halfSize.Z)
            }
            local vp = {}
            local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
            local hasFront = false
            for i, world in ipairs(corners) do
                local screenPos, onScreen = Camera:WorldToViewportPoint(world)
                vp[i] = {pos = screenPos, on = onScreen}
                if onScreen and screenPos.Z > 0 then
                    hasFront = true
                    minX = math.min(minX, screenPos.X)
                    maxX = math.max(maxX, screenPos.X)
                    minY = math.min(minY, screenPos.Y)
                    maxY = math.max(maxY, screenPos.Y)
                end
            end
            if not hasFront then
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
                nameText.Visible = false
                distanceText.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
                highlight.Enabled = false
                return
            end
            local width = maxX - minX
            local height = maxY - minY
            local centerX = (minX + maxX) / 2
            local boxColor = Color3.new(1, 1, 1)
            if humanoid and humanoid.Health > 0 then
                local perc = humanoid.Health / (humanoid.MaxHealth > 0 and humanoid.MaxHealth or 1)
                boxColor = Color3.fromHSV(perc * 0.333, 0.5, 1)
            end
            if boxESPEnabled then
                local edges = {
                    {1, 2},
                    {1, 3},
                    {1, 5},
                    {2, 4},
                    {2, 6},
                    {3, 4},
                    {3, 7},
                    {4, 8},
                    {5, 6},
                    {5, 7},
                    {6, 8},
                    {7, 8}
                }
                for i, edge in ipairs(edges) do
                    local aIdx, bIdx = edge[1], edge[2]
                    local a, b = vp[aIdx], vp[bIdx]
                    if a and b and a.on and b.on and a.pos and b.pos then
                        local ax, ay = a.pos.X, a.pos.Y
                        local bx, by = b.pos.X, b.pos.Y
                        if ax == ax and ay == ay and bx == bx and by == by then
                            lines[i].From = Vector2.new(ax, ay)
                            lines[i].To = Vector2.new(bx, by)
                            lines[i].Color = boxColor
                            lines[i].Thickness = thickness
                            lines[i].Visible = true
                        else
                            lines[i].Visible = false
                        end
                    else
                        lines[i].Visible = false
                    end
                end
            else
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
            end
            local currentTopY = minY
            if healthESPEnabled and humanoid and humanoid.Health > 0 then
                local perc = humanoid.Health / (humanoid.MaxHealth > 0 and humanoid.MaxHealth or 1)
                local barHeight = 4
                local minBarWidth = 50
                local barWidth = math.max(width, minBarWidth)
                local healthX = width < minBarWidth and centerX - minBarWidth / 2 or minX
                healthBg.Position = Vector2.new(healthX, currentTopY - barHeight - 2)
                healthBg.Size = Vector2.new(barWidth, barHeight)
                healthBg.Visible = true
                healthFg.Position = Vector2.new(healthX, currentTopY - barHeight - 2)
                healthFg.Size = Vector2.new(barWidth * perc, barHeight)
                healthFg.Color = Color3.fromHSV(perc * 0.333, 0.5, 1)
                healthFg.Visible = true
                currentTopY = currentTopY - barHeight - 2
            else
                healthBg.Visible = false
                healthFg.Visible = false
            end
            nameText.Text = nameESPEnabled and player.Name or ""
            nameText.Color =
                isPlayerExcluded(player.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
            nameText.Position = Vector2.new(centerX, currentTopY - 16)
            nameText.Visible = nameESPEnabled
            distanceText.Text = distanceESPEnabled and string.format("%.0f studs", dist) or ""
            distanceText.Position = Vector2.new(centerX, maxY + 4)
            distanceText.Visible = distanceESPEnabled
            highlight.Enabled = highlightEnabled
        end
    )
    espPlayers[player] = {conn = conn, drawings = drawings}
end
local function loadESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not espPlayers[player] then
            createESP(player)
        end
    end
    Players.PlayerAdded:Connect(
        function(player)
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(
                    function()
                        task.wait(0.1)
                        if not espPlayers[player] then
                            createESP(player)
                        end
                    end
                )
                if player.Character and not espPlayers[player] then
                    task.wait(0.1)
                    createESP(player)
                end
            end
        end
    )
    Players.PlayerRemoving:Connect(
        function(player)
            if espPlayers[player] then
                for _, obj in pairs(espPlayers[player].drawings) do
                    if obj and obj.Destroy then
                        pcall(
                            function()
                                obj:Destroy()
                            end
                        )
                    elseif typeof(obj) == "table" and obj.Visible ~= nil then
                        obj.Visible = false
                    end
                end
                if espPlayers[player].conn then
                    pcall(
                        function()
                            espPlayers[player].conn:Disconnect()
                        end
                    )
                end
                espPlayers[player] = nil
            end
        end
    )
end
-- Silent FOV Circle Setup
if not isMobile then
    SilentFOVCircle = Drawing.new("Circle")
    SilentFOVCircle.Color = Color3.fromRGB(255, 255, 255)
    SilentFOVCircle.Thickness = 2 -- Increased thickness for better visibility
    SilentFOVCircle.NumSides = 64
    SilentFOVCircle.Filled = false
    SilentFOVCircle.Transparency = 0.8 -- Slightly less transparent for better visibility
    SilentFOVCircle.Radius = FOVRadius
    SilentFOVCircle.Visible = false
else
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileFOV"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    SilentFOVCircle = Instance.new("Frame")
    SilentFOVCircle.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
    SilentFOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    SilentFOVCircle.Position = UDim2.fromScale(0.5, 0.5)
    SilentFOVCircle.BackgroundTransparency = 1
    local circleUI = Instance.new("UICorner")
    circleUI.CornerRadius = UDim.new(1, 0)
    circleUI.Parent = SilentFOVCircle
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Thickness = 2 -- Increased thickness for better visibility
    border.Transparency = 0.2 -- Slightly less transparent for better visibility
    border.Parent = SilentFOVCircle
    SilentFOVCircle.Parent = ScreenGui
end
local function isShotgun()
    if not Character then
        return false
    end
    for _, tool in ipairs(Character:GetChildren()) do
        if tool:IsA("Tool") then
            local ammoType = tool:GetAttribute("AmmoType")
            if ammoType == "shotgun" or ammoType == "shootgun" then
                return true
            end
        end
    end
    return false
end
local oldFire
if Remote and Remote.FireServer then
    local ok, res = pcall(function()
        oldFire = hookfunction(Remote.FireServer, function(self, ...)
            if self ~= Remote then return oldFire(self, ...) end
            local args = {...}

            if SilentAimEnabled and args[2] == "shoot_gun" and CurrentTarget then
                local head = CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("Head")
                local hrp = CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("Humanoid")

                if head and humanoid and hrp then
                    local aimPos = predictPosition(head, hrp)
                    local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                    local myPos = myHead and myHead.Position or nil

                    -- ✅ ตรวจว่ามีกำแพงขวางไหม (ใช้กับทุกปืน)
                    local blocked = isBehindWall(myPos, aimPos)
                    if blocked then
                        args[4] = CFrame.new(math.huge, math.huge, math.huge)
                    else
                        args[4] = CFrame.new(myPos, aimPos)
                    end

                    -- ✅ ถ้าเป็น shotgun ยิงกระจายหัว
                    if isShotgun() then
                        local pellets = {}
                        for i = 1, 6 do
                            local spread = Vector3.new(
                                math.random(-2, 2) * 0.03,
                                math.random(-2, 2) * 0.03,
                                math.random(-2, 2) * 0.03
                            )
                            table.insert(pellets, {
                                [1] = {
                                    Instance = head,
                                    Normal = Vector3.new(0, 1, 0),
                                    Position = aimPos + spread
                                }
                            })
                        end
                        args[5] = pellets
                    else
                        -- ✅ ปืนปกติ ยิงหัวตรง ๆ
                        args[5] = {
                            [1] = {
                                [1] = {
                                    ["Instance"] = head,
                                    ["Normal"] = Vector3.new(0, 1, 0),
                                    ["Position"] = aimPos
                                }
                            }
                        }
                    end

                    -- ✅ เอฟเฟกต์กระสุน
                    local success, beam = pcall(function()
                        local part = Instance.new("Part")
                        part.Anchored = true
                        part.CanCollide = false
                        part.Size = Vector3.new(0.15, 0.15, (aimPos - myPos).Magnitude)
                        part.CFrame = CFrame.new(myPos, aimPos) * CFrame.new(0, 0, -part.Size.Z / 2)
                        part.Material = Enum.Material.Neon
                        part.Transparency = 0.25
                        part.Parent = Workspace
                        Debris:AddItem(part, 4)
                        return part
                    end)

                    if humanoid then
                        local previousHealth = humanoid.Health
                        spawn(function()
                            wait(0.1)
                            if humanoid and humanoid.Health < previousHealth then
                                if success and beam then
                                    beam.Color = Color3.fromRGB(0, 255, 0)
                                end
                                for _, part in ipairs(CurrentTarget.Character:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        local box = Instance.new("Part")
                                        box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                                        box.CFrame = part.CFrame
                                        box.Anchored = true
                                        box.CanCollide = false
                                        box.Material = Enum.Material.Neon
                                        box.Color = Color3.fromRGB(128, 0, 128)
                                        box.Transparency = 0.5
                                        box.Parent = Workspace
                                        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)
                                        TweenService:Create(box, tweenInfo, {Transparency = 1}):Play()
                                        Debris:AddItem(box, 2)
                                    end
                                end
                                if head then
                                    local blood = Instance.new("Part")
                                    blood.Size = Vector3.new(0.2, 0.2, 0.2)
                                    blood.Shape = Enum.PartType.Ball
                                    blood.Material = Enum.Material.Neon
                                    blood.Color = Color3.fromRGB(255, 0, 0)
                                    blood.CFrame = CFrame.new(head.Position)
                                    blood.Anchored = false
                                    blood.CanCollide = false
                                    blood.Parent = Workspace
                                    local bv = Instance.new("BodyVelocity")
                                    bv.Velocity = Vector3.new(math.random(-5, 5), math.random(5, 10), math.random(-5, 5))
                                    bv.P = 5000
                                    bv.MaxForce = Vector3.new(4000, 4000, 4000)
                                    bv.Parent = blood
                                    Debris:AddItem(blood, 1)
                                end
                            else
                                if success and beam then
                                    beam.Color = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end)
                    end
                end
            end

            return oldFire(self, unpack(args))
        end)
    end)

    if not ok then
        warn("Warning: failed to hook Remote.FireServer")
    end
end

-- Main Render Loop
RunService.RenderStepped:Connect(
    function()
        pcall(
            function()
                if SilentAimAttachEnabled then
                    CurrentTarget = getClosestTarget()
                end
                if SilentFOVCircle then
                    SilentFOVCircle.Visible = SilentAimEnabled or SilentAimAttachEnabled
                    if isMobile then
                        SilentFOVCircle.Position = UDim2.fromScale(0.5, 0.5)
                        SilentFOVCircle.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
                    else
                        SilentFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        SilentFOVCircle.Radius = FOVRadius
                    end
                end
                CurrentTarget = (SilentAimEnabled or SilentAimAttachEnabled) and getClosestTarget() or nil
                if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("Head") then
                    local targetHead = CurrentTarget.Character.Head
                    local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local centerScreenPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) -- Center of FOV circle
                        local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(targetHead.Position)
                        if targetOnScreen then
                            Tracer.Visible = true
                            Tracer.From = centerScreenPos -- Start from center of FOV circle
                            Tracer.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                            Tracer.Color = Color3.fromRGB(255, 50, 50)
                        else
                            Tracer.Visible = false
                        end
                    else
                        Tracer.Visible = false
                    end
                else
                    Tracer.Visible = false
                end
                if FlyEnabled and isFlyingUp and HumanoidRootPart then
                    local v = HumanoidRootPart.Velocity
                    HumanoidRootPart.Velocity = Vector3.new(v.X, floatPower, v.Z)
                end
                if teleportActive and lockedY and HumanoidRootPart then
                    local currentPos = HumanoidRootPart.Position
                    if math.abs(currentPos.Y - lockedY) > 0.1 then
                        HumanoidRootPart.CFrame = CFrame.new(currentPos.X, lockedY, currentPos.Z)
                    end
                end
            end
        )
    end
)
-- Loops
RunService.Heartbeat:Connect(
    function()
        if getgenv().Sky and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LocalPlayer.Character.HumanoidRootPart
            local originalVel = Root.Velocity
            local angle = math.rad(math.random(0, 360))
            local x = math.cos(angle) * getgenv().SkyAmount
            local z = math.sin(angle) * getgenv().SkyAmount
            Root.Velocity = Vector3.new(x, math.random(200, 400), z)
            RunService.RenderStepped:Wait()
            Root.Velocity = originalVel
        end
    end
)
RunService.Heartbeat:Connect(
    function()
        if not enabled then
            return
        end
        if isDowned() then
            local hrp = getHRP()
            if hrp and not undergroundBaseCFrame then
                teleportUnderground()
            end
            flickerAndMove()
        else
            if undergroundBaseCFrame then
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = undergroundBaseCFrame + Vector3.new(0, -DROP_DEPTH, 0)
                end
            end
            undergroundBaseCFrame = nil
            flickering = false
        end
    end
)
RunService.Heartbeat:Connect(
    function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        end
        pcall(CheckAndPickup)
    end
)
-- Fly Bind
ContextActionService:BindAction(
    "FlyUp",
    function(actionName, inputState, inputObject)
        if not FlyEnabled then
            return Enum.ContextActionResult.Pass
        end
        local isJumpPressed = false
        -- PC: Spacebar
        if inputObject.UserInputType == Enum.UserInputType.Keyboard and inputObject.KeyCode == Enum.KeyCode.Space then
            isJumpPressed = true
        end
        -- Mobile: ใช้ปุ่ม Jump ของ Roblox
        if inputObject.UserInputType == Enum.UserInputType.Touch then
            isJumpPressed = true
        end
        if isJumpPressed then
            if inputState == Enum.UserInputState.Begin then
                isFlyingUp = true
                Humanoid.Jump = true -- กระโดดปกติ (มือถือ) หรือเริ่มบิน
                return Enum.ContextActionResult.Sink
            elseif inputState == Enum.UserInputState.End then
                isFlyingUp = false
                return Enum.ContextActionResult.Sink
            end
        end
        return Enum.ContextActionResult.Pass
    end,
    false,
    Enum.KeyCode.Space
)
-- =========================
-- Fly Update (ลอยขึ้นต่อเนื่อง)
-- =========================
RunService.RenderStepped:Connect(
    function(deltaTime)
        if FlyEnabled and isFlyingUp then
            HumanoidRootPart.Velocity =
                Vector3.new(HumanoidRootPart.Velocity.X, floatPower, HumanoidRootPart.Velocity.Z)
        end
    end
)
-- เพิ่มสำหรับมือถือ: ฟัง Humanoid.Jumping
LocalPlayer.CharacterAdded:Connect(
    function(char)
        local hum = char:WaitForChild("Humanoid")
        if flyJumpConnection then
            flyJumpConnection:Disconnect()
        end
        flyJumpConnection =
            hum:GetPropertyChangedSignal("Jumping"):Connect(
            function()
                if FlyEnabled and hum.Jumping then
                    isFlyingUp = true
                else
                    isFlyingUp = false
                end
            end
        )
    end
)
-- == Connections and Setup ==
LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
UserInputService.InputBegan:Connect(
    function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.KeyCode == Enum.KeyCode.G and WindUI and Window then
            if Window.Toggle then
                Window:Toggle()
            elseif Window.SetVisible then
                Window:SetVisible(not Window.Visible)
            end
        end
    end
)
UserInputService.InputBegan:Connect(
    function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.KeyCode == Enum.KeyCode.Z and featureEnabled then
            toggleTeleport()
        end
    end
)
LocalPlayer.CharacterAdded:Connect(
    function(newChar)
        Character = newChar
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        lockedY = nil
        teleportActive = false
        lockYPosition()
    end
)
lockYPosition()
LocalPlayer.CharacterAdded:Connect(
    function()
        task.wait(1)
        running = false
        task.wait(0.1)
        StartAutoAttack()
    end
)
StartAutoAttack()
for _, category in ipairs({"gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish"}) do
    registerItems(ReplicatedStorage:WaitForChild("Items")[category])
end
Players.PlayerAdded:Connect(
    function(player)
        player.CharacterAdded:Connect(
            function()
                if ESPEnabled then
                    wait(0.2)
                    createBillboardForPlayer(player)
                end
            end
        )
    end
)
Players.PlayerRemoving:Connect(
    function(player)
        if BillboardCache[player] then
            BillboardCache[player]:Destroy()
            BillboardCache[player] = nil
        end
    end
)
for _, p in ipairs(Players:GetPlayers()) do
    setupFastFinishForPlayer(p)
end
Players.PlayerAdded:Connect(setupFastFinishForPlayer)
task.spawn(
    function()
        while true do
            task.wait(scanInterval)
            if fastFinishEnabled then
                for _, prompt in ipairs(findFinishPrompts()) do
                    task.spawn(
                        function()
                            tryHoldPrompt(prompt, holdTime)
                        end
                    )
                end
            end
        end
    end
)
SetupAutoSkip()
ReplicatedStorage.ChildAdded:Connect(
    function(child)
        if child.Name == "Remotes" then
            SetupAutoSkip()
        end
    end
)
Players.PlayerAdded:Connect(
    function(player)
        player.CharacterAdded:Connect(
            function(character)
                if highlightEnabled then
                    highlights[player] = createHighlight(character)
                end
                if espPlayers[player] and espPlayers[player].drawings then
                    local nameText = espPlayers[player].drawings[1]
                    nameText.Color =
                        isPlayerExcluded(player.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                end
            end
        )
    end
)
Players.PlayerRemoving:Connect(
    function(player)
        if espPlayers[player] then
            for _, obj in pairs(espPlayers[player].drawings) do
                if obj and obj.Destroy then
                    pcall(
                        function()
                            obj:Destroy()
                        end
                    )
                elseif typeof(obj) == "table" and obj.Visible ~= nil then
                    obj.Visible = false
                end
            end
            if espPlayers[player].conn then
                pcall(
                    function()
                        espPlayers[player].conn:Disconnect()
                    end
                )
            end
            espPlayers[player] = nil
        end
    end
)
task.spawn(
    function()
        while task.wait(1) do
            if highlightEnabled then
                updateHighlights()
            end
        end
    end
)
loadESP()
-- == UI Tabs ==
local Tab = Window:Tab({Title = "COMBAT:", Icon = "crosshair"})
Tab:Section({Title = "GUN:"})
local SilentToggle =
    Tab:Toggle(
    {
        Title = "Silent Aim",
        Default = false,
        Callback = function(state)
            SilentAimEnabled = state
            CurrentTarget = nil
            if state then
                SilentAimAttachEnabled = false
                if AttachToggle then
                    AttachToggle:Set(false)
                end
            end
        end
    }
)
myConfig:Register("SilentAim", SilentToggle)
local AttachToggle =
    Tab:Toggle(
    {
        Title = "Silent Aim (Attach Anti Lock)",
        Default = false,
        Callback = function(state)
            SilentAimAttachEnabled = state
            CurrentTarget = nil
            if state then
                SilentAimEnabled = false
                if SilentToggle then
                    SilentToggle:Set(false)
                end
            end
        end
    }
)
myConfig:Register("SilentAimAttach", AttachToggle)
local FOVSlider =
    Tab:Slider(
    {
        Title = "FOV: ",
        Step = 1,
        Value = {
            Min = 20,
            Max = 750,
            Default = FOVRadius
        },
        Callback = function(value)
            FOVRadius = tonumber(value) or 120
        end
    }
)
myConfig:Register("FOVRadius", FOVSlider)
local FriendsInput =
    Tab:Input(
    {
        Title = "Sefe Friend List",
        Desc = "Enter Player Name",
        Value = "",
        InputIcon = "shield-check",
        Type = "Input",
        Placeholder = "",
        Callback = function(input)
            excludedPlayerNames = {}
            for name in string.gmatch(input, "%S+") do
                table.insert(excludedPlayerNames, name)
            end
            for _, player in pairs(Players:GetPlayers()) do
                if espPlayers[player] and espPlayers[player].drawings then
                    local nameText = espPlayers[player].drawings[1]
                    nameText.Color =
                        isPlayerExcluded(player.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                end
            end
        end
    }
)
myConfig:Register("FriendsList", FriendsInput)
pcall(
    function()
        Tab:Divider()
    end
)
Tab:Section({Title = "COMBAT:"})
local FistsToggle =
    Tab:Toggle(
    {
        Title = "Fists In Car",
        Default = false,
        Callback = function(state)
            if state then
                local backpack = LocalPlayer:WaitForChild("Backpack")
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local function fixAttributes(fists)
                    if fists and fists:IsA("Tool") then
                        if fists:GetAttribute("Disabled") ~= nil then
                            fists:SetAttribute("Disabled", false)
                        end
                        if fists:GetAttribute("DisableInVehicle") ~= nil then
                            fists:SetAttribute("DisableInVehicle", false)
                        end
                    end
                end
                for _, v in ipairs(backpack:GetChildren()) do
                    if v.Name == "Fists" then
                        fixAttributes(v)
                    end
                end
                for _, v in ipairs(character:GetChildren()) do
                    if v.Name == "Fists" then
                        fixAttributes(v)
                    end
                end
                LocalPlayer.CharacterAdded:Connect(
                    function(char)
                        task.wait(1)
                        for _, v in ipairs(char:GetChildren()) do
                            if v.Name == "Fists" then
                                fixAttributes(v)
                            end
                        end
                    end
                )
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "✅ Attributes Updated",
                            Description = "Fists Attributes ถูกตั้งค่าแล้ว",
                            Duration = 3
                        }
                    )
                end
            end
        end
    }
)
myConfig:Register("FistsInCar", FistsToggle)
local HitAuraToggle =
    Tab:Toggle(
    {
        Title = "Hit aura",
        Default = false,
        Callback = function(state)
            hookEnabled = state
        end
    }
)
myConfig:Register("HitAura", HitAuraToggle)
local Tab_mods = Window:Tab({Title = "WEAPON:", Icon = "layers"})
Tab_mods:Section({Title = "MODS:"})
local FastShootButton =
    Tab_mods:Button(
    {
        Title = "Fast Shoot (No Recoil)",
        Default = false,
        Callback = function()
            local player = Players.LocalPlayer
            local character = player.Character
            if character then
                local tools = {}
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(tools, tool)
                    end
                end
                if #tools > 0 then
                    for _, tool in ipairs(tools) do
                        local attrs = tool:GetAttributes()
                        local attrNames = {}
                        for name, _ in pairs(attrs) do
                            table.insert(attrNames, name)
                        end
                        table.sort(attrNames)
                        if #attrNames >= 6 then
                            tool:SetAttribute(attrNames[6], 1500)
                        end
                        if tool:GetAttribute("Recoil") ~= nil then
                            tool:SetAttribute("Recoil", 0)
                        end
                    end
                    if WindUI then
                        WindUI:Notify(
                            {
                                Title = "✅ Tool Updated",
                                Description = "ปรับค่า Fast Shoot ให้ Tool ทั้งหมดเรียบร้อยแล้ว!",
                                Duration = 3
                            }
                        )
                    end
                else
                    if WindUI then
                        WindUI:Notify(
                            {
                                Title = "❌ No Tool Found",
                                Description = "กรุณาถือปืนก่อนจึงจะปรับค่าได้",
                                Duration = 3
                            }
                        )
                    end
                end
            else
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "❌ Character Not Found",
                            Description = "กรุณารีสปอร์นก่อนใช้งาน",
                            Duration = 3
                        }
                    )
                end
            end
        end
    }
)
myConfig:Register("FastShoot", FastShootButton)
local Tab_ESP = Window:Tab({Title = "ESP:", Icon = "eye"})
Tab_ESP:Section({Title = "ESP:"})
local BoxESPToggle =
    Tab_ESP:Toggle(
    {
        Title = "Box ESP",
        Default = false,
        Callback = function(state)
            boxESPEnabled = state
        end
    }
)
myConfig:Register("BoxESP", BoxESPToggle)
local NameESPToggle =
    Tab_ESP:Toggle(
    {
        Title = "Name ESP",
        Default = false,
        Callback = function(state)
            nameESPEnabled = state
        end
    }
)
myConfig:Register("NameESP", NameESPToggle)
local HealthESPToggle =
    Tab_ESP:Toggle(
    {
        Title = "Health ESP",
        Default = false,
        Callback = function(state)
            healthESPEnabled = state
        end
    }
)
myConfig:Register("HealthESP", HealthESPToggle)
local DistanceESPToggle =
    Tab_ESP:Toggle(
    {
        Title = "Distance ESP",
        Default = false,
        Callback = function(state)
            distanceESPEnabled = state
        end
    }
)
myConfig:Register("DistanceESP", DistanceESPToggle)
local HighlightToggle =
    Tab_ESP:Toggle(
    {
        Title = "Highlight",
        Default = false,
        Callback = function(state)
            highlightEnabled = state
            if not state then
                for _, hl in pairs(highlights) do
                    if hl and hl.Destroy then
                        pcall(
                            function()
                                hl:Destroy()
                            end
                        )
                    end
                end
                highlights = {}
            else
                pcall(
                    function()
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl ~= LocalPlayer and pl.Character then
                                if not highlights[pl] then
                                    local ok, newHl =
                                        pcall(
                                        function()
                                            local h = Instance.new("Highlight")
                                            h.FillColor = Color3.fromRGB(200, 0, 255)
                                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                            h.FillTransparency = 0.3
                                            h.OutlineTransparency = 0
                                            h.Parent = pl.Character or Workspace
                                            h.Adornee = pl.Character
                                            return h
                                        end
                                    )
                                    if ok and newHl then
                                        highlights[pl] = newHl
                                    end
                                end
                            end
                        end
                    end
                )
            end
        end
    }
)
myConfig:Register("Highlight", HighlightToggle)
local ItemsESPToggle =
    Tab_ESP:Toggle(
    {
        Title = "Items ESP",
        Default = false,
        Callback = function(state)
            ESPEnabled = state
            if state then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        createBillboardForPlayer(p)
                    end
                end
                ESPConnection =
                    RunService.Heartbeat:Connect(
                    function()
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                createBillboardForPlayer(p)
                            end
                        end
                    end
                )
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "✅ ESP Items Enabled",
                            Description = "✅ Item ESP functionality activated",
                            Duration = 3
                        }
                    )
                end
            else
                if ESPConnection then
                    ESPConnection:Disconnect()
                    ESPConnection = nil
                end
                for _, billboard in pairs(BillboardCache) do
                    billboard:Destroy()
                end
                BillboardCache = {}
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "❌ ESP Items Disabled",
                            Description = "❌ Item ESP functionality deactivated",
                            Duration = 3
                        }
                    )
                end
            end
        end
    }
)
myConfig:Register("ItemsESP", ItemsESPToggle)
local Tab_Character = Window:Tab({Title = "CHARACTER:", Icon = "user"})
Tab_Character:Section({Title = "CHARACTER:"})
local WalkSpeedToggle =
    Tab_Character:Toggle(
    {
        Title = "Walk Speed",
        Default = false,
        Callback = function(state)
            walkSpeedEnabled = state
        end
    }
)
myConfig:Register("WalkSpeed", WalkSpeedToggle)
local SpeedSlider =
    Tab_Character:Slider(
    {
        Title = "Speed Multiplier",
        Step = 0.5,
        Value = {
            Min = 1,
            Max = 3,
            Default = 2
        },
        Callback = function(value)
            speedValue = value * 0.07
        end
    }
)
myConfig:Register("SpeedMultiplier", SpeedSlider)
local JumpPowerToggle =
    Tab_Character:Toggle(
    {
        Title = "Jump Power",
        Default = false,
        Callback = function(state)
            FlyEnabled = state
            if not FlyEnabled then
                flying = false
            end
        end
    }
)
myConfig:Register("JumpPower", JumpPowerToggle)
-- รอ
local Net = {}
function Net.send(...)
    local args = {...}
    CounterTable.event = CounterTable.event + 1
    pcall(
        function()
            Remotes.Send:FireServer(CounterTable.event, unpack(args))
        end
    )
end
local AutoSprintToggle =
    Tab_Character:Toggle(
    {
        Title = "Infinite Stamina",
        Default = false,
        Callback = function(state)
            AutoSprintEnabled = state
            if AutoSprintEnabled then
                -- Override stamina update to prevent depletion
                local success, SprintModule =
                    pcall(
                    function()
                        return require(ReplicatedStorage.Modules.Game.Sprint)
                    end
                )
                if success and SprintModule then
                    local consume_stamina = SprintModule.consume_stamina
                    local SprintBar = getupvalue(consume_stamina, 2).sprint_bar
                    if SprintBar then
                        local Old = SprintBar.update
                        SprintBar.update = function(...)
                            return Old(
                                function()
                                    return 1
                                end
                            ) -- Keep stamina at full
                        end
                        -- Store original function for restoration
                        getgenv().OriginalSprintUpdate = Old
                        -- Start auto sprint loop
                        getgenv().AutoSprintLoop =
                            task.spawn(
                            function()
                                while AutoSprintEnabled do
                                    pcall(
                                        function()
                                            Net.send("set_sprinting_1", true)
                                            task.wait(0.5)
                                            Net.send("set_sprinting_1", false)
                                        end
                                    )
                                    task.wait(0.1) -- Prevent excessive CPU usage
                                end
                                -- Ensure sprint is disabled when loop ends
                                pcall(
                                    function()
                                        Net.send("set_sprinting_1", false)
                                    end
                                )
                            end
                        )
                        if WindUI then
                            WindUI:Notify(
                                {
                                    Title = "✅ INF STAMINA",
                                    Description = "Auto Sprint และ Infinite Stamina ทำงานแล้ว",
                                    Duration = 3
                                }
                            )
                        end
                    else
                        warn("❌ ไม่พบ SprintBar!")
                        AutoSprintEnabled = false
                        AutoSprintToggle:Set(false)
                    end
                else
                    warn("❌ ไม่สามารถโหลด SprintModule ได้!")
                    AutoSprintEnabled = false
                    AutoSprintToggle:Set(false)
                end
            else
                -- Stop sprint loop and restore stamina behavior
                if getgenv().AutoSprintLoop then
                    task.cancel(getgenv().AutoSprintLoop)
                    getgenv().AutoSprintLoop = nil
                end
                -- Ensure sprint is disabled
                pcall(
                    function()
                        Net.send("set_sprinting_1", false)
                    end
                )
                -- Restore original stamina update function
                local success, SprintModule =
                    pcall(
                    function()
                        return require(ReplicatedStorage.Modules.Game.Sprint)
                    end
                )
                if success and SprintModule then
                    local consume_stamina = SprintModule.consume_stamina
                    local SprintBar = getupvalue(consume_stamina, 2).sprint_bar
                    if SprintBar and getgenv().OriginalSprintUpdate then
                        SprintBar.update = getgenv().OriginalSprintUpdate
                        getgenv().OriginalSprintUpdate = nil
                    end
                end
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "❌ Auto Sprint Disabled",
                            Description = "Auto Sprint และ Infinite Stamina ถูกปิดแล้ว",
                            Duration = 3
                        }
                    )
                end
            end
        end
    }
)
myConfig:Register("AutoSprint", AutoSprintToggle)
local AntiLockToggle =
    Tab_Character:Toggle(
    {
        Title = "Anti Lock",
        Default = false,
        Callback = function(state)
            getgenv().Sky = state
            if state then
                getgenv().SkyAmount = 1500
            end
        end
    }
)
myConfig:Register("AntiLock", AntiLockToggle)
local AntiKillToggle =
    Tab_Character:Toggle(
    {
        Title = "Anti Kill",
        Default = false,
        Callback = function(state)
            enabled = state
            if state then
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "🛡️ Anti Kill Enabled",
                            Description = "คุณจะวาร์ปใต้พื้นและเคลื่อนที่รอบๆ 10m เพื่อหลบการโจมตี",
                            Duration = 3
                        }
                    )
                end
            else
                if WindUI then
                    WindUI:Notify(
                        {
                            Title = "❌ Anti Kill Disabled",
                            Description = "ระบบป้องกันถูกปิดแล้ว",
                            Duration = 3
                        }
                    )
                end
            end
        end
    }
)
myConfig:Register("AntiKill", AntiKillToggle)
pcall(
    function()
        if Tab_Character and typeof(Tab_Character.Divider) == "function" then
            Tab_Character:Divider()
        end
    end
)
pcall(
    function()
        if Tab_Character and typeof(Tab_Character.Section) == "function" then
            Tab_Character:Section({Title = "Att:"})
        end
    end
)
local PickupToggle =
    Tab_Character:Toggle(
    {
        Title = "Pickup items",
        Default = false,
        Callback = function(state)
            sucking = state
        end
    }
)
myConfig:Register("PickupItems", PickupToggle)
local AntiRagdollToggle =
    Tab_Character:Toggle(
    {
        Title = "Anti Ragdoll",
        Default = false,
        Callback = function(state)
            local _AntiRagdollEnabled = state
            if not _AntiRagdollEnabled then
                return
            end
            pcall(
                function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local Players = game:GetService("Players")
                    local player = Players.LocalPlayer
                    local function findCounter()
                        for _, obj in ipairs(getgc and getgc(true) or {}) do
                            if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then
                                return obj
                            end
                        end
                    end
                    local CounterTable = findCounter()
                    if not CounterTable then
                        return
                    end
                    local function sendRemoteAction(action)
                        CounterTable.event = (CounterTable.event or 0) + 1
                        local SendRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send")
                        SendRemote:FireServer(CounterTable.event, action)
                    end
                    task.spawn(
                        function()
                            while _AntiRagdollEnabled do
                                sendRemoteAction("end_ragdoll_early")
                                task.wait(0.3)
                                if not _AntiRagdollEnabled then
                                    break
                                end
                                sendRemoteAction("clear_ragdoll")
                                task.wait(0.3)
                            end
                        end
                    )
                end
            )
        end
    }
)
myConfig:Register("AntiRagdoll", AntiRagdollToggle)
local HideNameToggle =
    Tab_Character:Toggle(
    {
        Title = "Hide Name",
        Default = false,
        Callback = function(state)
            pcall(
                function()
                    local player = Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    local gui = hrp:FindFirstChild("CharacterBillboardGui")
                    if gui then
                        local nameLabel = gui:FindFirstChild("PlayerName")
                        if nameLabel and nameLabel:IsA("TextLabel") then
                            nameLabel.Visible = not state
                        end
                    end
                end
            )
        end
    }
)
myConfig:Register("HideName", HideNameToggle)
local AutoRespawnToggle =
    Tab_Character:Toggle(
    {
        Title = "Auto Respawn",
        Default = false,
        Callback = function(state)
            local _AutoRespawnEnabled = state
            if not _AutoRespawnEnabled then
                return
            end
            pcall(
                function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local Players = game:GetService("Players")
                    local player = Players.LocalPlayer
                    local function findCounter()
                        for _, obj in ipairs(getgc and getgc(true) or {}) do
                            if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then
                                return obj
                            end
                        end
                    end
                    local CounterTable = findCounter()
                    if not CounterTable then
                        return
                    end
                    local function sendRemoteAction(action)
                        CounterTable.event = (CounterTable.event or 0) + 1
                        local SendRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send")
                        SendRemote:FireServer(CounterTable.event, action)
                    end
                    task.spawn(
                        function()
                            while _AutoRespawnEnabled do
                                local char = player.Character
                                local hum = char and char:FindFirstChildOfClass("Humanoid")
                                if hum and hum.Health <= 0 then
                                    task.wait(6.2)
                                    if _AutoRespawnEnabled then
                                        sendRemoteAction("death_screen_request_respawn")
                                    end
                                end
                                task.wait(0.5)
                            end
                        end
                    )
                end
            )
        end
    }
)
myConfig:Register("AutoRespawn", AutoRespawnToggle)
Tab_Character:Divider()
Tab_Character:Section({Title = "FOR PC HOLD (Z)"})
local SnapToggle =
    Tab_Character:Toggle(
    {
        Title = "Snap Under Map",
        Default = false,
        Callback = function(state)
            featureEnabled = state
            if featureEnabled then
                startY = HumanoidRootPart and HumanoidRootPart.Position.Y or nil
                teleportActive = true
                performTeleport()
            else
                teleportActive = false
                lockedY = nil
                startY = nil
            end
        end
    }
)
myConfig:Register("SnapUnderMap", SnapToggle)
local SnapSlider =
    Tab_Character:Slider(
    {
        Title = "Snap:",
        Step = 1,
        Value = {Min = 1, Max = 50, Default = 10},
        Callback = function(value)
            maxHeight = value
            if teleportActive and HumanoidRootPart and startY then
                local bottomPos =
                    Vector3.new(HumanoidRootPart.Position.X, startY - maxHeight, HumanoidRootPart.Position.Z)
                HumanoidRootPart.CFrame = CFrame.new(bottomPos)
                lockedY = bottomPos.Y
            end
        end
    }
)
myConfig:Register("SnapHeight", SnapSlider)
local Tab_player = Window:Tab({Title = "PLAYER:", Icon = "person-standing"})
Tab_player:Section({Title = "PLAYER:"})
local Input =
    Tab_player:Input(
    {
        Title = "Player Name:",
        Desc = "Player name troll",
        Value = "",
        InputIcon = "user",
        Type = "Input",
        Placeholder = "",
        Callback = function(input)
            SelectedPlayer = input
        end
    }
)
myConfig:Register("PlayerNameInput", Input)
local StartButton =
    Tab_player:Button(
    {
        Title = "Start",
        Desc = "Hold to Start troll",
        Locked = false,
        Callback = function()
            if not SelectedPlayer or SelectedPlayer == "" then
                return
            end
            ToggleBring(SelectedPlayer)
        end
    }
)
myConfig:Register("StartButton", StartButton)
local StopButton =
    Tab_player:Button(
    {
        Title = "Stop",
        Desc = "Hold to Stop troll",
        Locked = false,
        Callback = function()
            if Active then
                Active = false
                if BringConnection then
                    BringConnection:Disconnect()
                end
            end
        end
    }
)
myConfig:Register("StopButton", StopButton)
local Folder = Instance.new("Folder", Workspace)
local CorePart = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", CorePart)
CorePart.Anchored = true
CorePart.CanCollide = false
CorePart.Transparency = 1
Tab_player:Divider()
local AutoFinnishToggle =
    Tab_player:Toggle(
    {
        Title = "Auto Finnish",
        Default = false,
        Callback = function(state)
            fastFinishEnabled = state
            if state then
                applyToAll()
                if WindUI then
                    WindUI:Notify({Title = "✅ Auto Finish Enabled", Description = "✅ Auto Enabled", Duration = 3})
                end
            else
                if WindUI then
                    WindUI:Notify({Title = "❌ Auto Disabled", Description = "❌ Auto Disabled", Duration = 3})
                end
            end
        end
    }
)
myConfig:Register("AutoFinnish", AutoFinnishToggle)
-- Tab BUY
local Tab_buyer = Window:Tab({Title = "BUY:", Icon = "landmark"})
Tab_buyer:Section({Title = "BUY:"})
local function safeToggle(title, desc, key, callback)
    pcall(
        function()
            local ToggleElement =
                Tab_buyer:Toggle(
                {
                    Title = title,
                    Desc = desc,
                    Icon = "check",
                    Type = "Checkbox",
                    Default = false,
                    Callback = function(state)
                        AutoSkipEnabled = state
                        if callback then
                            callback(state)
                        end
                    end
                }
            )
            myConfig:Register(key, ToggleElement)
        end
    )
end
-- ใช้งาน:
safeToggle(
    "Skip Crate Spin",
    "ข้ามการหมุนกล่องอัตโนมัติ",
    "SkipCrate",
    function(state)
        if state then
            TrySkipCrate()
        end
    end
)
myConfig:Register("SkipCrate", SkipCrateToggle)
-- Tab MISC
local Tab_misc = Window:Tab({Title = "MISC:", Icon = "warehouse"})
-- ปุ่ม Claim All Quest
local ClaimAllQuestButton =
    Tab_misc:Button(
    {
        Title = "Claim All Quest",
        Callback = function()
            task.spawn(
                function()
                    local success, err =
                        pcall(
                        function()
                            local Players = game:GetService("Players")
                            local ReplicatedStorage = game:GetService("ReplicatedStorage")
                            local player = Players.LocalPlayer
                            -- หา CounterTable อย่างปลอดภัย
                            local function findCounter()
                                for _, obj in ipairs(getgc and getgc(true) or {}) do
                                    if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then
                                        return obj
                                    end
                                end
                                return nil
                            end
                            local CounterTable = findCounter()
                            if not CounterTable then
                                return
                            end
                            -- ฟังก์ชันส่ง Remote แบบ local
                            local Net = {}
                            function Net.get(...)
                                local args = {...}
                                CounterTable.func = (CounterTable.func or 0) + 1
                                local GetRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
                                return GetRemote:InvokeServer(CounterTable.func, table.unpack(args))
                            end
                            local questFrame =
                                player:WaitForChild("PlayerGui"):WaitForChild("Quests"):WaitForChild("QuestsHolder"):WaitForChild(
                                "QuestsScrollingFrame"
                            )
                            for _, child in ipairs(questFrame:GetChildren()) do
                                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
                                    Net.get("claim_quest", child.Name)
                                    task.wait(0.2)
                                end
                            end
                        end
                    )
                    if success then
                        print("Claim All Quests Completed")
                    else
                        warn(err)
                    end
                end
            )
        end
    }
)
myConfig:Register("ClaimAllQuest", ClaimAllQuestButton)
-- แทนที่การเข้าถึงโดยตรงด้วยตัวแปร
local saveFunc = myConfig["Save"]
local deleteFunc = myConfig["Delete"]
local loadFunc = myConfig["Load"]
-- สร้าง Section
Tab_misc:Section({Title = "Config Management"})
-- ปุ่มบันทึก Config
local SaveConfigButton =
    Tab_misc:Button(
    {
        Title = "Save Config",
        Callback = function()
            if saveFunc then
                saveFunc(myConfig)
            end
        end
    }
)
myConfig:Register("SaveConfig", SaveConfigButton)
-- ปุ่มลบ Config
local DeleteConfigButton =
    Tab_misc:Button(
    {
        Title = "Delete Config",
        Callback = function()
            if deleteFunc then
                deleteFunc(myConfig)
            end
        end
    }
)
myConfig:Register("DeleteConfig", DeleteConfigButton)
-- โหลด Config
if loadFunc then
    loadFunc(myConfig)
end
