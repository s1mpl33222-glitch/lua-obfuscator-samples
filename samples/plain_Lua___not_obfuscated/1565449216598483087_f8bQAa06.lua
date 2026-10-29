-- ============================================================
-- VANTA V1.4 | FIXED ESP & DISCORD
-- Credits: SumoXez (Discord: sumox_ez)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- LIMPEZA INICIAL
pcall(function()
    for _, v in pairs(CoreGui:GetChildren()) do
        if string.find(v.Name, "Vanta") or string.find(v.Name, "Spectre") then v:Destroy() end
    end
    if _G.EyeFOV then _G.EyeFOV:Remove() _G.EyeFOV = nil end
    if _G.EyeCrosshair then for _, v in pairs(_G.EyeCrosshair) do v:Remove() end _G.EyeCrosshair = nil end
    if _G.EyeDot then _G.EyeDot:Remove() _G.EyeDot = nil end
end)

local Config = {
    -- Combat
    Aimbot = true, TriggerBot = false, FOV = 150, AimbotPower = 10, TargetPart = "Head",
    AimbotDistance = 500, Prediction = false, PredictionAmount = 0.15,
    
    -- Visuals
    ESP = true, ESPName = true, ESPHealth = true, ESPDistance = true, ESPBox = true,
    ESPSkeleton = false, -- Desligado (mais leve)
    ESPColor = Color3.fromRGB(0, 255, 100),
    
    -- Camera / FOV
    CameraFOV = 70, CustomCamFOV = false,
    
    -- Premium Features
    AutoClicker = false, Fullbright = false, CameraZoom = false, HitboxExpander = false,
    
    -- Settings
    FPSBoost = false, MatrixBg = true,
    StreamerMode = false, MenuKey = Enum.KeyCode.RightShift
}

local C_Bg = Color3.fromRGB(8, 8, 8)
local C_Card = Color3.fromRGB(15, 18, 15)
local C_Accent = Color3.fromRGB(0, 255, 80)
local C_Text = Color3.fromRGB(220, 255, 220)
local C_Muted = Color3.fromRGB(80, 120, 80)
local C_Gold = Color3.fromRGB(255, 215, 0)

local function PlayClick() 
    local s = Instance.new("Sound", game:GetService("SoundService"))
    s.SoundId = "rbxassetid://6895079853"; s.Volume = 0.2; s:Play()
    game:GetService("Debris"):AddItem(s, 1)
end

-- ============================================================
-- TELA DE CARREGAMENTO
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "VantaLoading"; LoadingGui.ResetOnSpawn = false; LoadingGui.IgnoreGuiInset = true; LoadingGui.DisplayOrder = 10000; LoadingGui.Parent = CoreGui

local LoadBg = Instance.new("Frame", LoadingGui)
LoadBg.Size = UDim2.new(1, 0, 1, 0); LoadBg.BackgroundColor3 = C_Bg; LoadBg.BorderSizePixel = 0

local LoadTitle = Instance.new("TextLabel", LoadBg)
LoadTitle.Size = UDim2.new(0, 400, 0, 50); LoadTitle.Position = UDim2.new(0.5, -200, 0.4, -50); LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "VANTA"; LoadTitle.TextColor3 = C_Accent; LoadTitle.Font = Enum.Font.Code; LoadTitle.TextSize = 40

local LoadBarBg = Instance.new("Frame", LoadBg)
LoadBarBg.Size = UDim2.new(0, 300, 0, 6); LoadBarBg.Position = UDim2.new(0.5, -150, 0.5, 20); LoadBarBg.BackgroundColor3 = C_Card; LoadBarBg.BorderSizePixel = 0
Instance.new("UICorner", LoadBarBg).CornerRadius = UDim.new(1, 0)

local LoadBarFill = Instance.new("Frame", LoadBarBg)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0); LoadBarFill.BackgroundColor3 = C_Accent; LoadBarFill.BorderSizePixel = 0
Instance.new("UICorner", LoadBarFill).CornerRadius = UDim.new(1, 0)

