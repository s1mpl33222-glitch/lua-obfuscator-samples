-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
local v4 = getgenv and getgenv()
t1.value2 = v4
t1.value3 = 16531888
if not v4 then
    local value3 = t1.value3
    local v6 = _G or shared

    t1.value3 = value3
    t1.value2 = v6
end
local value2 = t1.value2
while not value2.STK_UI do
    task.wait(0.1)
end
local STK_UI = value2.STK_UI
t1.value2 = "ScreenGui"
t1.value1 = STK_UI.ScreenGui
t1.value2 = "mainFrame"
local _ = STK_UI.mainFrame
t1.value2 = "sidebarHeaderText"
t1.value3 = STK_UI.sidebarHeaderText
t1.value4 = t1.value3
t1.value2 = "CreateSidebarButton"
local CreateSidebarButton = STK_UI.CreateSidebarButton
t1.value2 = "CreateTab"
t1.value5 = CreateSidebarButton
local CreateTab = STK_UI.CreateTab
t1.value2 = "ShowTab"
t1.value6 = CreateTab
local ShowTab = STK_UI.ShowTab
t1.value2 = "CreateBlock"
t1.value7 = ShowTab
local CreateBlock = STK_UI.CreateBlock
t1.value2 = "EndBlock"
t1.value8 = CreateBlock
local EndBlock = STK_UI.EndBlock
t1.value2 = "CreateHeader"
t1.value9 = EndBlock
t1.value3 = STK_UI.CreateHeader
t1.value3 = STK_UI.CreateButton
t1.value10 = STK_UI.CreateToggle
t1.value2 = "CreateSlider"
t1.value11 = STK_UI.CreateSlider
t1.value2 = "CreateDropdown"
t1.value3 = STK_UI.CreateDropdown
t1.value3 = STK_UI.CreateColorPicker
t2.value1 = game:GetService("Players").LocalPlayer
t1.value2 = t2.value1:WaitForChild("PlayerGui")
t2.value2 = t1.value2
t1.value2 = game:GetService("UserInputService")
t2.value3 = t1.value2
t1.value2 = game:GetService("TweenService")
t2.value4 = t1.value2
t1.value2 = game:GetService("VirtualInputManager")
t2.value5 = t1.value2
t1.value2 = game:GetService("RunService")
t2.value6 = t1.value2
game:GetService("Lighting")
t1.value3 = workspace.CurrentCamera
t2.value7 = t1.value3
t1.value2 = game:GetService("ReplicatedStorage")
t2.value8 = t1.value2
t1.value3 = "Text"
t1.value2 = "Sell Fries"
t1.value4.Text = "Sell Fries"
function t1.value3(p1, p2, p3)
    local u36 = p3 or 2
    local CenterNotifyGui = t2.value2:FindFirstChild("CenterNotifyGui")

    if not CenterNotifyGui then
        CenterNotifyGui = Instance.new("ScreenGui")
        CenterNotifyGui.Name = "CenterNotifyGui"
        CenterNotifyGui.ResetOnSpawn = false
        CenterNotifyGui.DisplayOrder = 1000000
        CenterNotifyGui.Parent = t2.value2
    end

    local CenterCard = CenterNotifyGui:FindFirstChild("CenterCard")

    if CenterCard then
        CenterCard:Destroy()
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "CenterCard"
    Frame.Size = UDim2.new(0, 320, 0, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 28, 30)
    Frame.BackgroundTransparency = 0.05
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = CenterNotifyGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(0, 255, 200)
    UIStroke.Thickness = 1.2
    UIStroke.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.7
    UIScale.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 14)
    UIPadding.PaddingBottom = UDim.new(0, 16)
    UIPadding.PaddingLeft = UDim.new(0, 18)
    UIPadding.PaddingRight = UDim.new(0, 18)
    UIPadding.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, 16)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = string.format("%.1fs", u36)
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.Parent = Frame

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(1, 0, 0, 20)
    TextLabel2.Position = UDim2.new(0, 0, 0, 18)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = string.upper(p1 or "NOTIFICATION")
    TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 200)
    TextLabel2.Font = Enum.Font.GothamBold
    TextLabel2.TextSize = 14
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel2.Parent = Frame

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.new(1, 0, 0, 0)
    TextLabel3.Position = UDim2.new(0, 0, 0, 42)
    TextLabel3.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p2 or ""
    TextLabel3.TextColor3 = Color3.fromRGB(240, 240, 240)
    TextLabel3.Font = Enum.Font.SourceSansSemibold
    TextLabel3.TextSize = 16
    TextLabel3.TextWrapped = true
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel3.Parent = Frame
    t2.value4:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()

    local elapsed = os.clock()

    task.spawn(function()
        while Frame and Frame.Parent do
            local v197 = math.max(0, u36 - (os.clock() - elapsed))

            TextLabel.Text = string.format("%.1fs", v197)

            if v197 <= 0 then
                return
            end

            task.wait(0.05)
        end
    end)
    task.delay(u36, function()
        if Frame and Frame.Parent then
            local new = TweenInfo.new
            local EasingStyle = Enum.EasingStyle
            local v191 = t2.value4:Create(UIScale, new(0.2, EasingStyle.Quad, Enum.EasingDirection.In), {
				Scale = 0.6
			})
            local value4 = t2.value4
            local new2 = TweenInfo.new
            local Quad = Enum.EasingStyle.Quad
            local Create = value4.Create
            local EasingDirection = Enum.EasingDirection

            Create(value4, Frame, new2(0.2, Quad, EasingDirection.In), {
				BackgroundTransparency = 1
			}):Play()
            t2.value4:Create(UIStroke, TweenInfo.new(0.2), {
				Transparency = 1
			}):Play()
            t2.value4:Create(TextLabel, TweenInfo.new(0.2), {
				TextTransparency = 1
			}):Play()
            t2.value4:Create(TextLabel2, TweenInfo.new(0.2), {
				TextTransparency = 1
			}):Play()
            t2.value4:Create(TextLabel3, TweenInfo.new(0.2), {
				TextTransparency = 1
			}):Play()
            v191:Play()
            v191.Completed:Wait()
            Frame:Destroy()
        end
    end)
end
t2.value9 = t1.value3
t1.value5("Main", "rbxassetid://101988819289766")
t1.value6("Main")
t1.value7("Main")
t1.value8("Auto Play")
t2.value10 = {}
function t1.value3(p4)
    return p4 == t2.value10[1]
end
t2.value11 = t1.value3
local Remotes = t2.value8:FindFirstChild("Remotes")

