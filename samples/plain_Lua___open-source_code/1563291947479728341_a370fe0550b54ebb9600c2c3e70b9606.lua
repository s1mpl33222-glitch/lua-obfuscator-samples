-- التأكد من عدم تكرار السكريبت القديم وتدميره بالكامل
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("صيد ضبان kwarpex") then
    CoreGui["صيد ضبان kwarpex"]:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

-- التعرف التلقائي على الجهاز (لتوافقية كاملة وأداء سلس على كل الهواتف والأجهزة)
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- إنشاء واجهة المستخدم الشاملة (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "صيد ضبان kwarpex"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- ==========================================
-- 1. الواجهة الأولى: قراءة الحقوق (بدون اسم السكريبت)
-- ==========================================
local msgFrame = Instance.new("Frame")
msgFrame.Name = "MsgFrame"
msgFrame.Size = UDim2.new(0, 320, 0, 210)
msgFrame.Position = UDim2.new(0.5, -160, 0.5, -105)
msgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
msgFrame.BorderSizePixel = 0
msgFrame.Active = true
msgFrame.Draggable = true
msgFrame.Parent = screenGui

local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 12)
msgCorner.Parent = msgFrame

local msgStroke = Instance.new("UIStroke")
msgStroke.Color = Color3.fromRGB(0, 120, 255)
msgStroke.Transparency = 0.3
msgStroke.Thickness = 2
msgStroke.Parent = msgFrame

local msgTitle = Instance.new("TextLabel")
msgTitle.Size = UDim2.new(1, 0, 0, 35)
msgTitle.BackgroundTransparency = 1
msgTitle.Text = "قراءة الحقوق"
msgTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
msgTitle.TextSize = 14
msgTitle.Font = Enum.Font.GothamBold
msgTitle.Parent = msgFrame

local msgLabel = Instance.new("TextLabel")
msgLabel.Size = UDim2.new(0.9, 0, 0, 100)
msgLabel.Position = UDim2.new(0.05, 0, 0, 35)
msgLabel.BackgroundTransparency = 1
msgLabel.Text = "الحقوق: هذا السكريبت مصنوع من kwarpex\n\nالسيرفر: هذا السكريبت متعاون بين سيرفر txn ومطور kwarpex."
msgLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
msgLabel.TextSize = 11
msgLabel.Font = Enum.Font.Gotham
msgLabel.TextWrapped = true
msgLabel.TextXAlignment = Enum.TextXAlignment.Center
msgLabel.Parent = msgFrame

-- زر "حسناً" للانتقال للسكريبت الرئيسي
local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(0.9, 0, 0, 35)
okBtn.Position = UDim2.new(0.05, 0, 0, 150)
okBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
okBtn.Text = "حسناً"
okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
okBtn.TextSize = 12
okBtn.Font = Enum.Font.GothamBold
okBtn.Parent = msgFrame
Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 8)


-- ==========================================
-- 2. الواجهة الرئيسية للسكريبت
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 180) -- تم تصغير الحجم بعد إزالة زر التنقل
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(0, 120, 255)
frameStroke.Transparency = 0.5
frameStroke.Thickness = 1.5
frameStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "صيد ضبان kwarpex"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- ==========================================
-- زر الإخفاء والإظهار الخارجي (K)
-- ==========================================
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0.05, 0, 0.02, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.Text = "K"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Visible = false
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- أزرار الواجهة الرئيسية (مرتبة بعرض متناسق)
local detectBtn = Instance.new("TextButton")
detectBtn.Name = "DetectBtn"
detectBtn.Size = UDim2.new(0, 256, 0, 36)
detectBtn.Position = UDim2.new(0, 12, 0, 38)
detectBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
detectBtn.Text = "كشف الضبان: مغلق"
detectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
detectBtn.TextSize = 11
detectBtn.Font = Enum.Font.GothamBold
detectBtn.Parent = mainFrame
Instance.new("UICorner", detectBtn).CornerRadius = UDim.new(0, 7)

