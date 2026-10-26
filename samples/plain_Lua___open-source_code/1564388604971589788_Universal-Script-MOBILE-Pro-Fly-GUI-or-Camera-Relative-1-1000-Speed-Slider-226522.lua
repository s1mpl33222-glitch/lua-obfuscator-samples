-- Mobile 3D Camera Fly (Sıfır -- Mobile 3D Camera Fly (English UI - Max 1000 Speed & Anti-Gravity)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Eski GUI'yi temizle
if playerGui:FindFirstChild("SpikeProFly") then
    playerGui.SpikeProFly:Destroy()
end

-- Ana Ekran Çerçevesi
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpikeProFly"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "FlyPanel"
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.Text = "✈️ Pro Fly GUI"
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Hız Göstergesi Yazısı (İngilizce)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 35)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.Text = "Speed: 50"
speedLabel.Parent = frame

-- Slider Arka Planı (Çubuk)
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 12)
sliderBg.Position = UDim2.new(0.05, 0, 0.62, 0)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = frame
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

-- Slider Dolgu Alanı
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(50/1000, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(40, 140, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

-- Slider Düğmesi (Tutamaç)
local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 20, 0, 20)
sliderBtn.Position = UDim2.new(50/1000, -10, -0.5, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.Text = ""
sliderBtn.Parent = sliderBg
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

-- Aç/Kapat Butonu (İngilizce)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "FLY: OFF"
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- Mantık Değişkenleri
local flying = false
local flySpeed = 50
local maxSpeed = 1000
local sliding = false
local bv

-- Slider Sürükleme Mantığı
sliderBtn.MouseButton1Down:Connect(function() sliding = true end)
sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local bgPos = sliderBg.AbsolutePosition.X
        local bgSize = sliderBg.AbsoluteSize.X
        
        local percentage = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
        flySpeed = math.floor(percentage * maxSpeed)
        if flySpeed < 10 then flySpeed = 10 end
        
        speedLabel.Text = "Speed: " .. flySpeed
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderBtn.Position = UDim2.new(percentage, -10, -0.5, 0)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if flying then
            toggleBtn.Text = "FLY: ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
            
            if not hrp:FindFirstChild("SpikeFlyForce") then
                bv = Instance.new("BodyVelocity")
                bv.Name = "SpikeFlyForce"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = hrp
            end
        else
            toggleBtn.Text = "FLY: OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            if hrp:FindFirstChild("SpikeFlyForce") then
                hrp.SpikeFlyForce:Destroy()
            end
        end
    end
end)

-- Uçuş Motoru
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local hrp = char.HumanoidRootPart
        local humanoid = char.Humanoid
        
        if flying then
            humanoid.PlatformStand = true
            local cam = workspace.CurrentCamera
            
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
            
            local forceObj = hrp:FindFirstChild("SpikeFlyForce")
            if forceObj then
                if humanoid.MoveDirection.Magnitude > 0 then
                    forceObj.Velocity = cam.CFrame.LookVector * flySpeed
                else
                    forceObj.Velocity = Vector3.new(0, 0, 0)
                end
            end
        else
            humanoid.PlatformStand = false
            local forceObj = hrp:FindFirstChild("SpikeFlyForce")
            if forceObj then
                forceObj:Destroy()
            end
        end
    end
end)

