-- This file was generated at discord.gg/syncrypt

local t1 = {}
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local CompactMenu = PlayerGui:FindFirstChild("CompactMenu")

if CompactMenu then
    CompactMenu:Destroy()
end
t1.value1 = Instance.new("ScreenGui")
t1.value1.Name = "CompactMenu"
t1.value1.ResetOnSpawn = false
t1.value1.Parent = PlayerGui
local UserInputService = game:GetService("UserInputService")

t1.value2 = false
t1.value3 = nil
t1.value4 = nil
t1.value5 = nil
t1.value6 = nil
function t1.value7(p1)
    p1.Parent = nil
    p1.Parent = t1.value1
end
local function v5(p2, p3)
    if t1.value2 then
        return
    end

    t1.value2 = true
    t1.value4 = p2
    t1.value3 = p3
    t1.value5 = p2.Position
    t1.value6 = p3.Position
    t1.value7(p2)
    p3.Changed:Connect(function()
        if p3.UserInputState == Enum.UserInputState.End then
            t1.value2 = false
            t1.value4 = nil
            t1.value3 = nil
        end
    end)
end
UserInputService.InputChanged:Connect(function(input)
    local v13 = input == t1.value3

    if v13 then
        v13 = t1.value2 and t1.value4
    end

    if v13 then
        local v14 = input.Position - t1.value6
        local uDim2 = UDim2.new(t1.value5.X.Scale, t1.value5.X.Offset + v14.X, t1.value5.Y.Scale, t1.value5.Y.Offset + v14.Y)

        t1.value4.Position = uDim2
    end
end)
UserInputService.TouchMoved:Connect(function(p4, _)
    local value2 = t1.value2

    if value2 then
        value2 = t1.value3

        if value2 then
            value2 = t1.value3.UserInputType == Enum.UserInputType.Touch
        end
    end

    if value2 and p4 == t1.value3 then
        local v19 = p4.Position - t1.value6
        local uDim2 = UDim2.new(t1.value5.X.Scale, t1.value5.X.Offset + v19.X, t1.value5.Y.Scale, t1.value5.Y.Offset + v19.Y)

        if t1.value4 then
            t1.value4.Position = uDim2
        end
    end
end)

