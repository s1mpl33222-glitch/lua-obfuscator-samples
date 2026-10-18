local function StartAutoFarm()
    getgenv().WarMachinesExecuted = true
    local lp = game.Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local vinput = game:GetService("VirtualInputManager")
    local priorities = {"sniper", "elite", "bandit"}
 
    task.spawn(function()
        while getgenv().WarMachinesExecuted do
            local found = false
            for _, priority in ipairs(priorities) do
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") then
                        local name = tostring(npc.Name):lower()
                        if name:find(priority) and npc.Humanoid.Health > 0 then
                            local head = npc.Head
                            char:PivotTo(head.CFrame * CFrame.new(0, 0, 5))
                            vinput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.1)
                            vinput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            task.wait(0.3)
                            found = true
                            break
                        end
                    end
                end
                if found then break end
            end
            task.wait(0.4)
        end
    end)
end
 
-- Função para parar o Auto Farm
local function StopAutoFarm()
    getgenv().WarMachinesExecuted = false
end
 
-- GUI Pain or Hope
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PainOrHopeFarm"
 
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 130)
frame.Position = UDim2.new(0, 30, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
 
local title = Instance.new("TextLabel", frame)
title.Text = "Pain or Hope"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(180, 0, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
 
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -40, 0, 40)
toggle.Position = UDim2.new(0, 20, 0, 50)
toggle.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Text = "Start Auto Farm"
toggle.Font = Enum.Font.Gotham
toggle.TextScaled = true
 
local active = false
 
toggle.MouseButton1Click:Connect(function()
    active = not active
    if active then
        toggle.Text = "Stop Auto Farm"
        StartAutoFarm()
    else
        toggle.Text = "Start Auto Farm"
        StopAutoFarm()
    end
end)