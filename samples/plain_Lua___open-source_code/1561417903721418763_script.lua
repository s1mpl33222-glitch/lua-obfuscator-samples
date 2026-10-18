local utility = {
    dropkick = Instance.new("Animation"),
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    Debris = game:GetService("Debris"),
    HttpService = game:GetService("HttpService"),
    StarterGui = game:GetService("StarterGui"),
    conns = {}
}

utility.dropkick.AnimationId = "rbxassetid://133566007754001"

task.spawn(function()
    local instancesToLoad = {}
    table.insert(instancesToLoad, utility.dropkick)

    local gearPreload = Instance.new("ImageLabel")
    gearPreload.Image = "rbxthumb://type=Asset&id=7059346386&w=420&h=420"
    table.insert(instancesToLoad, gearPreload)

    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync(instancesToLoad)
    end)
end)

utility.selectedMethod = "Click"
utility.selectedKey = Enum.KeyCode.F
utility.flingForce = 5000

utility.keyListening = false
utility.recordingKey = false
utility.actionRunning = false
utility.menuOpen = false
utility.uiReady = false
utility.actionId = 0
utility.currentTrack = nil
utility.AnimationCutTime = 0.3
utility.savedWalkSpeed = nil
utility.savedAutoRotate = true
utility.walkflinging = false
utility.cacheFolder = "DropKick by Yes"
utility.cacheFile = utility.cacheFolder .. "/cache.json"

utility.noClipConnections = {}
utility.noClipNotificationSent = false
utility.noCollisionConstraints = {}

function utility:CheckValidRigType(h)
    local s, r = pcall(function()
        return h.RigType == Enum.HumanoidRigType.R15
    end)
    if s and r then
        return true
    end
    return false
end

function utility:LoadSettings()
    local success, content = pcall(function()
        return readfile(self.cacheFile)
    end)

    if success and content then
        local ok, data = pcall(function()
            return self.HttpService:JSONDecode(content)
        end)

        if ok and data then
            if data.selectedMethod then
                self.selectedMethod = data.selectedMethod
            end

            if data.selectedKey then
                local key = Enum.KeyCode[data.selectedKey]
                if key then
                    self.selectedKey = key
                end
            end

            if data.flingForce then
                self.flingForce = math.clamp(
                    tonumber(data.flingForce) or 5000,
                    500,
                    25000
                )
            end
        end
    end
end

function utility:SaveSettings()
    local data = {
        selectedMethod = self.selectedMethod,
        selectedKey = self.selectedKey.Name,
        flingForce = self.flingForce
    }

    local json = self.HttpService:JSONEncode(data)

    pcall(function()
        writefile(self.cacheFile, json)
    end)
end

function utility:Notify(title, text)
    pcall(function()
        self.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 10
        })
    end)
end

function utility:CleanupPlayerNoCollision(player)
    local data = self.noCollisionConstraints[player]
    if not data then return end

    for _, connection in pairs(data.connections or {}) do
        pcall(function() connection:Disconnect() end)
    end

    for _, constraint in pairs(data.constraints or {}) do
        pcall(function() constraint:Destroy() end)
    end

    self.noCollisionConstraints[player] = nil
end

