-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MachineClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("MachineClickEvent")
local SellBrainrotEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SellBrainrotEvent")
local PodiumFloorParts = workspace.Plots["DaniloMasAnto Plot"].PodiumFloorParts
local function v13(p1, p2)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
			Title = p1,
			Text = p2,
			Duration = 3
		})
    end)
end
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()

    local v39 = VirtualUser
    local t1 = { Vector2.new() }

    v39:ClickButton2(v1(t1))
    v13("ANTI AFK", "Prevented AFK kick!")
end)
task.spawn(function()
    while true do
        task.wait(300)
        v13("STATUS", "Auto Farm still running...")
    end
end)
local u14 = false
local function v15(p3)
    if not p3 then
        return
    end

    p3.Enabled = false

    for _, descendant in ipairs(p3:GetDescendants()) do
        local v44 = descendant

        if v44:IsA("GuiObject") then
            v44.Visible = false
            v44:GetPropertyChangedSignal("Visible"):Connect(function()
                if u14 then
                    v44.Visible = false
                end
            end)
        end
    end

    p3:GetPropertyChangedSignal("Enabled"):Connect(function()
        if u14 then
            p3.Enabled = false
        end
    end)
end
PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "EggCrateOpeningUI" then
        task.wait()

        if u14 then
            v15(child)
        end
    end
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 280)
Frame.Position = UDim2.new(0.5, -110, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Parent = ScreenGui
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(1, 0, 0, 25)
Frame2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame2.Parent = Frame
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -50, 1, 0)
TextLabel.Position = UDim2.new(0, 5, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Auto Farm Panel"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame2
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 25, 1, 0)
TextButton.Position = UDim2.new(1, -50, 0, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TextButton.Text = "-"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Parent = Frame2
local TextButton2 = Instance.new("TextButton")
TextButton2.Size = UDim2.new(0, 25, 1, 0)
TextButton2.Position = UDim2.new(1, -25, 0, 0)
TextButton2.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
TextButton2.Text = "X"
TextButton2.TextColor3 = Color3.new(1, 1, 1)
TextButton2.Parent = Frame2
local TextButton3 = Instance.new("TextButton")
TextButton3.Size = UDim2.new(1, -20, 0, 40)
TextButton3.Position = UDim2.new(0, 10, 0, 35)
TextButton3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton3.Text = "Auto Tap XP : OFF"
TextButton3.TextColor3 = Color3.new(1, 1, 1)
TextButton3.TextScaled = true
TextButton3.Font = Enum.Font.GothamBold
TextButton3.Parent = Frame
local TextButton4 = Instance.new("TextButton")
TextButton4.Size = UDim2.new(1, -20, 0, 40)
TextButton4.Position = UDim2.new(0, 10, 0, 80)
TextButton4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton4.Text = "Sell All"
TextButton4.TextColor3 = Color3.new(1, 1, 1)
TextButton4.TextScaled = true
TextButton4.Font = Enum.Font.GothamBold
TextButton4.Parent = Frame
local TextButton5 = Instance.new("TextButton")
TextButton5.Size = UDim2.new(1, -20, 0, 40)
TextButton5.Position = UDim2.new(0, 10, 0, 125)
TextButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton5.Text = "Auto Collect : OFF"
TextButton5.TextColor3 = Color3.new(1, 1, 1)
TextButton5.TextScaled = true
TextButton5.Font = Enum.Font.GothamBold
TextButton5.Parent = Frame
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(1, -20, 0, 20)
TextLabel2.Position = UDim2.new(0, 10, 0, 165)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = ""
TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel2.TextScaled = true
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.Visible = false
TextLabel2.Parent = Frame
local TextButton6 = Instance.new("TextButton")
TextButton6.Size = UDim2.new(1, -20, 0, 40)
TextButton6.Position = UDim2.new(0, 10, 0, 190)
TextButton6.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton6.Text = "Hide Crate UI : OFF"
TextButton6.TextColor3 = Color3.new(1, 1, 1)
TextButton6.TextScaled = true
TextButton6.Font = Enum.Font.GothamBold
TextButton6.Parent = Frame
local u27 = false
local u28 = false
local u29 = true
local n1 = 0
local u31 = false
local uDim2 = UDim2.new(0, 220, 0, 280)
local uDim2_2 = UDim2.new(0, 220, 0, 25)
TextButton.MouseButton1Click:Connect(function()
    u31 = not u31

    if u31 then
        local v47 = uDim2_2

        TweenService:Create(Frame, TweenInfo.new(0.25), {
			Size = v47
		}):Play()
        TextButton.Text = "+"
        TextButton3.Visible = false
        TextButton4.Visible = false
        TextButton5.Visible = false
        TextLabel2.Visible = false
        TextButton6.Visible = false

        return
    end

    local v48 = uDim2

    TweenService:Create(Frame, TweenInfo.new(0.25), {
		Size = v48
	}):Play()
    TextButton.Text = "-"
    TextButton3.Visible = true
    TextButton4.Visible = true
    TextButton5.Visible = true
    TextButton6.Visible = true

    if u28 then
        TextLabel2.Visible = true
    end
end)
TextButton3.MouseButton1Click:Connect(function()
    u27 = not u27
    TextButton3.Text = not u27 and "Auto Tap XP : OFF" or "Auto Tap XP : ON"

    local v49 = TextButton3
    local v50 = u27

    if v50 then
        v50 = Color3.fromRGB(0, 170, 0)
    end

    if not v50 then
        v50 = Color3.fromRGB(40, 40, 40)
    end

    v49.BackgroundColor3 = v50
end)
TextButton4.MouseButton1Click:Connect(function()
    SellBrainrotEvent:FireServer("all", "Pet")
    task.wait(5)
    SellBrainrotEvent:FireServer("all", "Worker")
    v13("SELL", "All Pets & Workers sold!")
end)
TextButton5.MouseButton1Click:Connect(function()
    u28 = not u28

    if u28 then
        n1 = tick()
        TextLabel2.Visible = true
    else
        TextLabel2.Visible = false
    end

    TextButton5.Text = not u28 and "Auto Collect : OFF" or "Auto Collect : ON"

    local v51 = TextButton5
    local v52 = u28

    if v52 then
        v52 = Color3.fromRGB(0, 170, 0)
    end

    if not v52 then
        v52 = Color3.fromRGB(40, 40, 40)
    end

    v51.BackgroundColor3 = v52
end)
TextButton6.MouseButton1Click:Connect(function()
    u14 = not u14
    TextButton6.Text = not u14 and "Hide Crate UI : OFF" or "Hide Crate UI : ON"

    local v53 = TextButton6
    local v54 = u14

    if v54 then
        v54 = Color3.fromRGB(0, 170, 0)
    end

    if not v54 then
        v54 = Color3.fromRGB(40, 40, 40)
    end

    v53.BackgroundColor3 = v54

    if u14 then
        local EggCrateOpeningUI = PlayerGui:FindFirstChild("EggCrateOpeningUI")

        if EggCrateOpeningUI then
            v15(EggCrateOpeningUI)
        end
    end
end)
TextButton2.MouseButton1Click:Connect(function()
    u29 = false
    ScreenGui:Destroy()
end)
local u34 = false
local u35
Frame2.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        u34 = true

        local _ = input.Position
        local _ = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                u34 = false
            end
        end)
    end