t1.value2 = Remotes
if not Remotes then
    local value3 = t1.value3

    t1.value12 = t2.value8:FindFirstChild("Shared") and t2.value8.Shared:FindFirstChild("Remotes")
    t1.value2 = t1.value12
    t1.value3 = value3
end
t2.value12 = t1.value2
t1.value2 = t2.value12 and t2.value12:FindFirstChild("ShutterPress")
t2.value13 = t1.value2
t1.value2 = t2.value12 and t2.value12:FindFirstChild("DropPotato")
t1.value14 = nil
t1.value15 = false
t2.value14 = nil
t2.value15 = t1.value2
t1.value16 = nil
t1.value13 = false
t1.value17 = nil
t1.value18 = nil
t1.value19 = 0
t1.value2 = "AutoFillCrateIsEnabled"
t2.value16 = {
	AutoFillCrateIsEnabled = t1.value13,
	AutoFillCrateOriginalCFrame = t1.value16,
	AutoFillCrateMaxCapacity = t1.value17,
	AutoFillCrateLastTool = t1.value18
}
function t1.value3(p5)
    if p5:IsA("Model") then
        local PrimaryPart = p5.PrimaryPart

        if PrimaryPart then
            return PrimaryPart.CFrame
        end

        return p5:GetPivot()
    end

    return p5.CFrame
end
t2.value17 = t1.value3
local function v17()
    local PotatoSpawnPart = workspace:FindFirstChild("PotatoSpawnPart")

    if PotatoSpawnPart and PotatoSpawnPart:IsA("BasePart") then
        return PotatoSpawnPart.Position
    end

    local PotatoPile = workspace:FindFirstChild("PotatoPile")

    if PotatoPile then
        if PotatoPile:IsA("Model") then
            return PotatoPile:GetPivot().Position
        end

        if PotatoPile:IsA("BasePart") then
            return PotatoPile.Position
        end

        local BasePart = PotatoPile:FindFirstChildWhichIsA("BasePart")

        if BasePart then
            return BasePart.Position
        end
    end

    return Vector3.new(104, 1, 18)
end
local function v18()
    local PotatoPile = workspace:FindFirstChild("PotatoPile")
    if not PotatoPile then
        return nil
    end
    local v58
    local GetChildren = PotatoPile.GetChildren
    for _, v in ipairs(GetChildren(PotatoPile)) do
        if not (v:IsA("MeshPart") and v.Name == "Potato") then
            continue
        end

        if v:FindFirstChild("MutationLight", true) then
            return v
        end

        if not v58 then
            v58 = v
        end
    end

    return v58
end
function t1.value3()
    if t2.value16.AutoFillCrateMaxCapacity and t2.value16.AutoFillCrateMaxCapacity > 0 then
        return t2.value16.AutoFillCrateMaxCapacity
    end

    local v62 = game:GetService("Players").LocalPlayer or t2.value1
    local Character = v62.Character
    local Tool = v62:GetAttribute("Tool")
    local v65 = Tool == "GoldenVacuum"

    if not v65 then
        v65 = Character

        if Character then
            v65 = Character:FindFirstChild("GoldenVacuum") ~= nil
        end

        if not v65 then
            v65 = Character

            if Character then
                v65 = Character:FindFirstChildOfClass("Tool")

                if v65 then
                    local FindFirstChildOfClass = Character.FindFirstChildOfClass

                    v65 = string.find(FindFirstChildOfClass(Character, "Tool").Name:lower(), "goldenvacuum") ~= nil
                end
            end
        end
    end

    if v65 then
        return 20
    end

    local v67 = Tool == "Vacuum"

    if not v67 then
        v67 = Character

        if Character then
            v67 = Character:FindFirstChild("Vacuum") ~= nil
        end

        if not v67 then
            v67 = Character

            if Character then
                v67 = Character:FindFirstChildOfClass("Tool") and string.find(Character:FindFirstChildOfClass("Tool").Name:lower(), "vacuum") ~= nil
            end
        end
    end

    if v67 then
        return 18
    end

    local v68 = Tool == "Bucket"

    if not v68 then
        v68 = Tool == "VipBucket"
    end

    if not v68 then
        v68 = Character

        if Character then
            v68 = Character:FindFirstChild("Bucket") ~= nil or Character:FindFirstChild("VipBucket") ~= nil
        end

        if not v68 then
            if Character then
                local Tool2 = Character:FindFirstChildOfClass("Tool")

                if Tool2 then
                    local FindFirstChildOfClass = Character.FindFirstChildOfClass

                    Tool2 = string.find(FindFirstChildOfClass(Character, "Tool").Name:lower(), "bucket") ~= nil
                end

                Character = Tool2
            end

            v68 = Character
        end
    end

    if v68 then
        return 7
    end

    return 1
end
t2.value18 = t1.value3
local function v19(p6, p7)
    if p7 then
        p7.AssemblyLinearVelocity = Vector3.zero
        p7.AssemblyAngularVelocity = Vector3.zero
    end

    if p6 then
        p6:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        p6:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        p6:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end
t2.value19 = {
	AutoShutterIsEnabled = false,
	AutoShutterLastPress = t1.value19,
	AutoShutterIsBusy = t1.value15
}
local function v20()
    if t2.value13 and t2.value13.Parent then
        return t2.value13
    end

    local Remotes2 = t2.value8:FindFirstChild("Remotes")

    if not Remotes2 then
        Remotes2 = t2.value8:FindFirstChild("Shared") and t2.value8.Shared:FindFirstChild("Remotes")
    end

    if Remotes2 and Remotes2:FindFirstChild("ShutterPress") then
        t2.value13 = Remotes2.ShutterPress

        return t2.value13
    end

    return nil
end
function t1.value3()
    local DriveThru = workspace:FindFirstChild("DriveThru")

    if not DriveThru then
        return nil
    end

    local Shutter = DriveThru:FindFirstChild("Shutter")

    if Shutter then
        return Shutter
    end

    local Window = DriveThru:FindFirstChild("Window")

    if Window and Window:FindFirstChild("Shutter") then
        return Window.Shutter
    end

    return DriveThru:FindFirstChildWhichIsA("Model", true)