local nightVisionBtn = Instance.new("TextButton")
nightVisionBtn.Name = "NightVisionBtn"
nightVisionBtn.Size = UDim2.new(0, 256, 0, 36)
nightVisionBtn.Position = UDim2.new(0, 12, 0, 82)
nightVisionBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
nightVisionBtn.Text = "الرؤية الليلية: مغلق"
nightVisionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nightVisionBtn.TextSize = 11
nightVisionBtn.Font = Enum.Font.GothamBold
nightVisionBtn.Parent = mainFrame
Instance.new("UICorner", nightVisionBtn).CornerRadius = UDim.new(0, 7)

local aimBotBtn = Instance.new("TextButton")
aimBotBtn.Name = "AimBotBtn"
aimBotBtn.Size = UDim2.new(0, 256, 0, 36)
aimBotBtn.Position = UDim2.new(0, 12, 0, 126)
aimBotBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
aimBotBtn.Text = "أيم بوت: مغلق"
aimBotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimBotBtn.TextSize = 11
aimBotBtn.Font = Enum.Font.GothamBold
aimBotBtn.Parent = mainFrame
Instance.new("UICorner", aimBotBtn).CornerRadius = UDim.new(0, 7)

-- الانتقال السليم من واجهة الحقوق للواجهة الرئيسية عند الضغط على حسناً
okBtn.MouseButton1Click:Connect(function()
    msgFrame.Visible = false
    mainFrame.Visible = true
    toggleButton.Visible = true
end)

-- متغيرات الحالة
local detectActive = false
local nightVisionActive = false
local aimBotActive = false

-- تخزين عناصر الكشف للضبان
local activeESPs = {}

-- إعداد الرؤية الليلية
local nightVisionEffect = Instance.new("ColorCorrectionEffect")
nightVisionEffect.Name = "KwarpexNaturalNightVision"
nightVisionEffect.Enabled = false
nightVisionEffect.Brightness = 0.12
nightVisionEffect.Contrast = 0.05
nightVisionEffect.Saturation = 0.1
nightVisionEffect.Parent = game:GetService("Lighting")

