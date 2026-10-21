local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local currentLang = "AR"

local TRANSLATIONS = {
    AR = {
        title = "Elite Team | #ابوسيف العنزي",
        protectedTitle = "🔥 Elite Team ",
        toggleOpen = "فتح",
        toggleClose = "إغلاق",
        espInvOn = "كاشف الحقيبة: مفعّل",
        espInvOff = "كاشف الحقيبة: معطّل",
        espPlrOn = "كاشف اللاعبين (ESP): مفعّل",
        espPlrOff = "كاشف اللاعبين (ESP): معطّل",
        aimOn = "التصويب التلقائي (Aimbot): مفعّل",
        aimOff = "التصويب التلقائي (Aimbot): معطّل",
        wallOn = "فحص الجدران: مفعّل",
        wallOff = "فحص الجدران: معطّل",
        fovText = "نطاق الرؤية (FOV): %d",
        fovCircleOn = "دائرة FOV: مفعّلة",
        fovCircleOff = "دائرة FOV: معطّلة",
        fovKOff = "دائرة FOV: إيقاف إجباري (K)",
        fishingNormal = "صنارة صيد عادية",
        fishingPro = "صنارة صيد احترافية",
        fishingAdv = "صنارة صيد متقدمة",
        fishingUlt = "صنارة صيد خرافية",
        aimModes = {
            "الهدف: الرأس (ثابت)",
            "الهدف: الجسد (ثابت)",
            "الهدف: الذراع الأيمن (ثابت)",
            "الهدف: الذراع الأيسر (ثابت)",
            "الهدف: تبديل تلقائي (رأس ↔ جسد)",
            "الهدف: تبديل تلقائي (يمين ↔ يسار)"
        }
    },
    ES = {
        title = "🔥 Elite Team | #AbuSaif 🔥",
        protectedTitle = "🔥 Elite Team | Protegidos: %d 🔥",
        toggleOpen = "Abrir",
        toggleClose = "Cerrar",
        espInvOn = "ESP Inventario: Activado",
        espInvOff = "ESP Inventario: Desactivado",
        espPlrOn = "ESP Jugadores: Activado",
        espPlrOff = "ESP Jugadores: Desactivado",
        aimOn = "Aimbot: Activado",
        aimOff = "Aimbot: Desactivado",
        wallOn = "Wallcheck: Activado",
        wallOff = "Wallcheck: Desactivado",
        fovText = "Rango de Visión (FOV): %d",
        fovCircleOn = "Círculo FOV: Activado",
        fovCircleOff = "Círculo FOV: Desactivado",
        fovKOff = "Círculo FOV: Forzado Off (K)",
        fishingNormal = "Caña de pescar normal",
        fishingPro = "Caña de pescar pro",
        fishingAdv = "Caña de pescar avanzada",
        fishingUlt = "Caña de pescar mítica",
        aimModes = {
            "Objetivo: Cabeza (Fijo)",
            "Objetivo: Cuerpo (Fijo)",
            "Objetivo: Brazo Derecho (Fijo)",
            "Objetivo: Brazo Izquierdo (Fijo)",
            "Objetivo: Auto (Cabeza ↔ Cuerpo)",
            "Objetivo: Auto (Der ↔ Izq)"
        }
    }
}

local espInventoryEnabled = true 
local MAX_DISTANCE = 2000 
local UPDATE_INTERVAL = 1 
local BillboardCache = {}
local nameCache = {} 

local RARITY_COLORS = {
    ["Common"] = Color3.fromRGB(255, 255, 255),
    ["Uncommon"] = Color3.fromRGB(99, 255, 52),
    ["Rare"] = Color3.fromRGB(51, 170, 255),
    ["Epic"] = Color3.fromRGB(237, 44, 255),
    ["Legendary"] = Color3.fromRGB(255, 150, 0),
    ["Omega"] = Color3.fromRGB(255, 20, 51),
}