end
t2.value20 = t1.value3
function t1.value3()
    local DriveThru = workspace:FindFirstChild("DriveThru")

    if not DriveThru then
        return false
    end

    if DriveThru:GetAttribute("CarWaiting") ~= true then
        return false
    end

    if DriveThru:GetAttribute("PatienceKind") == "Possessed" then
        return true
    end

    local Car = DriveThru:FindFirstChild("Car")

    if Car and Car:IsA("Model") then
        local Visit = Car:GetAttribute("Visit")
        local v85 = Visit == "Leaving"

        if not v85 then
            v85 = Visit == "Parking" or Car:GetAttribute("Unserved") ~= nil
        end

        if v85 then
            return false
        end

        local v86 = Car:GetAttribute("Possessed") == true

        if not v86 then
            v86 = Car:GetAttribute("Anomaly") ~= nil or typeof(Car:GetAttribute("Anomaly")) == "string"
        end

        if v86 then
            return true
        end

        local Driver = Car:FindFirstChild("Driver")

        if Driver then
            Driver = Driver:GetAttribute("Possessed") == true or Driver:GetAttribute("Anomaly") ~= nil
        end

        if Driver then
            return true
        end
    end

    return false
end
t2.value21 = t1.value3
local function v21()
    if not t2.value19.AutoShutterIsEnabled then
        return false
    end

    local v88 = t2.value20()

    if not v88 then
        return false
    end

    if v88:GetAttribute("ShutterMoving") == true then
        return false
    end

    local v89 = v88:GetAttribute("ShutterTo") or 0
    local v90 = t2.value21()
    local v91 = v90 and v89 == 0

    if not v91 then
        v91 = not v90 and v89 == 1
    end

    return v91
end
function t2.value14()
    if not t2.value19.AutoShutterIsEnabled then
        return false
    end

    if t2.value19.AutoShutterIsBusy then
        return true
    end

    return v21()
end
local function v22(p8, p9)
    if p9 then
        p9.AssemblyLinearVelocity = Vector3.zero
        p9.AssemblyAngularVelocity = Vector3.zero
    end

    if p8 then
        p8:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        p8:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        p8:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end
function t1.value3(p10, p11)
    local DriveThru = workspace:FindFirstChild("DriveThru")
    local Position
    local v98
    if DriveThru then
        local v99 = DriveThru:FindFirstChild("ShutterButton", true) or DriveThru:FindFirstChild("Button", true)

        if v99 and v99:IsA("BasePart") then
            Position = v99.Position
            v98 = v99.Position + Vector3.new(2.5, 0, 0)
        else
            local v100 = t2.value20()
            local v101 = v100

            if v100 then
                v101 = v100:IsA("BasePart") and v100

                if not v101 then
                    v101 = v100:FindFirstChildWhichIsA("BasePart", true)
                end
            end

            if v101 then
                Position = v101.Position
                v98 = v101.Position + Vector3.new(2.5, 0, 0)
            else
                local Window = DriveThru:FindFirstChild("Window", true)
                local v103 = Window

                if Window then
                    v103 = Window:IsA("BasePart") and Window

                    if not v103 then
                        v103 = Window:FindFirstChildWhichIsA("BasePart", true)
                    end
                end

                if v103 then
                    Position = v103.Position
                    v98 = v103.Position + Vector3.new(2.5, 0, 0)
                end
            end
        end
    end
    if not v98 then
        v98 = Vector3.new(14.5, 2.5, 23.5)
        Position = Vector3.new(11.8, 2.5, 23.5)
    end
    local v104 = math.max(v98.X, 14.2)
    local Z = v98.Z
    local Character = t2.value1.Character
    local n1 = 1
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    if Character then
        raycastParams.FilterDescendantsInstances = { Character }
    end
    local raycastResult = workspace:Raycast(Vector3.new(v104, 15, Z), Vector3.new(0, -30, 0), raycastParams)
    if raycastResult then
        n1 = raycastResult.Position.Y
    end
    if p10 then
        p10 = p10.HipHeight
    end
    local v110 = n1 + ((p10 or 2) + (p11 and p11.Size.Y * 0.5 or 1) + 0.1)

    return CFrame.lookAt(Vector3.new(v104, v110, Z), Vector3.new(Position.X, v110, Position.Z))
end
t2.value22 = t1.value3
function t1.value3()
    local v111 = t2.value20()

    if not v111 then
        return
    end

    if v111:GetAttribute("ShutterMoving") == true then
        return
    end

    local elapsed = os.clock()

    if elapsed - t2.value19.AutoShutterLastPress < 0.6 then
        return
    end

    local v113 = v20()

    if not v113 then
        return
    end

    local v114 = v111:GetAttribute("ShutterTo") or 0
    local v115 = t2.value21()
    local v116 = v115 and v114 == 0

    if not v116 then
        v116 = not v115 and v114 == 1
    end

    if v116 then
        t2.value19.AutoShutterIsBusy = true

        local Character = t2.value1.Character
        local v118 = Character and Character:FindFirstChildOfClass("Humanoid")
        local v119 = Character and Character:FindFirstChild("HumanoidRootPart")

        if Character then
            Character = v118

            if v118 then
                Character = v118.Health > 0 and v119
            end
        end

        if Character then
            local v120 = t2.value22(v118, v119)

            if v120 then
                v22(v118, v119)
                v119.CFrame = v120
                task.wait(0.2)
            end
        end

        t2.value19.AutoShutterLastPress = elapsed
        v113:FireServer()
        task.wait(0.2)
        t2.value19.AutoShutterIsBusy = false
    end
