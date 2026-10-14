-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game.Players.LocalPlayer
}
t1.value2 = t1.value1:GetMouse()
t1.value3 = game:GetService("Players")
t1.value4 = game:GetService("UserInputService")
t1.value5 = game:GetService("RunService")
t1.value6 = workspace.CurrentCamera
t1.value7 = Color3.fromRGB(0, 255, 0)
t1.value8 = 0.15
t1.value9 = 200
t1.value10 = 500
t1.value11 = 130
t1.value12 = 200
t1.value13 = 150
t1.value14 = "BLOX-7K9P-X4QM-82ZT-R6NW"
t1.value15 = "https://loot-link.com/s?GqesAP2m"
t1.value16 = false
t1.value17 = false
t1.value18 = nil
t1.value19 = nil
t1.value20 = nil
t1.value21 = nil
t1.value22 = nil
t1.value23 = false
t1.value24 = 130
t1.value25 = nil
t1.value26 = nil
t1.value27 = false
t1.value28 = false
t1.value29 = nil
t1.value30 = false
t1.value31 = {}
t1.value32 = false
t1.value33 = nil
t1.value34 = {}
t1.value35 = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 128, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(0, 128, 255),
	Color3.fromRGB(128, 0, 255),
	Color3.fromRGB(255, 0, 255)
}

function t1.value36(p1)
    return p1 and p1.Character
end
function t1.value37(p2)
    local v6 = p2 and p2:FindFirstChild("HumanoidRootPart")

    return v6 and v6.Position
end
function t1.value38()
    return t1.value23 and t1.value24 or t1.value9
end
local function v2()
    local v8 = t1.value36(t1.value1)
    local v9 = not v8
    if not v9 then
        v9 = not v8:FindFirstChild("HumanoidRootPart")
    end
    if v9 then
        return nil
    end
    local _ = v8.HumanoidRootPart.Position
    local vector2 = Vector2.new(t1.value6.ViewportSize.X / 2, t1.value6.ViewportSize.Y / 2)
    local v12
    local v13 = t1.value38()
    for _, player in ipairs(t1.value3:GetPlayers()) do
        if player ~= t1.value1 then
            local v16 = t1.value36(player)

            if v16 and v16:FindFirstChild("HumanoidRootPart") then
                local Humanoid = v16:FindFirstChildOfClass("Humanoid")

                if Humanoid and Humanoid.Health > 0 then
                    local v19, t2Result = t1.value6:WorldToViewportPoint(v16.HumanoidRootPart.Position)
                    if t2Result then
                        local Magnitude = (Vector2.new(v19.X, v19.Y) - vector2).Magnitude

                        if Magnitude < v13 then
                            v13 = Magnitude
                            v12 = v16
                        end
                    end
                end
            end
        end
    end

    return v12
end
function t1.value39()
    if t1.value19 then
        t1.value19:Destroy()
        t1.value19 = nil
    end

    if t1.value20 then
        t1.value20:Destroy()
        t1.value20 = nil
    end
end
t1.value40 = nil
function t1.value40(p3)
    t1.value39()

    if not p3 then
        return
    end

    t1.value19 = Instance.new("Highlight")
    t1.value19.Adornee = p3
    t1.value19.FillColor = t1.value7
    t1.value19.OutlineColor = Color3.fromRGB(0, 255, 0)
    t1.value19.FillTransparency = 0.5
    t1.value19.OutlineTransparency = 0
    t1.value19.Parent = game:GetService("CoreGui")

    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        t1.value20 = Instance.new("BoxHandleAdornment")
        t1.value20.Size = Vector3.new(8, 8, 8)
        t1.value20.Adornee = HumanoidRootPart
        t1.value20.AlwaysOnTop = true
        t1.value20.Color3 = t1.value7
        t1.value20.Transparency = 0.3
        t1.value20.ZIndex = 5
        t1.value20.Parent = game:GetService("CoreGui")
    end