TweenService:Create(LoadBarFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()

-- NOTIFICAÇÃO
local NotifGui = Instance.new("ScreenGui", CoreGui)
NotifGui.Name = "Vanta_Notif"; NotifGui.ResetOnSpawn = false
local NotifFrame = Instance.new("Frame", NotifGui)
NotifFrame.Size = UDim2.new(0, 250, 1, 0); NotifFrame.Position = UDim2.new(1, -270, 0, 20)
NotifFrame.BackgroundTransparency = 1
local NLayout = Instance.new("UIListLayout", NotifFrame)
NLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function Notify(title, text, color)
    local box = Instance.new("Frame", NotifFrame)
    box.Size = UDim2.new(1, 0, 0, 50); box.BackgroundColor3 = C_Card; box.BackgroundTransparency = 0.1
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", box).Color = color or C_Accent
    local t1 = Instance.new("TextLabel", box)
    t1.Size = UDim2.new(1, -20, 0, 20); t1.Position = UDim2.new(0, 10, 0, 5)
    t1.BackgroundTransparency = 1; t1.Text = title; t1.TextColor3 = color or C_Accent; t1.Font = Enum.Font.Code; t1.TextSize = 12; t1.TextXAlignment = Enum.TextXAlignment.Left
    local t2 = Instance.new("TextLabel", box)
    t2.Size = UDim2.new(1, -20, 0, 20); t2.Position = UDim2.new(0, 10, 0, 25)
    t2.BackgroundTransparency = 1; t2.Text = text; t2.TextColor3 = C_Text; t2.Font = Enum.Font.Code; t2.TextSize = 11; t2.TextXAlignment = Enum.TextXAlignment.Left
    box.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(box, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(3, function()
        TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.3); box:Destroy()
    end)
end

-- ============================================================
-- UI PRINCIPAL
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaUI"; ScreenGui.ResetOnSpawn = false; ScreenGui.IgnoreGuiInset = true; ScreenGui.DisplayOrder = 9999; ScreenGui.Parent = CoreGui
ScreenGui.Enabled = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 460); Main.Position = UDim2.new(0.5, -300, 0.5, -230)
Main.BackgroundColor3 = C_Bg; Main.Active = true; Main.Draggable = true; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = C_Accent

local MatrixBg = Instance.new("Frame", Main)
MatrixBg.Size = UDim2.new(1, 0, 1, 0); MatrixBg.BackgroundTransparency = 1; MatrixBg.ZIndex = 0

task.spawn(function()
    local chars = {"0","1","X","Y","Z","a","b","c","d","e","f","#","%","@","$"}
    while Main.Parent do
        if Config.MatrixBg then
            local col = Instance.new("TextLabel", MatrixBg)
            col.Size = UDim2.new(0, 15, 0, 20); col.Position = UDim2.new(math.random(), 0, -0.1, 0)
            col.BackgroundTransparency = 1; col.Text = chars[math.random(1, #chars)]
            col.TextColor3 = Color3.fromRGB(0, math.random(50, 120), 0); col.Font = Enum.Font.Code; col.TextSize = math.random(12, 16); col.ZIndex = 1
            local dur = math.random(3, 6)
            TweenService:Create(col, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Position = UDim2.new(col.Position.X.Scale, 0, 1.1, 0)}):Play()
            task.delay(dur, function() col:Destroy() end)
        end
        task.wait(0.3)
    end
end)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundColor3 = C_Card; Header.ZIndex = 2
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "VANTA [v1.4]"; Title.TextColor3 = C_Accent; Title.Font = Enum.Font.Code; Title.TextSize = 18; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.Code; CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -45); Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = C_Card; Sidebar.BackgroundTransparency = 0.3; Sidebar.ZIndex = 2

local Pages = {}
local Tabs = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Size = UDim2.new(1, -130, 1, -55); Page.Position = UDim2.new(0, 125, 0, 50)
    Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = C_Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y; Page.ZIndex = 2; Page.Visible = false
    local layout = Instance.new("UIListLayout", Page); layout.Padding = UDim.new(0, 8)
    Pages[name] = Page