end
t2.value23 = t1.value3
t1.value10("Auto Fill Crate", function(p12)
    t2.value16.AutoFillCrateIsEnabled = p12

    if not p12 then
        local v78 = table.find(t2.value10, "Crate")

        if v78 then
            table.remove(t2.value10, v78)
        end

        t2.value16.AutoFillCrateMaxCapacity = nil
        t2.value16.AutoFillCrateLastTool = nil

        local Character = t2.value1.Character
        local v80 = Character and Character:FindFirstChildOfClass("Humanoid")
        local v81 = Character and Character:FindFirstChild("HumanoidRootPart")

        if v80 then
            v80:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            v80:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end

        if v81 and t2.value16.AutoFillCrateOriginalCFrame then
            v81.AssemblyLinearVelocity = Vector3.zero
            v81.AssemblyAngularVelocity = Vector3.zero
            v81.CFrame = t2.value16.AutoFillCrateOriginalCFrame
            t2.value16.AutoFillCrateOriginalCFrame = nil
        end
    end

    if p12 then
        if not table.find(t2.value10, "Crate") then
            table.insert(t2.value10, "Crate")
        end

        task.spawn(function()
            local v198 = game:GetService("Players").LocalPlayer or t2.value1
            local g216
            while t2.value16.AutoFillCrateIsEnabled do
                if not t2.value11("Crate") then
                    task.wait(0.3)
                else
                    while t2.value16.AutoFillCrateIsEnabled and t2.value14() do
                        task.wait(0.2)
                    end

                    if t2.value16.AutoFillCrateIsEnabled and t2.value11("Crate") then
                        local Character = v198.Character
                        local v200 = Character and Character:FindFirstChildOfClass("Humanoid")
                        local v201 = Character and Character:FindFirstChild("HumanoidRootPart")
                        if Character then
                            Character = v200 and v200.Health > 0 and v201
                        end
                        if Character then
                            if not t2.value16.AutoFillCrateOriginalCFrame then
                                t2.value16.AutoFillCrateOriginalCFrame = v201.CFrame
                            end

                            local Tool = v198:GetAttribute("Tool")

                            if Tool ~= t2.value16.AutoFillCrateLastTool then
                                t2.value16.AutoFillCrateLastTool = Tool
                                t2.value16.AutoFillCrateMaxCapacity = nil
                            end

                            v19(v200, v201)

                            local v203 = v18()
                            local Map = workspace:FindFirstChild("Map")

                            if Map then
                                Map = workspace.Map:FindFirstChild("Kitchen") and workspace.Map.Kitchen:FindFirstChild("KitchenAppliances")
                            end

                            local v205 = Map and Map:FindFirstChild("PotatoCrate")

                            if v203 and v205 then
                                local GetAttribute = v198.GetAttribute
                                local value18 = t2.value18
                                local v208 = value18()

                                if v208 > (GetAttribute(v198, "CarryCount") or 0) then
                                    local v209 = v17()
                                    local v210 = (v203.Position - v209) * Vector3.new(1, 0, 1)
                                    local v211 = if not (v210.Magnitude < 0.1) then v210.Unit else Vector3.new(0, 0, 1)
                                    local v212 = v203.Position + v211 * 4 + Vector3.new(0, 1.8, 0)

                                    while t2.value16.AutoFillCrateIsEnabled and t2.value14() do
                                        task.wait(0.2)
                                    end

                                    if t2.value16.AutoFillCrateIsEnabled and t2.value11("Crate") then
                                        v19(v200, v201)
                                        v201.CFrame = CFrame.lookAt(v212, Vector3.new(v203.Position.X, v212.Y, v203.Position.Z))
                                        t2.value7.CFrame = CFrame.lookAt(t2.value7.CFrame.Position, v203.Position)
                                        task.wait(0.4)

                                        local v213 = 1 < 0
                                        local n2 = 0

                                        repeat
                                            n2 += 1

                                            local v215 = not v213 and n2 <= v208
                                            local v217

                                            repeat
                                                if not g216 and v213 then
                                                    v217 = true

                                                    if not (v208 <= n2) then
                                                        g216 = true
                                                    end
                                                else
                                                    g216 = false
                                                    v217 = v215
                                                end
                                            until not g216

                                            if not v217 then
                                                break
                                            end

                                            local v218 = not t2.value16.AutoFillCrateIsEnabled

                                            if not v218 then
                                                v218 = not t2.value11("Crate") or t2.value14()
                                            end

                                            if v218 then
                                                break
                                            end

                                            if not v203 or not v203.Parent then
                                                v203 = v18()
                                            end

                                            if v208 <= (v198:GetAttribute("CarryCount") or 0) then
                                                break
                                            end

                                            if v203 then
                                                t2.value7.CFrame = CFrame.lookAt(t2.value7.CFrame.Position, v203.Position)

                                                local v219, v220 = t2.value7:WorldToViewportPoint(v203.Position)

                                                if v220 then
                                                    local X = v219.X
                                                    local Y = v219.Y
                                                    local _game = game

                                                    t2.value5:SendMouseButtonEvent(X, Y, 0, true, _game, 0)
                                                    task.wait(0.02)
                                                    t2.value5:SendMouseButtonEvent(v219.X, v219.Y, 0, false, game, 0)
                                                end
                                            end

                                            task.wait(0.2)
                                        until v208 == 1

                                        task.wait(0.4)

                                        local v224 = v198:GetAttribute("CarryCount") or 0

                                        if v224 > 0 then
                                            if not t2.value16.AutoFillCrateMaxCapacity then
                                                t2.value16.AutoFillCrateMaxCapacity = v224
                                            else
                                                t2.value16.AutoFillCrateMaxCapacity = math.max(t2.value16.AutoFillCrateMaxCapacity, v224)
                                            end
                                        end
                                    end
                                end

                                local AutoFillCrateIsEnabled = t2.value16.AutoFillCrateIsEnabled

                                if AutoFillCrateIsEnabled then
                                    AutoFillCrateIsEnabled = t2.value11("Crate") and (v198:GetAttribute("CarryCount") or 0) > 0
                                end

                                if AutoFillCrateIsEnabled then
                                    while t2.value16.AutoFillCrateIsEnabled and t2.value14() do
                                        task.wait(0.2)
                                    end

                                    local Position = t2.value17(v205).Position
                                    local vector3 = Vector3.new(56.733, 3.998, 19.454)

                                    v19(v200, v201)
                                    v201.CFrame = CFrame.lookAt(vector3, Vector3.new(Position.X, vector3.Y, Position.Z))

                                    local v228 = vector3 + Vector3.new(0, 1.5, 0)

                                    t2.value7.CFrame = CFrame.lookAt(v228, Position)
                                    task.wait(0.2)

                                    local KeyCode = Enum.KeyCode

                                    t2.value5:SendKeyEvent(true, KeyCode.E, false, game)
                                    task.wait(0.15)
                                    t2.value5:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                end
                            else
                                task.wait(0.8)
                            end
                        else
                            task.wait(0.8)
                        end
                        task.wait(0.5)
                    else
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)
t1.value2 = "AutoFillConveyorIsEnabled"
t2.value24 = nil
t2.value25 = {
	AutoFillConveyorIsEnabled = false,
	AutoFillConveyorOriginalCFrame = t1.value14,
	AutoFillConveyorMaxCapacity = nil,
	AutoFillConveyorLastTool = nil
}
function t1.value3(p13)
    if p13:IsA("Model") then
        local PrimaryPart = p13.PrimaryPart

        if PrimaryPart then
            return PrimaryPart.CFrame
        end

        return p13:GetPivot()
    end

    return p13.CFrame
end
t2.value26 = t1.value3
local function v23()
    local PotatoSpawnPart = workspace:FindFirstChild("PotatoSpawnPart")

    if PotatoSpawnPart and PotatoSpawnPart:IsA("BasePart") then
        return PotatoSpawnPart.Position
    end

    local PotatoPile = workspace:FindFirstChild("PotatoPile")

    if PotatoPile then
        if PotatoPile:IsA("Model") then
            return PotatoPile:GetPivot().Position
        end

        if PotatoPile:IsA("BasePart") then
            return PotatoPile.Position
        end

        local BasePart = PotatoPile:FindFirstChildWhichIsA("BasePart")

        if BasePart then
            return BasePart.Position
        end
    end

    return Vector3.new(104, 1, 18)
end
local function v24()
    local PotatoPile = workspace:FindFirstChild("PotatoPile")
    if not PotatoPile then
        return nil
    end
    local v127
    local GetChildren = PotatoPile.GetChildren
    for _, v in ipairs(GetChildren(PotatoPile)) do
        if not (v:IsA("MeshPart") and v.Name == "Potato") then
            continue
        end

        if v:FindFirstChild("MutationLight", true) then
            return v
        end

        if not v127 then
            v127 = v
        end
    end

    return v127
end
function t1.value3()
    if t2.value25.AutoFillConveyorMaxCapacity and t2.value25.AutoFillConveyorMaxCapacity > 0 then
        return t2.value25.AutoFillConveyorMaxCapacity
    end

    local v131 = game:GetService("Players").LocalPlayer or t2.value1
    local Character = v131.Character
    local Tool = v131:GetAttribute("Tool")
    local v134 = Tool == "GoldenVacuum"

    if not v134 then
        v134 = Character and Character:FindFirstChild("GoldenVacuum") ~= nil

        if not v134 then
            v134 = Character

            if Character then
                v134 = Character:FindFirstChildOfClass("Tool")

                if v134 then
                    local _string = string
                    local FindFirstChildOfClass = Character.FindFirstChildOfClass

                    v134 = _string.find(FindFirstChildOfClass(Character, "Tool").Name:lower(), "goldenvacuum") ~= nil
                end
            end
        end
    end

    if v134 then
        return 20
    end

    local v137 = Tool == "Vacuum"

    if not v137 then
        v137 = Character

        if Character then
            v137 = Character:FindFirstChild("Vacuum") ~= nil
        end

        if not v137 then
            v137 = Character

            if Character then
                v137 = Character:FindFirstChildOfClass("Tool") and string.find(Character:FindFirstChildOfClass("Tool").Name:lower(), "vacuum") ~= nil
            end
        end
    end

    if v137 then
        return 18
    end

    local v138 = Tool == "Bucket" or Tool == "VipBucket"

    if not v138 then
        v138 = Character

        if Character then
            v138 = Character:FindFirstChild("Bucket") ~= nil or Character:FindFirstChild("VipBucket") ~= nil
        end

        if not v138 then
            if Character then
                Character = Character:FindFirstChildOfClass("Tool") and string.find(Character:FindFirstChildOfClass("Tool").Name:lower(), "bucket") ~= nil
            end

            v138 = Character
        end
    end

    if v138 then
        return 7
    end

    return 1
end
t2.value27 = t1.value3
function t1.value3(p14, p15)
    if p15 then
        p15.AssemblyLinearVelocity = Vector3.zero
        p15.AssemblyAngularVelocity = Vector3.zero
    end

    if p14 then
        p14:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        p14:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        p14:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end
t2.value24 = t1.value3
t1.value10("Auto Fill Conveyor", function(p16)
    t2.value25.AutoFillConveyorIsEnabled = p16

    if not p16 then
        local v142 = table.find(t2.value10, "Conveyor")

        if v142 then
            table.remove(t2.value10, v142)
        end

        t2.value25.AutoFillConveyorMaxCapacity = nil
        t2.value25.AutoFillConveyorLastTool = nil

        local Character = t2.value1.Character
        local v144 = Character and Character:FindFirstChildOfClass("Humanoid")
        local v145 = Character and Character:FindFirstChild("HumanoidRootPart")

        if v144 then
            v144:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            v144:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end

        if v145 and t2.value25.AutoFillConveyorOriginalCFrame then
            v145.AssemblyLinearVelocity = Vector3.zero
            v145.AssemblyAngularVelocity = Vector3.zero
            v145.CFrame = t2.value25.AutoFillConveyorOriginalCFrame
            t2.value25.AutoFillConveyorOriginalCFrame = nil
        end
    end

    if p16 then
        local Map = workspace:FindFirstChild("Map")

        if Map then
            Map = workspace.Map:FindFirstChild("Kitchen") and workspace.Map.Kitchen:FindFirstChild("KitchenBody")
        end

        if not Map or not Map:FindFirstChild("FirstConveyor") then
            t2.value9("Auto Fill Conveyor", "Please buy the conveyor first", 3)
        end

        if not table.find(t2.value10, "Conveyor") then
            table.insert(t2.value10, "Conveyor")
        end

        task.spawn(function()
            local v230 = game:GetService("Players").LocalPlayer or t2.value1
            local value15 = t2.value15

            if not value15 then
                value15 = t2.value12 and t2.value12:FindFirstChild("DropPotato")
            end

            local n3 = 0

            while t2.value25.AutoFillConveyorIsEnabled do
                if not t2.value11("Conveyor") then
                    task.wait(0.3)
                else
                    while t2.value25.AutoFillConveyorIsEnabled and t2.value14() do
                        task.wait(0.2)
                    end

                    if t2.value25.AutoFillConveyorIsEnabled and t2.value11("Conveyor") then
                        local Character = v230.Character
                        local v234 = Character and Character:FindFirstChildOfClass("Humanoid")
                        local v235 = Character and Character:FindFirstChild("HumanoidRootPart")

                        if Character and (v234 and (v234.Health > 0 and v235)) then
                            if not t2.value25.AutoFillConveyorOriginalCFrame then
                                t2.value25.AutoFillConveyorOriginalCFrame = v235.CFrame
                            end

                            local Tool = v230:GetAttribute("Tool")

                            if Tool ~= t2.value25.AutoFillConveyorLastTool then
                                t2.value25.AutoFillConveyorLastTool = Tool
                                Tool = nil
                                AutoFillConveyorMaxCapacity = Tool
                            end

                            t2.value24(v234, v235)

                            local v237 = v24()
                            local Map2 = workspace:FindFirstChild("Map")

                            if Map2 then
                                Map2 = workspace.Map:FindFirstChild("Kitchen") and workspace.Map.Kitchen:FindFirstChild("KitchenBody")
                            end

                            local v239 = Map2 and Map2:FindFirstChild("FirstConveyor")

                            if not v239 then
                                if os.clock() - n3 > 4 then
                                    n3 = os.clock()
                                end

                                task.wait(0.8)
                            elseif v237 and v239 then
                                local v240 = t2.value27()

                                if v240 > (v230:GetAttribute("CarryCount") or 0) then
                                    local v241 = v23()
                                    local v242 = (v237.Position - v241) * Vector3.new(1, 0, 1)
                                    local v243 = if not (v242.Magnitude < 0.1) then v242.Unit else Vector3.new(0, 0, 1)
                                    local v244 = v237.Position + v243 * 4 + Vector3.new(0, 1.8, 0)

                                    while t2.value25.AutoFillConveyorIsEnabled and t2.value14() do
                                        task.wait(0.2)
                                    end

                                    if t2.value25.AutoFillConveyorIsEnabled and t2.value11("Conveyor") then
                                        t2.value24(v234, v235)
                                        v235.CFrame = CFrame.lookAt(v244, Vector3.new(v237.Position.X, v244.Y, v237.Position.Z))
                                        t2.value7.CFrame = CFrame.lookAt(t2.value7.CFrame.Position, v237.Position)
                                        task.wait(0.4)

                                        for _ = 1, v240 do
                                            local v246 = not t2.value25.AutoFillConveyorIsEnabled

                                            if not v246 then
                                                v246 = not t2.value11("Conveyor")

                                                if not v246 then
                                                    v246 = t2.value14()
                                                end
                                            end

                                            if v246 then
                                                break
                                            end

                                            if not v237 or not v237.Parent then
                                                v237 = v24()
                                            end

                                            if v240 <= (v230:GetAttribute("CarryCount") or 0) then
                                                break
                                            end

                                            if v237 then
                                                t2.value7.CFrame = CFrame.lookAt(t2.value7.CFrame.Position, v237.Position)

                                                local v247, v248 = t2.value7:WorldToViewportPoint(v237.Position)

                                                if v248 then
                                                    local X = v247.X
                                                    local Y = v247.Y
                                                    local _game = game

                                                    t2.value5:SendMouseButtonEvent(X, Y, 0, true, _game, 0)
                                                    task.wait(0.02)
                                                    t2.value5:SendMouseButtonEvent(v247.X, v247.Y, 0, false, game, 0)
                                                end
                                            end

                                            task.wait(0.2)

                                            if v240 == 1 then
                                                break
                                            end
                                        end

                                        task.wait(0.4)

                                        local v252 = v230:GetAttribute("CarryCount") or 0

                                        if v252 > 0 then
                                            if not t2.value25.AutoFillConveyorMaxCapacity then
                                                t2.value25.AutoFillConveyorMaxCapacity = v252
                                            else
                                                t2.value25.AutoFillConveyorMaxCapacity = math.max(t2.value25.AutoFillConveyorMaxCapacity, v252)
                                            end
                                        end
                                    end
                                end

                                local AutoFillConveyorIsEnabled = t2.value25.AutoFillConveyorIsEnabled

                                if AutoFillConveyorIsEnabled then
                                    AutoFillConveyorIsEnabled = t2.value11("Conveyor")

                                    if AutoFillConveyorIsEnabled then
                                        AutoFillConveyorIsEnabled = (v230:GetAttribute("CarryCount") or 0) > 0
                                    end
                                end

                                if AutoFillConveyorIsEnabled then
                                    while t2.value25.AutoFillConveyorIsEnabled and t2.value14() do
                                        task.wait(0.2)
                                    end

                                    local Position = t2.value26(v239).Position
                                    local vector3 = Vector3.new(66.091, 3.998, 4.5)

                                    t2.value24(v234, v235)
                                    v235.CFrame = CFrame.lookAt(vector3, Vector3.new(Position.X, vector3.Y, Position.Z))

                                    local v256 = vector3 + Vector3.new(0, 1.5, 0)

                                    t2.value7.CFrame = CFrame.lookAt(v256, Position)
                                    task.wait(0.2)

                                    local vector3_2 = Vector3.new(38.138423919678, 5.8279433250427, 27.00364112854)
                                    local vector3_3 = Vector3.new(0.21427717804909, -0.66082519292831, -0.71930199861526)
                                    local t3 = {
										[1] = vector3_2,
										[2] = vector3_3,
										[3] = 91
									}

                                    if value15 then
                                        for _ = 1, v240 * 2 do
                                            local v261 = not t2.value25.AutoFillConveyorIsEnabled

                                            if not v261 then
                                                v261 = not t2.value11("Conveyor") or t2.value14()
                                            end

                                            if v261 then
                                                break
                                            end

                                            local t4 = { unpack(t3) }

                                            value15:FireServer(v3(t4))
                                            task.wait(0.05)
                                        end
                                    end
                                end
                            else
                                task.wait(0.8)
                            end
                        else
                            task.wait(0.8)
                        end

                        task.wait(0.5)
                    else
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)
t1.value10("Auto Close Window", function(p17)
    t2.value19.AutoShutterIsEnabled = p17

    if not p17 then
        local Character = t2.value1.Character
        local v149 = Character and Character:FindFirstChildOfClass("Humanoid")

        if v149 then
            v149:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            v149:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end

    if p17 then
        task.spawn(function()
            while t2.value19.AutoShutterIsEnabled do
                t2.value23()
                task.wait(0.2)
            end
        end)
    end
end)
t1.value2 = "AutoServerIsEnabled"
t2.value28 = nil
t2.value29 = {
	AutoServerIsEnabled = false,
	AutoServerCooldown = 0.5,
	AutoServerLastAction = 0
}
local function v25()
    local DriveThru = workspace:FindFirstChild("DriveThru")

    if not DriveThru then
        return false
    end

    if DriveThru:GetAttribute("PatienceKind") == "Possessed" then
        return true
    end

    local Car = DriveThru:FindFirstChild("Car")

    if Car and Car:IsA("Model") then
        local v152 = Car:GetAttribute("Possessed") == true

        if not v152 then
            v152 = Car:GetAttribute("Anomaly") ~= nil

            if not v152 then
                v152 = typeof(Car:GetAttribute("Anomaly")) == "string"
            end
        end

        if v152 then
            return true
        end

        local Driver = Car:FindFirstChild("Driver")

        if Driver then
            Driver = Driver:GetAttribute("Possessed") == true or Driver:GetAttribute("Anomaly") ~= nil
        end

        if Driver then
            return true
        end
    end

    return false
end
function t1.value3()
    local DriveThru = workspace:FindFirstChild("DriveThru")

    if not DriveThru then
        return false
    end

    local Car = DriveThru:FindFirstChild("Car")

    if Car and Car:IsA("Model") then
        return true
    end

    if DriveThru:GetAttribute("HasCustomer") == true or DriveThru:GetAttribute("Order") ~= nil then
        return true
    end

    return false
end
t2.value30 = t1.value3
local function v26()
    local DriveThru = workspace:FindFirstChild("DriveThru")

    if not DriveThru then
        return
    end

    local v158 = t2.value20()

    if v158 and v158:GetAttribute("ShutterTo") == 1 then
        return
    end

    local Remotes3 = t2.value8:FindFirstChild("Remotes")

    if not Remotes3 then
        Remotes3 = t2.value8:FindFirstChild("Shared") and t2.value8.Shared:FindFirstChild("Remotes")
    end

    if Remotes3 then
        local ServeCustomer = Remotes3:FindFirstChild("ServeCustomer")

        if not ServeCustomer then
            ServeCustomer = Remotes3:FindFirstChild("ServeOrder")

            if not ServeCustomer then
                ServeCustomer = Remotes3:FindFirstChild("ServePotato")

                if not ServeCustomer then
                    ServeCustomer = Remotes3:FindFirstChild("DriveThruServe") or Remotes3:FindFirstChild("GiveOrder")
                end
            end
        end

        if ServeCustomer then
            ServeCustomer:FireServer()
        end
    end

    local GetDescendants = DriveThru.GetDescendants

    for _, v in ipairs(GetDescendants(DriveThru)) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if fireproximityprompt then
                fireproximityprompt(v)
            else
                local KeyCode = Enum.KeyCode

                t2.value5:SendKeyEvent(true, KeyCode.E, false, game)
                task.wait(0.1)
                t2.value5:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end
        end
    end
end
function t2.value28()
    local elapsed = os.clock()

    if elapsed - t2.value29.AutoServerLastAction < t2.value29.AutoServerCooldown then
        return
    end

    if not t2.value30() then
        return
    end

    if v25() then
        return
    end

    t2.value29.AutoServerLastAction = elapsed
    v26()
end
t1.value10("Auto Serve Customers", function(p18)
    t2.value29.AutoServerIsEnabled = p18

    if p18 then
        task.spawn(function()
            while t2.value29.AutoServerIsEnabled do
                t2.value28()
                task.wait(0.25)
            end
        end)
    end
end)
t1.value9()
t1.value8("Misc")
t1.value2 = "Movement"
t1.value9()
t1.value5("Movement", "rbxassetid://104433470689984")
t1.value6("Movement")
t1.value2 = "Movement"
t1.value7("Movement")
t1.value8("Speed")
t2.value31 = {
	SpeedHumanoid = nil,
	SpeedRootPart = nil,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil
}
function t1.value3()
    local connection = t2.value6.Heartbeat:Connect(function()
        if not t2.value31.SpeedRootPart or not t2.value31.SpeedRootPart.Parent then
            return
        end

        if t2.value31.SpeedIsEnabled then
            if not t2.value31.SpeedHumanoid then
                return
            end

            local MoveDirection = t2.value31.SpeedHumanoid.MoveDirection

            if MoveDirection.Magnitude > 0 then
                t2.value31.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * t2.value31.SpeedValue, t2.value31.SpeedRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * t2.value31.SpeedValue)

                return
            end

            t2.value31.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, t2.value31.SpeedRootPart.AssemblyLinearVelocity.Y, 0)
        end
    end)

    return function()
        connection:Disconnect()
    end