end
function t1.value41()
    t1.value5.RenderStepped:Connect(function()
        if not t1.value17 or not t1.value18 then
            return
        end

        local Humanoid = t1.value18:FindFirstChildOfClass("Humanoid")
        local v96 = not Humanoid

        if not v96 then
            v96 = Humanoid.Health <= 0 or not t1.value18:IsDescendantOf(workspace)
        end

        if v96 then
            toggleAimbot()

            return
        end

        local v97 = t1.value37(t1.value18)

        if not v97 then
            return
        end

        t1.value6.CFrame = t1.value6.CFrame:Lerp(CFrame.lookAt(t1.value6.CFrame.Position, v97), t1.value8)

        local v98 = t1.value36(t1.value1)
        local v99 = v98

        if v98 then
            v99 = v98:FindFirstChild("HumanoidRootPart")
        end

        if v99 then
            local HumanoidRootPart = v98.HumanoidRootPart
            local Unit = (v97 - HumanoidRootPart.Position).Unit

            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + Unit)
        end

        t1.value40(t1.value18)
    end)
end
function toggleAimbot()
    if t1.value17 then
        t1.value17 = false
        t1.value18 = nil
        t1.value39()

        if t1.value21 then
            t1.value21:Disconnect()
        end

        if t1.value22 then
            t1.value4.MouseBehavior = t1.value22
        end

        atualizarLabels()

        return
    end

    t1.value18 = v2()

    if not t1.value18 then
        print("Nenhum alvo encontrado no FOV.")

        return
    end

    t1.value17 = true

    local _ = t1.value4.MouseBehavior

    t1.value4.MouseBehavior = Enum.MouseBehavior.LockCenter
    t1.value40(t1.value18)
    t1.value41()
    atualizarLabels()
end
function t1.value42()
    if t1.value25 then
        t1.value25:Remove()
    end

    if t1.value26 then
        t1.value26:Destroy()
        t1.value26 = nil
    end

    local ok, _ = pcall(function()
        local drawing = Drawing.new("Circle")

        drawing.Thickness = 2
        drawing.Color = Color3.fromRGB(0, 255, 0)
        drawing.Transparency = 0.8
        drawing.Radius = t1.value24
        drawing.Position = Vector2.new(t1.value6.ViewportSize.X / 2, t1.value6.ViewportSize.Y / 2)
        drawing.Visible = t1.value23

        return drawing
    end)

    if not ok then
        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "FOVGui"

        local ok2 = pcall(function()
            return game:GetService("CoreGui")
        end)

        if ok2 then
            ok2 = game:GetService("CoreGui")
        end

        if not ok2 then
            ok2 = t1.value1:WaitForChild("PlayerGui")
        end

        ScreenGui.Parent = ok2
        t1.value26 = Instance.new("Frame")
        t1.value26.Size = UDim2.new(0, t1.value24 * 2, 0, t1.value24 * 2)

        local value26 = t1.value26
        local new = UDim2.new
        local value24 = t1.value24

        value26.Position = new(0.5, -t1.value24, 0.5, -value24)
        t1.value26.BackgroundTransparency = 0.85
        t1.value26.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        t1.value26.BorderSizePixel = 0
        t1.value26.Parent = ScreenGui
        Instance.new("UICorner", t1.value26).CornerRadius = UDim.new(1, 0)

        local UIStroke = Instance.new("UIStroke", t1.value26)

        UIStroke.Color = Color3.fromRGB(0, 255, 0)
        UIStroke.Thickness = 2
        UIStroke.Transparency = 0.2
        t1.value26.Visible = t1.value23
    end
end
function t1.value43()
    if t1.value25 then
        t1.value25.Radius = t1.value24
        t1.value25.Position = Vector2.new(t1.value6.ViewportSize.X / 2, t1.value6.ViewportSize.Y / 2)
        t1.value25.Visible = t1.value23
    end

    if t1.value26 then
        t1.value26.Size = UDim2.new(0, t1.value24 * 2, 0, t1.value24 * 2)
        t1.value26.Position = UDim2.new(0.5, -t1.value24, 0.5, -t1.value24)
        t1.value26.Visible = t1.value23
    end