end

local function CreateTab(text, pageName, yPos)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Position = UDim2.new(0, 5, 0, 5 + yPos)
    Btn.BackgroundColor3 = C_Card; Btn.BackgroundTransparency = 1; Btn.Text = string.upper(text); Btn.TextColor3 = C_Muted; Btn.Font = Enum.Font.Code; Btn.TextSize = 12; Btn.ZIndex = 3
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    local Ind = Instance.new("Frame", Btn)
    Ind.Size = UDim2.new(0, 3, 0.6, 0); Ind.Position = UDim2.new(0, 0, 0.2, 0); Ind.BackgroundColor3 = C_Accent; Ind.Visible = false; Ind.ZIndex = 4
    Btn.MouseButton1Click:Connect(function()
        PlayClick()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do t.Btn.TextColor3 = C_Muted; t.Btn.BackgroundTransparency = 1; t.Ind.Visible = false end
        Pages[pageName].Visible = true; Btn.TextColor3 = C_Text; Btn.BackgroundTransparency = 0.5; Ind.Visible = true
    end)
    table.insert(Tabs, {Btn = Btn, Ind = Ind})
end

CreatePage("Combat"); CreatePage("Visuals"); CreatePage("Custom"); CreatePage("Premium"); CreatePage("Settings"); CreatePage("Credits")
CreateTab("Combat", "Combat", 0); CreateTab("Visuals", "Visuals", 40); CreateTab("Custom", "Custom", 80); CreateTab("Premium", "Premium", 120); CreateTab("Settings", "Settings", 160); CreateTab("Credits", "Credits", 200)
Pages["Combat"].Visible = true; Tabs[1].Btn.TextColor3 = C_Text; Tabs[1].Btn.BackgroundTransparency = 0.5; Tabs[1].Ind.Visible = true

-- COMPONENTES
local function CreateSection(parent, text)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.BackgroundTransparency = 1; Lbl.Text = "> " .. string.upper(text) .. " <"
    Lbl.TextColor3 = C_Muted; Lbl.Font = Enum.Font.Code; Lbl.TextSize = 10; Lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(parent, text, default, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35); Btn.BackgroundColor3 = default and C_Accent or C_Card; Btn.BackgroundTransparency = default and 0 or 0.3
    Btn.Text = "  " .. text .. (default and "   [ ON ]" or "   [ OFF ]"); Btn.TextColor3 = default and C_Bg or C_Text
    Btn.Font = Enum.Font.Code; Btn.TextSize = 12; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", Btn); stroke.Color = default and C_Accent or C_Muted; stroke.Transparency = default and 0 or 0.7
    local state = default
    Btn.MouseButton1Click:Connect(function()
        PlayClick(); state = not state
        Btn.Text = "  " .. text .. (state and "   [ ON ]" or "   [ OFF ]")
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and C_Accent or C_Card, BackgroundTransparency = state and 0 or 0.3, TextColor3 = state and C_Bg or C_Text}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = state and C_Accent or C_Muted, Transparency = state and 0 or 0.7}):Play()
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 45); Frame.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 0, 15); Lbl.BackgroundTransparency = 1; Lbl.Text = string.upper(text); Lbl.TextColor3 = C_Text; Lbl.Font = Enum.Font.Code; Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local ValLbl = Instance.new("TextLabel", Frame)
    ValLbl.Size = UDim2.new(0.3, 0, 0, 15); ValLbl.Position = UDim2.new(0.7, 0, 0, 0); ValLbl.BackgroundTransparency = 1; ValLbl.Text = tostring(default); ValLbl.TextColor3 = C_Accent; ValLbl.Font = Enum.Font.Code; ValLbl.TextSize = 11; ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 4); Bar.Position = UDim2.new(0, 0, 0, 25); Bar.BackgroundColor3 = C_Card
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = C_Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    local Dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * pos) * 100) / 100
        Fill.Size = UDim2.new(pos, 0, 1, 0); ValLbl.Text = tostring(val); callback(val)
    end
    Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; Main.Draggable = false; Update(input) end end)
    Bar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35); Btn.BackgroundColor3 = C_Card; Btn.Text = text; Btn.TextColor3 = C_Text; Btn.Font = Enum.Font.Code; Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    Btn.MouseButton1Click:Connect(function() PlayClick(); callback() end)
    return Btn