end
t2.value32 = t1.value3
t1.value2 = t2.value1
local function v27(p19)
    t2.value31.SpeedHumanoid = p19:WaitForChild("Humanoid")
    t2.value31.SpeedRootPart = p19:WaitForChild("HumanoidRootPart")

    if t2.value31.SpeedIsEnabled then
        if t2.value31.SpeedStopCallback then
            t2.value31.SpeedStopCallback()
        end

        t2.value31.SpeedStopCallback = t2.value32()
    end
end
if t1.value2.Character then
    task.spawn(v27, t2.value1.Character)
end
t1.value3 = t2.value1.CharacterAdded
t1.value3:Connect(v27)
t1.value2 = "Enable"
t1.value21 = "Min"
t1.value10("Enable", function(p20)
    if p20 == t2.value31.SpeedIsEnabled then
        return
    end

    t2.value31.SpeedIsEnabled = p20

    if t2.value31.SpeedStopCallback then
        t2.value31.SpeedStopCallback()
        t2.value31.SpeedStopCallback = nil
    end

    if t2.value31.SpeedIsEnabled then
        t2.value31.SpeedStopCallback = t2.value32()
    end
end)
t1.value20 = "Speed"
local SpeedValue = t2.value31.SpeedValue
t1.value11({
	Text = "Speed",
	Min = 16,
	Max = 300,
	Default = SpeedValue,
	Callback = function(p21)
    t2.value31.SpeedValue = p21
end
})
t1.value2 = "Fly"
t1.value20 = "FlyRootPart"
t1.value9()
t1.value8("Fly")
t1.value2 = "FlyCharacter"
t2.value33 = {
	FlyCharacter = nil,
	FlyRootPart = nil,
	FlyHumanoid = nil,
	FlyIsEnabled = false,
	FlySpeed = 16,
	FlyStopCallback = nil
}
local function v29()
    local BodyVelocity = Instance.new("BodyVelocity")

    BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.P = 1250
    BodyVelocity.Parent = t2.value33.FlyRootPart

    local connection = t2.value6.Heartbeat:Connect(function()
        local v264 = not t2.value33.FlyRootPart

        if not v264 then
            v264 = not t2.value33.FlyRootPart.Parent or not t2.value33.FlyHumanoid
        end

        if v264 then
            BodyVelocity.Velocity = Vector3.zero

            return
        end

        if t2.value33.FlyIsEnabled then
            local MoveDirection = t2.value33.FlyHumanoid.MoveDirection

            if MoveDirection.Magnitude > 0 then
                local LookVector = workspace.CurrentCamera.CFrame.LookVector
                local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)

                if vector3.Magnitude > 0 then
                    vector3 = vector3.Unit
                end

                local v268 = vector3:Dot(MoveDirection)

                BodyVelocity.Velocity = MoveDirection * t2.value33.FlySpeed + Vector3.new(0, LookVector.Y * v268 * t2.value33.FlySpeed, 0)

                return
            end

            BodyVelocity.Velocity = Vector3.zero

            return
        end

        BodyVelocity.Velocity = Vector3.zero
    end)

    return function()
        connection:Disconnect()
        BodyVelocity:Destroy()
    end
