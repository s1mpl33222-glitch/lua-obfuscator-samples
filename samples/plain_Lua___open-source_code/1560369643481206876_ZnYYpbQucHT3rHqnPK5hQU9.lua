-- سكربت Airdrop الخفيف والمرتب بدون إيموجات وبدون لاج
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SetClipboard = setclipboard or toclipboard or syn and syn.write_clipboard

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- حذف أي نسخة قديمة لتجنب التعليق واللاج
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui.Name == "EliteTeamCleanGUI" then
        gui:Destroy()
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteTeamCleanGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- القائمة الرئيسية
local frame = Instance.new("ImageLabel")
frame.Size = UDim2.new(0, 240, 0, 210)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.Image = "rbxassetid://94844851817701"
frame.ScaleType = Enum.ScaleType.Crop
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- تغميق خلفية القائمة لوضوح النصوص
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.4
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = frame

local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(0, 10)
overlayCorner.Parent = overlay

-- العنوان والحقوق
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.75, 0, 0, 30)
title.Position = UDim2.new(0.05, 0, 0.05, 0)
title.BackgroundTransparency = 1
title.Text = "ELITE TEAM | by m2x"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.ZIndex = 2
title.Parent = frame

-- زر الخروج (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.82, 0, 0.05, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.ZIndex = 2
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- زر التشغيل والإيقاف
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 42)
toggleBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "الحالة : متوقف"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.ZIndex = 2
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- زر نسخ الديسكورد
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.9, 0, 0, 35)
discordBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.Text = "نسخ رابط الديسكورد"
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.TextSize = 12
discordBtn.Font = Enum.Font.SourceSansBold
discordBtn.ZIndex = 2
discordBtn.Parent = frame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordBtn

-- زر إخفاء القائمة
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.9, 0, 0, 35)
hideBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hideBtn.Text = "إخفاء القائمة"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextSize = 12
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.ZIndex = 2
hideBtn.Parent = frame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideBtn

-- زر الإظهار العائم
local showFloatingBtn = Instance.new("TextButton")
showFloatingBtn.Size = UDim2.new(0, 45, 0, 45)
showFloatingBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
showFloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
showFloatingBtn.Text = "فتح"
showFloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
showFloatingBtn.TextSize = 12
showFloatingBtn.Font = Enum.Font.SourceSansBold
showFloatingBtn.Visible = false
showFloatingBtn.Parent = screenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = showFloatingBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

discordBtn.MouseButton1Click:Connect(function()
    if SetClipboard then
        SetClipboard("https://discord.gg/yourlink")
        discordBtn.Text = "تم النسخ بنجاح"
        task.wait(1.5)
        discordBtn.Text = "نسخ رابط الديسكورد"
    end
end)

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    showFloatingBtn.Visible = true
end)

showFloatingBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    showFloatingBtn.Visible = false
end)

-- محرك مانع اللاج لالتقاط الدروب
local active = false

toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        toggleBtn.Text = "الحالة : شغال ويجمع"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        task.spawn(function()
            while active and screenGui.Parent do
                task.wait(0.5)
                
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if not active or not screenGui.Parent then break end
                        if prompt:IsA("ProximityPrompt") then
                            local actionText = string.lower(prompt.ActionText or "")
                            local objectText = string.lower(prompt.ObjectText or "")
                            
                            if actionText:find("إلتقاط") or actionText:find("التقاط") or objectText:find("airdrop") or objectText:find("drop") then
                                local targetPart = prompt.Parent
                                if targetPart and targetPart:IsA("BasePart") then
                                    local distance = (root.Position - targetPart.Position).Magnitude
                                    
                                    if distance < 15 then
                                        pcall(function()
                                            prompt.MaxActivationDistance = 999999
                                            prompt.HoldDuration = 0
                                            fireproximityprompt(prompt)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        toggleBtn.Text = "الحالة : متوقف"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)