end

local function CreateTextBox(parent, placeholder)
    local Tb = Instance.new("TextBox", parent)
    Tb.Size = UDim2.new(1, -10, 0, 35); Tb.BackgroundColor3 = C_Card; Tb.PlaceholderText = placeholder
    Tb.Text = ""; Tb.TextColor3 = C_Text; Tb.PlaceholderColor3 = C_Muted; Tb.Font = Enum.Font.Code; Tb.TextSize = 12
    Instance.new("UICorner", Tb).CornerRadius = UDim.new(0, 4)
    return Tb
end

-- CONFIGURAÇÃO DAS ABAS
CreateSection(Pages["Combat"], "Aimbot Settings")
CreateToggle(Pages["Combat"], "Aimbot (Right Click)", Config.Aimbot, function(v) Config.Aimbot = v end)
CreateToggle(Pages["Combat"], "Trigger Bot", Config.TriggerBot, function(v) Config.TriggerBot = v end)
CreateButton(Pages["Combat"], "Target Part: " .. Config.TargetPart, function()
    if Config.TargetPart == "Head" then Config.TargetPart = "UpperTorso" else Config.TargetPart = "Head" end
    Notify("COMBAT", "Target set to " .. Config.TargetPart, C_Accent)
end)
CreateSlider(Pages["Combat"], "FOV Radius", 50, 500, Config.FOV, function(v) Config.FOV = v end)
CreateSlider(Pages["Combat"], "Max Distance", 50, 2000, Config.AimbotDistance, function(v) Config.AimbotDistance = v end)
CreateSlider(Pages["Combat"], "Aimbot Power", 1, 20, Config.AimbotPower, function(v) Config.AimbotPower = v end)
CreateToggle(Pages["Combat"], "Prediction (Lead Shot)", Config.Prediction, function(v) Config.Prediction = v end)

CreateSection(Pages["Visuals"], "ESP Settings")
CreateToggle(Pages["Visuals"], "Enable ESP", Config.ESP, function(v) Config.ESP = v end)
CreateToggle(Pages["Visuals"], "Draw Box", Config.ESPBox, function(v) Config.ESPBox = v end)
CreateToggle(Pages["Visuals"], "Show Name", Config.ESPName, function(v) Config.ESPName = v end)
CreateToggle(Pages["Visuals"], "Show Health", Config.ESPHealth, function(v) Config.ESPHealth = v end)
CreateToggle(Pages["Visuals"], "Show Distance", Config.ESPDistance, function(v) Config.ESPDistance = v end)
CreateToggle(Pages["Visuals"], "Draw Skeleton (Heavy/Lag)", Config.ESPSkeleton, function(v) Config.ESPSkeleton = v end)

CreateSection(Pages["Visuals"], "ESP Color (RGB)")
local er, eg, eb = 0, 255, 100
CreateSlider(Pages["Visuals"], "Red", 0, 255, 0, function(v) er = v; Config.ESPColor = Color3.fromRGB(er, eg, eb) end)
CreateSlider(Pages["Visuals"], "Green", 0, 255, 255, function(v) eg = v; Config.ESPColor = Color3.fromRGB(er, eg, eb) end)
CreateSlider(Pages["Visuals"], "Blue", 0, 255, 100, function(v) eb = v; Config.ESPColor = Color3.fromRGB(er, eg, eb) end)

CreateSection(Pages["Custom"], "FOV Settings")
CreateToggle(Pages["Custom"], "Enable Custom Camera FOV", Config.CustomCamFOV, function(v) Config.CustomCamFOV = v end)
CreateSlider(Pages["Custom"], "Camera FOV Value", 50, 120, Config.CameraFOV, function(v) Config.CameraFOV = v end)