end
function t1.value3(p22)
    t2.value33.FlyCharacter = p22

    local WaitForChild = p22.WaitForChild

    t2.value33.FlyRootPart = WaitForChild(p22, "HumanoidRootPart")

    local WaitForChild2 = p22.WaitForChild

    t2.value33.FlyHumanoid = WaitForChild2(p22, "Humanoid")

    if t2.value33.FlyIsEnabled then
        if t2.value33.FlyStopCallback then
            t2.value33.FlyStopCallback()
        end

        t2.value33.FlyStopCallback = v29()
    end
end
t1.value2 = t2.value1
t1.value21 = t1.value3
if t1.value2.Character then
    task.spawn(t1.value21, t2.value1.Character)
end
t1.value3 = t2.value1.CharacterAdded
t1.value2 = t1.value3.Connect
t1.value2(t1.value3, t1.value21)
t1.value2 = "Enable"
t1.value23 = "Min"
t1.value10("Enable", function(p23)
    if p23 == t2.value33.FlyIsEnabled then
        return
    end

    t2.value33.FlyIsEnabled = p23

    if t2.value33.FlyStopCallback then
        t2.value33.FlyStopCallback()
        t2.value33.FlyStopCallback = nil
    end

    if t2.value33.FlyIsEnabled then
        t2.value33.FlyStopCallback = v29()
    end
end)