function utility:SetupPlayerNoCollision(player)
    if not player or player == self.LocalPlayer then return end

    self:CleanupPlayerNoCollision(player)

    local localCharacter = self.LocalPlayer.Character
    local targetCharacter = player.Character

    if not localCharacter or not targetCharacter then return end

    local data = {
        constraints = {},
        connections = {}
    }

    self.noCollisionConstraints[player] = data

    local function createConstraint(localPart, targetPart)
        if not localPart:IsA("BasePart") or not targetPart:IsA("BasePart") then return end
        if not localPart.Parent or not targetPart.Parent then return end

        local constraint = Instance.new("NoCollisionConstraint")
        constraint.Part0 = localPart
        constraint.Part1 = targetPart
        constraint.Parent = localCharacter
        table.insert(data.constraints, constraint)
    end

    local localParts = {}
    for _, part in ipairs(localCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(localParts, part)
        end
    end

    local function addTargetPart(targetPart)
        if not targetPart:IsA("BasePart") then return end
        for _, localPart in ipairs(localParts) do
            createConstraint(localPart, targetPart)
        end
    end

    for _, targetPart in ipairs(targetCharacter:GetDescendants()) do
        addTargetPart(targetPart)
    end

    data.connections.targetAdded = targetCharacter.DescendantAdded:Connect(function(descendant)
        addTargetPart(descendant)
    end)

    data.connections.localAdded = localCharacter.DescendantAdded:Connect(function(descendant)
        if not descendant:IsA("BasePart") then return end
        for _, targetPart in ipairs(targetCharacter:GetDescendants()) do
            createConstraint(descendant, targetPart)
        end
    end)
end

function utility:SetupGlobalNoClip()
    local function setupPlayer(player)
        if player == self.LocalPlayer then return end

        local function setupCharacter(character)
            task.defer(function()
                if player ~= self.LocalPlayer and character == player.Character then
                    self:SetupPlayerNoCollision(player)
                end
            end)
        end

        if player.Character then
            setupCharacter(player.Character)
        end

        self.noClipConnections[player] = self.noClipConnections[player] or {}

        if self.noClipConnections[player].characterAdded then
            self.noClipConnections[player].characterAdded:Disconnect()
        end

        self.noClipConnections[player].characterAdded = player.CharacterAdded:Connect(setupCharacter)

        if self.noClipConnections[player].characterRemoving then
            self.noClipConnections[player].characterRemoving:Disconnect()
        end

        self.noClipConnections[player].characterRemoving = player.CharacterRemoving:Connect(function()
            self:CleanupPlayerNoCollision(player)
        end)
    end

    for _, player in ipairs(self.Players:GetPlayers()) do
        setupPlayer(player)
    end

    if self.noClipPlayerAdded then
        self.noClipPlayerAdded:Disconnect()
    end

    self.noClipPlayerAdded = self.Players.PlayerAdded:Connect(function(player)
        setupPlayer(player)
    end)

    if self.noClipPlayerRemoving then
        self.noClipPlayerRemoving:Disconnect()
    end

    self.noClipPlayerRemoving = self.Players.PlayerRemoving:Connect(function(player)
        self:CleanupPlayerNoCollision(player)

        local connections = self.noClipConnections[player]
        if connections then
            for _, connection in pairs(connections) do
                pcall(function() connection:Disconnect() end)
            end
            self.noClipConnections[player] = nil
        end
    end)

    if self.noClipLocalCharacterAdded then
        self.noClipLocalCharacterAdded:Disconnect()
    end

    self.noClipLocalCharacterAdded = self.LocalPlayer.CharacterAdded:Connect(function()
        task.defer(function()
            for _, player in ipairs(self.Players:GetPlayers()) do
                if player ~= self.LocalPlayer and player.Character then
                    self:SetupPlayerNoCollision(player)
                end
            end
        end)
    end)
end

function utility:ShowStartup()
    local playerGui = self.LocalPlayer:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "YesDevStartup"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.Parent = playerGui

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    overlay.BackgroundTransparency = 0.25
    overlay.BorderSizePixel = 0
    overlay.Parent = gui

    local container = Instance.new("Frame")
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.Size = UDim2.fromOffset(175, 85)
    container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    container.BackgroundTransparency = 0.05
    container.BorderSizePixel = 0
    container.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1
    stroke.Transparency = 0.15
    stroke.Parent = container

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.new(0.5, 0, 0.36, 0)
    title.Size = UDim2.new(1, -16, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Enjoy!"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 23
    title.Font = Enum.Font.GothamBold
    title.Parent = container

    local credit = Instance.new("TextLabel")
    credit.AnchorPoint = Vector2.new(0.5, 0.5)
    credit.Position = UDim2.new(0.5, 0, 0.67, 0)
    credit.Size = UDim2.new(1, -16, 0, 20)
    credit.BackgroundTransparency = 1
    credit.Text = "By yes.dev"
    credit.TextColor3 = Color3.fromRGB(150, 150, 150)
    credit.TextSize = 12
    credit.Font = Enum.Font.GothamMedium
    credit.Parent = container

    container.Size = UDim2.fromOffset(165, 80)
    container.BackgroundTransparency = 1
    stroke.Transparency = 1
    title.TextTransparency = 1
    credit.TextTransparency = 1

    container:TweenSize(UDim2.fromOffset(175, 85), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.35, true)

    self.TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0.05 }):Play()
    self.TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0.15 }):Play()
    self.TweenService:Create(title, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
    self.TweenService:Create(credit, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()

    task.wait(3.25)

    local fadeInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    self.TweenService:Create(overlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
    self.TweenService:Create(container, fadeInfo, { BackgroundTransparency = 1, Size = UDim2.fromOffset(165, 80) }):Play()
    self.TweenService:Create(stroke, fadeInfo, { Transparency = 1 }):Play()
    self.TweenService:Create(title, fadeInfo, { TextTransparency = 1 }):Play()
    self.TweenService:Create(credit, fadeInfo, { TextTransparency = 1 }):Play()

    task.wait(0.5)
    gui:Destroy()
end

function utility:StartWalkFling(character)
    if self.walkflinging then return end

    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    humanoid.BreakJointsOnDeath = false

    self.walkflinging = true

    task.spawn(function()
        while self.walkflinging and root and root.Parent do
            self.RunService.Heartbeat:Wait()
            if not self.walkflinging then break end

            local originalVel = root.Velocity
            root.Velocity = originalVel * 999999 + Vector3.new(0, 999999, 0)

            self.RunService.RenderStepped:Wait()
            if not self.walkflinging then break end

            root.Velocity = originalVel

            self.RunService.Stepped:Wait()
            if not self.walkflinging then break end

            root.Velocity = originalVel + Vector3.new(0, 0.1, 0)
        end
    end)
end

function utility:StopWalkFling()
    self.walkflinging = false

    local character = self.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid.BreakJointsOnDeath = true

        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end

        humanoid.PlatformStand = false
    end
end

function utility:FlingNearbyPlayers(userRoot, radius)
    local camera = workspace.CurrentCamera
    if not camera then return end

    local userLook = camera.CFrame.LookVector
    userLook = Vector3.new(userLook.X, 0, userLook.Z).Unit

    local flingDir = (userLook * 3 + Vector3.new(0, 0.4, 0)).Unit
    local force = self.flingForce
    local upForce = force * 0.0833

    for _, player in ipairs(self.Players:GetPlayers()) do
        if player ~= self.LocalPlayer and player.Character then
            local targetChar = player.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChild("Humanoid")

            if targetRoot and targetHum and targetHum.Health > 0 then
                local distance = (targetRoot.Position - userRoot.Position).Magnitude

                if distance <= radius then
                    pcall(function()
                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                        targetHum.PlatformStand = true

                        for _ = 1, 5 do
                            targetRoot:RequestNetworkOwnership()
                            task.wait(0.01)
                        end

                        local finalVel = flingDir * force + Vector3.new(0, upForce, 0)

                        for _, part in ipairs(targetChar:GetDescendants()) do
                            if part:IsA("BasePart") and part.AssemblyLinearVelocity then
                                part.AssemblyLinearVelocity = finalVel
                            end
                        end

                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Velocity = finalVel
                        bv.Parent = targetRoot
                        self.Debris:AddItem(bv, 0.5)

                        targetRoot.AssemblyAngularVelocity = Vector3.new(
                            math.random(-20, 20),
                            math.random(-20, 20),
                            math.random(-20, 20)
                        )
                    end)
                end
            end
        end
    end
end

function utility:PerformDropkick()
    if self.keyListening or self.recordingKey then return end
    if self.selectedMethod == "None" then return end

    local character = self.LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end

    local leg = character:FindFirstChild("LeftLowerLeg")
    if not leg then return end

    self.actionId += 1
    local thisActionId = self.actionId

    if self.currentTrack then
        pcall(function()
            self.currentTrack:Stop(0)
            self.currentTrack:Destroy()
        end)
        self.currentTrack = nil
    end

    self.actionRunning = true

    local originalWalkSpeed = humanoid.WalkSpeed
    local originalAutoRotate = humanoid.AutoRotate

    self.savedWalkSpeed = originalWalkSpeed
    self.savedAutoRotate = originalAutoRotate

    humanoid.AutoRotate = true
    humanoid.WalkSpeed = originalWalkSpeed

    local track
    local success = pcall(function()
        track = animator:LoadAnimation(self.dropkick)
    end)

    if not success or not track then
        if self.actionId == thisActionId then
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.AutoRotate = originalAutoRotate
            self.actionRunning = false
        end
        return
    end

    if self.actionId ~= thisActionId then
        pcall(function() track:Stop(0); track:Destroy() end)
        return
    end

    self.currentTrack = track
    track.Priority = Enum.AnimationPriority.Action
    track:Play(0)

    self:StartWalkFling(character)

    task.wait()

    if self.actionId ~= thisActionId then
        pcall(function() track:Stop(0); track:Destroy() end)
        self:StopWalkFling()
        return
    end

    local animationLength = track.Length
    if animationLength <= 0 then animationLength = 1 end

    local playTime = math.max(0.05, animationLength - self.AnimationCutTime)
    local startTime = os.clock()

    while track.IsPlaying and os.clock() - startTime < playTime do
        if self.actionId ~= thisActionId then
            if leg and leg.Parent then
                leg.AssemblyLinearVelocity = Vector3.zero
                leg.AssemblyAngularVelocity = Vector3.zero
            end
            pcall(function() track:Stop(0); track:Destroy() end)
            self:StopWalkFling()
            return
        end

        if not character.Parent then break end

        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.AutoRotate = true
        end

        self.RunService.Heartbeat:Wait()

        if self.actionId ~= thisActionId then
            if leg and leg.Parent then
                leg.AssemblyLinearVelocity = Vector3.zero
                leg.AssemblyAngularVelocity = Vector3.zero
            end
            self:StopWalkFling()
            return
        end

        leg = character:FindFirstChild("LeftLowerLeg")
        if not leg then break end

        local moveDirection = humanoid.MoveDirection
        local currentY = leg.AssemblyLinearVelocity.Y

        if moveDirection.Magnitude > 0.001 then
            local desiredHorizontal = moveDirection.Unit * originalWalkSpeed
            leg.AssemblyLinearVelocity = Vector3.new(desiredHorizontal.X, currentY, desiredHorizontal.Z)
        else
            leg.AssemblyLinearVelocity = Vector3.new(0, currentY, 0)
        end

        leg.AssemblyAngularVelocity = Vector3.zero

        self:FlingNearbyPlayers(character.HumanoidRootPart, 10)

        self.RunService.RenderStepped:Wait()

        if self.actionId ~= thisActionId then
            if leg and leg.Parent then
                leg.AssemblyLinearVelocity = Vector3.zero
                leg.AssemblyAngularVelocity = Vector3.zero
            end
            self:StopWalkFling()
            return
        end

        if leg and leg.Parent then
            local direction = humanoid.MoveDirection
            if direction.Magnitude > 0.001 then
                local desiredHorizontal = direction.Unit * originalWalkSpeed
                leg.AssemblyLinearVelocity = Vector3.new(desiredHorizontal.X, leg.AssemblyLinearVelocity.Y, desiredHorizontal.Z)
            else
                leg.AssemblyLinearVelocity = Vector3.new(0, leg.AssemblyLinearVelocity.Y, 0)
            end
            leg.AssemblyAngularVelocity = Vector3.zero
        end

        self.RunService.Stepped:Wait()

        if self.actionId ~= thisActionId then
            if leg and leg.Parent then
                leg.AssemblyLinearVelocity = Vector3.zero
                leg.AssemblyAngularVelocity = Vector3.zero
            end
            self:StopWalkFling()
            return
        end

        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.AutoRotate = true
        end
    end

    if self.actionId ~= thisActionId then
        pcall(function() track:Stop(0); track:Destroy() end)
        self:StopWalkFling()
        return
    end

    if track.IsPlaying then track:Stop(0) end

    if humanoid and humanoid.Parent then
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.AutoRotate = originalAutoRotate
    end

    leg = character:FindFirstChild("LeftLowerLeg")
    if leg and leg.Parent then
        leg.AssemblyLinearVelocity = Vector3.zero
        leg.AssemblyAngularVelocity = Vector3.zero
    end

    if self.currentTrack == track then
        self.currentTrack = nil
    end

    self.actionRunning = false
    self:StopWalkFling()

    pcall(function() track:Destroy() end)
end

function utility:MouseDetection()
    local mouse = self.LocalPlayer:GetMouse()

    if self.conns.mouse then
        self.conns.mouse:Disconnect()
    end

    self.conns.mouse = mouse.Button1Down:Connect(function()
        if self.selectedMethod ~= "Click" then return end
        if self.keyListening or self.recordingKey then return end

        local position = self.UserInputService:GetMouseLocation()
        local objects = self.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(position.X, position.Y)

        for _, object in ipairs(objects) do
            if object:IsDescendantOf(self.MainUI) then return end
        end

        self:PerformDropkick()
    end)
end

function utility:StartKeyDetection()
    if self.conns.key then
        self.conns.key:Disconnect()
    end

    self.conns.key = self.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if self.keyListening or self.recordingKey then return end
        if self.selectedMethod ~= "Key" then return end

        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.selectedKey then
            self:PerformDropkick()
        end
    end)
end

function utility:CreateButton(parent, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

function utility:UpdateUI()
    local clickColor = Color3.fromRGB(20, 20, 20)
    local keyColor = Color3.fromRGB(20, 20, 20)
    local uiColor = Color3.fromRGB(20, 20, 20)

    if self.selectedMethod == "Click" then
        clickColor = Color3.fromRGB(45, 45, 45)
    elseif self.selectedMethod == "Key" then
        keyColor = Color3.fromRGB(45, 45, 45)
    elseif self.selectedMethod == "UI Button" then
        uiColor = Color3.fromRGB(45, 45, 45)
    end

    self.ClickButton.BackgroundColor3 = clickColor
    self.KeyButton.BackgroundColor3 = keyColor
    self.UIButton.BackgroundColor3 = uiColor

    self.KeyConfig.Visible = self.selectedMethod == "Key"
    self.ActionButton.Visible = self.uiReady and self.selectedMethod == "UI Button"

    if self.selectedMethod == "Key" and not self.keyListening then
        self.KeyBox.Text = self.selectedKey.Name
    end

    self:ResizePanel()
end

function utility:ResizePanel()
    if not self.menuOpen then return end

    local height = 165
    if self.selectedMethod == "Key" then
        height += 42
    end

    self.Panel:TweenSize(
        UDim2.fromOffset(180, height),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.15,
        true
    )
end

function utility:CreateUI()
    local playerGui = self.LocalPlayer:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "DropkickController"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    self.MainUI = gui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(52, 52)
    main.Position = UDim2.new(0.3, 0, 0.35, 0)
    main.BackgroundTransparency = 1
    main.Parent = gui

    self.Main = main

    local gear = Instance.new("ImageButton")
    gear.Name = "Gear"
    gear.Size = UDim2.fromOffset(52, 52)
    gear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    gear.BorderSizePixel = 0
    gear.Image = ""
    gear.AutoButtonColor = false
    gear.Parent = main

    local gearCorner = Instance.new("UICorner")
    gearCorner.CornerRadius = UDim.new(0, 10)
    gearCorner.Parent = gear

    local gearStroke = Instance.new("UIStroke")
    gearStroke.Color = Color3.fromRGB(55, 55, 55)
    gearStroke.Parent = gear

    local gearImage = Instance.new("ImageLabel")
    gearImage.Name = "GearImage"
    gearImage.Size = UDim2.fromOffset(39, 39)
    gearImage.AnchorPoint = Vector2.new(0.5, 0.5)
    gearImage.Position = UDim2.fromScale(0.5, 0.5)
    gearImage.BackgroundTransparency = 1
    gearImage.BorderSizePixel = 0
    gearImage.Image = "rbxthumb://type=Asset&id=7059346386&w=420&h=420"
    gearImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    gearImage.ScaleType = Enum.ScaleType.Fit
    gearImage.Active = false
    gearImage.Selectable = false
    gearImage.Parent = gear

    self.GearButton = gear

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.fromOffset(180, 0)
    panel.Position = UDim2.new(0, 0, 1, 7)
    panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Visible = false
    panel.Parent = main

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(50, 50, 50)
    panelStroke.Parent = panel

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = panel

    self.Panel = panel

    local click = self:CreateButton(panel, "Click")
    click.LayoutOrder = 1

    local key = self:CreateButton(panel, "Key")
    key.LayoutOrder = 2

    local uiButton = self:CreateButton(panel, "UI Button")
    uiButton.LayoutOrder = 3

    self.ClickButton = click
    self.KeyButton = key
    self.UIButton = uiButton

    local keyConfig = Instance.new("Frame")
    keyConfig.Name = "KeyConfig"
    keyConfig.Size = UDim2.new(1, 0, 0, 36)
    keyConfig.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    keyConfig.BorderSizePixel = 0
    keyConfig.Visible = false
    keyConfig.LayoutOrder = 4
    keyConfig.Parent = panel

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 8)
    keyCorner.Parent = keyConfig

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0.45, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "Key"
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.TextSize = 13
    keyLabel.Font = Enum.Font.GothamSemibold
    keyLabel.Parent = keyConfig

    local keyBox = Instance.new("TextButton")
    keyBox.Size = UDim2.new(0.45, 0, 0, 27)
    keyBox.Position = UDim2.new(0.52, 0, 0.5, -13)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    keyBox.BorderSizePixel = 0
    keyBox.Text = self.selectedKey.Name
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 12
    keyBox.Font = Enum.Font.GothamMedium
    keyBox.AutoButtonColor = false
    keyBox.Parent = keyConfig

    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 6)
    keyBoxCorner.Parent = keyBox

    self.KeyConfig = keyConfig
    self.KeyBox = keyBox

    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    separator.BorderSizePixel = 0
    separator.LayoutOrder = 100
    separator.Parent = panel

    local credit = Instance.new("TextLabel")
    credit.Name = "Credit"
    credit.Size = UDim2.new(1, 0, 0, 16)
    credit.BackgroundTransparency = 1
    credit.Text = "by yes.dev"
    credit.TextColor3 = Color3.fromRGB(140, 140, 140)
    credit.TextSize = 11
    credit.Font = Enum.Font.GothamMedium
    credit.LayoutOrder = 101
    credit.Parent = panel

    local action = Instance.new("TextButton")
    action.Name = "ActionButton"
    action.AnchorPoint = Vector2.new(0.5, 1)
    action.Size = UDim2.fromOffset(120, 42)
    action.Position = UDim2.new(0.5, 0, 1, -30)
    action.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    action.BorderSizePixel = 0
    action.Text = "Drop Kick"
    action.TextColor3 = Color3.fromRGB(255, 255, 255)
    action.TextSize = 14
    action.Font = Enum.Font.GothamBold
    action.AutoButtonColor = false
    action.Visible = false
    action.Parent = gui

    local actionCorner = Instance.new("UICorner")
    actionCorner.CornerRadius = UDim.new(0, 10)
    actionCorner.Parent = action

    local actionStroke = Instance.new("UIStroke")
    actionStroke.Color = Color3.fromRGB(55, 55, 55)
    actionStroke.Parent = action

    self.ActionButton = action

    local gearDragging = false
    local gearDragStart
    local gearStartPosition
    local gearDragDistance = 0

    gear.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        gearDragging = true
        gearDragStart = input.Position
        gearStartPosition = main.Position
        gearDragDistance = 0
    end)

    self.conns.gearMove = self.UserInputService.InputChanged:Connect(function(input)
        if not gearDragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - gearDragStart
        gearDragDistance = math.max(gearDragDistance, math.abs(delta.X) + math.abs(delta.Y))

        main.Position = UDim2.new(
            gearStartPosition.X.Scale,
            gearStartPosition.X.Offset + delta.X,
            gearStartPosition.Y.Scale,
            gearStartPosition.Y.Offset + delta.Y
        )
    end)

    self.UserInputService.InputEnded:Connect(function(input)
        if not gearDragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        gearDragging = false

        if gearDragDistance >= 8 then return end

        self.menuOpen = not self.menuOpen

        if self.menuOpen then
            panel.Visible = true
            panel.Size = UDim2.fromOffset(180, 0)
            self:ResizePanel()
        else
            panel:TweenSize(UDim2.fromOffset(180, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
            task.delay(0.16, function()
                if not self.menuOpen then
                    panel.Visible = false
                end
            end)
        end
    end)

    click.MouseButton1Click:Connect(function()
        if self.selectedMethod == "Click" then
            self.selectedMethod = "None"
        else
            self.selectedMethod = "Click"
        end
        self:UpdateUI()
        self:SaveSettings()
    end)

    key.MouseButton1Click:Connect(function()
        if self.selectedMethod == "Key" then
            self.selectedMethod = "None"
            self.keyListening = false
            self.recordingKey = false
            if self.conns.keyRecord then
                self.conns.keyRecord:Disconnect()
                self.conns.keyRecord = nil
            end
        else
            self.selectedMethod = "Key"
        end
        self:UpdateUI()
        self:SaveSettings()
    end)

    uiButton.MouseButton1Click:Connect(function()
        if self.selectedMethod == "UI Button" then
            self.selectedMethod = "None"
        else
            self.selectedMethod = "UI Button"
        end
        self:UpdateUI()
        self:SaveSettings()
    end)

    keyBox.MouseButton1Click:Connect(function()
        if self.selectedMethod ~= "Key" then return end
        if self.keyListening or self.recordingKey then return end

        self.keyListening = true
        self.recordingKey = true
        keyBox.Text = "Press key..."

        if self.conns.keyRecord then
            self.conns.keyRecord:Disconnect()
            self.conns.keyRecord = nil
        end

        self.conns.keyRecord = self.UserInputService.InputBegan:Connect(function(input)
            if not self.keyListening then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Unknown then return end

            self.selectedKey = input.KeyCode
            self.keyListening = false
            keyBox.Text = self.selectedKey.Name

            if self.conns.keyRecord then
                self.conns.keyRecord:Disconnect()
                self.conns.keyRecord = nil
            end

            task.delay(0.1, function()
                self.recordingKey = false
            end)

            self:SaveSettings()
        end)
    end)

    local dragging = false
    local dragStart
    local startPosition
    local dragDistance = 0

    action.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        dragging = true
        dragStart = input.Position
        startPosition = action.Position
        dragDistance = 0

        local changed
        changed = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if changed then changed:Disconnect() end

                if dragDistance < 8
                    and self.selectedMethod == "UI Button"
                    and not self.keyListening
                    and not self.recordingKey then
                    self:PerformDropkick()
                end
            end
        end)
    end)

    self.conns.actionMove = self.UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        dragDistance = math.max(dragDistance, math.abs(delta.X) + math.abs(delta.Y))

        action.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    self.uiReady = true
    self:UpdateUI()

    self.conns.toggleMenu = self.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode == Enum.KeyCode.LeftControl then

            if not self.keyListening and not self.recordingKey then
                self.menuOpen = not self.menuOpen

                if self.menuOpen then
                    panel.Visible = true
                    panel.Size = UDim2.fromOffset(180, 0)
                    self:ResizePanel()
                else
                    panel:TweenSize(UDim2.fromOffset(180, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.15, true)
                    task.delay(0.16, function()
                        if not self.menuOpen then
                            panel.Visible = false
                        end
                    end)
                end
            end
        end
    end)