CreateSection(Pages["Premium"], "Premium Access")
local PassBox = CreateTextBox(Pages["Premium"], "Digite a senha...")
local UnlockedLabel = Instance.new("TextLabel", Pages["Premium"])
UnlockedLabel.Size = UDim2.new(1, -10, 0, 20); UnlockedLabel.BackgroundTransparency = 1; UnlockedLabel.Text = ""; UnlockedLabel.TextColor3 = C_Gold; UnlockedLabel.Font = Enum.Font.Code; UnlockedLabel.TextSize = 12

CreateButton(Pages["Premium"], "Desbloquear Premium", function()
    local pass = string.lower(PassBox.Text)
    if pass == "premiumadd" then
        PlayClick()
        PassBox:Destroy()
        UnlockedLabel.Text = "ACESSO VIP CONCEDIDO!"
        Notify("PREMIUM", "Acesso VIP desbloqueado!", C_Gold)
        
        CreateToggle(Pages["Premium"], "Auto Clicker (Fast Fire)", false, function(v) Config.AutoClicker = v end)
        CreateToggle(Pages["Premium"], "Fullbright (Noite Clara)", false, function(v) 
            Config.Fullbright = v
            if v then
                Lighting.Brightness = 3; Lighting.ClockTime = 12; Lighting.FogEnd = 1e6
                Lighting.Ambient = Color3.fromRGB(180, 180, 180); Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            else
                Lighting.Brightness = 1; Lighting.Ambient = Color3.fromRGB(70, 70, 70); Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end)
        CreateToggle(Pages["Premium"], "Camera Zoom (+30 FOV)", false, function(v) Config.CameraZoom = v end)
        CreateToggle(Pages["Premium"], "Hitbox Expander (Local)", false, function(v) Config.HitboxExpander = v end)
    else
        PlayClick()
        Notify("PREMIUM", "Senha Incorreta!", Color3.fromRGB(255, 50, 50))
    end
end)

CreateSection(Pages["Settings"], "Optimization & Performance")
CreateToggle(Pages["Settings"], "FPS Boost (Remove Textures)", Config.FPSBoost, function(v)
    Config.FPSBoost = v
    if v then
        Lighting.GlobalShadows = false; Lighting.FogEnd = 1e6
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then obj.Enabled = false end
        end
    else
        Lighting.GlobalShadows = true
        pcall(function() settings().Rendering.QualityLevel = 21 end)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then obj.Enabled = true end
        end
    end
end)
CreateToggle(Pages["Settings"], "Matrix Background (UI)", Config.MatrixBg, function(v) Config.MatrixBg = v end)

CreateSection(Pages["Credits"], "Developer")
local CreditText = Instance.new("TextLabel", Pages["Credits"])
CreditText.Size = UDim2.new(1, -10, 0, 100); CreditText.BackgroundColor3 = C_Card; CreditText.BackgroundTransparency = 0.3
CreditText.Text = "\nVANTA V1.4\nDeveloped by: SumoXez\nDiscord: sumox_ez"
CreditText.TextColor3 = C_Accent; CreditText.Font = Enum.Font.Code; CreditText.TextSize = 14; CreditText.TextWrapped = true
Instance.new("UICorner", CreditText).CornerRadius = UDim.new(0, 4)

CreateSection(Pages["Credits"], "Social")
CreateButton(Pages["Credits"], "Copiar Link do Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/3Ej4dYd8gT")
        Notify("DISCORD", "Link copiado! Cole no navegador.", C_Gold)
    else
        Notify("DISCORD", "Erro ao copiar. Link: discord.gg/3Ej4dYd8gT", Color3.fromRGB(255, 50, 50))
    end
end)

-- ============================================================
-- GAME LOGIC & DRAWING
-- ============================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.NumSides = 60; FOVCircle.Filled = false
_G.EyeFOV = FOVCircle