end
function t1.value44()
    t1.value23 = not t1.value23
    t1.value42()
    t1.value43()
    atualizarLabels()
end
local function v3()
    local min = math.min
    local v35 = t1.value24 + 10

    t1.value24 = min(t1.value10, v35)
    t1.value43()
    atualizarLabels()
end
function t1.value45()
    local max = math.max
    local v33 = t1.value24 - 10

    t1.value24 = max(t1.value11, v33)
    t1.value43()
    atualizarLabels()
end
function t1.value46()
    if t1.value29 then
        t1.value29:Disconnect()
    end

    t1.value5.RenderStepped:Connect(function()
        local v94 = t1.value36(t1.value1)

        if v94 then
            v94 = t1.value36(t1.value1):FindFirstChildOfClass("Humanoid")
        end

        if v94 then
            if t1.value27 then
                v94.WalkSpeed = t1.value12
            end

            if t1.value28 then
                v94.JumpPower = t1.value13
            end
        end
    end)
end
function t1.value47()
    t1.value27 = not t1.value27
    atualizarLabels()
end
function t1.value48()
    t1.value28 = not t1.value28
    atualizarLabels()
end
function t1.value49(p4)
    if p4 == t1.value1 then
        return
    end

    local v37 = t1.value36(p4)
    local v38 = not v37

    if not v38 then
        v38 = not v37:FindFirstChild("Head")
    end

    if v38 then
        return
    end

    local Head = v37.Head

    if Head:FindFirstChild("ESPSteve") then
        Head:FindFirstChild("ESPSteve"):Destroy()
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "ESPSteve"
    BillboardGui.Size = UDim2.new(0, 200, 0, 40)
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Parent = Head

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 12
    TextLabel.Parent = BillboardGui

    local Humanoid = v37:FindFirstChildOfClass("Humanoid")
    local connection = t1.value5.RenderStepped:Connect(function()
        local v104 = not v37

        if not v104 then
            v104 = not v37.Parent

            if not v104 then
                v104 = not Humanoid

                if not v104 then
                    v104 = Humanoid.Health <= 0
                end
            end
        end

        if v104 then
            if BillboardGui.Parent then
                BillboardGui:Destroy()
            end

            if t1.value31[p4] then
                local v105 = p4

                t1.value31[v105]:Disconnect()
                t1.value31[p4] = nil
            end

            return
        end

        local MaxHealth = Humanoid.MaxHealth
        local _math = math
        local v108 = MaxHealth or 100
        local v109 = _math.clamp(Humanoid.Health / v108 * 100, 0, 100)

        TextLabel.Text = p4.Name .. "\n❤\239\184\143 " .. math.floor(v109) .. "%"
    end)

    t1.value31[p4] = connection
end
local function v4()
    t1.value30 = not t1.value30

    if t1.value30 then
        for _, player in pairs(t1.value3:GetPlayers()) do
            local v46 = player

            if v46 ~= t1.value1 then
                t1.value49(v46)
                table.insert(t1.value31, v46.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    t1.value49(v46)
                end))
            end
        end

        table.insert(t1.value31, t1.value3.PlayerAdded:Connect(function(player)
            table.insert(t1.value31, player.CharacterAdded:Connect(function()
                task.wait(0.5)
                t1.value49(player)
            end))
        end))
    else

        for v49, v50 in pairs(t1.value3:GetPlayers()) do

            local Character = v50.Character

            if Character then
                Character = v50.Character:FindFirstChild("Head")
            end

            if Character then
                local ESPSteve = v50.Character.Head:FindFirstChild("ESPSteve")

                if ESPSteve then
                    ESPSteve:Destroy()
                end
            end
        end
        for _, v in pairs(t1.value31) do
            v:Disconnect()
        end
    end

    atualizarLabels()
end
t1.value50 = nil
function t1.value50()
    if t1.value33 then
        t1.value33:Disconnect()
    end

    t1.value33 = t1.value5.RenderStepped:Connect(function()
        if not t1.value32 then
            return
        end

        local v102 = t1.value36(t1.value1)

        if v102 then
            v102 = t1.value36(t1.value1):FindFirstChildOfClass("Humanoid")
        end

        if v102 then
            v102:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            v102:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            v102:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
            v102:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

            if v102:GetState() == Enum.HumanoidStateType.PlatformStand then
                v102:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end
        end
    end)