end)
Frame2.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        u35 = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == u35 and u34 then
        local v63 = input.Position - nil

        Frame.Position = UDim2.new((nil).X.Scale, (nil).X.Offset + v63.X, (nil).Y.Scale, (nil).Y.Offset + v63.Y)
    end
end)
task.spawn(function()
    while u29 do
        if u27 then
            MachineClickEvent:FireServer("ManualMachine")
        end

        if u28 then
            local v64 = math.max(0, 60 - (tick() - n1))

            if v64 > 0 then
                TextLabel2.Text = "Next collect in: " .. math.floor(v64) .. "s"
            else
                TextLabel2.Text = "Collecting..."

                local Character = LocalPlayer.Character

                if not Character then
                    Character = LocalPlayer.CharacterAdded:Wait()
                end

                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    for _, descendant in ipairs(PodiumFloorParts:GetDescendants()) do
                        local v69 = descendant.Name == "CollectButton"

                        if v69 then
                            v69 = descendant:IsA("BasePart")
                        end

                        if v69 then
                            firetouchinterest(HumanoidRootPart, descendant, 0)
                            task.wait()
                            firetouchinterest(HumanoidRootPart, descendant, 1)
                        end
                    end
                end

                n1 = tick()
                v13("COLLECT", "All collected!")
            end
        end

        task.wait(0.1)
    end
end)