local espCache = {}
local R15Connections = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local function AddESP(plr)
    if plr == LP or espCache[plr] then return end
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false
    local name = Drawing.new("Text"); name.Center = true; name.Outline = true; name.Size = 12; name.Visible = false
    local hpBg = Drawing.new("Square"); hpBg.Filled = true; hpBg.Color = Color3.new(0,0,0); hpBg.Visible = false
    local hp = Drawing.new("Square"); hp.Filled = true; hp.Color = Color3.fromRGB(0,255,0); hp.Visible = false
    local lines = {}
    for i = 1, #R15Connections do
        local line = Drawing.new("Line"); line.Thickness = 1; line.Visible = false
        table.insert(lines, line)
    end
    espCache[plr] = {box = box, name = name, hpBg = hpBg, hp = hp, lines = lines}
end

local function RemoveESP(plr)
    if espCache[plr] then 
        espCache[plr].box:Remove(); espCache[plr].name:Remove(); espCache[plr].hpBg:Remove(); espCache[plr].hp:Remove()
        for _, line in ipairs(espCache[plr].lines) do line:Remove() end
        espCache[plr] = nil 
    end
end

for _, p in pairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- AUTO CLICKER
task.spawn(function()
    while task.wait(0.05) do
        if Config.AutoClicker and not Config.StreamerMode and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
            end)
        end
    end
end)

-- HITBOX EXPANDER
task.spawn(function()
    while task.wait(0.5) do
        if Config.HitboxExpander and not Config.StreamerMode then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(10, 10, 10)
                        hrp.Transparency = 0.5
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- TECLAS
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Main.Draggable = true end end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.MenuKey then Main.Visible = not Main.Visible end
    if input.KeyCode == Enum.KeyCode.Delete then
        Config.StreamerMode = not Config.StreamerMode
        if Config.StreamerMode then Main.Visible = false end
    end
end)

-- FUNÇÃO DE ALVO DO AIMBOT
local function GetTarget(cam)
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local shortest, best = math.huge, nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local part = p.Character:FindFirstChild(Config.TargetPart) or p.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and part then
                local worldDist = (cam.CFrame.Position - part.Position).Magnitude
                if worldDist <= Config.AimbotDistance then
                    local sp, on = cam:WorldToViewportPoint(part.Position)
                    if on then
                        local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                        if d <= Config.FOV and d < shortest then 
                            shortest = d
                            best = part 
                        end
                    end
                end
            end
        end
    end
    return best
end