end
function t1.value51()
    t1.value32 = not t1.value32

    if t1.value32 then
        t1.value50()
    elseif t1.value33 then
        t1.value33:Disconnect()
    end

    atualizarLabels()
end
function t1.value52()
    if game:GetService("CoreGui"):FindFirstChild("SteveHubAimbot") then
        game:GetService("CoreGui"):FindFirstChild("SteveHubAimbot"):Destroy()
    end

    if t1.value1:WaitForChild("PlayerGui"):FindFirstChild("SteveHubAimbot") then
        t1.value1:WaitForChild("PlayerGui"):FindFirstChild("SteveHubAimbot"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "SteveHubAimbot"

    local ok = pcall(function()
        return game:GetService("CoreGui")
    end)

    if ok then
        ok = game:GetService("CoreGui")
    end

    if not ok then
        ok = t1.value1:WaitForChild("PlayerGui")
    end

    ScreenGui.Parent = ok

    local Frame = Instance.new("Frame")

    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 280, 0, 340)
    Frame.Position = UDim2.new(0.5, -140, 0.5, -170)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.35
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    local UIStroke = Instance.new("UIStroke", Frame)

    UIStroke.Thickness = 2
    table.insert(t1.value34, UIStroke)

    local ImageButton = Instance.new("ImageButton")

    ImageButton.Size = UDim2.new(0, 40, 0, 40)
    ImageButton.Position = UDim2.new(0.85, 0, 0.35, 0)
    ImageButton.Image = "rbxassetid://82710539061276"
    ImageButton.BackgroundTransparency = 1
    ImageButton.Active = true
    ImageButton.Draggable = true
    ImageButton.Parent = ScreenGui
    Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(1, 0)

    local UIStroke2 = Instance.new("UIStroke", ImageButton)

    UIStroke2.Thickness = 2.5
    table.insert(t1.value34, UIStroke2)
    ImageButton.MouseButton1Click:Connect(function()
        Frame.Visible = not Frame.Visible
    end)

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 24, 0, 24)
    TextButton.Position = UDim2.new(0, 8, 0, 8)
    TextButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TextButton.Text = "X"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.Parent = Frame
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

    local UIStroke3 = Instance.new("UIStroke", TextButton)

    UIStroke3.Thickness = 1
    table.insert(t1.value34, UIStroke3)
    TextButton.MouseButton1Click:Connect(function()
        Frame.Visible = false
    end)

    local u63 = false
    local TextButton2 = Instance.new("TextButton")

    TextButton2.Size = UDim2.new(0, 24, 0, 24)
    TextButton2.Position = UDim2.new(1, -32, 0, 8)
    TextButton2.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TextButton2.Text = "🔒"
    TextButton2.TextSize = 10
    TextButton2.Parent = Frame
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

    local UIStroke4 = Instance.new("UIStroke", TextButton2)

    UIStroke4.Thickness = 1
    table.insert(t1.value34, UIStroke4)
    TextButton2.MouseButton1Click:Connect(function()
        u63 = not u63
        Frame.Draggable = not u63

        if u63 then
            TextButton2.Text = "🔓"

            return
        end

        TextButton2.Text = "🔒"
    end)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, 25)
    TextLabel.Position = UDim2.new(0, 0, 0, 8)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Steve Hub Aimbot"
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 17
    TextLabel.Parent = Frame
    table.insert(t1.value34, TextLabel)

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.new(1, 0, 0, 270)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 50)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 1
    ScrollingFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ScrollingFrame

    local function v69(p5, p6)
        local TextButton3 = Instance.new("TextButton")

        TextButton3.Size = UDim2.new(1, -30, 0, 30)
        TextButton3.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TextButton3.BackgroundTransparency = 0.2
        TextButton3.BorderSizePixel = 0
        TextButton3.AutoButtonColor = true
        TextButton3.Text = p5 .. ": OFF"
        TextButton3.Font = Enum.Font.SourceSansBold
        TextButton3.TextSize = 11
        TextButton3.Parent = ScrollingFrame
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)
        table.insert(t1.value34, TextButton3)

        local UIStroke5 = Instance.new("UIStroke", TextButton3)

        UIStroke5.Thickness = 1
        UIStroke5.Color = Color3.fromRGB(60, 60, 60)
        TextButton3.MouseButton1Click:Connect(p6)

        return TextButton3
    end

    local v70 = v69("Aimbot", toggleAimbot)
    local v71 = v69("Aim FOV", t1.value44)
    local v72 = v69("Speed Boost", t1.value47)
    local v73 = v69("Jump Boost", t1.value48)
    local v74 = v69("ESP", v4)
    local v75 = v69("Ant Stun", t1.value51)
    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, -30, 0, 50)
    Frame2.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame2.BackgroundTransparency = 0.2
    Frame2.BorderSizePixel = 0
    Frame2.Parent = ScrollingFrame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 8)

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(1, 0, 0, 18)
    TextLabel2.Position = UDim2.new(0, 8, 0, 3)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "FOV Raio: " .. tostring(t1.value24)
    TextLabel2.Font = Enum.Font.SourceSansBold
    TextLabel2.TextSize = 11
    TextLabel2.Parent = Frame2
    table.insert(t1.value34, TextLabel2)

    local TextButton4 = Instance.new("TextButton")

    TextButton4.Size = UDim2.new(0, 35, 0, 22)
    TextButton4.Position = UDim2.new(0, 8, 0, 24)
    TextButton4.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    TextButton4.Text = "-"
    TextButton4.TextColor3 = Color3.new(1, 1, 1)
    TextButton4.Font = Enum.Font.SourceSansBold
    TextButton4.TextSize = 14
    TextButton4.Parent = Frame2
    Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)
    TextButton4.MouseButton1Click:Connect(t1.value45)

    local TextButton5 = Instance.new("TextButton")

    TextButton5.Size = UDim2.new(0, 35, 0, 22)
    TextButton5.Position = UDim2.new(1, -43, 0, 24)
    TextButton5.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    TextButton5.Text = "+"
    TextButton5.TextColor3 = Color3.new(1, 1, 1)
    TextButton5.Font = Enum.Font.SourceSansBold
    TextButton5.TextSize = 14
    TextButton5.Parent = Frame2
    Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 6)
    TextButton5.MouseButton1Click:Connect(v3)

    local Frame3 = Instance.new("Frame")

    Frame3.Size = UDim2.new(1, -100, 0, 5)
    Frame3.Position = UDim2.new(0, 50, 0, 32)
    Frame3.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Frame3.BorderSizePixel = 0
    Frame3.Parent = Frame2
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

    local Frame4 = Instance.new("Frame")

    Frame4.Size = UDim2.new(0, 0, 1, 0)
    Frame4.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    Frame4.BorderSizePixel = 0
    Frame4.Parent = Frame3
    Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)
    table.insert(t1.value34, Frame4)

    function atualizarLabels()
        v70.Text = not t1.value17 and "Aimbot: OFF" or "Aimbot: ON"
        v71.Text = not t1.value23 and "Aim FOV: OFF" or "Aim FOV: ON"
        v72.Text = not t1.value27 and "Speed Boost: OFF" or "Speed Boost: ON"
        v73.Text = not t1.value28 and "Jump Boost: OFF" or "Jump Boost: ON"
        v74.Text = not t1.value30 and "ESP: OFF" or "ESP: ON"
        v75.Text = not t1.value32 and "Ant Stun: OFF" or "Ant Stun: ON"
        TextLabel2.Text = "FOV Raio: " .. tostring(t1.value24)

        local v115 = (t1.value24 - t1.value11) / (t1.value10 - t1.value11)

        Frame4.Size = UDim2.new(v115, 0, 1, 0)
    end

    atualizarLabels()
    task.spawn(function()
        local n1 = 1
        local n2 = 2
        local n3 = 0

        while ScreenGui.Parent do
            local v119 = t1.value35[n1]:Lerp(t1.value35[n2], n3)
            for v122, v123 in ipairs(t1.value34) do

                if v123:IsA("UIStroke") then
                    v123.Color = v119
                else
                    local v124 = v123:IsA("TextLabel")

                    if not v124 then
                        v124 = v123:IsA("TextButton") or v123:IsA("ImageButton")
                    end

                    if v124 then
                        v123.TextColor3 = v119
                    else
                        local v125 = v123:IsA("Frame")

                        if v125 then
                            v125 = v123.Name ~= "MainFrame"
                        end

                        if v125 then
                            v123.BackgroundColor3 = v119
                        end
                    end
                end
            end
            n3 += 0.02
            if n3 >= 1 then
                n1 = n2
                n3 = 0
                n2 = n2 % #t1.value35 + 1
            end
            task.wait(0.03)
        end
    end)
    t1.value2.KeyDown:Connect(function(p7)
        if p7 == "p" then
            ScreenGui:Destroy()
        end
    end)

    return ScreenGui