local function getRealName(t)
    if not t or not t.Name then return nil end
    
    local originalName = t.Name
    local lowerName = originalName:lower()

    local cleaned = lowerName
        :gsub("%d+$", "")
        :gsub("_%d+$", "")
        :gsub("%s*%d+%s*$", "")
        :gsub("[%s_]+", " ")
        :gsub("([^%w%s])", "")
        :match("^%s*(.-)%s*$")

    local tLang = TRANSLATIONS[currentLang]
    if cleaned:find("fishing") or cleaned:find("rod") or cleaned:find("canne") or cleaned:find("pêche") then
        if cleaned:find("ultimate") or cleaned:find("ult") then
            return tLang.fishingUlt
        elseif cleaned:find("advanced") then
            return tLang.fishingAdv
        elseif cleaned:find("pro") then
            return tLang.fishingPro
        else
            return tLang.fishingNormal
        end
    end

    if nameCache[originalName] then 
        return nameCache[originalName] 
    end
    
    local h = t:FindFirstChild("Handle")
    local fallbackName = cleaned
    
    for _, folder in ipairs({ReplicatedStorage:FindFirstChild("Items"), StarterPack}) do
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    local match = true
                    if h then
                        for _, c in ipairs(h:GetChildren()) do
                            if not item.Handle:FindFirstChild(c.Name) then 
                                match = false 
                                break 
                            end
                        end
                    else
                        match = false
                    end
                    if match then 
                        nameCache[originalName] = item.Name 
                        return item.Name 
                    end
                end
            end
        end
    end
    
    nameCache[originalName] = fallbackName
    return fallbackName
end