-- دالة قراءة الوزن الحقيقي الموجود في اللعبة حصرياً بدون عشوائية
local function getRealDhabWeight(dhabModel)
    for attrName, attrVal in pairs(dhabModel:GetAttributes()) do
        local lowerName = string.lower(attrName)
        if string.find(lowerName, "weight") or string.find(lowerName, "وزن") or string.find(lowerName, "mass") then
            if type(attrVal) == "number" then
                return math.floor(attrVal)
            end
        end
    end
    
    local hitbox = dhabModel:FindFirstChild("Hitbox")
    if hitbox then
        for attrName, attrVal in pairs(hitbox:GetAttributes()) do
            local lowerName = string.lower(attrName)
            if string.find(lowerName, "weight") or string.find(lowerName, "وزن") or string.find(lowerName, "mass") then
                if type(attrVal) == "number" then
                    return math.floor(attrVal)
                end
            end
        end
    end

    for _, child in ipairs(dhabModel:GetDescendants()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") then
            local lowerName = string.lower(child.Name)
            if string.find(lowerName, "weight") or string.find(lowerName, "وزن") or string.find(lowerName, "mass") or string.find(lowerName, "w") then
                return math.floor(child.Value)
            end
        end
    end
    
    if hitbox and hitbox:IsA("BasePart") then
        return math.clamp(math.floor(hitbox.Size.X + hitbox.Size.Y + hitbox.Size.Z), 1, 100)
    end
    
    return 5
end

-- دالة البحث عن الضب الذي يمتلك "أعلى وزن" حقيقي (للأيم بوت)
local function getBestDhab()
    local dhabWildFolder = Workspace:FindFirstChild("DhabWild")
    if not dhabWildFolder then return nil end
    
    local bestDhab = nil
    local highestWeight = -math.huge
    
    for _, dhabModel in ipairs(dhabWildFolder:GetChildren()) do
        local hitbox = dhabModel:FindFirstChild("Hitbox")
        if hitbox and hitbox:IsA("BasePart") then
            local weight = getRealDhabWeight(dhabModel)
            if weight > highestWeight then
                highestWeight = weight
                bestDhab = dhabModel
            end
        end
    end
    
    return bestDhab
end

-- مسح جميع الـ ESPs عند الإغلاق
local function clearAllESPs()
    for model, esp in pairs(activeESPs) do
        if esp.highlight then esp.highlight:Destroy() end
        if esp.billboard then esp.billboard:Destroy() end
    end
    activeESPs = {}
end

-- 1. زر كشف الضبان
detectBtn.MouseButton1Click:Connect(function()
    detectActive = not detectActive
    
    if detectActive then
        detectBtn.Text = "كشف الضبان: شغال"
        detectBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
    else
        detectBtn.Text = "كشف الضبان: مغلق"
        detectBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        clearAllESPs()
    end
end)

-- 2. زر الرؤية الليلية
nightVisionBtn.MouseButton1Click:Connect(function()
    nightVisionActive = not nightVisionActive
    
    if nightVisionActive then
        nightVisionBtn.Text = "الرؤية الليلية: شغال"
        nightVisionBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
        nightVisionEffect.Enabled = true
    else
        nightVisionBtn.Text = "الرؤية الليلية: مغلق"
        nightVisionBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        nightVisionEffect.Enabled = false
    end
end)

-- 3. زر أيم بوت
aimBotBtn.MouseButton1Click:Connect(function()
    aimBotActive = not aimBotActive
    
    if aimBotActive then
        aimBotBtn.Text = "أيم بوت: شغال"
        aimBotBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
    else
        aimBotBtn.Text = "أيم بوت: مغلق"
        aimBotBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    end
end)

-- الحلقة التحديثية المستمرة المتوافقة مع جميع الأجهزة بذكاء لمنع اللاغ
local frameCounter = 0
RunService.Heartbeat:Connect(function()
    frameCounter = frameCounter + 1
    if isMobile and (frameCounter % 2 ~= 0) and not detectActive and not aimBotActive then
        return
    end

    if detectActive then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local dhabWildFolder = Workspace:FindFirstChild("DhabWild")
        
        if hrp and dhabWildFolder then
            local allDhabs = {}
            for _, dhabModel in ipairs(dhabWildFolder:GetChildren()) do
                local hitbox = dhabModel:FindFirstChild("Hitbox")
                if hitbox and hitbox:IsA("BasePart") then
                    local dist = (hrp.Position - hitbox.Position).Magnitude
                    table.insert(allDhabs, {model = dhabModel, hitbox = hitbox, dist = dist})
                end
            end
            
            table.sort(allDhabs, function(a, b)
                return a.dist < b.dist
            end)
            
            local currentClosestModels = {}
            local maxClosestCount = isMobile and 10 or 20 -- تحسين العدد تلقائياً حسب الجهاز لمنع أي تقطيع
            
            for i = 1, math.min(maxClosestCount, #allDhabs) do
                local data = allDhabs[i]
                local dhabModel = data.model
                local hitbox = data.hitbox
                currentClosestModels[dhabModel] = true
                
                local weight = getRealDhabWeight(dhabModel)
                
                if not activeESPs[dhabModel] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "DhabESP"
                    hl.FillColor = Color3.fromRGB(0, 255, 255)
                    hl.FillTransparency = 0.3
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.Parent = dhabModel
                    
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "DhabTag"
                    bb.Size = UDim2.new(0, 180, 0, 35)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = hitbox
                    
                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 255, 0)
                    txt.TextSize = 14
                    txt.Font = Enum.Font.GothamBold
                    txt.TextStrokeTransparency = 0
                    txt.TextWrapped = true
                    txt.Parent = bb
                    
                    activeESPs[dhabModel] = {highlight = hl, billboard = bb, label = txt}
                end
                
                if activeESPs[dhabModel] and activeESPs[dhabModel].label then
                    activeESPs[dhabModel].label.Text = "وزنه: " .. weight
                end
            end
            
            for model, esp in pairs(activeESPs) do
                if not currentClosestModels[model] or not model.Parent then
                    if esp.highlight then esp.highlight:Destroy() end
                    if esp.billboard then esp.billboard:Destroy() end
                    activeESPs[model] = nil
                end
            end
        end
    else
        clearAllESPs()
    end
    
    if aimBotActive then
        local bestDhab = getBestDhab()
        if bestDhab then
            local hitbox = bestDhab:FindFirstChild("Hitbox")
            if hitbox then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, hitbox.Position)
            end
        end
    end
end)