end

function utility:BeginDropkickHook(char)
    if not char then
        return warn("failed to get valid character")
    end

    local hum = char:WaitForChild("Humanoid", 1)
    if not hum then
        return warn("Failed to get humanoid")
    end

    if not self:CheckValidRigType(hum) then
        return self.LocalPlayer:Kick("Change avatar to R15")
    end

    local animator = hum:WaitForChild("Animator", 1)
    if not animator then
        return warn("failed to get animator")
    end

    return "success"
end

function utility:Initialize()
    self.LocalPlayer = self.Players.LocalPlayer

    if not self.LocalPlayer then
        return warn("failed to get localplayer")
    end

    pcall(makefolder, self.cacheFolder)

    self:LoadSettings()

    self.character = self.LocalPlayer.Character
    if not self.character then
        self.character = self.LocalPlayer.CharacterAdded:Wait()
    end

    self:ShowStartup()

    if self:BeginDropkickHook(self.character) ~= "success" then
        return
    end

    self.charadded = self.LocalPlayer.CharacterAdded:Connect(function(character)
        self:BeginDropkickHook(character)
    end)

    self:CreateUI()
    self:MouseDetection()
    self:StartKeyDetection()

    task.defer(function()
        self:SetupGlobalNoClip()
    end)

    if not self.charadded then
        return warn("failed to initialize charadded")
    end

    return warn("success")
end

utility:Initialize()
