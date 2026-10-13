setfpscap(600)
if exe then
    return
end
print("exe is sexy")
getgenv().exe = true
local u1 = true
local LocalPlayer = game.Players.LocalPlayer
local Part = Instance.new("Part")
Part.Name = "Visualizer"
Part.Anchored = true
Part.Size = Vector3.new(10, 0.4, 10)
Part.Color = Color3.new(1, 0, 0)
Part.CanCollide = false
Part.CastShadow = false
Part.CanQuery = false
Part.Transparency = getgenv().visualizer and 0.75 or 1
local SpecialMesh = Instance.new("SpecialMesh")
SpecialMesh.Parent = Part
SpecialMesh.MeshType = Enum.MeshType.FileMesh
SpecialMesh.MeshId = "rbxassetid://471124075"
SpecialMesh.Scale = Vector3.new(0.067, 0.042, 0.067)
Part.Parent = workspace
local clone = Part:Clone()
clone.Name = "VisualizerFollowBall"
clone.Parent = workspace
clone.Transparency = getgenv().visualizer and 0 or 1
local clone2 = Part:Clone()
clone2.Name = "VisualizerNoUnit"
clone2.Parent = workspace
clone2.Transparency = getgenv().visualizer and 0.9 or 1
clone2.Color = Color3.new(1, 0, 1)
local clone3 = clone2:Clone()
clone3.Name = "VisualizerFollowBallNoUnit"
clone3.Parent = workspace
clone3.Transparency = getgenv().visualizer and 0.9 or 1
local BillboardGui = Instance.new("BillboardGui")
local TextLabel = Instance.new("TextLabel")
local BillboardGui2 = Instance.new("BillboardGui")
local TextLabel2 = Instance.new("TextLabel")
BillboardGui.Name = "Range"
BillboardGui.Parent = game.CoreGui
BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BillboardGui.Active = true
BillboardGui.LightInfluence = 1
BillboardGui.Size = UDim2.new(3, 0, 3, 0)
BillboardGui.StudsOffset = Vector3.new(0, 5, 0)
BillboardGui.Enabled = getgenv().visualizer
TextLabel.Name = "Text"
TextLabel.Parent = BillboardGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(1, 0, 0.55, 0)
TextLabel.Position = UDim2.new(0, 0, 0.45, 0)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "100"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
TextLabel.TextStrokeTransparency = 0
TextLabel.TextWrapped = true
local clone4 = TextLabel:Clone()
clone4.Name = "TextMulti"
clone4.Parent = BillboardGui
clone4.TextTransparency = 0.5
clone4.TextStrokeTransparency = 0.5
clone4.Size = UDim2.new(1, 0, 0.45, 0)
clone4.Position = UDim2.new(0, 0, 0, 0)
clone4.Text = "1x"
BillboardGui2.Name = "Distance"
BillboardGui2.Parent = game.CoreGui
BillboardGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BillboardGui2.Active = true
BillboardGui2.LightInfluence = 1
BillboardGui2.Size = UDim2.new(2, 0, 2, 0)
BillboardGui2.StudsOffset = Vector3.new(0, 5, 0)
BillboardGui2.Enabled = getgenv().visualizer
TextLabel2.Name = "Text"
TextLabel2.Parent = BillboardGui2
TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.BackgroundTransparency = 1
TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel2.BorderSizePixel = 0
TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.Font = Enum.Font.FredokaOne
TextLabel2.Text = "100"
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextScaled = true
TextLabel2.TextSize = 14
TextLabel2.TextStrokeTransparency = 0
TextLabel2.TextWrapped = true
GetBall = function()
    local v13 = nil
    for _, child in pairs(workspace.Balls:GetChildren()) do
        if child.Velocity ~= Vector3.new(0, 0, 0) then
            v13 = child
        end
    end
    return v13
end
Round = function(p1, p2)
    local v18 = math.pow(10, p2)
    local v19 = p1 * v18
    return (if v19 >= 0 then math.floor(v19 + 0.5) else math.ceil(v19 - 0.5)) / v18
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
        spam = not spam
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    Part.Transparency = getgenv().visualizer and 0.75 or 1
    clone.Transparency = getgenv().visualizer and 0 or 1
    clone2.Transparency = getgenv().visualizer and 0.9 or 1
    clone3.Transparency = getgenv().visualizer and 0.9 or 1
    BillboardGui.Enabled = getgenv().visualizer
    BillboardGui2.Enabled = getgenv().visualizer
    Part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    clone.CFrame = workspace.Balls:FindFirstChildOfClass("Part") and CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, workspace.Balls:FindFirstChildOfClass("Part").Position) or Part.CFrame
    clone2.CFrame = Part.CFrame
    clone3.CFrame = clone.CFrame
    local v22 = GetBall()
    if v22 then
        local Character = LocalPlayer.Character
        if Character then
            local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            BillboardGui.Adornee = HumanoidRootPart
            BillboardGui2.Adornee = v22
            local v25 = v22.Velocity.magnitude * 0.3
            local Unit = v22.Velocity.Unit
            local LookVector = CFrame.new(v22.Position, HumanoidRootPart.Position).LookVector
            local v28 = 1.1 - (Unit.Unit - LookVector.Unit).Magnitude / 4
            local v29 = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 9 + v25
            if v29 > 200 then
                v29 = 200
            end
            if v29 >= 200 and not spam then
                Part.Color = Color3.new(0, 1, 0)
                clone.Color = Color3.new(0, 1, 0)
            elseif v29 < 200 and not spam then
                Part.Color = Color3.new(1, 0, 0)
                clone.Color = Color3.new(1, 0, 0)
            end
            local v30 = v28 * v29
            Part.Mesh.Scale = Vector3.new(v30 / 9 * 0.067, 0.042, v30 / 9 * 0.067)
            clone.Mesh.Scale = Part.Mesh.Scale
            clone2.Mesh.Scale = Vector3.new(v29 / 9 * 0.067, 0.042, v29 / 9 * 0.067)
            clone3.Mesh.Scale = clone2.Mesh.Scale
            TextLabel.Text = tostring(Round(v30, 1))
            TextLabel2.Text = tostring(Round((v22.Position - HumanoidRootPart.Position).magnitude, 1))
            local v31 = Round(v28, 2)
            clone4.Text = (v31 == 1 and "1.0" or tostring(v31)) .. "x"
            if v30 >= (v22.Position - HumanoidRootPart.Position).magnitude then
                TextLabel2.TextColor3 = Color3.new(1, 0, 0)
            else
                TextLabel2.TextColor3 = Color3.new(1, 1, 1)
            end
            if not spam then
                if u1 and HumanoidRootPart and ((Character:FindFirstChild("Highlight") or v22:GetAttribute("target") == LocalPlayer.Name) and v30 >= (v22.Position - HumanoidRootPart.Position).magnitude) then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                    u1 = false
                    TextLabel.TextColor3 = Color3.new(1, 1, 0)
                    if Character:FindFirstChild("Highlight") or v22:GetAttribute("target") == LocalPlayer.Name then
                        local timestamp = tick()
                        repeat
                            game:GetService("RunService").RenderStepped:Wait()
                            local v33 = not (tick() - timestamp < 1)
                            if not v33 then
                                v33 = not Character:FindFirstChild("Highlight") and v22:GetAttribute("target") ~= LocalPlayer.Name
                            end
                        until v33
                    end
                    u1 = true
                    TextLabel.TextColor3 = Color3.new(1, 1, 1)
                end
            elseif spam then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                Part.Color = Color3.new(1, 0.5, 0)
                clone.Color = Color3.new(1, 0.5, 0)
            end
        end
    end
end)