end;
(function()
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "KeyGUI"

    local ok = pcall(function()
        return game:GetService("CoreGui")
    end)

    if ok then
        ok = game:GetService("CoreGui")
    end

    if not ok then
        ok = t1.value1:WaitForChild("PlayerGui")
    end

    ScreenGui.Parent = ok

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 300, 0, 230)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -115)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke", Frame)

    UIStroke.Color = Color3.fromRGB(255, 0, 0)
    UIStroke.Thickness = 2

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, 30)
    TextLabel.Position = UDim2.new(0, 0, 0, 10)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "key noobzinx"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 18
    TextLabel.Parent = Frame

    local TextBox = Instance.new("TextBox")

    TextBox.Size = UDim2.new(0, 260, 0, 40)
    TextBox.Position = UDim2.new(0.5, -130, 0, 50)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TextBox.PlaceholderText = "KEY AQUI"
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 14
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.new(1, 0, 0, 20)
    TextLabel3.Position = UDim2.new(0, 0, 0, 100)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = ""
    TextLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
    TextLabel3.Font = Enum.Font.SourceSans
    TextLabel3.TextSize = 12
    TextLabel3.Parent = Frame

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 260, 0, 40)
    TextButton.Position = UDim2.new(0.5, -130, 0, 130)
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    TextButton.Text = "VALIDAR"
    TextButton.TextColor3 = Color3.new(1, 1, 1)
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.TextSize = 15
    TextButton.Parent = Frame
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

    local TextButton6 = Instance.new("TextButton")

    TextButton6.Size = UDim2.new(0, 120, 0, 30)
    TextButton6.Position = UDim2.new(0.5, -60, 0, 185)
    TextButton6.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    TextButton6.Text = "Buy Key"
    TextButton6.TextColor3 = Color3.new(1, 1, 1)
    TextButton6.Font = Enum.Font.SourceSansBold
    TextButton6.TextSize = 13
    TextButton6.Parent = Frame
    Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 6)
    TextButton6.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(t1.value15)
        end)
    end)
    TextButton.MouseButton1Click:Connect(function()
        if TextBox.Text == t1.value14 then
            ScreenGui:Destroy()
            t1.value16 = true
            t1.value52()
            t1.value43()
            t1.value46()

            return
        end

        TextLabel3.Text = "Key incorreta!"
    end)
end)()
task.spawn(function()
    while true do
        task.wait(1)

        if t1.value16 then
            local SteveHubAimbot = game:GetService("CoreGui"):FindFirstChild("SteveHubAimbot")
            local SteveHubAimbot2 = t1.value1:WaitForChild("PlayerGui"):FindFirstChild("SteveHubAimbot")
            local v93 = not SteveHubAimbot

            if v93 then
                v93 = not SteveHubAimbot2
            end

            if v93 then
                t1.value52()
                t1.value43()
            end
        end
    end
end)