local function updateESP(p)
    local bb = BillboardCache[p]
    if not bb then return end
    
    local char = p.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        bb.Enabled = false
        return 
    end
    
    local lChar = LocalPlayer.Character
    if lChar and lChar:FindFirstChild("HumanoidRootPart") then
        local dist = (lChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
        if dist > MAX_DISTANCE then
            bb.Enabled = false
            return
        end
    end

    local container = bb:FindFirstChild("EspContainer")
    if not container then return end
    container:ClearAllChildren()

    local layout = Instance.new("UIListLayout", container)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom 
    layout.Padding = UDim.new(0, 2)

    local tools = {}
    if p:FindFirstChild("Backpack") then
        for _, t in ipairs(p.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower() ~= "fists" then table.insert(tools, t) end
        end
    end
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower() ~= "fists" then table.insert(tools, t) end
        end
    end

    bb.Enabled = espInventoryEnabled and (#tools > 0)
    
    for _, tool in ipairs(tools) do
        local name = getRealName(tool)
        if name then
            local lbl = Instance.new("TextLabel", container)
            lbl.Size = UDim2.new(0, 180, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextSize = 11
            lbl.TextStrokeTransparency = 0.4
            
            local rarity = tool:GetAttribute("RarityName") or tool:GetAttribute("Rarity")
            lbl.TextColor3 = RARITY_COLORS[rarity] or Color3.new(1, 1, 1)
        end
    end
end

local function createESP(p)
    if p == LocalPlayer then return end
    
    local function setup(char)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        if not root then return end
        
        if BillboardCache[p] then BillboardCache[p]:Destroy() end
        
        local bb = Instance.new("BillboardGui", root)
        bb.Name = "FixedUnderfootESP"
        bb.Size = UDim2.new(0, 200, 0, 150)
        bb.StudsOffset = Vector3.new(0, -3.5, 0) 
        bb.AlwaysOnTop = true
        bb.MaxDistance = MAX_DISTANCE
        
        local cont = Instance.new("Frame", bb)
        cont.Name = "EspContainer"
        cont.Size = UDim2.new(1, 0, 1, 0)
        cont.BackgroundTransparency = 1
        
        BillboardCache[p] = bb

        updateESP(p)
        
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then task.wait(0.1); updateESP(p) end
        end)
        char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then task.wait(0.1); updateESP(p) end
        end)
        
        local backpack = p:WaitForChild("Backpack", 5)
        if backpack then
            backpack.ChildAdded:Connect(function() updateESP(p) end)
            backpack.ChildRemoved:Connect(function() updateESP(p) end)
        end

        task.spawn(function()
            while char.Parent and bb.Parent do
                updateESP(p)
                task.wait(UPDATE_INTERVAL)
            end
        end)
    end
    
    p.CharacterAdded:Connect(setup)
    if p.Character then setup(p.Character) end
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteTeam_HUB"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local LangFrame = Instance.new("Frame", ScreenGui)
LangFrame.Size = UDim2.new(0, 320, 0, 180)
LangFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
LangFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LangFrame.BorderSizePixel = 0
LangFrame.Active = true
LangFrame.ZIndex = 100
Instance.new("UICorner", LangFrame).CornerRadius = UDim.new(0, 10)

local LangTitle = Instance.new("TextLabel", LangFrame)
LangTitle.Size = UDim2.new(1, 0, 0, 40)
LangTitle.Position = UDim2.new(0, 0, 0, 10)
LangTitle.BackgroundTransparency = 1
LangTitle.Text = "Select Language / اختر اللغة"
LangTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LangTitle.TextScaled = true
LangTitle.Font = Enum.Font.SourceSansBold
LangTitle.ZIndex = 101

local BtnArabic = Instance.new("TextButton", LangFrame)
BtnArabic.Size = UDim2.new(0.8, 0, 0, 40)
BtnArabic.Position = UDim2.new(0.1, 0, 0.38, 0)
BtnArabic.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
BtnArabic.Text = "العربية (Arabic)"
BtnArabic.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnArabic.TextScaled = true
BtnArabic.Font = Enum.Font.SourceSansBold
BtnArabic.ZIndex = 101
Instance.new("UICorner", BtnArabic).CornerRadius = UDim.new(0, 6)

local BtnSpanish = Instance.new("TextButton", LangFrame)
BtnSpanish.Size = UDim2.new(0.8, 0, 0, 40)
BtnSpanish.Position = UDim2.new(0.1, 0, 0.68, 0)
BtnSpanish.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnSpanish.Text = "Español (Spanish)"
BtnSpanish.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSpanish.TextScaled = true
BtnSpanish.Font = Enum.Font.SourceSansBold
BtnSpanish.ZIndex = 101
Instance.new("UICorner", BtnSpanish).CornerRadius = UDim.new(0, 6)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0.4, 0, 0.65, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.18, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(0.8,0,0.08,0)
TitleLabel.Position = UDim2.new(0.1,0,0.02,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔥 Elite Team | #ابوسيف العنزي 🔥"
TitleLabel.TextColor3 = Color3.fromRGB(0,255,0)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold

local MainDrag = Instance.new("Frame", MainFrame)
MainDrag.Size = UDim2.new(1,0,0.1,0)
MainDrag.BackgroundTransparency = 1
MainDrag.Active = false

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0,100,0,40)
ToggleButton.Position = UDim2.new(0.85,0,0.05,0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
ToggleButton.Text = "فتح"
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.TextScaled = true
ToggleButton.Active = true
ToggleButton.ZIndex = 100
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,8)
ToggleButton.Visible = false

local ESPInventoryToggle = Instance.new("TextButton", MainFrame)
ESPInventoryToggle.Size = UDim2.new(0.8,0,0.12,0)
ESPInventoryToggle.Position = UDim2.new(0.1,0,0.12,0)
ESPInventoryToggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
ESPInventoryToggle.Text = "كاشف الحقيبة: مفعّل"
ESPInventoryToggle.TextScaled = true
Instance.new("UICorner", ESPInventoryToggle).CornerRadius = UDim.new(0,8)

local ESPToggle = Instance.new("TextButton", MainFrame)
ESPToggle.Size = UDim2.new(0.8,0,0.12,0)
ESPToggle.Position = UDim2.new(0.1,0,0.26,0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
ESPToggle.Text = "كاشف اللاعبين (ESP): معطّل"
ESPToggle.TextScaled = true
Instance.new("UICorner", ESPToggle).CornerRadius = UDim.new(0,8)

local AimbotToggle = Instance.new("TextButton", MainFrame)
AimbotToggle.Size = UDim2.new(0.8,0,0.12,0)
AimbotToggle.Position = UDim2.new(0.1,0,0.40,0)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
AimbotToggle.Text = "التصويب التلقائي (Aimbot): معطّل"
AimbotToggle.TextScaled = true
Instance.new("UICorner", AimbotToggle).CornerRadius = UDim.new(0,8)

local WallcheckToggle = Instance.new("TextButton", MainFrame)
WallcheckToggle.Size = UDim2.new(0.8,0,0.12,0)
WallcheckToggle.Position = UDim2.new(0.1,0,0.54,0)
WallcheckToggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
WallcheckToggle.Text = "فحص الجدران: مفعّل"
WallcheckToggle.TextScaled = true
WallcheckToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", WallcheckToggle).CornerRadius = UDim.new(0,8)

local FOVSlider = Instance.new("TextBox", MainFrame)
FOVSlider.Size = UDim2.new(0.8,0,0.12,0)
FOVSlider.Position = UDim2.new(0.1,0,0.68,0)
FOVSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
FOVSlider.Text = "نطاق الرؤية (FOV): 110"
FOVSlider.TextColor3 = Color3.fromRGB(255,0,0)
FOVSlider.TextScaled = true
Instance.new("UICorner", FOVSlider).CornerRadius = UDim.new(0,8)

local AimPartToggle = Instance.new("TextButton", MainFrame)
AimPartToggle.Size = UDim2.new(0.8,0,0.12,0)
AimPartToggle.Position = UDim2.new(0.1,0,0.82,0)
AimPartToggle.BackgroundColor3 = Color3.fromRGB(100,100,255)
AimPartToggle.Text = "الهدف: الرأس (ثابت)"
AimPartToggle.TextScaled = true
AimPartToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AimPartToggle).CornerRadius = UDim.new(0,8)

local FOVCircleToggle = Instance.new("TextButton", MainFrame)
FOVCircleToggle.Size = UDim2.new(0.8,0,0.12,0)
FOVCircleToggle.Position = UDim2.new(0.1,0,0.82+0.14,0)
FOVCircleToggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
FOVCircleToggle.Text = "دائرة FOV: مفعّلة"
FOVCircleToggle.TextScaled = true
FOVCircleToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FOVCircleToggle).CornerRadius = UDim.new(0,8)

local PlayerListFrame = Instance.new("ScrollingFrame", MainFrame)
PlayerListFrame.Size = UDim2.new(0.8,0,0.25,0)
PlayerListFrame.Position = UDim2.new(0.1,0,0.96,0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0,8)

local PlayerListLayout = Instance.new("UIListLayout", PlayerListFrame)
PlayerListLayout.Padding = UDim.new(0,4)

local espEnabledStatus = false
local AimbotOn = false
local FOVRadius = 110
local WallCheckEnabled = true
local FOVCircleVisible = true
local FOVCircleForcedOff = false
local ProtectedPlayers = {}
local PlayerButtons = {}
local AIM_SMOOTHNESS = 0.8
local PREDICTION_TIME = 0.03
local guiOpen = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = FOVRadius
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255,0,0)
FOVCircle.Transparency = 0.6
FOVCircle.Filled = false
FOVCircle.Visible = false