function t1.value8(p6, p7)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 160, 0, 220)

    if not p7 then
        p7 = UDim2.new(0.5, -100, 0, 10)
    end

    Frame.Position = p7
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Parent = t1.value1
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Shadow"
    ImageLabel.Image = "rbxassetid://1316045217"
    ImageLabel.Size = UDim2.new(1, 30, 1, 30)
    ImageLabel.Position = UDim2.new(0, -15, 0, -15)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ImageTransparency = 0.5
    ImageLabel.ZIndex = 0
    ImageLabel.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, -40, 0, 26)
    TextLabel.Position = UDim2.new(0, 10, 0, 8)
    TextLabel.Text = p6 or "Window"
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextSize = 12
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 2
    TextLabel.Parent = Frame

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 18, 0, 18)
    TextButton.Position = UDim2.new(1, -30, 0, 10)
    TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TextButton.Text = "-"
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 12
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.ZIndex = 3
    TextButton.AutoButtonColor = true
    TextButton.Parent = Frame
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "CreditBtn"
    TextButton2.Size = UDim2.new(1, -20, 0, 20)
    TextButton2.Position = UDim2.new(0, 10, 1, -25)
    TextButton2.Text = "YT: @TGMANKASKE"
    TextButton2.Font = Enum.Font.GothamMedium
    TextButton2.TextSize = 13
    TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton2.BackgroundTransparency = 1
    TextButton2.TextXAlignment = Enum.TextXAlignment.Left
    TextButton2.ZIndex = 2
    TextButton2.AutoButtonColor = true
    TextButton2.Parent = Frame
    TextButton2.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://youtube.com/@TGMANKASKE")
        end
    end)

    local t2 = {}

    local function v29()
        local n1 = 45

        for _, v in ipairs(t2) do
            if v:IsA("GuiObject") and v.Visible then
                v.Position = UDim2.new(0, 10, 0, n1)
                n1 += v.Size.Y.Offset + 10
            end
        end

        Frame.Size = UDim2.new(0, 160, 0, n1 + 40)
    end

    TextButton.MouseButton1Click:Connect(function()
        if Frame.Size.Y.Offset > 50 then
            for _, v in ipairs(t2) do
                local v93 = v ~= TextButton

                if v93 then
                    v93 = v ~= TextLabel

                    if v93 then
                        v93 = v ~= TextButton2
                    end
                end

                if v93 then
                    v.Visible = false
                end
            end

            TextButton2.Visible = true
            TextLabel.Visible = true
            TextButton.Visible = true
            Frame.Size = UDim2.new(0, 200, 0, 50)

            return
        end

        for _, v in ipairs(t2) do
            v.Visible = true
        end

        TextButton2.Visible = true
        TextLabel.Visible = true
        TextButton.Visible = true
        v29()
    end)
    TextLabel.InputBegan:Connect(function(input)
        local v97 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v97 then
            v97 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v97 then
            local v98 = Frame

            v5(v98, input)
        end
    end)
    TextLabel.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        end
    end)

    return {
		Frame = Frame,
		CreateTextbox = function(p8, p9)
        local TextBox = Instance.new("TextBox")

        if not p8 then
            p8 = ""
        end

        TextBox.PlaceholderText = p8
        TextBox.Size = UDim2.new(1, -20, 0, 24)
        TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.Text = ""
        TextBox.ClearTextOnFocus = false
        TextBox.Font = Enum.Font.Gotham
        TextBox.TextSize = 12
        TextBox.ZIndex = 2
        TextBox.Parent = Frame
        Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
        TextBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                enterPressed = p9
            end

            if enterPressed then
                p9(TextBox.Text)
            end
        end)
        table.insert(t2, TextBox)
        v29()

        return TextBox
    end,
		CreateToggle = function(p10, p11, p12)
        local v83 = p12 or 0.1
        local TextButton3 = Instance.new("TextButton")
        TextButton3.Text = "[ ] " .. (p10 or "Toggle")
        TextButton3.Size = UDim2.new(1, -20, 0, 24)
        TextButton3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton3.Font = Enum.Font.Gotham
        TextButton3.TextSize = 12
        TextButton3.ZIndex = 2
        TextButton3.AutoButtonColor = true
        TextButton3.Parent = Frame
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
        local u85 = false
        local u86 = false
        local co
        TextButton3.MouseButton1Click:Connect(function()
            u85 = not u85
            TextButton3.Text = (not u85 and "[ ]" or "[✔]") .. " " .. p10

            if u85 then
                u86 = true
                co = coroutine.create(function()
                    while u86 do
                        if p11 then
                            p11(u85)
                        end

                        task.wait(v83)
                    end
                end)
                coroutine.resume(co)
            end
        end)
        table.insert(t2, TextButton3)
        v29()

        return TextButton3
    end,
		CreateButton = function(p13, p14)
        local TextButton4 = Instance.new("TextButton")

        if not p13 then
            p13 = "Button"
        end

        TextButton4.Text = p13
        TextButton4.Size = UDim2.new(1, -20, 0, 26)
        TextButton4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton4.Font = Enum.Font.Gotham
        TextButton4.TextSize = 12
        TextButton4.AutoButtonColor = false
        TextButton4.ZIndex = 2
        TextButton4.Parent = Frame
        Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)
        TextButton4.MouseEnter:Connect(function()
            TextButton4.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        TextButton4.MouseLeave:Connect(function()
            TextButton4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        TextButton4.MouseButton1Down:Connect(function()
            TextButton4.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)
        TextButton4.MouseButton1Up:Connect(function()
            TextButton4.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        TextButton4.MouseButton1Click:Connect(function()
            if p14 then
                p14()
            end
        end)
        table.insert(t2, TextButton4)
        v29()

        return TextButton4
    end,
		UpdateSize = v29,
		Elements = t2
	}
end
t1.value9 = {}
local function v6(p15)
    local v31 = #t1.value9 * 207 + 10
    local v32 = t1.value8(p15, UDim2.new(0, v31, 0, 10))

    table.insert(t1.value9, v32)

    return v32
end
local v7 = v6("Boosts")

v7.CreateButton("Aimbot (legit)", function()
    print("I Love KontrollAll <3")

    local color3 = Color3.fromRGB(255, 255, 255)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService2 = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local CurrentCamera = workspace.CurrentCamera
    local drawing = Drawing.new("Circle")

    drawing.Color = color3
    drawing.Thickness = 1
    drawing.Filled = false
    drawing.NumSides = 100
    drawing.Transparency = 1
    drawing.Radius = 25
    drawing.Visible = true

    local function v40()
        local v100
        local n2 = 25
        for _, player in ipairs(Players:GetPlayers()) do
            local v104 = player ~= LocalPlayer

            if v104 then
                v104 = player.Character

                if v104 then
                    v104 = player.Character:FindFirstChild("Head")
                end
            end

            if v104 then
                local v105 = true

                if v105 then
                    v105 = player.Team == LocalPlayer.Team
                end

                if not v105 then
                    local Head = player.Character.Head
                    local v108, t3Result = CurrentCamera:WorldToViewportPoint(Head.Position)
                    if t3Result then
                        local MouseLocation = UserInputService2:GetMouseLocation()
                        local Magnitude = (Vector2.new(v108.X, v108.Y) - Vector2.new(MouseLocation.X, MouseLocation.Y)).Magnitude

                        if Magnitude < n2 then
                            n2 = Magnitude
                            v100 = player
                        end
                    end
                end
            end
        end

        return v100
    end

    RunService.RenderStepped:Connect(function()
        local MouseLocation = UserInputService2:GetMouseLocation()

        drawing.Position = Vector2.new(MouseLocation.X, MouseLocation.Y)

        if false then
            local v112 = v40()
            local v113 = v112

            if v112 then
                v113 = v112.Character

                if v113 then
                    v113 = v112.Character:FindFirstChild("Head")
                end
            end

            if v113 then
                local HeadPosition = v112.Character.Head.Position

                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, HeadPosition)
            end
        end
    end)
    UserInputService2.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        end
    end)
    UserInputService2.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        end
    end)