-- LOOP PRINCIPAL (RENDER)
local lastESPUpdate = 0
RunService:BindToRenderStep("Vanta_Main", Enum.RenderPriority.Camera.Value + 1, function(dt)
    local cam = workspace.CurrentCamera
    if not cam then return end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    if Config.StreamerMode then
        FOVCircle.Visible = false
        for _, objs in pairs(espCache) do 
            objs.box.Visible = false; objs.name.Visible = false; objs.hpBg.Visible = false; objs.hp.Visible = false
            for _, line in ipairs(objs.lines) do line.Visible = false end
        end
        return
    end

    local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

    -- FOV Circle
    FOVCircle.Position = center; FOVCircle.Radius = Config.FOV
    FOVCircle.Color = Config.ESPColor
    FOVCircle.Visible = Config.Aimbot and isAiming and not Main.Visible

    -- Custom FOV
    if Config.CustomCamFOV then 
        cam.FieldOfView = Config.CameraFOV 
    elseif Config.CameraZoom then
        cam.FieldOfView = 100
    else
        cam.FieldOfView = 70 
    end

    -- ESP OTIMIZADO (30 FPS - Melhorou a suavidade)
    if tick() - lastESPUpdate > 0.033 then
        lastESPUpdate = tick()
        for plr, objs in pairs(espCache) do
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if Config.ESP and hum and hum.Health > 0 and head and root then
                local vHead, onHead = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local vRoot, onRoot = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
                
                if onHead and onRoot then
                    -- Cálculo usando a Cabeça e o Quadril (Muito mais preciso)
                    local height = math.abs(vHead.Y - vRoot.Y) * 1.1
                    local width = height * 0.45
                    local boxX = math.floor(vHead.X - width / 2)
                    local boxY = math.floor(vHead.Y)
                    local h = math.floor(height)
                    local w = math.floor(width)
                    
                    objs.box.Size = Vector2.new(w, h); objs.box.Position = Vector2.new(boxX, boxY)
                    objs.box.Color = Config.ESPColor; objs.box.Visible = Config.ESPBox

                    if Config.ESPHealth then
                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barW = 4
                        objs.hpBg.Size = Vector2.new(barW, h)
                        objs.hpBg.Position = Vector2.new(boxX - barW - 4, boxY)
                        objs.hpBg.Color = Color3.fromRGB(30, 30, 30)
                        objs.hpBg.Visible = true
                        local fillH = math.floor(h * pct)
                        if fillH < 1 and pct > 0 then fillH = 1 end
                        objs.hp.Size = Vector2.new(barW, fillH)
                        objs.hp.Position = Vector2.new(boxX - barW - 4, boxY + (h - fillH))
                        objs.hp.Color = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(50, 255, 50), pct)
                        objs.hp.Visible = true
                    else
                        objs.hpBg.Visible = false; objs.hp.Visible = false
                    end

                    if Config.ESPName then
                        local txt = plr.Name
                        if Config.ESPDistance then txt = txt .. " [" .. math.floor((cam.CFrame.Position - head.Position).Magnitude) .. "m]" end
                        objs.name.Text = txt; objs.name.Position = Vector2.new(vHead.X, boxY - 15); objs.name.Color = Config.ESPColor; objs.name.Visible = true
                    else objs.name.Visible = false end

                    if Config.ESPSkeleton then
                        for i, connection in ipairs(R15Connections) do
                            local p1 = char:FindFirstChild(connection[1])
                            local p2 = char:FindFirstChild(connection[2])
                            local line = objs.lines[i]
                            if p1 and p2 and line then
                                local v1, on1 = cam:WorldToViewportPoint(p1.Position)
                                local v2, on2 = cam:WorldToViewportPoint(p2.Position)
                                if on1 and on2 then
                                    line.From = Vector2.new(v1.X, v1.Y); line.To = Vector2.new(v2.X, v2.Y)
                                    line.Color = Config.ESPColor; line.Visible = true
                                else line.Visible = false end
                            elseif line then line.Visible = false end
                        end
                    else
                        for _, line in ipairs(objs.lines) do line.Visible = false end
                    end
                else
                    objs.box.Visible = false; objs.name.Visible = false; objs.hpBg.Visible = false; objs.hp.Visible = false
                    for _, line in ipairs(objs.lines) do line.Visible = false end
                end
            else
                objs.box.Visible = false; objs.name.Visible = false; objs.hpBg.Visible = false; objs.hp.Visible = false
                for _, line in ipairs(objs.lines) do line.Visible = false end
            end
        end
    end

    -- AIMBOT LÓGICA
    if Config.Aimbot and isAiming and not Main.Visible then
        local target = GetTarget(cam)
        if target then
            local targetPos = target.Position
            if Config.Prediction then
                local hum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
                if hum and hum.RootPart then
                    targetPos = targetPos + (hum.RootPart.AssemblyLinearVelocity * Config.PredictionAmount)
                end
            end
            
            local sp, onScreen = cam:WorldToViewportPoint(targetPos)
            if onScreen then
                local deltaX = sp.X - center.X
                local deltaY = sp.Y - center.Y
                local powerMultiplier = Config.AimbotPower / 5 
                if mousemoverel then
                    mousemoverel(deltaX * powerMultiplier, deltaY * powerMultiplier)
                end
            end
        end
    end
end)

-- FINALIZAR LOADING
task.wait(1.5)
TweenService:Create(LoadBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(LoadTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(LoadBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

task.wait(0.6)
LoadingGui:Destroy()
ScreenGui.Enabled = true
Notify("VANTA", "Sistema Carregado [v1.4]", C_Accent)