local AIM_MODES = {
    {part = "Head",                        color = Color3.fromRGB(100,100,255)},
    {part = "HumanoidRootPart",            color = Color3.fromRGB(255,150,50)},
    {part = "RightUpperArm",               color = Color3.fromRGB(50,205,50)},
    {part = "LeftUpperArm",                color = Color3.fromRGB(50,255,150)},
    {parts = {"Head", "HumanoidRootPart"}, color = Color3.fromRGB(180,100,255)},
    {parts = {"RightUpperArm", "LeftUpperArm"}, color = Color3.fromRGB(255, 255, 0)} 
}

local currentModeIndex = 1
local currentAutoIndex = 1
local lastSwitchTime = 0
local SWITCH_INTERVAL = 0.7

local function UpdateLanguageTexts()
    local tLang = TRANSLATIONS[currentLang]
    
    ToggleButton.Text = guiOpen and tLang.toggleClose or tLang.toggleOpen
    ESPInventoryToggle.Text = espInventoryEnabled and tLang.espInvOn or tLang.espInvOff
    ESPToggle.Text = espEnabledStatus and tLang.espPlrOn or tLang.espPlrOff
    AimbotToggle.Text = AimbotOn and tLang.aimOn or tLang.aimOff
    WallcheckToggle.Text = WallCheckEnabled and tLang.wallOn or tLang.wallOff
    FOVSlider.Text = string.format(tLang.fovText, FOVRadius)
    AimPartToggle.Text = tLang.aimModes[currentModeIndex]
    
    if FOVCircleForcedOff then
        FOVCircleToggle.Text = tLang.fovKOff
    else
        FOVCircleToggle.Text = FOVCircleVisible and tLang.fovCircleOn or tLang.fovCircleOff
    end
end

local function UpdateProtectedList()
    local tLang = TRANSLATIONS[currentLang]
    for _, b in PlayerButtons do b:Destroy() end
    PlayerButtons = {}
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton", PlayerListFrame)
            btn.Size = UDim2.new(1,-10,0,30)
            local prot = ProtectedPlayers[p] or false
            btn.BackgroundColor3 = prot and Color3.fromRGB(0,100,255) or Color3.fromRGB(60,60,60)
            btn.Text = p.DisplayName .. " (@" .. p.Name .. ")" .. (prot and " ✔" or "")
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            table.insert(PlayerButtons, btn)

            btn.MouseButton1Click:Connect(function()
                ProtectedPlayers[p] = not ProtectedPlayers[p]
                UpdateProtectedList()
            end)
        end
    end
    local count = 0 
    for _ in pairs(ProtectedPlayers) do count = count + 1 end
    TitleLabel.Text = string.format(tLang.protectedTitle, count)