end)
v7.CreateButton("Head Hitbox", function()
    print("lol")

    local v41 = (function()
        for _, child in pairs(game:GetChildren()) do
            if child.ClassName == "Players" then
                return child.Name
            end
        end
    end)()
    local LocalPlayer = game[v41].LocalPlayer

    coroutine.wrap(function()
        while wait(1) do
            for _, player in pairs(game[v41]:GetPlayers()) do
                if player.Name ~= LocalPlayer.Name and player.Character then
                    local Character = player.Character

                    for _, v in ipairs({
						"RightUpperLeg",
						"LeftUpperLeg",
						"HeadHB",
						"HumanoidRootPart"
					}) do
                        local v2 = Character:FindFirstChild(v)

                        if v2 and v2:IsA("BasePart") then
                            v2.CanCollide = false
                            v2.Transparency = 1
                            v2.Size = Vector3.new(13, 13, 13)

                            if v == "HeadHB" then
                                v2.Size = Vector3.new(20, 20, 20)
                            end
                        end
                    end
                end
            end
        end
    end)()
end)
v7.CreateButton("Esp", function()
    print("i love the kontrollall <3")

    local color3 = Color3.fromRGB(255, 255, 255)
    local color3_2 = Color3.fromRGB(255, 255, 255)
    local color3_3 = Color3.fromRGB(255, 255, 255)
    local CurrentCamera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local t4 = {}

    local function v50(p16)
        local v126, v127 = CurrentCamera:WorldToViewportPoint(p16)

        return Vector2.new(v126.X, v126.Y), v127
    end
    local function v51(p17, p18)
        local drawing = Drawing.new(p17)

        for k, v in pairs(p18) do
            drawing[k] = v
        end

        return drawing
    end
    local function v52(p19)
        local v136 = v51("Line", {
			Thickness = 1.5,
			Color = color3,
			Transparency = 1
		})
        local t5 = {
			Radius = 3,
			NumSides = 12,
			Color = color3_3,
			Thickness = 1,
			Filled = false,
			Visible = false
		}
        local drawing = Drawing.new("Circle")
        for k, v in pairs(t5) do
            drawing[k] = v
        end
        local t6 = {
			line = v136,
			headCircle = drawing
		}
        local t7 = {
			"Head",
			"Torso",
			"HumanoidRootPart",
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand",
			"RightUpperArm",
			"RightLowerArm",
			"RightHand",
			"LeftUpperLeg",
			"LeftLowerLeg",
			"LeftFoot",
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot"
		}
        for i = 1, #t7 do
            t6[t7[i]] = v51("Line", {
				Color = color3_2,
				Thickness = 1,
				Transparency = 1
			})
        end
        t4[p19] = t6
    end
    local function v53(p20, p21)
        local v151 = t4[p20]

        if not v151 then
            return
        end

        local Humanoid = p21:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
            for _, v in pairs(v151) do
                v.Visible = false
            end

            return
        end

        local v155 = true

        if v155 then
            v155 = p20.Team == LocalPlayer.Team
        end

        if v155 then
            for _, v in pairs(v151) do
                v.Visible = false
            end

            return
        end

        local Head = p21:FindFirstChild("Head")
        local HumanoidRootPart = p21:FindFirstChild("HumanoidRootPart")

        if Head and HumanoidRootPart then
            local v160, v161 = v50(HumanoidRootPart.Position)
            local vector2 = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)

            if v161 then
                v151.line.From = vector2
                v151.line.To = v160
                v151.line.Visible = true
            else
                v151.line.Visible = false
            end

            local v163, v164 = v50(Head.Position)

            if v164 then
                v151.headCircle.Position = v163
                v151.headCircle.Visible = true
            else
                v151.headCircle.Visible = false
            end

            local function v165(p22, p23)
                local p22_2 = p21:FindFirstChild(p22)
                local p23_2 = p21:FindFirstChild(p23)
                local v185 = v151[p22]

                if p22_2 and (p23_2 and v185) then
                    local v186, v187 = v50(p22_2.Position)
                    local v188, v189 = v50(p23_2.Position)

                    if v187 and v189 then
                        v185.From = v186
                        v185.To = v188
                        v185.Visible = true

                        return
                    end

                    v185.Visible = false

                    return
                end

                if v185 then
                    v185.Visible = false
                end
            end

            v165("Head", "Torso")
            v165("Torso", "LeftUpperArm")
            v165("LeftUpperArm", "LeftLowerArm")
            v165("LeftLowerArm", "LeftHand")
            v165("Torso", "RightUpperArm")
            v165("RightUpperArm", "RightLowerArm")
            v165("RightLowerArm", "RightHand")
            v165("Torso", "LeftUpperLeg")
            v165("LeftUpperLeg", "LeftLowerLeg")
            v165("LeftLowerLeg", "LeftFoot")
            v165("Torso", "RightUpperLeg")
            v165("RightUpperLeg", "RightLowerLeg")
            v165("RightLowerLeg", "RightFoot")

            return
        end

        v151.line.Visible = false
        v151.headCircle.Visible = false
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            v52(player)
        end)
    end)
    Players.PlayerRemoving:Connect(function(player)
        if t4[player] then
            for _, v in pairs(t4[player]) do
                if v and v.Remove then
                    v:Remove()
                end
            end

            t4[player] = nil
        end
    end)

    for _, player in pairs(Players:GetPlayers()) do
        local v56 = player

        if v56 ~= LocalPlayer then
            if v56.Character then
                v52(v56)
            end

            v56.CharacterAdded:Connect(function()
                wait(1)
                v52(v56)
            end)
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                v53(player, player.Character)
            end
        end
    end)
