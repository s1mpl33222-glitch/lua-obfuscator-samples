-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer;
(function()
    local t1 = {
		value1 = 15,
		value2 = 60,
		value3 = 30,
		value4 = 24.5,
		value5 = 0,
		value6 = {
			speedToggled = false,
			laggerToggled = false,
			autoBatToggled = false,
			hittingCooldown = false,
			infJumpEnabled = false,
			antiRagdollEnabled = false,
			fpsBoostEnabled = false,
			antiLagEnabled = false,
			guiVisible = true,
			introEnabled = true,
			selectedIntroMusic = 1,
			isStealing = false,
			stealStartTime = nil,
			lastStealTick = 0,
			lastKnownHealth = 100,
			dropActive = false,
			dropBrainrotActive = false,
			autoLeftEnabled = false,
			autoRightEnabled = false,
			unwalkEnabled = false,
			desyncEnabled = false,
			stretchRezEnabled = false,
			removeAccessoriesEnabled = false
		},
		value7 = false,
		value8 = false,
		value9 = nil,
		value10 = function()
    end,
		value11 = nil
	}
    local t2 = {}

    UDim2.new(1, -298, 1, -334)
    UDim2.new(1, -144, 1, -334)
    UDim2.new(1, -298, 1, -270)
    UDim2.new(1, -144, 1, -270)
    UDim2.new(1, -298, 1, -206)
    UDim2.new(1, -144, 1, -206)
    UDim2.new(1, -144, 1, -142)

    local t3 = {
		kb = Enum.KeyCode.Z,
		gp = nil
	}
    local t4 = {
		kb = Enum.KeyCode.C,
		gp = nil
	}
    local t5 = {
		kb = Enum.KeyCode.X,
		gp = nil
	}

    t1.value12 = nil

    local t6 = {
		kb = Enum.KeyCode.F,
		gp = nil
	}
    local t7 = {
		kb = Enum.KeyCode.E,
		gp = nil
	}
    local t8 = {
		kb = Enum.KeyCode.Q,
		gp = nil
	}
    local t9 = {
		kb = Enum.KeyCode.R,
		gp = nil
	}
    local LeftControl = Enum.KeyCode.LeftControl

    t1.value13 = {
		AutoLeft = t3,
		AutoRight = t4,
		Drop = t5,
		TPDown = t6,
		AutoBat = t7,
		Speed = t8,
		Lagger = t9,
		GuiHide = {
			kb = LeftControl,
			gp = nil
		}
	}

    local vector3 = Vector3.new(-476.48, -6.28, 92.73)
    local vector3_2 = Vector3.new(-483.12, -4.95, 94.8)
    local vector3_3 = Vector3.new(-482.25, -4.96, 92.09)
    local vector3_4 = Vector3.new(-476.16, -6.52, 25.62)
    local vector3_5 = Vector3.new(-483.06, -5.03, 25.48)
    local vector3_6 = Vector3.new(-482.06, -6.93, 35.47)

    t1.value14 = {
		L1 = vector3,
		L2 = vector3_2,
		L_FACE = vector3_3,
		R1 = vector3_4,
		R2 = vector3_5,
		R_FACE = vector3_6
	}
    t1.value15 = nil
    t1.value16 = {
		AutoStealEnabled = false,
		StealRadius = 8,
		StealDuration = 1.3,
		Data = {},
		plotCache = {},
		plotCacheTime = {},
		cachedPrompts = {},
		promptCacheTime = 0
	}
    t1.value17 = {
		autoSteal = nil,
		antiRag = nil,
		anchor = {},
		progress = nil
	}

    function t1.value18()
        local Character = LocalPlayer.Character

        if Character then
            local GetChildren = Character.GetChildren

            for __, v in ipairs(GetChildren(Character)) do
                if v:IsA("Tool") then
                    return v
                end
            end
        end

        local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

        if Backpack then
            for __, child in ipairs(Backpack:GetChildren()) do
                if child:IsA("Tool") then
                    return child
                end
            end
        end

        return nil
    end

    t1.value19 = 0.08

    local function v24()
        local Character = LocalPlayer.Character

        if not Character then
            return nil
        end

        local GetChildren = Character.GetChildren

        for __, v in ipairs(GetChildren(Character)) do
            if v:IsA("Tool") and v.Name:lower():find("bat") or v.Name:lower():find("slap") then
                return v
            end
        end

        local Backpack = LocalPlayer:FindFirstChild("Backpack")

        if Backpack then
            for __, child in ipairs(Backpack:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
                    return child
                end
            end
        end

        return nil
    end
    local function v25()
        local v141 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not v141 then
            return nil
        end
        local v142
        local n1 = 1e999
        for __, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
                    local Magnitude = (HumanoidRootPart.Position - v141.Position).Magnitude

                    if Magnitude < n1 then
                        n1 = Magnitude
                        v142 = HumanoidRootPart
                    end
                end
            end
        end

        return v142
    end

    function t1.value20()
        if t1.value17.aimbot then
            t1.value17.aimbot:Disconnect()
        end

        if t1.value6.autoLeftEnabled then
            t1.value6.autoLeftEnabled = false

            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end

            stopAutoLeft()
        end

        if t1.value6.autoRightEnabled then
            t1.value6.autoRightEnabled = false

            if autoRightSetVisual then
                autoRightSetVisual(false)
            end

            stopAutoRight()
        end

        local v149 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if v149 then
            v149.AutoRotate = false
        end

        t1.value17.aimbot = RunService.RenderStepped:Connect(function()
            if not t1.value6.autoBatToggled then
                return
            end

            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                return
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid then
                return
            end

            if not Character:FindFirstChildOfClass("Tool") then
                local v520 = v24()

                if v520 then
                    pcall(function()
                        Humanoid:EquipTool(v520)
                    end)
                end
            end

            local v521 = v25()

            if not v521 then
                return
            end

            local AssemblyLinearVelocity = v521.AssemblyLinearVelocity
            local HumanoidRootPartPosition = HumanoidRootPart.Position
            local Position = v521.Position
            local v525 = Position + AssemblyLinearVelocity * 0.14 + v521.CFrame.LookVector * 0.3 - HumanoidRootPartPosition
            local Unit = Vector3.new(v525.X, 0, v525.Z).Unit
            local n2 = 58
            local v528 = (Position.Y + 3.7 - HumanoidRootPartPosition.Y) * 19.5 + AssemblyLinearVelocity.Y * 0.8

            if Humanoid.FloorMaterial ~= Enum.Material.Air then
                v528 = math.max(v528, 13)
            end

            local v529 = math.clamp(v528, -70, 110)
            local vector3_7 = Vector3.new(Unit.X * n2, v529, Unit.Z * n2)

            HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity:Lerp(vector3_7, 0.8)

            local v531 = Position + AssemblyLinearVelocity * math.clamp(AssemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

            if (v531 - HumanoidRootPartPosition).Magnitude > 0.1 then
                local cFrame = CFrame.lookAt(HumanoidRootPartPosition, v531)
                local v533, v534, v535 = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()
                local v536 = math.clamp(v533, -2.5, 2.5)
                local v537 = math.clamp(v534, -2.5, 2.5)
                local v538 = math.clamp(v535, -2.5, 2.5)
                local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
                local t10 = { Vector3.new(v536 * 42, v537 * 42, v538 * 42) }

                HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPartCFrame:VectorToWorldSpace(v1(t10))
            end
        end)
    end
    function t1.value21()
        if t1.value17.aimbot then
            t1.value17.aimbot:Disconnect()
            t1.value17.aimbot = nil
        end

        local Character = LocalPlayer.Character
        local v139 = Character and Character:FindFirstChild("HumanoidRootPart")

        if v139 then
            v139.AssemblyLinearVelocity = Vector3.zero
            v139.AssemblyAngularVelocity = Vector3.zero
        end

        local v140 = Character and Character:FindFirstChildOfClass("Humanoid")

        if v140 then
            v140.AutoRotate = true
        end

        t1.value6.hittingCooldown = false
    end

    t1.value22 = nil
    t1.value23 = nil
    t1.value24 = nil
    t1.value25 = nil

    function t1.value26()
    end

    t1.value27 = nil
    t1.value28 = nil
    t1.value29 = nil
    t1.value30 = nil
    t1.value31 = nil
    t1.value32 = nil
    t1.value33 = nil
    t1.value34 = nil
    t1.value35 = nil
    t1.value36 = nil
    t1.value37 = nil
    t1.value38 = nil
    t1.value39 = nil
    t1.value40 = nil
    t1.value41 = nil
    t1.value42 = 1
    t1.value43 = 1
    t1.value44 = false
    t1.value45 = nil
    t1.value46 = 20

    function t1.value47()
        if t1.value41 then
            t1.value41:Disconnect()
        end

        local Character = LocalPlayer.Character

        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid:Move(Vector3.zero, false)
            end
        end
    end
    function t1.value48()
        if t1.value40 then
            t1.value40:Disconnect()
        end

        t1.value42 = 1
        t1.value40 = RunService.Heartbeat:Connect(function()
            if not t1.value6.autoLeftEnabled then
                return
            end

            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local v559 = not HumanoidRootPart
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not v559 then
                v559 = not Humanoid
            end

            if v559 then
                return
            end

            local value2 = t1.value2

            if t1.value42 == 1 then
                if (Vector3.new(t1.value14.L1.X, HumanoidRootPart.Position.Y, t1.value14.L1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                    t1.value42 = 2

                    local v562 = t1.value14.L2 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v562.X, 0, v562.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                    return
                end

                local v564 = t1.value14.L1 - HumanoidRootPart.Position
                local Unit = Vector3.new(v564.X, 0, v564.Z).Unit

                Humanoid:Move(Unit, false)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                return
            end

            if t1.value42 == 2 then
                if (Vector3.new(t1.value14.L2.X, HumanoidRootPart.Position.Y, t1.value14.L2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                    Humanoid:Move(Vector3.zero, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    t1.value6.autoLeftEnabled = false

                    if t1.value40 then
                        t1.value40:Disconnect()
                        t1.value40 = nil
                    end

                    if t1.value24 then
                        t1.value24(false)
                    end

                    if (t1.value14.L_FACE - HumanoidRootPart.Position).Magnitude > 0.01 then
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Vector3.new(t1.value14.L_FACE.X, HumanoidRootPart.Position.Y, t1.value14.L_FACE.Z))
                    end

                    return
                end

                local v566 = t1.value14.L2 - HumanoidRootPart.Position
                local Unit = Vector3.new(v566.X, 0, v566.Z).Unit

                Humanoid:Move(Unit, false)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)
            end
        end)
    end
    function t1.value49()
        if t1.value41 then
            t1.value41:Disconnect()
        end

        t1.value43 = 1
        t1.value41 = RunService.Heartbeat:Connect(function()
            if not t1.value6.autoRightEnabled then
                return
            end

            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not HumanoidRootPart or not Humanoid then
                return
            end

            local value2 = t1.value2

            if t1.value43 == 1 then
                if (Vector3.new(t1.value14.R1.X, HumanoidRootPart.Position.Y, t1.value14.R1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                    t1.value43 = 2

                    local R2 = t1.value14.R2
                    local HumanoidRootPartPosition = HumanoidRootPart.Position
                    local _Vector3 = Vector3
                    local v548 = R2 - HumanoidRootPartPosition
                    local Unit = _Vector3.new(v548.X, 0, v548.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                    return
                end

                local R1 = t1.value14.R1
                local HumanoidRootPartPosition = HumanoidRootPart.Position
                local _Vector3 = Vector3
                local v553 = R1 - HumanoidRootPartPosition
                local Unit = _Vector3.new(v553.X, 0, v553.Z).Unit

                Humanoid:Move(Unit, false)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                return
            end

            if t1.value43 == 2 then
                if (Vector3.new(t1.value14.R2.X, HumanoidRootPart.Position.Y, t1.value14.R2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                    Humanoid:Move(Vector3.zero, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    t1.value6.autoRightEnabled = false

                    if t1.value41 then
                        t1.value41:Disconnect()
                        t1.value41 = nil
                    end

                    if t1.value25 then
                        t1.value25(false)
                    end

                    if (t1.value14.R_FACE - HumanoidRootPart.Position).Magnitude > 0.01 then
                        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Vector3.new(t1.value14.R_FACE.X, HumanoidRootPart.Position.Y, t1.value14.R_FACE.Z))
                    end

                    return
                end

                local v555 = t1.value14.R2 - HumanoidRootPart.Position
                local Unit = Vector3.new(v555.X, 0, v555.Z).Unit

                Humanoid:Move(Unit, false)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)
            end
        end)
    end

    t1.value15 = 0.2
    t1.value11 = 150

    function t1.value50()
        if t1.value6.dropActive then
            return
        end
        local Character = LocalPlayer.Character
        if not Character then
            return
        end
        if not Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        t1.value6.dropActive = true
        local timestamp = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local v508 = Character and Character:FindFirstChild("HumanoidRootPart")

            if not v508 then
                connection:Disconnect()
                t1.value6.dropActive = false

                return
            end

            if tick() - timestamp >= t1.value15 then
                connection:Disconnect()

                local raycastParams = RaycastParams.new()

                raycastParams.FilterDescendantsInstances = { Character }
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                local raycastResult = workspace:Raycast(v508.Position, Vector3.new(0, -2000, 0), raycastParams)

                if raycastResult then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local v512 = (Humanoid and Humanoid.HipHeight or 2) + v508.Size.Y / 2

                    v508.CFrame = CFrame.new(v508.Position.X, raycastResult.Position.Y + v512, v508.Position.Z)
                    v508.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end

                t1.value6.dropActive = false

                return
            end

            v508.AssemblyLinearVelocity = Vector3.new(v508.AssemblyLinearVelocity.X, t1.value11, v508.AssemblyLinearVelocity.Z)
        end)
    end

    t1.value12 = false

    function t1.value51()
        if t1.value12 then
            return
        end

        pcall(function()
            local Character = LocalPlayer.Character
            local v502 = Character and Character:FindFirstChild("HumanoidRootPart")
            local v503 = Character and Character:FindFirstChildOfClass("Humanoid")

            if not v502 or not v503 then
                t1.value12 = false

                return
            end

            local raycastParams = RaycastParams.new()

            raycastParams.FilterDescendantsInstances = { Character }
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude

            local raycastResult = workspace:Raycast(v502.Position, Vector3.new(0, -1000, 0), raycastParams)

            if raycastResult then
                local v506 = v503.HipHeight + v502.Size.Y / 2
                local v507 = raycastResult.Position + Vector3.new(0, v506, 0)

                v502.CFrame = CFrame.new(v507) * v502.CFrame.Rotation
            end
        end)
        t1.value12 = false
    end
    function t1.value52()
        if t1.value45 then
            task.cancel(t1.value45)
        end

        task.spawn(function()
            while t1.value44 do
                task.wait(0.1)
                pcall(function()
                    local Character = LocalPlayer.Character

                    if not Character then
                        return
                    end

                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if not HumanoidRootPart then
                        return
                    end

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if not Humanoid then
                        return
                    end

                    if Humanoid.FloorMaterial ~= Enum.Material.Air then
                        return
                    end

                    if HumanoidRootPart.Position.Y < t1.value46 then
                        return
                    end

                    local raycastParams = RaycastParams.new()

                    raycastParams.FilterDescendantsInstances = { Character }
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -2000, 0), raycastParams)
                    local v873 = Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2

                    if raycastResult then
                        raycastResult = raycastResult.Position.Y + v873
                    end

                    local v874 = raycastResult or -7

                    HumanoidRootPart.CFrame = CFrame.new(Vector3.new(HumanoidRootPart.Position.X, v874, HumanoidRootPart.Position.Z)) * CFrame.Angles(0, select(2, HumanoidRootPart.CFrame:ToEulerAnglesYXZ()), 0)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end)
            end
        end)
    end
    function t1.value53()
        t1.value44 = false

        if t1.value45 then
            task.cancel(t1.value45)
            t1.value45 = nil
        end
    end

    for __, v in pairs({ "flowHubDuelsGUI" }) do
        local v2 = game:GetService("CoreGui"):FindFirstChild(v)

        if v2 then
            v2:Destroy()
        end

        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

        if PlayerGui then
            local v3 = PlayerGui:FindFirstChild(v)

            if v3 then
                v3:Destroy()
            end
        end
    end

    local function v31(p1)
        local u159 = false
        local u160
        local inputPosition
        local p1Position
        p1.InputBegan:Connect(function(input)
            if t1.value8 then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                u159 = true
                inputPosition = input.Position
                p1Position = p1.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        u159 = false
                    end
                end)
            end
        end)
        p1.InputChanged:Connect(function(input)
            if t1.value8 then
                u159 = false

                return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                u160 = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if t1.value8 then
                u159 = false

                return
            end

            if input == u160 and u159 then
                local v571 = input.Position - inputPosition

                p1.Position = UDim2.new(p1Position.X.Scale, p1Position.X.Offset + v571.X, p1Position.Y.Scale, p1Position.Y.Offset + v571.Y)
            end
        end)
    end

    t1.value54 = Instance.new("ScreenGui")
    t1.value54.Name = "flowHubDuelsGUI"
    t1.value54.ResetOnSpawn = false
    t1.value54.DisplayOrder = 10
    t1.value54.IgnoreGuiInset = true

    if not pcall(function()
        t1.value54.Parent = game:GetService("CoreGui")
    end) then
        t1.value54.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local color3 = Color3.fromRGB(8, 0, 0)
    local color3_2 = Color3.fromRGB(12, 0, 0)
    local color3_3 = Color3.fromRGB(24, 4, 4)
    local color3_4 = Color3.fromRGB(45, 6, 6)
    local color3_5 = Color3.fromRGB(120, 10, 10)
    local color3_6 = Color3.fromRGB(180, 20, 20)
    local color3_7 = Color3.fromRGB(255, 235, 235)
    local color3_8 = Color3.fromRGB(190, 90, 90)
    local color3_9 = Color3.fromRGB(70, 8, 8)
    local color3_10 = Color3.fromRGB(18, 2, 2)
    local t11 = {
		[1] = color3,
		[2] = color3_2,
		[3] = color3_3,
		[4] = color3_4,
		[5] = color3_5,
		[6] = color3_6,
		[7] = color3_7,
		[8] = color3_8,
		[9] = color3_9,
		[10] = color3_10
	}

    t1.value55 = t11[1]

    local v43 = t11[2]

    t1.value56 = t11[3]
    t1.value57 = t11[4]
    t1.value58 = t11[5]
    t1.value59 = t11[6]
    t1.value60 = t11[7]
    t1.value61 = t11[8]
    t1.value62 = t11[9]
    t1.value63 = t11[10]
    t1.value64 = t11[10]
    t1.value65 = 70
    t1.value66 = Instance.new("Frame", t1.value54)
    t1.value66.Name = "flowhub duels"
    t1.value66.Size = UDim2.new(0, 490, 0, 460)
    t1.value66.Position = UDim2.new(0, 50, 0, 50)
    t1.value66.BackgroundColor3 = t1.value55
    t1.value66.BorderSizePixel = 0
    t1.value66.Active = true
    t1.value66.ClipsDescendants = true
    Instance.new("UICorner", t1.value66).CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke", t1.value66)

    UIStroke.Color = Color3.fromRGB(0, 0, 0)
    UIStroke.Thickness = 1
    v31(t1.value66)
    t1.value67 = Instance.new("UIScale", t1.value66)
    t1.value67.Scale = t1.value65 / 100

    local Frame = Instance.new("Frame", t1.value66)

    Frame.Size = UDim2.new(1, 0, 0, 44)
    Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 10
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Frame2 = Instance.new("Frame", Frame)

    Frame2.Size = UDim2.new(1, 0, 0, 12)
    Frame2.Position = UDim2.new(0, 0, 1, -12)
    Frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 9

    local Frame3 = Instance.new("Frame", Frame)

    Frame3.Size = UDim2.new(1, 0, 0, 1)
    Frame3.Position = UDim2.new(0, 0, 1, -1)
    Frame3.BackgroundColor3 = t1.value58
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 11

    local TextLabel = Instance.new("TextLabel", Frame)

    TextLabel.Size = UDim2.new(0, 160, 1, 0)
    TextLabel.Position = UDim2.new(0, 14, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "FLOW HUBR"
    TextLabel.TextColor3 = t1.value60
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 12

    local TextLabel2 = Instance.new("TextLabel", Frame)

    TextLabel2.Size = UDim2.new(0, 130, 1, 0)
    TextLabel2.Position = UDim2.new(0, 100, 0, 0)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "by flowwk7"
    TextLabel2.TextColor3 = t1.value61
    TextLabel2.Font = Enum.Font.Gotham
    TextLabel2.TextSize = 9
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 12
    t1.value68 = Instance.new("TextButton", Frame)
    t1.value68.Size = UDim2.new(0, 26, 0, 26)
    t1.value68.Position = UDim2.new(1, -36, 0.5, -13)
    t1.value68.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    t1.value68.BorderSizePixel = 0
    t1.value68.Text = "–"
    t1.value68.TextColor3 = t1.value60
    t1.value68.Font = Enum.Font.GothamBlack
    t1.value68.TextSize = 16
    t1.value68.ZIndex = 13
    Instance.new("UICorner", t1.value68).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", t1.value68).Color = t1.value58
    t1.value68.MouseEnter:Connect(function()
        TweenService:Create(t1.value68, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		}):Play()
    end)
    t1.value68.MouseLeave:Connect(function()
        TweenService:Create(t1.value68, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		}):Play()
    end)

    local Frame4 = Instance.new("Frame", t1.value66)

    Frame4.Size = UDim2.new(0, 160, 1, -44)
    Frame4.Position = UDim2.new(0, 0, 0, 44)
    Frame4.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
    Frame4.BorderSizePixel = 0
    Frame4.ClipsDescendants = true
    Frame4.ZIndex = 3
    Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 12)
    Instance.new("Frame", Frame4).Size = UDim2.new(1, 0, 0, 12)
    Instance.new("Frame", Frame4).Size = UDim2.new(0, 12, 1, 0)

    local ImageLabel = Instance.new("ImageLabel", Frame4)

    ImageLabel.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://87965903017451"
    ImageLabel.ScaleType = Enum.ScaleType.Crop
    ImageLabel.ZIndex = 3

    local Frame5 = Instance.new("Frame", Frame4)

    Frame5.Size = UDim2.new(0.5, 0, 1, 0)
    Frame5.Position = UDim2.new(0.5, 0, 0, 0)
    Frame5.BackgroundColor3 = t1.value55
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 4
    Instance.new("UIGradient", Frame5).Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})

    local Frame6 = Instance.new("Frame", Frame4)

    Frame6.Size = UDim2.new(1, 0, 0.3, 0)
    Frame6.Position = UDim2.new(0, 0, 0.7, 0)
    Frame6.BackgroundColor3 = t1.value55
    Frame6.BorderSizePixel = 0
    Frame6.ZIndex = 4

    local UIGradient = Instance.new("UIGradient", Frame6)

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})

    local TextLabel3 = Instance.new("TextLabel", Frame4)

    TextLabel3.Size = UDim2.new(1, -8, 0, 22)
    TextLabel3.Position = UDim2.new(0, 8, 1, -52)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "flow HUB DUELS"
    TextLabel3.TextColor3 = t1.value60
    TextLabel3.Font = Enum.Font.GothamBlack
    TextLabel3.TextSize = 13
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = 6

    local Frame7 = Instance.new("Frame", Frame4)

    Frame7.Size = UDim2.new(0.7, 0, 0, 1)
    Frame7.Position = UDim2.new(0, 8, 1, -30)
    Frame7.BackgroundColor3 = t1.value60
    Frame7.BorderSizePixel = 0
    Frame7.ZIndex = 6

    local TextLabel4 = Instance.new("TextLabel", Frame4)

    TextLabel4.Size = UDim2.new(1, -8, 0, 14)
    TextLabel4.Position = UDim2.new(0, 8, 1, -26)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "discord.gg/flowhubr"
    TextLabel4.TextColor3 = t1.value61
    TextLabel4.Font = Enum.Font.Gotham
    TextLabel4.TextSize = 9
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.ZIndex = 6

    local Frame8 = Instance.new("Frame", t1.value66)

    Frame8.Size = UDim2.new(0, 1, 1, -44)
    Frame8.Position = UDim2.new(0, 160, 0, 44)
    Frame8.BackgroundColor3 = t1.value58
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 5

    local Frame9 = Instance.new("Frame", t1.value66)

    Frame9.Size = UDim2.new(0, 90, 1, -44)
    Frame9.Position = UDim2.new(0, 161, 0, 44)
    Frame9.BackgroundColor3 = v43
    Frame9.BorderSizePixel = 0
    Frame9.ZIndex = 5
    Frame9.ClipsDescendants = false

    local Frame10 = Instance.new("Frame", t1.value66)

    Frame10.Size = UDim2.new(0, 90, 0, 12)
    Frame10.Position = UDim2.new(0, 161, 0, 44)
    Frame10.BackgroundColor3 = v43
    Frame10.BorderSizePixel = 0
    Frame10.ZIndex = 4

    local Frame11 = Instance.new("Frame", Frame9)

    Frame11.Size = UDim2.new(0, 1, 1, 0)
    Frame11.Position = UDim2.new(1, -1, 0, 0)
    Frame11.BackgroundColor3 = t1.value58
    Frame11.BorderSizePixel = 0
    Frame11.ZIndex = 6

    local Frame12 = Instance.new("Frame", t1.value66)

    Frame12.Name = "ContentArea"
    Frame12.Size = UDim2.new(1, -252, 1, -56)
    Frame12.Position = UDim2.new(0, 252, 0, 44)
    Frame12.BackgroundColor3 = t1.value55
    Frame12.BackgroundTransparency = 0
    Frame12.BorderSizePixel = 0
    Frame12.ClipsDescendants = true
    Frame12.ZIndex = 2
    t1.value69 = Instance.new("TextButton", t1.value54)
    t1.value69.Name = "flowHubDuelsMini"
    t1.value69.Size = UDim2.new(0, 160, 0, 30)
    t1.value69.Position = UDim2.new(0, 50, 0, 50)
    t1.value69.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
    t1.value69.BorderSizePixel = 0
    t1.value69.Text = "FLOW HUB DUELS"
    t1.value69.TextColor3 = t1.value60
    t1.value69.Font = Enum.Font.GothamBold
    t1.value69.TextSize = 11
    t1.value69.TextXAlignment = Enum.TextXAlignment.Center
    t1.value69.ZIndex = 20
    t1.value69.Visible = false
    Instance.new("UICorner", t1.value69).CornerRadius = UDim.new(0, 8)

    local UIStroke2 = Instance.new("UIStroke", t1.value69)

    UIStroke2.Color = Color3.fromRGB(0, 0, 0)
    UIStroke2.Thickness = 1
    v31(t1.value69)
    t1.value68.MouseButton1Click:Connect(function()
        t1.value66.Visible = false
        t1.value69.Visible = true
        t1.value6.guiVisible = false
    end)
    t1.value69.MouseButton1Click:Connect(function()
        t1.value66.Visible = true
        t1.value69.Visible = false
        t1.value6.guiVisible = true
    end)
    t1.value69.MouseEnter:Connect(function()
        TweenService:Create(t1.value69, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		}):Play()
    end)
    t1.value69.MouseLeave:Connect(function()
        TweenService:Create(t1.value69, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(8, 8, 8)
		}):Play()
    end)
    t1.value70 = {}
    t1.value71 = {}
    t1.value72 = nil
    t1.value73 = {
		{
			name = "Speed"
		},
		{
			name = "Bat Aimbot"
		},
		{
			name = "Mechanics"
		},
		{
			name = "Movement"
		},
		{
			name = "Performance"
		},
		{
			name = "Settings"
		}
	}
    t1.value74 = {}

    local Frame13 = Instance.new("Frame", Frame9)

    Frame13.Size = UDim2.new(1, 0, 1, 0)
    Frame13.Position = UDim2.new(0, 0, 0, 0)
    Frame13.BackgroundTransparency = 1
    Frame13.BorderSizePixel = 0
    Frame13.ZIndex = 6

    local UIListLayout = Instance.new("UIListLayout", Frame13)

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)

    local UIPadding = Instance.new("UIPadding", Frame13)

    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)
    t1.value75 = Color3.fromRGB(40, 40, 40)
    t1.value76 = t1.value60
    t1.value77 = Color3.fromRGB(16, 16, 16)
    t1.value78 = t1.value60

    local function v67(p2)
        t1.value72 = p2

        for __, v in ipairs(t1.value73) do
            local v166 = t1.value70[v.name]
            local v167 = p2 == v.name
            local v168 = TweenService
            local frame = v166.frame
            local tweenInfo = TweenInfo.new(0.14)
            local v171 = v167

            if v167 then
                v171 = t1.value75
            end

            v168:Create(frame, tweenInfo, {
				BackgroundColor3 = v171 or t1.value77
			}):Play()
            TweenService:Create(v166.lbl, TweenInfo.new(0.14), {
				TextColor3 = v167 and t1.value76 or t1.value78
			}):Play()
            t1.value71[v.name].Visible = v167
        end
    end

    for i, v in ipairs(t1.value73) do
        local v70 = v
        local TextButton = Instance.new("TextButton", Frame13)

        TextButton.Size = UDim2.new(1, 0, 0, 34)
        TextButton.BackgroundColor3 = t1.value77
        TextButton.BorderSizePixel = 0
        TextButton.Text = ""
        TextButton.LayoutOrder = i
        TextButton.ZIndex = 7
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)

        local TextLabel5 = Instance.new("TextLabel", TextButton)

        TextLabel5.Size = UDim2.new(1, 0, 1, 0)
        TextLabel5.Position = UDim2.new(0, 0, 0, 0)
        TextLabel5.BackgroundTransparency = 1
        TextLabel5.Text = v70.name
        TextLabel5.TextColor3 = t1.value78
        TextLabel5.Font = Enum.Font.GothamBold
        TextLabel5.TextSize = 9
        TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel5.TextWrapped = true
        TextLabel5.ZIndex = 9
        t1.value70[v70.name] = {
			frame = TextButton,
			lbl = TextLabel5
		}

        local ScrollingFrame = Instance.new("ScrollingFrame", Frame12)

        ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollingFrame.BackgroundColor3 = t1.value55
        ScrollingFrame.BackgroundTransparency = 0
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.ScrollBarThickness = 2
        ScrollingFrame.ScrollBarImageColor3 = t1.value59
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollingFrame.Visible = false
        ScrollingFrame.ZIndex = 3

        local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

        UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout2.Padding = UDim.new(0, 4)

        local UIPadding2 = Instance.new("UIPadding", ScrollingFrame)

        UIPadding2.PaddingLeft = UDim.new(0, 8)
        UIPadding2.PaddingRight = UDim.new(0, 8)
        UIPadding2.PaddingTop = UDim.new(0, 10)
        UIPadding2.PaddingBottom = UDim.new(0, 10)
        t1.value71[v70.name] = ScrollingFrame
        t1.value74[v70.name] = 0
        TextButton.Activated:Connect(function()
            v67(v70.name)
        end)
        TextButton.MouseEnter:Connect(function()
            if t1.value72 ~= v70.name then
                TweenService:Create(TextButton, TweenInfo.new(0.1), {
					BackgroundColor3 = Color3.fromRGB(28, 28, 28)
				}):Play()
            end
        end)
        TextButton.MouseLeave:Connect(function()
            if t1.value72 ~= v70.name then
                TweenService:Create(TextButton, TweenInfo.new(0.1), {
					BackgroundColor3 = t1.value77
				}):Play()
            end
        end)
    end

    function t1.value79(p3)
        local v173 = t1.value74[p3]

        t1.value74[p3] = v173 + 1

        return t1.value74[p3]
    end

    t1.value80 = nil

    function t1.value81(p4)
        return t1.value71[p4]
    end

    local function v76(p5, p6)
        local Frame14 = Instance.new("Frame", t1.value81(p5))

        Frame14.Size = UDim2.new(1, 0, 0, 18)
        Frame14.BackgroundTransparency = 1
        Frame14.BorderSizePixel = 0
        Frame14.LayoutOrder = t1.value79(p5)
        Frame14.ZIndex = 4

        local TextLabel6 = Instance.new("TextLabel", Frame14)

        TextLabel6.Size = UDim2.new(1, 0, 1, 0)
        TextLabel6.BackgroundTransparency = 1
        TextLabel6.Text = p6:upper()
        TextLabel6.TextColor3 = t1.value60
        TextLabel6.Font = Enum.Font.GothamBold
        TextLabel6.TextSize = 8
        TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel6.ZIndex = 5

        local Frame15 = Instance.new("Frame", Frame14)

        Frame15.Size = UDim2.new(1, 0, 0, 1)
        Frame15.Position = UDim2.new(0, 0, 1, -1)
        Frame15.BackgroundColor3 = t1.value58
        Frame15.BorderSizePixel = 0
        Frame15.ZIndex = 4
    end

    t1.value80 = nil

    function t1.value82()
        local Character = LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            local GetPlayingAnimationTracks = Humanoid.GetPlayingAnimationTracks

            for __, v in ipairs(GetPlayingAnimationTracks(Humanoid)) do
                local v200 = v

                pcall(function()
                    v200:Stop()
                end)
            end
        end

        local Animate = Character:FindFirstChild("Animate")

        if Animate then
            local Clone = Animate.Clone
            local Destroy = Animate.Destroy

            Clone(Animate)
            Destroy(Animate)
        end
    end
    function t1.value83()
        local Character = LocalPlayer.Character
        local v176 = Character

        if v176 then
            Character = v176:FindFirstChild("Animate")

            if not Character then
                Character = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")

                local v177 = Character and Character:FindFirstChild("Animate")

                if v177 then
                    Character = v177:Clone()
                    Character.Parent = v176
                elseif t1.value80 then
                    Character = "Parent"
                    t1.value80:Clone().Parent = v176
                end
            end
        end

        t1.value80 = Character
    end
    function t1.value84(p7, p8)
        local Frame16 = Instance.new("Frame", t1.value81(p7))

        Frame16.Size = UDim2.new(1, 0, 0, p8 or 38)
        Frame16.BackgroundColor3 = t1.value56
        Frame16.BorderSizePixel = 0
        Frame16.LayoutOrder = t1.value79(p7)
        Frame16.ZIndex = 4
        Instance.new("UICorner", Frame16).CornerRadius = UDim.new(0, 7)
        Instance.new("UIStroke", Frame16).Color = t1.value58
        Frame16.MouseEnter:Connect(function()
            TweenService:Create(Frame16, TweenInfo.new(0.1), {
				BackgroundColor3 = t1.value57
			}):Play()
        end)
        Frame16.MouseLeave:Connect(function()
            TweenService:Create(Frame16, TweenInfo.new(0.1), {
				BackgroundColor3 = t1.value56
			}):Play()
        end)

        return Frame16
    end
    function t1.value85(p9, p10, p11, p12, p13, p14, p15, p16)
        local TextLabel7 = Instance.new("TextLabel", p9)

        TextLabel7.Size = UDim2.new(0, p12 or 140, 1, 0)
        TextLabel7.Position = UDim2.new(0, p11 or 10, 0, 0)
        TextLabel7.BackgroundTransparency = 1
        TextLabel7.Text = p10

        if not p14 then
            p14 = t1.value60
        end

        TextLabel7.TextColor3 = p14
        TextLabel7.Font = p15 or Enum.Font.GothamBold
        TextLabel7.TextSize = p13 or 11
        TextLabel7.TextXAlignment = p16 or Enum.TextXAlignment.Left
        TextLabel7.ZIndex = 10

        return TextLabel7
    end

    local function v77(p17, p18, p19)
        local TextButton = Instance.new("TextButton", t1.value81(p17))

        TextButton.Size = UDim2.new(1, 0, 0, 36)
        TextButton.BackgroundColor3 = t1.value60
        TextButton.BorderSizePixel = 0
        TextButton.Text = p18
        TextButton.TextColor3 = t1.value55
        TextButton.Font = Enum.Font.GothamBold
        TextButton.TextSize = 11
        TextButton.LayoutOrder = t1.value79(p17)
        TextButton.ZIndex = 5
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)
        TextButton.MouseButton1Click:Connect(function()
            TweenService:Create(TextButton, TweenInfo.new(0.08), {
				BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			}):Play()
            task.delay(0.15, function()
                TweenService:Create(TextButton, TweenInfo.new(0.1), {
					BackgroundColor3 = t1.value60
				}):Play()
            end)

            if p19 then
                pcall(p19)
            end
        end)
        TextButton.MouseEnter:Connect(function()
            TweenService:Create(TextButton, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(210, 210, 210)
			}):Play()
        end)
        TextButton.MouseLeave:Connect(function()
            TweenService:Create(TextButton, TweenInfo.new(0.1), {
				BackgroundColor3 = t1.value60
			}):Play()
        end)

        return TextButton
    end
    local function v78(p20, p21, p22, p23, p24)
        local v230 = p22 and 48
        local v231 = t1.value84(p20, v230 or 38)

        t1.value85(v231, p21, 10, 130, 11, t1.value60, Enum.Font.GothamBold)

        if p22 then
            local v232 = t1.value85(v231, p22, 10, 160, 9, t1.value61, Enum.Font.Gotham)

            v232.Size = UDim2.new(0, 160, 0, 13)
            v232.Position = UDim2.new(0, 10, 0, 24)
        end

        local TextBox = Instance.new("TextBox", v231)

        TextBox.Size = UDim2.new(0, 64, 0, 24)
        TextBox.Position = UDim2.new(1, -74, 0.5, -12)
        TextBox.BackgroundColor3 = t1.value64
        TextBox.BorderSizePixel = 0
        TextBox.Text = tostring(p23)
        TextBox.TextColor3 = t1.value60
        TextBox.Font = Enum.Font.GothamBold
        TextBox.TextSize = 11
        TextBox.ClearTextOnFocus = false
        TextBox.ZIndex = 11
        Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 5)

        local UIStroke3 = Instance.new("UIStroke", TextBox)

        UIStroke3.Color = t1.value59
        UIStroke3.Thickness = 1
        UIStroke3.ZIndex = 12
        TextBox.Focused:Connect(function()
            TweenService:Create(UIStroke3, TweenInfo.new(0.1), {
				Color = t1.value60
			}):Play()
        end)
        TextBox.FocusLost:Connect(function()
            TweenService:Create(UIStroke3, TweenInfo.new(0.1), {
				Color = t1.value59
			}):Play()

            if p24 then
                local num = tonumber(TextBox.Text)

                if num then
                    p24(num)

                    return
                end

                TextBox.Text = tostring(p23)
            end
        end)

        return TextBox
    end

    function t1.value86(p25, p26, p27)
        local Frame17 = Instance.new("Frame", p25)

        Frame17.Size = UDim2.new(0, 36, 0, 19)
        Frame17.Position = UDim2.new(1, -46, 0.5, -9.5)
        Frame17.BackgroundColor3 = p26 and t1.value60 or Color3.fromRGB(16, 16, 16)
        Frame17.BorderSizePixel = 0
        Frame17.ZIndex = 8
        Instance.new("UICorner", Frame17).CornerRadius = UDim.new(0, 10)

        local UIStroke4 = Instance.new("UIStroke", Frame17)

        UIStroke4.Color = p26 and t1.value60 or t1.value59
        UIStroke4.Thickness = 1

        local Frame18 = Instance.new("Frame", Frame17)

        Frame18.Size = UDim2.new(0, 13, 0, 13)
        Frame18.Position = p26 and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        Frame18.BackgroundColor3 = p26 and t1.value55 or t1.value62
        Frame18.BorderSizePixel = 0
        Frame18.ZIndex = 9
        Instance.new("UICorner", Frame18).CornerRadius = UDim.new(0, 4)

        local u210 = p26 or false

        local function v211(p28)
            u210 = p28
            TweenService:Create(Frame17, TweenInfo.new(0.18), {
				BackgroundColor3 = p28 and t1.value60 or Color3.fromRGB(16, 16, 16)
			}):Play()
            TweenService:Create(UIStroke4, TweenInfo.new(0.18), {
				Color = p28 and t1.value60 or t1.value59
			}):Play()

            local v573 = TweenService
            local v574 = Frame18
            local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back)
            local v576 = p28 and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            local v577 = p28 and t1.value55 or t1.value62

            v573:Create(v574, tweenInfo, {
				Position = v576,
				BackgroundColor3 = v577
			}):Play()
        end

        local TextButton = Instance.new("TextButton", p25)

        TextButton.Size = UDim2.new(1, 0, 1, 0)
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.ZIndex = 6
        TextButton.MouseButton1Click:Connect(function()
            if t1.value7 then
                return
            end

            u210 = not u210
            v211(u210)

            if p27 then
                pcall(p27, u210)
            end
        end)

        return v211
    end
    function t1.value87(p29, p30, p31)
        local TextButton = Instance.new("TextButton", p29)
        TextButton.Size = UDim2.new(0, 44, 0, 20)
        TextButton.BackgroundColor3 = t1.value63
        TextButton.BorderSizePixel = 0
        TextButton.Text = if not p30.gp then not p30.kb and "None" or p30.kb.Name else "GP:" .. p30.gp.Name
        TextButton.TextColor3 = t1.value60
        TextButton.Font = Enum.Font.GothamBold
        TextButton.TextSize = 8
        TextButton.ZIndex = 11
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 5)
        local UIStroke5 = Instance.new("UIStroke", TextButton)
        UIStroke5.Color = t1.value59
        UIStroke5.Thickness = 1
        local u218 = false
        local u219
        local TextButtonText = TextButton.Text
        TextButton.MouseButton1Click:Connect(function()
            if u218 then
                u218 = false
                t1.value7 = false

                if u219 then
                    u219:Disconnect()
                    u219 = nil
                end

                TextButton.Text = TextButtonText
                TextButton.TextColor3 = t1.value60

                return
            end

            TextButtonText = TextButton.Text
            u218 = true
            t1.value7 = true
            TextButton.Text = "···"
            TextButton.TextColor3 = t1.value61
            TweenService:Create(UIStroke5, TweenInfo.new(0.1), {
				Color = t1.value60
			}):Play()
            u219 = UserInputService.InputBegan:Connect(function(input)
                if not u218 then
                    return
                end

                local v876 = input.UserInputType == Enum.UserInputType.Keyboard
                local v877 = input.UserInputType == Enum.UserInputType.Gamepad1

                if not v876 and not v877 then
                    return
                end

                if input.KeyCode == Enum.KeyCode.Escape then
                    t1.value7 = false

                    if u219 then
                        u219:Disconnect()
                        u219 = nil
                    end

                    TextButton.Text = TextButtonText
                    TextButton.TextColor3 = t1.value60
                    TweenService:Create(UIStroke5, TweenInfo.new(0.1), {
						Color = t1.value59
					}):Play()

                    return
                end

                if v877 then
                    p30.gp = input.KeyCode
                    p30.kb = nil
                    TextButton.Text = "GP:" .. input.KeyCode.Name

                    local __ = TextButton.Text
                else
                    p30.kb = input.KeyCode
                    p30.gp = nil
                    TextButton.Text = input.KeyCode.Name

                    local __ = TextButton.Text
                end

                TextButton.TextColor3 = t1.value60
                t1.value7 = false

                if u219 then
                    u219:Disconnect()
                    u219 = nil
                end

                TweenService:Create(UIStroke5, TweenInfo.new(0.1), {
					Color = t1.value59
				}):Play()

                if p31 then
                    p31(input.KeyCode)
                end
            end)
        end)

        return TextButton
    end

    local function v79(p32, p33, p34, p35, p36)
        local v240 = p34 and 48
        local v241 = t1.value84(p32, v240 or 38)

        t1.value85(v241, p33, 10, 160, 11, t1.value60, Enum.Font.GothamBold)

        if p34 then
            local v242 = t1.value85(v241, p34, 10, 170, 9, t1.value61, Enum.Font.Gotham)

            v242.Size = UDim2.new(0, 170, 0, 13)
            v242.Position = UDim2.new(0, 10, 0, 24)
        end

        return t1.value86(v241, p35, p36)
    end
    local function v80(p37, p38, p39, p40, p41)
        local v248 = p39 and 48
        local v249 = t1.value84(p37, v248 or 38)

        t1.value85(v249, p38, 10, 160, 11, t1.value60, Enum.Font.GothamBold)

        if p39 then
            local v250 = t1.value85(v249, p39, 10, 170, 9, t1.value61, Enum.Font.Gotham)

            v250.Size = UDim2.new(0, 170, 0, 13)
            v250.Position = UDim2.new(0, 10, 0, 24)
        end

        local v251 = t1.value87(v249, p40, function(p42)
            if p41 then
                p41(p42)
            end
        end)

        v251.Position = UDim2.new(1, -54, 0.5, -10)
        v251.ZIndex = 11

        return v251
    end
    local function v81(p43, p44, p45, p46, p47, p48, p49)
        local v259 = p45 and 48
        local v260 = t1.value84(p43, v259 or 38)

        t1.value85(v260, p44, 10, 120, 11, t1.value60, Enum.Font.GothamBold)

        if p45 then
            local v261 = t1.value85(v260, p45, 10, 150, 9, t1.value61, Enum.Font.Gotham)

            v261.Size = UDim2.new(0, 150, 0, 13)
            v261.Position = UDim2.new(0, 10, 0, 24)
        end

        local v262 = t1.value87(v260, p46, function(p50)
            if p49 then
                p49(p50)
            end
        end)

        v262.Position = UDim2.new(1, -98, 0.5, -10)
        v262.ZIndex = 11

        local n3 = 36
        local Frame19 = Instance.new("Frame", v260)

        Frame19.Size = UDim2.new(0, n3, 0, 19)
        Frame19.Position = UDim2.new(1, -(n3 + 10), 0.5, -9.5)
        Frame19.BackgroundColor3 = p47 and t1.value60 or Color3.fromRGB(16, 16, 16)
        Frame19.BorderSizePixel = 0
        Frame19.ZIndex = 8
        Instance.new("UICorner", Frame19).CornerRadius = UDim.new(0, 10)

        local UIStroke6 = Instance.new("UIStroke", Frame19)

        UIStroke6.Color = p47 and t1.value60 or t1.value59
        UIStroke6.Thickness = 1

        local Frame20 = Instance.new("Frame", Frame19)

        Frame20.Size = UDim2.new(0, 13, 0, 13)
        Frame20.Position = p47 and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        Frame20.BackgroundColor3 = p47 and t1.value55 or t1.value62
        Frame20.BorderSizePixel = 0
        Frame20.ZIndex = 9
        Instance.new("UICorner", Frame20).CornerRadius = UDim.new(0, 4)

        local u267 = p47 or false

        local function v268(p51)
            u267 = p51
            TweenService:Create(Frame19, TweenInfo.new(0.18), {
				BackgroundColor3 = p51 and t1.value60 or Color3.fromRGB(16, 16, 16)
			}):Play()
            TweenService:Create(UIStroke6, TweenInfo.new(0.18), {
				Color = p51 and t1.value60 or t1.value59
			}):Play()

            local v582 = TweenService
            local v583 = Frame20
            local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back)
            local v585 = p51 and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            local v586 = p51 and t1.value55 or t1.value62

            v582:Create(v583, tweenInfo, {
				Position = v585,
				BackgroundColor3 = v586
			}):Play()
        end

        local TextButton = Instance.new("TextButton", v260)

        TextButton.Size = UDim2.new(1, 0, 1, 0)
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.ZIndex = 6
        TextButton.MouseButton1Click:Connect(function()
            if t1.value7 then
                return
            end

            u267 = not u267
            v268(u267)

            if p48 then
                pcall(p48, u267)
            end
        end)

        return v268, v262
    end

    t1.value88 = Instance.new("Frame", t1.value54)
    t1.value88.Size = UDim2.new(0, 240, 0, 38)
    t1.value88.Position = UDim2.new(0.5, -120, 1, -58)
    t1.value88.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    t1.value88.BorderSizePixel = 0
    t1.value88.Active = true
    Instance.new("UICorner", t1.value88).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", t1.value88).Color = Color3.fromRGB(0, 0, 0)
    v31(t1.value88)
    t1.value38 = Instance.new("TextLabel", t1.value88)
    t1.value38.Size = UDim2.new(1, -20, 0, 16)
    t1.value38.Position = UDim2.new(0, 10, 0, 6)
    t1.value38.BackgroundTransparency = 1
    t1.value38.Text = "0%"
    t1.value38.TextColor3 = t1.value60
    t1.value38.Font = Enum.Font.GothamBold
    t1.value38.TextSize = 11
    t1.value38.TextXAlignment = Enum.TextXAlignment.Left
    t1.value38.ZIndex = 5
    t1.value39 = Instance.new("TextLabel", t1.value88)
    t1.value39.Size = UDim2.new(0, 110, 0, 16)
    t1.value39.Position = UDim2.new(1, -120, 0, 6)
    t1.value39.BackgroundTransparency = 1
    t1.value39.Text = "Radius: " .. t1.value16.StealRadius
    t1.value39.TextColor3 = t1.value60
    t1.value39.Font = Enum.Font.GothamBold
    t1.value39.TextSize = 11
    t1.value39.TextXAlignment = Enum.TextXAlignment.Right
    t1.value39.ZIndex = 5

    local Frame21 = Instance.new("Frame", t1.value88)

    Frame21.Size = UDim2.new(1, -20, 0, 8)
    Frame21.Position = UDim2.new(0, 10, 0, 22)
    Frame21.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame21.BorderSizePixel = 0
    Instance.new("UICorner", Frame21).CornerRadius = UDim.new(0, 5)
    t1.value37 = Instance.new("Frame", Frame21)
    t1.value37.Size = UDim2.new(0, 0, 1, 0)
    t1.value37.BackgroundColor3 = t1.value60
    t1.value37.BorderSizePixel = 0
    Instance.new("UICorner", t1.value37).CornerRadius = UDim.new(0, 5)
    v76("Speed", "Speed Configuration")
    t1.value89 = v78("Speed", "Normal Speed", nil, t1.value2, function(p52)
        if p52 > 0 and p52 <= 500 then
            t1.value2 = p52
        end
    end)
    t1.value90 = v78("Speed", "Carry Speed", nil, t1.value3, function(p53)
        if p53 > 0 and p53 <= 500 then
            t1.value3 = p53
        end
    end)
    t1.value91 = v78("Speed", "Lagger Speed", nil, t1.value1, function(p54)
        if p54 > 0 and p54 <= 500 then
            t1.value1 = p54
        end
    end)
    t1.value92 = v78("Speed", "Lagger Carry Speed", nil, t1.value4, function(p55)
        if p55 > 0 and p55 <= 500 then
            t1.value4 = p55
        end
    end)

    local v83 = t1.value84("Speed", 38)

    t1.value85(v83, "Mode", 10, 80, 11, t1.value60, Enum.Font.GothamBold)
    t1.value93 = t1.value85(v83, "Normal", 88, 80, 10, t1.value61, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

    local v84 = t1.value87(v83, t1.value13.Speed, function(__)
    end)

    v84.Position = UDim2.new(1, -54, 0.5, -10)
    v84.ZIndex = 11

    local TextButton = Instance.new("TextButton", v83)

    TextButton.Size = UDim2.new(0.65, 0, 1, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.ZIndex = 6
    TextButton.Active = true
    TextButton.Activated:Connect(function()
        if t1.value7 then
            return
        end

        t1.value6.speedToggled = not t1.value6.speedToggled

        if t1.value6.speedToggled then
            t1.value6.laggerToggled = false

            if t1.value34 then
                t1.value34(false)
            end
        end

        t1.value93.Text = if not t1.value6.laggerToggled then not t1.value6.speedToggled and "Normal" or "Carry" else "Lagger"
    end)

    local v86 = t1.value84("Speed", 38)

    t1.value85(v86, "Lagger Mode", 10, 120, 11, t1.value60, Enum.Font.GothamBold)

    local v87 = t1.value87(v86, t1.value13.Lagger, function(p57)
        t1.value13.Lagger.kb = p57
    end)

    v87.Position = UDim2.new(1, -54, 0.5, -10)
    v87.ZIndex = 11

    local TextButton2 = Instance.new("TextButton", v86)

    TextButton2.Size = UDim2.new(0.65, 0, 1, 0)
    TextButton2.BackgroundTransparency = 1
    TextButton2.Text = ""
    TextButton2.ZIndex = 6
    TextButton2.Active = true
    TextButton2.Activated:Connect(function()
        if t1.value7 then
            return
        end

        t1.value6.laggerToggled = not t1.value6.laggerToggled

        if t1.value6.laggerToggled then
            t1.value6.speedToggled = false

            if t1.value33 then
                t1.value33(false)
            end
        end

        t1.value93.Text = if not t1.value6.laggerToggled then not t1.value6.speedToggled and "Normal" or "Carry" else "Lagger"

        if t1.value34 then
            t1.value34(t1.value6.laggerToggled)
        end
    end)
    v76("Bat Aimbot", "Bat Combat")

    local v89, v90 = v81("Bat Aimbot", "Auto Bat", nil, t1.value13.AutoBat, false, function(p58)
        t1.value6.autoBatToggled = p58

        if p58 then
            t1.value20()

            return
        end

        t1.value21()
    end, function(p59)
        t1.value13.AutoBat.kb = p59
    end)

    _ = v90
    t1.value94 = v89
    t1.value95 = v89
    v76("Mechanics", "Game Mechanics")
    t1.value22 = v79("Mechanics", "Auto Grab", nil, false, function(p60)
        t1.value16.AutoStealEnabled = p60

        if p60 then
            if not pcall(t1.value31) then
                t1.value16.AutoStealEnabled = false
                t1.value22(false)

                return
            end
        else
            t1.value32()
        end
    end)
    t1.value96 = t1.value84("Mechanics", 38)
    t1.value85(t1.value96, "Grab Radius", 10, 120, 11, t1.value60, Enum.Font.GothamBold)
    t1.value97 = Instance.new("TextButton", t1.value96)
    t1.value97.Size = UDim2.new(0, 64, 0, 24)
    t1.value97.Position = UDim2.new(1, -74, 0.5, -12)
    t1.value97.BackgroundColor3 = t1.value64
    t1.value97.BorderSizePixel = 0
    t1.value97.Text = tostring(t1.value16.StealRadius)
    t1.value97.TextColor3 = t1.value60
    t1.value97.Font = Enum.Font.GothamBold
    t1.value97.TextSize = 11
    t1.value97.ZIndex = 11
    Instance.new("UICorner", t1.value97).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", t1.value97).Color = t1.value59
    t1.value98 = false
    t1.value97.Activated:Connect(function()
        if t1.value98 then
            return
        end

        local TextBox = Instance.new("TextBox", t1.value96)

        TextBox.Size = t1.value97.Size
        TextBox.Position = t1.value97.Position
        TextBox.BackgroundColor3 = t1.value57
        TextBox.BorderSizePixel = 0
        TextBox.Text = tostring(t1.value16.StealRadius)
        TextBox.TextColor3 = t1.value60
        TextBox.Font = Enum.Font.GothamBold
        TextBox.TextSize = 11
        TextBox.ClearTextOnFocus = false
        TextBox.ZIndex = 12
        Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", TextBox).Color = t1.value60
        TextBox:CaptureFocus()
        TextBox.FocusLost:Connect(function()
            local num = tonumber(TextBox.Text)

            if num and (num >= 5 and num <= 300) then
                t1.value16.StealRadius = math.floor(num)
                t1.value97.Text = tostring(t1.value16.StealRadius)
                t1.value39.Text = "Radius: " .. t1.value16.StealRadius
                t1.value16.cachedPrompts = {}
                t1.value16.promptCacheTime = 0
            end

            TextBox:Destroy()
        end)
    end)
    t1.value99 = v79("Mechanics", "Infinite Jump", nil, false, function(p61)
        t1.value6.infJumpEnabled = p61
    end)
    t1.value100 = v79("Mechanics", "Anti Ragdoll", nil, false, function(p62)
        t1.value6.antiRagdollEnabled = p62

        if p62 then
            t1.value29()

            return
        end

        t1.value30()
    end)
    t1.value101 = v79("Mechanics", "Unwalk", nil, false, function(p63)
        t1.value6.unwalkEnabled = p63

        if p63 then
            t1.value82()

            return
        end

        t1.value83()
    end)
    t1.value102 = v79("Mechanics", "Medusa Counter", nil, false, function(p64)
        t1.value6.medusaCounterEnabled = p64

        if p64 then
            setupMedusaCounter(LocalPlayer.Character)

            return
        end

        stopMedusaCounter()
    end)
    t1.value103 = v79("Mechanics", "Bat Counter", nil, false, function(p65)
        t1.value6.batCounterEnabled = p65

        if p65 then
            startBatCounter()

            return
        end

        stopBatCounter()
    end)
    t1.value104 = v79("Mechanics", "Desync", nil, false, function(p66)
        if p66 then
            t1.value27()

            return
        end

        t1.value28()
    end)
    v76("Movement", "Movement & Teleport")

    local v91, v92 = v81("Movement", "Auto Left", nil, t1.value13.AutoLeft, false, function(p67)
        t1.value6.autoLeftEnabled = p67

        if p67 then
            if t1.value6.autoRightEnabled then
                t1.value6.autoRightEnabled = false

                if t1.value25 then
                    t1.value25(false)
                end

                t1.value47()
            end

            if t1.value6.autoBatToggled then
                t1.value6.autoBatToggled = false

                if t1.value94 then
                    t1.value94(false)
                end

                t1.value21()
            end

            t1.value48()
        else
            if t1.value40 then
                t1.value40:Disconnect()
                t1.value40 = nil
            end

            t1.value42 = 1

            local Character = LocalPlayer.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end
        end

        if t1.value24 then
            t1.value24(t1.value6.autoLeftEnabled)
        end
    end, function(p68)
        t1.value13.AutoLeft.kb = p68
    end)

    _ = v92
    t1.value24 = v91

    local v93, v94 = v81("Movement", "Auto Right", nil, t1.value13.AutoRight, false, function(p69)
        t1.value6.autoRightEnabled = p69

        if p69 then
            if t1.value6.autoLeftEnabled then
                t1.value6.autoLeftEnabled = false

                if t1.value24 then
                    t1.value24(false)
                end

                if t1.value40 then
                    t1.value40:Disconnect()
                    t1.value40 = nil
                end

                t1.value42 = 1

                local Character = LocalPlayer.Character

                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        Humanoid:Move(Vector3.zero, false)
                    end
                end
            end

            if t1.value6.autoBatToggled then
                t1.value6.autoBatToggled = false

                if t1.value94 then
                    t1.value94(false)
                end

                t1.value21()
            end

            t1.value49()
        else
            t1.value47()
        end

        if t1.value25 then
            t1.value25(t1.value6.autoRightEnabled)
        end
    end, function(p70)
        t1.value13.AutoRight.kb = p70
    end)

    _ = v94
    t1.value25 = v93
    v80("Movement", "Drop", nil, t1.value13.Drop, function(p71)
        t1.value13.Drop.kb = p71
    end)
    v80("Movement", "TP Down", nil, t1.value13.TPDown, function(p72)
        t1.value13.TPDown.kb = p72
    end)
    setAutoTPDownVisual = v79("Movement", "Auto TP Down", nil, false, function(p73)
        t1.value44 = p73

        if p73 then
            t1.value52()

            return
        end

        t1.value53()
    end)
    v78("Movement", "TP Down Height", nil, t1.value46, function(p74)
        t1.value46 = math.clamp(p74, 0, 500)
    end)
    t1.value105 = nil

    function t1.value106()
        t1.value6.stretchRezEnabled = true
        workspace.CurrentCamera.FieldOfView = 120

        if t1.value105 then
            t1.value105:Disconnect()
        end

        t1.value105 = RunService.RenderStepped:Connect(function()
            if not t1.value6.stretchRezEnabled then
                local value105 = t1.value105

                value105:Disconnect()
                t1.value105 = value105

                return
            end

            workspace.CurrentCamera.FieldOfView = 120
        end)
    end
    function t1.value107()
        t1.value6.stretchRezEnabled = false

        if t1.value105 then
            t1.value105:Disconnect()
        end

        workspace.CurrentCamera.FieldOfView = 70
    end

    t1.value108 = nil

    function t1.value109()
        t1.value6.removeAccessoriesEnabled = true
        for v300, v301 in pairs(Players:GetPlayers()) do

            if v301.Character then
                for __, descendant in ipairs(v301.Character:GetDescendants()) do
                    local v304 = descendant

                    if v304:IsA("Accessory") or v304:IsA("Hat") then
                        pcall(function()
                            v304:Destroy()
                        end)
                    end
                end
            end
        end
        if not t1.value108 then
            t1.value108 = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(0.5)

                    if not t1.value6.removeAccessoriesEnabled then
                        return
                    end

                    local GetDescendants = character.GetDescendants

                    for __, v in ipairs(GetDescendants(character)) do
                        local v884 = v

                        if v884:IsA("Accessory") or v884:IsA("Hat") then
                            pcall(function()
                                v884:Destroy()
                            end)
                        end
                    end
                end)
            end)
        end
    end
    function t1.value110()
        t1.value6.removeAccessoriesEnabled = false

        if t1.value108 then
            t1.value108:Disconnect()
        end
    end

    t1.value111 = game:GetService("Lighting").Brightness
    t1.value112 = game:GetService("Lighting").ClockTime
    t1.value113 = game:GetService("Lighting").OutdoorAmbient

    function t1.value114()
        t1.value6.darkModeEnabled = true

        local Lighting = game:GetService("Lighting")
        local v306 = Lighting:FindFirstChild("GalaxySky") or Instance.new("Sky")

        v306.Name = "GalaxySky"
        v306.SkyboxBk = "rbxassetid://159454299"
        v306.SkyboxDn = "rbxassetid://159454296"
        v306.SkyboxFt = "rbxassetid://159454293"
        v306.SkyboxLf = "rbxassetid://159454286"
        v306.SkyboxRt = "rbxassetid://159454289"
        v306.SkyboxUp = "rbxassetid://159454291"
        v306.Parent = Lighting
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
        Lighting.ExposureCompensation = -2
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    end
    function t1.value115()
        t1.value6.darkModeEnabled = false

        local Lighting = game:GetService("Lighting")
        local GalaxySky = Lighting:FindFirstChild("GalaxySky")

        if GalaxySky then
            GalaxySky:Destroy()
        end

        Lighting.Brightness = t1.value111
        Lighting.ClockTime = t1.value112
        Lighting.ExposureCompensation = 0
        Lighting.OutdoorAmbient = t1.value113
    end

    v76("Performance", "Performance")
    t1.value116 = game:GetService("Lighting")
    t1.value117 = nil
    t1.value117 = nil

    function t1.value118(p75)
        if p75:IsA("ParticleEmitter") then
            p75.Enabled = false

            return
        end

        if p75:IsA("Decal") then
            p75.Transparency = 1

            return
        end

        if p75:IsA("BasePart") then
            p75.Material = Enum.Material.Plastic
            p75.Reflectance = 0
            p75.CastShadow = false
        end
    end
    function t1.value119()
        t1.value116.GlobalShadows = false
        t1.value116.FogEnd = 9000000000
        t1.value116.Brightness = 1
        t1.value116.EnvironmentDiffuseScale = 0
        t1.value116.EnvironmentSpecularScale = 0

        for __, child in pairs(t1.value116:GetChildren()) do
            if child:IsA("BloomEffect") or (child:IsA("BlurEffect") or child:IsA("SunRaysEffect")) then
                child.Enabled = false
            end
        end
    end

    local function v95()
        t1.value119()

        for __, descendant in pairs(workspace:GetDescendants()) do
            t1.value118(descendant)

            if descendant:IsA("Accessory") then
                descendant:Destroy()
            end
        end

        if t1.value117 then
            t1.value117:Disconnect()
        end

        workspace.DescendantAdded:Connect(function(descendant)
            t1.value118(descendant)

            if descendant:IsA("Accessory") then
                descendant:Destroy()
            end
        end)
    end

    function t1.value120()
        if t1.value117 then
            t1.value117:Disconnect()
            t1.value117 = nil
        end
    end
    function t1.value121(p76)
        t1.value6.antiLagEnabled = p76

        if p76 then
            v95()

            return
        end

        t1.value120()
    end

    t1.value122 = v79("Performance", "Anti Lag", nil, false, function(p77)
        t1.value121(p77)
    end)
    t1.value123 = t1.value121

    function t1.value121(p78)
        t1.value122(p78)
        t1.value123(p78)
    end
    function t1.value124(p79)
        if p79 then
            t1.value106()

            return
        end

        t1.value107()
    end

    t1.value125 = v79("Performance", "Stretch Rez", nil, false, function(p80)
        t1.value124(p80)
    end)
    t1.value126 = t1.value124

    function t1.value124(p81)
        t1.value125(p81)
        t1.value126(p81)
    end
    function t1.value127(p82)
        if p82 then
            t1.value109()

            return
        end

        t1.value110()
    end

    t1.value128 = v79("Performance", "Remove Accessories", nil, false, function(p83)
        t1.value127(p83)
    end)
    t1.value129 = t1.value127

    function t1.value127(p84)
        t1.value128(p84)
        t1.value129(p84)
    end
    function t1.value130(p85)
        if p85 then
            t1.value114()

            return
        end

        t1.value115()
    end

    t1.value131 = v79("Performance", "Dark Mode", nil, false, function(p86)
        t1.value130(p86)
    end)
    t1.value132 = t1.value130

    function t1.value130(p87)
        t1.value131(p87)
        t1.value132(p87)
    end

    v76("Settings", "Interface & Binds")
    t1.value133 = v79("Settings", "Play Intro", nil, t1.value6.introEnabled, function(p88)
        t1.value6.introEnabled = p88
        pcall(t1.value35)
    end)
    t1.value134 = nil
    t1.value135 = {
		"https://files.catbox.moe/zuid5n.mp3",
		"https://files.catbox.moe/z6eqnt.mp3",
		"https://files.catbox.moe/t0nlhv.mp3",
		"https://files.catbox.moe/mthg31.mp3",
		"https://files.catbox.moe/ddnbup.mp3",
		"https://files.catbox.moe/hg5cr4.mp3",
		"https://files.catbox.moe/nps6gk.mp3",
		"https://files.catbox.moe/iyw1cb.mp3",
		"https://files.catbox.moe/2w0wtv.mp3"
	}
    t1.value134 = nil
    t1.value136 = false

    function t1.value137()
        if t1.value134 then
            pcall(function()
                t1.value134:Stop()
            end)
            pcall(function()
                t1.value134:Destroy()
            end)
            t1.value134 = nil
        end
    end

    local v96 = t1.value84("Settings", 38)

    t1.value85(v96, "Intro Music", 10, 130, 11, t1.value60, Enum.Font.GothamBold)
    t1.value138 = Instance.new("TextButton", v96)
    t1.value138.Size = UDim2.new(0, 80, 0, 24)
    t1.value138.Position = UDim2.new(1, -90, 0.5, -12)
    t1.value138.BackgroundColor3 = t1.value60
    t1.value138.BorderSizePixel = 0
    t1.value138.Text = "Music " .. t1.value6.selectedIntroMusic
    t1.value138.TextColor3 = t1.value55
    t1.value138.Font = Enum.Font.GothamBold
    t1.value138.TextSize = 11
    t1.value138.ZIndex = 11
    Instance.new("UICorner", t1.value138).CornerRadius = UDim.new(0, 5)
    getgenv().EnvyMusicBtn = t1.value138
    t1.value138.Activated:Connect(function()
        if t1.value136 then
            return
        end

        t1.value137()
        task.wait(0.15)
        t1.value6.selectedIntroMusic = t1.value6.selectedIntroMusic + 1

        if t1.value6.selectedIntroMusic > #t1.value135 then
            t1.value6.selectedIntroMusic = 1
        end

        t1.value138.Text = "Music " .. t1.value6.selectedIntroMusic

        local selectedIntroMusic = t1.value6.selectedIntroMusic

        t1.value137()
        task.spawn(function()
            pcall(function()
                writefile("flowHubDuelsPreview", game:HttpGet(t1.value135[selectedIntroMusic]))
                t1.value134 = Instance.new("Sound", gethui())
                t1.value134.SoundId = getcustomasset("flowHubDuelsPreview")
                t1.value134.Volume = 0.5
                t1.value134:Play()
                task.delay(10, function()
                    t1.value137()
                end)
            end)
        end)
        pcall(t1.value35)
        TweenService:Create(t1.value138, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		}):Play()
        task.delay(0.15, function()
            TweenService:Create(t1.value138, TweenInfo.new(0.1), {
				BackgroundColor3 = t1.value60
			}):Play()
        end)
        task.wait(0.5)
    end)
    t1.value138.MouseEnter:Connect(function()
        TweenService:Create(t1.value138, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(210, 210, 210)
		}):Play()
    end)
    t1.value138.MouseLeave:Connect(function()
        TweenService:Create(t1.value138, TweenInfo.new(0.1), {
			BackgroundColor3 = t1.value60
		}):Play()
    end)
    t1.value139 = v78("Settings", "UI Scale", nil, t1.value65, function(p89)
        local v330 = math.clamp(math.floor(p89 + 0.5), 50, 150)

        t1.value65 = v330

        if t1.value67 then
            t1.value67.Scale = v330 / 70
        end

        pcall(t1.value35)
    end)
    v80("Settings", "Hide / Show GUI", nil, t1.value13.GuiHide, function(p90)
        t1.value13.GuiHide.kb = p90
    end)

    local v97 = v79("Settings", "Lock UI", nil, false, function(p91)
        t1.value8 = p91
        t1.value10()
    end)

    t1.value140 = nil
    t1.value140 = v77("Settings", "Save Config", function()
        if t1.value35 then
            pcall(function()
                t1.value35(t1.value140)
            end)

            if t1.value140 then
                local value140Text = t1.value140.Text

                t1.value140.Text = "✓ Saved!"
                task.delay(1.5, function()
                    if t1.value140 and t1.value140.Parent then
                        t1.value140.Text = value140Text
                    end
                end)
            end
        end
    end)
    v77("Settings", "Reset Mobile Buttons", function()
        if t1.value9 then
            t1.value9()
        end
    end)
    t1.value141 = 58
    t1.value142 = 14
    t1.value143 = 6
    t1.value144 = t1.value143 * 2 + 2 * t1.value141 + 1 * t1.value142
    t1.value145 = t1.value143 * 2 + 4 * t1.value141 + 3 * t1.value142
    t1.value146 = Instance.new("Frame")
    t1.value146.Name = "MobileButtonsPanel"
    t1.value146.Size = UDim2.new(0, t1.value144, 0, t1.value145)
    t1.value146.Position = UDim2.new(1, -(t1.value144 + 20), 1, -(t1.value145 + 20))
    t1.value146.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    t1.value146.BackgroundTransparency = 1
    t1.value146.BorderSizePixel = 0
    t1.value146.ZIndex = 95
    t1.value146.Parent = t1.value54
    v31(t1.value146)
    t1.value146.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            task.defer(function()
                pcall(t1.value35)
            end)
        end
    end)

    function t1.value9()
        local value146 = t1.value146
        local new = UDim2.new
        local v337 = -(t1.value145 + 20)

        value146.Position = new(1, -(t1.value144 + 20), 1, v337)
        task.defer(function()
            pcall(t1.value35)
        end)
    end

    t1.value147 = Color3.fromRGB(0, 0, 0)
    t1.value148 = Color3.fromRGB(255, 255, 255)
    t1.value149 = Color3.fromRGB(255, 255, 255)
    t1.value150 = Color3.fromRGB(0, 0, 0)

    local function v98(p92, p93, p94, p95, p96, p97)
        local v344 = t1.value143 + p94 * (t1.value141 + t1.value142)
        local v345 = t1.value143 + p95 * (t1.value141 + t1.value142)
        local TextButton3 = Instance.new("TextButton")

        TextButton3.Name = "Btn_" .. p92
        TextButton3.Size = UDim2.new(0, t1.value141, 0, t1.value141)
        TextButton3.Position = UDim2.new(0, v344, 0, v345)
        TextButton3.BackgroundColor3 = t1.value147
        TextButton3.Text = p93
        TextButton3.TextColor3 = t1.value149
        TextButton3.TextScaled = false
        TextButton3.TextSize = 11
        TextButton3.Font = Enum.Font.GothamBold
        TextButton3.TextWrapped = true
        TextButton3.LineHeight = 1.2
        TextButton3.BorderSizePixel = 0
        TextButton3.AutoButtonColor = false
        TextButton3.ZIndex = 99
        TextButton3.Parent = t1.value146
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 12)

        local u347 = false

        local function v348(p98)
            u347 = p98

            local v592 = TweenService
            local v593 = TextButton3
            local tweenInfo = TweenInfo.new(0.15)
            local v595 = p98 and t1.value148 or t1.value147
            local v596 = p98 and t1.value150 or t1.value149

            v592:Create(v593, tweenInfo, {
				BackgroundColor3 = v595,
				TextColor3 = v596
			}):Play()
        end
        local function v349()
            TweenService:Create(TextButton3, TweenInfo.new(0.08), {
				BackgroundColor3 = Color3.fromRGB(200, 200, 200),
				TextColor3 = t1.value150
			}):Play()
            task.delay(0.22, function()
                TweenService:Create(TextButton3, TweenInfo.new(0.15), {
					BackgroundColor3 = t1.value147,
					TextColor3 = t1.value149
				}):Play()
            end)
        end

        TextButton3.Activated:Connect(function()
            if p96 then
                u347 = not u347
                v348(u347)

                if p97 then
                    p97(u347)

                    return
                end
            else
                v349()

                if p97 then
                    p97()
                end
            end
        end)

        return TextButton3, v348
    end

    v98("Drop", "DROP\nBR", 0, 0, false, function()
        task.spawn(t1.value50)
    end)

    local __, v100 = v98("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(p99)
        t1.value6.autoLeftEnabled = p99

        if p99 then
            if t1.value6.autoRightEnabled then
                t1.value6.autoRightEnabled = false

                if t1.value25 then
                    t1.value25(false)
                end

                t1.value47()
            end

            if t1.value6.autoBatToggled then
                t1.value6.autoBatToggled = false

                if t1.value94 then
                    t1.value94(false)
                end

                t1.value21()
            end

            t1.value48()
        else
            if t1.value40 then
                t1.value40:Disconnect()
                t1.value40 = nil
            end

            t1.value42 = 1

            local Character = LocalPlayer.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end
        end

        if t1.value24 then
            t1.value24(t1.value6.autoLeftEnabled)
        end
    end)

    t1.value151 = v100

    function t1.value24(p100)
        t1.value151(p100)
    end

    local __, v102 = v98("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(p101)
        t1.value6.autoBatToggled = p101

        if p101 then
            t1.value20()

            return
        end

        t1.value21()
    end)

    t1.value152 = v102

    function t1.value94(p102)
        t1.value152(p102)

        if t1.value95 then
            t1.value95(p102)
        end
    end

    local __, v104 = v98("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(p103)
        t1.value6.autoRightEnabled = p103

        if p103 then
            if t1.value6.autoLeftEnabled then
                t1.value6.autoLeftEnabled = false

                if t1.value24 then
                    t1.value24(false)
                end

                if t1.value40 then
                    t1.value40:Disconnect()
                    t1.value40 = nil
                end

                t1.value42 = 1

                local Character = LocalPlayer.Character

                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        Humanoid:Move(Vector3.zero, false)
                    end
                end
            end

            if t1.value6.autoBatToggled then
                t1.value6.autoBatToggled = false

                if t1.value94 then
                    t1.value94(false)
                end

                t1.value21()
            end

            t1.value49()
        else
            t1.value47()
        end

        if t1.value25 then
            t1.value25(t1.value6.autoRightEnabled)
        end
    end)

    t1.value153 = v104

    function t1.value25(p104)
        t1.value153(p104)
    end

    v98("TPDown", "TP\nDOWN", 0, 2, false, function()
        task.spawn(t1.value51)
    end)

    local __, v106 = v98("Speed", "CARRY\nSPD", 1, 2, true, function(p105)
        t1.value6.speedToggled = p105
        t1.value6.laggerToggled = false
        t1.value5 = 0

        if t1.value34 then
            t1.value34(false)
        end

        if t1.value93 then
            t1.value93.Text = not p105 and "Normal" or "Carry"
        end
    end)

    t1.value154 = v106

    function t1.value33(p106)
        t1.value154(p106)
    end

    t1.value155 = nil

    local __, v108 = v98("Lagger", "LAGGER\nMODE", 1, 3, true, function(p107)
        t1.value6.laggerToggled = p107
        t1.value5 = not p107 and 0 or 1

        if p107 then
            t1.value6.speedToggled = false

            if t1.value33 then
                t1.value33(false)
            end

            t1.value155(false)

            if t1.value93 then
                t1.value93.Text = "Lagger"

                return
            end
        else
            t1.value5 = 0

            if t1.value93 then
                t1.value93.Text = "Normal"
            end
        end
    end)

    t1.value156 = v108

    function t1.value34(p108)
        t1.value156(p108)

        if not p108 then
            t1.value5 = 0
        end
    end

    local __, v110 = v98("LaggerCarry", "LAGGER\nCARRY", 0, 3, true, function(p109)
        t1.value6.laggerToggled = p109
        t1.value5 = not p109 and 0 or 2

        if p109 then
            t1.value6.speedToggled = false

            if t1.value33 then
                t1.value33(false)
            end

            t1.value156(false)

            if t1.value93 then
                t1.value93.Text = "Lagger Carry"

                return
            end
        else
            t1.value5 = 0

            if t1.value93 then
                t1.value93.Text = "Normal"
            end
        end
    end)

    t1.value155 = v110
    t2.AutoLeft = t1.value151
    t2.AutoRight = t1.value153
    t2.AutoBat = t1.value152

    function t1.value35(p110)
        local function v364(p111)
            local v598 = p111.kb and p111.kb.Name or nil
            local v599 = p111.gp and p111.gp.Name or nil

            return {
				kb = v598,
				gp = v599
			}
        end

        local value2 = t1.value2
        local value3 = t1.value3
        local value1 = t1.value1
        local introEnabled = t1.value6.introEnabled
        local selectedIntroMusic = t1.value6.selectedIntroMusic
        local v370 = v364(t1.value13.AutoLeft)
        local v371 = v364(t1.value13.AutoRight)
        local v372 = v364(t1.value13.Drop)
        local v373 = v364(t1.value13.TPDown)
        local v374 = v364(t1.value13.AutoBat)
        local v375 = v364(t1.value13.Speed)
        local v376 = v364(t1.value13.GuiHide)
        local v377 = v364(t1.value13.Lagger)
        local StealRadius = t1.value16.StealRadius
        local infJumpEnabled = t1.value6.infJumpEnabled
        local antiRagdollEnabled = t1.value6.antiRagdollEnabled
        local AutoStealEnabled = t1.value16.AutoStealEnabled
        local unwalkEnabled = t1.value6.unwalkEnabled
        local laggerToggled = t1.value6.laggerToggled
        local value8 = t1.value8
        local autoBatToggled = t1.value6.autoBatToggled
        local desyncEnabled = t1.value6.desyncEnabled
        local value66 = t1.value66

        if value66 then
            local XScale = t1.value66.Position.X.Scale
            local XOffset = t1.value66.Position.X.Offset
            local YScale = t1.value66.Position.Y.Scale
            local YOffset = t1.value66.Position.Y.Offset

            value66 = {
				xs = XScale,
				xo = XOffset,
				ys = YScale,
				yo = YOffset
			}
        end

        local v392 = value66 or nil
        local value69 = t1.value69

        if value69 then
            local XScale = t1.value69.Position.X.Scale
            local XOffset = t1.value69.Position.X.Offset
            local YScale = t1.value69.Position.Y.Scale
            local YOffset = t1.value69.Position.Y.Offset

            value69 = {
				xs = XScale,
				xo = XOffset,
				ys = YScale,
				yo = YOffset
			}
        end

        local v398 = value69 or nil
        local value146 = t1.value146

        if value146 then
            local XScale = t1.value146.Position.X.Scale
            local XOffset = t1.value146.Position.X.Offset
            local YScale = t1.value146.Position.Y.Scale
            local YOffset = t1.value146.Position.Y.Offset

            value146 = {
				xs = XScale,
				xo = XOffset,
				ys = YScale,
				yo = YOffset
			}
        end

        local v404 = value146 or nil
        local value88 = t1.value88

        if value88 then
            local XScale = t1.value88.Position.X.Scale
            local XOffset = t1.value88.Position.X.Offset
            local YScale = t1.value88.Position.Y.Scale
            local YOffset = t1.value88.Position.Y.Offset

            value88 = {
				xs = XScale,
				xo = XOffset,
				ys = YScale,
				yo = YOffset
			}
        end

        local v410 = value88 or nil
        local t12 = {
			normalSpeed = value2,
			carrySpeed = value3,
			laggerSpeed = value1,
			introEnabled = introEnabled,
			selectedIntroMusic = selectedIntroMusic,
			autoLeftKey = v370,
			autoRightKey = v371,
			dropKey = v372,
			tpDownKey = v373,
			autoBatKey = v374,
			speedKey = v375,
			guiHideKey = v376,
			laggerKey = v377,
			grabRadius = StealRadius,
			infJump = infJumpEnabled,
			antiRagdoll = antiRagdollEnabled,
			autoStealEnabled = AutoStealEnabled,
			unwalkEnabled = unwalkEnabled,
			laggerMode = laggerToggled,
			uiLocked = value8,
			autoBatToggled = autoBatToggled,
			desyncEnabled = desyncEnabled,
			mainPos = v392,
			miniPos = v398,
			panelPos = v404,
			pbPos = v410
		}
        local ok = pcall(function()
            local json = HttpService:JSONEncode(t12)

            if writefile then
                writefile("flowMobileConfig.json", json)
            end
        end)

        if not ok then
            pcall(function()
                local json = HttpService:JSONEncode(t12)

                if _writefile then
                    _writefile("flowMobileConfig.json", json)
                end
            end)
        end

        if p110 then
            local p110Text = p110.Text

            p110.Text = not ok and "✕  Failed!" or "✓  Saved!"
            task.wait(1.5)
            p110.Text = p110Text
        end
    end

    t1.value157 = {
		active = false,
		conn = nil,
		invisiblePart = nil,
		originalWalk = nil,
		lastWalkWritten = nil,
		lastSnapTime = 0,
		postSimLastT = 0,
		linearVelocity = nil,
		networkRefreshConn = nil,
		savedSpeed = nil,
		fflagLastApplyT = 0,
		LV_MAX_FORCE = 12000000,
		VEL_SMOOTH_HZ = 4.25,
		SNAP_MIN_INTERVAL = 0.14,
		DRIVE_MIN = 20,
		DRIVE_MAX = 29,
		REPORT_WALK_MIN_TOUCH = 38,
		REPORT_WALK_MAX_TOUCH = 56,
		REPORT_PER_DRIVE_TOUCH = 1.48,
		REPORT_PER_DRIVE_OFF_TOUCH = 3.2,
		BYPASS_STEAL_MIN = 40,
		BYPASS_STEAL_MAX = 51
	}
    t1.value158 = {
		S2PhysicsSenderRate = 15000,
		DFIntConnectionMTUSize = 1400,
		DFIntRakNetResendBufferArrayLength = 128,
		DFIntRakNetResendTimeoutMS = 300,
		DFIntNetworkLatencyTolerance = 1,
		DFIntNetworkPrediction = 1,
		FFlagRakNetDisableFlowControl = true,
		DFFlagRakNetDisableCongestionControl = true,
		DFIntTaskSchedulerTargetFps = 29383,
		FFlagGameBasicSettingsFramerateCap5 = false,
		FFlagTaskSchedulerLimitTargetFpsTo2402 = false
	}

    function t1.value159()
        local timestamp = tick()

        if timestamp - t1.value157.fflagLastApplyT < 0.75 then
            return
        end

        t1.value157.fflagLastApplyT = timestamp

        if type(setfflag) ~= "function" then
            return
        end

        for k, v in pairs(t1.value158) do
            local v425 = v

            pcall(function()
                setfflag(tostring(k), (tostring(v425)))
            end)
        end
    end
    function t1.value160(p112)
        pcall(function()
            local v602 = rawget(getgenv and getgenv() or _G, "raknet")

            if type(v602) == "table" and type(v602.desync) == "function" then
                v602.desync(p112)
            end
        end)
        pcall(function()
            local v603 = rawget(getgenv and getgenv() or _G, "network")

            if type(v603) == "table" and type(v603.desync) == "function" then
                v603.desync(p112)
            end
        end)
        pcall(function()
            local v604 = rawget(getgenv and getgenv() or _G, "fluxus")

            if type(v604) == "table" and type(v604.network_desync) == "function" then
                v604.network_desync(p112)
            end
        end)
    end

    t1.value161 = nil

    function t1.value162()
        if t1.value157.conn then
            t1.value157.conn:Disconnect()
            t1.value157.conn = nil
        end

        if t1.value157.networkRefreshConn then
            t1.value157.networkRefreshConn:Disconnect()
            t1.value157.networkRefreshConn = nil
        end

        pcall(function()
            if t1.value157.invisiblePart then
                t1.value157.invisiblePart:Destroy()
            end
        end)
        t1.value157.invisiblePart = nil

        for __, child in ipairs(workspace:GetChildren()) do
            if child.Name == "DarkHub_DesyncPos" then
                pcall(function()
                    child:Destroy()
                end)
            end
        end

        local Character = LocalPlayer.Character
        local v421 = Character and Character:FindFirstChildOfClass("Humanoid")

        if v421 and t1.value157.originalWalk ~= nil then
            pcall(function()
                v421.WalkSpeed = t1.value157.originalWalk
            end)
        end

        t1.value157.originalWalk = nil
        t1.value157.lastWalkWritten = nil
        t1.value157.lastSnapTime = 0
        t1.value157.postSimLastT = 0
        t1.value157.linearVelocity = nil
    end

    t1.value163 = nil

    function t1.value164(p113)
        local v427 = math.clamp((type(p113) == "number" and (p113 > 0 and (p113 < 0.5 and p113)) or 0.016666666666667) * t1.value157.VEL_SMOOTH_HZ, 0.08, 0.5)

        local function v428(p114, p115)
            local AssemblyLinearVelocity = t1.value157.invisiblePart.AssemblyLinearVelocity
            local vector3_8 = Vector3.new(AssemblyLinearVelocity.X + (p114 - AssemblyLinearVelocity.X) * v427, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z + (p115 - AssemblyLinearVelocity.Z) * v427)

            if t1.value157.linearVelocity and t1.value157.linearVelocity.Parent then
                t1.value157.linearVelocity.VectorVelocity = vector3_8

                return
            end

            t1.value157.invisiblePart.AssemblyLinearVelocity = vector3_8
        end

        if not t1.value157.active or (not t1.value157.invisiblePart or not t1.value157.invisiblePart.Parent) then
            return
        end

        local Character = LocalPlayer.Character

        if not Character or Character ~= t1.value157.invisiblePart.Parent then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local v432 = not Humanoid

        if not v432 then
            v432 = not HumanoidRootPart
        end

        if v432 then
            return
        end

        if Humanoid.Health <= 0 then
            local vector3_9 = Vector3.new(0, t1.value157.invisiblePart.AssemblyLinearVelocity.Y, 0)

            if t1.value157.linearVelocity and t1.value157.linearVelocity.Parent then
                t1.value157.linearVelocity.VectorVelocity = vector3_9

                return
            end

            t1.value157.invisiblePart.AssemblyLinearVelocity = vector3_9

            return
        end

        local MoveDirection = Humanoid.MoveDirection
        local v435 = MoveDirection.Magnitude > 0.02
        local v436 = v435 and MoveDirection.Unit or nil
        local v437 = math.clamp((math.clamp(t1.value157.originalWalk or 16, 6, 34) - 6) / 28, 0, 1)
        local v438 = t1.value157.DRIVE_MIN + v437 * (t1.value157.DRIVE_MAX - t1.value157.DRIVE_MIN)
        local u439 = math.clamp(v438 * t1.value157.REPORT_PER_DRIVE_TOUCH + t1.value157.REPORT_PER_DRIVE_OFF_TOUCH, t1.value157.REPORT_WALK_MIN_TOUCH, t1.value157.REPORT_WALK_MAX_TOUCH)

        if t1.value6.isStealing then
            v438 = math.clamp(30, t1.value157.BYPASS_STEAL_MIN, t1.value157.BYPASS_STEAL_MAX)
            u439 = v438
        end

        if v435 then
            if t1.value157.lastWalkWritten == nil or math.abs(t1.value157.lastWalkWritten - u439) > 0.28 then
                pcall(function()
                    Humanoid.WalkSpeed = u439
                end)
                t1.value157.lastWalkWritten = u439
            end

            v428(v436.X * v438, v436.Z * v438)
        else
            if t1.value157.lastWalkWritten == nil or math.abs(t1.value157.lastWalkWritten - u439) > 0.35 then
                pcall(function()
                    Humanoid.WalkSpeed = u439
                end)
                t1.value157.lastWalkWritten = u439
            end

            v428(0, 0)
        end
    end
    function t1.value163()
        if not t1.value157.active or (not t1.value157.invisiblePart or not t1.value157.invisiblePart.Parent) then
            return
        end

        local Character = LocalPlayer.Character

        if not Character or Character ~= t1.value157.invisiblePart.Parent then
            return
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

        local timestamp = tick()

        if t1.value157.lastSnapTime > 0 and timestamp - t1.value157.lastSnapTime < t1.value157.SNAP_MIN_INTERVAL then
            return
        end

        t1.value157.lastSnapTime = timestamp
        t1.value157.invisiblePart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -2.85)
    end
    function t1.value161(p116)
        t1.value162()

        if not t1.value157.active then
            return
        end

        local Humanoid = p116:WaitForChild("Humanoid", 15)
        local HumanoidRootPart = p116:WaitForChild("HumanoidRootPart", 15)

        if not Humanoid or not HumanoidRootPart then
            return
        end

        t1.value157.originalWalk = Humanoid.WalkSpeed
        t1.value157.lastWalkWritten = nil
        t1.value157.linearVelocity = nil
        t1.value157.invisiblePart = Instance.new("Part")
        t1.value157.invisiblePart.Name = "DarkHub_DesyncFollower"
        t1.value157.invisiblePart.Size = Vector3.new(2, 1, 2)
        t1.value157.invisiblePart.Transparency = 1
        t1.value157.invisiblePart.CanCollide = false
        t1.value157.invisiblePart.Anchored = false
        t1.value157.invisiblePart.Massless = true
        t1.value157.invisiblePart.Parent = p116

        local Attachment = Instance.new("Attachment")

        Attachment.Name = "DH_DesyncDrive"
        Attachment.Parent = t1.value157.invisiblePart

        local LinearVelocity = Instance.new("LinearVelocity")

        LinearVelocity.Name = "DH_DesyncLinearVelocity"
        LinearVelocity.Attachment0 = Attachment
        LinearVelocity.RelativeTo = Enum.ActivationRelativeTo.World
        LinearVelocity.MaxForce = t1.value157.LV_MAX_FORCE
        LinearVelocity.VectorVelocity = Vector3.zero
        LinearVelocity.Parent = t1.value157.invisiblePart
        t1.value157.linearVelocity = LinearVelocity

        local u448 = false

        pcall(function()
            local Weld = Instance.new("Weld")

            Weld.Name = "DH_DesyncWeld"
            Weld.Part0 = HumanoidRootPart
            Weld.Part1 = t1.value157.invisiblePart
            Weld.C0 = CFrame.new(0, 0, -3.85)
            Weld.Parent = t1.value157.invisiblePart
            u448 = true
        end)

        if not u448 then
            t1.value157.invisiblePart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -3.85)

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Name = "DH_DesyncWeldConstraint"
            WeldConstraint.Part0 = HumanoidRootPart
            WeldConstraint.Part1 = t1.value157.invisiblePart
            WeldConstraint.Parent = t1.value157.invisiblePart
        end

        task.defer(function()
            t1.value157.lastSnapTime = 0
            t1.value163()
            RunService.Heartbeat:Wait()
            t1.value163()
        end)
        task.delay(0.15, t1.value163)
        t1.value157.postSimLastT = os.clock()

        local v450 = RunService.PostSimulation or RunService.Heartbeat

        t1.value157.conn = v450:Connect(function()
            local elapsed = os.clock()
            local v618 = math.clamp(elapsed - t1.value157.postSimLastT, 0.0041666666666667, 0.04)

            t1.value157.postSimLastT = elapsed
            t1.value164(v618)
        end)

        local n4 = 0

        t1.value157.networkRefreshConn = RunService.Heartbeat:Connect(function(dt)
            if not t1.value157.active then
                return
            end

            local v620 = type(dt) == "number" and dt

            n4 += v620 or 0.016666666666667

            if n4 < 1.2 then
                return
            end

            if t1.value157.active then
                t1.value157.fflagLastApplyT = 0
                t1.value159()
            end
        end)
        t1.value157.fflagLastApplyT = 0
        t1.value159()
        task.delay(0.45, function()
            if t1.value157.active then
                t1.value157.fflagLastApplyT = 0
                t1.value159()
            end
        end)
        task.delay(1.35, function()
            if t1.value157.active then
                t1.value157.fflagLastApplyT = 0
                t1.value159()
            end
        end)
    end
    function t1.value28()
        t1.value160(false)
        t1.value157.active = false
        t1.value162()
        t1.value157.savedSpeed = nil
        t1.value6.desyncEnabled = false

        if t1.value104 then
            t1.value104(false)
        end

        if t1.value26 then
            t1.value26(false)
        end
    end
    function t1.value27()
        if t1.value157.active then
            return
        end

        t1.value162()
        t1.value157.savedSpeed = nil
        t1.value157.fflagLastApplyT = 0
        t1.value159()
        t1.value160(true)
        t1.value157.active = true
        t1.value6.desyncEnabled = true

        if t1.value104 then
            t1.value104(true)
        end

        if t1.value26 then
            t1.value26(true)
        end

        task.spawn(function()
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
            local v609, v610, v611 = ipairs({
				0.12,
				0.45,
				1.2
			})
            local g613
            local Character
            repeat
                repeat
                    local v612

                    v611, v612 = v609(v610, v611)

                    if not v611 then
                        g613 = true
                    end

                    if g613 then
                        break
                    end

                    task.wait(v612)

                    if not t1.value157.active then
                        return
                    end

                    Character = LocalPlayer.Character
                until Character and not t1.value157.invisiblePart or not t1.value157.invisiblePart.Parent

                if g613 then
                    break
                end

                t1.value161(Character)
            until t1.value157.invisiblePart and t1.value157.invisiblePart.Parent
            g613 = false
            task.wait(3.5)
            if not t1.value157.active then
                return
            end
            local Character2 = LocalPlayer.Character
            if Character2 and not t1.value157.invisiblePart or not t1.value157.invisiblePart.Parent then
                t1.value161(Character2)
            end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(function(character)
        if t1.value157.active then
            t1.value157.fflagLastApplyT = 0
            t1.value159()
            task.delay(0.45, function()
                if t1.value157.active and LocalPlayer.Character == character then
                    t1.value157.fflagLastApplyT = 0
                    t1.value159()
                end
            end)
            task.defer(function()
                t1.value161(character)

                if t1.value157.active and not t1.value157.invisiblePart or not t1.value157.invisiblePart.Parent then
                    task.delay(0.35, function()
                        if t1.value157.active and LocalPlayer.Character == character then
                            t1.value161(LocalPlayer.Character)
                        end
                    end)
                end
            end)
        end
    end);
    (function()
        local t13 = {}
        local t14 = {}
        local _isfile = isfile

        if not _isfile then
            _isfile = syn and syn.isfile or (getgenv and getgenv().isfile or function()
                return false
            end)
        end

        t14.value1 = _isfile

        local _readfile = readfile

        if not _readfile then
            _readfile = syn and syn.readfile or (getgenv and getgenv().readfile or function()
                return nil
            end)
        end

        t14.value2 = _readfile

        local _writefile2 = writefile

        if not _writefile2 then
            _writefile2 = syn and syn.writefile or (getgenv and getgenv().writefile or function()
            end)
        end

        t14.value3 = _writefile2

        local _getconnections = getconnections

        if not _getconnections then
            t13.value1 = get_signal_cons
            _getconnections = t13.value1

            if not t13.value1 then
                _getconnections = getconnects or syn and syn.get_signal_cons
            end
        end

        t14.value4 = _getconnections

        local W = Enum.KeyCode.W

        t13.value1 = Enum.KeyCode.A

        local S = Enum.KeyCode.S
        local D = Enum.KeyCode.D
        local Up = Enum.KeyCode.Up
        local Left = Enum.KeyCode.Left
        local KeyCode = Enum.KeyCode

        t14.value5 = nil

        local Down = KeyCode.Down
        local Right = Enum.KeyCode.Right

        t14.value6 = {
			[W] = true,
			[v1653] = true,
			[S] = true,
			[D] = true,
			[Up] = true,
			[Left] = true,
			[Down] = true,
			[Right] = true
		}
        t14.value7 = 2
        t14.value8 = 0.15
        t14.value9 = 0.1
        t14.value10 = 25
        t14.value11 = 0.15
        t14.value12 = "flowMobileConfig.json"
        t1.value6.autoLeftPhase = 1
        t1.value6.autoRightPhase = 1
        t1.value6.medusaLastUsed = 0
        t1.value6.medusaDebounce = false
        t1.value6.medusaCounterEnabled = false
        t1.value6.batAimbotToggled = false
        t1.value6.autoSwingEnabled = false
        t1.value6.hittingCooldown = false
        t1.value6.batCounterEnabled = false
        t1.value6.batCounterDebounce = false
        t1.value6.dropEnabled = false
        t1.value6._tpInProgress = false
        t1.value6.lastMoveDir = Vector3.new(0, 0, 0)
        t1.value6._prevCarry = t1.value3
        t1.value6._prevSpeed = false
        t1.value6.laggerEnabled = false
        t1.value17.autoLeft = nil
        t1.value17.autoRight = nil
        t1.value17.aimbot = nil
        t1.value17.batCounter = nil
        t1.value17.unwalk = nil
        t14.value13 = {}
        t14.value14 = "flowMobilePresets.json"
        t14.value15 = "flowMobileLastPreset.json"

        local function v467()
            local u649 = false
            pcall(function()
                u649 = t14.value1(t14.value15)
            end)
            if not u649 then
                return nil
            end
            local u650
            pcall(function()
                u650 = t14.value2(t14.value15)
            end)
            if not u650 then
                return nil
            end
            local ok, result = pcall(function()
                return HttpService:JSONDecode(u650)
            end)
            if ok and result then
                return result.lastPreset
            end

            return nil
        end

        t14.value16 = nil

        local function v468()
            pcall(function()
                local Character = LocalPlayer.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart then
                    return
                end

                local raycastParams = RaycastParams.new()

                raycastParams.FilterDescendantsInstances = { Character }
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                local raycastResult = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastParams)

                if raycastResult then
                    HumanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, HumanoidRootPart.Size.Y / 2 + 0.5, 0))
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end)
        end

        t14.value17 = {}

        local function v469(p117)
            if p117 == LocalPlayer then
                return
            end

            local function v654(p118)
                task.wait(0.2)

                local Head = p118:FindFirstChild("Head")
                local HumanoidRootPart = p118:FindFirstChild("HumanoidRootPart")

                if not Head or not HumanoidRootPart then
                    return
                end

                local EnvyOtherBB = Head:FindFirstChild("EnvyOtherBB")

                if EnvyOtherBB then
                    EnvyOtherBB:Destroy()
                end

                local BillboardGui = Instance.new("BillboardGui", Head)

                BillboardGui.Name = "EnvyOtherBB"
                BillboardGui.Size = UDim2.new(0, 100, 0, 30)
                BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                BillboardGui.AlwaysOnTop = true

                local TextLabel8 = Instance.new("TextLabel", BillboardGui)

                TextLabel8.Size = UDim2.new(1, 0, 1, 0)
                TextLabel8.BackgroundTransparency = 1
                TextLabel8.Text = "0.0"
                TextLabel8.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel8.Font = Enum.Font.GothamBlack
                TextLabel8.TextScaled = true
                TextLabel8.TextStrokeTransparency = 0
                TextLabel8.TextStrokeColor3 = Color3.new(0, 0, 0)
                RunService.RenderStepped:Connect(function()
                    if not HumanoidRootPart or not HumanoidRootPart.Parent then
                        conn:Disconnect()

                        return
                    end

                    local Magnitude = Vector3.new(HumanoidRootPart.Velocity.X, 0, HumanoidRootPart.Velocity.Z).Magnitude

                    TextLabel8.Text = string.format("%.1f", Magnitude)
                end)
            end

            p117.CharacterAdded:Connect(v654)

            if p117.Character then
                task.spawn(v654, p117.Character)
            end
        end

        t14.value18 = {
			"Bat",
			"Slap",
			"Iron Slap",
			"Gold Slap",
			"Diamond Slap",
			"Emerald Slap",
			"Ruby Slap",
			"Dark Matter Slap",
			"Flame Slap",
			"Nuclear Slap",
			"Galaxy Slap",
			"Glitched Slap"
		}

        local function v470()
            local Character = LocalPlayer.Character

            if not Character then
                return nil
            end

            local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

            for __, v in ipairs(t14.value18) do
                local v659 = Character:FindFirstChild(v) or Backpack and Backpack:FindFirstChild(v)

                if v659 then
                    return v659
                end
            end

            local v660, v661, v662 = ipairs(Character:GetChildren())
            local v663

            repeat
                v662, v663 = v660(v661, v662)

                if not v662 then
                    if Backpack then
                        local GetChildren = Backpack.GetChildren

                        for __, v in ipairs(GetChildren(Backpack)) do
                            if v:IsA("Tool") and v.Name:lower():find("bat") then
                                return v
                            end
                        end
                    end

                    return nil
                end
            until v663:IsA("Tool") and v663.Name:lower():find("bat")

            return v663
        end

        function t14.value19(p119, p120)
            local Humanoid = p120:FindFirstChildOfClass("Humanoid")

            if p120 ~= p119.Parent then
                if Humanoid then
                    pcall(function()
                        Humanoid:EquipTool(p119)
                    end)
                end

                task.wait(0.05)
            end

            local v670 = p119:FindFirstChildOfClass("RemoteEvent") or p119:FindFirstChildOfClass("RemoteFunction")

            if v670 and v670:IsA("RemoteEvent") then
                pcall(function()
                    v670:FireServer()
                end)
                task.wait(0.15)
                pcall(function()
                    v670:FireServer()
                end)

                return
            end

            pcall(function()
                p119:Activate()
            end)
            task.wait(0.15)
            pcall(function()
                p119:Activate()
            end)
        end
        function t14.value20()
            if t1.value17.batCounter then
                return
            end

            t1.value17.batCounter = RunService.Heartbeat:Connect(function()
                if not t1.value6.batCounterEnabled then
                    return
                end

                if t1.value6.batCounterDebounce then
                    return
                end

                local Character = LocalPlayer.Character

                if not Character then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not Humanoid then
                    return
                end

                local State = Humanoid:GetState()

                if State == Enum.HumanoidStateType.Physics or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown) then
                    t1.value6.batCounterDebounce = true
                    task.spawn(function()
                        local v1009 = v470()

                        if v1009 then
                            t14.value19(v1009, Character)
                        end

                        task.wait(0.5)
                        t1.value6.batCounterDebounce = false
                    end)
                end
            end)
        end

        local function v471()
            local Character = LocalPlayer.Character

            if not Character then
                return nil
            end

            local GetChildren = Character.GetChildren

            for __, v in ipairs(GetChildren(Character)) do
                if not v:IsA("Tool") then
                    continue
                end

                local v675 = v.Name:lower()

                if v675:find("medusa") or (v675:find("head") or v675:find("stone")) then
                    return v
                end
            end

            local Backpack = LocalPlayer:FindFirstChild("Backpack")

            if Backpack then
                for __, child in ipairs(Backpack:GetChildren()) do
                    if not child:IsA("Tool") then
                        continue
                    end

                    local v679 = child.Name:lower()

                    if v679:find("medusa") or (v679:find("head") or v679:find("stone")) then
                        return child
                    end
                end
            end

            return nil
        end
        local function v472()
            if t1.value6.medusaDebounce then
                return
            end

            if tick() - t1.value6.medusaLastUsed < t14.value10 then
                return
            end

            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            t1.value6.medusaDebounce = true

            local v681 = v471()

            if not v681 then
                t1.value6.medusaDebounce = false

                return
            end

            if Character ~= v681.Parent then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:EquipTool(v681)
                end
            end

            pcall(function()
                v681:Activate()
            end)
            t1.value6.medusaLastUsed = tick()
            t1.value6.medusaDebounce = false
        end
        local function v473(p121)
            return p121:GetPropertyChangedSignal("Anchored"):Connect(function()
                if p121.Anchored and p121.Transparency == 1 then
                    v472()
                end
            end)
        end
        local function v474(p122)

            for v687, v688 in pairs(t1.value17.anchor) do

                local v689 = v688

                pcall(function()
                    v689:Disconnect()
                end)
            end
            t1.value17.anchor = {}
            if not p122 then
                return
            end
            for __, descendant in ipairs(p122:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    table.insert(t1.value17.anchor, v473(descendant))
                end
            end
            table.insert(t1.value17.anchor, p122.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BasePart") then
                    table.insert(t1.value17.anchor, v473(descendant))
                end
            end))
        end

        function t14.value21()
            if t1.value17.autoLeft then
                t1.value17.autoLeft:Disconnect()
            end

            t1.value6.autoLeftPhase = 1
            t1.value17.autoLeft = RunService.Heartbeat:Connect(function()
                if not t1.value6.autoLeftEnabled then
                    return
                end

                local Character = LocalPlayer.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not HumanoidRootPart or not Humanoid then
                    return
                end

                local value2 = t1.value2

                if t1.value6.autoLeftPhase == 1 then
                    if (Vector3.new(t1.value14.L1.X, HumanoidRootPart.Position.Y, t1.value14.L1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        t1.value6.autoLeftPhase = 2

                        local v911 = t1.value14.L2 - HumanoidRootPart.Position
                        local Unit = Vector3.new(v911.X, 0, v911.Z).Unit

                        Humanoid:Move(Unit, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                        return
                    end

                    local L1 = t1.value14.L1
                    local HumanoidRootPartPosition = HumanoidRootPart.Position
                    local _Vector3 = Vector3
                    local v916 = L1 - HumanoidRootPartPosition
                    local Unit = _Vector3.new(v916.X, 0, v916.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                    return
                end

                if t1.value6.autoLeftPhase == 2 then
                    if (Vector3.new(t1.value14.L2.X, HumanoidRootPart.Position.Y, t1.value14.L2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        Humanoid:Move(Vector3.zero, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        t1.value6.autoLeftEnabled = false

                        if t1.value17.autoLeft then
                            t1.value17.autoLeft:Disconnect()
                            t1.value17.autoLeft = nil
                        end

                        t1.value6.autoLeftPhase = 1

                        if t1.value24 then
                            t1.value24(false)
                        end

                        pcall(function()
                            local Character3 = LocalPlayer.Character

                            if not Character3 then
                                return
                            end

                            local HumanoidRootPart2 = Character3:FindFirstChild("HumanoidRootPart")

                            if HumanoidRootPart2 then
                                HumanoidRootPart2.CFrame = CFrame.new(HumanoidRootPart2.Position) * CFrame.Angles(0, 0, 0)
                            end
                        end)

                        return
                    end

                    local L2 = t1.value14.L2
                    local HumanoidRootPartPosition = HumanoidRootPart.Position
                    local _Vector3 = Vector3
                    local v921 = L2 - HumanoidRootPartPosition
                    local Unit = _Vector3.new(v921.X, 0, v921.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)
                end
            end)
        end

        local function v475()
            if t1.value17.autoLeft then
                t1.value17.autoLeft:Disconnect()
                t1.value17.autoLeft = nil
            end

            t1.value6.autoLeftPhase = 1

            local Character = LocalPlayer.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end
        end

        function t14.value22()
            if t1.value17.autoRight then
                t1.value17.autoRight:Disconnect()
            end

            t1.value6.autoRightPhase = 1
            t1.value17.autoRight = RunService.Heartbeat:Connect(function()
                if not t1.value6.autoRightEnabled then
                    return
                end

                local Character = LocalPlayer.Character

                if not Character then
                    return
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local v925 = not HumanoidRootPart
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not v925 then
                    v925 = not Humanoid
                end

                if v925 then
                    return
                end

                local value2 = t1.value2

                if t1.value6.autoRightPhase == 1 then
                    if (Vector3.new(t1.value14.R1.X, HumanoidRootPart.Position.Y, t1.value14.R1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        t1.value6.autoRightPhase = 2

                        local v928 = t1.value14.R2 - HumanoidRootPart.Position
                        local Unit = Vector3.new(v928.X, 0, v928.Z).Unit

                        Humanoid:Move(Unit, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                        return
                    end

                    local v930 = t1.value14.R1 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v930.X, 0, v930.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)

                    return
                end

                if t1.value6.autoRightPhase == 2 then
                    if (Vector3.new(t1.value14.R2.X, HumanoidRootPart.Position.Y, t1.value14.R2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
                        Humanoid:Move(Vector3.zero, false)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        t1.value6.autoRightEnabled = false

                        if t1.value17.autoRight then
                            t1.value17.autoRight:Disconnect()
                            t1.value17.autoRight = nil
                        end

                        t1.value6.autoRightPhase = 1

                        if t1.value25 then
                            t1.value25(false)
                        end

                        pcall(function()
                            local Character4 = LocalPlayer.Character

                            if not Character4 then
                                return
                            end

                            local HumanoidRootPart3 = Character4:FindFirstChild("HumanoidRootPart")

                            if HumanoidRootPart3 then
                                HumanoidRootPart3.CFrame = CFrame.new(HumanoidRootPart3.Position) * CFrame.Angles(0, 3.141592653589793, 0)
                            end
                        end)

                        return
                    end

                    local v932 = t1.value14.R2 - HumanoidRootPart.Position
                    local Unit = Vector3.new(v932.X, 0, v932.Z).Unit

                    Humanoid:Move(Unit, false)
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * value2, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * value2)
                end
            end)
        end

        local function v476()
            if t1.value17.autoRight then
                t1.value17.autoRight:Disconnect()
                t1.value17.autoRight = nil
            end

            t1.value6.autoRightPhase = 1

            local Character = LocalPlayer.Character

            if Character then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end
        end

        function t1.value29()
            if t1.value17.antiRag then
                return
            end

            t1.value17.antiRag = RunService.Heartbeat:Connect(function()
                if not t1.value6.antiRagdollEnabled then
                    return
                end

                local Character = LocalPlayer.Character

                if not Character then
                    return
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if not Humanoid or not HumanoidRootPart then
                    return
                end

                if Humanoid.Health <= 0 then
                    return
                end

                local State = Humanoid:GetState()

                if State == Enum.HumanoidStateType.Dead then
                    return
                end

                if State == Enum.HumanoidStateType.Physics or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown) then
                    pcall(function()
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end)
                    pcall(function()
                        workspace.CurrentCamera.CameraSubject = Humanoid
                    end)
                    pcall(function()
                        local PlayerModule = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")

                        if PlayerModule then
                            local ControlModule = require(PlayerModule:FindFirstChild("ControlModule"))

                            if ControlModule then
                                ControlModule:Enable()
                            end
                        end
                    end)
                    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                end

                for __, descendant in ipairs(Character:GetDescendants()) do
                    local v940 = descendant

                    pcall(function()
                        if v940:IsA("Motor6D") and v940.Enabled == false then
                            v940.Enabled = true
                        end
                    end)
                end
            end)
        end
        function t1.value30()
            if t1.value17.antiRag then
                t1.value17.antiRag:Disconnect()
                t1.value17.antiRag = nil
            end
        end

        local function v477()
            pcall(function()
                setfpscap(999999999)
            end)

            local function v699(p123)
                pcall(function()
                    if p123:IsA("Model") then
                        p123.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
                        p123.ModelStreamingMode = Enum.ModelStreamingMode.Nonatomic

                        return
                    end

                    if p123:IsA("MeshPart") then
                        p123.CastShadow = false
                        p123.DoubleSided = false
                        p123.RenderFidelity = Enum.RenderFidelity.Performance

                        return
                    end

                    if p123:IsA("BasePart") then
                        p123.CastShadow = false
                        p123.Material = Enum.Material.Plastic
                        p123.Reflectance = 0

                        return
                    end

                    if p123:IsA("Decal") or p123:IsA("Texture") then
                        p123.Transparency = 1

                        return
                    end

                    if p123:IsA("SpecialMesh") then
                        p123.TextureId = ""

                        return
                    end

                    local v1016 = p123:IsA("Fire")

                    if not v1016 then
                        v1016 = p123:IsA("SpotLight")

                        if not v1016 then
                            v1016 = p123:IsA("Smoke")

                            if not v1016 then
                                v1016 = p123:IsA("Sparkles")

                                if not v1016 then
                                    v1016 = p123:IsA("ParticleEmitter") or (p123:IsA("Trail") or p123:IsA("Beam"))
                                end
                            end
                        end
                    end

                    if v1016 then
                        p123.Enabled = false

                        return
                    end

                    if p123:IsA("SurfaceAppearance") or p123:IsA("MaterialVariant") then
                        p123:Destroy()

                        return
                    end

                    if p123:IsA("Attachment") then
                        p123.Visible = false
                    end
                end)
            end

            for __, descendant in pairs(workspace:GetDescendants()) do
                v699(descendant)
            end

            pcall(function()
                local Lighting = game:GetService("Lighting")

                for __, descendant in pairs(Lighting:GetDescendants()) do
                    pcall(function()
                        local v1017 = descendant:IsA("Sky")

                        if not v1017 then
                            v1017 = descendant:IsA("Atmosphere")

                            if not v1017 then
                                v1017 = descendant:IsA("BloomEffect")

                                if not v1017 then
                                    v1017 = descendant:IsA("BlurEffect")

                                    if not v1017 then
                                        v1017 = descendant:IsA("SunRaysEffect")

                                        if not v1017 then
                                            v1017 = descendant:IsA("DepthOfFieldEffect")

                                            if not v1017 then
                                                v1017 = descendant:IsA("Clouds") or (descendant:IsA("PostEffect") or descendant:IsA("ColorCorrectionEffect"))
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if v1017 then
                            descendant:Destroy()
                        end
                    end)
                end

                pcall(function()
                    sethiddenproperty(Lighting, "Technology", Enum.Technology.Legacy)
                end)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9000000000
                Lighting.Brightness = 0

                local Terrain = workspace:FindFirstChildOfClass("Terrain")

                if Terrain then
                    pcall(function()
                        sethiddenproperty(Terrain, "Decoration", false)
                    end)
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 0.7
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                end
            end)
            workspace.DescendantAdded:Connect(function(descendant)
                if t1.value6.fpsBoostEnabled then
                    task.spawn(v699, descendant)
                end
            end)
        end

        t14.value5 = t1.value38

        function t1.value35(p124)
            local value2 = t1.value2
            local value3 = t1.value3
            local value1 = t1.value1
            local value4 = t1.value4
            local StealRadius = t1.value16.StealRadius
            local value65 = t1.value65
            local value8 = t1.value8
            local AutoLeft = t1.value13.AutoLeft
            local v711 = AutoLeft.kb and AutoLeft.kb.Name or nil
            local v712 = AutoLeft.gp and AutoLeft.gp.Name or nil
            local t15 = {
				kb = v711,
				gp = v712
			}
            local AutoRight = t1.value13.AutoRight
            local v715 = AutoRight.kb and AutoRight.kb.Name or nil
            local v716 = AutoRight.gp and AutoRight.gp.Name or nil
            local t16 = {
				kb = v715,
				gp = v716
			}
            local Drop = t1.value13.Drop
            local v719 = Drop.kb and Drop.kb.Name or nil
            local v720 = Drop.gp and Drop.gp.Name or nil
            local t17 = {
				kb = v719,
				gp = v720
			}
            local TPDown = t1.value13.TPDown
            local v723 = TPDown.kb and TPDown.kb.Name or nil
            local v724 = TPDown.gp and TPDown.gp.Name or nil
            local t18 = {
				kb = v723,
				gp = v724
			}
            local AutoBat = t1.value13.AutoBat
            local v727 = AutoBat.kb and AutoBat.kb.Name or nil
            local v728 = AutoBat.gp and AutoBat.gp.Name or nil
            local t19 = {
				kb = v727,
				gp = v728
			}
            local value13Speed = t1.value13.Speed
            local v731 = value13Speed.kb and value13Speed.kb.Name or nil
            local v732 = value13Speed.gp and value13Speed.gp.Name or nil
            local t20 = {
				kb = v731,
				gp = v732
			}
            local Lagger = t1.value13.Lagger
            local v735 = Lagger.kb and Lagger.kb.Name or nil
            local v736 = Lagger.gp and Lagger.gp.Name or nil
            local t21 = {
				kb = v735,
				gp = v736
			}
            local GuiHide = t1.value13.GuiHide
            local v739 = GuiHide.kb and GuiHide.kb.Name or nil
            local v740 = GuiHide.gp and GuiHide.gp.Name or nil
            local t22 = {
				kb = v739,
				gp = v740
			}
            local infJumpEnabled = t1.value6.infJumpEnabled
            local antiRagdollEnabled = t1.value6.antiRagdollEnabled
            local fpsBoostEnabled = t1.value6.fpsBoostEnabled
            local medusaCounterEnabled = t1.value6.medusaCounterEnabled
            local batCounterEnabled = t1.value6.batCounterEnabled
            local AutoStealEnabled = t1.value16.AutoStealEnabled
            local unwalkEnabled = t1.value6.unwalkEnabled
            local desyncEnabled = t1.value6.desyncEnabled
            local autoSwingEnabled = t1.value6.autoSwingEnabled
            local autoBatToggled = t1.value6.autoBatToggled
            local stretchRezEnabled = t1.value6.stretchRezEnabled
            local removeAccessoriesEnabled = t1.value6.removeAccessoriesEnabled
            local antiLagEnabled = t1.value6.antiLagEnabled
            local darkModeEnabled = t1.value6.darkModeEnabled
            local introEnabled = t1.value6.introEnabled
            local selectedIntroMusic = t1.value6.selectedIntroMusic
            local value44 = t1.value44
            local value46 = t1.value46
            local value146 = t1.value146
            local v761

            if not value146 then
                v761 = nil
            else
                local value146Position = value146.Position
                local XScale = value146Position.X.Scale
                local XOffset = value146Position.X.Offset
                local YScale = value146Position.Y.Scale
                local YOffset = value146Position.Y.Offset

                v761 = {
					xs = XScale,
					xo = XOffset,
					ys = YScale,
					yo = YOffset
				}
            end

            local value66 = t1.value66
            local v768

            if not value66 then
                v768 = nil
            else
                local value66Position = value66.Position
                local XScale = value66Position.X.Scale
                local XOffset = value66Position.X.Offset
                local YScale = value66Position.Y.Scale
                local YOffset = value66Position.Y.Offset

                v768 = {
					xs = XScale,
					xo = XOffset,
					ys = YScale,
					yo = YOffset
				}
            end

            local value69 = t1.value69
            local v775

            if not value69 then
                v775 = nil
            else
                local value69Position = value69.Position
                local XScale = value69Position.X.Scale
                local XOffset = value69Position.X.Offset
                local YScale = value69Position.Y.Scale
                local YOffset = value69Position.Y.Offset

                v775 = {
					xs = XScale,
					xo = XOffset,
					ys = YScale,
					yo = YOffset
				}
            end

            local value88 = t1.value88
            local v782

            if not value88 then
                v782 = nil
            else
                local value88Position = value88.Position
                local XScale = value88Position.X.Scale
                local XOffset = value88Position.X.Offset
                local YScale = value88Position.Y.Scale
                local YOffset = value88Position.Y.Offset

                v782 = {
					xs = XScale,
					xo = XOffset,
					ys = YScale,
					yo = YOffset
				}
            end

            local t23 = {
				normalSpeed = value2,
				carrySpeed = value3,
				laggerSpeed = value1,
				laggerCarrySpeed = value4,
				stealRadius = StealRadius,
				uiScale = value65,
				uiLocked = value8,
				autoLeftKey = t15,
				autoRightKey = t16,
				dropKey = t17,
				tpDownKey = t18,
				autoBatKey = t19,
				speedKey = t20,
				laggerKey = t21,
				guiHideKey = t22,
				infJump = infJumpEnabled,
				antiRagdoll = antiRagdollEnabled,
				fpsBoost = fpsBoostEnabled,
				medusaCounter = medusaCounterEnabled,
				batCounter = batCounterEnabled,
				autoStealEnabled = AutoStealEnabled,
				unwalkEnabled = unwalkEnabled,
				desyncEnabled = desyncEnabled,
				autoSwing = autoSwingEnabled,
				autoBatToggled = autoBatToggled,
				stretchRez = stretchRezEnabled,
				removeAccessories = removeAccessoriesEnabled,
				antiLag = antiLagEnabled,
				darkMode = darkModeEnabled,
				introEnabled = introEnabled,
				selectedIntroMusic = selectedIntroMusic,
				autoTPDown = value44,
				autoTPDownHeight = value46,
				panelPos = v761,
				mainPos = v768,
				miniPos = v775,
				pbPos = v782
			}
            local ok, result = pcall(function()
                return HttpService:JSONEncode(t23)
            end)

            if ok and result then
                local _writefile3 = writefile

                if not _writefile3 then
                    _writefile3 = syn and syn.writefile or (getgenv and getgenv().writefile or t14.value3)
                end

                if _writefile3 then
                    pcall(_writefile3, t14.value12, result)
                end
            end

            if p124 then
                local p124Text = p124.Text

                p124.Text = "Saved!"
                task.wait(1.5)

                if p124 and p124.Parent then
                    p124.Text = p124Text
                end
            end
        end
        function t14.value23()
            if t14.value5 then
                t14.value5.Text = "0%"
            end

            if t1.value37 then
                t1.value37.Size = UDim2.new(0, 0, 1, 0)
            end
        end
        function t1.value32()
            if t1.value17.autoSteal then
                t1.value17.autoSteal:Disconnect()
                t1.value17.autoSteal = nil
            end

            t1.value6.isStealing = false
            t1.value6.lastStealTick = 0
            t1.value16.plotCache = {}
            t1.value16.plotCacheTime = {}
            t1.value16.cachedPrompts = {}
            t14.value23()
        end
        function t14.value24(p125)
            local timestamp = tick()

            if t1.value16.plotCache[p125] and timestamp - (t1.value16.plotCacheTime[p125] or 0) < t14.value7 then
                return t1.value16.plotCache[p125]
            end

            local Plots = workspace:FindFirstChild("Plots")

            if not Plots then
                t1.value16.plotCache[p125] = false
                t1.value16.plotCacheTime[p125] = timestamp

                return false
            end

            local p125_2 = Plots:FindFirstChild(p125)

            if not p125_2 then
                t1.value16.plotCache[p125] = false
                t1.value16.plotCacheTime[p125] = timestamp

                return false
            end

            local PlotSign = p125_2:FindFirstChild("PlotSign")

            if PlotSign then
                local YourBase = PlotSign:FindFirstChild("YourBase")

                if YourBase and YourBase:IsA("BillboardGui") then
                    local v637 = YourBase.Enabled == true

                    t1.value16.plotCache[p125] = v637
                    t1.value16.plotCacheTime[p125] = timestamp

                    return v637
                end
            end

            t1.value16.plotCache[p125] = false
            t1.value16.plotCacheTime[p125] = timestamp

            return false
        end
        function t14.value25()
            local Character = LocalPlayer.Character
            if not Character then
                return nil
            end
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if not HumanoidRootPart then
                return nil
            end
            local timestamp = tick()
            if timestamp - t1.value16.promptCacheTime < t14.value8 and #t1.value16.cachedPrompts > 0 then
                local prompt
                local n5 = 1e999
                for __, v in ipairs(t1.value16.cachedPrompts) do
                    if v.spawn then
                        local Magnitude = (v.spawn.Position - HumanoidRootPart.Position).Magnitude

                        if Magnitude <= t1.value16.StealRadius and Magnitude < n5 then
                            prompt = v.prompt
                            n5 = Magnitude
                        end
                    end
                end
                if prompt then
                    return prompt
                end
            end
            t1.value16.cachedPrompts = {}
            t1.value16.promptCacheTime = timestamp
            local Plots = workspace:FindFirstChild("Plots")
            if not Plots then
                return nil
            end
            local u802
            local n6 = 1e999
            local GetChildren = Plots.GetChildren
            for __, v in ipairs(GetChildren(Plots)) do
                if not t14.value24(v.Name) then
                    local AnimalPodiums = v:FindFirstChild("AnimalPodiums")

                    if AnimalPodiums then
                        for __, child in ipairs(AnimalPodiums:GetChildren()) do
                            local v810 = child

                            pcall(function()
                                local Base = v810:FindFirstChild("Base")
                                local v957 = Base and Base:FindFirstChild("Spawn")

                                if v957 then
                                    local PromptAttachment = v957:FindFirstChild("PromptAttachment")

                                    if PromptAttachment then
                                        local GetChildren2 = PromptAttachment.GetChildren

                                        for __, v4 in ipairs(GetChildren2(PromptAttachment)) do
                                            if v4:IsA("ProximityPrompt") then
                                                local Magnitude = (v957.Position - HumanoidRootPart.Position).Magnitude

                                                table.insert(t1.value16.cachedPrompts, {
													prompt = v4,
													spawn = v957
												})

                                                if not (Magnitude <= t1.value16.StealRadius and Magnitude < n6) then
                                                    return
                                                end

                                                u802 = v4
                                                n6 = Magnitude

                                                return
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end

            return u802
        end
        function t14.value26(p126)
            local timestamp = tick()

            if timestamp - t1.value6.lastStealTick < t14.value9 then
                return
            end

            if t1.value6.isStealing then
                return
            end

            if not t1.value16.Data[p126] then
                t1.value16.Data[p126] = {
					hold = {},
					trigger = {},
					ready = true
				}
                pcall(function()
                    if t14.value4 then

                        for v965, v966 in ipairs(t14.value4(p126.PromptButtonHoldBegan)) do

                            if v966.Function then
                                table.insert(t1.value16.Data[p126].hold, v966.Function)
                            end
                        end
                        for __, v in ipairs(t14.value4(p126.Triggered)) do
                            if v.Function then
                                table.insert(t1.value16.Data[p126].trigger, v.Function)
                            end
                        end

                        return
                    end

                    t1.value16.Data[p126].useFallback = true
                end)
            end

            local v813 = t1.value16.Data[p126]

            if not v813.ready then
                return
            end

            v813.ready = false
            t1.value6.isStealing = true
            t1.value6.stealStartTime = timestamp
            t1.value6.lastStealTick = timestamp

            if t1.value17.progress then
                t1.value17.progress:Disconnect()
            end

            t1.value17.progress = RunService.Heartbeat:Connect(function()
                if not t1.value6.isStealing then
                    t1.value17.progress:Disconnect()

                    return
                end

                local v969 = math.clamp((tick() - t1.value6.stealStartTime) / t1.value16.StealDuration, 0, 1)

                if t1.value37 then
                    t1.value37.Size = UDim2.new(v969, 0, 1, 0)
                end

                if t14.value5 then
                    t14.value5.Text = math.floor(v969 * 100) .. "%"
                end
            end)
            task.spawn(function()
                local u970 = false
                pcall(function()
                    if not v813.useFallback then
                        for __, v in ipairs(v813.hold) do
                            task.spawn(v)
                        end

                        task.wait(t1.value16.StealDuration)

                        for __, v in ipairs(v813.trigger) do
                            task.spawn(v)
                        end

                        u970 = true
                    end
                end)
                if not u970 and fireproximityprompt then
                    pcall(function()
                        fireproximityprompt(p126)
                        u970 = true
                    end)
                end
                if not u970 then
                    pcall(function()
                        p126:InputHoldBegin()
                        task.wait(t1.value16.StealDuration)
                        p126:InputHoldEnd()
                    end)
                end
                task.wait(t1.value16.StealDuration * 0.3)
                if t1.value17.progress then
                    t1.value17.progress:Disconnect()
                end
                t14.value23()
                task.wait(0.05)
                v813.ready = true
                t1.value6.isStealing = false
            end)
        end
        function t1.value31()
            if t1.value17.autoSteal then
                return
            end

            t1.value17.autoSteal = RunService.Heartbeat:Connect(function()
                if not t1.value16.AutoStealEnabled or t1.value6.isStealing then
                    return
                end

                local v971 = t14.value25()

                if v971 then
                    t14.value26(v971)
                end
            end)
        end
        function t1.value36()
            local _isfile2 = isfile
            if not _isfile2 then
                _isfile2 = syn and syn.isfile or (getgenv and getgenv().isfile or t14.value1)
            end
            local v815 = _isfile2
            local _readfile2 = readfile
            if not _readfile2 then
                _readfile2 = syn and syn.readfile or (getgenv and getgenv().readfile or t14.value2)
            end
            local v817 = _readfile2
            local u818 = false
            pcall(function()
                u818 = v815(t14.value12)
            end)
            if not u818 then
                return
            end
            local u819
            pcall(function()
                u819 = v817(t14.value12)
            end)
            if not u819 then
                return
            end
            local data
            pcall(function()
                data = HttpService:JSONDecode(u819)
            end)
            if not data then
                return
            end
            if data.normalSpeed then
                t1.value2 = data.normalSpeed
                task.defer(function()
                    if t1.value89 then
                        t1.value89.Text = tostring(t1.value2)
                    end
                end)
            end
            if data.carrySpeed then
                t1.value3 = data.carrySpeed
                task.defer(function()
                    if t1.value90 then
                        t1.value90.Text = tostring(t1.value3)
                    end
                end)
            end
            if data.laggerSpeed then
                t1.value1 = data.laggerSpeed
                task.defer(function()
                    if t1.value91 then
                        t1.value91.Text = tostring(t1.value1)
                    end
                end)
            end
            if data.laggerCarrySpeed then
                t1.value4 = data.laggerCarrySpeed
                task.defer(function()
                    if t1.value92 then
                        t1.value92.Text = tostring(t1.value4)
                    end
                end)
            end
            if data.uiScale and type(data.uiScale) == "number" then
                t1.value65 = math.clamp(math.floor(data.uiScale + 0.5), 50, 150)

                if t1.value67 then
                    t1.value67.Scale = t1.value65 / 100
                end

                task.defer(function()
                    if t1.value139 then
                        t1.value139.Text = tostring(t1.value65)
                    end
                end)
            end
            if data.uiLocked then
                task.defer(function()
                    if v97 then
                        v97(true)
                    end
                end)
            end
            if data.selectedIntroMusic then
                t1.value6.selectedIntroMusic = data.selectedIntroMusic
                task.defer(function()
                    if getgenv().EnvyMusicBtn then
                        getgenv().EnvyMusicBtn.Text = "Music " .. t1.value6.selectedIntroMusic
                    end
                end)
            end
            if data.introEnabled ~= nil then
                t1.value6.introEnabled = data.introEnabled

                if t1.value133 then
                    task.defer(function()
                        t1.value133(data.introEnabled)
                    end)
                end
            end
            if data.autoTPDown then
                task.defer(function()
                    if setAutoTPDownVisual then
                        setAutoTPDownVisual(true)
                    end

                    t1.value52()
                end)
            end
            if data.autoTPDownHeight and type(data.autoTPDownHeight) == "number" then
                t1.value46 = math.clamp(data.autoTPDownHeight, 0, 500)
                task.defer(function()
                    for __, v in pairs(t1.value71) do
                        for __, child in ipairs(v:GetChildren()) do
                            if child:IsA("Frame") then
                                for __, child2 in ipairs(child:GetChildren()) do
                                    if child2:IsA("TextBox") and child2.Parent.Name ~= "flowHubDuelsGUI" then
                                        for __, child3 in ipairs(child:GetChildren()) do
                                            if child3:IsA("TextLabel") and child3.Text == "TP Down Height" then
                                                child2.Text = tostring(t1.value46)

                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            if data.stealRadius or data.grabRadius then
                t1.value16.StealRadius = data.stealRadius or data.grabRadius
                task.defer(function()
                    if t1.value39 then
                        t1.value39.Text = "Radius: " .. t1.value16.StealRadius
                    end
                end)
            end
            local function v821(p127, p128)
                if not p128 then
                    return
                end

                if p128.kb and Enum.KeyCode[p128.kb] then
                    p127.kb = Enum.KeyCode[p128.kb]
                end

                if p128.gp and Enum.KeyCode[p128.gp] then
                    p127.gp = Enum.KeyCode[p128.gp]
                end
            end
            v821(t1.value13.AutoLeft, data.autoLeftKey)
            v821(t1.value13.AutoRight, data.autoRightKey)
            v821(t1.value13.Drop, data.dropKey)
            v821(t1.value13.TPDown, data.tpDownKey)
            v821(t1.value13.AutoBat, data.autoBatKey)
            v821(t1.value13.Speed, data.speedKey)
            v821(t1.value13.Lagger, data.laggerKey)
            v821(t1.value13.GuiHide, data.guiHideKey)
            if data.infJump then
                t1.value6.infJumpEnabled = true

                if t1.value99 then
                    t1.value99(true)
                end
            end
            if data.antiRagdoll then
                t1.value6.antiRagdollEnabled = true

                if t1.value100 then
                    t1.value100(true)
                end

                t1.value29()
            end
            if data.fpsBoost then
                t1.value6.fpsBoostEnabled = true

                if t1.value23 then
                    t1.value23(true)
                end

                pcall(v477)
            end
            if data.medusaCounter then
                t1.value6.medusaCounterEnabled = true

                if t1.value102 then
                    t1.value102(true)
                end

                v474(LocalPlayer.Character)
            end
            if data.batCounter then
                t1.value6.batCounterEnabled = true

                if t1.value103 then
                    t1.value103(true)
                end

                t14.value20()
            end
            if data.autoStealEnabled then
                t1.value16.AutoStealEnabled = true

                if t1.value22 then
                    t1.value22(true)
                end

                pcall(t1.value31)
            end
            if data.autoSwing then
                t1.value6.autoSwingEnabled = true

                if t14.value16 then
                    t14.value16(true)
                end
            end
            if data.unwalkEnabled then
                t1.value6.unwalkEnabled = true

                if t1.value101 then
                    t1.value101(true)
                end

                t1.value82()
            end
            if data.stretchRez then
                t1.value6.stretchRezEnabled = true

                if t1.value124 then
                    t1.value124(true)
                end
            end
            if data.removeAccessories then
                t1.value6.removeAccessoriesEnabled = true

                if t1.value127 then
                    t1.value127(true)
                end
            end
            if data.antiLag then
                t1.value6.antiLagEnabled = true

                if t1.value121 then
                    t1.value121(true)
                end
            end
            if data.darkMode then
                t1.value6.darkModeEnabled = true

                if t1.value130 then
                    t1.value130(true)
                end
            end
            if data.desyncEnabled then
                t1.value6.desyncEnabled = true
                task.defer(function()
                    if t1.value104 then
                        t1.value104(true)
                    end

                    if t1.value26 then
                        t1.value26(true)
                    end

                    t1.value27()
                end)
            end
            if data.autoBatToggled then
                t1.value6.autoBatToggled = true
                task.defer(function()
                    if t1.value94 then
                        t1.value94(true)
                    end

                    pcall(t1.value20)
                end)
            end
            task.spawn(function()
                task.wait(0.5)

                local value66 = t1.value66
                local mainPos = data.mainPos
                local v984 = value66

                if value66 then
                    v984 = type(mainPos) == "table" and mainPos.xs ~= nil
                end

                if v984 then
                    value66.Position = UDim2.new(mainPos.xs, mainPos.xo, mainPos.ys, mainPos.yo)
                end

                local value69 = t1.value69
                local miniPos = data.miniPos
                local v987 = value69

                if value69 then
                    v987 = type(miniPos) == "table" and miniPos.xs ~= nil
                end

                if v987 then
                    value69.Position = UDim2.new(miniPos.xs, miniPos.xo, miniPos.ys, miniPos.yo)
                end

                local value146 = t1.value146
                local panelPos = data.panelPos
                local v990 = value146

                if value146 then
                    v990 = type(panelPos) == "table" and panelPos.xs ~= nil
                end

                if v990 then
                    value146.Position = UDim2.new(panelPos.xs, panelPos.xo, panelPos.ys, panelPos.yo)
                end

                local value88 = t1.value88
                local pbPos = data.pbPos
                local v993 = value88

                if value88 then
                    v993 = type(pbPos) == "table" and pbPos.xs ~= nil
                end

                if v993 then
                    value88.Position = UDim2.new(pbPos.xs, pbPos.xo, pbPos.ys, pbPos.yo)
                end
            end)
        end

        for __, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                v469(player)
            end
        end

        Players.PlayerAdded:Connect(v469)
        t14.value27 = nil
        t14.value28 = nil
        t14.value29 = nil

        function t14.value30(p129)
            task.wait(0.1)
            t14.value27 = p129:WaitForChild("Humanoid", 5)
            t14.value28 = p129:WaitForChild("HumanoidRootPart", 5)

            if not t14.value27 or not t14.value28 then
                return
            end

            local Head = p129:FindFirstChild("Head")

            if Head then
                local EnvyMobileBB = Head:FindFirstChild("EnvyMobileBB")

                if EnvyMobileBB then
                    EnvyMobileBB:Destroy()
                end

                local BillboardGui = Instance.new("BillboardGui", Head)

                BillboardGui.Name = "EnvyMobileBB"
                BillboardGui.Size = UDim2.new(0, 160, 0, 52)
                BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                BillboardGui.AlwaysOnTop = true
                t14.value29 = Instance.new("TextLabel", BillboardGui)
                t14.value29.Name = "SpeedBillLbl"
                t14.value29.Size = UDim2.new(1, 0, 0, 24)
                t14.value29.Position = UDim2.new(0, 0, 0, 0)
                t14.value29.BackgroundTransparency = 1
                t14.value29.Text = "0.0"
                t14.value29.TextColor3 = Color3.fromRGB(255, 255, 255)
                t14.value29.Font = Enum.Font.GothamBlack
                t14.value29.TextScaled = true
                t14.value29.TextStrokeTransparency = 0
                t14.value29.TextStrokeColor3 = Color3.new(0, 0, 0)

                local TextLabel9 = Instance.new("TextLabel", BillboardGui)

                TextLabel9.Size = UDim2.new(1, 0, 0, 28)
                TextLabel9.Position = UDim2.new(0, 0, 0, 26)
                TextLabel9.BackgroundTransparency = 1
                TextLabel9.Text = "by flowwk7"
                TextLabel9.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel9.Font = Enum.Font.GothamBold
                TextLabel9.TextScaled = true
                TextLabel9.TextStrokeTransparency = 0.1
                TextLabel9.TextStrokeColor3 = Color3.new(0, 0, 0)
            end

            if t1.value6.unwalkEnabled then
                task.wait(0.3)
                t1.value82()
            end

            t1.value30()

            if t1.value6.antiRagdollEnabled then
                task.wait(0.5)
                t1.value29()
            end

            if t1.value6.medusaCounterEnabled then
                v474(p129)
            end

            if t1.value6.autoBatToggled then
                t1.value21()
                task.wait(0.2)
                pcall(t1.value20)
            end

            if t1.value6.batCounterEnabled then
                task.wait(0.3)
                t14.value20()
            end

            if t1.value16.AutoStealEnabled then
                pcall(t1.value32)
                task.wait(0.5)
                pcall(t1.value31)
            end
        end

        LocalPlayer.CharacterAdded:Connect(t14.value30)

        if LocalPlayer.Character then
            task.spawn(function()
                t14.value30(LocalPlayer.Character)
            end)
        end

        RunService.Stepped:Connect(function()
            for __, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for __, child in ipairs(player.Character:GetChildren()) do
                        if child:IsA("BasePart") then
                            child.CanCollide = false
                        end
                    end
                end
            end
        end)
        UserInputService.JumpRequest:Connect(function()
            if not t1.value6.infJumpEnabled then
                return
            end

            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 55, HumanoidRootPart.Velocity.Z)
            end
        end)
        RunService.RenderStepped:Connect(function()
            if not t14.value27 or not t14.value28 then
                return
            end

            if t1.value6._tpInProgress then
                return
            end

            if not t1.value6.autoBatToggled and (not t1.value6.autoLeftEnabled and not t1.value6.autoRightEnabled) then
                local MoveDirection = t14.value27.MoveDirection
                local v834 = t1.value6.laggerToggled and (t1.value5 == 2 and t1.value4) or (t1.value1 or (t1.value6.speedToggled and t1.value3 or t1.value2))

                if MoveDirection.Magnitude > 0 then
                    t1.value6.lastMoveDir = MoveDirection
                    t14.value28.Velocity = Vector3.new(MoveDirection.X * v834, t14.value28.Velocity.Y, MoveDirection.Z * v834)
                elseif t1.value6.antiRagdollEnabled and t1.value6.lastMoveDir.Magnitude > 0 then
                    local v835 = false
                    local v836, v837, v838 = pairs(t14.value6)
                    local g839
                    repeat
                        v838 = v836(v837, v838)

                        if not v838 then
                            g839 = true
                        end

                        if g839 then
                            break
                        end
                    until UserInputService:IsKeyDown(v838)
                    if not g839 then
                        v835 = true
                    end
                    if v835 then
                        t14.value28.Velocity = Vector3.new(t1.value6.lastMoveDir.X * v834, t14.value28.Velocity.Y, t1.value6.lastMoveDir.Z * v834)
                    end
                end
            end

            pcall(function()
                if t14.value29 then
                    local Magnitude = Vector3.new(t14.value28.Velocity.X, 0, t14.value28.Velocity.Z).Magnitude

                    t14.value29.Text = string.format("%.1f", Magnitude)
                end
            end)
        end)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                gameProcessed = input.UserInputType ~= Enum.UserInputType.Gamepad1
            end

            if gameProcessed then
                return
            end

            local KeyCode2 = input.KeyCode

            if KeyCode2 == Enum.KeyCode.Unknown then
                return
            end

            local value13Speed = t1.value13.Speed

            if KeyCode2 == value13Speed.kb or value13Speed.gp and KeyCode2 == value13Speed.gp then
                t1.value6.laggerToggled = false
                t1.value5 = 0
                t1.value6.speedToggled = not t1.value6.speedToggled

                if t1.value34 then
                    t1.value34(false)
                end

                if t1.value93 then
                    t1.value93.Text = not t1.value6.speedToggled and "Normal" or "Carry"

                    return
                end
            else
                local AutoLeft = t1.value13.AutoLeft

                if KeyCode2 == AutoLeft.kb or AutoLeft.gp and KeyCode2 == AutoLeft.gp then
                    t1.value6.autoLeftEnabled = not t1.value6.autoLeftEnabled

                    if t1.value6.autoLeftEnabled and t1.value6.autoBatToggled then
                        t1.value6.autoBatToggled = false
                        t1.value21()

                        if t1.value94 then
                            t1.value94(false)
                        end
                    end

                    if t1.value6.autoLeftEnabled then
                        t14.value21()
                    else
                        v475()
                    end

                    if t1.value24 then
                        t1.value24(t1.value6.autoLeftEnabled)

                        return
                    end
                else
                    local AutoRight = t1.value13.AutoRight

                    if KeyCode2 == AutoRight.kb or AutoRight.gp and KeyCode2 == AutoRight.gp then
                        t1.value6.autoRightEnabled = not t1.value6.autoRightEnabled

                        if t1.value6.autoRightEnabled and t1.value6.autoBatToggled then
                            t1.value6.autoBatToggled = false
                            t1.value21()

                            if t1.value94 then
                                t1.value94(false)
                            end
                        end

                        if t1.value6.autoRightEnabled then
                            t14.value22()
                        else
                            v476()
                        end

                        if t1.value25 then
                            t1.value25(t1.value6.autoRightEnabled)

                            return
                        end
                    else
                        local Drop = t1.value13.Drop

                        if KeyCode2 == Drop.kb or Drop.gp and KeyCode2 == Drop.gp then
                            if not t1.value6.dropActive then
                                task.spawn(t1.value50)

                                return
                            end
                        else
                            local TPDown = t1.value13.TPDown

                            if KeyCode2 == TPDown.kb or TPDown.gp and KeyCode2 == TPDown.gp then
                                task.spawn(v468)

                                return
                            end

                            local Lagger = t1.value13.Lagger

                            if KeyCode2 == Lagger.kb or Lagger.gp and KeyCode2 == Lagger.gp then
                                if t1.value5 == 1 then
                                    t1.value6.laggerToggled = true
                                    t1.value6.speedToggled = false

                                    if t1.value34 then
                                        t1.value34(true)
                                    end

                                    if t1.value93 then
                                        t1.value93.Text = "Lagger Carry"

                                        return
                                    end
                                else
                                    t1.value6.laggerToggled = true
                                    t1.value6.speedToggled = false

                                    if t1.value33 then
                                        t1.value33(false)
                                    end

                                    if t1.value34 then
                                        t1.value34(true)
                                    end

                                    if t1.value93 then
                                        t1.value93.Text = "Lagger"

                                        return
                                    end
                                end
                            else
                                local AutoBat = t1.value13.AutoBat

                                if KeyCode2 == AutoBat.kb or AutoBat.gp and KeyCode2 == AutoBat.gp then
                                    t1.value6.autoBatToggled = not t1.value6.autoBatToggled

                                    if t1.value6.autoBatToggled then
                                        if t1.value6.autoLeftEnabled then
                                            t1.value6.autoLeftEnabled = false
                                            v475()

                                            if t1.value24 then
                                                t1.value24(false)
                                            end
                                        end

                                        if t1.value6.autoRightEnabled then
                                            t1.value6.autoRightEnabled = false
                                            v476()

                                            if t1.value25 then
                                                t1.value25(false)
                                            end
                                        end

                                        pcall(t1.value20)
                                    else
                                        t1.value21()
                                    end

                                    if t1.value94 then
                                        t1.value94(t1.value6.autoBatToggled)

                                        return
                                    end
                                else
                                    local GuiHide = t1.value13.GuiHide

                                    if KeyCode2 == GuiHide.kb or GuiHide.gp and KeyCode2 == GuiHide.gp then
                                        t1.value6.guiVisible = not t1.value6.guiVisible
                                        pcall(function()
                                            t1.value66.Visible = t1.value6.guiVisible
                                        end)
                                        pcall(function()
                                            t1.value69.Visible = not t1.value6.guiVisible
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end);
        (function()
            local u641 = false
            pcall(function()
                u641 = t14.value1(t14.value14)
            end)
            if not u641 then
                return
            end
            local u642
            pcall(function()
                u642 = t14.value2(t14.value14)
            end)
            if not u642 then
                return
            end
            local ok, result = pcall(function()
                return HttpService:JSONDecode(u642)
            end)
            if ok and result then
                t14.value13 = result
            end
        end)()
        t1.value36()
        task.spawn(function()
            task.wait(0.3)

            local v851 = v467()

            if v851 and v851 ~= "" then
                for __, v in ipairs(t14.value13) do
                    if v851 == v.name then
                        pcall(function()
                            applyPreset(v.data)
                        end)

                        return
                    end
                end
            end
        end)
        task.delay(1, function()
            pcall(t1.value35)
        end)
        task.spawn(function()
            while task.wait(10) do
                pcall(t1.value35)
            end
        end)
        Players.LocalPlayer.AncestryChanged:Connect(function()
            pcall(t1.value35)
        end)
        print("[flow Hub Duels Revamped] Loaded with SAFE MODE & Neon Effects!")
    end)()
    task.spawn(function()
        if not LocalPlayer then
            return
        end

        LocalPlayer.CharacterAdded:Connect(function(__)
            task.wait(0.1)

            if t1.value6.autoBatToggled then
                t1.value6.autoBatToggled = false
                t1.value21()

                if t1.value94 then
                    t1.value94(false)
                end
            end

            if t1.value6.autoLeftEnabled then
                t1.value6.autoLeftEnabled = false

                if t1.value40 then
                    t1.value40:Disconnect()
                    t1.value40 = nil
                end

                t1.value42 = 1

                local Character = LocalPlayer.Character

                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        Humanoid:Move(Vector3.zero, false)
                    end
                end

                if t1.value24 then
                    t1.value24(false)
                end
            end

            if t1.value6.autoRightEnabled then
                t1.value6.autoRightEnabled = false
                t1.value47()

                if t1.value25 then
                    t1.value25(false)
                end
            end

            if t1.value6.speedToggled then
                t1.value6.speedToggled = false

                if t1.value33 then
                    t1.value33(false)
                end
            end

            if t1.value6.laggerToggled then
                t1.value6.laggerToggled = false

                if t1.value34 then
                    t1.value34(false)
                end

                if t1.value93 then
                    t1.value93.Text = "None"
                end
            end

            if t1.value6.antiRagdollEnabled then
                t1.value6.antiRagdollEnabled = false
                t1.value30()
            end

            print("[flow Hub Duels] 🛡\239\184\143 SAFE MODE: All features disabled on respawn!")
        end)
    end)
    task.spawn(function()
        local function v480(p131)
            if p131:FindFirstChild("__flowNeon") then
                return
            end

            local UIStroke7 = Instance.new("UIStroke", p131)

            UIStroke7.Name = "__flowNeon"
            UIStroke7.Color = Color3.fromRGB(255, 255, 255)
            UIStroke7.Thickness = 1.2
            UIStroke7.Transparency = 0.15
            UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local UIGradient2 = Instance.new("UIGradient", UIStroke7)

            UIGradient2.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 80, 80)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 80, 80)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})
            UIGradient2.Rotation = 0
            task.spawn(function()
                while UIStroke7.Parent do
                    UIGradient2.Rotation = (UIGradient2.Rotation + 4) % 360
                    task.wait(0.04)
                end
            end)
        end

        task.spawn(function()
            task.wait(0.1)

            local function u860(p132)
                for __, descendant in ipairs(p132:GetDescendants()) do
                    if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                        pcall(v480, descendant)
                    end
                end
            end

            pcall(function()
                if t1.value66 then
                    u860(t1.value66)
                end
            end)
            pcall(function()
                if t1.value69 then
                    v480(t1.value69)
                end
            end)
            pcall(function()
                if t1.value146 then
                    u860(t1.value146)
                end
            end)

            if t1.value54 then
                t1.value54.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                        task.wait(0.05)
                        pcall(v480, descendant)
                    end
                end)
            end
        end)
    end)
    task.spawn(function()
        task.wait(3)
        local success, result = pcall(function()
            local CoreGui = game:GetService("CoreGui")
            if not t1.value6 then
                return
            end
            local ScreenGui
            local Frame22
            local TextLabel10
            local u865
            if t1.value6 and t1.value6.kingNasirEnabled then
                task.wait(1)
                pcall(function()
                    if ScreenGui and ScreenGui.Parent then
                        return
                    end

                    ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.Name = "flowHubDuelsMusicPlayer"
                    ScreenGui.ResetOnSpawn = false
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.DisplayOrder = 50
                    pcall(function()
                        ScreenGui.Parent = gethui and gethui() or CoreGui
                    end)
                    Frame22 = Instance.new("Frame", ScreenGui)
                    Frame22.Size = UDim2.new(0, 230, 0, 56)
                    Frame22.Position = UDim2.new(0, 18, 1, -82)
                    Frame22.BackgroundColor3 = Color3.fromRGB(18, 4, 6)
                    Frame22.BackgroundTransparency = 0.05
                    Frame22.BorderSizePixel = 0
                    Instance.new("UICorner", Frame22).CornerRadius = UDim.new(0, 10)

                    local UIStroke8 = Instance.new("UIStroke", Frame22)

                    UIStroke8.Color = Color3.fromRGB(220, 30, 30)
                    UIStroke8.Thickness = 1.2
                    UIStroke8.Transparency = 0.2
                    TextLabel10 = Instance.new("TextLabel", Frame22)
                    TextLabel10.BackgroundTransparency = 1
                    TextLabel10.Position = UDim2.new(0, 12, 0, 6)
                    TextLabel10.Size = UDim2.new(1, -24, 0, 18)
                    TextLabel10.Font = Enum.Font.GothamBold
                    TextLabel10.TextSize = 12
                    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel10.TextColor3 = Color3.fromRGB(255, 230, 230)
                    TextLabel10.Text = "King Nasir"

                    local function v1000(p133, p134)
                        local TextButton4 = Instance.new("TextButton", Frame22)

                        TextButton4.Size = UDim2.new(0, 64, 0, 22)
                        TextButton4.Position = UDim2.new(0, p134, 1, -28)
                        TextButton4.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
                        TextButton4.BorderSizePixel = 0
                        TextButton4.Font = Enum.Font.GothamBold
                        TextButton4.TextSize = 11
                        TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
                        TextButton4.Text = p133
                        Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)

                        return TextButton4
                    end

                    u865 = v1000("Pause", 12)
                    v1000("Next", 84)
                    u865.MouseButton1Click:Connect(function()
                    end)
                end)
            end
        end)
        if not success then
            warn("[Envy Hub Music] init failed:", result)
        end
    end)

    function t1.value165()
        if not t1.value6 or not t1.value6.introEnabled then
            return
        end

        local Players2 = game:GetService("Players")
        local TweenService2 = game:GetService("TweenService")
        local PlayerGui = Players2.LocalPlayer:WaitForChild("PlayerGui")
        local CoreGui = game:GetService("CoreGui")
        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "flowHubDuelsIntroTyping"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 999
        pcall(function()
            ScreenGui.Parent = gethui and gethui() or CoreGui
        end)

        if not ScreenGui.Parent then
            ScreenGui.Parent = PlayerGui
        end

        local CurrentCamera = workspace.CurrentCamera
        local BlurEffect = Instance.new("BlurEffect")

        BlurEffect.Size = 0
        BlurEffect.Parent = CurrentCamera
        TweenService2:Create(BlurEffect, TweenInfo.new(0.6), {
			Size = 48
		}):Play()

        local Frame23 = Instance.new("Frame", ScreenGui)

        Frame23.Size = UDim2.new(1, 0, 1, 0)
        Frame23.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
        Frame23.BackgroundTransparency = 0.25
        Frame23.BorderSizePixel = 0
        Frame23.ZIndex = 1

        local ImageLabel2 = Instance.new("ImageLabel", Frame23)

        ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = "rbxassetid://6996636246"
        ImageLabel2.ImageColor3 = Color3.fromRGB(120, 0, 0)
        ImageLabel2.ImageTransparency = 0.4
        ImageLabel2.ZIndex = 2

        local Frame24 = Instance.new("Frame", ScreenGui)

        Frame24.Size = UDim2.new(0, 720, 0, 140)
        Frame24.Position = UDim2.new(0.5, -360, 0.5, -70)
        Frame24.BackgroundTransparency = 1
        Frame24.ZIndex = 5

        local TextLabel11 = Instance.new("TextLabel", Frame24)

        TextLabel11.Size = UDim2.new(1, 0, 1, 0)
        TextLabel11.BackgroundTransparency = 1
        TextLabel11.Font = Enum.Font.Code
        TextLabel11.TextSize = 78
        TextLabel11.TextColor3 = Color3.fromRGB(255, 240, 240)
        TextLabel11.TextStrokeColor3 = Color3.fromRGB(160, 0, 0)
        TextLabel11.TextStrokeTransparency = 0
        TextLabel11.Text = ""
        TextLabel11.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel11.ZIndex = 6

        local UIStroke9 = Instance.new("UIStroke", TextLabel11)

        UIStroke9.Color = Color3.fromRGB(255, 30, 30)
        UIStroke9.Thickness = 2
        UIStroke9.Transparency = 0.2

        local TextLabel12 = Instance.new("TextLabel", Frame24)

        TextLabel12.Size = UDim2.new(1, 0, 0, 22)
        TextLabel12.Position = UDim2.new(0, 0, 1, 6)
        TextLabel12.BackgroundTransparency = 1
        TextLabel12.Font = Enum.Font.Gotham
        TextLabel12.TextSize = 14
        TextLabel12.TextColor3 = Color3.fromRGB(220, 80, 80)
        TextLabel12.TextTransparency = 1
        TextLabel12.Text = "discord.gg/flowhubr -  flow hub duels edition"
        TextLabel12.ZIndex = 6
        pcall(function()
            local Sound = Instance.new("Sound", ScreenGui)

            Sound.SoundId = "rbxassetid://126107591945718"
            Sound.Volume = 0.6
            Sound.TimePosition = 34
            Sound:Play()
            task.delay(8, function()
                pcall(function()
                    TweenService2:Create(Sound, TweenInfo.new(0.5), {
						Volume = 0
					}):Play()
                    task.wait(0.6)
                    Sound:Stop()
                    Sound:Destroy()
                end)
            end)
        end)

        local s1 = ""

        for __, v in ipairs({
			"F",
			"L",
			"O",
			"W",
			"R",
			" ",
			"H",
			"U",
			"B",
			" ",
			"D",
			"U",
			"E",
			"L",
			"S"
		}) do
            s1 ..= v
            TextLabel11.Text = s1 .. "|"
            pcall(function()
                local Sound = Instance.new("Sound", ScreenGui)

                Sound.SoundId = "rbxassetid://6895079853"
                Sound.Volume = 0.4
                Sound:Play()
                game:GetService("Debris"):AddItem(Sound, 1)
            end)
            task.wait(0.3)
        end

        for i = 1, 6 do
            TextLabel11.Text = s1 .. (i % 2 ~= 0 and " " or "|")
            task.wait(0.28)
        end

        TextLabel11.Text = s1
        TweenService2:Create(TextLabel12, TweenInfo.new(0.5), {
			TextTransparency = 0
		}):Play()
        task.wait(1.4)

        local tweenInfo = TweenInfo.new(0.6)

        TweenService2:Create(TextLabel11, tweenInfo, {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}):Play()
        TweenService2:Create(TextLabel12, tweenInfo, {
			TextTransparency = 1
		}):Play()
        TweenService2:Create(Frame23, tweenInfo, {
			BackgroundTransparency = 1
		}):Play()
        TweenService2:Create(ImageLabel2, tweenInfo, {
			ImageTransparency = 1
		}):Play()
        TweenService2:Create(BlurEffect, tweenInfo, {
			Size = 0
		}):Play()
        task.wait(0.7)
        pcall(function()
            BlurEffect:Destroy()
        end)
        ScreenGui:Destroy()
    end

    task.spawn(function()
        task.wait(0.5)

        if t1.value6 and t1.value6.introEnabled then
            t1.value165()
        end
    end)
end)()