local FlySpeed = t2.value33.FlySpeed
t1.value11({
	Text = "Fly Speed",
	Min = 16,
	Max = 300,
	Default = FlySpeed,
	Decimals = 1,
	Callback = function(p24)
    t2.value33.FlySpeed = p24
end
})
t1.value2 = "InfJumpCharacter"
t1.value9()
t1.value8()
t2.value34 = {
	InfJumpCharacter = nil,
	InfJumpHumanoid = nil,
	InfJumpIsEnabled = false,
	InfJumpStopCallback = nil
}
t1.value2 = t2.value1
function t1.value23(p25)
    t2.value34.InfJumpCharacter = p25
    t2.value34.InfJumpHumanoid = p25:WaitForChild("Humanoid")

    if t2.value34.InfJumpIsEnabled then
        if t2.value34.InfJumpStopCallback then
            t2.value34.InfJumpStopCallback()
        end

        local value34 = t2.value34
        local connection = t2.value3.JumpRequest:Connect(function()
            if not t2.value34.InfJumpCharacter or not t2.value34.InfJumpCharacter.Parent then
                return
            end

            if t2.value34.InfJumpIsEnabled and t2.value34.InfJumpHumanoid then
                t2.value34.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        function value34.InfJumpStopCallback()
            connection:Disconnect()
        end
    end
end
if t1.value2.Character then
    task.spawn(t1.value23, t2.value1.Character)
end
t1.value24 = "CharacterAdded"
t1.value3 = t2.value1.CharacterAdded
t1.value2 = "Connect"
t1.value25 = {}
t1.value2 = t1.value3.Connect
t1.value22 = false
t1.value2(t1.value3, t1.value23)
t1.value10("Infinite Jump", function(p26)
    if p26 == t2.value34.InfJumpIsEnabled then
        return
    end

    t2.value34.InfJumpIsEnabled = p26

    if t2.value34.InfJumpStopCallback then
        t2.value34.InfJumpStopCallback()
        t2.value34.InfJumpStopCallback = nil
    end

    if t2.value34.InfJumpIsEnabled then
        local value34 = t2.value34
        local connection = t2.value3.JumpRequest:Connect(function()
            if not t2.value34.InfJumpCharacter or not t2.value34.InfJumpCharacter.Parent then
                return
            end

            if t2.value34.InfJumpIsEnabled and t2.value34.InfJumpHumanoid then
                t2.value34.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        function value34.InfJumpStopCallback()
            connection:Disconnect()
        end
    end
end)
t1.value9()
t1.value2 = "NoclipCharacter"
t1.value24 = nil
t1.value8()
t2.value35 = {
	NoclipCharacter = t1.value24,
	NoclipIsEnabled = t1.value22,
	NoclipStopCallback = nil,
	NoclipParts = t1.value25,
	NoclipOriginalCanCollide = {},
	NoclipDescendantConnection = nil
}
function t1.value3()
    table.clear(t2.value35.NoclipParts)

    if not t2.value35.NoclipCharacter then
        return
    end

    table.clear(t2.value35.NoclipOriginalCanCollide)

    for _, descendant in ipairs(t2.value35.NoclipCharacter:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(t2.value35.NoclipParts, descendant)
            t2.value35.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
        end
    end
end
t2.value36 = t1.value3
local function v31()
    local connection = t2.value6.Stepped:Connect(function()
        if not t2.value35.NoclipCharacter or not t2.value35.NoclipCharacter.Parent then
            return
        end

        if t2.value35.NoclipIsEnabled then
            for _, v in ipairs(t2.value35.NoclipParts) do
                v.CanCollide = false
            end
        end
    end)

    return function()
        connection:Disconnect()

        if t2.value35.NoclipCharacter and t2.value35.NoclipCharacter.Parent then
            for _, v in ipairs(t2.value35.NoclipParts) do
                if v and v.Parent then
                    local v273 = t2.value35.NoclipOriginalCanCollide[v]

                    if v273 ~= nil then
                        v.CanCollide = v273
                    end
                end
            end
        end
    end
end
t1.value2 = t2.value1
local function v32(p27)
    t2.value35.NoclipCharacter = p27
    t2.value36()

    if t2.value35.NoclipDescendantConnection then
        t2.value35.NoclipDescendantConnection:Disconnect()
    end

    if t2.value35.NoclipRemovingConnection then
        t2.value35.NoclipRemovingConnection:Disconnect()
    end

    t2.value35.NoclipDescendantConnection = p27.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            table.insert(t2.value35.NoclipParts, descendant)
            t2.value35.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
        end
    end)
    t2.value35.NoclipRemovingConnection = p27.DescendantRemoving:Connect(function(descendant)
        if not descendant:IsA("BasePart") then
            return
        end

        local v276 = table.find(t2.value35.NoclipParts, descendant)

        if v276 then
            table.remove(t2.value35.NoclipParts, v276)
        end

        t2.value35.NoclipOriginalCanCollide[descendant] = nil
    end)

    if t2.value35.NoclipIsEnabled then
        if t2.value35.NoclipStopCallback then
            t2.value35.NoclipStopCallback()
        end

        t2.value35.NoclipStopCallback = v31()
    end
end
if t1.value2.Character then
    task.spawn(v32, t2.value1.Character)
end
t2.value1.CharacterAdded:Connect(v32)
t1.value10("Noclip", function(p28)
    if p28 == t2.value35.NoclipIsEnabled then
        return
    end

    t2.value35.NoclipIsEnabled = p28

    if t2.value35.NoclipStopCallback then
        t2.value35.NoclipStopCallback()
        t2.value35.NoclipStopCallback = nil
    end

    if t2.value35.NoclipIsEnabled then
        t2.value35.NoclipStopCallback = v31()
    end
end)
t1.value9()
t1.value7("Main")