end)
v7.CreateButton("Speed", function()
    print("lol")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function v60(p24)
        local Character = LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = p24
        end
    end

    v60(50)
    LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        v60(50)
    end)
    RunService.RenderStepped:Connect(function()
        local Character = LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid and Humanoid.WalkSpeed ~= 50 then
            Humanoid.WalkSpeed = 50
        end
    end)
end)
v7.CreateButton("Air jump", function()
    print("lol")

    local n3 = 1e999
    local Players = game:GetService("Players")
    local UserInputService3 = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local n4 = 0
    local u66 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = u66:WaitForChild("Humanoid")

    Humanoid.JumpPower = 70
    Humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            n4 = 0
        end
    end)
    UserInputService3.JumpRequest:Connect(function()
        if n4 < n3 then
            local v177 = Humanoid

            if v177 then
                v177 = Humanoid:GetState() ~= Enum.HumanoidStateType.Dead
            end

            if v177 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                local _ = n4 + 1
            end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(character)
        u66 = character
        Humanoid = u66:WaitForChild("Humanoid")
        Humanoid.JumpPower = 70
    end)
end)
v7.CreateButton("No-Recoil", function()
    print("lol")

    local ReplicatedStorage = game.ReplicatedStorage

    for _, descendant in pairs(ReplicatedStorage.Weapons:GetDescendants()) do
        if descendant.Name == "RecoilControl" then
            descendant.Value = 0
        end
    end
end)
v7.CreateButton("Rapid Fire", function()
    print("lol")

    for _, descendant in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        local v73 = descendant.Name == "FireRate"

        if not v73 then
            v73 = descendant.Name == "BFireRate"
        end

        if v73 then
            descendant.Value = 0.03
        end
    end
end)

local v8 = v6("My TEAM")

v8.CreateButton("KontrollAll", function()
    print("i love the kontrollall <3")
    setclipboard("youtube.com/@pl3h")
end)
v8.CreateButton("TGMANKASKE", function()
    print("i love the kontrollall <3")
    setclipboard("youtube.com/@TGMANKASKE")
end)
v8.CreateButton("Discord Here", function()
    print("i love the kontrollall <3")
    setclipboard("https://discord.gg/esYJzYnsfC")
end)