end

local function setLanguage(lang)
    currentLang = lang
    LangFrame.Visible = false
    ToggleButton.Visible = true
    UpdateLanguageTexts()
    UpdateProtectedList()
end

BtnArabic.MouseButton1Click:Connect(function() setLanguage("AR") end)
BtnSpanish.MouseButton1Click:Connect(function() setLanguage("ES") end)

local function IsAlive(char)
    local h = char and char:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function IsVisible(part)
    if not part then return false end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character or workspace, part.Parent}
    local result = workspace:Raycast(origin, direction, params)
    return not result
end

local function removeESP(char)
    if char then
        local head = char:FindFirstChild("Head")
        if head then 
            local b = head:FindFirstChild("AnouarNameHP") 
            if b then b:Destroy() end 
        end
        local h = char:FindFirstChild("AnouarHighlight") 
        if h then h:Destroy() end
    end
end

local function applyESP(char)
    local plr = Players:GetPlayerFromCharacter(char)
    if not plr or plr == LocalPlayer then return end
    removeESP(char)

    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum or not IsAlive(char) then return end

    local bill = Instance.new("BillboardGui", head)
    bill.Name = "AnouarNameHP"
    bill.Adornee = head
    bill.Size = UDim2.new(0,160,0,35)
    bill.StudsOffset = Vector3.new(0,2.8,0)
    bill.AlwaysOnTop = true

    local name = Instance.new("TextLabel", bill)
    name.Size = UDim2.new(1,0,0,16)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName ~= plr.Name and (plr.DisplayName .. " (@" .. plr.Name .. ")") or plr.Name
    name.TextColor3 = Color3.new(1,1,1)
    name.TextStrokeTransparency = 0
    name.Font = Enum.Font.SourceSansBold
    name.TextSize = 14

    local hpBg = Instance.new("Frame", bill)
    hpBg.Size = UDim2.new(1,-6,0,5)
    hpBg.Position = UDim2.new(0,3,0,16)
    hpBg.BackgroundColor3 = Color3.new(0,0,0)
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,3)

    local hpFill = Instance.new("Frame", hpBg)
    hpFill.Size = UDim2.new(1,0,1,0)
    hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0,3)

    local hpText = Instance.new("TextLabel", hpBg)
    hpText.Size = UDim2.new(1,0,1,0)
    hpText.BackgroundTransparency = 1
    hpText.TextColor3 = Color3.new(1,1,1)
    hpText.TextStrokeTransparency = 0
    hpText.TextSize = 8

    local function updateHP()
        if hum.Parent and IsAlive(char) then
            local r = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            hpFill.Size = UDim2.new(r, 0, 1, 0)
            hpText.Text = math.floor(hum.Health) .. "/" .. hum.MaxHealth
        else
            removeESP(char)
        end
    end

    hum.HealthChanged:Connect(updateHP)
    hum.Died:Connect(function() removeESP(char) end)
    updateHP()

    local hl = Instance.new("Highlight", char)
    hl.Name = "AnouarHighlight"
    hl.OutlineColor = Color3.fromRGB(255,255,0)
    hl.OutlineTransparency = 0
    hl.FillTransparency = 1
end

local function onCharAdded(char)
    local plr = Players:GetPlayerFromCharacter(char)
    if not plr or plr == LocalPlayer then return end
    task.delay(0.6, function()
        removeESP(char)
        if espEnabledStatus then applyESP(char) end
    end)
end

for _, p in Players:GetPlayers() do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(onCharAdded)
        if p.Character then onCharAdded(p.Character) end
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(onCharAdded)
        if p.Character then onCharAdded(p.Character) end
    end
end)

