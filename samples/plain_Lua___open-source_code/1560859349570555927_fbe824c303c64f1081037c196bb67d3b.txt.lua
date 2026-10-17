local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AshFreeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 20, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ASH FREE 1.0"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

local pullBtn = Instance.new("TextButton")
pullBtn.Size = UDim2.new(1, -20, 0, 40)
pullBtn.Position = UDim2.new(0, 10, 0, 40)
pullBtn.Text = "Puxar 10 Armas"
pullBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
pullBtn.TextColor3 = Color3.new(1,1,1)
pullBtn.Font = Enum.Font.SourceSansBold
pullBtn.TextSize = 18
pullBtn.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 1, 10)
toggleBtn.Text = "Esconder Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 14
toggleBtn.Parent = frame

-- Armas jÃ¡ puxadas (pra evitar duplicatas)
local armasPuxadas = {}

pullBtn.MouseButton1Click:Connect(function()
    local puxadas = 0
    local fontes = {
        game:GetService("Workspace"),
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterPack"),
        game:GetService("StarterGear")
    }

    for _, fonte in ipairs(fontes) do
        for _, obj in ipairs(fonte:GetDescendants()) do
            if obj:IsA("Tool") and not armasPuxadas[obj.Name] then
                local temScript = false
                for _, filho in ipairs(obj:GetDescendants()) do
                    if filho:IsA("Script") or filho:IsA("LocalScript") then
                        temScript = true
                        break
                    end
                end

                if temScript then
                    pcall(function()
                        obj.Parent = player.Backpack
                        armasPuxadas[obj.Name] = true
                        puxadas += 1
                    end)
                end

                if puxadas >= 10 then
                    break
                end
            end
        end
        if puxadas >= 10 then
            break
        end
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "ASH FREE 1.0",
        Text = "Foram puxadas " .. puxadas .. " novas armas.",
        Duration = 4,
    })
end)

local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    toggleBtn.Text = menuVisible and "Esconder Menu" or "Mostrar Menu"
end)