RunService.Heartbeat:Connect(function()
    if espEnabledStatus then
        for _, p in Players:GetPlayers() do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                if head and not head:FindFirstChild("AnouarNameHP") then
                    applyESP(p.Character)
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(UpdateProtectedList)
Players.PlayerRemoving:Connect(UpdateProtectedList)
UpdateProtectedList()

local function GetTargetPart(char)
    local mode = AIM_MODES[currentModeIndex]
    local partName
    if mode.parts then
        partName = mode.parts[currentAutoIndex]
    else
        partName = mode.part
    end
    local part = char:FindFirstChild(partName)
    if not part then
        if partName == "RightUpperArm" then part = char:FindFirstChild("Right Arm") end
        if partName == "LeftUpperArm"   then part = char:FindFirstChild("Left Arm") end
    end
    return part or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function GetPredictedPosition(char)
    local part = GetTargetPart(char)
    if not part then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return part.Position end
    local velocity = root.Velocity
    return part.Position + (velocity * PREDICTION_TIME)
end

local function GetClosest()
    local closest, distMin = nil, math.huge
    local center = Camera.ViewportSize / 2
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer and not ProtectedPlayers[p] and p.Character and IsAlive(p.Character) then
            local part = GetTargetPart(p.Character)
            if part then
                local predictedPos = GetPredictedPosition(p.Character) or part.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < distMin and dist <= FOVRadius then
                        if not WallCheckEnabled or IsVisible(part) then
                            distMin = dist
                            closest = p
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = FOVRadius
    FOVCircle.Visible = AimbotOn and FOVCircleVisible and not FOVCircleForcedOff
    
    if AimbotOn then
        local target = GetClosest()
        if target and target.Character then
            local predictedPos = GetPredictedPosition(target.Character)
            if predictedPos then
                local cf = CFrame.new(Camera.CFrame.Position, predictedPos)
                Camera.CFrame = Camera.CFrame:Lerp(cf, AIM_SMOOTHNESS)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not AimbotOn then return end
    local mode = AIM_MODES[currentModeIndex]
    if not mode.parts then return end
    lastSwitchTime = lastSwitchTime + dt
    if lastSwitchTime >= SWITCH_INTERVAL then
        lastSwitchTime = 0
        currentAutoIndex = currentAutoIndex % #mode.parts + 1
    end
end)

ESPToggle.MouseButton1Click:Connect(function()
    espEnabledStatus = not espEnabledStatus
    ESPToggle.BackgroundColor3 = espEnabledStatus and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    UpdateLanguageTexts()
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer and p.Character then
            if espEnabledStatus then 
                applyESP(p.Character) 
            else 
                removeESP(p.Character) 
            end
        end
    end
end)

AimbotToggle.MouseButton1Click:Connect(function()
    AimbotOn = not AimbotOn
    AimbotToggle.BackgroundColor3 = AimbotOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    UpdateLanguageTexts()
end)

AimPartToggle.MouseButton1Click:Connect(function()
    currentModeIndex = currentModeIndex % #AIM_MODES + 1
    local mode = AIM_MODES[currentModeIndex]
    AimPartToggle.BackgroundColor3 = mode.color
    UpdateLanguageTexts()
end)

WallcheckToggle.MouseButton1Click:Connect(function()
    WallCheckEnabled = not WallCheckEnabled
    WallcheckToggle.BackgroundColor3 = WallCheckEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,100,100)
    UpdateLanguageTexts()
end)

FOVSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(FOVSlider.Text:match("%d+"))
        if num and num >= 20 and num <= 600 then
            FOVRadius = num
            FOVCircle.Radius = num
        end
        UpdateLanguageTexts()
    end
end)

FOVCircleToggle.MouseButton1Click:Connect(function()
    FOVCircleVisible = not FOVCircleVisible
    FOVCircleToggle.BackgroundColor3 = FOVCircleVisible and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    UpdateLanguageTexts()
end)

ESPInventoryToggle.MouseButton1Click:Connect(function()
    espInventoryEnabled = not espInventoryEnabled
    ESPInventoryToggle.BackgroundColor3 = espInventoryEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    UpdateLanguageTexts()
    for _, p in ipairs(Players:GetPlayers()) do
        updateESP(p)
    end
end)

local function makeDraggable(frame, dragArea)
    local dragging, startPos, startMouse
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            startMouse = input.Position
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startMouse
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(MainFrame, MainDrag)

local function toggleUI()
    MainFrame.Visible = not MainFrame.Visible
    guiOpen = MainFrame.Visible
    UpdateLanguageTexts()
    if guiOpen then UpdateProtectedList() end
end

ToggleButton.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleUI()
    end
    
    if input.KeyCode == Enum.KeyCode.K then
        FOVCircleForcedOff = not FOVCircleForcedOff
        
        if FOVCircleToggle then
            if FOVCircleForcedOff then
                FOVCircleToggle.BackgroundColor3 = Color3.fromRGB(150,150,150)
            else
                FOVCircleToggle.BackgroundColor3 = FOVCircleVisible and Color3.fromRGB(0,255,0) or Color3.fromRGB(245,0,0)
            end
            UpdateLanguageTexts()
        end
    end
end)
